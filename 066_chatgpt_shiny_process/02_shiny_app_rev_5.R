library(modeltime)
library(tidymodels)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(readxl)
library(tidyverse)
library(lubridate)
library(gt)
library(timetk)
library(trelliscopejs)

observe <- shiny::observe

# Define UI for the app
ui <- navbarPage(
    theme = shinythemes::shinytheme("cyborg"),
    title = "Pro Forma Financial Statement Forecaster",

    # First tab: Upload and display Excel data
    tabPanel(
        title = "Upload Excel",
        sidebarLayout(
            sidebarPanel(
                fileInput("file1", "Choose Excel File", accept = c(".xlsx")),
                # Dropdown to select sheet
                uiOutput("sheet_ui")
            ),
            mainPanel(
                # Display selected sheet name
                textOutput("selected_sheet"),
                gt_output("table1")  # Change this line
            )
        )
    ),

    # Second tab: Trelliscope
    tabPanel(
        title = "Visualize Financial Statement",
        textOutput("go_to_step_3"),
        trelliscopeOutput("trelliscope_view_1") %>% withSpinner(color="#0dc5c1")

    ),

    # Third tab:
    tabPanel(
        title = "Forecast Financial Statement",
        sidebarLayout(
            sidebarPanel(
                sliderInput("forecast_horizon", "Select a Forecast Horizon", value = 3, min = 1, max = 10),
                selectizeInput("model_selection", "Choose models",
                               choices = c("ARIMA", "ETS", "XGBoost", "GLMNET"),
                               selected = "ARIMA", multiple = TRUE),
                actionButton("run_forecast", "Run Forecast")
            ),
            mainPanel(
                # Display selected sheet name
                trelliscopeOutput("trelliscope_view_2") %>% withSpinner(color="#0dc5c1")

            )
        )
    ),
)

