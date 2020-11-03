# load libraries
library(tidyverse)

# read data in
url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-20/beer_awards.csv"
beer_awards <- read_csv(url)

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


# installing usmap library
#install.packages("usmap")
library(usmap)
statepop



