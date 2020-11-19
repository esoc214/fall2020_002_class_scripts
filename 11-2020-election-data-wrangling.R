# load libraries
library(tidyverse)
library(rvest)
library(janitor)

# check working environment
getwd()
dir()
dir("data")

# read data in
election_data <- read_csv("data/president_county_candidate.csv")

# count number of states
election_data %>%
  count(state)

# Question #1: How many votes total (popular votes) for each candidate? ####
# 10 minutes -- check in at 1pm, share code in the chat, if you want to
election_data %>%
  group_by(candidate) %>%
  summarise(popular_votes = sum(total_votes)) %>%
  arrange(-popular_votes)

# recode candidate variable into three values:
# Joe Biden, Donald Trump, and Other
election_data <- election_data %>%
  mutate(candidate_2 = ifelse(candidate == "Joe Biden" |
                                candidate == "Donald Trump",
                              candidate, "Other"))
election_data %>%
  count(candidate_2, candidate)

# save data to disk
write_csv(election_data, "data/election_data_2020.csv")

# sum total votes again with group by candidate_2 variable
election_data %>%
  group_by(candidate_2) %>%
  summarise(popular_votes = sum(total_votes)) %>%
  arrange(-popular_votes)

# plot the first sum (all the candidates)
election_data %>%
  group_by(candidate) %>%
  summarise(popular_votes = sum(total_votes)) %>%
  filter(popular_votes > 10000) %>%
  ggplot(aes(y = reorder(candidate, popular_votes),
             x = popular_votes)) +
  geom_col() +
  geom_label(aes(label = popular_votes)) +
  labs(x = "Total Popular Votes",
       y = "",
       title = "Total Number of Votes Per Presidential Candidate",
       subtitle = "Displaying Candidates with 10k votes or more") +
  theme_minimal()

# plot the recoded candidate variable
election_data %>%
  group_by(candidate_2) %>%
  summarise(popular_votes = sum(total_votes)) %>%
  ggplot(aes(x = popular_votes,
             y = reorder(candidate_2, popular_votes))) +
  geom_segment(aes(xend = 0, yend = candidate_2)) +
  geom_label(aes(label = popular_votes)) +
  theme_minimal() +
  labs(y = "",
       x = "Total Popular Votes") +
  theme(panel.grid.major = element_blank(),
        axis.text.x = element_blank())

### Question #2: How many electoral votes for each candidate? ####
# First step: Calculate who won each state 
# make a new data frame (with group_by and summarise) with
# state and winning candidate
winner_by_state <- election_data %>%
  group_by(state, candidate) %>%
  summarize(popular_votes = sum(total_votes)) %>%
  group_by(state) %>%
  top_n(1)

# create a variable that holds our url
my_url <- "https://en.wikipedia.org/wiki/United_States_Electoral_College#:~:text=Electoral%20votes%2C%20out%20of%20538,entitled%20to%20at%20least%203."

# read in the html file
my_html <- read_html(my_url)

# parse html to get the table we need (class="sortable")
electoral_votes <- my_html %>%
  html_node(".sortable") %>%
  html_table(fill = TRUE) %>%
  clean_names()

electoral_votes <- electoral_votes[c(4:54), c(2,36)]

# change column names to "state" and "electoral_votes"
electoral_votes <- electoral_votes %>%
  rename(state = electionyear_2,
         electoral_votes = x2004_2)

# change one value in state from "D.C" to "District of Columbia"  
electoral_votes <- electoral_votes %>%
  mutate(state = ifelse(state == "D.C.",
                        "District of Columbia",
                        state))

# combine winner_by_state and electoral_votes  
winner_by_state <- left_join(winner_by_state,
                             electoral_votes)
glimpse(winner_by_state)

winner_by_state <- winner_by_state %>%
  mutate(electoral_votes = as.numeric(electoral_votes))

glimpse(winner_by_state)

# write the resulting data frame
write_csv(winner_by_state, "data/presidential_elections_per_state.csv")
