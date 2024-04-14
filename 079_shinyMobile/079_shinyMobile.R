library(shiny)
library(shinyMobile)
library(apexcharter)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

thematic_shiny(font = "auto")

data("economics_long")
economics_long <- economics_long %>%
    group_by(variable) %>%
    slice((n()-100):n())

portfolio <- data.frame(
    name = c('Bonds', 'Stocks', 'ETFs', 'Cash'),
    value = c(10, 55, 25, 10)
)

# Generate time series data
set.seed(123)
dates <- seq(as.Date("2020-01-01"), by="month", length.out=36)
stocks <- cumsum(rnorm(36, 0.5, 2))
bonds <- cumsum(rnorm(36, 0.3, 1))
etfs <- cumsum(rnorm(36, 0.4, 1.5))
cash <- rep(10, 36)  # Cash stays constant

time_series_data <- data.frame(Date = dates, Stocks = stocks, Bonds = bonds, ETFs = etfs, Cash = cash) %>%
    pivot_longer(cols = -Date)

shinyApp(
    ui = f7Page(
        title = "Business Science Mobile Investment App",
        options = list(dark = TRUE, filled = FALSE, theme = "md", color = "blue"),
        f7TabLayout(
            navbar = f7Navbar(
                title = "Business Science Mobile Investment App",
                hairline = TRUE,
                shadow = TRUE
            ),
            # main content
            f7Tabs(
                animated = FALSE,
                swipeable = TRUE,
                id = "tabset",
                f7Tab(
                    tabName = "PortfolioGrowth",
                    icon = f7Icon("graph_square"),
                    f7Shadow(
                        intensity = 16,
                        hover = TRUE,
                        f7Card(
                            title = "Portfolio Growth Over Time (In $1,000's)",
                            apexchartOutput("lineChart")
                        )
                    )
                ),
                f7Tab(
                    tabName = "PortfolioSnapshot",
                    icon = f7Icon("chart_pie"),
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
                    tabName = "EconomicIndex",
                    icon = f7Icon("info_circle"),
                    f7Shadow(
                        intensity = 16,
                        hover = TRUE,
                        f7Card(
                            title = "Economic Index Over Time",
                            apexchartOutput("econChart")
                        )
                    )
                )
            )
        )
    ),
    server = function(input, output) {
        output$econChart <- renderApexchart({
            apex(
                data = economics_long,
                type = "line",
                mapping = aes(
                    x = date,
                    y = value01,
                    fill = variable
                )
            ) %>%
                ax_yaxis(decimalsInFloat = 2) %>% # number of decimals to keep
                # ax_chart(stacked = TRUE) %>%
                ax_tooltip(theme = "dark")
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

        output$lineChart <- renderApexchart({
            apex(
                data = time_series_data,
                type = "line",
                mapping = aes(
                    x = Date,
                    y = value,
                    fill = name
                )
            ) %>%
                ax_tooltip(theme = "dark") %>%
                ax_yaxis(
                    labels = list(
                        formatter = htmlwidgets::JS("
                        function(value) {
                          return '$' + (value).toFixed(1) + 'K';  // Converting to thousands for cleaner display
                        }
                    ")
                    )
                )
        })
    }
)
