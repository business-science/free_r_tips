library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Monthly Expenses Calculator"),
    sidebarLayout(
        sidebarPanel(
            selectInput("month", "Select month:", choices = month.name),
            numericInput("rent", "Rent/mortgage payment:", value = 0, min = 0),
            numericInput("utilities", "Utilities:", value = 0, min = 0),
            numericInput("groceries", "Groceries:", value = 0, min = 0),
            numericInput("transportation", "Transportation:", value = 0, min = 0),
            numericInput("entertainment", "Entertainment:", value = 0, min = 0),
            actionButton("submit", "Submit"),
            actionButton("reset", "Reset")
        ),
        mainPanel(
            h4("Monthly Expenses:"),
            verbatimTextOutput("total"),
            plotOutput("expenses_plot"),
            tableOutput("expenses_table")
        )
    )
)

server <- function(input, output, session) {
    expenses <- reactiveVal(data.frame(month = character(), rent = numeric(), utilities = numeric(), groceries = numeric(), transportation = numeric(), entertainment = numeric()))

    observeEvent(input$submit, {
        new_row <- data.frame(
            month = input$month,
            rent = input$rent,
            utilities = input$utilities,
            groceries = input$groceries,
            transportation = input$transportation,
            entertainment = input$entertainment
        )
        expenses_data <- expenses()
        expenses_data <- bind_rows(expenses_data, new_row)
        expenses_data <- expenses_data %>% arrange(month)
        expenses(expenses_data)
    })

    observeEvent(input$reset, {
        expenses(data.frame(month = character(), rent = numeric(), utilities = numeric(), groceries = numeric(), transportation = numeric(), entertainment = numeric()))
    })

    output$total <- renderText({
        expenses_sum <- sum(expenses() %>% select(-month) %>% unlist())
        paste("$", round(expenses_sum, 2))
    })

    output$expenses_plot <- renderPlot({
        expenses_melted <- expenses() %>%
            pivot_longer(cols = rent:entertainment, names_to = "category", values_to = "expenses") %>%
            mutate(month = factor(month, levels = month.name))
        ggplot(expenses_melted, aes(x = month, y = expenses, fill = category)) +
            geom_col() +
            labs(x = "Month", y = "Expenses", title = "Monthly Expenses Breakdown") +
            scale_fill_manual(values = c("#F8766D", "#00BA38", "#619CFF", "#FB9A99", "#66A61E")) +
            theme_minimal()
    })

    output$expenses_table <- renderTable({
        expenses() %>%
            pivot_longer(cols = rent:entertainment, names_to = "category", values_to = "expenses") %>%
            select(month, category, expenses) %>%
            group_by(month, category) %>%
            summarise(expenses = sum(expenses)) %>%
            pivot_wider(names_from = category, values_from = expenses)
    })
}

shinyApp(ui = ui, server = server)
