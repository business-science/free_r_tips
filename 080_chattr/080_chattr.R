# BUSINESS SCIENCE R TIPS ----
# R-TIP 80 | Chattr ----

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

# INSTALL:
remotes::install_github("mlverse/chattr")

# LOAD LIBRARY
library(chattr)

# SET UP YOU OPENAI API KEY
Sys.setenv("OPENAI_API_KEY" = "XXXXXX")

# PICK THE MODEL TO USE (gpt4 or gpt35)
chattr_use("gpt35")

# RUN CHATTR SHINY APP AS A JOB (SO YOU CAN STILL USE YOUR CONSOLE)
chattr_app(as_job = TRUE)

# 1.0 loading a file

# QUESTION:
# How to open the data set that is in the folder 080_chattr/data/marketing_campaign.csv?

# ANSWER:
library(readr)

data <- read_csv("080_chattr/data/marketing_campaign.csv")

data

# QUESTION:

# THE DATA SET LOOKS LIKE THIS. HOW TO MAKE A MINIMAL SHINY APP TO EXPLORE THE DATA?
# > data
# A tibble: 2,240 × 29
# ID Year_Birth Education  Marital_Status Income Kidhome Teenhome Dt_Customer Recency MntWines MntFruits
# <dbl>      <dbl> <chr>      <chr>           <dbl>   <dbl>    <dbl> <chr>         <dbl>    <dbl>     <dbl>
#     1  5524       1957 Graduation Single          58138       0        0 04-09-2012       58      635        88
# 2  2174       1954 Graduation Single          46344       1        1 08-03-2014       38       11         1
# 3  4141       1965 Graduation Together        71613       0        0 21-08-2013       26      426        49
# 4  6182       1984 Graduation Together        26646       1        0 10-02-2014       26       11         4
# 5  5324       1981 PhD        Married         58293       1        0 19-01-2014       94      173        43
# 6  7446       1967 Master     Together        62513       0        1 09-09-2013       16      520        42
# 7   965       1971 Graduation Divorced        55635       0        1 13-11-2012       34      235        65
# 8  6177       1985 PhD        Married         33454       1        0 08-05-2013       32       76        10
# 9  4855       1974 PhD        Together        30351       1        0 06-06-2013       19       14         0
# 10  5899       1950 PhD        Together         5648       1        1 13-03-2014       68       28         0
# # ℹ 2,230 more rows
# # ℹ 18 more variables: MntMeatProducts <dbl>, MntFishProducts <dbl>, MntSweetProducts <dbl>, MntGoldProds <dbl>,
# #   NumDealsPurchases <dbl>, NumWebPurchases <dbl>, NumCatalogPurchases <dbl>, NumStorePurchases <dbl>,
# #   NumWebVisitsMonth <dbl>, AcceptedCmp3 <dbl>, AcceptedCmp4 <dbl>, AcceptedCmp5 <dbl>, AcceptedCmp1 <dbl>,
# #   AcceptedCmp2 <dbl>, Complain <dbl>, Z_CostContact <dbl>, Z_Revenue <dbl>, Response <dbl>
# # ℹ Use `print(n = ...)` to see more rows
#

# ANSWER

library(shiny)

ui <- fluidPage(
    titlePanel("Customer Data Explorer"),
    sidebarLayout(
        sidebarPanel(
            selectInput("x_var", "X-axis variable", choices = colnames(data)),
            selectInput("y_var", "Y-axis variable", choices = colnames(data)),
            numericInput("obs", "Number of observations to show", value =10)
        ),
        mainPanel(
            plotOutput("scatterplot"),
            tableOutput("table")
        )
    )
)

server <- function(input, output) {
    output$scatterplot <- renderPlot({
        ggplot(data = data, aes_string(x = input$x_var, y = input$y_var)) +
            geom_point()
    })

    output$table <- renderTable({
        head(data, n = input$obs)
    })
}

shinyApp(ui = ui, server = server)
