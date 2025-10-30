#!/usr/bin/env python3
"""
自编码器异常检测工具
基于PyTorch实现深度自编码器，支持自定义网络结构
提供重构误差计算和异常分数评估，包含ROC曲线绘制
"""

import argparse
import numpy as np
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset
from sklearn.datasets import make_blobs
from sklearn.metrics import roc_curve, auc, precision_recall_curve
from sklearn.preprocessing import StandardScaler
import os
import warnings
warnings.filterwarnings('ignore')

class Autoencoder(nn.Module):
    """自编码器神经网络"""
    
    def __init__(self, input_dim, encoding_dim=32, hidden_dims=[64, 32]):
        """
        初始化自编码器
        
        参数:
        input_dim: 输入维度
        encoding_dim: 编码层维度
        hidden_dims: 隐藏层维度列表
        """
        super(Autoencoder, self).__init__()
        
        # 编码器
        encoder_layers = []
        prev_dim = input_dim
        
        for hidden_dim in hidden_dims:
            encoder_layers.append(nn.Linear(prev_dim, hidden_dim))
            encoder_layers.append(nn.ReLU())
            prev_dim = hidden_dim
        
        encoder_layers.append(nn.Linear(prev_dim, encoding_dim))
        encoder_layers.append(nn.ReLU())
        self.encoder = nn.Sequential(*encoder_layers)
        
        # 解码器（对称结构）
        decoder_layers = []
        hidden_dims_rev = hidden_dims[::-1]  # 反转隐藏层维度
        prev_dim = encoding_dim
        
        for hidden_dim in hidden_dims_rev:
            decoder_layers.append(nn.Linear(prev_dim, hidden_dim))
            decoder_layers.append(nn.ReLU())
            prev_dim = hidden_dim
        
        decoder_layers.append(nn.Linear(prev_dim, input_dim))
        # 最后一层不使用激活函数，因为要重构原始数据
        self.decoder = nn.Sequential(*decoder_layers)
    
    def forward(self, x):
        """前向传播"""
        encoded = self.encoder(x)
        decoded = self.decoder(encoded)
        return decoded

class AnomalyDetector:
    """异常检测器"""
    
    def __init__(self, input_dim, encoding_dim=32, hidden_dims=[64, 32], 
                 lr=0.001, device='cuda' if torch.cuda.is_available() else 'cpu'):
        self.device = device
        self.model = Autoencoder(input_dim, encoding_dim, hidden_dims).to(device)
        self.optimizer = optim.Adam(self.model.parameters(), lr=lr)
        self.criterion = nn.MSELoss()
        self.scaler = StandardScaler()
        self.threshold = None
    
    def fit(self, X, epochs=100, batch_size=32, validation_split=0.1, verbose=True):
        """
        训练自编码器
        
        参数:
        X: 训练数据
        epochs: 训练轮数
        batch_size: 批次大小
        validation_split: 验证集比例
        verbose: 是否显示训练进度
        """
        # 数据标准化
        X_scaled = self.scaler.fit_transform(X)
        
        # 划分训练集和验证集
        n_val = int(len(X_scaled) * validation_split)
        X_train = X_scaled[:-n_val]
        X_val = X_scaled[-n_val:]
        
        # 转换为PyTorch张量
        train_dataset = TensorDataset(torch.FloatTensor(X_train))
        val_dataset = TensorDataset(torch.FloatTensor(X_val))
        
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=batch_size)
        
        train_losses = []
        val_losses = []
        
        for epoch in range(epochs):
            # 训练阶段
            self.model.train()
            train_loss = 0
            for batch in train_loader:
                x = batch[0].to(self.device)
                
                self.optimizer.zero_grad()
                reconstructed = self.model(x)
                loss = self.criterion(reconstructed, x)
                loss.backward()
                self.optimizer.step()
                
                train_loss += loss.item()
            
            # 验证阶段
            self.model.eval()
            val_loss = 0
            with torch.no_grad():
                for batch in val_loader:
                    x = batch[0].to(self.device)
                    reconstructed = self.model(x)
                    loss = self.criterion(reconstructed, x)
                    val_loss += loss.item()
            
            avg_train_loss = train_loss / len(train_loader)
            avg_val_loss = val_loss / len(val_loader)
            
            train_losses.append(avg_train_loss)
            val_losses.append(avg_val_loss)
            
            if verbose and (epoch + 1) % 10 == 0:
                print(f'Epoch [{epoch+1}/{epochs}], Train Loss: {avg_train_loss:.6f}, Val Loss: {avg_val_loss:.6f}')
        
        # 设置异常检测阈值（基于验证集的重构误差）
        self._set_threshold(X_val)
        
        return train_losses, val_losses
    
    def _set_threshold(self, X_val):
        """基于验证集设置异常检测阈值"""
        X_val_scaled = self.scaler.transform(X_val)
        val_tensor = torch.FloatTensor(X_val_scaled).to(self.device)
        
        self.model.eval()
        with torch.no_grad():
            reconstructed = self.model(val_tensor)
            errors = torch.mean((reconstructed - val_tensor) ** 2, dim=1)
        
        # 使用95%分位数作为阈值
        self.threshold = torch.quantile(errors, 0.95).item()
    
    def predict(self, X):
        """预测异常点"""
        anomaly_scores = self.anomaly_score(X)
        return (anomaly_scores > self.threshold).astype(int)
    
    def anomaly_score(self, X):
        """计算异常分数（重构误差）"""
        X_scaled = self.scaler.transform(X)
        X_tensor = torch.FloatTensor(X_scaled).to(self.device)
        
        self.model.eval()
        with torch.no_grad():
            reconstructed = self.model(X_tensor)
            errors = torch.mean((reconstructed - X_tensor) ** 2, dim=1)
        
        return errors.cpu().numpy()

