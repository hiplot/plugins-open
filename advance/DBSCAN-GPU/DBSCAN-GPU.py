#!/usr/bin/env python3
"""
GPU加速的DBSCAN密度聚类工具
支持自定义eps和min_samples参数，使用GPU加速距离计算
包含自动确定最优eps参数的功能
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_moons, make_blobs
from sklearn.neighbors import NearestNeighbors
import os
import time

try:
    import cupy as cp
    GPU_AVAILABLE = True
    print("CuPy可用，使用GPU加速")
except ImportError:
    import numpy as cp
    GPU_AVAILABLE = False
    print("CuPy不可用，使用CPU计算")

class DBSCAN_GPU:
    def __init__(self, eps=0.5, min_samples=5, metric='euclidean'):
        """
        初始化GPU DBSCAN
        
        参数:
        eps: 邻域半径
        min_samples: 核心点的最小邻域样本数
        metric: 距离度量方式
        """
        self.eps = eps
        self.min_samples = min_samples
        self.metric = metric
        self.labels_ = None
        
    def _compute_distances_gpu(self, X):
        """使用GPU计算距离矩阵（优化版，避免大矩阵）"""
        n_samples = X.shape[0]
        
        # 分批处理以避免内存溢出
        batch_size = 1000
        distances = []
        
        for i in range(0, n_samples, batch_size):
            batch_end = min(i + batch_size, n_samples)
            X_batch = X[i:batch_end]
            
            # 计算批次内距离
            if self.metric == 'euclidean':
                dist_batch = cp.linalg.norm(X_batch[:, cp.newaxis] - X, axis=2)
            elif self.metric == 'cosine':
                # 余弦距离计算
                norm_X = cp.linalg.norm(X, axis=1)
                norm_batch = cp.linalg.norm(X_batch, axis=1)
                dot_products = cp.dot(X_batch, X.T)
                dist_batch = 1 - dot_products / (norm_batch[:, cp.newaxis] * norm_X)
            
            distances.append(dist_batch)
        
        return cp.vstack(distances)
    
    def _find_neighbors(self, distances, eps):
        """找到每个点的邻域点"""
        neighbors = []
        for i in range(distances.shape[0]):
            mask = distances[i] <= eps
            neighbor_indices = cp.where(mask)[0]
            neighbors.append(neighbor_indices)
        return neighbors
    
    def fit(self, X):
        """
        训练DBSCAN模型
        
        参数:
        X: 输入数据，形状为(n_samples, n_features)
        """
        # 转换数据为CuPy数组
        if isinstance(X, np.ndarray):
            X_gpu = cp.asarray(X.astype(np.float32))
        else:
            X_gpu = X.astype(cp.float32)
        
        print("计算距离矩阵...")
        start_time = time.time()
        distances = self._compute_distances_gpu(X_gpu)
        print(f"距离矩阵计算完成，耗时: {time.time() - start_time:.2f}秒")
        
        print("寻找邻域点...")
        neighbors = self._find_neighbors(distances, self.eps)
        
        # DBSCAN核心算法
        n_samples = X_gpu.shape[0]
        labels = cp.full(n_samples, -1, dtype=cp.int32)  # -1表示未访问
        cluster_id = 0
        
        for i in range(n_samples):
            if labels[i] != -1:  # 已访问过
                continue
                
            # 获取邻域点
            neighbor_indices = neighbors[i]
            
            if len(neighbor_indices) < self.min_samples:
                # 标记为噪声点
                labels[i] = -1
            else:
                # 创建新簇
                self._expand_cluster(i, neighbor_indices, labels, cluster_id, neighbors)
                cluster_id += 1
        
        self.labels_ = cp.asnumpy(labels) if GPU_AVAILABLE else labels.get()
        self.n_clusters_ = cluster_id
        
        return self
    
    def _expand_cluster(self, point_id, neighbors, labels, cluster_id, all_neighbors):
        """扩展簇"""
        labels[point_id] = cluster_id
        queue = list(neighbors)
        
        i = 0
        while i < len(queue):
            point = queue[i]
            
            if labels[point] == -1:  # 如果是噪声点，加入当前簇
                labels[point] = cluster_id
            elif labels[point] == -1:  # 未访问
                labels[point] = cluster_id
                
                # 检查该点是否是核心点
                point_neighbors = all_neighbors[point]
                if len(point_neighbors) >= self.min_samples:
                    # 将其邻域点加入队列
                    for neighbor in point_neighbors:
                        if labels[neighbor] == -1 and neighbor not in queue:
                            queue.append(neighbor)
            
            i += 1
    
    def predict(self, X):
        """预测新数据的簇标签（简化版，实际DBSCAN通常不用于预测新数据）"""
        # DBSCAN通常不用于预测新数据，这里返回-1表示噪声点
        return np.full(X.shape[0], -1)

def find_optimal_eps(X, k=5, plot=True):
    """使用k距离图自动确定最优eps参数"""
    if isinstance(X, np.ndarray):
        X_gpu = cp.asarray(X.astype(np.float32))
    else:
        X_gpu = X.astype(cp.float32)
    
    # 计算每个点到第k个最近邻的距离
    n_samples = X_gpu.shape[0]
    k_distances = cp.zeros(n_samples)
    
    for i in range(0, n_samples, 1000):  # 分批处理
        batch_end = min(i + 1000, n_samples)
        batch = X_gpu[i:batch_end]
        
        # 计算批次内距离
        distances = cp.linalg.norm(batch[:, cp.newaxis] - X_gpu, axis=2)
        
        # 对每个点排序距离，取第k个
        sorted_distances = cp.sort(distances, axis=1)
        k_distances[i:batch_end] = sorted_distances[:, k]
    
    k_distances_sorted = cp.sort(k_distances)
    
    if plot:
        plt.figure(figsize=(10, 6))
        plt.plot(range(len(k_distances_sorted)), cp.asnumpy(k_distances_sorted))
        plt.xlabel('样本点（按距离排序）')
        plt.ylabel(f'到第{k}个最近邻的距离')
        plt.title('k距离图（用于确定eps参数）')
        plt.grid(True)
        plt.savefig('k_distance_plot.png', dpi=300, bbox_inches='tight')
        plt.show()
    
    # 返回拐点处的距离作为建议的eps
    distances_cpu = cp.asnumpy(k_distances_sorted)
    diff = np.diff(distances_cpu, 2)  # 二阶差分找拐点
    optimal_idx = np.argmax(diff) + 1 if len(diff) > 0 else len(distances_cpu) // 2
    
    return distances_cpu[optimal_idx]

def visualize_dbscan(X, labels, title="DBSCAN聚类结果"):
    """可视化DBSCAN聚类结果"""
    plt.figure(figsize=(12, 5))
    
    plt.subplot(1, 2, 1)
    unique_labels = set(labels)
    colors = [plt.cm.Spectral(each) for each in np.linspace(0, 1, len(unique_labels))]
    
    for k, col in zip(unique_labels, colors):
        if k == -1:
            # 噪声点用黑色显示
            col = [0, 0, 0, 1]
        
        class_member_mask = (labels == k)
        xy = X[class_member_mask]
        plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
                markeredgecolor='k', markersize=6 if k != -1 else 4,
                alpha=0.6 if k != -1 else 0.3)
    
    plt.title(title)
    plt.xlabel('特征1')
    plt.ylabel('特征2')
    
    # 统计信息
    n_clusters = len(unique_labels) - (1 if -1 in unique_labels else 0)
    n_noise = list(labels).count(-1)
    
    plt.subplot(1, 2, 2)
    cluster_sizes = [np.sum(labels == i) for i in range(n_clusters)]
    plt.bar(range(n_clusters), cluster_sizes)
    plt.xlabel('簇编号')
    plt.ylabel('样本数量')
    plt.title(f'簇大小分布 (噪声点: {n_noise})')
    
    plt.tight_layout()
    plt.savefig('dbscan_clustering.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    print(f"发现 {n_clusters} 个簇")
    print(f"噪声点数量: {n_noise}")
    print(f"簇大小: {cluster_sizes}")

def main():
    parser = argparse.ArgumentParser(description='GPU加速的DBSCAN密度聚类')
    parser.add_argument('--eps', type=float, default=0.5, help='邻域半径')
    parser.add_argument('--min_samples', type=int, default=5, help='核心点最小样本数')
    parser.add_argument('--auto_eps', action='store_true', help='自动确定eps参数')
    parser.add_argument('--k_neighbors', type=int, default=5, help='自动确定eps时使用的近邻数')
    parser.add_argument('--n_samples', type=int, default=1000, help='生成样本数量')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 生成示例数据（月牙形数据，适合DBSCAN）
    print("生成示例数据...")
    X, y_true = make_moons(n_samples=args.n_samples, noise=0.05, random_state=42)
    
    # 自动确定最优eps参数
    if args.auto_eps:
        print("自动确定最优eps参数...")
        optimal_eps = find_optimal_eps(X, k=args.k_neighbors)
        args.eps = optimal_eps
        print(f"自动确定的eps参数: {optimal_eps:.4f}")
    
    # 运行GPU DBSCAN
    print("开始GPU DBSCAN聚类...")
    start_time = time.time()
    
    dbscan = DBSCAN_GPU(eps=args.eps, min_samples=args.min_samples)
    dbscan.fit(X)
    
    end_time = time.time()
    print(f"聚类完成，耗时: {end_time - start_time:.4f}秒")
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'dbscan_labels.npy'), dbscan.labels_)
    
    # 可视化结果
    visualize_dbscan(X, dbscan.labels_)
    
    print("DBSCAN聚类完成！结果已保存到", args.output_dir)

if __name__ == "__main__":
    main()
