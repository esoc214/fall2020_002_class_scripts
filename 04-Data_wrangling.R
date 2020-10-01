# check your working environment
getwd()
dir()
dir("data")

# install readxl
#install.packages("readxl")
library(readxl)
library(tidyverse)

# load excel file
nfl_salary <- read_excel("data/nfl_salary.xlsx")

# inspect data
summary(nfl_salary)
glimpse(nfl_salary)
View(nfl_salary)

# Summarise data
# get the nfl_salary dataframe and then
# group by year and then
# summarise the mean of Quarterback
nfl_salary %>%
  group_by(year) %>%
  summarise(qb_mean_salary = mean(Quarterback, na.rm = TRUE))

# in addition to quarterback, we want to add mean of cornerback salary
# get the nfl_salary dataframe and then
# group by year and then
# summarise the mean of Quarterback and the mean of Cornerback
nfl_salary %>%
  group_by(year) %>%
  summarise(qb_mean_salary = mean(Quarterback, na.rm = TRUE),
            cb_mean_salary = mean(Cornerback, na.rm = TRUE))


# our dataframe is not tidy
# we need to have three columns:
# year, position, salary
nfl_tidy <- nfl_salary %>%
  pivot_longer(cols = -year,
               names_to = "position",
               values_to = "salary")
# inspect data
glimpse(nfl_tidy)
View(nfl_tidy)

# let's count position
nfl_tidy %>%
  count(position, year)

# check how many missing data (for salary) we have
# per position and year
nfl_tidy %>%
  filter(is.na(salary)) %>%
  count(position, year)

# clean our data by deleting the NAs
nfl_clean <- nfl_tidy %>%
  filter(!is.na(salary))

# start with nfl_clean and then
# group by year and position
# summarise the mean of salary
nfl_clean %>%
  group_by(year, position) %>%
  summarise(mean_salary = mean(salary))

# flip group by
nfl_clean %>%
  group_by(position, year) %>%
  summarise(mean_salary = mean(salary))

# add arrange()
nfl_clean %>%
  group_by(year, position) %>%
  summarise(mean_salary = mean(salary)) %>%
  arrange(-mean_salary)

# summarise and visualize
nfl_clean %>%
  group_by(year, position) %>%
  summarise(mean_salary = mean(salary)) %>%
  ggplot(aes(x = year, y = mean_salary, color = position)) +
  geom_point() +
  geom_line(aes(group = position))

###################### REVIEW #### September 24 ##############################
# group_by()
# grouping specific columns of data
# when we want to organize by a certain variable
# usually accompanied by summarise()
nfl_clean %>%
  group_by(year)

# summarise()
# summarizes the data into a new data frame
# we use different functions inside summarise() like mean() and n()
nfl_clean %>%
  group_by(position) %>%
  summarise(mean(salary))

# filter()
# select specific rows in my data give some comparison
nfl_clean %>%
  filter(position == "Tight End") 

# count()
# tells you how much of each value in a column you have
nfl_clean %>%
  count(position)

# arrange()
# organizes data by a column in increasing order (alpha numerical)
nfl_clean %>%
  arrange(position)

# organize data by a column in decreasing order
# this only works with numeric variables
nfl_clean %>%
  arrange(-salary)

# pivot_longer()
# it moves the data so it's a longer spreadsheet rather than wide
# making the data concise
nfl_salary %>%
  pivot_longer(cols = Cornerback:`Wide Receiver`)

# summarise
nfl_clean %>%
  group_by(year, position) %>%
  summarise(mean_salary = mean(salary))

# add player count using n() inside summarise()
# add total salary which is the sum() of salary inside summarise
nfl_clean %>%
  group_by(year, position) %>% 
  summarise(player_count = n(),
            total_salary = sum(salary)) 

# add a new column to our summary data frame using mutate()
nfl_clean %>%
  group_by(year, position) %>%
  summarise(player_count = n(),
            total_sal_pos_year = sum(salary)) %>%
  mutate(total_per_year = sum(total_sal_pos_year)) 

# a new function inside mutate to calculate percentage of salary
# divide total_sal_pos_year by total_per_year
nfl_summary <- nfl_clean %>%
  group_by(year, position) %>%
  summarise(player_count = n(),
            total_sal_pos_year = sum(salary)) %>%
  mutate(total_per_year = sum(total_sal_pos_year),
         percent_salary = total_sal_pos_year / total_per_year)

View(nfl_summary)

# plotting our summary
# start with your data frame
# first thing you need is ggplot() 
# and inside ggplot() you need aes() which defines the elements in your plot
# elements: x axis, y axis, color
# the last thing here is geom_, we want two geoms: point and line
nfl_summary %>%
  ggplot(aes(x = year, 
             y = percent_salary, 
             color = position,
             shape = position)) +
  geom_point() +
  geom_line(aes(group = position)) +
  theme_minimal()




