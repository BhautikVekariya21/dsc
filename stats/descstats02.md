# Descriptive Statistics Session 2 - Complete Guide

## Quantiles and Percentiles

### What are Quantiles?

Quantiles are statistical measures used to divide a set of numerical data into equal-sized groups, with each group containing an equal number of observations. Quantiles are important measures of variability and can be used to:

- Understand distribution of data
- Summarize and compare different datasets
- Identify outliers

### Types of Quantiles

#### 1. Quartiles

Divide the data into four equal parts:

- **Q1** (25th percentile) - First quartile
- **Q2** (50th percentile or median) - Second quartile
- **Q3** (75th percentile) - Third quartile

#### 2. Deciles

Divide the data into ten equal parts:

- **D1** (10th percentile), **D2** (20th percentile), ..., **D9** (90th percentile)

#### 3. Percentiles

Divide the data into 100 equal parts:

- **P1** (1st percentile), **P2** (2nd percentile), ..., **P99** (99th percentile)

#### 4. Quintiles

Divide the data into 5 equal parts

### Important Things to Remember:

1. **Data should be sorted** from low to high
2. **You are finding the location** of an observation
3. **They are not actual values** in the data
4. **All other tiles** can be easily derived from Percentiles

## Percentiles

### Definition

A percentile is a statistical measure that represents the percentage of observations in a dataset that fall below a particular value. For example, the 75th percentile is the value below which 75% of the observations in the dataset fall.

### Formula to Calculate Percentile Location

**PL = (N × p) / 100**

Where:

- **PL** = the desired percentile value location
- **N** = the total number of observations in the dataset
- **p** = the percentile rank (expressed as a percentage)

### Example: Finding the 75th Percentile

**Data:** 78, 82, 84, 88, 91, 93, 94, 96, 98, 99

**Step 1:** Sort the data (already sorted)
78, 82, 84, 88, 91, 93, 94, 96, 98, 99

**Step 2:** Apply formula

- N = 10 (total observations)
- p = 75 (75th percentile)
- PL = (10 × 75) / 100 = 7.5

**Step 3:** Since PL = 7.5, we take the average of the 7th and 8th values

- 7th value = 94
- 8th value = 96
- 75th percentile = (94 + 96) / 2 = 95

## Percentile Rank of a Value

### Formula

**Percentile rank = ((X + 0.5Y) / N) × 100**

Where:

- **X** = number of values below the given value
- **Y** = number of values equal to the given value
- **N** = total number of values in the dataset

### Example

Using the same dataset: 78, 82, 84, 88, 91, 93, 94, 96, 98, 99

To find the percentile rank of 91:

- X = 4 (values below 91: 78, 82, 84, 88)
- Y = 1 (value equal to 91: just 91)
- N = 10
- Percentile rank = ((4 + 0.5×1) / 10) × 100 = 45%

## Five-Number Summary

The five-number summary is a descriptive statistic that provides a comprehensive summary of a dataset. It consists of five values that divide the dataset into four equal parts (quartiles).

### Components of Five-Number Summary:

1. **Minimum value** - The smallest value in the dataset
2. **First quartile (Q1)** - The value that separates the lowest 25% of the data from the rest
3. **Median (Q2)** - The value that separates the lowest 50% from the highest 50% of the data
4. **Third quartile (Q3)** - The value that separates the lowest 75% from the highest 25%
5. **Maximum value** - The largest value in the dataset

### Uses of Five-Number Summary:

- Quickly summarize central tendency, variability, and distribution
- Often represented visually using a box plot
- Shows the range, median, and quartiles of the dataset

## Interquartile Range (IQR)

The interquartile range is a measure of variability based on the five-number summary.

### Formula

**IQR = Q3 - Q1**

### Characteristics:

- Measures the spread of the middle 50% of the data
- Less affected by outliers than the range
- Useful for identifying outliers using the 1.5×IQR rule

## Box Plots (Box-and-Whisker Plots)

### What is a Box Plot?

A box plot is a graphical representation of a dataset that shows the distribution of the data using the five-number summary.

### Components of a Box Plot:

- **Box**: Represents the interquartile range (Q1 to Q3)
- **Median line**: Line inside the box showing Q2
- **Whiskers**: Lines extending from the box to the minimum and maximum values
- **Outliers**: Points beyond the whiskers (using 1.5×IQR rule)

### How to Create a Box Plot:

1. Calculate the five-number summary
2. Draw a box from Q1 to Q3
3. Mark the median (Q2) with a line inside the box
4. Draw whiskers to the minimum and maximum values (within 1.5×IQR)
5. Plot outliers as individual points

### Benefits of Box Plots:

1. **Easy visualization** of data distribution
2. **Shows skewness** of data
3. **Identifies outliers** clearly
4. **Enables comparison** between different datasets
5. **Side-by-side comparison** of multiple categories

### Side-by-Side Box Plots

Multiple box plots can be displayed together to compare distributions across different groups or categories.

## Scatter Plots

Scatter plots are graphical representations that show the relationship between two numerical variables. Each point represents one observation with coordinates (x, y).

### Uses of Scatter Plots:

- Visualize relationships between variables
- Identify patterns, trends, and correlations
- Detect outliers
- Assess linearity of relationships

## Covariance

### What Problem Does Covariance Solve?

Covariance helps us understand whether two variables move together or in opposite directions.

### Definition

Covariance is a statistical measure that describes the degree to which two variables are linearly related. It measures how much two variables change together.

### Interpretation:

