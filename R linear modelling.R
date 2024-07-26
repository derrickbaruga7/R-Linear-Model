###########################################
#
# Title: Linear Models 
# Script Name: 7.5
# Name: Derrick Baruga
# Date: 11/01/2023
# Script purpose: 
# 
###########################################

# Load necessary libraries
library(tidyverse)
library(tidymodels)

# Set directory
setwd('/Users/derrickmarkbavaudbaruga/Documents/spring 2023/csc 461 machine learning/topic 7')

# Read the data
housing_data <- read.csv("melbourne_housing.csv")

# Clean the data
# Examine for missing values
summary(housing_data)

# Drop rows with missing values
housing_data_clean <- drop_na(housing_data)

# Examine R-values
cor(housing_data_clean[ , sapply(housing_data_clean, is.numeric)])

# Scatter plot for Price vs Building Area
ggplot(housing_data_clean, aes(x = BuildingArea, y = Price)) +
  geom_point() +
  labs(title = "Price vs Building Area")

# Prepare the data
set.seed(123) # For reproducibility
data_split <- initial_split(housing_data_clean, prop = 0.75)
train_data <- training(data_split)
test_data <- testing(data_split)

# Functions for calculating fences for outliers
calculate_fences <- function(data, column) {
  Q1 <- quantile(data[[column]], 0.25)
  Q3 <- quantile(data[[column]], 0.75)
  IQR <- Q3 - Q1
  list(lower = Q1 - 1.5 * IQR, upper = Q3 + 1.5 * IQR)
}

# Apply fences and drop outliers
price_fences <- calculate_fences(train_data, "Price")
building_area_fences <- calculate_fences(train_data, "BuildingArea")

train_data <- train_data %>%
  filter(Price > price_fences$lower, Price < price_fences$upper) %>%
  filter(BuildingArea > building_area_fences$lower, BuildingArea < building_area_fences$upper)

# Scatter plot to identify additional outliers
ggplot(train_data, aes(x = BuildingArea, y = Price)) +
  geom_point() +
  labs(title = "Price vs Building Area with Outlier Fences")

# Drop rows with BuildingArea greater than 1000
train_data <- train_data %>%
  filter(BuildingArea <= 1000)

# Drop rows with BuildingArea greater than 1000 in testing data
test_data <- test_data %>%
  filter(BuildingArea <= 1000)

# Create a model
model <- lm(Price ~ BuildingArea, data = train_data)

# Predictions
test_data$Predicted_Price <- predict(model, test_data)

# Scatter plot for actual vs predicted values
ggplot(test_data, aes(x = BuildingArea, y = Price)) +
  geom_point(aes(color = "Actual")) +
  geom_point(aes(y = Predicted_Price, color = "Predicted")) +
  labs(title = "Actual vs Predicted Prices")

# Plot equations and formulas
ggplot(test_data, aes(x = BuildingArea, y = Price)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_function(fun = function(x) model$coefficients[1] + model$coefficients[2] * x, color = "red") +
  labs(title = "Regression Line and Smoothed Mean")

# Output model coefficients
model$coefficients

