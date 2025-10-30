import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import (VarianceThreshold, SelectKBest, 
                                       f_classif, mutual_info_classif,
                                       RFE, RFECV, SelectFromModel)
from sklearn.linear_model import Lasso, LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.metrics import accuracy_score, roc_auc_score
from scipy.stats import pearsonr, ttest_ind
import warnings
warnings.filterwarnings('ignore')

class FeatureSelector:
    """
    组学数据特征筛选与重要性评估工具
    
    适用于转录组、蛋白组等组学数据的特征处理，支持多种特征选择方法
    和重要性评估功能
    """
    
    def __init__(self, random_state=42):
        """初始化特征选择器"""
        self.random_state = random_state
        self.selected_features_ = None
        self.feature_importance_ = None
        self.models_ = {}
        
    def preprocess(self, X, y=None, fillna_method='median', normalize=True):
        """
        数据预处理
        
        参数:
            X: 特征矩阵 (pd.DataFrame或np.ndarray)
            y: 标签 (可选)
            fillna_method: 缺失值填充方法 ('median', 'mean'或数值)
            normalize: 是否标准化数据
            
        返回:
            预处理后的特征矩阵
        """
        # 确保输入为DataFrame
        if not isinstance(X, pd.DataFrame):
            X = pd.DataFrame(X)
        
        # 缺失值处理
        if fillna_method == 'median':
            X = X.fillna(X.median())
        elif fillna_method == 'mean':
            X = X.fillna(X.mean())
        elif isinstance(fillna_method, (int, float)):
            X = X.fillna(fillna_method)
        
        # 标准化
        if normalize:
            scaler = StandardScaler()
            X_scaled = scaler.fit_transform(X)
            X = pd.DataFrame(X_scaled, columns=X.columns, index=X.index)
            
        return X
    
    def remove_low_variance(self, X, threshold=0.01):
        """
        移除低方差特征
        
        参数:
            X: 特征矩阵
            threshold: 方差阈值
            
        返回:
            筛选后的特征矩阵
        """
        selector = VarianceThreshold(threshold=threshold)
        X_selected = selector.fit_transform(X)
        
        # 获取保留的特征名称
        mask = selector.get_support()
        self.selected_features_ = X.columns[mask].tolist()
        
        return pd.DataFrame(X_selected, columns=self.selected_features_, index=X.index)
    
    def remove_high_correlation(self, X, threshold=0.9):
        """
        移除高度相关的特征
        
        参数:
            X: 特征矩阵
            threshold: 相关系数阈值
            
        返回:
            筛选后的特征矩阵
        """
        corr_matrix = X.corr().abs()
        upper = corr_matrix.where(np.triu(np.ones(corr_matrix.shape), k=1).astype(bool))
        to_drop = [column for column in upper.columns if any(upper[column] > threshold)]
        
        self.selected_features_ = [col for col in X.columns if col not in to_drop]
        return X[self.selected_features_]
    
    def univariate_selection(self, X, y, method='f_classif', k='all'):
        """
        单变量特征选择
        
        参数:
            X: 特征矩阵
            y: 标签
            method: 评分方法 ('f_classif', 'mutual_info_classif')
            k: 保留的特征数量
            
        返回:
            筛选后的特征矩阵
        """
        if method == 'f_classif':
            selector = SelectKBest(f_classif, k=k)
        elif method == 'mutual_info_classif':
            selector = SelectKBest(mutual_info_classif, k=k)
        else:
            raise ValueError("方法不支持，请选择 'f_classif' 或 'mutual_info_classif'")
            
        X_selected = selector.fit_transform(X, y)
        
        # 获取特征分数和保留的特征
        scores = pd.Series(selector.scores_, index=X.columns)
        self.feature_importance_ = scores.sort_values(ascending=False)
        mask = selector.get_support()
        self.selected_features_ = X.columns[mask].tolist()
        
        return pd.DataFrame(X_selected, columns=self.selected_features_, index=X.index)
    
    def lasso_selection(self, X, y, alpha=0.01):
        """
        使用Lasso正则化进行特征选择
        
        参数:
            X: 特征矩阵
            y: 标签
            alpha: 正则化强度
            
        返回:
            筛选后的特征矩阵
        """
        lasso = Lasso(alpha=alpha, random_state=self.random_state)
        lasso.fit(X, y)
        
        # 提取系数不为零的特征
        mask = lasso.coef_ != 0
        self.selected_features_ = X.columns[mask].tolist()
        
        # 存储特征重要性（系数绝对值）
        self.feature_importance_ = pd.Series(
            abs(lasso.coef_[mask]), 
            index=self.selected_features_
        ).sort_values(ascending=False)
        
        self.models_['lasso'] = lasso
        return X[self.selected_features_]
    
    def tree_based_selection(self, X, y, method='random_forest', n_estimators=100, k=None):
        """
        基于树模型的特征选择
        
        参数:
            X: 特征矩阵
            y: 标签
            method: 树模型 ('random_forest', 'gradient_boosting')
            n_estimators: 树的数量
            k: 保留的特征数量，None则保留所有特征
            k: 保留的特征数量，None则保留所有特征
            
        返回:
            筛选后的特征矩阵
        """
        if method == 'random_forest':
            model = RandomForestClassifier(
                n_estimators=n_estimators,
                random_state=self.random_state,
                n_jobs=-1
            )
        elif method == 'gradient_boosting':
            model = GradientBoostingClassifier(
                n_estimators=n_estimators,
                random_state=self.random_state
            )
        else:
            raise ValueError("方法不支持，请选择 'random_forest' 或 'gradient_boosting'")
            
        model.fit(X, y)
        self.models_[method] = model
        
        # 获取特征重要性
        importances = model.feature_importances_
        self.feature_importance_ = pd.Series(
            importances, index=X.columns
        ).sort_values(ascending=False)
        
        # 选择重要性最高的k个特征
        if k is not None and k < len(X.columns):
            self.selected_features_ = self.feature_importance_.index[:k].tolist()
            return X[self.selected_features_]
        else:
            self.selected_features_ = X.columns.tolist()
            return X
    
    def rfe_selection(self, X, y, estimator=None, n_features_to_select=10, cv=5):
        """
        递归特征消除(RFE)
        
        参数:
            X: 特征矩阵
            y: 标签
            estimator: 基础模型，默认为随机森林
            n_features_to_select: 要选择的特征数量
            cv: 交叉验证折数
            
        返回:
            筛选后的特征矩阵
        """
        if estimator is None:
            estimator = RandomForestClassifier(
                n_estimators=100,
                random_state=self.random_state,
                n_jobs=-1
            )
            
        # 使用带交叉验证的RFE
        selector = RFECV(
            estimator,
            step=1,
            cv=StratifiedKFold(cv, shuffle=True, random_state=self.random_state),
            scoring='accuracy',
            min_features_to_select=n_features_to_select,
            n_jobs=-1
        )
        
        X_selected = selector.fit_transform(X, y)
        self.models_['rfe'] = selector
        
        # 存储结果
        self.selected_features_ = X.columns[selector.support_].tolist()
        self.feature_importance_ = pd.Series(
            selector.grid_scores_, index=X.columns
        ).sort_values(ascending=False)
        
        return pd.DataFrame(X_selected, columns=self.selected_features_, index=X.index)
    
    def evaluate_selection(self, X, y, model=None, cv=5):
        """
        评估筛选后特征的性能
        
        参数:
            X: 特征矩阵
            y: 标签
            model: 评估用的模型，默认为随机森林
            cv: 交叉验证折数
            
        返回:
            包含准确率和AUC的字典
        """
        if model is None:
            model = RandomForestClassifier(
                n_estimators=100,
                random_state=self.random_state,
                n_jobs=-1
            )
            
        # 交叉验证评估
        cv_acc = cross_val_score(
            model, X, y, cv=StratifiedKFold(cv, shuffle=True, random_state=self.random_state),
            scoring='accuracy'
        )
        
        cv_auc = cross_val_score(
            model, X, y, cv=StratifiedKFold(cv, shuffle=True, random_state=self.random_state),
            scoring='roc_auc'
        )
        
        # 拟合模型用于特征重要性
        model.fit(X, y)
        
        return {
            'accuracy': np.mean(cv_acc),
            'accuracy_std': np.std(cv_acc),
            'auc': np.mean(cv_auc),
            'auc_std': np.std(cv_auc)
        }
    
    def plot_feature_importance(self, top_n=20, figsize=(10, 8)):
        """
        可视化特征重要性
        
        参数:
            top_n: 显示前N个重要特征
            figsize: 图表大小
        """
        if self.feature_importance_ is None:
            raise ValueError("请先运行特征选择方法以计算特征重要性")
            
        plt.figure(figsize=figsize)
        top_features = self.feature_importance_.head(top_n)
        sns.barplot(x=top_features.values, y=top_features.index)
        plt.title(f'Top {top_n} Feature Importance', fontsize=15)
        plt.xlabel('Importance Score', fontsize=12)
        plt.ylabel('Features', fontsize=12)
        plt.tight_layout()
        return plt
    
    def compare_methods(self, X, y, methods=['univariate', 'lasso', 'random_forest'], cv=5):
        """
        比较不同特征选择方法的性能
        
        参数:
            X: 特征矩阵
            y: 标签
            methods: 要比较的方法列表
            cv: 交叉验证折数
            
        返回:
            比较结果的数据框和可视化图表
        """
        results = []
        
        for method in methods:
            if method == 'univariate':
                X_selected = self.univariate_selection(X, y, k=20)
            elif method == 'lasso':
                X_selected = self.lasso_selection(X, y, alpha=0.01)
            elif method == 'random_forest':
                X_selected = self.tree_based_selection(X, y, k=20)
            elif method == 'rfe':
                X_selected = self.rfe_selection(X, y, n_features_to_select=20)
            else:
                continue
                
            # 评估性能
            eval_res = self.evaluate_selection(X_selected, y, cv=cv)
            results.append({
                'method': method,
                'num_features': len(X_selected.columns),
                'accuracy': eval_res['accuracy'],
                'auc': eval_res['auc']
            })
        
        # 转换为数据框
        results_df = pd.DataFrame(results)
        
        # 可视化比较结果
        fig, axes = plt.subplots(1, 2, figsize=(15, 6))
        
        sns.barplot(x='method', y='accuracy', data=results_df, ax=axes[0])
        axes[0].set_title('Accuracy Comparison', fontsize=14)
        axes[0].set_ylim(0, 1)
        
        sns.barplot(x='method', y='auc', data=results_df, ax=axes[1])
        axes[1].set_title('AUC Comparison', fontsize=14)
        axes[1].set_ylim(0.5, 1)
        
        plt.tight_layout()
        
        return results_df, plt
    
    def save_results(self, output_file):
        """
        保存筛选结果
        
        参数:
            output_file: 输出文件路径
        """
        if self.selected_features_ is None:
            raise ValueError("请先运行特征选择方法")
            
        results = pd.DataFrame({
            'feature': self.selected_features_,
            'importance': [self.feature_importance_.get(f, 0) for f in self.selected_features_]
        })
        
        results = results.sort_values('importance', ascending=False)
        results.to_csv(output_file, index=False)
        print(f"结果已保存至 {output_file}")


