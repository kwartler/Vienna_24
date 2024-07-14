#' Author: Ted Kwartler
#' Date: 6-30-2024
#' Purpose: Case Study - Obtain, Scrub, Explore, Model, Interpret
#' 

# Libraries 

# Obtain the data
drNotes <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/drNotes.csv')
drugData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/drugData.csv')
hospitalStayData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/hospitalStayData.csv')
patientDemographic <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/patientDemographics.csv')

# Join the data
# Join in this order to simplicity
# patientDemographic>drugData>hospitalStayData>drNotes

# Scrub the data - account for missing with dummy variables; drop the dr notes section if you joined it; an easy method after the join is to explore the library(vtreat) or use the various dummy packages to help you; and remember you can use GPT!


# Explore the data - create a lot of visuals and summary statistics understanding aspects of the data, correlations, frequencies etc

# Arrange into a modeling matrix of relevant data inputs and the y variable & save a copy

# Success for day 1 is a modeling matrix that has been cleaned meaning no missing data and dummy variables have been created where appropriate

# End