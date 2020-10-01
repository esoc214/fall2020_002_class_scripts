# load libraries
library(tidyverse)

# check my working environment
getwd()
dir("data")

# read data in
spotify_data <- read_csv("data/spotify_songs.csv")

# inspect data
glimpse(spotify_data)
View(spotify_data)

########## HISTOGRAM #########################
#### PLOT ONE NUMERIC CONTINUOUS VARIABLE ####
# histogram of track_popularity
spotify_data %>%
  ggplot(aes(x = track_popularity)) +
  geom_histogram()

# histogram of release_year
spotify_data %>%
  ggplot(aes(x = release_year)) +
  geom_histogram()

# histogram of danceability
spotify_data %>%
  ggplot(aes(x = danceability)) +
  geom_histogram()

############ SCATTERPLOTS #################
#### PLOT TWO NUMERIC VARIABLE ############
# plot release_year by track_popularity
spotify_data %>%
  ggplot(aes(x = release_year, y = track_popularity)) +
  geom_point(alpha = .5)

# plot two numeric variable but add color for a third
# variable, usually a categorical variable
spotify_data %>%
  ggplot(aes(x = release_year,
             y = track_popularity,
             fill = playlist_genre)) +
  geom_bin2d(alpha = 0.5)





