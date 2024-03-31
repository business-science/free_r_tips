# BUSINESS SCIENCE R TIPS ----
# R-TIP 78 | PDF Scraping Process ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


library(tidyverse)
library(pdftools)
library(httr)

file_path <- "078_pdf_scraping/pdf/meta_10k_filing_feb_2024.pdf"

# 1.0 EXTRACT TEXT FROM EVERY PAGE ----

# Extract text
text <- pdf_text(file_path)

# Store text
text %>% write_rds("078_pdf_scraping/text/text.rds")

text <- read_rds("078_pdf_scraping/text/text.rds")

# Inspect the document
length(text) # 147 pages of text

text[1] # PAGE 1 TEXT
text[2] # PAGE 2 TEXT


# 2.0 SUMMARIZE PDF DOCUMENT WITH OPENAI ----

# My API key is stored as an environment variable (see usethis::edit_r_environ())
api_key <- Sys.getenv("OPENAI_API_KEY")

# General API completion endpoint
endpoint <- "https://api.openai.com/v1/chat/completions"

# Combine a Prompt with the document
prompt <- "What are the top 3 biggest risks to Meta?"

text_processed <- str_c(text, collapse = "\\n")

# Note that currently this model can only handle 36K Tokens
text_processed %>% str_sub(1, 20000)


# API request body
body <- list(
    model = "gpt-3.5-turbo", # Correct chat model identifier
    messages = list(
        list(role = "system", content = "You are a helpful assistant."),
        list(role = "user", content = str_c(prompt, text_processed %>% str_sub(1, 30000)))
    )
)

# Ensure 'endpoint' and 'api_key' are correctly defined
response <- POST(
    url = endpoint,  # Make sure this is set to "https://api.openai.com/v1/chat/completions"
    body = body,
    encode = "json",
    add_headers(
        `Authorization` = paste("Bearer", api_key),
        `Content-Type` = "application/json")
)

# Parse the Response
content <- content(response, "parsed")

# Store Response content
content %>% write_rds("078_pdf_scraping_openai/response/content.rds")

content <- read_rds("078_pdf_scraping_openai/response/content.rds")

# Extract the OpenAI API Message
text_chatgpt_response <- content$choices[[1]]$message$content

cat(text_chatgpt_response)


