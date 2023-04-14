## [ROC](/basic/roc)

- Introduction

  Receiver operating characteristic curve (ROC curve) is used to describe the diagnostic ability of binary classifier system when its recognition threshold changes.

- Analysis of case data

  The loaded data are the outcomes of one column of dichotomous variables and three columns of different variables (diagnostic indicators) and their values.

- Interpretation of case statistics graphics

  There is no functional relationship between specificity on the horizontal axis and sensitivity on the vertical axis.The closer the curve is to the upper left corner, the better the predictive ability of the diagnostic index is.Each color represented a variable (diagnostic indicator), and the blue and red curves were significantly better predictors than the green curves.AUC is the area under ROC curve.AUC=1 indicates that there is at least one threshold on the curve that leads to a perfect prediction.0.5<AUC<1, better than random guess, appropriate selection of threshold value, can have predictive value. AUC=0.5, like random guesses, the model has no predictive value. If AUC<0.5, the possible reason is that the dichotomy variable such as (0,1) is reversed with the ending setting, and the result assignment can be reversed.In this diagram, it can be considered that Am variable has the best predictive ability as shown in value-Am(86.9792)>value-GG(84.3750)>value-EL(56.7708).

- Extra parameters

  Add interval:Shape means to draw a confidence interval with color, bars means to draw a confidence interval with vertical bars, and no means not to draw a confidence interval.

  Smooth Curve:make a step diagram into a smooth curve.

  Evaluation Modle:

  Compare Modles:

