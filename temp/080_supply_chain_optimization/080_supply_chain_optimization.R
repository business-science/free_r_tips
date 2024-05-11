# BUSINESS SCIENCE R TIPS ----
# R-TIP 80 | Supply Chain Optimization ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


# Libraries
library(lpSolve)

# Define the costs
production_cost_per_unit <- 10
transport_cost_per_unit  <- 5
storage_cost_per_unit    <- 2

# Total transport cost including storage
total_transport_cost_per_unit <- transport_cost_per_unit + storage_cost_per_unit

# Objective function coefficients
objective <- c(production_cost_per_unit, total_transport_cost_per_unit)

# Constraints matrix
# Production units, Transport units
constraints <- matrix(c(1, 0,   # Production <= 1000 units
                        1, -1,  # Production units >= Transport units
                        0, 1),  # Transport units >= 800 units
                      nrow=3, byrow=TRUE)

# Right-hand side of the constraints
rhs <- c(1000, 0, 800)

# Directions of the constraints
directions <- c("<=", ">=", ">=")

# Solve the linear programming problem
solution <- lp("min", objective, constraints, directions, rhs)


# Check if the solution is optimal
if(solution$status == 0) {
    print("Solution is optimal")
    print(paste("Optimal Production units:", solution$solution[1]))
    print(paste("Optimal Transport units:", solution$solution[2]))
    print(paste("Total Cost:", solution$objval))
} else {
    print("Solution is not optimal")
    if(solution$status == 1) {
        print("Solution is infeasible")
    } else if(solution$status == 2) {
        print("Solution is unbounded")
    } else if(solution$status == 3) {
        print("Solution is degenerate")
    } else {
        print("Solution could not be found due to numerical difficulties")
    }
}

