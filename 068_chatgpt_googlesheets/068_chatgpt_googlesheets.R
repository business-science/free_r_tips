# BUSINESS SCIENCE R TIPS ----
# R-TIP 068 | ChatGPT: Automate Google Sheets with R ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# PROMPT 1: ----
#  how to make a google sheet with R

# Load the googlesheets4 package
# install.packages("googlesheets4")
library(googlesheets4)

# Authenticate with Google Sheets
gs4_auth()

# Create a new Google Sheet
new_sheet <- gs4_create("R-Tip 068: Automate Google Sheets")

# Create a sample data frame
data <- data.frame(
    Name = c("Alice", "Bob", "Charlie"),
    Age = c(25, 30, 28)
)

# Write the data to the new Google Sheet
write_sheet(data, new_sheet, sheet = "data")

# Access an existing Google Sheet by URL or title
existing_sheet <- gs4_find("R-Tip 068")

# * ERROR: CHATGPT HALUCINATION ----
# Update data in the existing Google Sheet
# sheets_edit_cells(existing_sheet, range = "A2:B4", values = data)


# PROMPT 2: ----
#  How to locate a google sheet by its id or URL?

# Load the googlesheets4 package
library(googlesheets4)

# Replace 'your_sheet_url' with the actual URL of the Google Sheet
sheet_url <- "https://docs.google.com/spreadsheets/d/your_sheet_id/edit"

sheet_url <- "https://docs.google.com/spreadsheets/d/1Ts_XbrxbR5Lswu_8N6jnHprx7Q7TG9M8-9qt7CLsB2w"


# Extract the sheet ID from the URL
sheet_id <- tools::file_path_sans_ext(basename(sheet_url))
sheet_id

# Get the Google Sheet by ID
sheet_by_url <- gs4_get(sheet_id)
sheet_by_url


# Write mpg data
write_sheet(
    data  = ggplot2::mpg,
    ss    = sheet_by_url,
    sheet = "mpg"
)


# LEARNING MORE: LIVE CHATGPT FOR DATA SCIENTISTS WORKSHOP ----
# 👉 Register Here: https://learn.business-science.io/registration-chatgpt-2?el=youtube
