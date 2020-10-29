# install.packages("tabulizer")
# load libraries
library(janitor)
library(tidyverse)


# get data from tables in pdf files
library(tabulizer)

# get pdf file
ua_common_dataset <- extract_tables("https://uair.arizona.edu/sites/default/files/2019-2020%20CDS_FINAL_060820.pdf")

# get table #9
ua_common_dataset[[9]]


################## OCTOBER 29, 2020 ################################
# install.packages("rvest")
library(rvest)

# read the html page
url <- "https://en.wikipedia.org/wiki/University_of_Arizona"
uarizona_wiki_html <- read_html(url)

# parse the html page for tables
uarizona_wiki_html %>%
  html_nodes("table")

# "table" nodes retrieves too many tables, let's use the table class instead
wiki_tables <- uarizona_wiki_html %>%
  html_nodes(".wikitable")

# check each table in the list
wiki_tables[[1]] %>%
  html_table(fill = TRUE)

wiki_tables[[2]] %>%
  html_table(fill = TRUE)

wiki_tables[[3]] %>%
  html_table(fill = TRUE)

# table #3 is the one we want
fall_freshman_stats <- wiki_tables[[3]] %>%
  html_table(fill = TRUE)

# fix column names
fall_freshman_stats %>%
  clean_names()

# use colnames() to manually rename first column
colnames(fall_freshman_stats)[1] <- "type"

# pivot longer, pivot all year columns ("2017":"2013")
# start with the original data frame fall_freshman_stats
# pivot_longer the cols "2017":"2013" with names mapped to year
fall_fresh_longer <- fall_freshman_stats %>%
  pivot_longer(cols = "2017":"2013",
               names_to = "year")

# inspect our data
glimpse(fall_fresh_longer)

###### plot number of (Applicants, Admits, Enrolled) across year
# start with fall_fresh_longer and then
# filter data to keep type %in%  ("Applicants", "Admits", "Enrolled")
# map x to year, y to value, and color to type
# add geom_point
fall_fresh_longer %>%
  filter(type %in% c("Applicants", "Admits", "Enrolled")) %>%
  ggplot(aes(x = year,
             y = value,
             color = type)) +
  geom_point() +
  geom_line(aes(group = type))

# convert value from character to numeric
# using parse_number()
fall_fresh_longer <- fall_fresh_longer %>%
  mutate(value = parse_number(value))

# inspect data
glimpse(fall_fresh_longer)

# try plotting it again
fall_fresh_longer %>%
  filter(type %in% c("Applicants", "Admits", "Enrolled")) %>%
  ggplot(aes(x = year,
             y = value,
             color = fct_reorder(type, value, .desc = TRUE))) +
  geom_point() +
  geom_line(aes(group = type)) +
  ggtitle("UArizona Fall Freshman Counts") +
  theme_bw() +
  labs(y = "student count",
       color = "",
       caption = "Data from https://uair.arizona.edu/sites/default/files/2019-2020%20CDS_FINAL_060820.pdf")

ggsave("freshman_count.png")

