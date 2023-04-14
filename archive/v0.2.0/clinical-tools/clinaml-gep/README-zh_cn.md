## [AML 基因表达亚型](/clinical-tools/clinaml-gep)

- 简介

  集成模型用于预测 AML 基因表达亚型。
  
  G1: PML-RARA
  
  G2: CBFB-MYH11
  
  G3: RUNX1-RUNXT1
  
  G4: Bialleic CEBPA
  
  G5: ...
  
  G6: NPM1/KMT2A/NUP98...

- 额外参数

  数据标准化方法：deseq2 vst 或 log2 (tpm + 1)

  模型：xgboost 或 autogluon

- 其他说明

  模型训练数据的基因名基于 hg38 GENCODE v34 基因注释文件

  'label' 行只用于检查最终结果的准确度，输入程序后会自动删除