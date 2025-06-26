# Descriptive Statistics - Complete Guide

## What is Statistics?

Statistics is a branch of mathematics that involves collecting, analyzing, interpreting, and presenting data. It provides tools and methods to understand and make sense of large amounts of data and to draw conclusions and make decisions based on the data.

Statistics is used in a wide range of fields, such as business, economics, social sciences, medicine, and engineering. It is used to conduct research studies, analyze market trends, evaluate the effectiveness of treatments and interventions, and make forecasts and predictions.

### Examples of Statistics Applications:

1. **Business** - Data Analysis (Identifying customer behavior) and Demand Forecasting
2. **Medical** - Identify efficacy of new medicines (Clinical trials), Identifying risk factors for diseases (Epidemiology)
3. **Government & Politics** - Conducting surveys, Polling
4. **Environmental Science** - Climate research

## Types of Statistics

### 1. Descriptive Statistics

Descriptive statistics deals with the collection, organization, analysis, interpretation, and presentation of data. It focuses on summarizing and describing the main features of a set of data, without making inferences or predictions about the larger population.

### 2. Inferential Statistics

Inferential statistics deals with making conclusions and predictions about a population based on a sample. It involves the use of probability theory to estimate the likelihood of certain events occurring, hypothesis testing to determine if a certain claim about a population is supported by the data, and regression analysis to examine the relationships between variables.

## Population vs Sample

### Population

Population refers to the entire group of individuals or objects that we are interested in studying. It is the complete set of observations that we want to make inferences about.

**Examples:**

- All the students in a particular school
- All the cars in a particular city
- All cricket fans

### Sample

A sample is a subset of the population. It is a smaller group of individuals or objects that we select from the population to study. Samples are used to estimate characteristics of the population, such as the mean or the proportion with a certain attribute.

**Examples:**

- 100 randomly selected students from a school
- Fans who were present in the stadium
- Students who visit college for lectures

### Things to be Careful About When Creating Samples:

1. **Sample Size** - Ensure adequate size for reliable results
2. **Random** - Use random selection methods
3. **Representative** - Ensure sample represents the population

### Parameter vs Statistics

- **Parameter**: A characteristic of a population (generally unknown)
- **Statistic**: A characteristic of a sample (used to estimate parameters)

The goal of statistical inference is to use the information obtained from the sample to make inferences about the population parameters.

## Inferential Statistics Topics

Inferential statistics involves using statistical techniques to test hypotheses and draw conclusions from data:

1. **Hypothesis Testing** - Testing a hypothesis about a population parameter based on sample data
2. **Confidence Intervals** - Estimating the range of values that a population parameter could take
3. **Analysis of Variance (ANOVA)** - Comparing means across multiple groups
4. **Regression Analysis** - Modeling the relationship between dependent and independent variables
5. **Chi-square Tests** - Testing independence or association between categorical variables
6. **Sampling Techniques** - Ensuring representative samples of the population
7. **Bayesian Statistics** - Updating beliefs about probability based on new evidence

## Types of Data

Data can be classified into different types based on their characteristics and the level of measurement. Understanding data types is crucial for selecting appropriate statistical methods and visualization techniques.

## Measures of Central Tendency

A measure of central tendency is a statistical measure that represents a typical or central value for a dataset. It provides a summary of the data by identifying a single value that is most representative of the dataset as a whole.

### 1. Mean

The mean is the sum of all values in the dataset divided by the number of values.

**Formula:** Mean = Σx / n

Where:

- Σx = sum of all values
- n = number of values

### 2. Median

The median is the middle value in the dataset when the data is arranged in order.

**Steps to find median:**

1. Arrange data in ascending order
2. If n is odd: median = middle value
3. If n is even: median = average of two middle values

### 3. Mode

The mode is the value that appears most frequently in the dataset.

**Types of mode:**

- Unimodal: One mode
- Bimodal: Two modes
- Multimodal: More than two modes
- No mode: All values appear equally

### 4. Weighted Mean

The weighted mean is the sum of the products of each value and its weight, divided by the sum of the weights. It is used when values in the dataset have different importance or frequency.

**Formula:** Weighted Mean = Σ(xi × wi) / Σwi

Where:

- xi = individual values
- wi = corresponding weights

### 5. Trimmed Mean

A trimmed mean is calculated by removing a certain percentage of the smallest and largest values from the dataset and then taking the mean of the remaining values. The percentage of values removed is called the trimming percentage.

