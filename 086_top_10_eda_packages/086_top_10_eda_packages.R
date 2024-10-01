# BUSINESS SCIENCE R TIPS ----
# R-TIP 86 | TOP 10 R PACKAGES FOR EXPLORATORY DATA ANALYSIS (EDA) ----

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

# TOP 14 R PACKAGES FOR EDA ----

# 1. Skimr: Summary of the dataset ----
skim(iris)

# 2. Psych: Descriptive statistics ----
describe(iris)

# 3. Corrplot: Correlation matrix visualization ----
corrplot(cor(iris[, 1:4]), method = "circle")

# 4. PerformanceAnalytics: Correlation matrix with scatterplots and histograms ----
chart.Correlation(iris[, 1:4], histogram = TRUE, pch = 19)

# 5. GGally: Scatterplot matrix with pairwise relationships ----
ggpairs(iris, columns = 1:4, aes(color = Species))

# 6. DataExplorer: Generate a full EDA report ----
create_report(iris, output_dir = "086_top_15_eda_packages/", output_file = "DataExplorer_Report.html")

# 7. Summarytools: Summary table for the dataset ----
dfSummary(iris) %>% stview()

# 8. SmartEDA: Generate a detailed EDA report in HTML ----
ExpReport(iris, op_dir = "086_top_15_eda_packages/", op_file = "SmartEDA_Report.html")

# 9. Janitor: Frequency table for a categorical variable ----
iris %>% tabyl(Species)

# 10. Inspectdf: Visualize missing values in the dataset ----
inspect_na(iris) %>% show_plot()


# BECOME A BUSINESS SCIENTIST: ----
# - Do you want to become the data science + business expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE BUSINESS SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

