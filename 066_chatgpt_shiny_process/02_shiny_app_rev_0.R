library(shiny)
library(shinythemes)
library(readxl)

# Define UI for the app
ui <- navbarPage(
    theme = shinythemes::shinytheme("cyborg"),
    title = "Pro Forma Financial Forecaster",

    # First tab: Upload and display Excel data
    tabPanel("Upload Excel",
          sidebarLayout(
              sidebarPanel(
                  fileInput("file1", "Choose Excel File",
                            accept = c(".xlsx")
                  )
              ),
              mainPanel(
                  tableOutput("table1")
              )
          )),

    # Second tab: Placeholder for other content
    tabPanel("Another Page",
          h2("Content for another page can be added here"))
)

# Define server logic
server <- function(input, output) {

    # Reactive function to read data when a new file is uploaded
    data <- reactive({
        inFile <- input$file1
        if (is.null(inFile)) {
            return(NULL)
        }
        read_excel(path = inFile$datapath, sheet = 1, skip = 1)
    })

    # Generate table output to display data
    output$table1 <- renderTable({
        data()
    })

}

# Run the application
shinyApp(ui = ui, server = server)
