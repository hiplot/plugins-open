## [Group-comparison Heatmap](/basic/group-comparison)

This plugin provides a way to compare multiple variables across multiple (>2) groups and visualize the result with heatmap.

When the reference group is not set, let's say you have A,B,C 3 groups, then this plugin will

- Compare A and B+C
- Compare B and A+C
- Compare C and A+B

If reference groups set to A, then

- Compare A and B
- Compare A and C

If you have discrete variable, only binary is valid, you can use `TRUE`/`P` for positive
case and `FALSE`/`N` for negative case.

