# load library
library(tidyverse)

# check working environment
getwd()
dir("data")

# read in data files
olympic_events <- read_csv("data/olympic_history_athlete_events.csv")
noc_regions <- read_csv("data/olympic_history_noc_regions.csv")

# inspect data
glimpse(olympic_events)
View(olympic_events)
View(noc_regions)

# Has athlete height and weight changed over time overall?
# Has height and weight changed over time for the top 
# 5 countries with the most medals?

# how many athletes are there per year
olympic_events %>%
  count(Year) %>%
  View()

# what's the relationship between Height and Weight
olympic_events %>%
  ggplot(aes(x = Height,
             y = Weight)) +
  geom_point(alpha = .3)

# filter to keep only Summer Olympics
# group by Year and summarise the mean of Height
# mapped x to Year and x to mean of height
# plotted points and line
olympic_events %>%
  filter(Season == "Summer") %>%
  group_by(Year) %>%
  summarise(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year, y = mean_height)) +
  geom_point() +
  geom_line()

# do the same as above, but with weight instead of height
olympic_events %>%
  filter(Season == "Summer") %>%
  group_by(Year) %>%
  summarise(mean_weight = mean(Weight, na.rm = TRUE)) %>%
  ggplot(aes(x = Year, y = mean_weight)) +
  geom_point() +
  geom_line()

# count medals
# what are the top 5 countries with the most medal count?
olympic_events %>%
  filter(Season == "Summer") %>%
  filter(!is.na(Medal)) %>%
  count(NOC, Medal) %>%
  arrange(-n)


