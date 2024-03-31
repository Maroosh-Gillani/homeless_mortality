#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto's "Deaths of People Experiencing Homelessness" and "Toronto Shelter System Flow" datasets.
# Author: Maroosh Gillani
# Date: March 31st 2024
# Contact: maroosh.gillani@mail.utoronto.ca
# Pre-requisites: N/A
# Any other information needed? N/A


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####

# Download data from Deaths of People Experiencing Homelessness

package_1 <- show_package("a7ae08f3-c512-4a88-bb3c-ab40eca50c5e")

resources_1 <- list_package_resources("a7ae08f3-c512-4a88-bb3c-ab40eca50c5e")

datastore_resources_1 <- filter(resources_1, tolower(format) %in% c('csv', 'geojson'))

homeless_death_data <- filter(datastore_resources_1, row_number()==1) %>% get_resource()

# Download data from Toronto Shelter System Flow

package_2 <- show_package("ac77f532-f18b-427c-905c-4ae87ce69c93")

resources_2 <- list_package_resources("ac77f532-f18b-427c-905c-4ae87ce69c93")

datastore_resources_2 <- filter(resources_2, tolower(format) %in% c('csv', 'geojson'))

shelter_data <- filter(datastore_resources_2, row_number()==1) %>% get_resource()

#### Save data ####

write_csv(x=homeless_death_data, file="data/raw_data/raw_homeless_death_data.csv")
write_csv(shelter_data, "data/raw_data/raw_shelter_data.csv")
