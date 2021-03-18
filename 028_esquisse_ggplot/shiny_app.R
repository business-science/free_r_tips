# R TIPS ----
# TIP 028 | Esquisse ggplot Builder ---
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# Why Shiny?
# - Example of Nostradamus (My Forecasting App built with modeltime)
#   https://business-science.shinyapps.io/nostradamus/

# LIBRARIES ----

library(esquisse)
library(modeldata)
library(shiny)

data("drinks")
data("mpg")

ui <- fluidPage(

    titlePanel("Use esquisse as a Shiny module"),

    sidebarLayout(
        sidebarPanel(
            radioButtons(
                inputId = "data",
                label = "Data to use:",
                choices = c("drinks", "mpg"),
                inline = TRUE
            )
        ),
        mainPanel(
            tabsetPanel(
                tabPanel(
                    title = "esquisse",
                    esquisserUI(
                        id = "esquisse",
                        header = FALSE, # dont display gadget title
                        choose_data = FALSE # dont display button to change data
                    )
                ),
                tabPanel(
                    title = "output",
                    verbatimTextOutput("module_out")
                )
            )
        )
    )
)


server <- function(input, output, session) {

    data_r <- reactiveValues(data = drinks, name = "drinks")

    observeEvent(input$data, {
        if (input$data == "drinks") {
            data_r$data <- drinks
            data_r$name <- "drinks"
        } else {
            data_r$data <- mpg
            data_r$name <- "mpg"
        }
    })

    result <- callModule(
        module = esquisserServer,
        id = "esquisse",
        data = data_r
    )

    output$module_out <- renderPrint({
        str(reactiveValuesToList(result))
    })

}

shinyApp(ui, server)
