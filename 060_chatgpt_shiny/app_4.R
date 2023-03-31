# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)

# Define UI
ui <- fluidPage(

    # Page title
    titlePanel("Monthly Expenses Calculator"),

    # Input form
    sidebarLayout(
        sidebarPanel(
            selectInput("month", "Select Month:", choices = month.name, selected = "January"),
            numericInput("housing", "Housing:", 0, min = 0),
            numericInput("utilities", "Utilities:", 0, min = 0),
            numericInput("transportation", "Transportation:", 0, min = 0),
            numericInput("food", "Food:", 0, min = 0),
            numericInput("entertainment", "Entertainment:", 0, min = 0),
            numericInput("miscellaneous", "Miscellaneous:", 0, min = 0),
            actionButton("add", "Add Expenses"),
            actionButton("reset", "Reset Expenses")
        ),

        # Output table and graph
        mainPanel(
            tabsetPanel(
                tabPanel("Expenses Table", tableOutput("expensesTable")),
                tabPanel("Expenses Graph", plotOutput("expensesPlot"))
            )
        )
    )
)

# Define server
server <- function(input, output) {

    # Initialize empty expenses data frame
    expenses <- reactiveVal(data.frame(
        Month = character(),
        Housing = numeric(),
        Utilities = numeric(),
        Transportation = numeric(),
        Food = numeric(),
        Entertainment = numeric(),
        Miscellaneous = numeric(),
        stringsAsFactors = FALSE
    ))

    # Add expenses for current month
    observeEvent(input$add, {
        expensesNew <- data.frame(
            Month = input$month,
            Housing = input$housing,
            Utilities = input$utilities,
            Transportation = input$transportation,
            Food = input$food,
            Entertainment = input$entertainment,
            Miscellaneous = input$miscellaneous,
            stringsAsFactors = FALSE
        )
        expenses(expenses() %>% bind_rows(expensesNew))
    })

    # Reset expenses data frame
    observeEvent(input$reset, {
        expenses(data.frame(
            Month = character(),
            Housing = numeric(),
            Utilities = numeric(),
            Transportation = numeric(),
            Food = numeric(),
            Entertainment = numeric(),
            Miscellaneous = numeric(),
            stringsAsFactors = FALSE
        ))
    })

    # Calculate monthly expenses by category and month
    expensesByMonth <- reactive({
        expenses() %>%
            group_by(Month) %>%
            summarize(
                Housing = sum(Housing),
                Utilities = sum(Utilities),
                Transportation = sum(Transportation),
                Food = sum(Food),
                Entertainment = sum(Entertainment),
                Miscellaneous = sum(Miscellaneous)
            )
    })

    # Render output table
    output$expensesTable <- renderTable({
        expensesByMonth()
    }, rownames = FALSE)

    # Render output graph
    output$expensesPlot <- renderPlot({
        ggplot(expensesByMonth(), aes(x = Month, y = Housing, fill = "Housing")) +
            geom_col(position = "dodge") +
            geom_col(aes(y = Utilities, fill = "Utilities"), position = "dodge") +
            geom_col(aes(y = Transportation, fill = "Transportation"), position = "dodge") +
            geom_col(aes(y = Food, fill = "Food"), position = "dodge") +
            geom_col(aes(y = Entertainment, fill = "Entertainment"), position = "dodge") +
            geom_col(aes(y = Miscellaneous, fill = "Miscellaneous"), position = "dodge") +
            scale_fill_manual(values = c("Housing" = "darkblue", "Utilities" = "lightblue",
                                       "Transportation" = "green", "Food" = "orange",
                                       "Entertainment" = "purple", "Miscellaneous" = "brown"),
                            name = "Expense Category") +
            labs(title = "Monthly Expenses by Category", x = "Month", y = "Monthly Expense") +
            theme_bw()

    })

}

shinyApp(ui, server)