def create_sample_data(n_normal=900, n_anomaly=100, random_state=42):
    """创建示例数据（正常点+异常点）"""
    # 正常数据
    X_normal, _ = make_blobs(n_samples=n_normal, centers=2, 
                           cluster_std=0.5, random_state=random_state)
    
    # 异常数据（远离正常数据）
    rng = np.random.RandomState(random_state)
    X_anomaly = rng.uniform(low=-10, high=10, size=(n_anomaly, 2))
    
    X = np.vstack([X_normal, X_anomaly])
    y = np.array([0] * n_normal + [1] * n_anomaly)  # 0:正常, 1:异常
    
    return X, y

def plot_training_curve(train_losses, val_losses):
    """绘制训练曲线"""
    plt.figure(figsize=(10, 4))
    
    plt.subplot(1, 2, 1)
    plt.plot(train_losses, label='训练损失')
    plt.plot(val_losses, label='验证损失')
    plt.xlabel('训练轮数')
    plt.ylabel('损失')
    plt.title('训练过程')
    plt.legend()
    plt.grid(True)
    
    plt.subplot(1, 2, 2)
    plt.semilogy(train_losses, label='训练损失')
    plt.semilogy(val_losses, label='验证损失')
    plt.xlabel('训练轮数')
    plt.ylabel('损失（对数尺度）')
    plt.title('训练过程（对数尺度）')
    plt.legend()
    plt.grid(True)
    
    plt.tight_layout()
    plt.savefig('training_curve.png', dpi=300, bbox_inches='tight')
    plt.show()

