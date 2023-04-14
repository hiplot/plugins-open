## [Cox Models Forest](/basic/ezcox)

- Introduction

  Cox model forest  is a visual representation of a COX model that constructs a risk forest map to facilitate variable screening

- Analysis of case data

  The loaded data are time,status and multiple variable factor.

- Interpretation of case statistics graphics

  The first column of the table shows the variables and sample numbers, the second column shows the forest plot, and the third column shows the CI 95% confidence interval range, its mean and P values.
  
  Forest map interpretation.
  
  The middle vertical line represents the invalid line, the horizontal line represents the 95% confidence interval of the variable factor, and the length represents the magnitude of the confidence interval. If the confidence interval of a variable factor intersects the invalid line, the variable factor is considered to have no statistical significance, and the position of the square is the point estimation of HR.
  
  Age is the control variable.
  
  The incidence of the ph.ecog factor is greater than that of the age factor, and the ph.ecog factor increases the occurrence of survival (P&LT;0.001, statistically significant).
  
  The incidence of sex is less than that of age, and sex reduces the incidence of survival (P =0.002&lt;0.05, statistically significant).

- Extra parameters

  Merge Models:Integrate multiple variable factors into an icon.

  Drop Controls:Remove the row of the age variable in the diagram.

  Add Caption:Mark the title below the icon to the right.

