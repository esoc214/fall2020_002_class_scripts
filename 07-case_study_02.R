# load libraries
library(lubridate)
library(janitor)
library(tidyverse)

# read data in
global_temperatures <- read_csv("https://raw.githubusercontent.com/esoc214/fall2020_002_class_scripts/main/data/GlobalLandTemperaturesByCountry.csv")

# inspect data
View(global_temperatures)

# clean up column names
global_temperatures <- global_temperatures %>%
  clean_names()

# manipulating dates
class(global_temperatures$dt)
year(global_temperatures$dt)
month(global_temperatures$dt)
month(global_temperatures$dt, label = TRUE, abbr = FALSE)
week(global_temperatures$dt)

# add year, month, and week as columns to our data frame
global_temperatures <- global_temperatures %>%
  mutate(year = year(dt),
         month = month(dt),
         week = week(dt))

# extra data libraries
library(countrycode)

# add continent to data frame, based on country
global_temperatures <- global_temperatures %>%
  mutate(continent = countrycode(sourcevar = country,
                                 origin = "country.name",
                                 destination = "continent"))

# why some continent were not assigned
global_temperatures %>%
  filter(is.na(continent)) %>%
  distinct(country)

# create new data frame with clean global_temperatures
global_temp_cont <- global_temperatures %>%
  filter(!is.na(continent))

# inspect data
View(global_temp_cont)

# with the new data frame (global_temp_cont) 
# group by year and continent
# summarise mean of average_temperature
# draw a line plot with x mapped to year, y mapped to mean of 
# average_temperature and color mapped to continent
global_temp_cont %>%
  group_by(year, continent) %>%
  summarise(mean_temp = mean(average_temperature,
                             na.rm = TRUE)) %>%
  ggplot(aes(x = year,
             y = mean_temp,
             color = continent)) +
  geom_point() +
  geom_line()

# start with global_temp_cont
# filter to keep only Europe as continent
# summarise mean average_temperature by month
# plot mean temperature across months

global_temp_cont %>%
  filter(continent == "Europe") %>%
  group_by(country, month) %>%
  summarise(avg_temp = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = month,
             y = avg_temp,
             color = country)) +
  geom_point() +
  geom_line()



