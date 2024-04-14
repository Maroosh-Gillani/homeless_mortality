#### Preamble ####
# Purpose: Cleans the raw homeless death and Toronto shelter data originally from OpenDataToronto
# Author: Maroosh Gillani
# Date: 13 April 2024
# Contact: maroosh.gillani@mail.utoronto.ca
# Pre-requisites: make sure you have successfully ran 01-download_data.R
# Any other information needed? N/A

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####
raw_death_data <- read_csv("data/raw_data/raw_homeless_death_data.csv")
raw_shelter_data <- read.csv("data/raw_data/raw_shelter_data.csv")

# Clean raw_death_data
cleaned_death_data <- raw_death_data %>%
  # Select only the "Year of death" and "Count" columns
  select(`Year of death`, Count) %>%
  # Filter rows where the year is between 2018 and 2022
  filter(`Year of death` >= 2018 & `Year of death` <= 2022) %>%
  # Group by "Year of death" and summarize the counts
  group_by(`Year of death`) %>%
  summarize(Count = sum(Count))

# Clean raw_shelter_data
cleaned_shelter_data <- raw_shelter_data %>%
  # Select only the relevant columns
  select(date.mmm.yy., population_group, returned_to_shelter) %>%
  # Filter rows where the year is between 18 and 22
  filter(as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) >= 18 & as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) <= 22) %>%
  # Filter rows where the population_group is "All Population"
  filter(population_group == "All Population") %>%
  # Group by year and summarize the counts of "returned_to_shelter"
  group_by(year = as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1))) %>%
  summarize(returned_to_shelter = sum(returned_to_shelter))
# Fix year format
cleaned_shelter_data <- cleaned_shelter_data %>%
  mutate(year = paste0("20", year))



# Merge cleaned_death_data and cleaned_shelter_data
clean_data <- merge(cleaned_death_data, cleaned_shelter_data, by.x = "Year of death", by.y = "year", all = TRUE)

# Renaming columns
names(clean_data)[names(clean_data) == "Year of death"] <- "Year"
names(clean_data)[names(clean_data) == "Count"] <- "Number of Deaths"
names(clean_data)[names(clean_data) == "returned_to_shelter"] <- "Returned to Shelter"


#### Save data ####
write_csv(clean_data, "data/clean_data/cleaned_data.csv")
