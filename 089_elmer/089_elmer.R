# BUSINESS SCIENCE R TIPS ----
# R-TIP 89 | EXPLORING ELMER FOR AI DATA SUMMARIZATION IN R ----

# Goal: Explore the elmer library for AI data summarization in R


# remotes::install_github("tidyverse/elmer")

# LIBRARIES
library(tidyverse)
library(elmer)
library(httr2)
library(rvest)

# Run this to set your OPENAI_API_KEY:
usethis::edit_r_environ()

# 1.0 CHAT SETUP & BASIC USAGE
chat <- elmer::chat_openai(
    api_key = Sys.getenv("OPENAI_API_KEY"),
    model = "gpt-4o-mini"
)

# CHAT BASIC USAGE

mayo_recipe <- chat$chat(
    "What is the recipe for mayonaise?",
    echo = FALSE
)

mayo_recipe


# 2.0 DATA ANALYTICS: GET STRUCTURED DATA FROM A WEBSITE
# - Uses httr2 to get the web page data
# - Uses openai to structure and summarize the data

# Make HTTP request
url <- "https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series"
response <- request(url) %>%
    req_perform()
response

# Extract content
content <- response %>% resp_body_string()
content

# Parse HTML
html <- read_html(content)
text <- html %>% html_text()
text

# OPENAI Document Summarizer Spec

course_summary <- type_object(
    "Summary of the course structure and program",
    course_name = type_string("Name of the course"),
    course_description = type_string("Description of the course"),
    estimated_hours = type_number("Estimated number of hours of video in the course")
)

data <- chat$extract_data(text, spec = course_summary)
data

# Return the structured data as a data frame:

data %>% as_tibble()

# Result:

course_summary_tbl <- read_csv("089_elmer/data/course_summary.csv")

course_summary_tbl

# CONCLUSIONS:
# - You have a powerful example of how to use AI to summarize web data into a data frame
# - There's more to becoming a data scientist
# - If you want to become awesome at R, join my 5-Course R-Track

# 5-COURSE R-TRACK: https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series"
