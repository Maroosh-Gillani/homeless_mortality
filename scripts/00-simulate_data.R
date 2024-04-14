#### Preamble ####
# Purpose: Simulates number of homeless deaths and number of homeless people returning to shelters per year
# Author: Maroosh Gillani
# Date: 12 April 2024
# Contact: maroosh.gillani@mail.utoronto.ca
# Pre-requisites: N/A
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(7)

years <- 2018:2022

returns <- seq(1000, 1500, length.out = length(years)) + rnorm(length(years), mean = 0, sd = 100)
deaths <- returns * 0.02 + rnorm(length(years), mean = 0, sd = 20)

# store simulated data in a dataframe
yearly_data <- data.frame(Year = years,
                   `Number of Homeless Deaths` = round(deaths),
                   `Number of People Returning to Homeless Shelters` = round(returns))




