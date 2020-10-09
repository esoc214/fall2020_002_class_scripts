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
             color = playlist_genre)) +
  geom_point(alpha = 0.5)

########### October 01, 2020 ################
# plot a scatterplot of track_populariy by release_year
# add third variable to mapping in the plot, which is genre
spotify_data %>%
  ggplot(aes(x = release_year,
             y = track_popularity,
             color = playlist_genre)) +
  geom_point(alpha = 0.3) +
  facet_wrap(~playlist_genre)

#### Summarize Data First ######
spotify_summarised <- spotify_data %>%
  group_by(release_year, playlist_genre, playlist_subgenre) %>%
  summarise(mean_popularity = mean(track_popularity)) 

# plot the summarized data, scatterplot of mean_popularity by
# release year
spotify_summarised %>%
  ggplot(aes(x = release_year, y = mean_popularity)) +
  geom_point()

# plot the summarized data, scatterplot of mean_popularity (y)
# by release year (x) across subgenre (color)
spotify_summarised %>%
  ggplot(aes(x = release_year, 
             y = mean_popularity, 
             color = playlist_subgenre)) +
  geom_point()

# plot the summarized data, bar plot of mean_popularity (y)
# by release year (x) across subgenre (fill)
spotify_summarised %>%
  ggplot(aes(x = release_year,
             y = mean_popularity,
             fill = playlist_subgenre)) +
  geom_col(position = "dodge")

# same plot as before, but faceted
spotify_summarised %>%
  ggplot(aes(x = release_year,
             y = mean_popularity,
             fill = playlist_subgenre)) +
  geom_col(position = "dodge") +
  facet_wrap(~playlist_subgenre)

# new summarized data frame
# Summarize mean track_popularity by playlist_genre
spotify_data %>%
  group_by(playlist_genre) %>%
  summarise(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = fct_reorder(playlist_genre, -mean_popularity), 
             y = mean_popularity)) +
  geom_col() +
  xlab("Genre") +
  ylab("Mean Popularity") +
  ggtitle("Mean Popularity of Tracks across Genre") +
  theme_minimal()

  
# bar plot, stacked bars are subgenre, x is mapped to genre, and
# y is mapped to mean_popularity
spotify_data %>%
  group_by(playlist_genre, playlist_subgenre) %>%
  summarise(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = playlist_genre,
             y = mean_popularity,
             fill = playlist_subgenre)) +
  geom_col()

# change to point and shape
spotify_data %>%
  group_by(playlist_genre, playlist_subgenre) %>%
  summarise(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = playlist_genre,
             y = mean_popularity,
             shape = playlist_subgenre)) +
  geom_point()

spotify_data %>% 
  group_by(playlist_genre, playlist_subgenre) %>%
  summarize(mean_popularity = mean(track_popularity)) %>% 
  ggplot(aes(x = fct_reorder(playlist_genre, mean_popularity),
             y = mean_popularity,
             fill = playlist_subgenre)) +
  geom_col() 

spotify_data %>% 
  group_by(playlist_genre, playlist_subgenre) %>%
  summarize(mean_popularity = mean(track_popularity)) %>% 
  arrange(-mean_popularity)

############### OCTOBER 06 ###################
# what artists are represented in the data set
spotify_data %>%
  select(track_artist) %>%
  unique() %>%
  View()

# count number of songs per artist, and arrange results
# showing artist with most songs first
spotify_data %>%
  count(track_artist) %>%
  arrange(-n) 

# filter data to only keep the following artists:
# The Cranberries, The Beatles, and Queen
artist_to_keep <- c("The Cranberries",
                    "The Beatles",
                    "Queen",
                    "Drake")

# create a new data frame with selected artists  
filtered_data <- spotify_data %>%
  filter(track_artist %in% artist_to_keep)

# inspect data frame to check whether it is 
# what you wanted it to be
filtered_data %>%
  count(track_artist)

# what genres these artists represent
filtered_data %>%
  count(track_artist, playlist_genre)

spotify_data %>%
  filter(track_artist %in% artist_to_keep) %>%
  count(track_artist, playlist_genre)

# what are the two pop songs by Queen
filtered_data %>%
  filter(track_artist == "Queen" & 
           playlist_genre == "pop") %>%
  select(track_name)


# summarize mean track_popularity by track_artist and decade
filtered_data %>%
  group_by(track_artist, decade) %>%
  summarise(mean_pop = mean(track_popularity))

# plot your summarized results 
# decade (x) by mean popularity (y) across track_artist (color)
# try geom_point() + geom_line()
# geom_line needs another aesthetics, group
filtered_data %>%
  group_by(track_artist, decade) %>%
  summarise(mean_pop = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_pop,
             color = track_artist)) +
  geom_point() +
  geom_line()

# use geom_col() you might need to change position to "dodge"
filtered_data %>%
  group_by(track_artist, decade) %>%
  summarise(mean_pop = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_pop,
             fill = track_artist)) +
  geom_col(position = "dodge")

############ OCTOBER 08 #####################
# 1. Filter data (DONE), resulting df is filtered_data
# 2. group_by() and summarize()
# 3. plot
filtered_data %>%
  group_by(track_artist, decade) %>%
  summarise(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_popularity,
             fill = track_artist)) +
  geom_col() +
  facet_wrap(~track_artist)

# 1. filtered_data
# 2. group_by and summarise()
# summarise() should hold both mean() and sd()
filtered_data %>%
  group_by(track_artist, decade) %>%
  summarise(total = n(),
            mean_popularity = mean(track_popularity),
            sd_popularity = sd(track_popularity)) %>%
  mutate(lower = mean_popularity - sd_popularity,
         upper = mean_popularity + sd_popularity) %>%
  ggplot(aes(x = decade,
             y = mean_popularity,
             fill = track_artist)) +
  geom_col() +
  facet_wrap(~track_artist) +
  geom_errorbar(aes(ymin = lower, ymax = upper))

# from the plot above, remove decade from it
# map track_artist to the x axis
filtered_data %>%
  group_by(track_artist) %>%
  summarise(mean_popularity = mean(track_popularity),
            sd_popularity = sd(track_popularity)) %>%
  mutate(lower = mean_popularity - sd_popularity,
         upper = mean_popularity + sd_popularity) %>%
  ggplot(aes(x = track_artist,
             y = mean_popularity,
             fill = track_artist)) +
  geom_col() +
  geom_errorbar(aes(ymin = lower, ymax = upper))  +
  xlab("") +
  ylab("mean popularity") +
  theme_bw() +
  theme(legend.position = "none") +
  ggtitle("Average Popularity of Songs across Artists")

# start with the original data (spotify_data)
# filter for track_artist "Drake"
# group_by track_album_name
# summarise mean popularity
spotify_data %>%
  filter(track_artist == "Drake") %>%
  group_by(track_album_name) %>%
  summarise(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(y = reorder(track_album_name, mean_popularity),
             x = mean_popularity)) +
  geom_col()




