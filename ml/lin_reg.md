# Simple Linear Regression and Regression Metrics

## Simple Linear Regression

### Introduction

Simple Linear Regression is a statistical method used to model the relationship between a dependent variable (target) and a single independent variable (feature). It assumes a linear relationship between the variables and aims to find the best-fitting straight line through the data points.

### Mathematical Foundation

The simple linear regression equation is:

```
y = mx + b
```

Where:

- `y` = dependent variable (target/output)
- `x` = independent variable (feature/input)
- `m` = slope of the line (coefficient)
- `b` = y-intercept (bias term)

### Intuition

Simple linear regression works by finding the line that best fits through the data points. The "best fit" is determined by minimizing the sum of squared differences between the actual values and the predicted values (residuals).

The goal is to:

1. Find the optimal values of `m` (slope) and `b` (intercept)
2. Minimize the prediction errors
3. Create a model that can make accurate predictions on new data

### Finding the Optimal Parameters (m and b)

#### Method 1: Normal Equation (Analytical Solution)

The optimal values of `m` and `b` can be calculated using the following formulas:

**Slope (m):**

```
m = (n∑xy - ∑x∑y) / (n∑x² - (∑x)²)
```

**Intercept (b):**

```
b = (∑y - m∑x) / n
```

Where:

- `n` = number of data points
- `∑xy` = sum of products of x and y
- `∑x` = sum of x values
- `∑y` = sum of y values
- `∑x²` = sum of squared x values

#### Method 2: Least Squares Method

The least squares method minimizes the sum of squared residuals:

**Cost Function:**

```
J(m,b) = (1/2n) ∑(yi - (mxi + b))²
```

**Gradient Descent Update Rules:**

```
m = m - α * (∂J/∂m)
b = b - α * (∂J/∂b)
```

Where:

```
∂J/∂m = (1/n) ∑(yi - (mxi + b)) * (-xi)
∂J/∂b = (1/n) ∑(yi - (mxi + b)) * (-1)
```

### Implementation from Scratch

```python
import numpy as np
import matplotlib.pyplot as plt

class SimpleLinearRegression:
    def __init__(self):
        self.slope = None
        self.intercept = None

    def fit(self, X, y):
        n = len(X)

        # Calculate slope (m)
        numerator = n * np.sum(X * y) - np.sum(X) * np.sum(y)
        denominator = n * np.sum(X**2) - (np.sum(X))**2
        self.slope = numerator / denominator

        # Calculate intercept (b)
        self.intercept = (np.sum(y) - self.slope * np.sum(X)) / n

    def predict(self, X):
        return self.slope * X + self.intercept
```

## Regression Metrics

### Mean Absolute Error (MAE)

MAE measures the average absolute difference between predicted and actual values.

**Formula:**

```
MAE = (1/n) ∑|yi - ŷi|
```

**Characteristics:**

- Range: [0, ∞)
- Units: Same as target variable
- Less sensitive to outliers
- Intuitive interpretation

**When to use:**

- When you want to penalize all errors equally
- When outliers should not heavily influence the metric
- When you need an easily interpretable metric

### Mean Squared Error (MSE)

MSE measures the average squared difference between predicted and actual values.

**Formula:**

```
MSE = (1/n) ∑(yi - ŷi)²
```

**Characteristics:**

- Range: [0, ∞)
- Units: Squared units of target variable
- More sensitive to outliers than MAE
- Penalizes larger errors more heavily

**When to use:**

- When large errors are particularly undesirable
- When you want to penalize outliers more heavily
- For optimization purposes (differentiable)

### Root Mean Squared Error (RMSE)

RMSE is the square root of MSE, bringing the units back to the original scale.

**Formula:**

```
RMSE = √(MSE) = √[(1/n) ∑(yi - ŷi)²]
```

**Characteristics:**

- Range: [0, ∞)
- Units: Same as target variable
- Sensitive to outliers
- More interpretable than MSE

**When to use:**

- When you want MSE's properties but in original units
- When comparing models with different scales
- When you need an easily interpretable metric

### R-squared (R²) Score

R² measures the proportion of variance in the dependent variable explained by the independent variable.

**Formula:**

```
R² = 1 - (SSres/SStot)
```

Where:

```
SSres = ∑(yi - ŷi)²  (Sum of Squares Residual)
SStot = ∑(yi - ȳ)²   (Total Sum of Squares)
```

**Alternative Formula:**

```
R² = 1 - (MSE/Var(y))
```

**Characteristics:**

- Range: (-∞, 1]
- Unitless
- R² = 1: Perfect prediction
- R² = 0: Model performs as well as predicting the mean
- R² < 0: Model performs worse than predicting the mean

**Interpretation:**

- R² = 0.8 means 80% of variance is explained by the model
- Higher R² indicates better fit

### Adjusted R-squared (Adjusted R²)

Adjusted R² modifies R² to account for the number of features in the model, preventing inflation due to adding more variables.

**Formula:**

```
Adjusted R² = 1 - [(1 - R²) * (n - 1) / (n - k - 1)]
```

Where:

- `n` = number of observations
- `k` = number of independent variables

**Characteristics:**

- Range: (-∞, 1]
- Penalizes addition of irrelevant features
- More reliable for model comparison
- Can decrease when adding non-significant variables

**When to use:**

- When comparing models with different numbers of features
- When you want to avoid overfitting
- For feature selection purposes

## Model Evaluation Summary

| Metric | Formula           | Range   | Units    | Outlier Sensitivity | Best Value |
| ------ | ----------------- | ------- | -------- | ------------------- | ---------- |
| MAE    | (1/n)∑\|yi - ŷi\| | [0, ∞)  | Original | Low                 | 0          |
| MSE    | (1/n)∑(yi - ŷi)²  | [0, ∞)  | Squared  | High                | 0          |
| RMSE   | √MSE              | [0, ∞)  | Original | High                | 0          |
| R²     | 1 - SSres/SStot   | (-∞, 1] | None     | Medium              | 1          |
| Adj R² | Modified R²       | (-∞, 1] | None     | Medium              | 1          |

## Practical Implementation

```python
import numpy as np
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

def calculate_metrics(y_true, y_pred):
    mae = mean_absolute_error(y_true, y_pred)
    mse = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    r2 = r2_score(y_true, y_pred)

    # Adjusted R² calculation
    n = len(y_true)
    k = 1  # number of features for simple linear regression
    adj_r2 = 1 - (1 - r2) * (n - 1) / (n - k - 1)

    return {
        'MAE': mae,
        'MSE': mse,
        'RMSE': rmse,
        'R²': r2,
        'Adjusted R²': adj_r2
    }
```

## Key Takeaways

1. **Simple Linear Regression** models linear relationships between one input and one output variable
2. **Parameter estimation** can be done analytically using normal equations or iteratively using gradient descent
3. **MAE** is robust to outliers and easily interpretable
4. **MSE/RMSE** penalizes large errors more heavily, useful when large errors are costly
5. **R²** indicates the proportion of variance explained by the model
6. **Adjusted R²** is preferred when comparing models with different numbers of features

Choose the appropriate metric based on your specific problem requirements and the nature of your data.
