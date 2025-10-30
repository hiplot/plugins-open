#!/usr/bin/env python3
"""
GPU加速的K-Means聚类工具
基于Lloyd算法，使用CuPy实现GPU加速
支持自定义聚类数、最大迭代次数和可视化功能
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
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

class GPUKMeans:
    def __init__(self, n_clusters=8, max_iter=300, tol=1e-4, random_state=42):
        """
        初始化GPU K-Means
        
        参数:
        n_clusters: 聚类数量
        max_iter: 最大迭代次数
        tol: 收敛容忍度
        random_state: 随机种子
        """
        self.n_clusters = n_clusters
        self.max_iter = max_iter
        self.tol = tol
        self.random_state = random_state
        self.centroids = None
        self.labels = None
        
    def _initialize_centroids(self, X):
        """随机初始化质心"""
        n_samples = X.shape[0]
        rng = cp.random.RandomState(self.random_state)
        indices = rng.choice(n_samples, self.n_clusters, replace=False)
        return X[indices]
    
    def _assign_clusters(self, X, centroids):
        """分配样本到最近的质心"""
        # 计算每个样本到所有质心的距离
        distances = cp.linalg.norm(X[:, cp.newaxis] - centroids, axis=2)
        # 返回最近的质心索引
        return cp.argmin(distances, axis=1)
    
    def _update_centroids(self, X, labels):
        """更新质心位置"""
        new_centroids = cp.zeros((self.n_clusters, X.shape[1]))
        for i in range(self.n_clusters):
            # 计算每个簇的均值作为新质心
            mask = (labels == i)
            if cp.sum(mask) > 0:
                new_centroids[i] = cp.mean(X[mask], axis=0)
            else:
                # 如果簇为空，随机重新初始化
                new_centroids[i] = X[cp.random.randint(X.shape[0])]
        return new_centroids
    
    def fit(self, X):
        """
        训练K-Means模型
        
        参数:
        X: 输入数据，形状为(n_samples, n_features)
        """
        # 转换数据为CuPy数组
        if isinstance(X, np.ndarray):
            X_gpu = cp.asarray(X.astype(np.float32))
        else:
            X_gpu = X.astype(cp.float32)
        
        # 初始化质心
        self.centroids = self._initialize_centroids(X_gpu)
        
        for iteration in range(self.max_iter):
            # 分配簇
            labels = self._assign_clusters(X_gpu, self.centroids)
            
            # 更新质心
            new_centroids = self._update_centroids(X_gpu, labels)
            
            # 检查收敛
            centroid_shift = cp.linalg.norm(new_centroids - self.centroids)
            
            if centroid_shift < self.tol:
                print(f"收敛于第 {iteration + 1} 次迭代")
                break
                
            self.centroids = new_centroids
            
            if (iteration + 1) % 10 == 0:
                print(f"迭代 {iteration + 1}, 质心移动: {centroid_shift:.6f}")
        
        self.labels_ = cp.asnumpy(labels) if GPU_AVAILABLE else labels.get()
        self.centroids_ = cp.asnumpy(self.centroids) if GPU_AVAILABLE else self.centroids.get()
        
        return self
    
    def predict(self, X):
        """预测新数据的簇标签"""
        if isinstance(X, np.ndarray):
            X_gpu = cp.asarray(X.astype(np.float32))
        else:
            X_gpu = X.astype(cp.float32)
            
        labels = self._assign_clusters(X_gpu, cp.asarray(self.centroids_))
        return cp.asnumpy(labels) if GPU_AVAILABLE else labels.get()

def visualize_clustering(X, labels, centroids, title="K-Means聚类结果"):
    """可视化聚类结果"""
    plt.figure(figsize=(12, 5))
    
    plt.subplot(1, 2, 1)
    plt.scatter(X[:, 0], X[:, 1], c=labels, cmap='viridis', alpha=0.6)
    plt.scatter(centroids[:, 0], centroids[:, 1], marker='x', c='red', s=200, linewidths=3)
    plt.title(title)
    plt.xlabel('特征1')
    plt.ylabel('特征2')
    plt.colorbar(label='簇标签')
    
    plt.subplot(1, 2, 2)
    for i in range(len(centroids)):
        cluster_points = X[labels == i]
        plt.scatter(cluster_points[:, 0], cluster_points[:, 1], 
                   label=f'簇 {i}', alpha=0.7)
    plt.scatter(centroids[:, 0], centroids[:, 1], marker='x', 
               c='black', s=200, linewidths=3, label='质心')
    plt.title('簇分布')
    plt.xlabel('特征1')
    plt.ylabel('特征2')
    plt.legend()
    
    plt.tight_layout()
    plt.savefig('kmeans_clustering.png', dpi=300, bbox_inches='tight')
    plt.show()

def main():
    parser = argparse.ArgumentParser(description='GPU加速的K-Means聚类')
    parser.add_argument('--n_clusters', type=int, default=3, help='聚类数量')
    parser.add_argument('--max_iter', type=int, default=100, help='最大迭代次数')
    parser.add_argument('--n_samples', type=int, default=1000, help='生成样本数量')
    parser.add_argument('--random_state', type=int, default=42, help='随机种子')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 生成示例数据
    print("生成示例数据...")
    X, y_true = make_blobs(n_samples=args.n_samples, centers=args.n_clusters,
                          random_state=args.random_state, cluster_std=0.60)
    
    # 运行GPU K-Means
    print("开始GPU K-Means聚类...")
    start_time = time.time()
    
    kmeans = GPUKMeans(n_clusters=args.n_clusters, max_iter=args.max_iter,
                      random_state=args.random_state)
    kmeans.fit(X)
    
    end_time = time.time()
    print(f"聚类完成，耗时: {end_time - start_time:.4f}秒")
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'kmeans_labels.npy'), kmeans.labels_)
    np.save(os.path.join(args.output_dir, 'kmeans_centroids.npy'), kmeans.centroids_)
    
    print(f"簇标签形状: {kmeans.labels_.shape}")
    print(f"质心形状: {kmeans.centroids_.shape}")
    
    # 可视化结果
    visualize_clustering(X, kmeans.labels_, kmeans.centroids_)
    
    print("聚类完成！结果已保存到", args.output_dir)

if __name__ == "__main__":
    main()
