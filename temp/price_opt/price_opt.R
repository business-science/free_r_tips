
library(ggplot2)
library(tidyquant)

set.seed(123) # For reproducibility

# Number of observations
n <- 100

# Generate data for 4 products
products <- list()

# Product 1: Expensive with high range
products$product1 <- data.frame(
    price = runif(n, 50, 100),
    quantity_sold = NA
)
products$product1$quantity_sold <- pmax(1200 * exp(-0.05 * products$product1$price) + rnorm(n, 0, 30), 0)

# Product 2: Moderate price with medium range
products$product2 <- data.frame(
    price = runif(n, 30, 70),
    quantity_sold = NA
)
decay_rate <- ifelse(products$product2$price > 45, 0.023, 0.02)
products$product2$quantity_sold <- pmax(1600 * exp(-decay_rate * products$product2$price) + rnorm(n, 0, 50), 0)


# Product 3: Cheaper with lower range but with more variance
products$product3 <- data.frame(
    price = runif(n, 10, 50),
    quantity_sold = NA
)
products$product3$quantity_sold <- pmax(1900 * exp(-0.07 * products$product3$price) + rnorm(n, 0, 50), 0)

# Product 4: Expensive with medium range
products$product4 <- data.frame(
    price = runif(n, 40, 90),
    quantity_sold = NA
)
products$product4$quantity_sold <- pmax(1100 * exp(-0.025 * products$product4$price) + rnorm(n, 0, 75), 0)

# Plot
par(mfrow=c(2,2))
for (i in 1:4) {
    plot(products[[i]]$price, products[[i]]$quantity_sold, main=paste("Product", i),
         xlab="Price", ylab="Quantity Sold", pch=19, col=rgb(0,0.5,0.9,0.5))
    abline(h=0, col="red", lty=2)
}

library(ggplot2)

# Combine data for ggplot2
combined_data <- do.call(rbind, lapply(names(products), function(name) {
    df <- products[[name]]
    df$product <- name
    df
}))

# Plot
ggplot(combined_data, aes(x=price, y=quantity_sold, color=product)) +
    geom_point() +
    geom_smooth() +
    labs(title="Price vs. Quantity Sold for 4 iPhone Case Products",
         x="Price",
         y="Quantity Sold") +
    theme_tq() +
    scale_color_tq(name="Product")
