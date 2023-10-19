

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
products$product1$quantity_sold <- 1000 * exp(-0.05 * products$product1$price) + rnorm(n, 0, 30)

# Product 2: Moderate price with medium range
products$product2 <- data.frame(
    price = runif(n, 30, 70),
    quantity_sold = NA
)
products$product2$quantity_sold <- 1200 * exp(-0.05 * products$product2$price) + rnorm(n, 0, 25)

# Product 3: Cheaper with lower range but with more variance
products$product3 <- data.frame(
    price = runif(n, 10, 50),
    quantity_sold = NA
)
products$product3$quantity_sold <- 1500 * exp(-0.05 * products$product3$price) + rnorm(n, 0, 50) # Increased SD to 50

# Product 4: Expensive with medium range
products$product4 <- data.frame(
    price = runif(n, 40, 90),
    quantity_sold = NA
)
products$product4$quantity_sold <- 1100 * exp(-0.05 * products$product4$price) + rnorm(n, 0, 25)

# Plot
par(mfrow=c(2,2))
for (i in 1:4) {
    plot(products[[i]]$price, products[[i]]$quantity_sold, main=paste("Product", i),
         xlab="Price", ylab="Quantity Sold", pch=19, col=rgb(0,0.5,0.9,0.5))
    abline(h=0, col="red", lty=2)
}

