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
  count(NOC, Team, Medal) %>%
  arrange(-n)

############ October 15 ####################
# Combine (join, merge) olympic_events with noc_regions by the NOC column
olympic_combined <- left_join(olympic_events, noc_regions)

# start with olympic_combined and then
# filter to keep Summer season only
# filter to keep Medals that are not NA only
# count medals and region
# arrange results to see first the region with the most medals
olympic_combined %>%
  filter(Season == "Summer") %>%
  filter(!is.na(Medal)) %>%
  count(region, Medal) %>%
  arrange(-n)

# look at winter
olympic_combined %>%
  filter(Season == "Winter") %>%
  filter(!is.na(Medal)) %>%
  count(region, Medal) %>%
  arrange(-n)

# look at both seasons at the same time
olympic_combined %>%
  filter(!is.na(Medal)) %>%
  count(Season, region, Medal) %>%
  View()

# filter to keep only Summer olympics
# count total number of Medals with no subcount per medal category
# total count of Medals (that are not NA) per region
top_5_regions <- olympic_combined %>%
  filter(Season == "Summer") %>%
  filter(!is.na(Medal)) %>%
  count(region) %>%
  top_n(6)

top_5_regions$region

# filter our data (olympic_combined) to keep only
# rows from the top_5_regions
olympic_filtered <- olympic_combined %>%
  filter(region %in% top_5_regions$region)

# check to see if all 6 regions are still in olympic_filtered
olympic_filtered %>%
  count(region)

# plot height across Year across the different regions 
# in olympic_filtered
# scatterplot
olympic_filtered %>%
  filter(Season == "Summer") %>%
  ggplot(aes(x = Year,
             y = Height,
             color = region)) +
  geom_point() +
  facet_wrap(~region)

# bar plot
olympic_filtered %>%
  filter(Season == "Summer") %>%
  ggplot(aes(x = region,
             y = Height,
             fill = region)) +
  geom_col(position = "dodge")


# error with missing column/variable
olympic_filtered %>% 
  filter(Season == "Summer") %>% 
  group_by(Year, region) %>%
  summarise(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_height,
             color = region)) +
  geom_point() +
  facet_wrap(~region)

olympic_filtered <- olympic_filtered %>%
  mutate(region = factor(region,
                         levels = c("USA",
                                    "Russia",
                                    "Germany",
                                    "UK",
                                    "France",
                                    "Italy")))

# summarize + point and line
# add region to this plot
olympic_filtered %>%
  filter(Season == "Summer") %>%
  group_by(Year, region) %>%
  summarize(mean_weight = mean(Weight, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_weight,
             color = region)) +
  geom_point() +
  geom_line() +
  facet_wrap(~region)

# look at Sport
olympic_filtered %>%
  count(Sport) %>%
  arrange(-n)

# look at number of medals per sex
# start with olympic_filtered and then
# count non-NA medals per sex
# plot number of medals per sex per region
olympic_filtered %>%
  filter(Season == "Summer") %>%
  filter(!is.na(Medal)) %>%
  count(Sex, region) %>%
  ggplot(aes(x = Sex, y = n, color = region)) +
  geom_point()


