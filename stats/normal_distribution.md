# Complete Guide to Normal Distribution

## What is Normal Distribution?

Normal distribution, also known as **Gaussian distribution**, is a probability distribution that is commonly used in statistical analysis. It is a continuous probability distribution that is symmetrical around the mean, with a distinctive bell-shaped curve.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/800px-Normal_Distribution_PDF.svg.png" alt="Normal Distribution Bell Curve" width="600">

### Key Characteristics:

- **Tail**: The distribution has tails that extend infinitely in both directions
- **Asymptotic in nature**: The tails approach but never touch the x-axis
- **Concentration around mean**: Lots of data points near the mean and very few far away
- **Symmetrical**: Perfectly balanced around the center

## Parameters of Normal Distribution

The normal distribution is characterized by two parameters:

1. **Mean (μ)**: Represents the center of the distribution
2. **Standard deviation (σ)**: Represents the spread of the distribution

**Notation**: X ~ N(μ, σ²)

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Standard_deviation_diagram.svg/800px-Standard_deviation_diagram.svg.png" alt="Standard Deviation in Normal Distribution" width="600">

## PDF Equation of Normal Distribution

The probability density function (PDF) of a normal distribution is:

```
f(x) = (1 / (σ√(2π))) * e^(-(x-μ)²/(2σ²))
```

Where:

- **x** = random variable
- **μ** = mean
- **σ** = standard deviation
- **e** = Euler's number (≈ 2.718)
- **π** = Pi (≈ 3.14159)

<img src="https://wikimedia.org/api/rest_v1/media/math/render/svg/8b13f4c6c0e7c3db99b2d7fd8f945f5bcc8a0b8d" alt="Normal Distribution PDF Formula" width="400">

## Why is Normal Distribution Important?

### Commonality in Nature

Many natural phenomena follow a normal distribution:

- Heights of people
- Weights of objects
- IQ scores of a population
- Measurement errors
- Blood pressure readings
- Test scores

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/The_Normal_Distribution.svg/800px-The_Normal_Distribution.svg.png" alt="Real-world examples of normal distribution" width="600">

## Standard Normal Variate (Z-Score)

A **Standard Normal Variate (Z)** is a standardized form of the normal distribution with:

- **Mean = 0**
- **Standard deviation = 1**

### Formula for Standardization:

```
Z = (X - μ) / σ
```

Where:

- **Z** = standardized value
- **X** = original value
- **μ** = population mean
- **σ** = population standard deviation

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Normal_distribution_and_scales.gif/800px-Normal_distribution_and_scales.gif" alt="Standard Normal Distribution" width="600">

### Benefits of Standardization:

1. **Comparison**: Allows comparison between different distributions
2. **Probability calculation**: Enables use of standard Z-tables
3. **Universal reference**: Creates a common scale for all normal distributions

## Z-Tables

A z-table tells you the area underneath a normal distribution curve, to the left of the z-score. This represents the cumulative probability.

<img src="https://www.mathsisfun.com/data/images/normal-distrubution-large.svg" alt="Z-table visualization" width="600">

**Example**: If Z = 1.96, the z-table shows that approximately 97.5% of the data falls below this value.

## Properties of Normal Distribution

### 1. Symmetricity

The normal distribution is perfectly symmetric about its mean. The probability of observing a value above the mean equals the probability of observing a value below the mean.

### 2. Measures of Central Tendency

In a normal distribution:

- **Mean = Median = Mode**

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Relationship_between_mean_and_median_under_different_skewness.png/800px-Relationship_between_mean_and_median_under_different_skewness.png" alt="Central tendencies in normal distribution" width="600">

### 3. Empirical Rule (68-95-99.7 Rule)

- **68%** of data falls within **1 standard deviation** of the mean
- **95%** of data falls within **2 standard deviations** of the mean
- **99.7%** of data falls within **3 standard deviations** of the mean

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Empirical_Rule.PNG/800px-Empirical_Rule.PNG" alt="Empirical Rule Visualization" width="600">

### 4. Area Under the Curve

The total area under the normal distribution curve equals **1** (representing 100% probability).

## Skewness

### What is Skewness?

Skewness is a measure of the asymmetry of a probability distribution. It describes how much a dataset deviates from the normal distribution.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Negative_and_positive_skew_diagrams_%28English%29.svg/800px-Negative_and_positive_skew_diagrams_%28English%29.svg.png" alt="Types of Skewness" width="600">

### Types of Skewness:

