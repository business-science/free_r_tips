# R TIPS ----
# TIP 002: Scraping MS Word (docx) Files with R ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# 1.0 LIBRARIES ----
library(officer)
library(janitor)
library(ggtext)
library(tidyverse)


# 2.0 EXTRACT THE DOCX CONTENTS -----
doc <- read_docx("002_scraping_word_docs/Business Science.docx")

content_tbl <- docx_summary(doc) %>% as_tibble()

table_content_tbl <- content_tbl %>%
    filter(content_type == "table cell")

table_content_tbl


# 3.0 FORMAT THE DATA ----

# * Table Headers ----
table_header <- table_content_tbl %>%
    filter(is_header) %>%
    pull(text)

# * Table Contents ----
lecture_analysis_tbl <- table_content_tbl %>%
    filter(!is_header) %>%
    select(text, row_id, cell_id) %>%
    pivot_wider(names_from = cell_id, values_from = text) %>%
    select(-row_id) %>%
    mutate(across(.cols = -1, .fns = parse_number)) %>%
    set_names(table_header) %>%
    clean_names() %>%
    mutate(activity_ratio = lectures_completed / students)


# 4.0 VISUALIZE RESULTS ----
lecture_analysis_tbl %>%
    ggplot(aes(students, lectures_completed)) +
    geom_point(aes(size = activity_ratio)) +
    geom_smooth(method = "loess") +
    geom_richtext(
        aes(label = str_glue("___Course: {course}___<br>Ratio: {round(activity_ratio)}")),
        vjust = "inward", hjust = "inward", size = 3.5
    ) +
    labs(
        title = "Lessons Completed Vs Students",
        x = "No. of Students", y = "No. of Lessons Completed"
    ) +
    scale_y_continuous(label = scales::comma) +
    expand_limits(y = 0) +
    theme_minimal()

# LEARN MORE:
# - Recommendation: DS4B 101-R Course
# - I cover data manipulation & data visualization in-depth in my "R for Business Analysis Course" (DS4B 101-R)
# - LEARN MORE: https://university.business-science.io/p/ds4b-101-r-business-analysis-r

