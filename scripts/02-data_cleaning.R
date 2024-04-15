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
  select(`Year of death`, `Month of death`, Count) %>%
  filter(`Year of death` >= 2018 & `Year of death` <= 2022) %>%
  group_by(`Year of death`, `Month of death`) %>%
  mutate(Month = month_mapping[`Month of death`])

# Cleaned shelter data
cleaned_shelter_data <- raw_shelter_data %>%
  select(date.mmm.yy., population_group, returned_to_shelter) %>%
  filter(as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) >= 18 & as.integer(substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)) <= 22) %>%
  filter(population_group == "All Population") %>%
  mutate(Year = paste0("20", substring(date.mmm.yy., nchar(date.mmm.yy.) - 1)),
         Month = match(substring(date.mmm.yy., 1, 3), month.abb)) %>%
  select(Year, Month, returned_to_shelter) %>%
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

# Rename columns
clean_data <- clean_data %>%
  rename(`Returned to shelter` = returned_to_shelter,
         `Month/Year` = Year_Month, `Deaths` = Count)

#### Save data ####
write_csv(clean_data, "data/clean_data/cleaned_data.csv")
