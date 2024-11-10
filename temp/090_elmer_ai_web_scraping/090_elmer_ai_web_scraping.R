# BUSINESS SCIENCE R TIPS ----
# R-TIP 89 | EXPLORING ELMER FOR AI WEB SCRAPING IN R ----


# remotes::install_github("tidyverse/elmer")

# LIBRARIES
library(tidyverse)
library(elmer)
library(httr2)
library(rvest)

# Run this to set your OPENAI_API_KEY:
# usethis::edit_r_environ()


# Make HTTP request
url <- "https://www.cannondale.com/en-us/bikes"
response <- request(url) %>%
    req_perform()
response

# Extract content
content <- response %>% resp_body_string()
content

content <- read_lines("090_elmer_ai_web_scraping/cannondale_bikes.html")

# Parse HTML
html <- read_html(content)
text <- html %>% html_text()
text

# OPENAI Document Summarizer Spec

chat <- elmer::chat_openai(
    api_key = Sys.getenv("OPENAI_API_KEY"),
    model = "gpt-4o-mini"
)

cannondale_bicycles_spec <- type_object(
    # "Summarize the bicycles by name, price and short description for all bicycles found in the website html",
    bike_name = type_array(items = type_string("Name of the bicycle")),
    price = type_array(items = type_number("Price of the bicycle")),
    short_description = type_array(items = type_string("Description of the bicycle"))
)

data <- chat$extract_data(text, spec = cannondale_bicycles_spec)
data

# Return the structured data as a data frame:

data %>%
    as_tibble() %>%
    unnest() %>%
    write_csv("090_elmer_ai_web_scraping/cannondale_bikes.csv")

# Result:

cannondale_bikes_tbl <- read_csv("090_elmer_ai_web_scraping/cannondale_bikes.csv")

cannondale_bikes_tbl

# CONCLUSIONS:
# - You have a powerful example of how to use AI to summarize web data into a data frame
# - There's more to becoming a data scientist
# - If you want to become awesome at R, join my 5-Course R-Track

# 5-COURSE R-TRACK: https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series"
