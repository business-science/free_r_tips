# BUSINESS SCIENCE R TIPS ----
# R-TIP 72 | How To Make A Data Science Portfolio ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter


# 1.0 INSTALL LIBRARIES ----
# Note - portfoliodown is ONLY available on GitHub (not CRAN)
remotes::install_github("business-science/portfoliodown")

library(portfoliodown)

# 2.0 MAKE A NEW PORTFOLIO SITE ----

portfoliodown::new_portfolio_site(
    "072_data_science_portfolio_website/my_portfolio_website",
    theme = "raditian"
)

# 3.0 SERVE THE PORTFOLIO SITE ----

portfoliodown::serve_site(
    .site_dir = "072_data_science_portfolio_website/my_portfolio_website/"
)

# 4.0 EDIT YOUR PORTFOLIO SITE ----
#  Navigate to data\homepage.yml
#  Make changes to content

# 5.0 EDIT YOUR PORTFOLIO SITE IMAGES ----
# Add static > img folder
# I added showcase \ logo-business-science.png
# Then update the homepage.yml to point to the image from the path relative to the img folder.
# img\showcase\logo-business-science.png

# Sometimes needed to refresh the images

blogdown::stop_server()

portfoliodown::serve_site(
    .site_dir = "072_data_science_portfolio_website/my_portfolio_website/"
)

# 6.0 EDIT YOUR PORTFOLIO ----
# Update the homepage.yml work section

# 7.0 PUBLISH ----
# Use usethis::use_github()
# Deploy to Netlify

# 8.0 QUESTION? ----
# DO YOU:
#   1. Need data science skills: Data Visualization, Time Series, Machine Learning, Production, Web Apps, and Cloud?
#   2. Data science projects to fill your portfolio?
#   3. Know how to communicate your results to non-technical audiences?
#   4. Know how to build production web applications?
#   5. Know how to work with a team?
# IF YOU NEED ANY OF THESE, I CAN HELP:
#  https://learn.business-science.io/free-rtrack-masterclass



