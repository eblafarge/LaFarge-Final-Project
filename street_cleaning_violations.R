library(tidyverse)
library(janitor)
library(lubridate)
library(stringr)
library(dplyr)
library(ggplot2)

#read and clean dataset from NYC Open Data Parking and Camera Violations. 
#I filtered the dataset down to only street cleaning violations in the open data portal and exported only the data I needed
ASP_parking_violations <- read_csv("Open_Parking_and_Camera_Violations.csv") %>% 
  clean_names()

#checking the dataset for nonsensical dates
#referencing the original Open Data portal, these bad dates are from the original set
#result <- ASP_parking_violations %>%
  #filter(str_detect(issue_date, "2099"))

#concerned about potential duplicate rows, I filtered for only the first occurence of each summons number.
#there were no duplicates
#filtered <- ASP_parking_violations %>%
#distinct(summons_number, .keep_all = TRUE)

#convert date column to readable dates
ASP_parking_violations <- ASP_parking_violations %>% 
  mutate(issue_date = mdy(issue_date)) 

#add a column for year
ASP_parking_violations <- ASP_parking_violations %>%
  mutate(year = year(issue_date))

#arrange by year
arrange_ASP_parking_violations <- ASP_parking_violations %>% 
  arrange(year)

#counting the number of violations per year
#this will give counts for the nonsense years but that total count is low compared to the rest of the data so we will eliminate it
violations_per_year <- ASP_parking_violations %>%
  group_by(year, violation) %>%
  summarise(total_violations = n())

#selecting only years 2016-2023 for which I know the data is consistently reported
violations_per_year <- violations_per_year %>%
  filter(year >= 2016 & year <= 2023)

#graph violations by year
violations_line_graph <- ggplot(violations_per_year, aes(x = year, y = total_violations)) +
  geom_line(color = "red") +
  geom_point(color = "red")  +
  labs(title = "Street Cleaning Parking Violations from 2016-2023",
       y = "Violations",
       x="",
       caption = "Source: NYC Open Data Parking Violations")+
  scale_y_continuous(
    limits = c(0,2000000),
    labels = scales::unit_format(scale = 1/1000000, unit="Mil")) +
  scale_x_continuous(breaks = seq(2016, 2023, by = 1))+
  theme_minimal()

violations_line_graph




