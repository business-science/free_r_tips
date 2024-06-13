# BUSINESS SCIENCE R TIPS ----
# R-TIP 81 | Tidychatmodels ----

# 👉 CHATGPT FOR DATA SCIENTISTS LIVE WORKSHOP:
#   Learn 15+ data science skills with chatgpt!
#   https://learn.business-science.io/registration-chatgpt-2

# LIBRARIES

devtools::install_github("AlbertRapp/tidychatmodels")

library(tidyverse)
library(tidychatmodels)

# 1.0 OPENAI API KEY SETUP ----

# Edit your R Environment Variables to add your OpenAI API Key:
usethis::edit_r_environ()

# Get your OpenAI API KEY from your environment variables

my_api_key <- Sys.getenv('OPENAI_API_KEY')


# 2.0 TIDY CHAT MODELS ----

chat_openai <- create_chat('openai', Sys.getenv('OPENAI_API_KEY'))
chat_openai

# * Make a virtual chatbot that is designed to return R code ----

rcode_chatbot <- chat_openai %>%
    add_model("gpt-4o") %>%
    add_params('temperature' = 0, 'max_tokens' = 2500) %>%
    add_message(
        role = 'system',
        message = "You are a chatbot that writes R programs and R code scripts.
        You only return R code. Do not return anything else."
    )

# * Ask an R code question ----

rcode_chatbot_message_added <- rcode_chatbot %>%
    add_message(
        role = 'user',
        message = "Create a shiny app that includes a dataset such as
        mtcars and makes a visualization using plotly for columns that the user selects.
        Allow the user to upload an Excel file or CSV file that changes the data being analyzed by
        the plotly plot."
    )

# * Perform the Chat (Costs $) ----

rcode_chatbot_result <- rcode_chatbot_message_added %>% perform_chat()

# * Extracting Results as a data frame ----

rcode_chatbot_result %>% extract_chat(silent = TRUE)

rcode_chatbot_result %>%
    extract_chat(silent = TRUE) %>%
    pluck("message", 3) %>%
    cat()

# OUTPUT: ----

# ```r
# library(shiny)
# library(plotly)
# library(readxl)
#
# ui <- fluidPage(
#     titlePanel("Dynamic Plotly Visualization with User Data Upload"),
#     sidebarLayout(
#         sidebarPanel(
#             fileInput("file", "Upload Excel or CSV File", accept = c(".csv", ".xlsx")),
#             uiOutput("xcol"),
#             uiOutput("ycol")
#         ),
#         mainPanel(
#             plotlyOutput("plot")
#         )
#     )
# )
#
# server <- function(input, output, session) {
#     data <- reactive({
#         req(input$file)
#         ext <- tools::file_ext(input$file$name)
#         if (ext == "csv") {
#             read.csv(input$file$datapath)
#         } else if (ext == "xlsx") {
#             read_excel(input$file$datapath)
#         } else {
#             mtcars
#         }
#     })
#
#     output$xcol <- renderUI({
#         req(data())
#         selectInput("xcol", "X-Axis Variable", choices = names(data()))
#     })
#
#     output$ycol <- renderUI({
#         req(data())
#         selectInput("ycol", "Y-Axis Variable", choices = names(data()))
#     })
#
#     output$plot <- renderPlotly({
#         req(input$xcol, input$ycol)
#         plot_ly(data(), x = ~get(input$xcol), y = ~get(input$ycol), type = 'scatter', mode = 'markers')
#     })
# }
#
# shinyApp(ui, server)
# ```
