library(tidyverse)
library(janitor)
library(tidycensus)
library(lubridate)
library(stringr)
library(ggplot2)

#reading in dataset and pivoting it longer
scores_by_year <- read.csv("borough scores by year.csv") %>% 
  pivot_longer(
    cols = c(Manhattan, Bronx, Queens, Brooklyn, Staten.Island),
    names_to = "borough",
    values_to = "score"
  ) 

#create line chart of change in cleanliness over time by borough
ggplot(scores_by_year, aes(x = Year, y = score, group = borough, color = borough)) +
  geom_line() +
  geom_point() +
  labs(title = "Percentage of Acceptably Clean Streets by Borough",
       x = "",
       y = "Percentage Clean",
       color = "Borough",
  caption= "Source: NYC Community Board Cleanliness Scorecard")+
  scale_x_continuous(breaks = seq(2016, 2023, by = 1)) +
  theme_minimal()
