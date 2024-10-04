#' Author: Ted Kwartler
#' Date: 6-30-2024
#' Purpose: EDA on Aug 12 ice cream machines
#' 
#' lon - longitude
#' lat - latitude
#' is_broken - is the machine actively capable of dispensing ice cream
#' city, state, street - geo data
#' last_checked - exact timestamp of the ping
#' date - overall data represented

# libs
library(radiant.data) # beginners only
library(DataExplorer) # beginners only
library(leaflet)
library(leaflet.extras)
library(maps)

# No sci notation!
options(scipen = 999)


# Read in Data
iceCream <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/mcBroken_august_12_2022.csv')

# Look at the bottom 6 rows
tail(iceCream, 6)

# Are there any NA or missings in the data?
chk <- apply(iceCream, 2, is.na)
apply(chk, 2, sum)
plot_missing(iceCream)

# how many rows are there?  These are machine sensors indications so there are usually a lot
nrow(iceCream)

# Subset the date to just 8-12
iceCream <- subset(iceCream, iceCream$date=='2022-08-12')

# how many rows are there now?  Was there noise in the data query?
nrow(iceCream)
# Yes although it was supposed to be just a single date, other dates were in the data

# get a table() of the unique states.  How many machines are found in each location? 
table(iceCream$state)

# Overall how many unique() broken machines are there?
table(iceCream$is_broken)
proportions(table(iceCream$is_broken))

# what state has the highest _percentage_ of broken machines? This is a tough one, requiring you to know the total machines in a state, the total broken and to get the proportion.
# hint, you can do this stepwise or you can employ the function prop.table()
tmp <- prop.table(table(iceCream$state,iceCream$is_broken))
idx <- which.max(tmp[,2])
rownames(tmp)[idx]


# create a map of the machines on this date (hint, use leaflet library with "markerClusterOptions()")
leaflet(data=iceCream) %>%
  addTiles() %>% 
  addMarkers( popup = paste("Broken:", iceCream$is_broken, "<br>",
                            "Street:", iceCream$street),
              clusterOptions = markerClusterOptions()) %>%
  addResetMapButton()


# are there any unusual data points that should be removed?  Subset the data to just US machines or a state of interest like MA and only broken machines
onlyMA <- subset(iceCream, iceCream$state=='MA'&
                   iceCream$is_broken==T)

# Subset to just the broken machines for this suubsection from above, then use the maps library to make another map plot with the smaller data, not of all machines but just broken.
map('state', region = c('mass'))
points(onlyMA$lon,onlyMA$lat, col='red')

# End