def plot_roc_curve(y_true, anomaly_scores):
    """绘制ROC曲线"""
    fpr, tpr, thresholds = roc_curve(y_true, anomaly_scores)
    roc_auc = auc(fpr, tpr)
    
    plt.figure(figsize=(12, 5))
    
    plt.subplot(1, 2, 1)
    plt.plot(fpr, tpr, color='darkorange', lw=2, label=f'ROC曲线 (AUC = {roc_auc:.2f})')
    plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('假正率')
    plt.ylabel('真正率')
    plt.title('ROC曲线')
    plt.legend(loc="lower right")
    plt.grid(True)
    
    # 精确率-召回率曲线
    plt.subplot(1, 2, 2)
    precision, recall, _ = precision_recall_curve(y_true, anomaly_scores)
    pr_auc = auc(recall, precision)
    
    plt.plot(recall, precision, color='green', lw=2, label=f'PR曲线 (AUC = {pr_auc:.2f})')
    plt.xlabel('召回率')
    plt.ylabel('精确率')
    plt.title('精确率-召回率曲线')
    plt.legend(loc="lower left")
    plt.grid(True)
    
    plt.tight_layout()
    plt.savefig('roc_curve.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    return roc_auc, pr_auc

def visualize_anomalies(X, y_true, y_pred, anomaly_scores):
    """可视化异常检测结果"""
    plt.figure(figsize=(15, 5))
    
    # 真实标签
    plt.subplot(1, 3, 1)
    normal_mask = y_true == 0
    anomaly_mask = y_true == 1
    plt.scatter(X[normal_mask, 0], X[normal_mask, 1], c='blue', label='正常点', alpha=0.6)
    plt.scatter(X[anomaly_mask, 0], X[anomaly_mask, 1], c='red', label='异常点', alpha=0.6)
    plt.title('真实标签')
    plt.legend()
    
    # 预测结果
    plt.subplot(1, 3, 2)
    pred_normal = y_pred == 0
    pred_anomaly = y_pred == 1
    plt.scatter(X[pred_normal, 0], X[pred_normal, 1], c='blue', label='预测正常', alpha=0.6)
    plt.scatter(X[pred_anomaly, 0], X[pred_anomaly, 1], c='red', label='预测异常', alpha=0.6)
    plt.title('预测结果')
    plt.legend()
    
    # 异常分数热图
    plt.subplot(1, 3, 3)
    scatter = plt.scatter(X[:, 0], X[:, 1], c=anomaly_scores, cmap='viridis', alpha=0.6)
    plt.colorbar(scatter, label='异常分数')
    plt.title('异常分数分布')
    
    plt.tight_layout()
    plt.savefig('anomaly_detection.png', dpi=300, bbox_inches='tight')
    plt.show()

def main():
    parser = argparse.ArgumentParser(description='自编码器异常检测工具')
    parser.add_argument('--encoding_dim', type=int, default=2, help='编码层维度')
    parser.add_argument('--hidden_dims', type=int, nargs='+', default=[64, 32], help='隐藏层维度列表')
    parser.add_argument('--epochs', type=int, default=100, help='训练轮数')
    parser.add_argument('--batch_size', type=int, default=32, help='批次大小')
    parser.add_argument('--lr', type=float, default=0.001, help='学习率')
    parser.add_argument('--n_normal', type=int, default=900, help='正常样本数量')
    parser.add_argument('--n_anomaly', type=int, default=100, help='异常样本数量')
    parser.add_argument('--output_dir', type=str, default='results', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 创建示例数据
    print("创建示例数据...")
    X, y_true = create_sample_data(args.n_normal, args.n_anomaly)
    
    # 初始化异常检测器
    detector = AnomalyDetector(input_dim=X.shape[1], 
                              encoding_dim=args.encoding_dim,
                              hidden_dims=args.hidden_dims,
                              lr=args.lr)
    
    # 训练模型
    print("开始训练自编码器...")
    train_losses, val_losses = detector.fit(X, epochs=args.epochs, 
                                           batch_size=args.batch_size)
    
    # 预测
    y_pred = detector.predict(X)
    anomaly_scores = detector.anomaly_score(X)
    
    # 绘制训练曲线
    plot_training_curve(train_losses, val_losses)
    
    # 绘制ROC曲线
    roc_auc, pr_auc = plot_roc_curve(y_true, anomaly_scores)
    
    # 可视化结果
    visualize_anomalies(X, y_true, y_pred, anomaly_scores)
    
    # 保存结果
    np.save(os.path.join(args.output_dir, 'anomaly_scores.npy'), anomaly_scores)
    np.save(os.path.join(args.output_dir, 'predictions.npy'), y_pred)
    
    # 输出评估结果
    from sklearn.metrics import classification_report, confusion_matrix
    print("\n分类报告:")
    print(classification_report(y_true, y_pred, target_names=['正常', '异常']))
    print(f"ROC AUC: {roc_auc:.4f}")
    print(f"PR AUC: {pr_auc:.4f}")
    print(f"异常检测阈值: {detector.threshold:.6f}")
    
    print("异常检测完成！结果已保存到", args.output_dir)

if __name__ == "__main__":
    main()