# 使用示例
if __name__ == "__main__":
    # 生成模拟组学数据（实际使用时替换为您的数据）
    np.random.seed(42)
    n_samples = 100
    n_features = 500  # 组学数据通常有大量特征
    
    # 生成特征矩阵
    X = np.random.randn(n_samples, n_features)
    feature_names = [f'Feature_{i+1}' for i in range(n_features)]
    X = pd.DataFrame(X, columns=feature_names)
    
    # 生成标签（二元分类）
    # 让前20个特征与标签相关
    y = np.where(
        X.iloc[:, :20].sum(axis=1) > 5, 1, 0
    )
    
    # 初始化特征选择器
    fs = FeatureSelector(random_state=42)
    
    # 数据预处理
    X_processed = fs.preprocess(X)
    
    # 1. 移除低方差特征
    X_var = fs.remove_low_variance(X_processed, threshold=0.5)
    print(f"移除低方差特征后保留: {X_var.shape[1]} 个特征")
    
    # 2. 移除高度相关特征
    X_corr = fs.remove_high_correlation(X_var, threshold=0.8)
    print(f"移除高相关特征后保留: {X_corr.shape[1]} 个特征")
    
    # 3. 使用随机森林进行特征选择
    X_rf = fs.tree_based_selection(X_corr, y, method='random_forest', k=30)
    print(f"随机森林特征选择后保留: {X_rf.shape[1]} 个特征")
    
    # 4. 可视化特征重要性
    plt = fs.plot_feature_importance(top_n=15)
    plt.savefig('feature_importance.png')
    print("特征重要性图已保存为 feature_importance.png")
    
    # 5. 评估筛选后特征的性能
    performance = fs.evaluate_selection(X_rf, y, cv=5)
    print(f"筛选后特征的性能 - 准确率: {performance['accuracy']:.4f} ± {performance['accuracy_std']:.4f}")
    print(f"筛选后特征的性能 - AUC: {performance['auc']:.4f} ± {performance['auc_std']:.4f}")
    
    # 6. 比较不同特征选择方法
    results_df, plt = fs.compare_methods(X_corr, y, methods=['univariate', 'lasso', 'random_forest', 'rfe'])
    print("\n不同方法的性能比较:")
    print(results_df)
    plt.savefig('method_comparison.png')
    print("方法比较图已保存为 method_comparison.png")
    
    # 7. 保存最终结果
    fs.save_results('selected_features.csv')