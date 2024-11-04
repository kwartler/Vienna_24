#' Compare ggplot to echarts4r
#' TK
#' Nov 4

# libraries
library(ggplot2)
library(ggthemes)
library(echarts4r)

# Load some example data
diabetesData <- read.csv('https://raw.githubusercontent.com/kwartler/Vienna_24/refs/heads/main/Fall_2024/day2/data/100_diabetes_no_null_text.csv')

# Build a nice ggplot
ggplot(diabetesData, aes(x = num_lab_procedures, y = time_in_hospital)) + 
  geom_point(color = 'darkred') +
  theme_gdocs() + ggtitle('Lab Procedures to Time in Hospital')

# Now the same with echarts;
# Author suggests to use the "pipe" forward operator
diabetesData |> 
  e_charts(num_lab_procedures) |>
  e_scatter(time_in_hospital, symbol_size = 5, legend = F) |>
  e_toolbox_feature()|>
  e_zoom() |>
  e_theme('bee-inspired') |> #more than 12 & you can make custom 
  e_tooltip()



# End