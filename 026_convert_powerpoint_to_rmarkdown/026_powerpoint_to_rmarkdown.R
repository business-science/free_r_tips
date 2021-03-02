# R TIPS ----
# TIP 026 | Convert PowerPoint to Rmarkdown ---
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# slidex: Maintains tables, figures, links and bulleted lists during conversion process

# LIBRARIES ----

# devtools::install_github("datalorax/slidex")

library(slidex)
library(xaringan)

# CONVERSION FROM POWERPOINT TO RMARKDOWN ----
# - PowerPoint created from R using officer R package
#   (Learning Lab PRO: Building an R Package Series - Labs 43-45)
# - Now, we're converting the PPTX file to an Rmarkdown Xaringan Presentation

?convert_pptx

convert_pptx(
    path    = "026_convert_powerpoint_to_rmarkdown/assets/attrition_report.pptx",
    author  = "Matt Dancho",
    out_dir = "./026_convert_powerpoint_to_rmarkdown/assets/",
    force   = TRUE
)

# GET MORE R-TIPS ----

# - R-Tip 005: Automating Excel with openxlsx
# - R-Tip 004: Automating PowerPoint with officer
# - R-Tip 003: Scraping Word Docs
# - R-Tip 007: PDF Reporting


