## [GEP-defind AML subtypes](/clinical-tools/clinaml-gep)

- Introduction

  Bagging models to predict the GEP-defined AML subtypes.
  
  G1: PML-RARA
  
  G2: CBFB-MYH11
  
  G3: RUNX1-RUNXT1
  
  G4: Bialleic CEBPA
  
  G5: ...
  
  G6: NPM1/KMT2A/NUP98...

- Extra parameters

  Data normalization method: deseq2 vst or log2 (tpm + 1)

  Model: xgboost or autogluon

- Other notes

  Gene symbols of models are based on the hg38 GENCODE v34 gene annotation file

  'label' row is only used to check results for users and will be automatically removed in the program