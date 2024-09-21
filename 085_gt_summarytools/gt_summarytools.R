gt_summarytools <- function(data, title = "Data Summary") {

    # Ensure required packages are installed
    required_packages <- c("gt", "gtExtras", "dplyr", "tibble", "ggplot2", "scales", "purrr", "tidyr", "stringr", "glue", "forcats")
    for (pkg in required_packages) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
            stop(paste0("Package '", pkg, "' is required but is not installed."))
        }
    }

    # If no title, return name of input dataframe
    if (is.null(title)) title <- deparse(substitute(data))

    # Check for list columns and large data size
    if (any(sapply(data, class) == "list")) stop("gt_summarytools() doesn't handle list columns.", call. = FALSE)
    if (nrow(data) >= 1e5) warning("Data has more than 100,000 rows, consider sampling the data to reduce size.", call. = FALSE)

    # Helper function to create summary table
    create_sum_table <- function(df) {
        vars <- names(df)

        sum_table <- purrr::map_df(vars, function(var_name) {
            x <- df[[var_name]]
            type <- class(x)[1]
            n_total <- length(x)
            n_missing <- sum(is.na(x))
            n_valid <- n_total - n_missing

            # Calculate percentages
            if (is.numeric(n_total) && n_total > 0) {
                percent_valid <- round((n_valid / n_total) * 100, 1)
                percent_missing <- round((n_missing / n_total) * 100, 1)
            } else {
                percent_valid <- NA
                percent_missing <- NA
            }

            # Format the Valid and Missing columns with counts and percentages
            valid_text <- paste0(n_valid, " (", percent_valid, "%)")
            missing_text <- paste0(n_missing, " (", percent_missing, "%)")

            # Numeric Variables
            if (is.numeric(x)) {
                Mean <- mean(x, na.rm = TRUE)
                SD <- sd(x, na.rm = TRUE)
                Min <- min(x, na.rm = TRUE)
                Median <- median(x, na.rm = TRUE)
                Max <- max(x, na.rm = TRUE)
                IQR_val <- IQR(x, na.rm = TRUE)
                CV <- SD / Mean

                # Prepare the summary for numeric variables
                stats_values <- paste0(
                    "Mean (sd): ", round(Mean, 1), " (", round(SD, 1), ")<br>",
                    "min ≤ med ≤ max:<br>",
                    round(Min, 1), " ≤ ", round(Median, 1), " ≤ ", round(Max, 1), "<br>",
                    "IQR (CV): ", round(IQR_val, 1), " (", round(CV, 1), ")<br>",
                    length(unique(x)), " distinct values"
                )
                Freqs_Percents <- NA_character_

                # Date Variables
            } else if (inherits(x, "Date") || inherits(x, "POSIXct")) {
                Min <- min(x, na.rm = TRUE)
                Median <- median(x, na.rm = TRUE)
                Max <- max(x, na.rm = TRUE)
                Range <- Max - Min

                # Prepare the summary for date variables
                stats_values <- paste0(
                    "Min: ", Min, "<br>Median: ", Median, "</br>Max: ", Max, "<br>Range: ", Range
                )
                Freqs_Percents <- NA_character_

                # Categorical Variables
            } else if (is.character(x) || is.factor(x)) {
                # Apply lumping for variables with more than 10 distinct categories
                if (length(unique(x)) > 10) {
                    # Lump least frequent categories into "OTHER"
                    x <- forcats::fct_lump_n(factor(x), n = 10, other_level = "OTHER", ties.method = "first")
                }

                # Create frequency and percentage summaries
                freqs <- table(x, useNA = "ifany")
                percents <- prop.table(freqs) * 100
                levels <- names(freqs)
                levels_numbers <- seq_along(levels)

                # Prepare the summary for categorical variables
                levels_info <- paste0("[", levels_numbers, "] ", levels)
                freqs_info <- paste0(freqs, "\t(", round(percents, 1), "%)")

                stats_values <- paste(levels_info, collapse = "</br>")
                Freqs_Percents <- paste(freqs_info, collapse = "<br>")

            } else {
                stats_values <- NA_character_
                Freqs_Percents <- NA_character_
            }

            tibble(
                No = NA_integer_,
                Variable = var_name,
                type = type,
                stats_values = stats_values,
                Freqs_Percents = Freqs_Percents,
                Graph = NA_character_,
                Valid = valid_text,
                Missing = missing_text
            )
        })

        sum_table <- sum_table %>% mutate(No = row_number())
        return(sum_table)
    }

    # Inline plot function
    plot_data <- function(col, col_name, n_missing, ...) {

        col_type <- class(col)[1]
        col <- col[!is.na(col)]

        # Categorical data: Create horizontal bar plot
        if (col_type %in% c("factor", "character", "ordered")) {
            n_unique <- length(unique(col))

            # Apply lumping: Limit categories to 10 and group others into "OTHER"
            if (n_unique > 10) {
                col <- forcats::fct_lump_n(factor(col), n = 10, other_level = "OTHER", ties.method = "first")
                n_unique <- length(unique(col))  # Update the unique count after lumping
            }

            cat_lab <- ifelse(col_type == "ordered", "categories, ordered", "categories")
            cc <- scales::seq_gradient_pal(low = "#3181bd", high = "#ddeaf7", space = "Lab")(seq(0, 1, length.out = n_unique))

            # Create a horizontal bar plot for categorical data
            plot_out <- dplyr::tibble(vals = as.character(col)) %>%
                dplyr::group_by(vals) %>%
                dplyr::summarise(n = n(), .groups = 'drop') %>%
                dplyr::arrange(desc(n)) %>%
                dplyr::mutate(vals = factor(vals, levels = unique(rev(vals)), ordered = TRUE)) %>%
                ggplot(aes(x = n, y = vals, fill = vals)) +
                geom_bar(stat = "identity") +
                guides(fill = "none") +
                scale_fill_manual(values = rev(cc)) +
                theme_minimal() +
                theme(
                    axis.title.x = element_blank(),
                    axis.title.y = element_blank(),
                    axis.text.y = element_text(size = 8),
                    axis.text.x = element_text(size = 8),
                    plot.margin = margin(3, 1, 3, 1)
                ) +
                labs(y = paste(n_unique, cat_lab))  # Label showing the number of unique categories

            # Dynamically set the plot height based on the number of unique categories
            plot_height <- ifelse(n_unique <= 11, n_unique * 8, 8)  # Adjust height based on number of categories

        } else if (col_type %in% c("numeric", "double", "integer")) {
            # Handle numeric data
            df_in <- dplyr::tibble(x = col) %>%
                dplyr::filter(!is.na(x))

            rng_vals <- scales::expand_range(range(col, na.rm = TRUE), mul = 0.01)
            bw <- 2 * IQR(col, na.rm = TRUE) / length(col)^(1 / 3)

            plot_out <- ggplot(df_in, aes(x = x)) +
                {
                    if (bw > 0 && !is.infinite(bw)) {
                        geom_histogram(color = "white", fill = "#f8bb87", binwidth = bw)
                    } else {
                        hist_breaks <- graphics::hist(col[!is.na(col)], breaks = "FD", plot = FALSE)$breaks
                        geom_histogram(color = "white", fill = "#f8bb87", breaks = hist_breaks)
                    }
                } +
                scale_x_continuous(
                    breaks = range(col),
                    labels = scales::label_number(big.mark = ",", scale_cut = scales::cut_long_scale())(range(col, na.rm = TRUE))
                ) +
                geom_point(data = NULL, aes(x = rng_vals[1], y = 1), color = "transparent", size = 0.1) +
                geom_point(data = NULL, aes(x = rng_vals[2], y = 1), color = "transparent", size = 0.1) +
                scale_y_continuous(expand = c(0, 0)) +
                {
                    if (length(unique(col)) > 2) geom_vline(xintercept = median(col, na.rm = TRUE))
                } +
                theme_void() +
                theme(
                    axis.text.x = element_text(color = "black", vjust = -2, size = 6),
                    axis.line.x = element_line(color = "black"),
                    axis.ticks.x = element_line(color = "black"),
                    axis.ticks.length.x = unit(1, "mm"),
                    plot.margin = margin(1, 1, 3, 1),
                    text = element_text(family = "mono", size = 6)
                )

            plot_height <- 8*3

        } else if (grepl(x = col_type, pattern = "date|posix|time|hms", ignore.case = TRUE)) {
            df_in <- dplyr::tibble(x = col) %>%
                dplyr::filter(!is.na(x))

            bw <- 2 * IQR(col, na.rm = TRUE) / length(col)^(1 / 5)

            plot_out <- ggplot(data = df_in, aes(x = x)) +
                geom_histogram(color = "white", fill = "#73a657", binwidth = bw) +
                {
                    if ("continuous" %in% ggplot2::scale_type(col)) {
                        scale_x_continuous(
                            breaks = range(col, na.rm = TRUE),
                            labels = scales::label_date()(range(col, na.rm = TRUE))
                        )
                    } else if ("time" %in% ggplot2::scale_type(col)) {
                        scale_x_time(
                            breaks = range(col, na.rm = TRUE)
                        )
                    } else {
                        scale_x_discrete(
                            breaks = range(col, na.rm = TRUE)
                        )
                    }
                } +
                theme_void() +
                theme(
                    axis.text.x = element_text(
                        color = "black",
                        vjust = -2,
                        size = 6
                    ),
                    axis.line.x = element_line(color = "black"),
                    axis.ticks.x = element_line(color = "black"),
                    axis.ticks.length.x = unit(1, "mm"),
                    plot.margin = margin(1, 1, 3, 1),
                    text = element_text(family = "mono", size = 6)
                )
            plot_height <- 8*3
        } else {
            return("<div></div>")
        }

        # Save plot as SVG and return HTML for embedding
        out_name <- tempfile(fileext = ".svg")
        ggsave(out_name, plot = plot_out, dpi = 25.4, height = plot_height, width = 50, units = "mm", device = "svg")

        img_plot <- readLines(out_name, warn = FALSE) %>%
            paste0(collapse = "") %>%
            gt::html()

        on.exit(file.remove(out_name), add = TRUE)
        img_plot
    }

    # Create a summary table using the 'create_sum_table' approach
    summary_table <- create_sum_table(data)

    # Create a gt table for visualization
    gt_table <- summary_table %>%
        gt() %>%
        text_transform(
            locations = cells_body(columns = c("Variable")),
            fn = function(x) {
                lapply(x, function(z) {
                    gt::html(glue::glue("<div style='font-weight: bold;'>{z}</div>"))
                })
            }
        ) %>%
        text_transform(
            locations = cells_body(columns = c("Graph")),
            fn = function(x) {
                plots <- map(seq_len(nrow(summary_table)), function(i) {
                    plot_data(data[[summary_table$Variable[i]]], summary_table$Variable[i], summary_table$Missing[i])
                })
                plots
            }
        ) %>%
        cols_label(
            No = "No",
            Variable = "Variable",
            type = "Type",
            stats_values = "Stats / Values",
            Freqs_Percents = "Freqs (% of Valid)",
            Graph = "Graph",
            Valid = "Valid",
            Missing = "Missing"
        ) %>%
        fmt_markdown(columns = c("stats_values", "Freqs_Percents")) %>%
        gtExtras::gt_theme_espn() %>%
        tab_style(
            style = cell_text(weight = "bold", whitespace = "pre"),
            locations = cells_body(columns = c("Variable"))
        ) %>%
        tab_header(
            title = title,
            subtitle = glue::glue("{nrow(data)} rows x {ncol(data)} cols")
        ) %>%
        tab_options(
            column_labels.border.top.width = px(0),
            heading.border.bottom.width = px(0)
        )

    # Handle missing values differently based on the version of gt
    if (utils::packageVersion("gt")$minor >= 6) {
        gt_table <- gt_table %>% sub_missing()
    } else {
        gt_table <- gt_table %>% fmt_missing(missing_text = "--")
    }

    return(gt_table)
}
