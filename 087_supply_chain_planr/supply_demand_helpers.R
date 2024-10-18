library(dplyr)
library(reactable)
library(reactablefmtr)
library(htmltools)

# Define the status_PI.Index function (adjusted to handle missing PI.Index)
status_PI.Index <- function(value) {
    color <- switch(
        value,
        "TBC" = "hsl(154, 3%, 50%)",
        "OverStock" = "hsl(214, 45%, 50%)",
        "OK" = "hsl(154, 64%, 50%)",
        "Alert" = "hsl(30, 97%, 70%)",
        "Shortage" = "hsl(3, 69%, 50%)",
        "#aaa"  # Default color
    )
    span(style = list(
        display = "inline-block",
        marginRight = "0.5rem",
        width = "0.55rem",
        height = "0.55rem",
        backgroundColor = color,
        borderRadius = "50%"
    ))
}

# Create the function to generate the reactable table
generate_supply_chain_table <- function(data) {
    # Prepare the data
    df1 <- data

    # Create a color palette field based on 'Calculated.Coverage.in.Periods'
    df1 <- df1 %>%
        mutate(f_colorpal = case_when(
            Calculated.Coverage.in.Periods > 6 ~ "#FFA500",  # Orange
            Calculated.Coverage.in.Periods > 2 ~ "#32CD32",  # LimeGreen
            Calculated.Coverage.in.Periods > 0 ~ "#FFFF99",  # LightYellow
            TRUE ~ "#FF0000"                                 # Red
        ))

    # Compute PI.Index if not present
    if (!"PI.Index" %in% names(df1)) {
        df1 <- df1 %>%
            mutate(PI.Index = case_when(
                Calculated.Coverage.in.Periods > 6 ~ "OverStock",
                Calculated.Coverage.in.Periods > 2 ~ "OK",
                Calculated.Coverage.in.Periods > 0 ~ "Alert",
                TRUE ~ "Shortage"
            ))
    }

    # Generate the reactable table
    reactable_table <- reactable(
        df1,
        resizable = TRUE,
        showPageSizeOptions = TRUE,
        striped = TRUE,
        highlight = TRUE,
        compact = TRUE,
        defaultPageSize = 20,
        columns = list(
            DFU = colDef(
                name = "DFU",
                minWidth = 100,
                sticky = "left"
            ),
            Period = colDef(
                name = "Period",
                format = colFormat(date = TRUE),
                minWidth = 100,
                sticky = "left"
            ),
            Demand = colDef(
                name = "Demand (units)",
                cell = data_bars(
                    df1,
                    fill_color = "#3fc1c9",
                    text_position = "outside-end",
                    number_fmt = scales::comma_format()
                )
            ),
            Calculated.Coverage.in.Periods = colDef(
                name = "Coverage (Periods)",
                maxWidth = 90,
                cell = color_tiles(df1, color_ref = "f_colorpal")
            ),
            Projected.Inventories.Qty = colDef(
                name = "Projected Inventories (units)",
                format = colFormat(separators = TRUE, digits = 0),
                style = function(value) {
                    if (value > 0) {
                        color <- "#008000"
                    } else if (value < 0) {
                        color <- "#e00000"
                    } else {
                        color <- "#777777"
                    }
                    list(color = color)
                }
            ),
            Supply = colDef(
                name = "Supply (units)",
                cell = data_bars(
                    df1,
                    fill_color = "#3CB371",
                    text_position = "outside-end",
                    number_fmt = scales::comma_format()
                )
            ),
            Opening = colDef(
                name = "Opening Inventories (units)",
                format = colFormat(separators = TRUE, digits = 0)
            ),
            PI.Index = colDef(
                name = "Analysis",
                cell = function(value) {
                    PI.Index_icon <- status_PI.Index(value)
                    tagList(PI.Index_icon, value)
                }
            ),
            f_colorpal = colDef(show = FALSE)  # Hidden column used for coloring
        ),
        groupBy = "DFU",  # Group the table by DFU
        searchable = TRUE,
        pagination = TRUE
    )

    # Return the reactable table
    return(reactable_table)
}
