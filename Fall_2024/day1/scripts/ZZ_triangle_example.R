#' Create example of the triangle distribution
#' TK
#' Oct 30, 2024

# Install and load triangle library
library(triangle)

# Define distribution parameters
a <- 1  # Minimum
b <- 10 # Maximum
c <- 5  # Mode

# Create triangle distribution object
dist <- rtriangle(10000,a, b, c)

# Quick plot
plot(hist(dist))

# Define distribution parameters
a <- 1  # Minimum
b <- 10 # Maximum
c <- 3  # Mode

# Create triangle distribution object
dist <- rtriangle(10000,a, b, c)

# Quick plot
plot(hist(dist))





# End