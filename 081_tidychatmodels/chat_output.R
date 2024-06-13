

library(shiny)
library(plotly)
library(readxl)

ui <- fluidPage(
    titlePanel("Dynamic Plotly Visualization with User Data Upload"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Upload Excel or CSV File", accept = c(".csv", ".xlsx")),
            uiOutput("xcol"),
            uiOutput("ycol")
        ),
        mainPanel(
            plotlyOutput("plot")
        )
    )
)

server <- function(input, output, session) {
    data <- reactive({
        req(input$file)
        ext <- tools::file_ext(input$file$name)
        if (ext == "csv") {
            read.csv(input$file$datapath)
        } else if (ext == "xlsx") {
            read_excel(input$file$datapath)
        } else {
            mtcars
        }
    })

    output$xcol <- renderUI({
        req(data())
        selectInput("xcol", "X-Axis Variable", choices = names(data()))
    })

    output$ycol <- renderUI({
        req(data())
        selectInput("ycol", "Y-Axis Variable", choices = names(data()))
    })

    output$plot <- renderPlotly({
        req(input$xcol, input$ycol)
        plot_ly(data(), x = ~get(input$xcol), y = ~get(input$ycol), type = 'scatter', mode = 'markers')
    })
}

shinyApp(ui, server)

