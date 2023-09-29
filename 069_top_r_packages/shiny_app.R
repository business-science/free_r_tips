library(shiny)
library(leaflet)

ui <- fluidPage(
    titlePanel("Interactive Store Locator"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("salesRange",
                        "Sales Range:",
                        min = 100,
                        max = 1000,
                        value = c(100, 1000))
        ),

        mainPanel(
            leafletOutput("mymap")
        )
    )
)

server <- function(input, output) {

    data <- data.frame(
        Store = c('Store 1', 'Store 2', 'Store 3', 'Store 4'),
        Lat = c(37.7749, 34.0522, 36.7783, 40.7128),
        Lng = c(-122.4194, -118.2437, -119.4179, -74.0060),
        Sales = c(500, 200, 800, 300)
    )

    output$mymap <- renderLeaflet({
        # Filtering data based on input sales range
        filteredData <- data[data$Sales >= input$salesRange[1] & data$Sales <= input$salesRange[2],]

        leaflet(filteredData) %>%
            addTiles() %>%
            addMarkers(~Lng, ~Lat, popup = ~Store)
    })
}

shinyApp(ui = ui, server = server)








