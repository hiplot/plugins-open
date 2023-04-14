## [Heatmap Decision Tree](/basic/treeheatr)

- Introduction

  The heatmap decision tree is a visualization graph that combines two types of graphs: heatmap and decision tree visualization.

- Case data analysis

  The first column is the name of the species, the second column is the island, and the rest are the species characteristics.

- Graphic interpretation of case statistics

  The upper half of the figure is a decision diagram, and the lower half is a heat map.

  Decision tree: The topmost island has the greatest influence on the classification of species, and can be classified into different species according to different conditions.

  Heatmap: you can observe the changes in the amount of each species under each condition.

  Legend: For each categorical variable, different colors indicate different types; for continuous variables, the higher the value, the lighter the color, otherwise, the darker.
  
- Extra parameters

  Display mode: heat-tree: draw a heat map decision tree diagram; heat-only: draw only a heat map; tree-only: draw a decision tree diagram only.

  The relative size of the heat map: 0 means no heat map; 1 means only heat map. That is, the proportion of the height of the heat map relative to the entire heat map decision tree.

  Graphic spacing: the spacing between the heat map and the decision tree diagram.

  Relative level weight: Relative weight of child node positions according to their levels, commonly ranges from 1 to 1.5. 1 for parent node perfectly in the middle of child nodes.

  Leaf node clustering: Logical. If TRUE, target/label is included in hierarchical clustering of samples within each leaf node and might yield a more interpretable heatmap.

  Sample clustering: Logical. If TRUE, hierarchical clustering would be performed among samples within each leaf node.

  Continuous variable legend: whether to display the color legend of the continuous variable of the heat map.

  Categorical variable legend: whether to display the color legend of the categorical variable of the heat map.
