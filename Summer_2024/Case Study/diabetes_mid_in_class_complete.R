#' Author: Ted Kwartler
#' Date: 6-30-2024
#' Purpose: Case Study - Obtain, Scrub, Explore, Model, Interpret
#' 

# Libraries 
library(vtreat)
library(ggplot2)
library(ggthemes)
library(dplyr)

# Obtain the data
drNotes <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/drNotes.csv')
drugData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/drugData.csv')
hospitalStayData <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/hospitalStayData.csv')
patientDemographic <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/diabetes_tables/patientDemographics.csv')

# Explore the first 6 rows and column names
head(drNotes) #not using 
head(drugData) # lets use this data
head(hospitalStayData) # lets use this data and y=readmitted
head(patientDemographic) # lets use this data

# Explore darta quality and select the appropriate x variables
summary(drugData)
apply(drugData[,2:28],2,table) # some have no variance and will not be modeled
apply(hospitalStayData[,2:15],2,table) # good data to be used
apply(patientDemographic[,2:5],2,table) 

# Scrub the patientDemographic age data to remove [ and - and ) 
#patientDemographic$age <- gsub(')',']', patientDemographic$age)
# strsplit on the - and extarct the numbers

# Build a density plot for Num Diag
ggplot(hospitalStayData, aes(x = number_diagnoses)) +
  geom_density() + 
  theme_economist_white() +
  ggtitle('Diabetes Patient Number of Diagnoses')
ggsave('~/Desktop/Vienna_July24/personalFiles/Diabetes Patient Number of Diagnoses.jpg')

# number_outpatient histogram
ggplot(hospitalStayData, aes(x = number_outpatient)) +
  geom_histogram() +
  theme_dark() + 
  ggtitle('Diabetes Patient Number of Outpatient')
ggsave('~/Desktop/Vienna_July24/personalFiles/Diabetes Patient Number of Outpatient.jpg')

# Let's remove patientDemographic$weight because it has 9.6K ? values
patientDemographic$weight <- NULL

# Join the data
joinData <- patientDemographic %>% 
  left_join(drugData, by = 'id') %>%
  left_join(hospitalStayData, by  = 'id')

# Declare your modeling set up variables
informativeFeatures <- names(joinData)[2:44]
yVariable <- 'readmitted'

# Scrub the data for univariate columns and build dummy variables
plan <- designTreatmentsC( dframe = joinData,
                           varlist = informativeFeatures,
                           outcomename = yVariable,
                           outcometarget = TRUE)

treatedJoinedData <- prepare(plan, joinData)

write.csv(treatedJoinedData, '~/Desktop/Vienna_July24/personalFiles/modelinMatrix.csv',row.names = F)

# Success for day 1 is a modeling matrix that has been cleaned meaning no missing data and dummy variables have been created where appropriate

# End