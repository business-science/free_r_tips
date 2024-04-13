
library(shiny)
library(shinyMobile)

cities <- names(precip)

shinyApp(
    ui = f7Page(
        title = "My app",
        f7Appbar(
            f7Flex(f7Back(targetId = "tabset"), f7Next(targetId = "tabset")),
            f7Searchbar(id = "search1", inline = TRUE)
        ),
        f7TabLayout(
            navbar = f7Navbar(
                title = "f7Appbar",
                hairline = FALSE,
                shadow = TRUE
            ),
            f7Tabs(
                animated = FALSE,
                swipeable = TRUE,
                id = "tabset",
                f7Tab(
                    tabName = "Tab1",
                    icon = f7Icon("envelope"),
                    active = TRUE,
                    "Text 1"
                ),
                f7Tab(
                    tabName = "Tab2",
                    icon = f7Icon("today"),
                    active = FALSE,
                    "Text 2"
                ),
                f7Tab(
                    tabName = "Tab3",
                    icon = f7Icon("cloud_upload"),
                    active = FALSE,
                    "Text 3"
                )
            )
        )
    ),
    server = function(input, output) {}
)
