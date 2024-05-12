library(shiny)
library(tidyverse)

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
