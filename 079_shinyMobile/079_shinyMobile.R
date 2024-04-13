library(shiny)
library(shinyMobile)
library(apexcharter)
library(dplyr)
library(ggplot2)
library(thematic)

thematic_shiny(font = "auto")

data("economics_long")

economics_long <- economics_long %>%
    group_by(variable) %>%
    slice((n()-100):n())

portfolio <- data.frame(
    name = c('Bonds', 'Stocks', 'ETFs', 'Cash'),
    value = c(10, 55, 25, 10)
)

# thematic::auto_config()

shinyApp(
    ui = f7Page(
        title = "My app",
        options = list(dark = TRUE, filled = FALSE, theme = "md", color = "blue"),
        f7TabLayout(
            navbar = f7Navbar(
                title = "Investment App",
                hairline = TRUE,
                shadow = TRUE
            ),
            # main content
            f7Tabs(
                animated = FALSE,
                swipeable = TRUE,
                id = "tabset",
                f7Tab(
                    tabName = "Tab2",
                    icon = f7Icon("chart_pie"),
                    active = TRUE,
                    f7Shadow(
                        intensity = 16,
                        hover = TRUE,
                        f7Card(
                            title = "Portfolio Snapshot",
                            apexchartOutput("donutChart")
                        )
                    )
                ),
                f7Tab(
                    tabName = "Tab1",
                    icon = f7Icon("graph_square"),
                    active = TRUE,
                    f7Shadow(
                        intensity = 16,
                        hover = TRUE,
                        f7Card(
                            title = "Economic Index Over Time",
                            apexchartOutput("areaChart")
                        )
                    )
                )

            )
        )
    ),
    server = function(input, output) {
        output$areaChart <- renderApexchart({
            apex(
                data = economics_long,
                type = "area",
                mapping = aes(
                    x = date,
                    y = value01,
                    fill = variable
                )
            ) %>%
                ax_yaxis(decimalsInFloat = 2) %>% # number of decimals to keep
                ax_chart(stacked = TRUE)
        })

        output$donutChart <- renderApexchart({
            apex(
                data = portfolio,
                type = "donut",
                mapping = aes(
                    x = name,
                    y = value
                )
            )
        })
    }
)