# Define server logic
server <- function(input, output, session) {

    # reactive values
    rv <- reactiveValues()

    # Reactive function to return list of sheet names from the uploaded Excel file
    observe({
        inFile <- input$file1
        if (!is.null(inFile)) {
            sheets <- excel_sheets(inFile$datapath)
            # Update the selectInput choices based on sheet names
            updateSelectInput(session, "sheet_name", choices = sheets, selected = sheets[1])
        }
    })

    # Generate dropdown UI for sheets
    output$sheet_ui <- renderUI({
        inFile <- input$file1
        if (is.null(inFile)) {
            return(NULL)
        }
        tagList(
            selectInput("sheet_name", "Choose a sheet:", choices = NULL),
            p("Proceed to Tab 2 to visualize the financial statement")
        )
    })

    # Display the selected sheet name
    output$selected_sheet <- renderText({
        req(input$sheet_name)
        paste("Selected Sheet:", input$sheet_name)
    })

    # Reactive function to read data when a new file is uploaded and a sheet is selected
    data <- reactive({

        inFile    <- input$file1
        sheetName <- input$sheet_name

        if (is.null(inFile) || is.null(sheetName)) {
            return(NULL)
        }

        df <- read_excel(
            path  = inFile$datapath,
            sheet = sheetName,
            skip  = 1
        ) %>%
            mutate_if(is.numeric, .funs = function(x) ifelse(is.na(x), 0, x))

        df_long <- df %>%
            pivot_longer(cols = -1) %>%
            rename("id" = 1) %>%
            mutate(date = lubridate::make_date(year = str_replace(name, "FY '", "20")))

        rv$df_long <- df_long

        rv$df <- df

        print("df_long")
        print(df_long)

        df

    })

    # Generate table output to display data
    output$table1 <- render_gt({

        req(data())

        data() %>%
            gt() %>%
            tab_options(
                table.background.color = "transparent",
                table.font.color = "white"
            ) %>%
            fmt_currency(
                columns    = -1,
                decimals   = 0,
                accounting = TRUE,
            )
    })

    output$trelliscope_view_1 <- renderTrelliscope({

        req(rv$df_long)

        rv$map_plot <- rv$df_long %>%
            mutate(id = as_factor(id)) %>%
            mutate(id_index = as.numeric(id)) %>%
            nest(data = !one_of("id", "id_index")) %>%
            mutate(panel = map_plot(data, function(x) {
                plot_time_series(
                    x, date, value,
                    .y_intercept = 0,
                    .interactive = FALSE,
                    .title       = NULL
                )
            }))

        rv$map_plot %>%
            trelliscope(
                name = "time_series_visual_1",
                path = "www",
                self_contained = TRUE,
                state = list(sort = list(sort_spec("id_index")))
            )
    })

    # Display the next step
    output$go_to_step_3 <- renderText({
        req(rv$map_plot)
        "Please proceed to tab 3 when you are ready to forecast."
    })

    observeEvent(input$run_forecast, {

        req(rv$df_long)

        withProgress(message = "Forecasting...", value = 0, {

            rv$nested_data_tbl <- rv$df_long %>%
                select(id, date, value) %>%
                extend_timeseries(
                    .id_var        = id,
                    .date_var      = date,
                    .length_future = input$forecast_horizon
                ) %>%

                # ** Add x-regs ----
                # mutate(
                #     category_oil_shock = case_when(
                #         year(date) <= 2014            ~ "pre-oil-shock",
                #         year(date) %in% c(2015, 2016) ~ "oil-shock",
                #         year(date) > 2016             ~ "post-oil-shock"
                #     ) %>%
                #         as.factor()
                # ) %>%

                nest_timeseries(
                    .id_var        = id,
                    .length_future = input$forecast_horizon
                ) %>%
                    split_nested_timeseries(
                        .length_test   = input$forecast_horizon
                    )

            print("nested_data_tbl")
            print(rv$nested_data_tbl)


            recipe_xreg_simple <- recipe(value ~ ., data = extract_nested_train_split(rv$nested_data_tbl))


            model_arima <- arima_reg(seasonal_period = 1) %>%
                set_engine("auto_arima")

            wflw_arima <- workflow() %>%
                add_model(model_arima) %>%
                add_recipe(recipe_xreg_simple) %>%
                fit(extract_nested_train_split(rv$nested_data_tbl))

            model_ets <- exp_smoothing(seasonal_period = 1) %>%
                set_engine("ets")

            wflw_ets <- workflow() %>%
                add_model(model_ets) %>%
                add_recipe(recipe_xreg_simple) %>%
                fit(extract_nested_train_split(rv$nested_data_tbl))

            incProgress(amount = 0.2, message = "Round 1: Fitting models.")


            rv$nested_modeltime_tbl <- modeltime_nested_fit(

                # Nested data
                nested_data = rv$nested_data_tbl,

                # Individual models
                # wflw_arima,
                wflw_ets,

                # Hyper parameter lists
                # model_list = c(model_list_xgboost, model_list_glmnet),

                control = control_nested_fit(verbose = TRUE)
            )

            incProgress(amount = 0.5, message = "Round 1 of fitting complete.")

            rv$nested_best_tbl <- rv$nested_modeltime_tbl %>%
                modeltime_nested_select_best(
                    metric                = "rmse",
                    minimize              = TRUE,
                    filter_test_forecasts = TRUE
                )

            rv$nested_best_refit_tbl <- rv$nested_best_tbl %>%
                modeltime_nested_refit(
                    control = control_nested_refit(verbose = TRUE)
                )

            incProgress(amount = 0.3, message = "Round 2 of fitting complete.")


            print(
                rv$nested_best_refit_tbl %>%
                    extract_nested_future_forecast()
            )

        })

    })

    output$trelliscope_view_2 <- renderTrelliscope({

        req(rv$nested_best_refit_tbl)

        rv$map_plot_2 <- rv$nested_best_refit_tbl %>%
            extract_nested_future_forecast() %>%
            mutate(id = as_factor(id)) %>%
            mutate(id_index = as.numeric(id)) %>%
            nest(data = !one_of("id", "id_index")) %>%
            mutate(panel = map_plot(data, function(x) {
                plot_modeltime_forecast(
                    x,
                    .interactive = FALSE,
                    .title       = NULL
                )
            }))

        rv$map_plot_2 %>%
            trelliscope(
                name = "Financial Statement Forecast",
                path = "www",
                self_contained = TRUE,
                state = list(sort = list(sort_spec("id_index")))
            )
    })

}

# Run the application
shinyApp(ui = ui, server = server)
