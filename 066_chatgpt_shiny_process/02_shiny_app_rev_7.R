library(modeltime)
library(tidymodels)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(readxl)
library(writexl)
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

    # Second tab:
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

    # First tab: Upload and display Excel data
    tabPanel(
        title = "Download Pro-Forma Excel",
        sidebarLayout(
            sidebarPanel(
                p("Download the Pro-Forma Financial Statement"),
                downloadButton("download_excel", "Download Excel"),
            ),
            mainPanel(
                gt_output("table2")  # Change this line
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

            model_list <- list()

            recipe_xreg_simple <- recipe(value ~ ., data = extract_nested_train_split(rv$nested_data_tbl))

            recipe_xreg_ml <- recipe_xreg_simple %>%
                step_timeseries_signature(date) %>%
                step_select(value, date_index.num, date_year)

            if ("ARIMA" %in% input$model_selection) {

                model_arima <- arima_reg(seasonal_period = 1) %>%
                    set_engine("auto_arima")

                wflw_arima <- workflow() %>%
                    add_model(model_arima) %>%
                    add_recipe(recipe_xreg_simple) %>%
                    fit(extract_nested_train_split(rv$nested_data_tbl))

                model_list <- c(model_list, list(wflw_arima))
            }

            if ("ETS" %in% input$model_selection) {
                model_ets <- exp_smoothing(seasonal_period = 1) %>%
                    set_engine("ets")

                wflw_ets <- workflow() %>%
                    add_model(model_ets) %>%
                    add_recipe(recipe_xreg_simple) %>%
                    fit(extract_nested_train_split(rv$nested_data_tbl))

                model_list <- c(model_list, list(wflw_ets))
            }


            if ("XGBoost" %in% input$model_selection) {
                model_xgb <- boost_tree("regression") %>%
                    set_engine("xgboost")

                wflw_xgb <- workflow() %>%
                    add_model(model_xgb) %>%
                    add_recipe(recipe_xreg_ml) %>%
                    fit(extract_nested_train_split(rv$nested_data_tbl))

                model_list <- c(model_list, list(wflw_xgb))
            }

            if ("GLMNET" %in% input$model_selection) {
                model_glmnet <- linear_reg(penalty = 0.1) %>%
                    set_engine("glmnet")

                wflw_glmnet <- workflow() %>%
                    add_model(model_glmnet) %>%
                    add_recipe(recipe_xreg_ml) %>%
                    fit(extract_nested_train_split(rv$nested_data_tbl))

                model_list <- c(model_list, list(wflw_glmnet))
            }


            print(model_list)
            mod_list <<- model_list

            incProgress(amount = 0.2, message = "Round 1: Fitting models.")


            rv$nested_modeltime_tbl <- modeltime_nested_fit(

                # Nested data
                nested_data = rv$nested_data_tbl,

                # Individual models
                # wflw_arima,
                # wflw_ets,

                # Hyper parameter lists
                # model_list = c(model_list_xgboost, model_list_glmnet),
                model_list = model_list,

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
                name = "financial_statement_forecast",
                path = "www",
                self_contained = TRUE,
                state = list(sort = list(sort_spec("id_index")))
            )
    })

    # Generate table output to display data
    output$table2 <- render_gt({

        req(rv$nested_best_refit_tbl)

        rv$proforma_tbl <- rv$nested_best_refit_tbl %>%
            extract_nested_future_forecast() %>%
            filter(.key == "prediction") %>%
            select(id, .index, .value) %>%
            mutate(
                fiscal_year_id = year(.index) %>%
                    as.character() %>%
                    str_sub(3),
                fiscal_year_id = str_glue("FY '{fiscal_year_id}") %>% as.character()
            ) %>%
            select(-.index) %>%
            pivot_wider(
                names_from = fiscal_year_id,
                values_from = .value
            )

        print(rv$proforma_tbl)

        proforma_short_tbl <- rv$proforma_tbl %>% select(-id)

        rv$ret <- data() %>%
            bind_cols(
                proforma_short_tbl
            )

        rv$ret %>%
            gt() %>%
            tab_options(
                table.background.color = "transparent",
                table.font.color = "white"
            ) %>%
            fmt_currency(
                columns    = -1,
                decimals   = 0,
                accounting = TRUE,
            ) %>%
            tab_style(
                style = cell_text("green"),
                locations = cells_body(
                    columns = one_of(names(proforma_short_tbl))
                )
            )
    })

    # Excel download logic
    output$download_excel <- downloadHandler(
        filename = function() {
            paste("data-", Sys.Date(), ".xlsx", sep="")
        },
        content = function(file) {
            writexl::write_xlsx(rv$ret, path = file)
        }
    )

}

# Run the application
shinyApp(ui = ui, server = server)
