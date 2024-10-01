# BUSINESS SCIENCE R TIPS ----
# R-TIP 86 | TOP 14 R PACKAGES FOR EXPLORATORY DATA ANALYSIS (EDA) ----

# LIBRARIES & DATA ----

# Install necessary packages
install.packages(c("skimr", "psych", "corrplot", "PerformanceAnalytics", "GGally",
                   "DataExplorer", "summarytools", "SmartEDA", "janitor", "inspectdf"))

# Load required libraries
library(skimr)
library(psych)
library(corrplot)
library(PerformanceAnalytics)
library(GGally)
library(DataExplorer)
library(summarytools)
library(SmartEDA)
library(janitor)
library(inspectdf)

library(tidyverse)

# Load example data
data(iris)

# 1. Skimr: Summary of the dataset
skim(iris)

# 2. Psych: Descriptive statistics
describe(iris)

# 3. Corrplot: Correlation matrix visualization
cor_matrix <- cor(iris[, 1:4])
corrplot(cor_matrix, method = "circle")

# 4. PerformanceAnalytics: Correlation matrix with scatterplots and histograms
chart.Correlation(iris[, 1:4], histogram = TRUE, pch = 19)

# 5. GGally: Scatterplot matrix with pairwise relationships
ggpairs(iris, columns = 1:4, aes(color = Species))

# 6. DataExplorer: Generate a full EDA report
create_report(iris)

# 7. Summarytools: Summary table for the dataset
dfSummary(iris)

# 8. SmartEDA: Generate a detailed EDA report in HTML
ExpReport(iris, op_file = "EDA_Report.html")

# 9. Janitor: Frequency table for a categorical variable
iris %>%
    tabyl(Species)

# 10. Inspectdf: Visualize missing values in the dataset
inspect_na(iris) %>% show_plot()

# 11. Corrplot: Visualize correlations with significance levels
corrplot.mixed(cor_matrix, lower = "circle", upper = "number", tl.cex = 0.7)

# 12. GGally: Customizable scatterplot matrix for visual exploration
ggpairs(iris, columns = 1:4, ggplot2::aes(color = Species),
        upper = list(continuous = "points"),
        lower = list(continuous = "smooth"),
        diag = list(continuous = "densityDiag"))

# 13. PerformanceAnalytics: Customize the correlation plot aesthetics
chart.Correlation(iris[, 1:4], histogram = FALSE, pch = 21,
                  col = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3"))

# 14. Janitor: Clean column names for better readability
iris_cleaned <- iris %>% clean_names()
print(iris_cleaned)

# 15. Inspectdf: Compare variable types between two dataframes
setosa_versicolor <- iris[iris$Species %in% c("setosa", "versicolor"), ]
inspect_types(iris, setosa_versicolor) %>% show_plot()
