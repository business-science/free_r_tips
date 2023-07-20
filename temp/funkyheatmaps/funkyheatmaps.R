

library(tidyverse)
library(funkyheatmap)



data <- mtcars %>%
    rownames_to_column("id") %>%
    arrange(desc(mpg))

column_info <- tribble(
    ~id,     ~group,         ~name,                      ~geom,        ~palette,    ~options,
    "id",    "",             "",                         "text",       NA,          list(hjust = 0, width = 6),
    "mpg",   "overall",      "Miles / gallon",           "bar",        "palette1",  list(width = 4, legend = FALSE),
    "cyl",   "overall",      "Number of cylinders",      "bar",        "palette2",  list(width = 4, legend = FALSE),
    "disp",  "group1",       "Displacement (cu.in.)",    "funkyrect",  "palette1",  lst(),
    "hp",    "group1",       "Gross horsepower",         "funkyrect",  "palette1",  lst(),
    "drat",  "group1",       "Rear axle ratio",          "funkyrect",  "palette1",  lst(),
    "wt",    "group1",       "Weight (1000 lbs)",        "funkyrect",  "palette1",  lst(),
    "qsec",  "group2",       "1/4 mile time",            "circle",     "palette2",  lst(),
    "vs",    "group2",       "Engine",                   "circle",     "palette2",  lst(),
    "am",    "group2",       "Transmission",             "circle",     "palette2",  lst(),
    "gear",  "group2",       "# Forward gears",          "circle",     "palette2",  lst(),
    "carb",  "group2",       "# Carburetors",            "circle",     "palette2",  lst()
)

funky_heatmap(data, column_info = column_info, expand = list(xmax = 4))



# Source: https://eresearch.fidelity.com/eresearch/markets_sectors/sectors/si_performance.jhtml?tab=siperformance

sector_performance_tbl <- tibble::tribble(
    ~ sector_name, ~ last_pct_change, ~ one_day, ~ five_day, ~ one_month, ~ three_month, ~year_to_date, ~ one_year, ~ three_year, ~ five_year, ~ten_year,

                "Materials (.GSPM)", "+3.37%", "+3.37%", "+3.30%", "-2.75%", "-4.89%", "+0.69%", "-7.60%", "+40.73%", "+33.66", "+94.83%",
                    "Energy (.GSPE)",  "+2.96%",  "+2.96%",  "+0.93%",  "-5.65%",  "-6.14%",  "-9.21%",  "-8.84%", "+105.87%",   "+8.74%",   "+3.31%",
               "Industrials (.GSPI)",  "+2.96%",  "+2.96%",  "+3.36%",  "+0.11%",  "-0.40%",  "+2.44%",  "+7.36%",  "+49.08%",  "+35.05%", "+126.86%",
    "Consumer Discretionary (.GSPD)",  "+2.20%",  "+2.20%",  "+5.73%",  "+7.79%", "+10.17%", "+22.22%",  "+2.45%",  "+21.50%",  "+45.16%", "+176.81%",
                "Financials (.GSPF)",  "+2.18%",  "+2.18%",  "+2.87%",  "-1.06%",  "-7.90%",  "-4.50%",  "-5.97%",  "+38.80%",  "+19.52%", "+103.94%",
              "Real Estate (.GSPRE)",  "+2.09%",  "+2.09%",  "+4.27%",  "-1.71%",  "-2.40%",  "-0.79%", "-15.68%",   "+5.38%",  "+18.15%",       "--",
          "Consumer Staples (.GSPS)",  "+1.39%",  "+1.39%",  "+0.63%",  "-5.07%",  "+2.81%",  "-1.56%",  "+0.65%",  "+25.83%",  "+51.02%",  "+86.03%",
               "Health Care (.GSPA)",  "+1.33%",  "+1.33%",  "+2.01%",  "-3.09%",  "+2.62%",  "-4.37%",  "+0.01%",  "+27.83%",  "+57.50%", "+172.73%",
                 "Utilities (.GSPU)",  "+1.02%",  "+1.01%",  "+0.69%",  "-6.35%",  "+1.71%",  "-8.31%", "-12.37%",   "+7.67%",  "+29.91%",  "+72.77%",
    "Information Technology (.GSPT)",  "+0.51%",  "+0.51%",  "+4.08%", "+11.11%", "+24.95%", "+35.80%", "+20.66%",  "+71.61%", "+136.45%", "+480.67%",
    "Communication Services (.GSPL)",  "+0.10%",  "+0.10%",  "+2.85%",  "+7.61%", "+23.67%", "+33.83%",  "+6.56%",  "+16.97%",  "+46.86%",  "+37.60%",
            "S&P 500 ® Index (.SPX)",  "+1.45%",  "+1.45%",  "+3.16%",  "+2.75%",  "+8.38%", "+11.53%",  "+4.42%",  "+40.14%",  "+56.60%", "+162.60%"
)

