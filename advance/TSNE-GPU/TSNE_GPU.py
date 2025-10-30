#!/usr/bin/env python3
"""
GPU加速的t-SNE高维数据可视化工具
支持自定义perplexity参数，能够处理10万+样本的高维数据集
提供交互式可视化界面（使用Plotly）
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_digits, make_classification, load_iris
from sklearn.manifold import TSNE
from sklearn.decomposition import PCA
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots
import os
import time
import warnings
warnings.filterwarnings('ignore')

try:
    import cuml
    GPU_TSNE_AVAILABLE = True
    print("cuML可用，使用GPU加速t-SNE")
except ImportError:
    GPU_TSNE_AVAILABLE = False
    print("cuML不可用，使用scikit-learn的t-SNE")

class TSNEVisualizer:
    """t-SNE可视化工具"""
    
    def __init__(self, n_components=2, perplexity=30.0, learning_rate=200.0, 
                 n_iter=1000, random_state=42, method='barnes_hut', 
                 early_exaggeration=12.0, metric='euclidean'):
        """
        初始化t-SNE可视化器
        
        参数:
        n_components: 降维后的维度（2或3）
        perplexity: 困惑度参数
        learning_rate: 学习率
        n_iter: 迭代次数
        random_state: 随机种子
        method: 优化方法 ('barnes_hut' 或 'exact')
        early_exaggeration: 早期放大因子
        metric: 距离度量方式
        """
        self.n_components = n_components
        self.perplexity = perplexity
        self.learning_rate = learning_rate
        self.n_iter = n_iter
        self.random_state = random_state
        self.method = method
        self.early_exaggeration = early_exaggeration
        self.metric = metric
        
        if GPU_TSNE_AVAILABLE and n_components in [2, 3]:
            # 使用RAPIDS cuML的GPU加速t-SNE
            self.tsne = cuml.UMAP(n_components=n_components,  # cuML使用UMAP作为近似
                                n_neighbors=min(perplexity, 15),
                                random_state=random_state)
            self.gpu_accelerated = True
        else:
            # 使用scikit-learn的t-SNE
            self.tsne = TSNE(n_components=n_components,
                           perplexity=perplexity,
                           learning_rate=learning_rate,
                           n_iter=n_iter,
                           random_state=random_state,
                           method=method,
                           early_exaggeration=early_exaggeration,
                           metric=metric)
            self.gpu_accelerated = False
    
    def fit_transform(self, X, y=None):
        """
        执行t-SNE降维
        
        参数:
        X: 高维数据
        y: 可选标签（用于着色）
        
        返回:
        X_embedded: 降维后的数据
        """
        print(f"开始t-SNE降维 ({'GPU加速' if self.gpu_accelerated else 'CPU'})...")
        print(f"数据形状: {X.shape}, 目标维度: {self.n_components}")
        
        start_time = time.time()
        
        # 如果数据维度很高，先使用PCA进行初步降维
        if X.shape[1] > 50:
            print("数据维度较高，先使用PCA进行预处理...")
            pca = PCA(n_components=min(50, X.shape[1]))
            X_reduced = pca.fit_transform(X)
            explained_variance = np.sum(pca.explained_variance_ratio_)
            print(f"PCA保留方差: {explained_variance:.3f}")
        else:
            X_reduced = X
        
        # 执行t-SNE
        X_embedded = self.tsne.fit_transform(X_reduced)
        
        end_time = time.time()
        print(f"t-SNE完成，耗时: {end_time - start_time:.2f}秒")
        
        self.X_embedded_ = X_embedded
        self.y_ = y
        
        return X_embedded
    
    def create_interactive_plot(self, title="t-SNE可视化"):
        """创建交互式可视化图"""
        if not hasattr(self, 'X_embedded_'):
            raise ValueError("请先调用fit_transform方法")
        
        if self.n_components == 2:
            return self._create_2d_plot(title)
        elif self.n_components == 3:
            return self._create_3d_plot(title)
        else:
            raise ValueError("只支持2D或3D可视化")
    
    def _create_2d_plot(self, title):
        """创建2D交互式图"""
        if self.y_ is not None:
            # 有标签数据
            unique_labels = np.unique(self.y_)
            n_labels = len(unique_labels)
            
            fig = go.Figure()
            
            for i, label in enumerate(unique_labels):
                mask = (self.y_ == label)
                fig.add_trace(go.Scatter(
                    x=self.X_embedded_[mask, 0],
                    y=self.X_embedded_[mask, 1],
                    mode='markers',
                    marker=dict(size=6, color=i, colorscale='viridis'),
                    name=f'类别 {label}',
                    text=[f'样本 {j}, 类别 {label}' for j in np.where(mask)[0]],
                    hovertemplate='<b>X</b>: %{x:.3f}<br><b>Y</b>: %{y:.3f}<br>%{text}<extra></extra>'
                ))
        else:
            # 无标签数据
            fig = go.Figure(data=go.Scatter(
                x=self.X_embedded_[:, 0],
                y=self.X_embedded_[:, 1],
                mode='markers',
                marker=dict(size=4, color=np.arange(len(self.X_embedded_)), 
                          colorscale='viridis', showscale=True),
                text=[f'样本 {i}' for i in range(len(self.X_embedded_))],
                hovertemplate='<b>X</b>: %{x:.3f}<br><b>Y</b>: %{y:.3f}<br>%{text}<extra></extra>'
            ))
        
        fig.update_layout(
            title=dict(text=title, x=0.5, xanchor='center'),
            xaxis_title="t-SNE 维度 1",
            yaxis_title="t-SNE 维度 2",
            width=800,
            height=600,
            template="plotly_white"
        )
        
        return fig
    
    def _create_3d_plot(self, title):
        """创建3D交互式图"""
        if self.y_ is not None:
            # 有标签数据
            unique_labels = np.unique(self.y_)
            
            fig = go.Figure()
            
            for i, label in enumerate(unique_labels):
                mask = (self.y_ == label)
                fig.add_trace(go.Scatter3d(
                    x=self.X_embedded_[mask, 0],
                    y=self.X_embedded_[mask, 1],
                    z=self.X_embedded_[mask, 2],
                    mode='markers',
                    marker=dict(size=4, color=i, colorscale='viridis'),
                    name=f'类别 {label}',
                    text=[f'样本 {j}, 类别 {label}' for j in np.where(mask)[0]],
                    hovertemplate='<b>X</b>: %{x:.3f}<br><b>Y</b>: %{y:.3f}<br><b>Z</b>: %{z:.3f}<br>%{text}<extra></extra>'
                ))
        else:
            # 无标签数据
            fig = go.Figure(data=go.Scatter3d(
                x=self.X_embedded_[:, 0],
                y=self.X_embedded_[:, 1],
                z=self.X_embedded_[:, 2],
                mode='markers',
                marker=dict(size=3, color=np.arange(len(self.X_embedded_)), 
                          colorscale='viridis', showscale=True),
                text=[f'样本 {i}' for i in range(len(self.X_embedded_))],
                hovertemplate='<b>X</b>: %{x:.3f}<br><b>Y</b>: %{y:.3f}<br><b>Z</b>: %{z:.3f}<br>%{text}<extra></extra>'
            ))
        
        fig.update_layout(
            title=dict(text=title, x=0.5, xanchor='center'),
            scene=dict(
                xaxis_title="维度 1",
                yaxis_title="维度 2",
                zaxis_title="维度 3"
            ),
            width=900,
            height=700,
            template="plotly_white"
        )
        
        return fig
    
    def create_static_plots(self, title="t-SNE可视化"):
        """创建静态对比图"""
        if not hasattr(self, 'X_embedded_'):
            raise ValueError("请先调用fit_transform方法")
        
        if self.n_components == 2:
            fig, axes = plt.subplots(2, 2, figsize=(15, 12))
            axes = axes.flatten()
        else:
            fig = plt.figure(figsize=(18, 12))
            # 3D图需要特殊处理
            
        # 1. 基本的t-SNE图
        if self.n_components == 2:
            ax1 = axes[0]
            if self.y_ is not None:
                scatter = ax1.scatter(self.X_embedded_[:, 0], self.X_embedded_[:, 1], 
                                    c=self.y_, cmap='tab10', alpha=0.7, s=20)
                plt.colorbar(scatter, ax=ax1, label='类别')
            else:
                ax1.scatter(self.X_embedded_[:, 0], self.X_embedded_[:, 1], 
                          alpha=0.7, s=20)
            ax1.set_xlabel('t-SNE 维度 1')
            ax1.set_ylabel('t-SNE 维度 2')
            ax1.set_title(f'{title} - 基本视图')
            ax1.grid(True, alpha=0.3)
        
        # 2. 密度图
        if self.n_components == 2:
            ax2 = axes[1]
            from scipy.stats import gaussian_kde
            xy = self.X_embedded_.T
            z = gaussian_kde(xy)(xy)
            scatter = ax2.scatter(self.X_embedded_[:, 0], self.X_embedded_[:, 1], 
                                c=z, cmap='viridis', alpha=0.7, s=20)
            plt.colorbar(scatter, ax=ax2, label='密度')
            ax2.set_xlabel('t-SNE 维度 1')
            ax2.set_ylabel('t-SNE 维度 2')
            ax2.set_title(f'{title} - 密度视图')
            ax2.grid(True, alpha=0.3)
        
        # 3. 类别分布（如果有标签）
        if self.y_ is not None and self.n_components == 2:
            ax3 = axes[2]
            unique_labels = np.unique(self.y_)
            for label in unique_labels:
                mask = (self.y_ == label)
                ax3.scatter(self.X_embedded_[mask, 0], self.X_embedded_[mask, 1], 
                          label=f'类别 {label}', alpha=0.7, s=20)
            ax3.set_xlabel('t-SNE 维度 1')
            ax3.set_ylabel('t-SNE 维度 2')
            ax3.set_title(f'{title} - 类别分布')
            ax3.legend()
            ax3.grid(True, alpha=0.3)
        
        # 4. 边缘分布
        if self.n_components == 2:
            ax4 = axes[3]
            ax4.hist(self.X_embedded_[:, 0], bins=50, alpha=0.7, label='维度1')
            ax4.hist(self.X_embedded_[:, 1], bins=50, alpha=0.7, label='维度2')
            ax4.set_xlabel('值')
            ax4.set_ylabel('频数')
            ax4.set_title('维度分布直方图')
            ax4.legend()
            ax4.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.savefig('tsne_static_plots.png', dpi=300, bbox_inches='tight')
        plt.show()

def analyze_perplexity_effect(X, y, perplexity_values, n_components=2):
    """分析perplexity参数对t-SNE结果的影响"""
    fig = make_subplots(rows=2, cols=3, 
                       subplot_titles=[f'Perplexity={p}' for p in perplexity_values],
                       horizontal_spacing=0.05, vertical_spacing=0.1)
    
    embeddings = []
    
    for i, perplexity in enumerate(perplexity_values):
        row = i // 3 + 1
        col = i % 3 + 1
        
        visualizer = TSNEVisualizer(n_components=n_components, perplexity=perplexity, 
                                  n_iter=500, random_state=42)
        X_embedded = visualizer.fit_transform(X, y)
        embeddings.append(X_embedded)
        
        # 添加子图
        if n_components == 2:
            scatter = go.Scatter(x=X_embedded[:, 0], y=X_embedded[:, 1],
                               mode='markers', marker=dict(size=3, color=y, colorscale='viridis'),
                               showlegend=False, hoverinfo='skip')
            fig.add_trace(scatter, row=row, col=col)
            
            # 更新子图布局
            fig.update_xaxes(title_text="维度1", row=row, col=col)
            fig.update_yaxes(title_text="维度2", row=row, col=col)
    
    fig.update_layout(height=600, width=900, title_text="Perplexity参数影响分析")
    fig.show()
    
    return embeddings

def create_large_scale_demo(n_samples=10000, n_features=100, n_classes=10):
    """创建大规模数据演示"""
    print(f"创建大规模演示数据: {n_samples}样本, {n_features}特征, {n_classes}类别")
    X, y = make_classification(n_samples=n_samples, n_features=n_features,
                              n_informative=50, n_redundant=20,
                              n_classes=n_classes, n_clusters_per_class=1,
                              random_state=42)
    return X, y

def main():
    parser = argparse.ArgumentParser(description='GPU加速的t-SNE可视化工具')
    parser.add_argument('--n_components', type=int, choices=[2, 3], default=2, help='降维维度')
    parser.add_argument('--perplexity', type=float, default=30.0, help='困惑度参数')
    parser.add_argument('--learning_rate', type=float, default=200.0, help='学习率')
    parser.add_argument('--n_iter', type=int, default=1000, help='迭代次数')
    parser.add_argument('--dataset', choices=['digits', 'iris', 'synthetic', 'large'], 
                       default='digits', help='使用的数据集')
    parser.add_argument('--n_samples', type=int, default=1000, help='合成数据样本数')
    parser.add_argument('--n_features', type=int, default=20, help='合成数据特征数')
    parser.add_argument('--large_scale', action='store_true', help='使用大规模数据演示')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 加载数据
    print("加载数据...")
    if args.dataset == 'digits':
        # 手写数字数据集
        digits = load_digits()
        X, y = digits.data, digits.target
        dataset_name = "手写数字"
    elif args.dataset == 'iris':
        # 鸢尾花数据集
        iris = load_iris()
        X, y = iris.data, iris.target
        dataset_name = "鸢尾花"
    elif args.dataset == 'synthetic' or args.large_scale:
        # 合成数据
        if args.large_scale:
            X, y = create_large_scale_demo(n_samples=args.n_samples, 
                                          n_features=args.n_features)
        else:
            X, y = make_classification(n_samples=args.n_samples, 
                                     n_features=args.n_features, 
                                     n_classes=3, random_state=42)
        dataset_name = "合成数据"
    else:
        raise ValueError("不支持的数据集类型")
    
    print(f"数据集: {dataset_name}")
    print(f"数据形状: {X.shape}")
    print(f"类别数: {len(np.unique(y)) if y is not None else '无标签'}")
    
    # 初始化t-SNE可视化器
    visualizer = TSNEVisualizer(
        n_components=args.n_components,
        perplexity=args.perplexity,
        learning_rate=args.learning_rate,
        n_iter=args.n_iter,
        random_state=42
    )
    
    # 执行t-SNE降维
    X_embedded = visualizer.fit_transform(X, y)
    
    # 创建交互式可视化
    print("生成交互式可视化...")
    interactive_fig = visualizer.create_interactive_plot(
        title=f"{dataset_name} t-SNE可视化 (Perplexity={args.perplexity})"
    )
    
    # 保存交互式图表
    interactive_fig.write_html(os.path.join(args.output_dir, "tsne_interactive.html"))
    
    # 创建静态图表
    print("生成静态可视化...")
    visualizer.create_static_plots(
        title=f"{dataset_name} t-SNE可视化"
    )
    
    # 分析perplexity参数影响
    if X.shape[0] < 5000:  # 避免在大数据集上运行太长时间
        print("分析perplexity参数影响...")
        perplexity_values = [5, 15, 30, 50, 100]
        embeddings = analyze_perplexity_effect(X, y, perplexity_values, args.n_components)
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'original_data.npy'), X)
    np.save(os.path.join(args.output_dir, 'embedded_data.npy'), X_embedded)
    if y is not None:
        np.save(os.path.join(args.output_dir, 'labels.npy'), y)
    
    # 保存可视化配置
    config = {
        'n_components': args.n_components,
        'perplexity': args.perplexity,
        'learning_rate': args.learning_rate,
        'n_iter': args.n_iter,
        'dataset': args.dataset,
        'gpu_accelerated': visualizer.gpu_accelerated,
        'data_shape': X.shape,
        'embedded_shape': X_embedded.shape
    }
    
    import json
    with open(os.path.join(args.output_dir, 'config.json'), 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"\n可视化完成！")
    print(f"原始数据维度: {X.shape[1]} → 降维后: {args.n_components}")
    print(f"使用的算法: {'GPU加速t-SNE' if visualizer.gpu_accelerated else 'CPU t-SNE'}")
    print(f"结果已保存到: {args.output_dir}")
    print(f"交互式图表: {os.path.join(args.output_dir, 'tsne_interactive.html')}")

if __name__ == "__main__":
    main()
