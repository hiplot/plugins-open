#!/usr/bin/env python3
"""
半监督标签传播工具
支持自定义传播迭代次数和核函数类型
处理部分标记数据集，输出完整标签预测结果
包含分类准确率评估
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_classification, make_moons
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.neighbors import NearestNeighbors
from scipy.sparse import csgraph, csr_matrix
import os
import warnings
warnings.filterwarnings('ignore')

class LabelPropagator:
    """标签传播算法实现"""
    
    def __init__(self, max_iter=1000, tol=1e-3, kernel='rbf', gamma=20, alpha=0.2, n_neighbors=7):
        """
        初始化标签传播器
        
        参数:
        max_iter: 最大迭代次数
        tol: 收敛容忍度
        kernel: 核函数类型 ('rbf', 'knn')
        gamma: RBF核的参数
        alpha: 钳位因子（已标记数据的置信度）
        n_neighbors: KNN核的近邻数
        """
        self.max_iter = max_iter
        self.tol = tol
        self.kernel = kernel
        self.gamma = gamma
        self.alpha = alpha
        self.n_neighbors = n_neighbors
        self.labels_ = None
        self.label_distributions_ = None
    
    def _build_graph(self, X):
        """构建图结构（相似性矩阵）"""
        n_samples = X.shape[0]
        
        if self.kernel == 'rbf':
            # RBF核函数
            from sklearn.metrics.pairwise import rbf_kernel
            W = rbf_kernel(X, gamma=self.gamma)
            np.fill_diagonal(W, 0)  # 对角线设为0
            
        elif self.kernel == 'knn':
            # KNN核函数
            W = np.zeros((n_samples, n_samples))
            knn = NearestNeighbors(n_neighbors=self.n_neighbors)
            knn.fit(X)
            distances, indices = knn.kneighbors(X)
            
            for i in range(n_samples):
                for j, idx in enumerate(indices[i]):
                    if i != idx:  # 排除自身
                        W[i, idx] = np.exp(-distances[i][j] ** 2 * self.gamma)
        
        # 对称化并归一化
        W = np.maximum(W, W.T)  # 确保对称
        D = np.diag(np.sum(W, axis=1))
        D_inv_sqrt = np.diag(1.0 / np.sqrt(np.diag(D)))
        S = D_inv_sqrt @ W @ D_inv_sqrt
        
        return S
    
    def fit(self, X, y):
        """
        训练标签传播模型
        
        参数:
        X: 特征矩阵
        y: 标签向量，未标记点用-1表示
        """
        n_samples = X.shape[0]
        labeled_mask = (y != -1)
        unlabeled_mask = ~labeled_mask
        
        if np.sum(labeled_mask) == 0:
            raise ValueError("必须提供至少一个已标记样本")
        
        # 构建图
        print("构建图结构...")
        S = self._build_graph(X)
        
        # 初始化标签分布
        classes = np.unique(y[labeled_mask])
        n_classes = len(classes)
        self.classes_ = classes
        
        # 创建one-hot编码的标签矩阵
        F = np.zeros((n_samples, n_classes))
        for i, label in enumerate(classes):
            F[labeled_mask, i] = (y[labeled_mask] == label).astype(float)
        
        # 钳位已标记数据
        F_labeled = F[labeled_mask].copy()
        
        # 标签传播迭代
        print("开始标签传播...")
        for iteration in range(self.max_iter):
            F_old = F.copy()
            
            # 传播步骤
            F = S @ F
            
            # 钳位步骤：保持已标记数据的标签不变
            F[labeled_mask] = (1 - self.alpha) * F[labeled_mask] + self.alpha * F_labeled
            
            # 检查收敛
            diff = np.linalg.norm(F - F_old)
            if diff < self.tol:
                print(f"收敛于第 {iteration + 1} 次迭代")
                break
            
            if (iteration + 1) % 100 == 0:
                print(f"迭代 {iteration + 1}, 变化量: {diff:.6f}")
        
        self.label_distributions_ = F
        self.labels_ = classes[np.argmax(F, axis=1)]
        
        return self
    
    def predict(self, X):
        """预测标签（需要重新构建图，实际中通常不用于新数据）"""
        # 注意：标签传播通常用于半监督学习，不直接用于新数据预测
        # 这里简化处理，返回训练数据的预测结果
        return self.labels_
    
    def predict_proba(self, X):
        """预测概率分布"""
        return self.label_distributions_

def create_semi_supervised_data(n_samples=1000, n_labeled=50, random_state=42):
    """创建半监督学习示例数据"""
    # 生成分类数据
    X, y_true = make_classification(n_samples=n_samples, n_features=20, 
                                   n_informative=15, n_redundant=5,
                                   n_clusters_per_class=1, random_state=random_state)
    
    # 随机选择部分样本作为已标记数据
    rng = np.random.RandomState(random_state)
    labeled_indices = rng.choice(n_samples, n_labeled, replace=False)
    
    y = np.full(n_samples, -1)  # -1表示未标记
    y[labeled_indices] = y_true[labeled_indices]
    
    return X, y_true, y, labeled_indices

def evaluate_performance(y_true, y_pred, labeled_mask):
    """评估模型性能"""
    # 整体准确率
    overall_accuracy = accuracy_score(y_true, y_pred)
    
    # 未标记数据的准确率
    unlabeled_accuracy = accuracy_score(y_true[~labeled_mask], y_pred[~labeled_mask])
    
    # 已标记数据的准确率（应该接近100%）
    labeled_accuracy = accuracy_score(y_true[labeled_mask], y_pred[labeled_mask])
    
    print(f"\n性能评估:")
    print(f"整体准确率: {overall_accuracy:.4f}")
    print(f"已标记数据准确率: {labeled_accuracy:.4f}")
    print(f"未标记数据准确率: {unlabeled_accuracy:.4f}")
    
    return {
        'overall': overall_accuracy,
        'labeled': labeled_accuracy,
        'unlabeled': unlabeled_accuracy
    }

def visualize_results(X, y_true, y_pred, y_semi, labeled_indices, title="标签传播结果"):
    """可视化标签传播结果"""
    if X.shape[1] > 2:
        # 使用PCA降维进行可视化
        from sklearn.decomposition import PCA
        pca = PCA(n_components=2)
        X_2d = pca.fit_transform(X)
    else:
        X_2d = X
    
    plt.figure(figsize=(15, 5))
    
    # 真实标签
    plt.subplot(1, 3, 1)
    for class_label in np.unique(y_true):
        mask = y_true == class_label
        plt.scatter(X_2d[mask, 0], X_2d[mask, 1], label=f'类别 {class_label}', alpha=0.6)
    plt.title('真实标签分布')
    plt.legend()
    
    # 半监督输入（已标记数据）
    plt.subplot(1, 3, 2)
    unlabeled_mask = np.ones(len(y_semi), dtype=bool)
    unlabeled_mask[labeled_indices] = False
    
    # 未标记点
    plt.scatter(X_2d[unlabeled_mask, 0], X_2d[unlabeled_mask, 1], 
               c='lightgray', alpha=0.3, label='未标记')
    
    # 已标记点
    for class_label in np.unique(y_semi[labeled_indices]):
        mask = (y_semi == class_label) & (y_semi != -1)
        plt.scatter(X_2d[mask, 0], X_2d[mask, 1], label=f'已标记 {class_label}', 
                   alpha=0.8, s=80, edgecolors='black')
    
    plt.title('半监督输入（已标记数据）')
    plt.legend()
    
    # 预测结果
    plt.subplot(1, 3, 3)
    for class_label in np.unique(y_pred):
        mask = y_pred == class_label
        plt.scatter(X_2d[mask, 0], X_2d[mask, 1], label=f'预测 {class_label}', alpha=0.6)
    
    # 高亮错误分类的点
    error_mask = (y_pred != y_true)
    plt.scatter(X_2d[error_mask, 0], X_2d[error_mask, 1], 
               c='red', marker='x', s=100, label='分类错误')
    
    plt.title('预测结果（红色×表示错误）')
    plt.legend()
    
    plt.tight_layout()
    plt.savefig('label_propagation_results.png', dpi=300, bbox_inches='tight')
    plt.show()

def plot_convergence_analysis(X, y_semi, kernel_types=['rbf', 'knn']):
    """分析不同参数下的收敛性能"""
    n_labeled = np.sum(y_semi != -1)
    accuracies = {}
    
    plt.figure(figsize=(12, 4))
    
    for i, kernel in enumerate(kernel_types):
        # 测试不同迭代次数
        iterations = [10, 50, 100, 200, 500, 1000]
        accs = []
        
        for max_iter in iterations:
            propagator = LabelPropagator(max_iter=max_iter, kernel=kernel)
            propagator.fit(X, y_semi)
            y_pred = propagator.predict(X)
            
            # 计算未标记数据的准确率（模拟真实场景）
            unlabeled_mask = (y_semi == -1)
            if np.sum(unlabeled_mask) > 0:
                # 这里我们用真实标签评估（实际中不可用）
                from sklearn.datasets import make_classification
                _, y_true = make_classification(n_samples=len(y_semi), random_state=42)
                acc = accuracy_score(y_true[unlabeled_mask], y_pred[unlabeled_mask])
                accs.append(acc)
        
        accuracies[kernel] = accs
        
        plt.subplot(1, 2, 1)
        plt.plot(iterations[:len(accs)], accs, 'o-', label=f'{kernel}核')
        plt.xlabel('迭代次数')
        plt.ylabel('准确率')
        plt.title('不同迭代次数下的性能')
        plt.legend()
        plt.grid(True)
    
    # 分析不同已标记数据比例的影响
    labeled_ratios = [0.01, 0.05, 0.1, 0.2, 0.3]
    ratio_accs = []
    
    for ratio in labeled_ratios:
        n_labeled = int(len(y_semi) * ratio)
        if n_labeled < 1:
            continue
            
        # 创建新的半监督数据
        rng = np.random.RandomState(42)
        labeled_indices = rng.choice(len(y_semi), n_labeled, replace=False)
        y_new = np.full(len(y_semi), -1)
        y_new[labeled_indices] = y_semi[labeled_indices]
        
        propagator = LabelPropagator(kernel='rbf')
        propagator.fit(X, y_new)
        y_pred = propagator.predict(X)
        
        # 评估性能
        unlabeled_mask = (y_new == -1)
        _, y_true = make_classification(n_samples=len(y_semi), random_state=42)
        acc = accuracy_score(y_true[unlabeled_mask], y_pred[unlabeled_mask])
        ratio_accs.append(acc)
    
    plt.subplot(1, 2, 2)
    plt.plot(labeled_ratios[:len(ratio_accs)], ratio_accs, 's-', color='red')
    plt.xlabel('已标记数据比例')
    plt.ylabel('准确率')
    plt.title('已标记数据比例对性能的影响')
    plt.grid(True)
    
    plt.tight_layout()
    plt.savefig('convergence_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    return accuracies

def main():
    parser = argparse.ArgumentParser(description='半监督标签传播工具')
    parser.add_argument('--max_iter', type=int, default=1000, help='最大迭代次数')
    parser.add_argument('--kernel', choices=['rbf', 'knn'], default='rbf', help='核函数类型')
    parser.add_argument('--gamma', type=float, default=20.0, help='RBF核参数')
    parser.add_argument('--alpha', type=float, default=0.2, help='钳位因子')
    parser.add_argument('--n_neighbors', type=int, default=7, help='KNN近邻数')
    parser.add_argument('--n_samples', type=int, default=1000, help='总样本数')
    parser.add_argument('--n_labeled', type=int, default=50, help='已标记样本数')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 创建半监督数据
    print("创建半监督学习数据...")
    X, y_true, y_semi, labeled_indices = create_semi_supervised_data(
        args.n_samples, args.n_labeled
    )
    
    print(f"数据形状: {X.shape}")
    print(f"已标记样本数: {len(labeled_indices)}")
    print(f"未标记样本数: {args.n_samples - len(labeled_indices)}")
    
    # 初始化标签传播器
    propagator = LabelPropagator(
        max_iter=args.max_iter,
        kernel=args.kernel,
        gamma=args.gamma,
        alpha=args.alpha,
        n_neighbors=args.n_neighbors
    )
    
    # 训练模型
    print("开始标签传播训练...")
    propagator.fit(X, y_semi)
    
    # 预测
    y_pred = propagator.predict(X)
    
    # 评估性能
    labeled_mask = np.zeros(len(y_semi), dtype=bool)
    labeled_mask[labeled_indices] = True
    accuracy_results = evaluate_performance(y_true, y_pred, labeled_mask)
    
    # 可视化结果
    visualize_results(X, y_true, y_pred, y_semi, labeled_indices)
    
    # 收敛性分析
    plot_convergence_analysis(X, y_semi)
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'true_labels.npy'), y_true)
    np.save(os.path.join(args.output_dir, 'semi_labels.npy'), y_semi)
    np.save(os.path.join(args.output_dir, 'predicted_labels.npy'), y_pred)
    np.save(os.path.join(args.output_dir, 'label_distributions.npy'), propagator.label_distributions_)
    
    # 输出分类报告
    print("\n分类报告:")
    print(classification_report(y_true, y_pred))
    
    print("标签传播完成！结果已保存到", args.output_dir)

if __name__ == "__main__":
    main()