- **Positive covariance**: Variables tend to move together in the same direction
- **Negative covariance**: Variables tend to move in opposite directions
- **Zero covariance**: Variables are not linearly related

### Formula

**Cov(X,Y) = Σ[(Xi - X̄)(Yi - Ȳ)] / (n-1)**

Where:

- Xi, Yi = individual data points
- X̄, Ȳ = means of X and Y
- n = number of observations

### Example Calculations:

#### Example 1: Experience vs Salary

| Exp(x) | Salary(y) | X-X̄ | Y-Ȳ | (X-X̄)\*(Y-Ȳ) |
| ------ | --------- | --- | --- | ------------ |
| 2      | 1         | -6  | -5  | 30           |
| 5      | 2         | -3  | -4  | 12           |
| 8      | 5         | 0   | -1  | 0            |
| 12     | 12        | 4   | 6   | 24           |
| 13     | 10        | 5   | 4   | 20           |

**Positive covariance** indicates that as experience increases, salary tends to increase.

#### Example 2: Backlogs vs Package

| Backlogs(x) | Package(y) | X-X̄ | Y-Ȳ | (X-X̄)\*(Y-Ȳ) |
| ----------- | ---------- | --- | --- | ------------ |
| 2           | 10         | -6  | 4   | -24          |
| 5           | 12         | -3  | 6   | -18          |
| 8           | 5          | 0   | -1  | 0            |
| 12          | 2          | 4   | -4  | -16          |
| 13          | 1          | 5   | -5  | -25          |

**Negative covariance** indicates that as backlogs increase, package tends to decrease.

#### Example 3: No Relationship

| Backlogs(x) | Package(y) | X-X̄ | Y-Ȳ | (X-X̄)\*(Y-Ȳ) |
| ----------- | ---------- | --- | --- | ------------ |
| 2           | 10         | -6  | 0   | 0            |
| 5           | 10         | -3  | 0   | 0            |
| 8           | 10         | 0   | 0   | 0            |
| 12          | 10         | 4   | 0   | 0            |
| 13          | 10         | 5   | 0   | 0            |

**Zero covariance** indicates no linear relationship.

### Disadvantages of Covariance:

- **Scale dependent**: Magnitude affected by the scale of variables
- **Difficult to interpret**: No standard range for comparison
- **Doesn't indicate strength**: Only shows direction, not strength of relationship

### Covariance of a Variable with Itself:

The covariance of a variable with itself equals its variance:
**Cov(X,X) = Var(X)**

## Correlation

### What Problem Does Correlation Solve?

Correlation addresses the limitations of covariance by providing a standardized measure of relationship strength.

### Definition

Correlation refers to a statistical relationship between two or more variables. It measures the degree to which two variables are related and how they tend to change together.

### Correlation Coefficient

The correlation coefficient ranges from -1 to 1:

- **+1**: Perfect positive correlation
- **0**: No correlation
- **-1**: Perfect negative correlation

### Formula (Pearson Correlation Coefficient)

**r = Cov(X,Y) / (σx × σy)**

Where:

- Cov(X,Y) = covariance between X and Y
- σx, σy = standard deviations of X and Y

### Advantages over Covariance:

- **Standardized measure**: Always between -1 and +1
- **Scale independent**: Not affected by units of measurement
- **Interpretable**: Easy to understand strength of relationship

## Correlation and Causation

### Important Principle

**"Correlation does not imply causation"**

This means that just because two variables are associated with each other, it does not necessarily mean that one causes the other.

### Example: Firefighters and Fire Damage

- **Observation**: Positive correlation between number of firefighters present and fire damage
- **Wrong conclusion**: Firefighters cause more damage
- **Correct explanation**: A third variable (fire severity) affects both:
  - More severe fires require more firefighters
  - More severe fires also cause more damage

### Establishing Causation Requires:

- Controlled experiments
- Randomized controlled trials
- Well-designed observational studies
- Additional evidence beyond correlation

## Visualizing Multiple Variables

### 1. 3D Scatter Plots

Three-dimensional scatter plots show relationships between three numerical variables simultaneously.

**Uses:**

- Visualize complex relationships
- Identify patterns in three dimensions
- Explore multivariate data

### 2. Hue Parameter

Adding color coding to plots based on a categorical variable.

**Benefits:**

- Distinguish between different groups
- Add another dimension to 2D plots
- Reveal group-specific patterns

### 3. Facet Grids

Creating multiple subplots based on categorical variables.

**Advantages:**

- Compare patterns across different categories
- Avoid overcrowding in single plots
- Enable detailed group comparisons

### 4. Joint Plots

Combine scatter plots with marginal histograms or density plots.

**Features:**

- Show bivariate relationships
- Display individual variable distributions
- Comprehensive view of data

### 5. Pair Plots

Matrix of scatter plots showing relationships between all pairs of variables.

**Uses:**

- Explore multiple variable relationships simultaneously
- Identify interesting variable pairs
- Get overview of entire dataset

### 6. Bubble Plots

Scatter plots where point size represents a third variable.

**Applications:**

- Show three variables in 2D space
- Emphasize important observations
- Create visually appealing representations

## Summary

This session covered advanced descriptive statistics concepts including:

- **Quantiles and percentiles** for understanding data distribution
- **Five-number summary and box plots** for comprehensive data visualization
- **Covariance and correlation** for measuring relationships between variables
- **Multiple variable visualization techniques** for complex data exploration

These tools are essential for:

- Comprehensive data analysis
- Identifying patterns and relationships
- Making informed decisions based on data
- Communicating findings effectively

Understanding these concepts provides a solid foundation for advanced statistical analysis and data science applications.
