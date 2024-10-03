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
iris <- read_csv("086_top_10_eda_packages/data/iris.csv")

# TOP 10 R PACKAGES FOR EDA ----

# 1. Skimr: Summary of the dataset ----
skim(iris)

# 2. Psych: Descriptive statistics ----
describe(iris)

describe(iris) %>% gt::gt()

# 3. Corrplot: Correlation matrix visualization ----
corrplot(
    cor(iris[, 1:4]),
    method = "circle",
    addCoef.col = 'grey',
    order = 'hclust',
    rect.col = 'blue',
    addrect = 2
)

# 4. PerformanceAnalytics: Correlation matrix with scatterplots and histograms ----
chart.Correlation(
    iris[, 1:4],
    histogram = TRUE,
    pch = 19
)

# 5. GGally: Scatterplot matrix with pairwise relationships ----
ggpairs(
    data    = iris,
    columns = 1:4,
    mapping = aes(color = Species)
) +
    tidyquant::scale_fill_tq() +
    tidyquant::scale_color_tq()

# 6. DataExplorer: Generate a full EDA report ----
create_report(
    iris,
    output_dir = "086_top_10_eda_packages/",
    output_file = "DataExplorer_Report.html"
)

# 7. Summarytools: Summary table for the dataset ----
dfSummary(iris) %>% stview()

# 8. SmartEDA: Generate a detailed EDA report in HTML ----
ExpReport(
    iris,
    op_dir = "086_top_10_eda_packages/",
    op_file = "SmartEDA_Report.html"
)

# 9. Janitor: Frequency table for a categorical variable with Tabyl ----
iris %>%
    tabyl(Species) %>%
    adorn_totals("row") %>%
    adorn_pct_formatting()

iris %>%
    tabyl(Species) %>%
    adorn_totals("row") %>%
    adorn_pct_formatting() %>%
    gt::gt()

# 10. Inspectdf: Visualize missing values in the dataset ----
inspect_na(iris) %>% show_plot()
inspect_cat(iris) %>% show_plot()
inspect_cor(iris) %>% show_plot()


# BECOME A BUSINESS SCIENTIST: ----
# - Do you want to become the data science + business expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE BUSINESS SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

