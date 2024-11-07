#' Author: Ted Kwartler
#' Date: Oct 30 2024
#' Purpose: Lending Club, build a functional model(s) tuning and improving it the best you can.
#' Apply the model to the unknown new notes OpenNotesJune18_v2.csv to identify the best investment options
#'

#### Libraries

#### Working Directory

#### Custom Functions
removePercentSign <- function(df, colNamesToFix){
  # select the columns to fix
  x <- df[,colNamesToFix]
  
  # remove the % sign, and make numeric
  for(i in 1:ncol(x)){
    fixedCol <- as.numeric(gsub("%","",x[,i]))/100
    x[,i]    <- fixedCol
  }
  
  finalDF <- df %>% select(-colNamesToFix)
  finalDF <- cbind(finalDF, x)
}

#### Data Load - your dependent variable is "y" which is a binary output; 1 is success 0 is a default
loans <- read.csv('https://github.com/kwartler/Vienna_24/raw/refs/heads/main/Fall_2024/day1/data/20K_sampleLoans.csv')
investmentOpportunities <- read.csv('https://raw.githubusercontent.com/kwartler/Vienna_24/refs/heads/main/Fall_2024/day1/data/OpenNotesJune18_v2.csv')

#### Sample - end of day 1
# First step is to identify the column names in investmentOpportunities and use those to select the same columns in loans.  Second step is to append the loans$y so you have 28 columns in loans.

#### Explore - end of day 1

#### Modify - end of day 1

#### Model(s) - end of day 2

#### Assess - end of day 2

#### Apply - end of day 2



# End