#!/usr/bin/env python3
"""
孤立森林异常值移除工具
基于scikit-learn的孤立森林算法
支持自定义异常值比例阈值，提供异常值掩码输出
包含数据清洗前后的对比可视化
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
from sklearn.ensemble import IsolationForest
from sklearn.datasets import make_blobs, make_classification
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix
import os
import warnings
warnings.filterwarnings('ignore')

class OutlierRemover:
    """异常值移除工具（基于孤立森林）"""
    
    def __init__(self, contamination=0.1, n_estimators=100, max_samples='auto',
                 random_state=42, **kwargs):
        """
        初始化异常值移除器
        
        参数:
        contamination: 异常值比例估计
        n_estimators: 孤立树数量
        max_samples: 每棵树的样本数
        random_state: 随机种子
        """
        self.contamination = contamination
        self.n_estimators = n_estimators
        self.max_samples = max_samples
        self.random_state = random_state
        self.detector = IsolationForest(
            contamination=contamination,
            n_estimators=n_estimators,
            max_samples=max_samples,
            random_state=random_state,
            **kwargs
        )
        self.scaler = StandardScaler()
        self.outlier_mask_ = None
        self.anomaly_scores_ = None
    
    def fit_detect(self, X):
        """
        拟合模型并检测异常值
        
        参数:
        X: 输入数据
        
        返回:
        outlier_mask: 异常值掩码（True表示异常值）
        """
        # 数据标准化
        X_scaled = self.scaler.fit_transform(X)
        
        # 训练孤立森林
        self.detector.fit(X_scaled)
        
        # 预测异常值（-1表示异常，1表示正常）
        predictions = self.detector.predict(X_scaled)
        self.outlier_mask_ = (predictions == -1)
        
        # 获取异常分数（分数越低越可能是异常）
        self.anomaly_scores_ = self.detector.decision_function(X_scaled)
        
        return self.outlier_mask_
    
    def remove_outliers(self, X, y=None):
        """
        移除异常值
        
        参数:
        X: 特征数据
        y: 可选标签数据
        
        返回:
        X_clean: 清洗后的特征数据
        y_clean: 清洗后的标签数据（如果提供了y）
        """
        if self.outlier_mask_ is None:
            self.fit_detect(X)
        
        clean_mask = ~self.outlier_mask_
        X_clean = X[clean_mask]
        
        if y is not None:
            y_clean = y[clean_mask]
            return X_clean, y_clean
        else:
            return X_clean
    
    def get_clean_data(self, X, y=None):
        """获取清洗后的数据（remove_outliers的别名）"""
        return self.remove_outliers(X, y)
    
    def get_anomaly_scores(self, X):
        """获取异常分数"""
        if self.anomaly_scores_ is None:
            X_scaled = self.scaler.transform(X)
            self.anomaly_scores_ = self.detector.decision_function(X_scaled)
        return self.anomaly_scores_

def create_data_with_outliers(n_samples=1000, n_outliers=100, n_features=2, random_state=42):
    """创建包含异常值的示例数据"""
    # 生成正常数据
    X_normal, y_normal = make_blobs(n_samples=n_samples - n_outliers, 
                                  centers=3, cluster_std=0.8,
                                  random_state=random_state)
    
    # 生成异常数据（远离正常数据）
    rng = np.random.RandomState(random_state + 1)
    
    # 方法1：均匀分布的异常点
    X_outliers_uniform = rng.uniform(low=-10, high=10, size=(n_outliers // 2, n_features))
    
    # 方法2：远离中心的异常点
    center = np.mean(X_normal, axis=0)
    radius = np.max(np.linalg.norm(X_normal - center, axis=1)) * 2
    directions = rng.randn(n_outliers // 2, n_features)
    directions = directions / np.linalg.norm(directions, axis=1, keepdims=True)
    X_outliers_radial = center + directions * radius * (1 + rng.rand(n_outliers // 2, 1))
    
    X_outliers = np.vstack([X_outliers_uniform, X_outliers_radial])
    
    # 合并数据
    X = np.vstack([X_normal, X_outliers])
    y = np.array([0] * len(X_normal) + [1] * len(X_outliers))  # 0:正常, 1:异常
    
    return X, y

def visualize_comparison(X_original, y_original, X_clean, y_clean, outlier_mask, 
                        anomaly_scores, contamination, title_suffix=""):
    """可视化数据清洗前后的对比"""
    fig = plt.figure(figsize=(18, 12))
    
    # 1. 原始数据分布
    ax1 = plt.subplot(2, 3, 1)
    normal_mask_orig = (y_original == 0)
    outlier_mask_orig = (y_original == 1)
    
    plt.scatter(X_original[normal_mask_orig, 0], X_original[normal_mask_orig, 1],
               c='blue', alpha=0.6, s=30, label='正常点')
    plt.scatter(X_original[outlier_mask_orig, 0], X_original[outlier_mask_orig, 1],
               c='red', alpha=0.6, s=50, marker='x', label='异常点')
    plt.title(f'原始数据分布{title_suffix}\n(正常: {np.sum(normal_mask_orig)}, 异常: {np.sum(outlier_mask_orig)})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 2. 异常分数分布
    ax2 = plt.subplot(2, 3, 2)
    scores_normal = anomaly_scores[normal_mask_orig]
    scores_outliers = anomaly_scores[outlier_mask_orig]
    
    plt.hist(scores_normal, bins=50, alpha=0.7, label='正常点', color='blue')
    plt.hist(scores_outliers, bins=50, alpha=0.7, label='异常点', color='red')
    plt.axvline(x=np.percentile(anomaly_scores, contamination * 100), 
               color='black', linestyle='--', label=f'阈值 ({contamination*100:.1f}%)')
    plt.xlabel('异常分数')
    plt.ylabel('频数')
    plt.title('异常分数分布')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 3. 检测结果
    ax3 = plt.subplot(2, 3, 3)
    detected_normal = ~outlier_mask_
    detected_outliers = outlier_mask_
    
    plt.scatter(X_original[detected_normal, 0], X_original[detected_normal, 1],
               c='green', alpha=0.6, s=30, label='检测为正常')
    plt.scatter(X_original[detected_outliers, 0], X_original[detected_outliers, 1],
               c='orange', alpha=0.8, s=60, marker='s', label='检测为异常')
    plt.title(f'异常检测结果{title_suffix}\n(检测异常: {np.sum(detected_outliers)})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 4. 清洗后数据分布
    ax4 = plt.subplot(2, 3, 4)
    normal_mask_clean = (y_clean == 0)
    outlier_mask_clean = (y_clean == 1) if 1 in y_clean else np.zeros(len(y_clean), dtype=bool)
    
    plt.scatter(X_clean[normal_mask_clean, 0], X_clean[normal_mask_clean, 1],
               c='blue', alpha=0.6, s=30, label='正常点')
    if np.sum(outlier_mask_clean) > 0:
        plt.scatter(X_clean[outlier_mask_clean, 0], X_clean[outlier_mask_clean, 1],
                   c='red', alpha=0.6, s=50, marker='x', label='剩余异常点')
    plt.title(f'清洗后数据分布{title_suffix}\n(剩余样本: {len(X_clean)})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 5. 检测性能分析
    ax5 = plt.subplot(2, 3, 5)
    from sklearn.metrics import ConfusionMatrixDisplay
    y_true = y_original
    y_pred = np.where(outlier_mask, 1, 0)  # 转换为0/1标签
    
    cm = confusion_matrix(y_true, y_pred)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['正常', '异常'])
    disp.plot(ax=ax5, cmap='Blues')
    plt.title('混淆矩阵')
    
    # 6. 异常分数箱线图
    ax6 = plt.subplot(2, 3, 6)
    data_to_plot = [scores_normal, scores_outliers]
    box_plot = plt.boxplot(data_to_plot, labels=['正常点', '异常点'], patch_artist=True)
    
    # 设置颜色
    colors = ['lightblue', 'lightcoral']
    for patch, color in zip(box_plot['boxes'], colors):
        patch.set_facecolor(color)
    
    plt.ylabel('异常分数')
    plt.title('异常分数分布比较')
    plt.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('outlier_detection_comparison.png', dpi=300, bbox_inches='tight')
    plt.show()

def evaluate_detection_performance(y_true, outlier_mask):
    """评估异常检测性能"""
    y_pred = outlier_mask.astype(int)
    
    # 计算各项指标
    tn = np.sum((y_true == 0) & (y_pred == 0))  # 真负例
    fp = np.sum((y_true == 0) & (y_pred == 1))  # 假正例
    fn = np.sum((y_true == 1) & (y_pred == 0))  # 假负例
    tp = np.sum((y_true == 1) & (y_pred == 1))  # 真正例
    
    accuracy = (tp + tn) / len(y_true) if len(y_true) > 0 else 0
    precision = tp / (tp + fp) if (tp + fp) > 0 else 0
    recall = tp / (tp + fn) if (tp + fn) > 0 else 0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
    
    print(f"\n异常检测性能评估:")
    print(f"准确率: {accuracy:.4f}")
    print(f"精确率: {precision:.4f}")
    print(f"召回率: {recall:.4f}")
    print(f"F1分数: {f1:.4f}")
    print(f"真正例(TP): {tp}, 真负例(TN): {tn}")
    print(f"假正例(FP): {fp}, 假负例(FN): {fn}")
    
    return {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1': f1,
        'confusion_matrix': [[tn, fp], [fn, tp]]
    }

def analyze_contamination_sensitivity(X, y_true, contamination_values):
    """分析异常值比例参数的敏感性"""
    results = []
    
    for contamination in contamination_values:
        remover = OutlierRemover(contamination=contamination, random_state=42)
        outlier_mask = remover.fit_detect(X)
        
        # 评估性能
        y_pred = outlier_mask.astype(int)
        accuracy = np.mean(y_true == y_pred)
        
        n_detected = np.sum(outlier_mask)
        n_actual = np.sum(y_true == 1)
        
        results.append({
            'contamination': contamination,
            'accuracy': accuracy,
            'detected_outliers': n_detected,
            'actual_outliers': n_actual,
            'detection_ratio': n_detected / n_actual if n_actual > 0 else 0
        })
    
    # 绘制敏感性分析图
    plt.figure(figsize=(12, 4))
    
    plt.subplot(1, 3, 1)
    accuracies = [r['accuracy'] for r in results]
    plt.plot(contamination_values, accuracies, 'o-', linewidth=2, markersize=8)
    plt.xlabel('异常值比例参数')
    plt.ylabel('检测准确率')
    plt.title('参数敏感性分析 - 准确率')
    plt.grid(True)
    
    plt.subplot(1, 3, 2)
    detected = [r['detected_outliers'] for r in results]
    actual = results[0]['actual_outliers']  # 实际异常值数量是固定的
    plt.plot(contamination_values, detected, 's-', label='检测到的异常值', linewidth=2)
    plt.axhline(y=actual, color='r', linestyle='--', label='实际异常值数量')
    plt.xlabel('异常值比例参数')
    plt.ylabel('异常值数量')
    plt.title('参数敏感性分析 - 异常值数量')
    plt.legend()
    plt.grid(True)
    
    plt.subplot(1, 3, 3)
    ratios = [r['detection_ratio'] for r in results]
    plt.plot(contamination_values, ratios, '^-', linewidth=2, markersize=8)
    plt.xlabel('异常值比例参数')
    plt.ylabel('检测比例')
    plt.title('参数敏感性分析 - 检测比例')
    plt.grid(True)
    
    plt.tight_layout()
    plt.savefig('contamination_sensitivity.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    return results

def main():
    parser = argparse.ArgumentParser(description='孤立森林异常值移除工具')
    parser.add_argument('--contamination', type=float, default=0.1, help='异常值比例估计')
    parser.add_argument('--n_estimators', type=int, default=100, help='孤立树数量')
    parser.add_argument('--max_samples', type=str, default='auto', help='每棵树样本数')
    parser.add_argument('--n_samples', type=int, default=1000, help='总样本数')
    parser.add_argument('--n_outliers', type=int, default=100, help='异常值数量')
    parser.add_argument('--n_features', type=int, default=2, help='特征维度')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 创建包含异常值的数据
    print("创建包含异常值的示例数据...")
    X, y_true = create_data_with_outliers(
        n_samples=args.n_samples,
        n_outliers=args.n_outliers,
        n_features=args.n_features
    )
    
    print(f"数据形状: {X.shape}")
    print(f"实际异常值比例: {np.sum(y_true == 1) / len(y_true):.3f}")
    
    # 初始化异常值移除器
    remover = OutlierRemover(
        contamination=args.contamination,
        n_estimators=args.n_estimators,
        max_samples=args.max_samples,
        random_state=42
    )
    
    # 检测异常值
    print("开始异常值检测...")
    outlier_mask = remover.fit_detect(X)
    anomaly_scores = remover.anomaly_scores_
    
    print(f"检测到异常值数量: {np.sum(outlier_mask)}")
    print(f"预期异常值数量: {int(args.contamination * len(X))}")
    
    # 评估检测性能
    performance = evaluate_detection_performance(y_true, outlier_mask)
    
    # 移除异常值
    X_clean, y_clean = remover.remove_outliers(X, y_true)
    print(f"清洗后数据形状: {X_clean.shape}")
    print(f"移除的样本数量: {len(X) - len(X_clean)}")
    
    # 可视化对比
    visualize_comparison(X, y_true, X_clean, y_clean, outlier_mask, 
                        anomaly_scores, args.contamination)
    
    # 参数敏感性分析
    contamination_values = [0.01, 0.05, 0.1, 0.15, 0.2, 0.25]
    sensitivity_results = analyze_contamination_sensitivity(X, y_true, contamination_values)
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'original_data.npy'), X)
    np.save(os.path.join(args.output_dir, 'original_labels.npy'), y_true)
    np.save(os.path.join(args.output_dir, 'cleaned_data.npy'), X_clean)
    np.save(os.path.join(args.output_dir, 'cleaned_labels.npy'), y_clean)
    np.save(os.path.join(args.output_dir, 'outlier_mask.npy'), outlier_mask)
    np.save(os.path.join(args.output_dir, 'anomaly_scores.npy'), anomaly_scores)
    
    # 保存检测报告
    with open(os.path.join(args.output_dir, 'detection_report.txt'), 'w') as f:
        f.write("异常检测报告\n")
        f.write("="*50 + "\n")
        f.write(f"总样本数: {len(X)}\n")
        f.write(f"实际异常值: {np.sum(y_true == 1)}\n")
        f.write(f"检测异常值: {np.sum(outlier_mask)}\n")
        f.write(f"准确率: {performance['accuracy']:.4f}\n")
        f.write(f"精确率: {performance['precision']:.4f}\n")
        f.write(f"召回率: {performance['recall']:.4f}\n")
        f.write(f"F1分数: {performance['f1']:.4f}\n")
    
    print("异常值移除完成！结果已保存到", args.output_dir)

if __name__ == "__main__":
    main()
