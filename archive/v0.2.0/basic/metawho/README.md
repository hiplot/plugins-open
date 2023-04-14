## [Metawho](/basic/metawho)

- Introduction

The goal of metawho is to provide simple R implementation of “Meta-analytical method to Identify Who Benefits Most from Treatments”.

metawho is powered by R package metafor and does not support dataset contains individuals for now. Please use stata package ipdmetan if you are more familar with stata code.

- Usage

  - `data`: a table contains at least columns 'trial' (for trial id), 'hr' (for hazard ratio), 'ci.lb' (for lower boundary of hazard ratio), 'ci.ub' (for upper boundary of hazard ratio) and 'ni' (number of sample).
  - `conf_level`: set the confidence interval coresponding to the 'ci.lb' and 'ci.ub', typically is 0.95.