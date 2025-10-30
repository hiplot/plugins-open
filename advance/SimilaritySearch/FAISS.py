#!/usr/bin/env python3
"""
FAISS GPU相似性搜索引擎
实现向量入库、批量查询、K近邻搜索功能
支持余弦相似度和欧氏距离两种度量方式
提供查询结果可视化
"""

import argparse
import numpy as np
import faiss
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
from sklearn.preprocessing import normalize
import os
import time

class FAISSSearch:
    """FAISS相似性搜索引擎"""
    
    def __init__(self, dimension, metric='l2', gpu_id=0):
        """
        初始化FAISS搜索引擎
        
        参数:
        dimension: 向量维度
        metric: 距离度量方式 ('l2'或'cosine')
        gpu_id: GPU设备ID
        """
        self.dimension = dimension
        self.metric = metric
        self.gpu_id = gpu_id
        self.index = None
        self.is_trained = False
        self.vectors = None
        
        # 根据度量方式选择索引类型
        if metric == 'l2':
            # 欧氏距离
            self.index = faiss.IndexFlatL2(dimension)
        elif metric == 'cosine':
            # 余弦相似度（使用内积，需要归一化）
            self.index = faiss.IndexFlatIP(dimension)
        else:
            raise ValueError("不支持的度量方式，请选择 'l2' 或 'cosine'")
        
        # 使用GPU加速
        if faiss.get_num_gpus() > 0:
            try:
                res = faiss.StandardGpuResources()
                self.index = faiss.index_cpu_to_gpu(res, gpu_id, self.index)
                print(f"使用GPU {gpu_id} 加速")
            except Exception as e:
                print(f"GPU加速失败，使用CPU: {e}")
    
    def add_vectors(self, vectors, normalize_vectors=False):
        """
        添加向量到索引
        
        参数:
        vectors: 要添加的向量
        normalize_vectors: 是否对向量进行归一化（用于余弦相似度）
        """
        if normalize_vectors and self.metric == 'cosine':
            vectors = normalize(vectors, norm='l2', axis=1)
        
        self.vectors = vectors.astype(np.float32)
        
        if not self.is_trained:
            # 对于需要训练的索引（如IVF），这里进行训练
            # 对于Flat索引，直接添加即可
            pass
        
        self.index.add(self.vectors)
        print(f"成功添加 {len(vectors)} 个向量到索引")
    
    def search(self, query_vectors, k=5, normalize_queries=False):
        """
        搜索相似向量
        
        参数:
        query_vectors: 查询向量
        k: 返回的最近邻数量
        normalize_queries: 是否对查询向量归一化
        
        返回:
        distances: 距离矩阵
        indices: 索引矩阵
        """
        if normalize_queries and self.metric == 'cosine':
            query_vectors = normalize(query_vectors, norm='l2', axis=1)
        
        query_vectors = query_vectors.astype(np.float32)
        
        # 执行搜索
        distances, indices = self.index.search(query_vectors, k)
        
        # 对于余弦相似度，将内积转换为余弦距离
        if self.metric == 'cosine':
            distances = 1 - distances  # 余弦距离 = 1 - 余弦相似度
        
        return distances, indices
    
    def save_index(self, filepath):
        """保存索引到文件"""
        if isinstance(self.index, faiss.GpuIndex):
            # 如果是GPU索引，先转换回CPU再保存
            index_cpu = faiss.index_gpu_to_cpu(self.index)
            faiss.write_index(index_cpu, filepath)
        else:
            faiss.write_index(self.index, filepath)
        print(f"索引已保存到: {filepath}")
    
    def load_index(self, filepath, vectors=None):
        """从文件加载索引"""
        index_cpu = faiss.read_index(filepath)
        
        # 转换到GPU
        if faiss.get_num_gpus() > 0:
            try:
                res = faiss.StandardGpuResources()
                self.index = faiss.index_cpu_to_gpu(res, self.gpu_id, index_cpu)
            except:
                self.index = index_cpu
                print("GPU加载失败，使用CPU索引")
        else:
            self.index = index_cpu
        
        self.vectors = vectors
        print(f"索引已从 {filepath} 加载")
    
    def get_vector(self, index):
        """根据索引获取向量"""
        if self.vectors is not None and 0 <= index < len(self.vectors):
            return self.vectors[index]
        return None

def create_sample_data(n_samples=1000, n_features=128, n_queries=10, random_state=42):
    """创建示例数据"""
    # 生成随机向量作为数据库
    rng = np.random.RandomState(random_state)
    database_vectors = rng.randn(n_samples, n_features).astype(np.float32)
    
    # 从数据库中随机选择一些作为查询向量
    query_indices = rng.choice(n_samples, n_queries, replace=False)
    query_vectors = database_vectors[query_indices]
    
    # 添加一些噪声使查询向量略有不同
    query_vectors += rng.normal(0, 0.1, query_vectors.shape)
    
    return database_vectors, query_vectors, query_indices

