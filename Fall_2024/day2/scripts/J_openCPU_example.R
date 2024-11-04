#' openCPU example
#' TK
#' Nov 4

# Load it
library(opencpu)

# In reality you would make your own functions loading your own model objects etc within a package, then opencpu serves the package functions

# Let's start the server and examine it
ocpu_start_server() #http://localhost:5656/ocpu

# GET ../library//stats/R/rnorm; shows the function inputs
# rnorm(n, mean = 0, sd = 1)

#POST
# creates response as an object ../library//stats/R/rnorm/
# creates response in json ../library//stats/R/rnorm/json
# creates response in csv  ../library//stats/R/rnorm/csv

# End