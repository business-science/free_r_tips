# BUSINESS SCIENCE R TIPS ----
# R-TIP 70 | ChatGPT: Excel Spreadsheet Analyzer ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# PROMPT 1: ----
#  Start by making a shiny app that uploads a users excel file.

# PROMPT 2: ----
# Add a way to visualize the date column (automatically selected) versus a value column from the excel file.

# PROMPT 3: ----
# Include some sample data for the user to get started with.

# LEARNING MORE: LIVE CHATGPT FOR DATA SCIENTISTS WORKSHOP ----
# 👉 Register Here: https://learn.business-science.io/registration-chatgpt-2?el=youtube

# FINAL SHINY APP CODE ----

# Load necessary libraries
library(shiny)
library(readxl)
library(ggplot2)

# Sample data
sample_data <- data.frame(
    date = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "months"),
    sales = c(150, 200, 250, 220, 280, 300, 320, 310, 280, 270, 250, 240),
    expenses = c(100, 120, 110, 105, 115, 130, 125, 130, 125, 120, 115, 110)
)

# Define the user interface for the app
ui <- fluidPage(
    titlePanel("Excel File Upload with Visualization"),

    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose Excel File",
                      multiple = FALSE,
                      accept = c(".xlsx")
            ),
            tags$hr(),
            actionButton("loadSample", "Load Sample Data"),
            tags$hr(),
            h5(helpText("Select the Excel file from your computer or load sample data.")),
            actionButton("submit", "Submit"),
            selectInput("valueCol", "Choose a value column:", ""),
            tags$hr(),
            h5(helpText("After uploading, select the value column you want to plot against the date."))
        ),

        mainPanel(
            tableOutput("contents"),
            plotOutput("datePlot")
        )
    )
)

# Define server logic required
server <- function(input, output, session) {

    data <- reactiveVal()  # To store the data

    observeEvent(input$loadSample, {
        data(sample_data)
        updateSelectInput(session, "valueCol", choices = setdiff(names(sample_data), "date"))
        output$contents <- renderTable(data())
    })

    observeEvent(input$submit, {
        inFile <- input$file1

        if (is.null(inFile))
            return(NULL)

        uploaded_data <- read_excel(inFile$datapath)
        data(uploaded_data)

        # Update the selectInput choices (assuming date column is always named 'date')
        updateSelectInput(session, "valueCol", choices = setdiff(names(uploaded_data), "date"))

        # Display the data in the main panel
        output$contents <- renderTable(data())
    })

    # Create the plot
    output$datePlot <- renderPlot({
        if(is.null(input$valueCol) || input$valueCol == "") return(NULL)

        ggplot(data(), aes_string(x = "date", y = input$valueCol)) +
            geom_line() +
            labs(title = paste("Date vs.", input$valueCol),
                 x = "Date", y = input$valueCol)
    })

}

# Run the app
shinyApp(ui, server)
