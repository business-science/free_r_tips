



library(tidyverse)
library(gt)
library(gtExtras)

# DATA

churn_data_tbl <- read_csv("085_gtExtras/data/customer_churn.csv")

stock_data_tbl <- read_csv("085_gtExtras/data/stock_data.csv")

stock_data_tbl <- stock_data_tbl %>%
    pivot_longer(
        cols = -Date,
        names_to = "symbol",
        values_to = "price"
    )


# SUMMARY PLOT ----

churn_data_tbl %>%
    select(-customerID) %>%
    gt_plt_summary("Churn Data Summary") %>%
    gtExtras::gt_theme_538()

churn_data_tbl


# CUSTOM FUNCTION THAT REPLICATES SUMMARYTOOLS DFSUMMARY() FROM R-TIP 84 ----

create_summary_table <- function(data, title = "Data Summary") {
    # Ensure required packages are installed
    required_packages <- c("gt", "gtExtras", "dplyr", "tibble", "ggplot2", "scales")
    for (pkg in required_packages) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
            stop(paste0("Package '", pkg, "' is required but is not installed."))
        }
    }

    # If no title, return name of input dataframe
    if (is.null(title)) title <- deparse(substitute(data))

    # Check for list columns and large data size
    if (any(sapply(data, class) == "list")) stop("create_summary_table() doesn't handle list columns.", call. = FALSE)
    if (nrow(data) >= 1e5) warning("Data has more than 100,000 rows, consider sampling the data to reduce size.", call. = FALSE)

    # Create a summary table using the 'create_sum_table' approach
    summary_table <- create_sum_table(data)

    # Create a gt table for visualization
    gt_table <- summary_table %>%
        gt() %>%
        text_transform(
            cells_body(columns = vars(name)),
            fn = function(x) {
                temp_df <- gtExtras::gt_index(gt_object = ., name, as_vector = FALSE)

                apply_detail <- function(type, name, value) {
                    if (grepl(x = type, pattern = "factor|character|ordered")) {
                        value_count <- tapply(value, value, length) %>%
                            sort(decreasing = TRUE) %>%
                            labels() %>%
                            unlist()

                        html(glue::glue(
                            "<div style='max-width: 150px;'>
               <details style='font-weight: normal !important;'>
               <summary style='font-weight: bold !important;'>{name}</summary>
               {glue::glue_collapse(value_count, ', ', last = ' and ')}
               </details></div>"
                        ))
                    } else {
                        name
                    }
                }

                mapply(
                    FUN = apply_detail,
                    temp_df$type,
                    temp_df$name,
                    temp_df$value,
                    MoreArgs = NULL
                )
            }
        ) %>%
        text_transform(
            cells_body(columns = vars(value)),
            fn = function(x) {
                .mapply(
                    FUN = plot_data,
                    list(
                        gtExtras::gt_index(gt_object = ., value),
                        gtExtras::gt_index(gt_object = ., name),
                        gtExtras::gt_index(gt_object = ., n_missing)
                    ),
                    MoreArgs = NULL
                )
            }
        ) %>%
        fmt_number(
            columns = vars(Mean, Median, SD),
            decimals = 1
        ) %>%
        fmt_percent(columns = vars(n_missing), decimals = 1) %>%
        text_transform(
            cells_body(columns = vars(type)),
            fn = function(x) {
                lapply(x, function(z) {
                    if (grepl(x = z, pattern = "factor|character|ordered")) {
                        fontawesome::fa("list", "#4e79a7", height = "20px")
                    } else if (grepl(x = z, pattern = "number|numeric|double|integer|complex")) {
                        fontawesome::fa("signal", "#f18e2c", height = "20px")
                    } else if (grepl(x = z, pattern = "date|time|posix|hms", ignore.case = TRUE)) {
                        fontawesome::fa("clock", "#73a657", height = "20px")
                    } else {
                        fontawesome::fa("question", "black", height = "20px")
                    }
                })
            }
        ) %>%
        cols_label(
            name = "Column",
            value = "Plot Overview",
            type = "", n_missing = "Missing"
        ) %>%
        gtExtras::gt_theme_espn() %>%
        tab_style(
            cells_body(columns = vars(name)),
            style = cell_text(weight = "bold")
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
        gt_table %>% sub_missing(Mean:SD)
    } else {
        gt_table %>% fmt_missing(Mean:SD, missing_text = "--")
    }
}

