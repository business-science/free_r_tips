# R TIPS ----
# TIP 027 | Gentle Introduction to Shiny ---
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# Why Shiny?
# - Example of Nostradamus (My Forecasting App built with modeltime)
#   https://business-science.shinyapps.io/nostradamus/

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



# LIBRARIES ----

# Shiny
library(shiny)
library(bslib)

# Modeling
library(modeldata)
library(DataExplorer)

# Widgets
library(plotly)

# Core
library(tidyverse)


# LOAD DATASETS ----
utils::data("stackoverflow", "car_prices", "Sacramento", package = "modeldata")

data_list = list(
    "StackOverflow" = stackoverflow,
    "Car Prices"    = car_prices,
    "Sacramento Housing" = Sacramento
)

# 1.0 USER INTERFACE ----
ui <- navbarPage(

    title = "Data Explorer",

    theme = bslib::bs_theme(version = 4, bootswatch = "minty"),

    tabPanel(
        title = "Explore",

        sidebarLayout(

            sidebarPanel(
                width = 3,
                h1("Explore a Dataset"),

                # Requires Reactive Programming Knowledge
                # - Taught in Shiny Dashboards (DS4B 102-R)
                shiny::selectInput(
                    inputId = "dataset_choice",
                    label   = "Data Connection",
                    choices = c("StackOverflow", "Car Prices", "Sacramento Housing")
                ),

                # Requires Boostrap Knowledge
                # - Taught in Shiny Developer with AWS (DS4B 202A-R)
                hr(),
                h3("Apps by Business Science"),
                p("Go from beginner to building full-stack shiny apps."),
                p("Learn Shiny Today!") %>%
                    a(
                        href = 'https://www.business-science.io/',
                        target = "_blank",
                        class = "btn btn-lg btn-primary"
                    ) %>%
                    div(class = "text-center")


            ),

            mainPanel(
                h1("Correlation"),
                plotlyOutput("corrplot", height = 700)
            )
        )

    )


)

# 2.0 SERVER ----
server <- function(input, output) {

    # REACTIVE PROGRAMMING  ----
    # - Taught in Shiny Dashboards & Shiny Developer Courses

    rv <- reactiveValues()

    observe({

        rv$data_set <- data_list %>% pluck(input$dataset_choice)

    })

    output$corrplot <- renderPlotly({

        g <- DataExplorer::plot_correlation(rv$data_set)

        plotly::ggplotly(g)
    })

}

# Run the application
shinyApp(ui = ui, server = server)
