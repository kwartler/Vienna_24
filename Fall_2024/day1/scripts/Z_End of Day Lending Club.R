#' Author: Ted Kwartler
#' Date: Oct 30 2024
#' Purpose: Lending Club, build a functional model(s) tuning and improving it the best you can.
#' Apply the model to the unknown new notes OpenNotesJune18_v2.csv to identify the best investment options
#'

#### Libraries

#### Working Directory

#### Data Load - your dependent variable is "y" which is a binary output; 1 is success 0 is a default
loans <- read.csv('https://github.com/kwartler/Vienna_24/raw/refs/heads/main/Fall_2024/day1/data/20K_sampleLoans.csv')
investmentOpportunities <- read.csv('https://raw.githubusercontent.com/kwartler/Vienna_24/refs/heads/main/Fall_2024/day1/data/OpenNotesJune18_v2.csv')

#### Sample - end of day 1
# First step is to identify the column names in investmentOpportunities and use those to select the same columns in loans.  Second step is to append the loans$y so you have 28 columns in loans.

#### Explore - end of day 1

#### Modify - end of day 1

#### Model(s)

#### Assess

#### Apply



# End