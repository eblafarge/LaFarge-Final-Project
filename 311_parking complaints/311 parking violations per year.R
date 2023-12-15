library(tidyverse)
library(janitor)
library(lubridate)
library(stringr)
library(dplyr)
library(ggplot2)

#flitering for only violations related to ASP
parking_complaints <- read_csv("311_parking_complaints.csv") %>% 
  filter(descriptor %in% c("Posted Parking Sign Violation", "Double Parked Blocking Traffic"))

#converting dates into readable form and arrange data by year
parking_complaints <- parking_complaints %>%
  mutate(Date = mdy_hms(created_date)) %>%
  arrange(Date)

# Creating a Year column
parking_complaints <- parking_complaints %>%
  mutate(Year = year(Date))

# Counting the number of violations per year
complaints_per_year <- parking_complaints %>%
  group_by(Year) %>%
  summarise(Count = n())

write_csv(complaints_per_year, file = "output/complaints_per_year.csv")

# Creating the line chart
ggplot(complaints_per_year, aes(x = Year, y = Count, group = 1)) +
  geom_line() +
  geom_point() +
  labs(title = "Number of Complaints per Year",
       x = "Year",
       y = "Number of Complaints") +
  theme_minimal()
