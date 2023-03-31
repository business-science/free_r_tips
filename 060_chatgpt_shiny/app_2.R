library(shiny)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Monthly Expenses Calculator"),
    sidebarLayout(
        sidebarPanel(
            numericInput("rent", "Rent/mortgage payment:", value = 0, min = 0),
            numericInput("utilities", "Utilities:", value = 0, min = 0),
            numericInput("groceries", "Groceries:", value = 0, min = 0),
            numericInput("transportation", "Transportation:", value = 0, min = 0),
            numericInput("entertainment", "Entertainment:", value = 0, min = 0),
            actionButton("submit", "Submit")
        ),
        mainPanel(
            h4("Monthly Expenses:"),
            verbatimTextOutput("total"),
            plotOutput("expenses_plot")
        )
    )
)

server <- function(input, output) {
    expenses <- reactiveValues(data = data.frame(month = character(), expenses = numeric()))

    observeEvent(input$submit, {
        new_row <- data.frame(
            month = format(Sys.time(), "%Y-%m"),
            expenses = input$rent + input$utilities + input$groceries + input$transportation + input$entertainment
        )
        expenses$data <- rbind(expenses$data, new_row)
    })

    output$total <- renderText({
        expenses_sum <- sum(expenses$data$expenses)
        paste("$", round(expenses_sum, 2))
    })

    output$expenses_plot <- renderPlot({
        ggplot(expenses$data, aes(x = month, y = expenses)) +
            geom_line() +
            labs(x = "Month", y = "Expenses", title = "Total Expenses Over Time")
    })
}

shinyApp(ui = ui, server = server)

