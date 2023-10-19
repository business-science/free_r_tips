
library(ggplot2)
library(tidyquant)
library(tidyverse)

set.seed(123) # For reproducibility

# Number of observations
n <- 200

# Generate data for Product 1
product1 <- tibble(
    price = runif(n, 5, 35)
) %>%
    mutate(
        L = 1200,
        k = -0.1,
        x0 = 25,
        quantity_sold = pmax(L / (1 + exp(-k * (price - x0))) + rnorm(n, 0, 75), 0),
        product = "product1"
    )

# Generate data for Product 2
product2 <- tibble(
    price = runif(n, 30, 70)
) %>%
    mutate(
        decay_rate = if_else(price > 45, 0.023, 0.02),
        quantity_sold = pmax(1600 * exp(-decay_rate * price) + rnorm(n, 0, 50), 0),
        product = "product2"
    )

# Generate data for Product 3
product3 <- tibble(
    price = runif(n, 10, 50)
) %>%
    mutate(
        quantity_sold = pmax(1900 * exp(-0.07 * price) + rnorm(n, 0, 50), 0),
        product = "product3"
    )

# Generate data for Product 4
product4 <- tibble(
    price = runif(n, 40, 90)
) %>%
    mutate(
        quantity_sold = pmax(1100 * exp(-0.025 * price) + rnorm(n, 0, 75), 0),
        product = "product4"
    )

# Combine data
combined_data <- bind_rows(product1, product2, product3, product4)

# Plot
ggplot(combined_data, aes(x=price, y=quantity_sold, color=product)) +
    geom_point() +
    geom_smooth() +
    labs(title="Price Elasticity and Optimization",
         subtitle="Price vs. Quantity Sold for iPhone Case Products",
         x="Price",
         y="Quantity Sold") +
    theme_tq() +
    scale_color_tq(name="Product")

