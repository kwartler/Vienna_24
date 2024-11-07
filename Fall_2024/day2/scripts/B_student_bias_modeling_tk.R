#' Build a model and test for bias
#' TK
#' Oct 30
#' https://raw.githubusercontent.com/Opensourcefordatascience/Data-sets/refs/heads/master/admission.csv


# Library 
library(dplyr)
library(fairness)
library(ggplot2)
library(ggthemes)
library(rpart)
library(randomForest)
library(MLmetrics)

# Data
admissions <- read.csv('https://raw.githubusercontent.com/Opensourcefordatascience/Data-sets/refs/heads/master/admission.csv')

# Let's add some bias for analysis:
appendSyntheticGender <- function(df) {
  set.seed(123)  # For reproducibility
  
  # Create a synthetic gender column with bias
  df <- df %>%
    mutate(syntheticGender = sample(c("Male", "Female"), 
                                    size = n(), 
                                    replace = TRUE, 
                                    prob = c(0.7, 0.3)))  # 70% Male, 30% Female
  
  # Create a bias in admission rates
  # Assume males have a higher acceptance rate
  df <- df %>%
    mutate(admissionStatus = case_when(
      syntheticGender == "Male" ~ ifelse(runif(n()) < 0.75, "Admitted", "Not Admitted"),
      syntheticGender == "Female" ~ ifelse(runif(n()) < 0.50, "Admitted", "Not Admitted")
    )) %>% select(-admit)

  return(df)
}

# Now you can start your modeling workflow
syntheticBias <- appendSyntheticGender(admissions)

#### SEMMA SECTION - students to add
### SAMPLE
set.seed(1234)
idx <- sample(1:400,nrow(syntheticBias)*.8)
train <- syntheticBias[idx,]
test <- syntheticBias[-idx,]

### Exploration
head(train)
table(train$admissionStatus, train$syntheticGender)
ggplot(data = train, aes(x = gre)) +
  geom_density() +
  theme_gdocs() +
  ggtitle('Admissions GRE Distribution') +
  facet_wrap(admissionStatus~.)

### Modify - NA this data is cleaned up

### Model
selectionModel <- rpart(admissionStatus~ gre + gpa + rank,
                        train,
                        method = "class", 
                        minsplit = 1, 
                        minbucket = 1, 
                        cp=.01)

selectionModelRF <- randomForest(as.factor(admissionStatus)~ gre + gpa + rank,
                   train)

### Assess the models
# Assess the decision tree
# decision tree - in sample predictions
decisionTreeTrainPredictions <- predict(selectionModel, train)

# decisions - Out of sample predictions
decisionTreeTestPredictions <- predict(selectionModel, test)

# rf - in sample prediction
rfTrainPredictions <- predict(selectionModelRF, train, type = 'prob')

# rf - out of sample prediction
rfTestPredictions <- predict(selectionModelRF, test, type = 'prob')

# Organize this data into a results data frame - train set
resultsTrain <- data.frame(decisionTreeAdmitted = decisionTreeTrainPredictions[,1],
                           rfAdmitted = rfTrainPredictions[,1],
                           actuals = train$admissionStatus)

# Add my classes based on a cutoff threshold
cutThres <- 0.5
resultsTrain$decisionTreeClass <- ifelse(resultsTrain$decisionTreeAdmitted>=cutThres,
                                         'Admitted',
                                         'Not Admitted')
resultsTrain$rfClass <- ifelse(resultsTrain$rfAdmitted>=cutThres,
                                         'Admitted',
                                         'Not Admitted')

# Organize this data into a results data frame - test set
resultsTest <- data.frame(decisionTreeAdmitted = decisionTreeTestPredictions[,1],
                           rfAdmitted = rfTestPredictions[,1],
                           actuals = test$admissionStatus)
resultsTest$decisionTreeClass <- ifelse(resultsTest$decisionTreeAdmitted>=cutThres,
                                         'Admitted',
                                         'Not Admitted')
resultsTest$rfClass <- ifelse(resultsTest$rfAdmitted>=cutThres,
                               'Admitted',
                               'Not Admitted')


# Decision Tree - confusion matrix - train
table(resultsTrain$decisionTreeClass, resultsTrain$actuals)
# Decision Tree - confusion matrix - test
table(resultsTest$decisionTreeClass, resultsTest$actuals)

# Decision Tree - accuracy - train
Accuracy(y_pred = resultsTrain$decisionTreeClass, 
         y_true = resultsTrain$actuals)

# Decision Tree - accuracy - test
Accuracy(y_pred = resultsTest$decisionTreeClass, 
         y_true = resultsTest$actuals)

# Random Forest - accuracy - train
Accuracy(y_pred = resultsTrain$rfClass, 
         y_true = resultsTrain$actuals)

# Random Forest - accuracy - test
Accuracy(y_pred = resultsTest$rfClass, 
         y_true = resultsTest$actuals)

# Let's examine the relationship of RF to gender
# Append the gender column from the training set
resultsTrain$gender <- train$syntheticGender

# Append the gender column from the training set
resultsTest$gender <- test$syntheticGender

#### DEMOGRAPHIC PARITY REVIEW
# Hint- if you're comparing probability column predictions you need to used probs= within dem_parit
# Training Dem Partity
dem_parity(data = resultsTrain, 
           outcome = 'actuals', 
           group = 'gender',
           probs = 'rfAdmitted', base = 'Male')

# Hint- if you're using classification outcomes you have to switch `Admitted` to 1 & 'Not Admitted' =0 for the original data and the classification outcome levels
dem_parity(data = resultsTrain, 
           outcome = 'actuals', 
           group = 'gender',
           preds = 'rfClass', base = 'Male')

dem_parity(data = resultsTest, 
           outcome = 'actuals', 
           group = 'gender',
           probs = 'rfAdmitted', base = 'Male')

### Test Set Dem Parity
# Hint- if you're using classification outcomes you have to switch `Admitted` to 1 & 'Not Admitted' =0 for the original data and the classification outcome levels
dem_parity(data = resultsTest, 
           outcome = 'actuals', 
           group = 'gender',
           preds = 'rfClass', base = 'Male')


# Please write a comment to interpret the charts

# End