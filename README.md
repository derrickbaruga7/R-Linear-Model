# R-Linear-Model
This R project focuses on predicting housing prices based on various features such as building area, number of rooms, and more. The dataset used is cleaned and analyzed to build a predictive model using linear regression.

Requirements

R version 4.3.1 or later
R packages:
tidyverse 2.0.0
tidymodels 1.1.1
Installation

Install the required R packages using the following commands:

install.packages("tidyverse")
install.packages("tidymodels")

Usage

1. Load the necessary libraries:

library(tidyverse)
library(tidymodels)

2. Clean the data by removing rows with missing values:

housing_data_clean <- drop_na(housing_data)

3. Examine the correlation between numeric features:

cor(housing_data_clean[, sapply(housing_data_clean, is.numeric)])

4. Create scatter plots for initial visualization:

ggplot(housing_data_clean, aes(x = BuildingArea, y = Price)) +
  geom_point() +
  labs(title = "Price vs Building Area")

5. Split the data into training and testing sets:

set.seed(123)
data_split <- initial_split(housing_data_clean, prop = 0.75)
train_data <- training(data_split)
test_data <- testing(data_split)

6. Identify and remove outliers based on calculated fences:

calculate_fences <- function(data, column) {
  Q1 <- quantile(data[[column]], 0.25)
  Q3 <- quantile(data[[column]], 0.75)
  IQR <- Q3 - Q1
  list(lower = Q1 - 1.5 * IQR, upper = Q3 + 1.5 * IQR)
}

price_fences <- calculate_fences(train_data, "Price")
building_area_fences <- calculate_fences(train_data, "BuildingArea")

train_data <- train_data %>%
  filter(Price > price_fences$lower, Price < price_fences$upper) %>%
  filter(BuildingArea > building_area_fences$lower, BuildingArea < building_area_fences$upper)

7. Build the linear regression model:

model <- lm(Price ~ BuildingArea, data = train_data)

8. Predict and visualize the results:

test_data$Predicted_Price <- predict(model, test_data)

ggplot(test_data, aes(x = BuildingArea, y = Price)) +
  geom_point(aes(color = "Actual")) +
  geom_point(aes(y = Predicted_Price, color = "Predicted")) +
  labs(title = "Actual vs Predicted Prices")
  
License

This project is licensed under the terms of the R Foundation for Statistical Computing.