sector_performance_tbl %>%
    mutate(across(
        .cols = -sector_name,
        .fns = function(x) {
            y = str_remove(x, "%") %>%
                as.numeric()

            y/100
        }
    )) %>%
    write_csv("temp/funkyheatmaps/sector_performance.csv")


# START ----

sector_performance_tbl <- read_csv("temp/funkyheatmaps/sector_performance.csv")

sector_performance_tbl


sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap()


sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap(palettes = list(numerical_palette = "Greens"))



# CUSTOM ----

palettes <- tribble(
    ~palette,             ~colours,
    "pal_greens",           grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Greens"))(101),
    "pal_red_blue",           grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "RdBu"))(101),
    "pal_blue", grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "RdBu"))(101)[100:101]
)

column_info <- tribble(
    ~id,     ~group,         ~name,                      ~geom,        ~palette,    ~options,
    "id",    "Sector",       "",             "text",       NA,          list(hjust = 0, width = 6),
    "last_pct_change",  "Short Term",      "05:21 PM ET 06/02/2023",         "funkyrect",        "pal_red_blue", lst(),
    "one_day", "Short Term", "1 Day", "funkyrect", "pal_red_blue", lst(),
    "five_day", "Short Term", "5 Day", "funkyrect", "pal_red_blue", lst(),
    "one_month", "Short Term", "1 Month", "funkyrect", "pal_red_blue", lst(),

    "three_month", "Medium Term", "3 Month", "bar", "pal_greens", list(width = 2, legend = FALSE),
    "year_to_date", "Medium Term", "YTD", "bar", "pal_greens", list(width = 2, legend = FALSE),
    "one_year", "Medium Term", "1 Year", "bar", "pal_greens", list(width = 2, legend = FALSE),

    "three_year", "Long Term", "3 Year", "funkyrect", "pal_greens", lst(),
    "five_year", "Long Term", "5 Year", "funkyrect", "pal_greens", lst(),
    "ten_year", "Long Term", "10 Year", "funkyrect", "pal_greens", lst(),

)

column_groups <- tribble(
    ~group, ~palette, ~level1, ~level2,
    "Sector", "#333", "Sector", "",
    "Short Term", "pal_blue", "Short Term", "< 3 Months",
    "Medium Term", "pal_greens", "Medium Term", "< 1 year",
    "Long Term", "pal_greens", "Long Term", "3-10 Years"
)

row_info <- tribble(
    ~ "id", ~ "group",
    "Materials (.GSPM)", "Sectors",
    "Energy (.GSPE)", "Sectors",
    "Industrials (.GSPI)", "Sectors",
    "Consumer Discretionary (.GSPD)", "Sectors",
    "Financials (.GSPF)", "Sectors",
    "Real Estate (.GSPRE)", "Sectors",
    "Consumer Staples (.GSPS)", "Sectors",
    "Health Care (.GSPA)", "Sectors",
    "Utilities (.GSPU)", "Sectors",
    "Information Technology (.GSPT)", "Sectors",
    "Communication Services (.GSPL)", "Sectors",
    "S&P 500 ® Index (.SPX)", "Overall Market"
)

g <- sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap(
        column_info      = column_info,
        column_groups    = column_groups,
        row_info         = row_info,
        palettes         = palettes,
        col_annot_offset = 3.2,
    )

g
