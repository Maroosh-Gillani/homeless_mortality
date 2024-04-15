#### Preamble ####
# Purpose: Models the cleaned data derived from OpenDataToronto's datasets using poisson regression
# Author: Maroosh Gillani
# Date: 15 April 2024
# Contact: maroosh.gillani@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure that 01-download_data.R and 02-data_cleaning.R have been run already.

#### Workspace setup ####
library(tidyverse)
library(here)
library(rstanarm)

#### Read data ####
cleaned_data = read.csv(file=here("data/clean_data/cleaned_data.csv"))

### Model data ####
poisson_model <- 
  glm(Deaths ~ Returned.to.shelter, data = cleaned_data, family = poisson)

#### Save model ####
saveRDS(
  poisson_model,
  file = "models/poisson_model.rds"
)


