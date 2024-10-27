# BUSINESS SCIENCE R TIPS ----
# R-TIP 88 | EXPLORING GGALIGN FOR COMPLEX HEATMAPS ----

# Goal: Explore the ggalign library

library(tidyverse)
library(magrittr)
library(ggalign)

# 1.0 STOCK CORRELATION AND RETURN ANALYSIS

stock_returns_annual <- read_csv("088_ggalign/data/stock_returns.csv")
stock_returns_annual

cor_mat <- stock_returns_annual %>%
    select(-company) %>%
    as.matrix() %>%
    t() %>%
    magrittr::set_colnames(stock_returns_annual$company) %>%
    cor(use = "pairwise.complete.obs")

cumulative_return <- stock_returns_annual %>%
    select(-company) %>%
    select(where(~ !any(is.na(.)))) %>%
    rowwise() %>%
    mutate(cumulative_return = prod(1 + c_across(everything()), na.rm = TRUE) - 1) %>%
    ungroup() %>%
    select(cumulative_return) %>%
    as.matrix() %>%
    # t() %>%
    magrittr::set_rownames(stock_returns_annual$company)


ggheatmap(cor_mat, filling = FALSE) +

    # HEATMAP
    geom_tile(aes(fill = value), color = "white") +
    scale_fill_gradientn(
        colours = c("red", "red", "yellow",  "cornflowerblue", "blue"), # Red for negative, white for neutral, green for positive
        values = c(-1, 0, 0.2, 0.5, 1)
    ) +
    scale_color_brewer(palette = "Dark2") +
    theme(axis.text.x = element_text(angle = -60, hjust = 0)) +

    # RIGHT DENDROGRAM
    hmanno("r", unit(3, "cm")) +
    align_dendro(aes(color= branch), plot_dendrogram = TRUE, k=5) +
    scale_color_brewer() +

    # TOP CUMULATIVE LOG RETURNS
    hmanno("t", size = unit(4, "cm")) +
    ggalign(data = cumulative_return) +
    geom_bar(aes(y = log(value)), fill = "cornflowerblue", color = "white", stat = "identity") +
    labs(y="Cum Log Returns\n(2015-2024)") +
    align_dendro(aes(color= branch), plot_dendrogram = FALSE, k=5) +
    scale_y_continuous(expand = expansion()) +

    # PLOT TITLE
    ggtitle("Annual Stock Correlation and Log Returns for Top 50 Companies (1980-2024)") +
    theme(plot.title = element_text(hjust = 0.5))


# 2.0 GGALIGN MEASLES EXAMPLE:

mat <- read_example("measles.rds")

ggheatmap(mat, filling=FALSE) +
    geom_tile(aes(fill = value), color = "white") +
    scale_fill_gradientn(
        colours = c("white", "cornflowerblue", "yellow", "red"),
        values = scales::rescale(c(0, 800, 1000, 127000), c(0, 1))
    ) +
    theme(axis.text.x = element_text(angle = -60, hjust = 0)) +
    hmanno("r") +
    align_dendro(plot_dendrogram = FALSE) +
    hmanno("t", size = unit(2, "cm")) +
    ggalign(data = rowSums) +
    geom_bar(aes(y = value), fill = "#FFE200", color = "white", stat = "identity") +
    scale_y_continuous(expand = expansion()) +
    ggtitle("Measles cases in US states 1930-2001\nVaccine introduced 1961") +
    theme(plot.title = element_text(hjust = 0.5)) +
    hmanno("r", size = unit(2, "cm")) +
    ggalign(data = rowSums) +
    geom_bar(aes(x = value),
             fill = "#FFE200", color = "white", stat = "identity",
             orientation = "y"
    ) +
    scale_x_continuous(expand = expansion()) +
    theme(axis.text.x = element_text(angle = -60, hjust = 0))








