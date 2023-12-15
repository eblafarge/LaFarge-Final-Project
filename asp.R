library(tidyverse)
library(janitor)
library(tidycensus)
library(lubridate)
library(stringr)

#read the entire dataset of NYC parking signs
parking_regulations <- read.csv("Parking_Regulation_Locations_and_Signs_20231122.csv") %>% 
  clean_names()

#selected and filtered down to only the ASP signs and locations
asp_regulations <- select(parking_regulations, 'borough', 'on_street', 'from_street', 'to_street', 'side_of_street', 'sign_code', 'sign_description', 'sign_x_coord', 'sign_y_coord') %>% 
  filter(str_detect(sign_description, 'SANITATION BROOM SYMBOL')) %>% 
  drop_na() %>% 
  arrange(sign_code)

write_csv(asp_regulations, file = "output/asp_regulations.csv")