def visualize_search_results(database_vectors, query_vectors, indices, distances, 
                           metric='l2', max_display=3):
    """可视化搜索结果（适用于2D或3D数据）"""
    if database_vectors.shape[1] not in [2, 3]:
        print("只能可视化2D或3D数据")
        return
    
    n_queries = min(len(query_vectors), max_display)
    
    if database_vectors.shape[1] == 2:
        # 2D可视化
        fig, axes = plt.subplots(1, n_queries, figsize=(5*n_queries, 5))
        if n_queries == 1:
            axes = [axes]
        
        for i, ax in enumerate(axes):
            # 绘制所有数据点
            ax.scatter(database_vectors[:, 0], database_vectors[:, 1], 
                      c='lightblue', alpha=0.3, s=20, label='数据库向量')
            
            # 绘制查询点
            query = query_vectors[i]
            ax.scatter(query[0], query[1], c='red', s=100, marker='*', label='查询点')
            
            # 绘制最近邻点
            nearest_indices = indices[i]
            nearest_vectors = database_vectors[nearest_indices]
            ax.scatter(nearest_vectors[:, 0], nearest_vectors[:, 1], 
                      c='green', s=50, label=f'Top-{len(nearest_indices)}最近邻')
            
            # 连接查询点和最近邻点
            for j, neighbor in enumerate(nearest_vectors):
                ax.plot([query[0], neighbor[0]], [query[1], neighbor[1]], 
                       'g--', alpha=0.5, linewidth=1)
                ax.text(neighbor[0], neighbor[1], f'{distances[i][j]:.3f}', 
                       fontsize=8, ha='right')
            
            ax.set_xlabel('特征1')
            ax.set_ylabel('特征2')
            ax.set_title(f'查询点 {i+1} 的搜索结果')
            ax.legend()
            ax.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('search_results.png', dpi=300, bbox_inches='tight')
    plt.show()

def benchmark_search(searcher, query_vectors, k_values=[1, 5, 10, 20], n_repeats=10):
    """性能基准测试"""
    print("开始性能基准测试...")
    
    results = {}
    for k in k_values:
        times = []
        for _ in range(n_repeats):
            start_time = time.time()
            distances, indices = searcher.search(query_vectors, k=k)
            end_time = time.time()
            times.append(end_time - start_time)
        
        avg_time = np.mean(times)
        std_time = np.std(times)
        results[k] = {'avg_time': avg_time, 'std_time': std_time}
        
        print(f"k={k}: 平均搜索时间 {avg_time*1000:.2f}ms ± {std_time*1000:.2f}ms")
    
    return results

def main():
    parser = argparse.ArgumentParser(description='FAISS GPU相似性搜索引擎')
    parser.add_argument('--dimension', type=int, default=128, help='向量维度')
    parser.add_argument('--n_samples', type=int, default=10000, help='数据库向量数量')
    parser.add_argument('--n_queries', type=int, default=5, help='查询向量数量')
    parser.add_argument('--metric', choices=['l2', 'cosine'], default='l2', help='距离度量方式')
    parser.add_argument('--k', type=int, default=10, help='返回的最近邻数量')
    parser.add_argument('--gpu_id', type=int, default=0, help='GPU设备ID')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 创建示例数据
    print("创建示例数据...")
    database_vectors, query_vectors, true_indices = create_sample_data(
        args.n_samples, args.dimension, args.n_queries
    )
    
    # 初始化搜索引擎
    searcher = FAISSSearch(dimension=args.dimension, metric=args.metric, gpu_id=args.gpu_id)
    
    # 添加向量到索引
    normalize_vectors = (args.metric == 'cosine')
    searcher.add_vectors(database_vectors, normalize_vectors=normalize_vectors)
    
    # 执行搜索
    print("执行相似性搜索...")
    start_time = time.time()
    distances, indices = searcher.search(query_vectors, k=args.k, normalize_queries=normalize_vectors)
    search_time = time.time() - start_time
    
    print(f"搜索完成，耗时: {search_time*1000:.2f}ms")
    
    # 显示搜索结果
    for i in range(len(query_vectors)):
        print(f"\n查询点 {i+1}:")
        print(f"真实最近邻索引: {true_indices[i]}")
        print(f"搜索到的最近邻: {indices[i]}")
        print(f"距离: {distances[i]}")
        
        # 检查真实最近邻是否在结果中
        if true_indices[i] in indices[i]:
            position = np.where(indices[i] == true_indices[i])[0][0] + 1
            print(f"真实最近邻排名: 第 {position} 位")
        else:
            print("真实最近邻不在前K个结果中")
    
    # 性能基准测试
    benchmark_results = benchmark_search(searcher, query_vectors)
    
    # 可视化结果（如果维度为2或3）
    if args.dimension in [2, 3]:
        visualize_search_results(database_vectors, query_vectors, indices, distances, args.metric)
    else:
        # 使用PCA降维进行可视化
        from sklearn.decomposition import PCA
        if args.dimension > 3:
            pca = PCA(n_components=2)
            db_2d = pca.fit_transform(database_vectors)
            query_2d = pca.transform(query_vectors)
            visualize_search_results(db_2d, query_2d, indices, distances, args.metric)
    
    # 保存索引和结果
    index_path = os.path.join(args.output_dir, 'faiss_index.bin')
    searcher.save_index(index_path)
    
    np.save(os.path.join(args.output_dir, 'search_indices.npy'), indices)
    np.save(os.path.join(args.output_dir, 'search_distances.npy'), distances)
    
    # 保存基准测试结果
    import json
    with open(os.path.join(args.output_dir, 'benchmark_results.json'), 'w') as f:
        json.dump(benchmark_results, f, indent=2)
    
    print(f"\n搜索结果已保存到 {args.output_dir}")
    print(f"使用的度量方式: {args.metric}")
    print(f"数据库大小: {args.n_samples} 个 {args.dimension} 维向量")

if __name__ == "__main__":
    main()