**Purpose:** Reduces the effect of outliers on the mean

## Measures of Dispersion

A measure of dispersion is a statistical measure that describes the spread or variability of a dataset. It provides information about how the data is distributed around the central tendency of the dataset.

### 1. Range

The range is the difference between the maximum and minimum values in the dataset.

**Formula:** Range = Maximum value - Minimum value

**Characteristics:**

- Simple to calculate
- Can be affected by outliers
- Provides basic understanding of data spread

### 2. Variance

The variance is the average of the squared differences between each data point and the mean. It measures the average distance of each data point from the mean.

**Population Variance Formula:** σ² = Σ(xi - μ)² / N
**Sample Variance Formula:** s² = Σ(xi - x̄)² / (n-1)

**Example calculation:**

```
Data: 3, 2, 1, 5, 4
Mean = 3

X    | X-mean | (X-mean)²
-----|--------|----------
3    | 0      | 0
2    | -1     | 1
1    | -2     | 4
5    | 2      | 4
4    | 1      | 1

Variance = (0+1+4+4+1)/5 = 2
```

### 3. Standard Deviation

The standard deviation is the square root of the variance. It is a widely used measure of dispersion that describes the shape of a distribution.

**Formula:**

- Population SD: σ = √σ²
- Sample SD: s = √s²

**Advantages:**

- Same units as original data
- Widely used and understood
- Useful for describing distribution shape

### 4. Coefficient of Variation (CV)

The CV is the ratio of the standard deviation to the mean expressed as a percentage. It is used to compare the variability of datasets with different means.

**Formula:** CV = (Standard Deviation / Mean) × 100%

**Uses:**

- Comparing variability across different datasets
- Commonly used in biology, chemistry, and engineering
- Dimensionless measure of relative variability

## Univariate Analysis Graphs

### 1. Categorical Data - Frequency Distribution Table & Cumulative Frequency

#### Frequency Distribution Table

A frequency distribution table summarizes the number of times (frequency) that each value occurs in a dataset.

**Example: Survey of 200 people about favorite vacation type**

- Categories: Beach, City, Adventure, Nature, Cruise, Other
- Shows frequency of each category

#### Relative Frequency

The proportion or percentage of a category in a dataset.

**Formula:** Relative Frequency = Frequency of category / Total observations

#### Cumulative Frequency

The running total of frequencies of a variable or category.

**Calculation:** Add current frequency to all previous frequencies

### 2. Numerical Data - Frequency Distribution Table & Histogram

#### Histogram

A graphical representation of the distribution of numerical data using bars.

#### Shapes of Histograms:

1. **Normal/Bell-shaped** - Symmetric distribution
2. **Right-skewed (Positive skew)** - Tail extends to the right
3. **Left-skewed (Negative skew)** - Tail extends to the left
4. **Uniform** - All bars approximately same height
5. **Bimodal** - Two distinct peaks

## Bivariate Analysis Graphs

### 1. Categorical - Categorical: Contingency Table/Crosstab

A contingency table (cross-tabulation or crosstab) summarizes the relationship between two categorical variables. It displays frequencies or relative frequencies of observed values organized into rows and columns.

**Uses:**

- Examine relationships between categorical variables
- Calculate conditional probabilities
- Perform chi-square tests

### 2. Numerical - Numerical: Scatter Plot

A scatter plot displays the relationship between two numerical variables using points on a coordinate plane.

**Components:**

- X-axis: Independent variable
- Y-axis: Dependent variable
- Each point represents one observation

**Patterns to look for:**

- Positive correlation
- Negative correlation
- No correlation
- Non-linear relationships

### 3. Categorical - Numerical

Various graphs can be used to show the relationship between a categorical and numerical variable:

**Common visualizations:**

- Box plots by category
- Bar charts with means
- Violin plots
- Strip plots

**Purpose:**

- Compare numerical distributions across categories
- Identify differences between groups
- Detect outliers within categories

## Summary

Descriptive statistics provides essential tools for understanding and summarizing data through:

- **Central tendency measures** that identify typical values
- **Dispersion measures** that describe data variability
- **Graphical representations** that visualize data patterns
- **Frequency distributions** that show data occurrence patterns

These concepts form the foundation for more advanced statistical analysis and are crucial for data-driven decision making across various fields.

Understanding descriptive statistics is essential before moving to inferential statistics, as it provides the groundwork for making predictions and drawing conclusions about populations based on sample data.
