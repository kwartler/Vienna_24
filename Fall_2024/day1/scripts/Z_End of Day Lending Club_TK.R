#' Author: Ted Kwartler
#' Date: Oct 30 2024
#' Purpose: Lending Club, build a functional model(s) tuning and improving it the best you can.
#' Apply the model to the unknown new notes OpenNotesJune18_v2.csv to identify the best investment options
#'

#### Libraries
library(ggplot2)
library(ggthemes)
library(randomForest)
library(rpart)
library(caret)
library(ranger)
library(DataExplorer)
library(vtreat)

## Custom functions
# Fixing percent
removePercentSign <- function(df, colNamesToFix){
  # select the columns to fix
  x <- df[,colNamesToFix]
  
  # remove the % sign, and make numeric
  for(i in 1:ncol(x)){
    fixedCol <- as.numeric(gsub("%","",x[,i]))/100
    x[,i]    <- fixedCol
  }
  
  finalDF <- df %>% select(-colNamesToFix)
  finalDF <- cbind(x, finalDF)
}


#### Working Directory
setwd('~/Desktop/Vienna_24/personalFiles')

#### Data Load - your dependent variable is "y" which is a binary output; 1 is success 0 is a default
loans <- read.csv('https://github.com/kwartler/Vienna_24/raw/refs/heads/main/Fall_2024/day1/data/20K_sampleLoans.csv')
investmentOpportunities <- read.csv('https://raw.githubusercontent.com/kwartler/Vienna_24/refs/heads/main/Fall_2024/day1/data/OpenNotesJune18_v2.csv')

#### Sample - end of day 1
# First step is to identify the column names in investmentOpportunities and use those to select the same columns in loans.  Second step is to append the loans$y so you have 28 columns in loans.
names(loans)
names(investmentOpportunities)

# identify the shared columns in our loans and investment opportunities
colIndex <- names(loans) %in% names(investmentOpportunities)

# select the shared columns
smallLoans <- loans[,colIndex]

# append the original y variable
smallLoans$y <- loans$y

# Let's fix the percentage columns revol_util, int_rate
smallLoans <- removePercentSign(df            = smallLoans, 
                                colNamesToFix = c('int_rate','revol_util'))

#### SAMPLE - feature engineering/vtreat partitions
set.seed(1234)
idx <- sample(1:nrow(smallLoans), nrow(smallLoans)*.1)
prepData <- smallLoans[idx,]
restData <- smallLoans[-idx,]

# SAMPLE - train/text partitions
set.seed(2024)
idx2 <- sample(1:nrow(restData), nrow(restData)*.8)
trainData <- restData[idx2,]
testData <- restData[-idx2,]

#### EXPLORE
head(trainData)

# Exploration of the Y variable
EDAtableList <- lapply(trainData[c("y", "grade", "purpose", "home_ownership")], table)
two_way_table_grade_y <- table(trainData$grade, trainData$y)


# Plot missing percentage by variables
plot_missing(smallLoans) +theme_gdocs() + ggtitle('Percent of Lending CLub missinginess')
ggsave('pct_missing.jpg')
plot_correlation(smallLoans)

# Plot of annual Income as x; loan amount as y
ggplot(trainData, aes(x = annual_inc, y = loan_amnt, color = as.factor(y))) +
  geom_point(alpha = 0.5) +
  xlim(c(0, 250000)) +
  facet_wrap(term~.) +
  theme_few() +
  ggtitle('Relationship between income and loan amount')

# Plot
ggplot(trainData, aes(x = int_rate, y = grade, color = as.factor(y))) + 
  geom_point() +
  facet_wrap(term~.)


#### Modify - end of day 1
testData$int_rate <- as.numeric(gsub("%","",testData$int_rate))/100

#### Model(s) - end of day 2

#### Assess - end of day 2

#### Apply - end of day 2



# End