library(shiny)
library(shinythemes)
library(readxl)
library(tidyverse)

# Define UI for the app
ui <- navbarPage(
    theme = shinythemes::shinytheme("cyborg"),
    title = "Pro Forma Financial Forecaster",

    # First tab: Upload and display Excel data
    tabPanel("Upload Excel",
             sidebarLayout(
                 sidebarPanel(
                     fileInput("file1", "Choose Excel File", accept = c(".xlsx")),
                     # Dropdown to select sheet
                     uiOutput("sheet_ui")
                 ),
                 mainPanel(
                     # Display selected sheet name
                     textOutput("selected_sheet"),
                     tableOutput("table1")
                 )
             )),

    # Second tab: Placeholder for other content
    tabPanel("Another Page",
             h2("Content for another page can be added here"))
)

# Define server logic
server <- function(input, output, session) {

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
        selectInput("sheet_name", "Choose a sheet:", choices = NULL)
    })

    # Display the selected sheet name
    output$selected_sheet <- renderText({
        req(input$sheet_name)
        paste("Selected Sheet:", input$sheet_name)
    })

    # Reactive function to read data when a new file is uploaded and a sheet is selected
    data <- reactive({
        inFile <- input$file1
        sheetName <- input$sheet_name
        if (is.null(inFile) || is.null(sheetName)) {
            return(NULL)
        }
        df <- read_excel(
            path  = inFile$datapath,
            sheet = sheetName,
            skip  = 1
        )

        df %>%
            mutate_if(is.numeric, .funs = function(x) ifelse(is.na(x), 0, x))
    })

    # Generate table output to display data
    output$table1 <- renderTable({
        data()
    })

}

# Run the application
shinyApp(ui = ui, server = server)