- **Positive Skewness**: Tail is longer on the right side (mean > median > mode)
- **Negative Skewness**: Tail is longer on the left side (mode > median > mean)
- **Zero Skewness**: Perfectly symmetrical distribution (mean = median = mode)

### Skewness Formula:

```
Skewness = E[(X - μ)³] / σ³
```

### Interpretation:

- **Skewness = 0**: Normal distribution
- **-0.5 < Skewness < 0.5**: Approximately symmetric
- **Skewness < -1 or > 1**: Highly skewed

## Cumulative Distribution Function (CDF)

The CDF gives the probability that a random variable X is less than or equal to a specific value x.

```
F(x) = P(X ≤ x) = ∫[from -∞ to x] f(t) dt
```

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Normal_Distribution_CDF.svg/800px-Normal_Distribution_CDF.svg.png" alt="Normal Distribution CDF" width="600" />

## Applications in Data Science

### 1. Outlier Detection

Values beyond 3 standard deviations from the mean are typically considered outliers.

<img src="https://miro.medium.com/v2/resize:fit:1400/1*_8tZEhvJhsIWrXcN0IPVQA.png" alt="Outlier detection using normal distribution" width="600" />

### 2. Machine Learning Assumptions

Many ML algorithms assume normal distribution:

- **Linear Regression**: Assumes residuals are normally distributed
- **Gaussian Mixture Models (GMM)**: Explicitly uses normal distributions

### 3. Hypothesis Testing

Normal distribution is fundamental in:

- t-tests
- ANOVA
- Confidence intervals
- p-value calculations

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Student_t_pdf.svg/800px-Student_t_pdf.svg.png" alt="Hypothesis testing with normal distribution" width="600" />

### 4. Central Limit Theorem

States that the sampling distribution of sample means approaches a normal distribution as sample size increases, regardless of the population distribution.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/IllustrationCentralTheorem.png/800px-IllustrationCentralTheorem.png" alt="Central Limit Theorem" width="600" />

## Practical Example

**Problem**: Heights of adult males follow N(68, 3²). What's the probability a randomly selected male is taller than 72 inches?

**Solution**:

1. Calculate Z-score:  
   \( Z = \frac{72 - 68}{3} = 1.33 \)

2. From Z-table:  
   \( P(Z \leq 1.33) = 0.9082 \)

3. Probability of being taller than 72:  
   \( P(X > 72) = 1 - 0.9082 = 0.0918 = 9.18\% \)

![Normal Distribution with Z=1.33](https://upload.wikimedia.org/wikipedia/commons/8/8c/Standard_deviation_diagram.svg)

---

# Interactive Visualization of Normal Distribution

For hands-on experience with normal distributions, try these tools:

- **[Normal Distribution Visualizer](https://samp-suman-normal-dist-visualize-app-lkntug.streamlit.app/)**  
  Adjust mean (μ) and standard deviation (σ) to see real-time changes in the curve.
- **[Z-table Calculator](https://www.ztable.net/)**  
  Calculate probabilities for standard normal (Z) scores.

---

## Visualizing Tail Probabilities

Here are alternative images for the standard normal distribution:

### Annotated Bell Curve

![Bell Curve with Tails](https://www.simplypsychology.org/wp-content/uploads/normal-distribution.jpg)  
_Source: Simply Psychology_

Key features:

- **Right-tail probability**: Shaded area under the curve for \( P(Z > z) \).
- **Symmetry**: Left-tail probabilities mirror the right tail (e.g., \( P(Z < -1.96) = P(Z > 1.96) \)).

---

## Importance of Normal Distribution

The normal distribution is foundational because:

1. **Central Limit Theorem**  
   Sample means approximate normality, enabling confidence intervals and hypothesis testing.
2. **Empirical Rule**
   - 68% of data falls within ±1σ of μ.
   - 95% within ±2σ.
   - 99.7% within ±3σ.
3. **Standardization**  
   Z-scores (\( \frac{X - μ}{σ} \)) allow cross-dataset comparisons.

---

> _"The normal distribution is the backbone of statistical inference, turning randomness into measurable patterns."_  
> — Adapted from [Investopedia](https://www.investopedia.com/terms/n/normaldistribution.asp).

For further reading:

- [LibreTexts on Normal Distributions](https://stats.libretexts.org/Bookshelves/Introductory_Statistics)
- [Khan Academy Tutorial](https://www.khanacademy.org/math/statistics-probability/modeling-distributions-of-data)

---

> _Normal distribution is the cornerstone of statistical analysis and data science, providing the mathematical foundation for understanding variability in natural phenomena and enabling powerful analytical techniques._
