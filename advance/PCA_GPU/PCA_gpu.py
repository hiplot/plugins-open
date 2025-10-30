#!/usr/bin/env python3
"""
基于GPU加速的主成分分析(PCA)降维工具
使用PyTorch实现GPU加速，支持大型数据集处理和多种可视化功能
"""

import argparse
import logging
import time
import os
import sys
from pathlib import Path

import numpy as np
import torch
import torch.nn.functional as F
from torch.utils.data import DataLoader, TensorDataset

# 可视化相关库
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MaxNLocator

# 数据加载库
import pandas as pd
import h5py

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial']
plt.rcParams['axes.unicode_minus'] = False

class GPUPCA:
    """
    GPU加速的PCA实现类
    """
    
    def __init__(self, n_components=None, method='svd', device='auto', batch_size=1000):
        """
        初始化GPU PCA
        
        参数:
            n_components: 主成分数量，如果为小数则表示解释方差比例
            method: PCA计算方法 ('svd' 或 'covariance')
            device: 计算设备 ('auto', 'cuda', 'cpu')
            batch_size: 批处理大小
        """
        self.n_components = n_components
        self.method = method
        self.batch_size = batch_size
        self.fitted = False
        
        # 自动选择设备
        if device == 'auto':
            self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        else:
            self.device = torch.device(device)
            
        logging.info(f"使用设备: {self.device}")
        
        # 初始化属性
        self.components_ = None
        self.explained_variance_ = None
        self.explained_variance_ratio_ = None
        self.mean_ = None
        self.singular_values_ = None
        self.total_variance_ = None
        
    def _check_device_memory(self, data_size):
        """检查GPU内存是否足够"""
        if self.device.type == 'cuda':
            total_memory = torch.cuda.get_device_properties(0).total_memory
            free_memory = torch.cuda.memory_reserved(0) - torch.cuda.memory_allocated(0)
            required_memory = data_size * 4 * 10  # 估算所需内存
            
            if required_memory > free_memory * 0.8:  # 使用不超过80%的剩余内存
                logging.warning("GPU内存可能不足，考虑减小批处理大小或使用CPU")
                return False
        return True
    
    def _standardize_data(self, X):
        """数据标准化"""
        if isinstance(X, np.ndarray):
            X = torch.from_numpy(X).float()
        
        self.mean_ = X.mean(dim=0, keepdim=True)
        X_centered = X - self.mean_
        
        # 标准差标准化
        std = X_centered.std(dim=0, keepdim=True)
        std[std == 0] = 1.0  # 避免除零
        X_standardized = X_centered / std
        
        return X_standardized
    
    def _process_in_batches(self, X, func):
        """分批处理大型数据集"""
        n_samples = X.shape[0]
        results = []
        
        for i in range(0, n_samples, self.batch_size):
            end_idx = min(i + self.batch_size, n_samples)
            batch = X[i:end_idx].to(self.device)
            batch_result = func(batch)
            results.append(batch_result.cpu())
            
            # 清理GPU内存
            del batch, batch_result
            if self.device.type == 'cuda':
                torch.cuda.empty_cache()
                
        return torch.cat(results, dim=0)
    
    def fit(self, X):
        """
        训练PCA模型
        
        参数:
            X: 输入数据 (n_samples, n_features)
        """
        start_time = time.time()
        logging.info("开始训练PCA模型...")
        
        # 数据验证
        if isinstance(X, np.ndarray):
            X = torch.from_numpy(X).float()
        elif not isinstance(X, torch.Tensor):
            raise ValueError("输入数据必须是numpy数组或PyTorch张量")
        
        original_shape = X.shape
        logging.info(f"输入数据形状: {original_shape}")
        
        # 检查内存
        if not self._check_device_memory(X.nelement()):
            logging.warning("切换到CPU处理")
            self.device = torch.device('cpu')
        
        # 数据标准化
        X_standardized = self._standardize_data(X)
        X_standardized = X_standardized.to(self.device)
        
        n_samples, n_features = X_standardized.shape
        
        if self.method == 'svd':
            # 使用SVD方法
            logging.info("使用SVD方法计算主成分...")
            U, S, Vt = torch.svd(X_standardized)
            
            self.components_ = Vt.T
            self.singular_values_ = S
            self.explained_variance_ = (S ** 2) / (n_samples - 1)
            
        elif self.method == 'covariance':
            # 使用协方差矩阵方法
            logging.info("使用协方差矩阵方法计算主成分...")
            covariance_matrix = torch.matmul(X_standardized.T, X_standardized) / (n_samples - 1)
            
            # 特征分解
            eigenvalues, eigenvectors = torch.linalg.eigh(covariance_matrix)
            
            # 按特征值降序排列
            idx = eigenvalues.argsort(descending=True)
            eigenvalues = eigenvalues[idx]
            eigenvectors = eigenvectors[:, idx]
            
            self.components_ = eigenvectors
            self.explained_variance_ = eigenvalues
            self.singular_values_ = torch.sqrt(eigenvalues * (n_samples - 1))
        
        # 计算解释方差比例
        self.total_variance_ = self.explained_variance_.sum()
        self.explained_variance_ratio_ = self.explained_variance_ / self.total_variance_
        
        # 确定主成分数量
        if self.n_components is not None:
            if isinstance(self.n_components, float) and 0 < self.n_components < 1:
                # 按解释方差比例选择
                cumulative_variance = torch.cumsum(self.explained_variance_ratio_, dim=0)
                self.n_components_ = torch.sum(cumulative_variance <= self.n_components).item() + 1
                self.n_components_ = min(self.n_components_, n_features)
            else:
                self.n_components_ = min(int(self.n_components), n_features)
        else:
            self.n_components_ = n_features
        
        logging.info(f"选择 {self.n_components_} 个主成分")
        
        # 只保留选择的主成分
        self.components_ = self.components_[:, :self.n_components_]
        self.explained_variance_ = self.explained_variance_[:self.n_components_]
        self.explained_variance_ratio_ = self.explained_variance_ratio_[:self.n_components_]
        self.singular_values_ = self.singular_values_[:self.n_components_]
        
        self.fitted = True
        training_time = time.time() - start_time
        logging.info(f"PCA训练完成，耗时: {training_time:.2f}秒")
        
        return self
    
    def transform(self, X):
        """将数据转换到主成分空间"""
        if not self.fitted:
            raise ValueError("必须先调用fit方法训练模型")
        
        if isinstance(X, np.ndarray):
            X = torch.from_numpy(X).float()
        
        # 数据标准化
        X_standardized = self._standardize_data(X)
        X_standardized = X_standardized.to(self.device)
        
        # 投影到主成分空间
        def transform_batch(batch):
            return torch.matmul(batch, self.components_)
        
        X_transformed = self._process_in_batches(X_standardized, transform_batch)
        
        return X_transformed.cpu().numpy()
    
    def fit_transform(self, X):
        """训练并转换数据"""
        self.fit(X)
        return self.transform(X)
    
    def get_cumulative_variance(self):
        """获取累积解释方差"""
        if not self.fitted:
            raise ValueError("模型未训练")
        return torch.cumsum(self.explained_variance_ratio_, dim=0).cpu().numpy()


