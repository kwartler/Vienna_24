#' Author: Ted Kwartler
#' Date: 6-30-2024
#' Purpose: EDA on a sales dataset
#' Dataset origination: https://www.kaggle.com/datasets/dhruvkothari19/practice-eda-on-this-sales-dataset?resource=download
#' 
#' Possible questions to answer, but many more are possible!
#' What was the best month for sales? How much was earned that month?  Can you make a line plot of this?
#' What city sold the most product? Can you plot the top 6 cities as a bar chart?  You will need to stringsplit the Purchase.Address by comma and extract the states and cities.  Maybe look up how to map it too!
#' What time should we display advertisements to maximize the likelihood of customers buying products? Maybe check for the most useful hour of the day?
#' What products are most often sold together? This one is HARD and you could use gpt or the library arules to help.
#' What product sold the most and plot the top 6? table() could be helpful
#' 

# Libraries
library(ggplot2)
library(ggthemes)
library(lubridate)
options(scipen = 999)

# Read in the data
salesData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/salesData.csv')

# Get a structure & summary of the data
str(salesData)
summary(salesData)

# change Price.Each column to numeric
salesData$Price.Each <- as.numeric(salesData$Price.Each)

# Make sure the number ordered is numeric
salesData$Quantity.Ordered <- as.numeric(salesData$Quantity.Ordered)

# Density plot of Price.Each
ggplot(data = salesData, aes(x = Price.Each)) + 
  geom_density() +
  theme_gdocs() +
  ggtitle("Distribution of Unit Price")

# Tally the products columns
prodTally <- as.data.frame(table(salesData$Product))

# Order the tally of products
prodTally <- prodTally[order(prodTally$Freq, decreasing = T),]

# Create a column chart of top5 object
topFive <- prodTally[1:5,]
topFive <- head(prodTally, 5)

# Create a column chart of top5
ggplot(data = topFive, aes(x = Var1, y = Freq)) +
  geom_col() + theme_few() +
  ggtitle('top 5 product sales') + 
  theme(axis.text.x = element_text(angle = 90))

# Engineer variables from days using lubridate functions 
#overwrite Order.Date as a date object
salesData$Order.Date  <- mdy_hm(salesData$Order.Date) 

# get day of week in a new variable $dayOfWeek
salesData$dayOfWeek   <- wday(salesData$Order.Date)

# get day of the month in a new variable $dayOfMonth 
salesData$dayOfMonth  <- mday(salesData$Order.Date)

# get weekday in a new variable $weekday 
salesData$weekday     <- weekdays(salesData$Order.Date)

# get hour of the day in a new variable $hourOfDay
salesData$hourOfDay   <- hour(salesData$Order.Date)

# get day of the year in a new variable $dayOfYear
salesData$dayOfYear   <- yday(salesData$Order.Date)

# get month in a new variable $month 
salesData$month       <- month(salesData$Order.Date)

# get year in a new variable $year  
salesData$year        <- year(salesData$Order.Date)

# Examine a portion of the data
head(salesData)

# Tally (table) the year column to see if there is any data skew
table(salesData$year)

# Subset the data to just "2019" 
# hint: salesData <- subset(data object, column name == 2019) 
# *remember the double ==* 
salesData <- subset(salesData, salesData$year==2019)

# Let's aggregate up by month
# 1. quantity times price each in a new variable $orderRevenue
# 2. aggeegate orderRevenue by month and apply sum
salesData$orderRevenue <- salesData$Quantity.Ordered * salesData$Price.Each
monthlySales <- aggregate(orderRevenue ~ month, salesData, sum)
monthlySales

# Change to month name using R's built in month.name object
# 1. Overwrite the $month column using month.name applied to the numeric column
monthlySales$month <-  month.name[monthlySales$month]

# Find maximum month with which.max on $orderRevenue)
monthlySales[which.max(monthlySales$orderRevenue),]

# Data prep for visual - overwrite $month
# 1. use factor() on the month column with levels = month.name
monthlySales$month <- factor(monthlySales$month, levels = month.name)

# Plot
# 1. ggplot() x is month, y is orderRevenue, group = 1
# 2. add a layer geom_line()
# 3. add a layer scale_x_discrete() with limits = month.name
# 4. add a ggtheme layer, you can pick any from the package
# 5. rotate the x axis text by 90 degrees
# 6. add a title to the plot, Sales by Month
ggplot(monthlySales, aes(x = month, y = orderRevenue,  group = 1)) + 
  geom_line() + 
  scale_x_discrete(limits = month.name) + 
  theme_gdocs() + 
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle('Sales by month')

# Now your turn.  Try to answer some of the questions or explore on your own!



# End