#' Build a model and test for bias
#' TK
#' Oct 30
#' https://raw.githubusercontent.com/Opensourcefordatascience/Data-sets/refs/heads/master/admission.csv


# Library 
library(dplyr)
library(fairness)

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