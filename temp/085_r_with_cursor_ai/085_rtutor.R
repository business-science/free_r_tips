

# INSTALLATION:

# library(remotes)
# install_github("jcrodriguez1989/heyshiny", dependencies = TRUE)
# install_github("gexijin/RTutor")

Sys.set("OPEN_API_KEY") = Sys.getenv("OPENAI_API_KEY")

library(RTutor)
RTutor::run_app()

chattr::chattr_app()
