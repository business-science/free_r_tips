library(shiny)

ui <- fluidPage(
    titlePanel("Monthly Expenses Calculator"),
    sidebarLayout(
        sidebarPanel(
            numericInput("rent", "Rent/mortgage payment:", value = 0, min = 0),
            numericInput("utilities", "Utilities:", value = 0, min = 0),
            numericInput("groceries", "Groceries:", value = 0, min = 0),
            numericInput("transportation", "Transportation:", value = 0, min = 0),
            numericInput("entertainment", "Entertainment:", value = 0, min = 0)
        ),
        mainPanel(
            h4("Monthly Expenses:"),
            verbatimTextOutput("total")
        )
    )
)

server <- function(input, output) {
    output$total <- renderText({
        expenses <- input$rent + input$utilities + input$groceries + input$transportation + input$entertainment
        paste("$", round(expenses, 2))
    })
}

shinyApp(ui = ui, server = server)
