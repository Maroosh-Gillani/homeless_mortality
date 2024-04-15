#### Preamble ####
# Purpose: Tests cleaned data from OpenDataToronto's homeless deaths and homeless shelter datasets
# Author: Maroosh Gillani
# Date: 15 April 2024
# Contact: maroosh.gillani@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure that 01-download_data.R and 02-data_cleaning.R have been run already.


#### Workspace setup ####
library(tidyverse)
library(here)
library(haven)

# read data
cleaned_data = read.csv(file=here("data/clean_data/cleaned_data.csv"))

#### Test data ####

# Returned to shelter and Deaths are numeric and non-negative
all(cleaned_data$Returned.to.shelter >= 0) & all(cleaned_data$Deaths >= 0)

# total of 60 rows (12 months x 5 years)
nrow(cleaned_data) == 60

# months are in between 1 and 12
all(sapply(strsplit(cleaned_data$Month.Year, "/"), 
           function(x) as.integer(x[1]) >= 1 & as.integer(x[1]) <= 12))

# no missing values
!any(is.na(cleaned_data$Returned.to.shelter)) & !any(is.na(cleaned_data$Deaths)) &
  !any(is.na(cleaned_data$Month.Year))

# all unique rows
nrow(unique(cleaned_data)) == nrow(cleaned_data)
