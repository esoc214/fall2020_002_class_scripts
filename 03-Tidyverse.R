# Data Types
integer_variable <- 1L
class(integer_variable)

numeric_variable <- 2
class(numeric_variable)

character_variable <- "2"
class(character_variable)

transformed_char_var <- as.numeric(character_variable)
class(transformed_char_var)

# install tidyverse
#install.packages("tidyverse")

# load libraries
library(tidyverse)
#library(dplyr)

# check your working directory
getwd()

# list contents of a folder
dir()
dir("data")

# load data
groundhog_predictions <- read_csv("data/groundhog_day.csv")
View(groundhog_predictions)

# inspect data
summary(groundhog_predictions)
glimpse(groundhog_predictions)

# get variable names
colnames(groundhog_predictions)

# check values in a column/variable
unique(groundhog_predictions$`Punxsutawney Phil`)

### The Pipe ####
# %>% means "and then"
# ctrl+shift and press "m"
groundhog_predictions %>% 
  summary()

# select a column in your data frame
# equivalent to 
# groundhog_predictions$`Punxsutawney Phil`
groundhog_predictions %>% 
  select(`Punxsutawney Phil`) %>% 
  unique()

# count how many of each category
groundhog_predictions %>%
  count(`Punxsutawney Phil`)

######## SEPTEMBER 17 ##################
# counting categorical variable
# use count() 
groundhog_predictions %>%
  count(`Punxsutawney Phil`)
  
# use group_by() and count()
groundhog_predictions %>%
  group_by(`Punxsutawney Phil`) %>%
  count()

# use group_by() summarise()
groundhog_predictions %>%
  group_by(`Punxsutawney Phil`) %>%
  summarise(total = n())

# add to summarise() a mean() function to calculate mean of
# `February Average Temperature` and `March Average Temperature`
groundhog_predictions %>% 
  group_by(`Punxsutawney Phil`) %>%
  summarise(total = n(),
            feb_temp = mean(`February Average Temperature`, na.rm = TRUE),
            mar_temp = mean(`March Average Temperature`, na.rm = TRUE))

# filter data
groundhog_predictions %>%
  filter(`Punxsutawney Phil` == "Full Shadow" |
           `Punxsutawney Phil` == "No Shadow") %>%
  group_by(`Punxsutawney Phil`) %>%
  summarise(total = n(),
            feb_temp = mean(`February Average Temperature`, na.rm = TRUE),
            mar_temp = mean(`March Average Temperature`, na.rm = TRUE))

# select data
selected_predictions <- groundhog_predictions %>%
  select("shadow" = `Punxsutawney Phil`, 
         "feb_temp" = `February Average Temperature`,
         "mar_temp" = `March Average Temperature`)
View(selected_predictions)

# pivot data frame
predictions_longer <- selected_predictions %>%
  pivot_longer(cols = c(feb_temp, mar_temp),
               names_to = "month_temp",
               values_to = "temperature")

View(predictions_longer)

# demonstration of a chart
predictions_longer %>%
  ggplot(aes(x = month_temp, y = temperature)) +
  geom_jitter(aes(color = shadow))

#########################




