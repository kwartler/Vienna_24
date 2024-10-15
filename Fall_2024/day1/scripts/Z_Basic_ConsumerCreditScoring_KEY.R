#' Author: Ted Kwartler
#' Date: Oct 31, 2022
#' Purpose: Lending Club score notes and visualize
#' 

# WD
setwd("~/Desktop/Harvard_DataMining_Business_Student/personalFiles")

# Options
options(scipen = 999)

# Libraries
# only if you want to explore other algo types
#library(randomForest)
#library(rpart)
# Load libraries dplyr, caret, e1071, vtreat, MLmetrics, ggplot2, ggthemes
library(dplyr)
library(caret)
library(e1071)
library(vtreat)
library(MLmetrics)
library(ggplot2)
library(ggthemes)

# Read in the data 20K_sampleLoans.csv
df <- read.csv('https://raw.githubusercontent.com/kwartler/Harvard_DataMining_Business_Student/master/Lessons/I_CreditModeling/data/20K_sampleLoans.csv') 

# Read in the new notes for possible investment OpenNotesJune18_v2.csv
newNotes <- read.csv('https://raw.githubusercontent.com/kwartler/Harvard_DataMining_Business_Student/master/Lessons/I_CreditModeling/data/OpenNotesJune18_v2.csv')

# Keep the pertinent information; you *could* explore other variables but for now these are good enough
keeps <- c("loan_amnt", "term", "int_rate", "installment", "grade", "sub_grade", "emp_length" , "home_ownership", "annual_inc", "purpose", "title", "zip_code", "addr_state", "dti", "delinq_2yrs", "pub_rec_bankruptcies", "inq_last_6mths", "mths_since_last_delinq", "mths_since_last_record", "open_acc", "pub_rec", "revol_bal", "revol_util", "total_acc", "collections_12_mths_ex_med","y")
df    <- df[,keeps]

# Clean up the data with as.numeric, gsub in the following columns
# revol_util, int_rate, term, revol_bal, int_rate
# This will remove % and also the space and months used in the terms " months" 
# vs "36 months" For both types of values we want just numeric
# These steps need to be done on the historical data `df` and the `newNotes`
df$revol_util <- as.numeric(gsub('%', '', df$revol_util))
df$int_rate   <- as.numeric(gsub('%', '', df$int_rate))
df$term       <- as.numeric(gsub(' months','',df$term))
newNotes$revol_bal <- as.numeric(gsub('%', '', newNotes$revol_bal))
newNotes$int_rate  <- as.numeric(gsub('%', '', newNotes$int_rate))
newNotes$term      <- as.numeric(gsub(' months','',newNotes$term))

## Sample & Segment the prep data
set.seed(1234)
idx         <- sample(1:nrow(df),.1*nrow(df))
prepData    <- df[idx,]
nonPrepData <- df[-idx,]

## Modify
# Design a "C"ategorical variable plan 
dataPlan <- designTreatmentsC(dframe        = prepData, 
                              varlist       = keeps,
                              outcomename   = 'y', 
                              outcometarget = 1)

# Apply to 90% leftover data so all of the historical data is cleaned 
treatedX <- prepare(dataPlan, nonPrepData)

# Partition the 90% to avoid over fitting when modeling
set.seed(2022)
idx        <- sample(1:nrow(treatedX),.8*nrow(treatedX))
training   <- treatedX[idx,]
validation <- treatedX[-idx,]

## Explore
head(training)

# Model w/cross-validation; this shuffles partitions within the training data and results in a more stable model fit.  This will create 10 mini-partitions inside the training data and fit a model multiple times using 9 of the sections at a time 
crtl <- trainControl(method      = "cv", 
                     number      = 10,
                     verboseIter = TRUE)

# Fit lm model using 10-fold CV: model; you can use ranger and rpart too
finalFit <- train(as.factor(y) ~ ., 
                  data      = training, 
                  method    = "glm", 
                  family    = "binomial",
                  trControl = crtl)

# Make predictions for 2 partitions of the historical notes
trainProbs    <- predict(finalFit, training, type = 'prob')
testProbs     <- predict(finalFit, validation, type = 'prob')

# Remember the new notes need to be "prepared" with dataPlan for the model!
treatedNew    <- prepare(dataPlan, newNotes) 
newNotesProbs <- predict(finalFit, treatedNew, type = 'prob')

