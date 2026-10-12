# Housing prices with linear regression

An R analysis of the relationship between building area and housing price. The script explores numeric correlations, splits the data into training and test sets, filters outliers, and fits `Price ~ BuildingArea`.

## Run locally

Install R 4.3.1 or newer and the packages used by the script:

```r
install.packages(c("tidyverse", "tidymodels"))
```

Clone this repository and run from its root:

```bash
git clone https://github.com/derrickbaruga7/R-Linear-Model.git
cd R-Linear-Model
Rscript "R linear modelling.R"
```

The source dataset is **not included**. Place `melbourne_housing.csv` in `data/`, or set `HOUSING_DATA_PATH` to its location. The model requires numeric `Price` and `BuildingArea` columns. The original script drops rows with missing values across the supplied columns, so a different dataset layout may change the retained sample.

Open [R linear modelling.R](R%20linear%20modelling.R) in RStudio and run the plotting expressions interactively to inspect the figures.

## Method and limits

- A seeded 75/25 split separates training and test rows.
- Price and building-area outlier fences are calculated from training data.
- A building-area limit of 1,000 is applied to both sets, restricting the evaluation population.
- The final model uses building area alone; it does not incorporate all housing attributes or establish a causal effect.

The repository does not include a license file. R's own license does not license this project's code.
