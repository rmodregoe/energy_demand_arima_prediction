# Energy Demand Prediction Using ARIMA Models

## Repository Name
`energy-demand-arima-prediction`

## Project Description
This project predicts energy demand at 6 PM using ARIMA (AutoRegressive Integrated Moving Average) models. The study incorporates historical demand data, temperature variables, and public holidays as regressors to improve prediction accuracy. The analysis explores different variations of ARIMA models to identify the best fit.

## Features
- **Data Preparation**:
  - Processes hourly demand data from 2011 to 2019.
  - Corrects anomalies such as daylight savings and missing values.
- **Temperature Integration**:
  - Includes daily maximum and minimum temperatures as predictive regressors.
- **Holiday Effects**:
  - Adjusts for national and local public holidays to improve model accuracy.
- **ARIMA Modeling**:
  - Implements seasonal ARIMA models with varying regressors.
  - Evaluates model performance using metrics like AIC (Akaike Information Criterion) and residual analysis.
- **Visualization**:
  - Generates diagnostic plots to assess model fit and residual behavior.

## Motivation
This project was developed during my studies as part of a time series analysis course. The aim was to apply statistical techniques to a practical problem, leveraging ARIMA models for demand prediction while integrating external factors like weather and holidays.

## Included Files
- `graphs.R`: R script for generating diagnostic plots.
- `data_loading.R`: R script for loading and preprocessing data.
- `reg_Arima.R`: R script for ARIMA model implementation.
- `Demand_PENR2.mat`: Input data containing energy demand.
- `Holidays_PENR2.mat`: Input data for public holidays.
- `TempPrev_PENR2.mat`: Input data for historical temperature records.

## Requirements
- R 4.1.2 or higher.
- Libraries:
  - `R.matlab`
  - `forecast`
  - `xts`
  - `zoo`
  - `lubridate`
  - `dygraphs`

Install dependencies in R:
```R
install.packages(c("R.matlab", "forecast", "xts", "zoo", "lubridate", "dygraphs"))
```

## Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/rmodregoe/energy-demand-arima-prediction.git
   ```
2. Open the R scripts in your preferred IDE (e.g., RStudio).
3. Run `data_loading.R` to preprocess the data.
4. Execute `reg_Arima.R` to implement and evaluate ARIMA models.
5. Use `graphs.R` to generate diagnostic plots.

## Results
The project identifies ARIMA models with regressors that significantly improve energy demand predictions by incorporating temperature effects and public holiday adjustments. Key findings include:
- Lower AIC values for models with temperature and holiday adjustments.
- Residuals analysis to validate model assumptions.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
Created by Ricardo Modrego. For questions or comments, contact me at [r.modrego.e@gmail.com](mailto:r.modrego.e@gmail.com).
