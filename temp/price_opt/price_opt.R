library(ggplot2)
library(tidyquant)
library(tidyverse)

set.seed(123) # For reproducibility

# Number of observations
n <- 200

# Event data
events <- tibble(
    event_name = c("No Promo", "The Big Game", "Black Friday", "Christmas", "New iPhone"),
    effect = c(0, 0.1, 0.4, 0.2, -0.75)
)

# Function to apply promotions and iPhone launch effects
apply_promotions <- function(product_data) {
    sample_events <- sample(events$event_name, n, replace = TRUE, prob = c(0.7, 0.05, 0.1, 0.05, 0.1))
    effect_multiplier <- events$effect[match(sample_events, events$event_name)]
    product_data %>% mutate(
        event = sample_events,
        # Adjust the "New iPhone" effect to be more prominent as price increases
        adjusted_effect = ifelse(event == "New iPhone", effect_multiplier * price / max(price, na.rm = TRUE), effect_multiplier),
        quantity_sold = pmax(0, quantity_sold * (1 + adjusted_effect)) # Ensure quantity_sold never drops below 0
    )
}

# Generate data for Product 1
product1 <- tibble(
    price = runif(n, 5, 35)
) %>%
    mutate(
        L = 1200,
        k = -0.1,
        x0 = 25,
        quantity_sold = pmax(L / (1 + exp(-k * (price*0.5 - x0))) + rnorm(n, 0, 75), 0),
        product = "Standard Case | iPhone 15 Pro Max"
    ) %>%
    apply_promotions()

# Generate data for Product 2
product2 <- tibble(
    price = runif(n, 30, 70)
) %>%
    mutate(
        L = 1000,
        k = -0.1,
        x0 = 50,
        quantity_sold = pmax(L / (1 + exp(-k * (price*0.65 - x0))) + rnorm(n, 0, 50), 0),
        product = "Premium Case | iPhone 15 Pro Max"
        # decay_rate = if_else(price > 45, 0.023, 0.02),
        # quantity_sold = pmax(1600 * exp(-decay_rate * price) + rnorm(n, 0, 50), 0),
        # product = "product2"
    ) %>%
    apply_promotions()

# Generate data for Product 3
product3 <- tibble(
    price = runif(n, 10, 50)
) %>%
    mutate(
        quantity_sold = pmax(1900 * exp(-0.055 * price) + rnorm(n, 0, 100), 0),
        product = "Standard Case | iPhone 15 Pro"
    ) %>%
    apply_promotions()

# Generate data for Product 4
product4 <- tibble(
    price = runif(n, 40, 90)
) %>%
    mutate(
        quantity_sold = pmax(1100 * exp(-0.025 * price) + rnorm(n, 0, 75), 0),
        product = "Premium Case | iPhone 15 Pro"
    ) %>%
    apply_promotions()


# Combine data
combined_data <- bind_rows(product1, product2, product3, product4) %>%
    mutate(promo_event = ifelse(event == "No Promo", NA, "Promo Event")) %>%
    mutate(quantity_sold = round(quantity_sold)) %>%
    mutate(price = round(price, 2))

# Plot
ggplot(combined_data, aes(x=price, y=quantity_sold, color=product)) +
    geom_point() +
    # geom_point(color = "red", size = 5, shape = 21, data = combined_data %>% filter(promo_event == "Promo Event")) +
    geom_smooth(span = 1, level = 0.999) +
    # facet_wrap(~ product, scales = "free") +
    labs(title="Price Elasticity and Optimization",
         subtitle="Price vs. Quantity Sold for iPhone Case Products with Promotions",
         x="Price",
         y="Quantity Sold") +
    theme_tq() +
    scale_color_tq(name="Product") +
    theme(legend.position="bottom")

# Final Dataset:
combined_data %>%
    select(price, quantity_sold, product, event) %>%
    write_csv("temp/price_opt/price_opt.csv")

