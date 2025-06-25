# Non-Gaussian Statistical Distributions Guide

## Table of Contents

1. [Kurtosis](#kurtosis)
2. [Testing for Normality](#testing-for-normality)
3. [QQ Plots](#qq-plots)
4. [Uniform Distribution](#uniform-distribution)
5. [Log-Normal Distribution](#log-normal-distribution)
6. [Pareto Distribution](#pareto-distribution)
7. [Transformations](#transformations)

---

## Kurtosis

### What is Kurtosis?

Kurtosis is the **4th statistical moment** in probability theory and statistics. The term comes from the Greek word meaning "curved" or "arching". It measures the "tailedness" of a probability distribution of a real-valued random variable.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Comparison_mean_median_mode.svg/354px-Comparison_mean_median_mode.svg.png" alt="Statistical Moments Visualization" width="400">

### Kurtosis Formula

The kurtosis formula is:

**K = E[(X - μ)⁴] / σ⁴**

Where:

- K = Kurtosis
- E = Expected value
- X = Random variable
- μ = Mean
- σ = Standard deviation

### Practical Use Case in Finance

In finance, **kurtosis risk** refers to the risk associated with extreme outcomes or "fat tails" in return distributions. High kurtosis indicates:

- Higher likelihood of extreme events (positive or negative)
- Greater probability of large losses or gains
- Need for adjusted investment strategies

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Standard_deviation_diagram.svg/400px-Standard_deviation_diagram.svg.png" alt="Normal Distribution with Standard Deviations" width="400">

### Excess Kurtosis & Types

**Excess Kurtosis** = Sample Kurtosis - 3

This measures how much more peaked or flat a distribution is compared to a normal distribution (which has kurtosis = 3).

#### Types of Kurtosis:

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Comparison_of_normal_and_non-normal_distribution_kurtosis.png/800px-Comparison_of_normal_and_non-normal_distribution_kurtosis.png" alt="Kurtosis Types Comparison" width="600">

**1. Leptokurtic (Positive Excess Kurtosis)**

- "Lepto" = slender
- **Fatter tails** and more peaked center
- More extreme values/outliers
- **Example**: Risky, volatile assets with sudden price movements

**2. Platykurtic (Negative Excess Kurtosis)**

- "Platy" = broad
- **Thinner tails** and flatter peak
- Fewer extreme values/outliers
- **Example**: Less risky assets with gradual price movements

**3. Mesokurtic (Zero Excess Kurtosis)**

- Same "peakedness" as normal distribution
- **Example**: Normal distribution family
- Considered ideal for balanced risk-return portfolios

---

## Testing for Normality

### How to Determine if a Distribution is Normal

#### 1. Visual Inspection

- Create **histogram** or **density plot**
- Look for bell-shaped curve
- Check for symmetric tails

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/720px-Normal_Distribution_PDF.svg.png" alt="Normal Distribution Bell Curve" width="500">

#### 2. QQ Plot (Quantile-Quantile Plot)

- Plots observed data against expected normal values
- Points should fall along straight line for normal data

#### 3. Statistical Tests

- **Shapiro-Wilk test**
- **Anderson-Darling test**
- **Kolmogorov-Smirnov test**

**Interpretation**: p-value < 0.05 suggests data is **not normal**

---

## QQ Plots

### What is a QQ Plot?

A **Quantile-Quantile (QQ) plot** is a graphical tool for assessing similarity between two data distributions. It's particularly useful for determining if data follows a normal distribution.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Normal_normal_qq.svg/360px-Normal_normal_qq.svg.png" alt="Normal QQ Plot Example" width="400">

### How QQ Plots Work

1. **Quantiles** of two datasets are plotted against each other
2. **X-axis**: Quantiles of first dataset
3. **Y-axis**: Quantiles of second dataset
4. **Straight line**: Indicates same distribution
5. **Deviation from line**: Indicates different distributions

### Python Implementation

```python
import statsmodels.api as sm
import matplotlib.pyplot as plt

# Create QQ plot
sm.qqplot(data, line='s')
plt.show()
```

Reference: [Statsmodels QQ Plot Documentation](https://www.statsmodels.org/dev/generated/statsmodels.graphics.gofplots.qqplot.html)

### Interpreting QQ Plots

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/QQplot_-_random_data_from_different_distributions.png/640px-QQplot_-_random_data_from_different_distributions.png" alt="QQ Plot Interpretations" width="600">

- **Straight line**: Normal distribution
- **S-shaped curve**: Skewed distribution
- **Curved ends**: Heavy or light tails
- **Outliers**: Points far from the line

### Does QQ Plot Only Detect Normal Distribution?

**No!** QQ plots can compare any two distributions:

- Normal vs. sample data (most common)
- Sample vs. any theoretical distribution
- Two sample datasets
- Different distribution families (exponential, uniform, etc.)

---

## Uniform Distribution

### Definition

In a **uniform distribution**, all outcomes are **equally likely** within a given range. Every value has the same probability of occurrence.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Uniform_Distribution_PDF_SVG.svg/512px-Uniform_Distribution_PDF_SVG.svg.png" alt="Uniform Distribution PDF" width="400">

### Types

**Continuous Uniform Distribution**: U(a,b)

- **Notation**: X ~ U(a,b)
- **Range**: [a, b]
- **PDF**: f(x) = 1/(b-a) for a ≤ x ≤ b

**Discrete Uniform Distribution**

- Finite number of equally likely outcomes
- **Example**: Rolling a fair die

### Examples

1. **Height**: Person randomly selected from 5'6" to 6'0" range
2. **Production time**: Machine output between 5-10 minutes
3. **Travel distance**: Car travels 300-400 miles on full tank
4. **Apple weight**: Random apple weighs 100-200 grams

### PDF and CDF Formulas

**PDF (Probability Density Function)**:

```
f(x) = 1/(b-a)  for a ≤ x ≤ b
f(x) = 0        otherwise
```

**CDF (Cumulative Distribution Function)**:

```
F(x) = 0           for x < a
F(x) = (x-a)/(b-a) for a ≤ x ≤ b
F(x) = 1           for x > b
```

### Skewness

**Skewness = 0** (perfectly symmetric)

### Applications in Machine Learning

1. **Random Initialization**: Neural networks, k-means clustering
2. **Sampling**: Representative subset selection
3. **Data Augmentation**: Generate new data points within range
4. **Hyperparameter Tuning**: Explore parameter space uniformly

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Artificial_neural_network.svg/560px-Artificial_neural_network.svg.png" alt="Neural Network Architecture" width="500">

---

## Log-Normal Distribution

### Definition

A **log-normal distribution** is a continuous probability distribution where the **logarithm** of the variable is normally distributed. It has heavy tails and is right-skewed.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/PDF-log_normal_distributions.svg/640px-PDF-log_normal_distributions.svg.png" alt="Log-Normal Distribution PDFs" width="500">

### Real-World Examples

1. **Internet forums**: Length of discussion comments
2. **Online articles**: User dwell time (jokes, news)
3. **Chess games**: Game duration
4. **Economics**: Income distribution (97-99% of population)

### Mathematical Notation

**X ~ LogNormal(μ, σ²)**

Where μ and σ are the mean and standard deviation of the underlying normal distribution.

### PDF Equation

**f(x) = (1/(x·σ·√(2π))) · exp(-((ln(x)-μ)²)/(2σ²))**

For x > 0

### CDF

**F(x) = Φ((ln(x)-μ)/σ)**

Where Φ is the standard normal CDF.

### Skewness

**Skewness = (e^(σ²) + 2)√(e^(σ²) - 1)**

Always positive (right-skewed).

### Testing for Log-Normal Distribution

1. **Take logarithm** of data
2. **Test if log(X) is normally distributed**
3. Use normality tests (Shapiro-Wilk, etc.)
4. Check QQ plot of log-transformed data

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/LogNormal_distribution_PDF.png/640px-LogNormal_distribution_PDF.png" alt="Log-Normal vs Normal Distribution" width="500">

---

## Pareto Distribution

### Definition

The **Pareto distribution** models quantities that exhibit **power-law behavior**. It's commonly used for wealth, income, and other phenomena where "few have much, many have little."

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Probability_density_function_of_Pareto_distribution.svg/640px-Probability_density_function_of_Pareto_distribution.svg.png" alt="Pareto Distribution PDF" width="500">

### Power Law Relationship

**y = k × x^a**

Where:

- k = scaling constant
- a = power law exponent

### Historical Context

**Vilfredo Pareto** used this distribution to describe:

- **Wealth allocation**: 20% of people control 80% of wealth
- **Income distribution**: Similar concentration patterns
- **Pareto Principle**: The famous "80-20 rule"

### Parameters and Graph

**PDF**: f(x) = (α × x_m^α) / x^(α+1)

Where:

- α = shape parameter (α > 0)
- x_m = scale parameter (minimum value)
- x ≥ x_m

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Pareto_distribution_pdf.png/640px-Pareto_distribution_pdf.png" alt="Pareto Distribution with Different Parameters" width="500">

### Real-World Examples

1. **Human settlements**: Few large cities, many small villages
2. **Internet traffic**: Many small files, few large files (TCP protocol)
3. **Business**: 80% of sales from 20% of customers
4. **Software**: 80% of problems from 20% of code

### CDF

**F(x) = 1 - (x_m/x)^α**

### Skewness

**Skewness = (2(1+α)√(α-2))/((α-3)√α)**

For α > 3 (always positive - right skewed)

### Detecting Pareto Distribution

1. **Log-log plot**: Should show straight line
2. **Rank-frequency plot**: Check for power-law relationship
3. **Statistical tests**: Kolmogorov-Smirnov goodness-of-fit
4. **Parameter estimation**: Maximum likelihood estimation

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Pareto_distribution_visualization.png/640px-Pareto_distribution_visualization.png" alt="Pareto Distribution Visualization" width="500">

---

## Transformations

Data transformations are essential techniques for:

- **Converting non-normal data** to approximately normal
- **Stabilizing variance**
- **Linearizing relationships**
- **Meeting statistical assumptions**

### Common Transformations

1. **Logarithmic**: log(x) - for right-skewed data
2. **Square root**: √x - for Poisson-like data
3. **Box-Cox**: More flexible power transformations
4. **Reciprocal**: 1/x - for highly right-skewed data

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Data_transformation_illustration.png/640px-Data_transformation_illustration.png" alt="Data Transformation Effects" width="600">

### When to Use Transformations

- **Skewed distributions** → More symmetric
- **Heteroscedasticity** → Constant variance
- **Non-linear relationships** → Linear relationships
- **Outliers** → Reduce impact

---

## Summary

Understanding non-Gaussian distributions is crucial for:

- **Risk Assessment** (kurtosis in finance)
- **Data Quality** (normality testing)
- **Model Selection** (distribution fitting)
- **Statistical Inference** (assumption validation)

Each distribution has unique characteristics and applications. Proper identification and handling of these distributions leads to more accurate statistical analysis and better decision-making.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/The_Normal_Distribution.svg/720px-The_Normal_Distribution.svg.png" alt="Statistical Analysis Workflow" width="600">

---

_This guide provides a comprehensive overview of non-Gaussian statistical distributions commonly encountered in data science and statistical analysis._
