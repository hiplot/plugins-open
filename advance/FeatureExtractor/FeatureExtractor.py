#!/usr/bin/env python3
"""
多模态特征提取工具
支持ResNet50(图像)和BERT(文本)特征提取
输出固定维度的特征向量，支持.npy格式保存
"""

import argparse
import numpy as np
import os
import torch
import torch.nn as nn
from PIL import Image
import torchvision.transforms as transforms
import torchvision.models as models
from transformers import BertTokenizer, BertModel
import json
from typing import Union, List

class ImageFeatureExtractor:
    """图像特征提取器（基于ResNet50）"""
    
    def __init__(self, device='cuda' if torch.cuda.is_available() else 'cpu'):
        self.device = device
        self.model = models.resnet50(pretrained=True)
        # 移除最后的分类层，获取2048维特征
        self.model = nn.Sequential(*list(self.model.children())[:-1])
        self.model.eval()
        self.model.to(device)
        
        # 图像预处理
        self.transform = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406],
                               std=[0.229, 0.224, 0.225]),
        ])
    
    def extract(self, image_path: str) -> np.ndarray:
        """从单张图像提取特征"""
        image = Image.open(image_path).convert('RGB')
        image_tensor = self.transform(image).unsqueeze(0).to(self.device)
        
        with torch.no_grad():
            features = self.model(image_tensor)
        
        return features.squeeze().cpu().numpy().flatten()
    
    def extract_batch(self, image_paths: List[str]) -> np.ndarray:
        """批量提取图像特征"""
        features = []
        for path in image_paths:
            features.append(self.extract(path))
        return np.array(features)

class TextFeatureExtractor:
    """文本特征提取器（基于BERT）"""
    
    def __init__(self, model_name='bert-base-uncased', device='cuda' if torch.cuda.is_available() else 'cpu'):
        self.device = device
        self.tokenizer = BertTokenizer.from_pretrained(model_name)
        self.model = BertModel.from_pretrained(model_name)
        self.model.to(device)
        self.model.eval()
    
    def extract(self, text: str, pooling_strategy='mean') -> np.ndarray:
        """从单条文本提取特征"""
        inputs = self.tokenizer(text, return_tensors='pt', truncation=True, 
                               padding=True, max_length=512)
        inputs = {k: v.to(self.device) for k, v in inputs.items()}
        
        with torch.no_grad():
            outputs = self.model(**inputs)
        
        if pooling_strategy == 'mean':
            # 平均池化
            features = outputs.last_hidden_state.mean(dim=1)
        elif pooling_strategy == 'cls':
            # CLS token
            features = outputs.last_hidden_state[:, 0, :]
        
        return features.squeeze().cpu().numpy()
    
    def extract_batch(self, texts: List[str], pooling_strategy='mean') -> np.ndarray:
        """批量提取文本特征"""
        features = []
        for text in texts:
            features.append(self.extract(text, pooling_strategy))
        return np.array(features)

class MultiModalFeatureExtractor:
    """多模态特征提取器"""
    
    def __init__(self):
        self.image_extractor = ImageFeatureExtractor()
        self.text_extractor = TextFeatureExtractor()
    
    def extract_image_features(self, image_paths: List[str]) -> np.ndarray:
        """提取图像特征"""
        return self.image_extractor.extract_batch(image_paths)
    
    def extract_text_features(self, texts: List[str]) -> np.ndarray:
        """提取文本特征"""
        return self.text_extractor.extract_batch(texts)
    
    def save_features(self, features: np.ndarray, filepath: str):
        """保存特征到.npy文件"""
        np.save(filepath, features)
        print(f"特征已保存到: {filepath}")

def create_sample_data(output_dir: str):
    """创建示例数据"""
    # 创建示例图像（使用随机数据模拟）
    image_dir = os.path.join(output_dir, 'sample_images')
    os.makedirs(image_dir, exist_ok=True)
    
    # 创建一些随机图像文件（实际使用时替换为真实图像）
    sample_images = []
    for i in range(5):
        # 在实际应用中这里应该创建真实图像文件
        # 这里我们用文件名代替
        img_path = os.path.join(image_dir, f'sample_{i}.jpg')
        sample_images.append(img_path)
        print(f"创建示例图像: {img_path}")
    
    # 示例文本
    sample_texts = [
        "This is a sample sentence for feature extraction.",
        "Machine learning is a fascinating field of study.",
        "Natural language processing helps computers understand human language.",
        "Deep learning models can extract meaningful features from data.",
        "Feature extraction is an important step in many AI applications."
    ]
    
    return sample_images, sample_texts

def main():
    parser = argparse.ArgumentParser(description='多模态特征提取工具')
    parser.add_argument('--mode', type=str, choices=['image', 'text', 'both'], 
                       default='both', help='提取模式')
    parser.add_argument('--image_dir', type=str, help='图像目录路径')
    parser.add_argument('--text_file', type=str, help='文本文件路径')
    parser.add_argument('--output_dir', type=str, default='features', help='输出目录')
    
    args = parser.parse_args()
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 初始化特征提取器
    extractor = MultiModalFeatureExtractor()
    
    if args.mode in ['image', 'both']:
        print("处理图像特征提取...")
        
        if args.image_dir:
            # 从指定目录加载图像
            image_paths = [os.path.join(args.image_dir, f) for f in os.listdir(args.image_dir) 
                          if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
        else:
            # 使用示例数据
            print("使用示例图像数据...")
            image_paths, sample_texts = create_sample_data(args.output_dir)
        
        if image_paths:
            image_features = extractor.extract_image_features(image_paths)
            extractor.save_features(image_features, os.path.join(args.output_dir, 'image_features.npy'))
            print(f"提取了 {len(image_paths)} 张图像的特征，特征维度: {image_features.shape}")
    
    if args.mode in ['text', 'both']:
        print("处理文本特征提取...")
        
        if args.text_file and os.path.exists(args.text_file):
            # 从文件加载文本
            with open(args.text_file, 'r', encoding='utf-8') as f:
                texts = [line.strip() for line in f if line.strip()]
        else:
            # 使用示例文本
            print("使用示例文本数据...")
            if 'sample_texts' not in locals():
                _, sample_texts = create_sample_data(args.output_dir)
            texts = sample_texts
        
        if texts:
            text_features = extractor.extract_text_features(texts)
            extractor.save_features(text_features, os.path.join(args.output_dir, 'text_features.npy'))
            print(f"提取了 {len(texts)} 条文本的特征，特征维度: {text_features.shape}")
    
    # 保存元数据
    metadata = {
        'feature_dim': {
            'image': image_features.shape[1] if 'image_features' in locals() else 0,
            'text': text_features.shape[1] if 'text_features' in locals() else 0
        },
        'num_samples': {
            'image': len(image_paths) if 'image_paths' in locals() else 0,
            'text': len(texts) if 'texts' in locals() else 0
        }
    }
    
    with open(os.path.join(args.output_dir, 'metadata.json'), 'w') as f:
        json.dump(metadata, f, indent=2)
    
    print("特征提取完成！")

if __name__ == "__main__":
    main()
