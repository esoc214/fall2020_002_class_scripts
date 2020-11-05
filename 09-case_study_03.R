# load libraries
library(tidyverse)

# read data in
url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-20/beer_awards.csv"
beer_awards <- read_csv(url)

# alternatively
beer_awards <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-20/beer_awards.csv")

# state codes have multiple casing
beer_awards %>%
  count(state)

# clean data: ensure state is standardized
beer_awards <- beer_awards %>%
  mutate(state = toupper(state))

# what questions can you ask about the data?
# what plots can you draw?
# Question: How many medals total per state?
beer_awards %>%
  count(state) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(state, -n), y = n)) +
  geom_col() +
  geom_label(aes(label = n)) +
  labs(x = "state",
       y = "award count",
       caption = "data from Great American Beer Festival (2020)") +
  ggtitle("Great American Beer Festival -- Award count by state",
          subtitle = "Top 10 states with the most awards") +
  theme_bw()

# reorder medal factors
beer_awards <- beer_awards %>%
  mutate(medal = factor(medal,
                        levels = c("Gold",
                                   "Silver",
                                   "Bronze")))

# Question: How many medals per category (gold, silver, bronze) per state?
# draw similar plot as above, but now we have a third variable (medal)
beer_awards %>%
  group_by(medal) %>%
  count(state, medal) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(state, -n),
             y = n,
             fill = medal)) +
  geom_col(position = "dodge") +
  geom_label(aes(label = n),
             position = position_dodge(width=1),
             show.legend = FALSE,
             color = "white") +
  labs(x = "state",
       y = "award count",
       caption = "data from Great American Beer Festival (2020)") +
  theme_bw() +
  scale_fill_manual(values = c("#e79e4f",
                               "#898b8a",
                               "#aa3a3a"))

############### NOVEMBER 05 #############################
# installing usmap library
#install.packages("usmap")
library(usmap)
statepop
statepov
state.x 

# create a data frame with medal count per state
medals_per_state <- beer_awards %>%
  count(state)

# use statepop to add population info to medals_per_state
statepop

# create a new data frame called us_pop with two columns
# abbr and pop_2015
us_pop <- statepop %>%
  select("state" = abbr, 
         "population" = pop_2015)

# add population by state to medals_per_state
medals_per_state <- left_join(medals_per_state,
                              us_pop, by = "state")

# change default to non-scientific notation
options(scipen = 999)

# starting medals_per_state
# plot n, state, and population
# first try: bar plot
medals_per_state %>% 
  top_n(20, wt = n) %>%
  ggplot(aes(x = reorder(state, -n), 
             y = n,
             fill = population)) +
  geom_col()

# second try: scatter plot
medals_per_state %>%
  ggplot(aes(x = population,
             y = n)) +
  geom_point() +
  geom_label(aes(label = state))

medals_per_state %>%
  filter(population < 10000000) %>%
  ggplot(aes(x = population,
             y = n)) +
  geom_point() +
  geom_label(aes(label = state))

# first establish direct rel. between pop. and n
medals_per_state %>%
  mutate(people_per_medal = population/n) %>%
  ggplot(aes(x = reorder(state, people_per_medal), 
             y = people_per_medal)) +
  geom_col()

# plot a map, with color representing n (i.e., number of medals)
plot_usmap(data = medals_per_state, 
           values = "n") +
  theme(legend.position = "right") +
  scale_fill_continuous(name = "Medal Count", 
                        low = "cornsilk", 
                        high = "darkgoldenrod4")

# plot a map
medals_per_state %>%
  mutate(medals_per_10kppl = (n/population) * 10000) %>%
  plot_usmap(data = .,
             values = "medals_per_10kppl") +
  theme(legend.position = "right") +
  scale_fill_continuous(name = "Medals per 10K Persons",
                        low = "#56B1F7", 
                        high = "#132B43") 
