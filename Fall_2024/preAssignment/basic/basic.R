#' Title: Basic PreModule Assignment
#' Author: [please change to your name when turning in]
#' Data: [please add your date]

# Remember to install pacakges the first time you have to use the following code
# Remove the # in front of the following lines to activeate the code
# install.packages('ggplot2')
# install.packages('ggthemes')
# install.packages('dplyr')

# Once you have used install.packageS() you then call the functions from the library using library() to load libraries
# ggplot2 for data visualization
# ggthemes for themes in ggplot2
# dplyr for data manipulation
library(___)
library(___)
library(___)

# Practice creating some objects 
x <- _ # Assign the numeric value 5 to x
y <- _ # Assign the numeric value 7 to y
z <- _ + _ # Add x and y and assign the result to z
print(paste("The sum of x and y is: ", z)) # Display the sum of x and y

# Le'ts show how and if else statement works.
# The If-else operation chckes a condition and execute code accordingly
# The condition to check is whether z > 10
if (_ > __) {
  print("z is greater than 10") # If z > 10
} else {
  print("z is not greater than 10") # If z is not > 10
}

# Here is another ifelse function to try
# This function will have a condition, then with commas perform the other operation.  
# Psudeo code is like this:
# ifelse(condition to check, TRUE operation, FALSE operation)
# Create an object called result
# use ifelse() to check if x is greater than y
# if TRUE then assign "x is greater"
# if FALE then assign "y is greater" 
# finally use print() on the result object
___(___)

# Now we will create a vector called vec using the c() function to combine the vector
# The vector will have the integers 15, 20, 25
___ <- _(__, __, __)

# Now we will use a loop to repeat an operation using the values from the vector
# Loops are important when you want to perform repetitive operations
# Loops make your code less error prone
# To setup a loop you use a for() function
# I prefer to use a temporary variable i like this 
# for(i in 1:lenth(vec)){
# some operation
# }
for(i in 1:length(___)) {
  x <- ___[i] # select the value from the vec vector 1 at a time as i iterates
  ___(x^2) # Apply print() while squaring each value of the x variable
}

# Load Data (mtcars data is preloaded in R)
# This is a car dataset form motor trend
data("___") 

# Get Some summary() Statistics of mtcars; it will return the min, max, mean, median, 1st and 3rd quartiles.
___(___)

# Now we will use some "tidy-verse" syntax and the pipe operator which "forwards" objects
# Tidy Verse operates like this psuedo code
# object %>% function(variable name) %>% function(...)
# Using mtcars as the initial object
# forward it to the group_by() function and apply it to the cyl variable
# This is forwarded again to dplyr's summarize() function
# The avgMPG is calaculated from the mean of the mpg variable
# The avgHP is calculated from the mean of the hp variable
# The minHP variable is calculated with the min of the hp variable
# The maxHP variable is calculated with the max of the hp variable 
___ %>%
  ___(___) %>%
  ___(avgMPG = mean(___), 
      avgHP  = ___(__), 
      minHP  = min(__), 
      maxHP = ___(__))

# Visualizations using ggplot. 
# The scatter plot helps visualize how two variables are related
# Use ggplot with mtcars where x is mpg and y is hp
# Add a scatter plot layer with geom_point()
# Add a labs() layer with a title "HP vs MPG Scatter Plot"
# within labs() add x label "Miles Per Gallon" and y label as "Horse Power"
# Add theme_economist()
___(___, aes(x=___, y=__)) + 
  ___() +
  labs(title="___", x="___", y="___") + 
  ___()

# Make a box_plot using ggplot
# data is mtcars, x is the cyl, and y is hp
# add the labs() layer with 
# title="Box Plot of HP Across Number of Cylinders", 
# x="Number of Cylinders", 
# y="Horse Power"
# Add theme_economist() as the last layer
__(___, aes(x=factor(___), y=__)) +
  geom_boxplot() +
  ___(___="___", 
      _="___", 
      _="___") +
  ___()

# Examine the dataset for outliers. boxplot.stats() returns the statistics used in boxplot
# Apply boxplot.stats() to the hp column of mtcars; leave the rest the same to get the correct cutoffs from the function
# Assign this object name as outlierBounds
___ <- ___.___(___$__)$stats[c(1, 5)]

# Now let's use tidy-verse again
# we will forward mtcars to the 
# mutate function
# within mutate, let's create a new variable caleld hpOutlier
# this is calculated with ifelse statement
### the condition is hp is less than the first outlierBounds value
### Note the straight line | operator is an "OR" operator
### the second condition is to check if hp is greater than the second value of outlierBounds
# This code will create a new variable that checks if a hp value is a low outlier OR high outlier.  The new varialbe will have two labels, "Outlier" or "Not Outlier"
mtcars <- ___ %>%
  ___(hpOutlier = ifelse(__ < outlierBounds[1] | __ > ___[2], 
                         "Outlier", 
                         "Not Outlier"))

# Build a Model. Here we're building a simple linear regression model. The model predicts 'hp' based on 'mpg' using data mtcars
model <- lm(hp ~ ___, data=___)

# Apply summary() to the model object to see coefficients, residuals, etc.
___(___)  

# We are synthetically creating a fake data set to make predictions on.
# The new object is newData
# Apply the data.frame() function
___ <- ___.___(mpg = seq(10, 30, by = 5))  # New mpg values for which we want to predict hp

# Now we will make predictions using the predict() function on the newData 
# The new object is called lmPreds
___ <- ___(model, newData)

# Print the mpg and their predicted hp
___(data.frame(MPG=newData$mpg, predictedHP=lmPreds)) 

# End