class PCAPlotter:
    """PCA结果可视化类"""
    
    def __init__(self, output_dir='./pca_results'):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
    def plot_explained_variance(self, pca_model, figsize=(10, 6)):
        """绘制解释方差比例图"""
        plt.figure(figsize=figsize)
        
        explained_variance = pca_model.explained_variance_ratio_.cpu().numpy()
        cumulative_variance = np.cumsum(explained_variance)
        
        # 创建子图
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=figsize)
        
        # 解释方差比例图
        ax1.bar(range(1, len(explained_variance) + 1), explained_variance, alpha=0.6, color='skyblue')
        ax1.set_xlabel('主成分')
        ax1.set_ylabel('解释方差比例')
        ax1.set_title('主成分解释方差比例')
        ax1.grid(True, alpha=0.3)
        
        # 累积解释方差比例图
        ax2.plot(range(1, len(cumulative_variance) + 1), cumulative_variance, 
                marker='o', linewidth=2, markersize=4)
        ax2.axhline(y=0.95, color='r', linestyle='--', alpha=0.7, label='95%方差')
        ax2.axhline(y=0.90, color='g', linestyle='--', alpha=0.7, label='90%方差')
        ax2.set_xlabel('主成分数量')
        ax2.set_ylabel('累积解释方差比例')
        ax2.set_title('累积解释方差比例')
        ax2.legend()
        ax2.grid(True, alpha=0.3)
        ax2.yaxis.set_major_locator(MaxNLocator(10))
        
        plt.tight_layout()
        plt.savefig(self.output_dir / 'explained_variance.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        logging.info("解释方差比例图已保存")
    
    def plot_scree_plot(self, pca_model, figsize=(8, 6)):
        """绘制碎石图"""
        explained_variance = pca_model.explained_variance_.cpu().numpy()
        
        plt.figure(figsize=figsize)
        plt.plot(range(1, len(explained_variance) + 1), explained_variance, 
                'o-', linewidth=2, markersize=6)
        plt.xlabel('主成分')
        plt.ylabel('特征值')
        plt.title('PCA碎石图')
        plt.grid(True, alpha=0.3)
        
        plt.savefig(self.output_dir / 'scree_plot.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        logging.info("碎石图已保存")
    
    def plot_loadings(self, pca_model, feature_names=None, n_components=2, figsize=(12, 8)):
        """绘制主成分载荷图"""
        if feature_names is None:
            feature_names = [f'Feature_{i}' for i in range(pca_model.components_.shape[0])]
        
        loadings = pca_model.components_[:n_components].T.cpu().numpy()
        
        plt.figure(figsize=figsize)
        
        for i in range(min(n_components, 2)):
            if i == 0:
                plt.scatter(loadings[:, 0], loadings[:, 1], alpha=0.6)
                for j, feature in enumerate(feature_names):
                    plt.annotate(feature, (loadings[j, 0], loadings[j, 1]), 
                               xytext=(5, 5), textcoords='offset points', fontsize=8)
                plt.xlabel('主成分1')
                plt.ylabel('主成分2')
            else:
                break
        
        plt.axhline(y=0, color='grey', linestyle='-', alpha=0.3)
        plt.axvline(x=0, color='grey', linestyle='-', alpha=0.3)
        plt.title('主成分载荷图')
        plt.grid(True, alpha=0.3)
        
        plt.savefig(self.output_dir / 'loadings_plot.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        logging.info("主成分载荷图已保存")
    
    def plot_transformed_data(self, transformed_data, labels=None, figsize=(10, 8)):
        """绘制降维后的数据散点图"""
        plt.figure(figsize=figsize)
        
        if labels is not None:
            unique_labels = np.unique(labels)
            for label in unique_labels:
                mask = labels == label
                plt.scatter(transformed_data[mask, 0], transformed_data[mask, 1], 
                          label=f'Class {label}', alpha=0.7, s=30)
            plt.legend()
        else:
            plt.scatter(transformed_data[:, 0], transformed_data[:, 1], alpha=0.7, s=30)
        
        plt.xlabel('主成分1')
        plt.ylabel('主成分2')
        plt.title('PCA降维结果（前两个主成分）')
        plt.grid(True, alpha=0.3)
        
        plt.savefig(self.output_dir / 'transformed_data.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        logging.info("降维结果散点图已保存")


def load_data(file_path, format_type='auto', label_column=None):
    """加载数据文件"""
    if format_type == 'auto':
        format_type = Path(file_path).suffix.lower()[1:]  # 去除点号
    
    logging.info(f"加载{format_type.upper()}文件: {file_path}")
    
    if format_type == 'csv':
        data = pd.read_csv(file_path)
        if label_column is not None and label_column in data.columns:
            labels = data[label_column].values
            features = data.drop(columns=[label_column]).values
        else:
            labels = None
            features = data.values
            
    elif format_type == 'npy':
        data = np.load(file_path)
        if data.ndim == 2:
            features = data
            labels = None
        else:
            raise ValueError("NPY文件应该是2维数组")
            
    elif format_type in ['h5', 'hdf5']:
        with h5py.File(file_path, 'r') as f:
            # 获取第一个数据集
            dataset_name = list(f.keys())[0]
            features = f[dataset_name][:]
            labels = None
            
    else:
        raise ValueError(f"不支持的格式: {format_type}")
    
    logging.info(f"加载数据形状: {features.shape}")
    return features, labels


def setup_logging(log_level='INFO'):
    """设置日志配置"""
    logging.basicConfig(
        level=getattr(logging, log_level.upper()),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('pca_analysis.log')
        ]
    )


def main():
    """主函数：命令行接口"""
    parser = argparse.ArgumentParser(description='GPU加速的PCA降维工具')
    
    # 输入输出参数
    parser.add_argument('--input', '-i', required=True, help='输入文件路径')
    parser.add_argument('--output', '-o', default='./pca_results', help='输出目录')
    parser.add_argument('--format', '-f', choices=['csv', 'npy', 'hdf5', 'auto'], 
                       default='auto', help='输入文件格式')
    
    # PCA参数
    parser.add_argument('--components', '-c', type=float, default=0.95,
                       help='主成分数量（整数）或解释方差比例（0-1小数）')
    parser.add_argument('--method', '-m', choices=['svd', 'covariance'], 
                       default='svd', help='PCA计算方法')
    
    # 设备参数
    parser.add_argument('--device', '-d', choices=['auto', 'cuda', 'cpu'], 
                       default='auto', help='计算设备')
    parser.add_argument('--batch_size', '-b', type=int, default=1000,
                       help='批处理大小')
    
    # 数据参数
    parser.add_argument('--label_column', help='标签列名（CSV文件）')
    parser.add_argument('--log_level', default='INFO', help='日志级别')
    
    args = parser.parse_args()
    
    # 设置日志
    setup_logging(args.log_level)
    
    try:
        # 加载数据
        features, labels = load_data(args.input, args.format, args.label_column)
        
        # 创建PCA实例
        pca = GPUPCA(
            n_components=args.components,
            method=args.method,
            device=args.device,
            batch_size=args.batch_size
        )
        
        # 执行PCA
        start_time = time.time()
        transformed_data = pca.fit_transform(features)
        end_time = time.time()
        
        logging.info(f"PCA处理完成，耗时: {end_time - start_time:.2f}秒")
        logging.info(f"降维后数据形状: {transformed_data.shape}")
        
        # 保存结果
        output_dir = Path(args.output)
        output_dir.mkdir(exist_ok=True)
        
        np.save(output_dir / 'transformed_data.npy', transformed_data)
        if labels is not None:
            np.save(output_dir / 'labels.npy', labels)
        
        # 可视化
        plotter = PCAPlotter(output_dir)
        plotter.plot_explained_variance(pca)
        plotter.plot_scree_plot(pca)
        plotter.plot_transformed_data(transformed_data, labels)
        
        # 保存模型信息
        model_info = {
            'n_components': pca.n_components_,
            'explained_variance_ratio': pca.explained_variance_ratio_.cpu().numpy(),
            'total_variance': pca.total_variance_.cpu().item(),
            'processing_time': end_time - start_time
        }
        
        with open(output_dir / 'model_info.txt', 'w') as f:
            for key, value in model_info.items():
                f.write(f"{key}: {value}\n")
        
        logging.info(f"所有结果已保存到: {output_dir}")
        
    except Exception as e:
        logging.error(f"处理过程中发生错误: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    # 示例使用代码
    logging.info("GPU加速PCA降维工具示例")
    
    # 生成示例数据
    np.random.seed(42)
    n_samples, n_features = 1000, 50
    X = np.random.randn(n_samples, n_features)
    
    # 添加一些相关性以创建有意义的PCA
    X[:, 10:20] = X[:, 0:10] * 0.5 + np.random.randn(n_samples, 10) * 0.1
    
    logging.info(f"示例数据形状: {X.shape}")
    
    # 使用GPU PCA
    pca = GPUPCA(n_components=0.95, device='auto', batch_size=500)
    
    start_time = time.time()
    X_transformed = pca.fit_transform(X)
    end_time = time.time()
    
    logging.info(f"PCA完成，耗时: {end_time - start_time:.2f}秒")
    logging.info(f"原始数据维度: {X.shape[1]}")
    logging.info(f"降维后维度: {X_transformed.shape[1]}")
    logging.info(f"解释方差比例: {pca.explained_variance_ratio_.sum().cpu().item():.3f}")
    
    # 可视化结果
    plotter = PCAPlotter('./example_results')
    plotter.plot_explained_variance(pca)
    plotter.plot_scree_plot(pca)
    plotter.plot_transformed_data(X_transformed)
    
    logging.info("示例运行完成，结果保存在 ./example_results 目录")
