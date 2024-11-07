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

# Organize this data into a results data frame
resultsTrain <- data.frame()

# Decision Tree - confusion matrix
# Decision Tree - accuracy

#### DEMOGRAPHIC PARITY REVIEW
# Hint- if you're comparing probability column predictions you need to used probs= within dem_parity
dem_parity(data = ___, 
           outcome = '___', 
           group = '___',
           probs = '___', base = '___')

# Hint- if you're using classification outcomes you have to switch `Admitted` to 1 & 'Not Admitted' =0 for the original data and the classification outcome levels
dem_parity(data = ___, 
           outcome = '___', 
           group = '___',
           preds = '___', base = '___')

# Please write a comment to interpret the charts

# End