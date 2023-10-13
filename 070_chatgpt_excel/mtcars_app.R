# Load the required packages
library(shiny)
library(readxl)
library(plotly)
library(ggplot2)
library(dplyr)
library(DT)

# Sample Data
sample_data <- data.frame(
    Date = seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "months"),
    Value = rnorm(12, mean = 50, sd = 10),
    Category = sample(c("A", "B", "C"), 12, replace = TRUE)  # Example faceting column
)

# UI
ui <- fluidPage(
    titlePanel("Upload and Visualize Excel File"),

    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose Excel File",
                      multiple = FALSE,
                      accept = c(".xlsx")
            ),
            tags$hr(),
            checkboxInput("header", "Header", TRUE),
            actionButton("loadSample", "Load Sample Data"),
            uiOutput("dateSelect"),
            uiOutput("valueSelect"),
            uiOutput("facetColUI")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Plot", plotlyOutput("plot")),
                tabPanel("Data Preview", DTOutput("tablePreview"))
            )
        )
    )
)

# Server logic
server <- function(input, output, session) {

    dataInput <- reactiveVal(sample_data)

    observeEvent(input$loadSample, {
        dataInput(sample_data)
    })

    observeEvent(input$file1, {
        inFile <- input$file1
        if (!is.null(inFile)) {
            new_data <- read_excel(inFile$datapath, 1, col_names = input$header)
            dataInput(new_data)
        }
    })

    output$dateSelect <- renderUI({
        req(dataInput())
        selectInput("selectedDate", "Select Date Column", choices = names(dataInput()), selected = NULL)
    })

    output$valueSelect <- renderUI({
        req(dataInput())
        selectInput("selectedValue", "Select Value Column", choices = names(dataInput()), selected = NULL)
    })

    output$facetColUI <- renderUI({
        choices <- c("None", names(dataInput()))
        selectInput("facetCol", "Optional Facet Column", choices, selected = "None")
    })


    output$plot <- renderPlotly({
        req(input$selectedDate, input$selectedValue)
        df <- dataInput()

        # Basic plot without faceting
        p <- ggplot(data = df, aes_string(x = input$selectedDate, y = input$selectedValue)) +
            geom_line(aes(color = "Line")) +
            geom_point(aes(color = "Points")) +
            scale_color_manual(values = c(Line = "#1f77b4", Points = "#ff7f0e")) +  # Set custom colors for line and points
            theme_minimal() +  # Minimal theme for ggplot2
            theme(
                text = element_text(size = 10),  # Reducing text size
                title = element_text(size = 12, face = "bold"),  # Title size and style
                legend.title = element_text(size = 10),  # Legend title size
                legend.text = element_text(size = 8)  # Legend text size
            )

        # If a faceting column is selected, facet the plot
        if (input$facetCol != "None") {
            p <- p + facet_wrap(as.formula(paste("~", input$facetCol))) + ggtitle(paste("Date vs. Value Plot (Faceted by", input$facetCol, ")"))
        } else {
            p <- p + ggtitle("Date vs. Value Plot")
        }

        # Convert to plotly and adjust layout properties
        p_plotly <- ggplotly(p, tooltip = c("x", "y")) %>%
            layout(
                font = list(family = "Arial", size = 10, color = "#7f7f7f"),  # Font adjustments
                plot_bgcolor = '#f7f7f7',  # Background color
                xaxis = list(title = input$selectedDate, gridcolor = "#e1e5ed"),  # x-axis adjustments
                yaxis = list(title = input$selectedValue, gridcolor = "#e1e5ed"),  # y-axis adjustments
                legend = list(bgcolor = "#f7f7f7", bordercolor = "#e1e5ed", borderwidth = 1)  # Legend adjustments
            )

        p_plotly
    })


    output$tablePreview <- renderDT({
        datatable(head(dataInput(), 5), options = list(pageLength = 5, searching = FALSE))
    })
}

# Run the application
shinyApp(ui = ui, server = server)





