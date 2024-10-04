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


# change Price.Each column to numeric

# Make sure the number ordered is numeric

# Density plot of Price.Each


# Tally the products columns

# Order the tally of products

# Select the top 5 products

# Create a column chart of top5 object


# Engineer variables from days using lubridate functions 
#overwrite Order.Date as a date object

# get day of week in a new variable $dayOfWeek

# get day of the month in a new variable $dayOfMonth 

# get weekday in a new variable $weekday 

# get hour of the day in a new variable $hourOfDay

# get day of the year in a new variable $dayOfYear

# get month in a new variable $month 

# get year in a new variable $year  

# Examine a portion of the data


# Tally (table) the year column to see if there is any data skew


# Subset the data to just "2019" 
# hint: salesData <- subset(data object, column name == 2019) 
# *remember the double ==* 

# Let's aggregate up by month
# 1. quantity times price each in a new variable $orderRevenue
# 2. aggregate orderRevenue by month and apply sum


# Change to month name using R's built in month.name object
# 1. Overwrite the $month column using month.name applied to the numeric column

# Find maximum month with which.max on $orderRevenue)

# Data prep for visual - overwrite $month
# 1. use factor() on the month column with levels = month.name

# Plot
# 1. ggplot() x is month, y is orderRevenue, group = 1
# 2. add a layer geom_line()
# 3. add a layer scale_x_discrete() with limits = month.name
# 4. add a ggtheme layer, you can pick any from the package
# 5. rotate the x axis text by 90 degrees
# 6. add a title to the plot, Sales by Month


# Now your turn.  Try to answer some of the questions or explore on your own!



# End