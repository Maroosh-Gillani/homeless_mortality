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


month_mapping <- c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12)

# Cleaned death data with year and month
cleaned_death_data <- raw_death_data %>%
  # Select only the "Year of death", "Month of death", and "Count" columns
  select(`Year of death`, `Month of death`, Count) %>%
  # Filter rows where the year is between 2018 and 2022
  filter(`Year of death` >= 2018 & `Year of death` <= 2022) %>%
  # Group by "Year of death" and "Month of death" and summarize the counts
  group_by(`Year of death`, `Month of death`) %>%
  # summarize(Count = sum(Count)) %>%
  # Convert month names to numeric values using custom mapping
  mutate(Month = month_mapping[`Month of death`])


# Cleaned shelter data with year and month
cleaned_shelter_data <- raw_shelter_data %>%
  # Select only the "date.mmm.yy.", "population_group", and "returned_to_shelter" columns
  select(date.mmm.yy., population_group, returned_to_shelter) %>%
  # Filter rows where the year is between 2018 and 2022
  filter(as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) >= 18 & as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) <= 22) %>%
  # Filter rows where the population_group is "All Population"
  filter(population_group == "All Population") %>%
  # Extract year and month from "date.mmm.yy." column
  mutate(Year = paste0("20", substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)),
         Month = match(substring(date.mmm.yy., 1, 3), month.abb)) %>%
  # Select only the "Year", "Month", and "returned_to_shelter" columns
  select(Year, Month, returned_to_shelter) %>%
  # Group by "Year" and "Month" and summarize the counts
  group_by(Year, Month) %>%
  summarize(returned_to_shelter = sum(returned_to_shelter))

# Merge cleaned_death_data and cleaned_shelter_data
cleaned_death_data <- cleaned_death_data %>%
  rename(Year = `Year of death`)

clean_data <- merge(cleaned_death_data, cleaned_shelter_data, by = c("Year", "Month"), all = TRUE) %>%
  select(Year, Month, returned_to_shelter, Count) %>%
  filter(!is.na(Month))

# Combine Month and Year columns into a single column
clean_data <- clean_data %>%
  mutate(Year_Month = paste(Month, "/", Year))

# Remove the separate Month and Year columns
clean_data <- clean_data %>%
  select(-Year, -Month)

#### Save data ####
write_csv(clean_data, "data/clean_data/cleaned_data.csv")