# Create summary table helper function (adopted from your example)
create_sum_table <- function(df) {
    sum_table <- df %>%
        dplyr::summarise(dplyr::across(dplyr::everything(), list)) %>%
        tidyr::pivot_longer(dplyr::everything()) %>%
        dplyr::rowwise() %>%
        dplyr::mutate(
            type = paste0(class(value), collapse = " "),
            n_missing = sum(is.na(value) | is.null(value)) / length(value)
        ) %>%
        dplyr::mutate(
            Mean = ifelse(type %in% c("double", "integer", "numeric"), mean(value, na.rm = TRUE), NA),
            Median = ifelse(type %in% c("double", "integer", "numeric"), median(value, na.rm = TRUE), NA),
            SD = ifelse(type %in% c("double", "integer", "numeric"), sd(value, na.rm = TRUE), NA)
        ) %>%
        dplyr::ungroup() %>%
        dplyr::select(type, name, dplyr::everything())
    sum_table
}

# Inline plot function (adapted from your plot_data function)
plot_data <- function(col, col_name, n_missing, ...) {
    # Handle missing values
    if (n_missing >= 0.99) return("<div></div>")

    col_type <- paste0(class(col), collapse = " ")
    col <- col[!is.na(col)]

    # Categorical data
    if (col_type %in% c("factor", "character", "ordered factor")) {
        n_unique <- length(unique(col))
        cat_lab <- ifelse(col_type == "ordered factor", "categories, ordered", "categories")
        cc <- scales::seq_gradient_pal(low = "#3181bd", high = "#ddeaf7", space = "Lab")(seq(0, 1, length.out = n_unique))

        plot_out <- dplyr::tibble(vals = as.character(col)) %>%
            dplyr::group_by(vals) %>%
            dplyr::mutate(n = n(), .groups = "drop") %>%
            dplyr::arrange(desc(n)) %>%
            dplyr::ungroup() %>%
            dplyr::mutate(vals = factor(vals, levels = unique(rev(vals)), ordered = TRUE)) %>%
            ggplot(aes(y = 1, fill = vals)) +
            geom_bar(position = "fill") +
            guides(fill = "none") +
            scale_fill_manual(values = rev(cc)) +
            theme_void() +
            theme(
                axis.title.x = element_text(hjust = 0, size = 8),
                plot.margin = margin(3, 1, 3, 1)
            ) +
            scale_x_continuous(expand = c(0, 0)) +
            labs(x = paste(n_unique, cat_lab))
    } else if (col_type %in% c("numeric", "double", "integer", "complex")) {
        # Handle numeric data
        df_in <- dplyr::tibble(x = col) %>%
            dplyr::filter(!is.na(x))

        rng_vals <- scales::expand_range(range(col, na.rm = TRUE), mul = 0.01)
        bw <- 2 * IQR(col, na.rm = TRUE) / length(col)^(1 / 3)

        plot_out <- ggplot(df_in, aes(x = x)) +
            {
                if (bw > 0) {
                    geom_histogram(color = "white", fill = "#f8bb87", binwidth = bw)
                } else {
                    hist_breaks <- graphics::hist(col[!is.na(col)], breaks = "FD", plot = FALSE)$breaks
                    geom_histogram(color = "white", fill = "#f8bb87", breaks = hist_breaks)
                }
            } +
            scale_x_continuous(
                breaks = range(col),
                labels = scales::label_number(big.mark = ",", ..., scale_cut = scales::cut_long_scale())(range(col, na.rm = TRUE))
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
    }

    # Save plot as SVG and return HTML for embedding
    out_name <- file.path(tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg"))
    ggsave(out_name, plot = plot_out, dpi = 25.4, height = 12, width = 50, units = "mm", device = "svg")

    img_plot <- readLines(out_name) %>%
        paste0(collapse = "") %>%
        gt::html()

    on.exit(file.remove(out_name), add = TRUE)
    img_plot
}




churn_data_tbl %>%
    select(-customerID) %>%
    create_summary_table("Customer Churn Summary") %>%
    gt_theme_538()
