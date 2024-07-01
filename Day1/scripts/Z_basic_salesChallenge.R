#' Author: Ted Kwartler
#' Date: 6-30-2024
#' Purpose: Case Study - 
#' 
# Libraries
library(ggplot2)
library(ggthemes)
library(lubridate)
options(scipen = 999)

# Read in the data
salesData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/salesData.csv')

# Get a summary of the data
str(salesData)
summary(salesData)

# change Price.Each column to numeric
salesData$Price.Each <- as.numeric(salesData$Price.Each)

# Make sure the sales column is numeric
salesData$Price.Each <- as.numeric(salesData$Price.Each)

# Make sure the number ordered is numeric
salesData$Quantity.Ordered <- as.numeric(salesData$Quantity.Ordered)

# Density plot of Price.Each
ggplot(data = salesData, aes(x = Price.Each)) + 
  geom_density() +
  theme_gdocs() +
  ggtitle("Distribution of Unit Price")

# Tally the products
prodTally <- as.data.frame(table(salesData$Product))

# Order the tally
prodTally <- prodTally[order(prodTally$Freq, decreasing = T),]

# Select the top 5 products
topFive <- prodTally[1:5,]
topFive <- head(prodTally, 5)

# Create a col chart
ggplot(data = topFive, aes(x = Var1, y = Freq)) +
  geom_col() + theme_few() +
  ggtitle('top 5 product sales') + 
  theme(axis.text.x = element_text(angle = 90))

# Engineer variables from days
salesData$Order.Date  <- mdy_hm(salesData$Order.Date) #overwrite as a data object
salesData$dayOfWeek   <- wday(salesData$Order.Date)
salesData$dayOfMonth  <- mday(salesData$Order.Date)
salesData$weekday     <- weekdays(salesData$Order.Date)
salesData$hourOfDay   <- hour(salesData$Order.Date)
salesData$dayOfYear   <- yday(salesData$Order.Date)
salesData$month       <- month(salesData$Order.Date)
salesData$year        <- year(salesData$Order.Date)


# Examine a portion of the data 

# Tally (table) the year column to see if there is any data skew


# Subset the data to just "2019" 
# hint: salesData <- subset(data object, column name == 2019) 
# *remember the double ==* 

# Let's aggregate up by month
salesData$orderRevenue <- salesData$Quantity.Ordered * salesData$Price.Each
monthlySales <- aggregate(orderRevenue ~ month, salesData, sum)
monthlySales

# Change to month name
monthlySales$month <-  month.name[monthlySales$month]

# Find maximum month
monthlySales[which.max(monthlySales$orderRevenue),]

# Data prep for visual
monthlySales$month <- factor(monthlySales$month, levels = month.name)

# Plot
ggplot(monthlySales, aes(x = month, y = orderRevenue,  group = 1)) + 
  geom_line() + 
  scale_x_discrete(limits = month.name) + 
  theme_gdocs() + 
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle('Sales by month')
# End