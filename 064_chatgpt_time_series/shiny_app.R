
# Load necessary libraries
library(shiny)
library(tidyverse)
library(lubridate)
library(timetk)
library(modeltime)
library(tidymodels)
library(plotly)

ui <- fluidPage(
    titlePanel("Time Series Forecasting with Modeltime"),
    sidebarLayout(
        sidebarPanel(
            fileInput('file1', 'Choose CSV File',
                      accept=c('text/csv',
                               'text/comma-separated-values,text/plain',
                               '.csv')),
            numericInput('forecast_horizon', "Enter Forecast Horizon", value = 90, min = 1),
            selectInput("model", "Choose a model", choices = c("XGBoost", "ARIMA")),
            tags$hr()
        ),
        mainPanel(
            plotlyOutput("plot1"),
            plotlyOutput("plot2")
        )
    )
)

server <- function(input, output) {
    data <- reactive({
        req(input$file1)
        df <- read_csv(input$file1$datapath)
        df
    })

    splits_cal <- reactive({
        req(input$file1)

        # Split the data
        splits <- initial_time_split(data(), prop = 0.8)

        splits

    })

    model_cal <- reactive({
        req(input$file1)

        if (input$model == "ARIMA") {
            # Define the model
            model_spec <- arima_reg() %>%
                set_engine("auto_arima") %>%
                set_mode("regression")

            # Define a recipe
            rec <- recipe(value ~ date, data = training(splits_cal()))
        } else {
            # Define the model
            model_spec <- boost_tree() %>%
                set_engine("xgboost") %>%
                set_mode("regression")

            rec <- recipe(value ~ date, data = training(splits_cal())) %>%
                step_timeseries_signature(date) %>%
                step_dummy(all_nominal_predictors(), one_hot = TRUE) %>%
                step_rm(date)
        }



        # Fit the model
        model_fit <- workflow() %>%
            add_model(model_spec) %>%
            add_recipe(rec) %>%
            fit(data = training(splits_cal()))

        # Calibrate the model
        modeltime_calibrate(model_fit, testing(splits_cal()))
    })

    output$plot1 <- renderPlotly({
        req(model_cal())

        # Generate a forecast
        model_forecast <- model_cal() %>%
            modeltime_forecast(
                new_data    = testing(splits_cal()),
                actual_data = data()
            )

        # Plot the forecast
        model_forecast %>%
            plot_modeltime_forecast()
    })

    output$plot2 <- renderPlotly({
        req(model_cal())

        # Recalibrate the model using the testing data
        model_fit_recalibrated <- modeltime_refit(
            model_cal(),
            data = data()
        )

        # Generate a forecast
        model_forecast_recalibrated <- model_fit_recalibrated %>%
            modeltime_forecast(
                new_data = future_frame(data(), .length_out = input$forecast_horizon),
                actual_data = data()
            )

        # Plot the recalibrated forecast
        model_forecast_recalibrated %>%
            plot_modeltime_forecast()
    })
}

shinyApp(ui = ui, server = server)