# Change the cutoff threshold
# 0.50 isn't a useful cutoff and its often better to be more accurate in the upper probabilities in this type of use case.
cutoff              <- 0.80
cutoffProbsTrain    <- ifelse(trainProbs[,2]>=cutoff, 1, 0) 
cutoffProbsTest     <- ifelse(testProbs[,2]>=cutoff, 1, 0) 
cutoffProbsNewNotes <- ifelse(newNotesProbs[,2]>=cutoff, 1, 0) 

# Accuracy for training and validation y versus the cutoffProbsTrain & cutoffProbsTest
Accuracy(training$y, cutoffProbsTrain)
Accuracy(validation$y, cutoffProbsTest)

# Simple confusion matrix for both training$y, cutoffProbsTrain & validation$y, cutoffProbsTest
table(training$y, cutoffProbsTrain)
table(validation$y, cutoffProbsTest)

## Since you're likely not going to invest in all loans you may want to focus on the "A" loans that they believe are the best quality.
# You can also add your probability of default from your model
# If you use ranger or rpart you will have to adjust the risk column

# Organize the actual outcomes, LendingCLub best guess and the model's probability
testSetComparison <- data.frame(y     = validation$y, #actual outcome
                                grade = nonPrepData[-idx,]$grade, #lending club guess
                                risk  = testProbs[,1]) #probability of 0 in model

# Examine a portion of the organized data
head(testSetComparison)

# Get their best guess of "A" models using subset()
onlyA <- subset(testSetComparison, testSetComparison$grade == "A")

# Now create another version where you subset to their best guest "A" models 
# And also get your model's best guess where default probability is less than .1 (10%)
testSetBEST <- subset(testSetComparison, 
                      testSetComparison$grade == "A" & 
                      testSetComparison$risk <= 0.1 )

# Let's understand how many defaults are in the data set overall
# This would be a random selection of notes
sum(testSetComparison$y==0) / nrow(testSetComparison)

# Let's understand how many defaults are in the data within the "A" notes which is Lending Club's best guess.  
sum(onlyA$y==0)/nrow(onlyA)

# Finally let's combine how many defaults are within the "A" (their best guess) and when our model is applied to see if there is an uplift to finding good notes
# This combines their expertise & our model
sum(testSetBEST$y==0) / nrow(testSetBEST)

# It looks like A plus our model does provide a lift over random and just their 
# best guess.  
# Now let's apply that logic to the new notes
scoredNotes <- data.frame(id           = 1:nrow(treatedNew),
                          risk         = newNotesProbs[,1],
                          successProb  = newNotesProbs[,2],
                          reward       = newNotes$int_rate,
                          LCgrade      = newNotes$grade)

# Sort  by least risky and examine
scoredNotes <- scoredNotes[order(scoredNotes$risk),]
head(scoredNotes, 10)

# Subset to "A" & 10%; our and their best guess
bestNotes <- subset(scoredNotes, 
                    scoredNotes$LCgrade == "A" & scoredNotes$risk <= 0.1)

# Make a mkt ggplot2, capm style 
# data is bestNotes
# x= risk
# y = reward
# make it a scatter plot layer with geom_point()
# add a theme_gdocs() layer
# Add a horizontal line that is "dashed" and "red"
# Annotate the line with the label "Historical S&P500 return"
# Annotate another line with "5yr T-Bill Historical Avg Return"
ggplot(data = bestNotes, aes(x= risk, y = reward)) + 
  geom_point() + 
  geom_text(aes(label = id, vjust = -0.5)) +
  theme_gdocs() +
  geom_hline(yintercept = 7, linetype = "dashed", color = "red")  +
  annotate("text", x = .025, y = 7.1, label = "Historical S&P500 return", color = "red") +
  geom_hline(yintercept = 5.86, linetype = "dashed", color = "red") +
  annotate("text", x = .025, y = 5.96, label = "5yr T-Bill Historical Avg Return", color = "red")

# Make an interactive plot; you can leave this as is
bestNotes |>
  e_charts(risk) |>
  e_scatter( reward, bind = id) |>
  e_tooltip(
    formatter = htmlwidgets::JS("
      function(params){
        return('<strong> noteID: ' + params.name + 
                '</strong><br />risk: ' + params.value[0] + 
                '<br />reward: ' + params.value[1]) 
                }
    ")) |>
  e_toolbox_feature(feature = "dataZoom") |>
  e_mark_line(data = list(yAxis = 7), title = "Historical SP500 Avg Return") |>
  e_mark_line(data = list(yAxis = 5.86), title = "Historical 5yr T-Bill Return")



# End