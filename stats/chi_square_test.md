# Complete Guide to Hypothesis Testing with Python

## Table of Contents

1. [P-value Fundamentals](#p-value-fundamentals)
2. [Interpreting P-values](#interpreting-p-values)
3. [P-value in Context of Z-test](#p-value-in-context-of-z-test)
4. [T-tests Overview](#t-tests-overview)
5. [Single Sample t-test](#single-sample-t-test)
6. [Independent Two-Sample t-test](#independent-two-sample-t-test)
7. [Paired Two-Sample t-test](#paired-two-sample-t-test)
8. [Chi-Square Distribution](#chi-square-distribution)
9. [Chi-Square Goodness-of-Fit Test](#chi-square-goodness-of-fit-test)
10. [Chi-Square Test for Independence](#chi-square-test-for-independence)
11. [Applications in Machine Learning](#applications-in-machine-learning)
12. [Python Code Examples](#python-code-examples)

---

## P-value Fundamentals

**P-value** is the probability of getting a sample as or more extreme (having more evidence against H₀) than our own sample given the Null Hypothesis (H₀) is true.

In simple words, p-value is a measure of the strength of the evidence against the Null Hypothesis that is provided by our sample data.

---

## Interpreting P-values

### With Significance Value

1. **Very small p-values (e.g., p < 0.01)** indicate strong evidence against the null hypothesis, suggesting that the observed effect or difference is unlikely to have occurred by chance alone.

2. **Small p-values (e.g., 0.01 ≤ p < 0.05)** indicate moderate evidence against the null hypothesis, suggesting that the observed effect or difference is less likely to have occurred by chance alone.

3. **Large p-values (e.g., 0.05 ≤ p < 0.1)** indicate weak evidence against the null hypothesis, suggesting that the observed effect or difference might have occurred by chance alone, but there is still some level of uncertainty.

4. **Very large p-values (e.g., p ≥ 0.1)** indicate weak or no evidence against the null hypothesis, suggesting that the observed effect or difference is likely to have occurred by chance alone.

---

## P-value in Context of Z-test

### Example 1: Training Program Impact

Suppose a company is evaluating the impact of a new training program on the productivity of its employees. The company has data on the average productivity of its employees before implementing the training program. The average productivity was 50 units per day. After implementing the training program, the company measures the productivity of a random sample of 30 employees. The sample has an average productivity of 53 units per day and the population standard deviation is 4. The company wants to know if the new training program has significantly increased productivity.

### Example 2: Lays Wafer Packets Weight Verification

Suppose a snack food company claims that their Lays wafer packets contain an average weight of 50 grams per packet. To verify this claim, a consumer watchdog organization decides to test a random sample of Lays wafer packets. The organization wants to determine whether the actual average weight differs significantly from the claimed 50 grams. The organization collects a random sample of 40 Lays wafer packets and measures their weights. They find that the sample has an average weight of 49 grams, with a population standard deviation of 5 grams.

---

## T-tests Overview

A **t-test** is a statistical test used in hypothesis testing to compare the means of two samples or to compare a sample mean to a known population mean. The t-test is based on the t-distribution, which is used when the population standard deviation is unknown and the sample size is small.

### Three Main Types of t-tests:

1. **One-sample t-test**: Used to compare the mean of a single sample to a known population mean. The null hypothesis states that there is no significant difference between the sample mean and the population mean, while the alternative hypothesis states that there is a significant difference.

2. **Independent two-sample t-test**: Used to compare the means of two independent samples. The null hypothesis states that there is no significant difference between the means of the two samples, while the alternative hypothesis states that there is a significant difference.

3. **Paired t-test (dependent two-sample t-test)**: Used to compare the means of two samples that are dependent or paired, such as pre-test and post-test scores for the same group of subjects or measurements taken on the same subjects under two different conditions. The null hypothesis states that there is no significant difference between the means of the paired differences, while the alternative hypothesis states that there is a significant difference.

---

## Single Sample t-test

A one-sample t-test checks whether a sample mean differs from the population mean.

### Assumptions for a Single Sample t-test:

1. **Normality** - Population from which the sample is drawn is normally distributed
2. **Independence** - The observations in the sample must be independent, which means that the value of one observation should not influence the value of another observation
3. **Random Sampling** - The sample must be a random and representative subset of the population
4. **Unknown population std** - The population standard deviation is not known

### Example: Chocolate Bar Weight

Suppose a manufacturer claims that the average weight of their new chocolate bars is 50 grams. We highly doubt that and want to check this, so we drew out a sample of 25 chocolate bars and measured their weight. The sample mean came out to be 49.7 grams and the sample standard deviation was 1.2 grams. Consider the significance level to be 0.05.

---

## Independent Two-Sample t-test

An independent two-sample t-test, also known as an unpaired t-test, is a statistical method used to compare the means of two independent groups to determine if there is a significant difference between them.

### Assumptions for the Test:

1. **Independence of observations**: The two samples must be independent, meaning there is no relationship between the observations in one group and the observations in the other group. The subjects in the two groups should be selected randomly and independently.

2. **Normality**: The data in each of the two groups should be approximately normally distributed. The t-test is considered robust to mild violations of normality, especially when the sample sizes are large (typically n ≥ 30) and the sample sizes of the two groups are similar. If the data is highly skewed or has substantial outliers, consider using a non-parametric test, such as the Mann-Whitney U test.

3. **Equal variances (Homoscedasticity)**: The variances of the two populations should be approximately equal. This assumption can be checked using F-test for equality of variances. If this assumption is not met, you can use Welch's t-test, which does not require equal variances.

4. **Random sampling**: The data should be collected using a random sampling method from the respective populations. This ensures that the sample is representative of the population and reduces the risk of selection bias.

### Example: Website Usage Time

Suppose a website owner claims that there is no difference in the average time spent on their website between desktop and mobile users. To test this claim, we collect data from 30 desktop users and 30 mobile users regarding the time spent on the website in minutes.

**Desktop users**: [12, 15, 18, 16, 20, 17, 14, 22, 19, 21, 23, 18, 25, 17, 16, 24, 20, 19, 22, 18, 15, 14, 23, 16, 12, 21, 19, 17, 20, 14]

- Sample size (n1): 30
- Sample mean (mean1): 18.5 minutes
- Sample standard deviation (std_dev1): 3.5 minutes

**Mobile users**: [10, 12, 14, 13, 16, 15, 11, 17, 14, 16, 18, 14, 20, 15, 14, 19, 16, 15, 17, 14, 12, 11, 18, 15, 10, 16, 15, 13, 16, 11]

- Sample size (n2): 30
- Sample mean (mean2): 14.3 minutes
- Sample standard deviation (std_dev2): 2.7 minutes

We will use a significance level (α) of 0.05 for the hypothesis test.

---

## Paired Two-Sample t-test

A paired two-sample t-test, also known as a dependent or paired-samples t-test, is a statistical test used to compare the means of two related or dependent groups.

### Common Scenarios:

1. **Before-and-after studies**: Comparing the performance of a group before and after an intervention or treatment.
2. **Matched or correlated groups**: Comparing the performance of two groups that are matched or correlated in some way, such as siblings or pairs of individuals with similar characteristics.

### Assumptions:

1. **Paired observations**: The two sets of observations must be related or paired in some way, such as before-and-after measurements on the same subjects or observations from matched or correlated groups.

2. **Normality**: The differences between the paired observations should be approximately normally distributed. This assumption can be checked using graphical methods (e.g., histograms, Q-Q plots) or statistical tests for normality (e.g., Shapiro-Wilk test). Note that the t-test is generally robust to moderate violations of this assumption when the sample size is large.

3. **Independence of pairs**: Each pair of observations should be independent of other pairs. In other words, the outcome of one pair should not affect the outcome of another pair. This assumption is generally satisfied by appropriate study design and random sampling.

### Example: Weight Loss Program

Let's assume that a fitness center is evaluating the effectiveness of a new 8-week weight loss program. They enroll 15 participants in the program and measure their weights before and after the program. The goal is to test whether the new weight loss program leads to a significant reduction in the participants' weight.

**Before the program**: [80, 92, 75, 68, 85, 78, 73, 90, 70, 88, 76, 84, 82, 77, 91]
**After the program**: [78, 93, 81, 67, 88, 76, 74, 91, 69, 88, 77, 81, 80, 79, 88]
**Significance level (α)** = 0.05

---

## Python Code Examples

### 1. Calculating P-value from t-statistic

```python
from scipy.stats import t

# Set the t-value and degrees of freedom
t_value = -5.25
df = 58  # Replace this with your specific degrees of freedom

# Calculate the CDF value
cdf_value = t.cdf(t_value, df)
print(cdf_value * 2)
```

### 2. Shapiro-Wilk Test for Normality

```python
from scipy.stats import shapiro

# Input the data as lists
desktop_users = [12, 15, 18, 16, 20, 17, 14, 22, 19, 21, 23, 18, 25, 17, 16, 24, 20, 19, 22, 18, 15, 14, 23, 16, 12, 21, 19, 17, 20, 14]
mobile_users = [10, 12, 14, 13, 16, 15, 11, 17, 14, 16, 18, 14, 20, 15, 14, 19, 16, 15, 17, 14, 12, 11, 18, 15, 10, 16, 15, 13, 16, 11]

# Perform the Shapiro-Wilk test for both desktop and mobile users
shapiro_desktop = shapiro(desktop_users)
shapiro_mobile = shapiro(mobile_users)

print("Shapiro-Wilk test for desktop users:", shapiro_desktop)
print("Shapiro-Wilk test for mobile users:", shapiro_mobile)
```

**Note**: The Shapiro-Wilk test returns two values: the test statistic (W) and the p-value. If the p-value is greater than your chosen significance level (α = 0.05), you can assume the data comes from a normally distributed population. If the p-value is less than or equal to the significance level, the normality assumption is not met, and you should consider applying a data transformation or using a non-parametric test like the Mann-Whitney U test.

### 3. Levene's Test for Equal Variances

```python
from scipy.stats import levene

# Input the data as lists
desktop_users = [12, 15, 18, 16, 20, 17, 14, 22, 19, 21, 23, 18, 25, 17, 16, 24, 20, 19, 22, 18, 15, 14, 23, 16, 12, 21, 19, 17, 20, 14]
mobile_users = [10, 12, 14, 13, 16, 15, 11, 17, 14, 16, 18, 14, 20, 15, 14, 19, 16, 15, 17, 14, 12, 11, 18, 15, 10, 16, 15, 13, 16, 11]

# Perform Levene's test
levene_test = levene(desktop_users, mobile_users)
print(levene_test)
```

**Note**: If the p-value from Levene's test is greater than your chosen significance level (α = 0.05), you can assume equal variances. If the p-value is less than or equal to the significance level, the assumption of equal variances is not met, and you should consider using Welch's t-test instead of the regular independent two-sample t-test.

### 4. Paired t-test Analysis with Seaborn Visualization

```python
import numpy as np
import scipy.stats as stats
import seaborn as sns
import matplotlib.pyplot as plt

# Weight data
before = np.array([80, 92, 75, 68, 85, 78, 73, 90, 70, 88, 76, 84, 82, 77, 91])
after = np.array([78, 93, 81, 67, 88, 76, 74, 91, 69, 88, 77, 81, 80, 79, 88])

# Calculate differences
differences = after - before

# Create histogram using seaborn
plt.figure(figsize=(10, 6))
sns.histplot(differences, bins=10, kde=True, color='skyblue', alpha=0.7)
plt.title("Distribution of Weight Differences (After - Before)", fontsize=14, fontweight='bold')
plt.xlabel("Weight Differences (kg)", fontsize=12)
plt.ylabel("Frequency", fontsize=12)
plt.grid(True, alpha=0.3)
plt.show()

# Perform Shapiro-Wilk test for normality
shapiro_test = stats.shapiro(differences)
print("Shapiro-Wilk test:", shapiro_test)

# Calculate descriptive statistics
mean_diff = np.mean(differences)
std_diff = np.std(differences, ddof=1)
n = len(differences)

# Calculate t-statistic
t_statistic = mean_diff / (std_diff / np.sqrt(n))
df = n - 1

print(f"T-statistic: {t_statistic}")

# Calculate p-value (one-tailed test)
alpha = 0.05
p_value = stats.t.cdf(t_statistic, df)

print(f"P-value: {p_value}")
print(f"Degrees of freedom: {df}")
print(f"Mean difference: {mean_diff:.3f}")
print(f"Standard deviation of differences: {std_diff:.3f}")
```

### 5. Enhanced Visualization with Seaborn

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Create a comprehensive visualization
fig, axes = plt.subplots(2, 2, figsize=(15, 10))

# 1. Before vs After comparison
data_comparison = pd.DataFrame({
    'Weight': np.concatenate([before, after]),
    'Time': ['Before'] * len(before) + ['After'] * len(after)
})

sns.boxplot(data=data_comparison, x='Time', y='Weight', ax=axes[0, 0])
axes[0, 0].set_title('Weight Distribution: Before vs After')
axes[0, 0].grid(True, alpha=0.3)

# 2. Differences distribution with KDE
sns.histplot(differences, bins=8, kde=True, ax=axes[0, 1], color='coral', alpha=0.7)
axes[0, 1].set_title('Distribution of Weight Differences')
axes[0, 1].set_xlabel('Weight Difference (kg)')
axes[0, 1].grid(True, alpha=0.3)

# 3. Q-Q plot for normality check
stats.probplot(differences, dist="norm", plot=axes[1, 0])
axes[1, 0].set_title('Q-Q Plot for Normality Check')
axes[1, 0].grid(True, alpha=0.3)

# 4. Paired comparison plot
participant_ids = np.arange(1, len(before) + 1)
data_paired = pd.DataFrame({
    'Participant': np.tile(participant_ids, 2),
    'Weight': np.concatenate([before, after]),
    'Time': ['Before'] * len(before) + ['After'] * len(after)
})

for i in range(len(before)):
    axes[1, 1].plot([0, 1], [before[i], after[i]], 'o-', alpha=0.6, color='gray')

sns.stripplot(data=data_paired, x='Time', y='Weight', ax=axes[1, 1],
              size=8, alpha=0.8, jitter=0.1)
axes[1, 1].set_title('Individual Weight Changes')
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.show()
```

### 6. Complete Statistical Summary

```python
def paired_t_test_summary(before, after, alpha=0.05):
    """
    Complete paired t-test analysis with summary statistics
    """
    differences = after - before
    n = len(differences)
    mean_diff = np.mean(differences)
    std_diff = np.std(differences, ddof=1)
    se_diff = std_diff / np.sqrt(n)

    # t-statistic and degrees of freedom
    t_stat = mean_diff / se_diff
    df = n - 1

    # p-value (two-tailed)
    p_value = 2 * (1 - stats.t.cdf(abs(t_stat), df))

    # Confidence interval
    t_critical = stats.t.ppf(1 - alpha/2, df)
    ci_lower = mean_diff - t_critical * se_diff
    ci_upper = mean_diff + t_critical * se_diff

    # Effect size (Cohen's d)
    cohens_d = mean_diff / std_diff

    print("=== PAIRED T-TEST RESULTS ===")
    print(f"Sample size: {n}")
    print(f"Mean difference: {mean_diff:.4f}")
    print(f"Standard deviation of differences: {std_diff:.4f}")
    print(f"Standard error: {se_diff:.4f}")
    print(f"t-statistic: {t_stat:.4f}")
    print(f"Degrees of freedom: {df}")
    print(f"p-value (two-tailed): {p_value:.6f}")
    print(f"95% Confidence Interval: [{ci_lower:.4f}, {ci_upper:.4f}]")
    print(f"Cohen's d (effect size): {cohens_d:.4f}")

    if p_value < alpha:
        print(f"\nResult: Reject the null hypothesis (p < {alpha})")
        print("There is a statistically significant difference between before and after measurements.")
    else:
        print(f"\nResult: Fail to reject the null hypothesis (p >= {alpha})")
        print("There is no statistically significant difference between before and after measurements.")

    return {
        'mean_diff': mean_diff,
        'std_diff': std_diff,
        't_statistic': t_stat,
        'p_value': p_value,
        'confidence_interval': (ci_lower, ci_upper),
        'effect_size': cohens_d
    }

# Run the complete analysis
results = paired_t_test_summary(before, after)
```

---

## Chi-Square Distribution

The **Chi-Square distribution**, also written as χ² distribution, is a continuous probability distribution that is widely used in statistical hypothesis testing, particularly in the context of goodness-of-fit tests and tests for independence in contingency tables. It arises when the sum of the squares of independent standard normal random variables follows this distribution.

The Chi-Square distribution has a single parameter, the **degrees of freedom (df)**, which influences the shape and spread of the distribution. The degrees of freedom are typically associated with the number of independent variables or constraints in a statistical problem.

### Key Properties of the Chi-Square Distribution:

1. **Continuous distribution**: Defined for non-negative values only
2. **Positively skewed**: The degree of skewness decreases as the degrees of freedom increase
3. **Mean and Variance**:
   - Mean = degrees of freedom (df)
   - Variance = 2 × degrees of freedom (2df)
4. **Asymptotic normality**: As the degrees of freedom increase, the Chi-Square distribution approaches the normal distribution in shape

### Common Applications:

- Chi-Square goodness-of-fit test
- Chi-Square test for independence
- Confidence intervals for variance
- Model fitting assessments

---

## Chi-Square Goodness-of-Fit Test

The **Chi-Square Goodness-of-Fit test** is a statistical hypothesis test used to determine if the observed distribution of a single categorical variable matches an expected theoretical distribution. It helps evaluate whether the data follows a specific probability distribution, such as uniform, binomial, or Poisson distribution.

### Steps for Chi-Square Goodness-of-Fit Test:

1. **Define hypotheses**:

   - H₀: The observed data follows the expected theoretical distribution
   - H₁: The observed data does not follow the expected theoretical distribution

2. **Calculate expected frequencies** for each category based on the theoretical distribution and sample size

3. **Compute the Chi-Square test statistic**:

   ```
   χ² = Σ [(Oᵢ - Eᵢ)² / Eᵢ]
   ```

   where Oᵢ is the observed frequency and Eᵢ is the expected frequency in category i

4. **Determine degrees of freedom**: df = k - 1 (where k is the number of categories)

5. **Calculate p-value** using the Chi-Square distribution

6. **Compare** test statistic to critical value or p-value to significance level

### Assumptions:

1. **Independence**: Observations must be independent of each other
2. **Categorical data**: Variable must be categorical, not continuous or ordinal
3. **Expected frequency**: Each category should have an expected frequency of at least 5
4. **Fixed distribution**: The theoretical distribution should be specified before conducting the test

### Example 1: Fair Die Test

Testing if a six-sided die is fair by rolling it 60 times:

**Observed frequencies**:

- Side 1: 12 times
- Side 2: 8 times
- Side 3: 11 times
- Side 4: 9 times
- Side 5: 10 times
- Side 6: 10 times

**Expected frequency** for each side = 60/6 = 10 times

### Example 2: Website Visits Distribution

Testing if website visits are uniformly distributed across days of the week:

**Observed frequencies** (4 weeks of data):

- Monday: 420
- Tuesday: 380
- Wednesday: 410
- Thursday: 400
- Friday: 410
- Saturday: 430
- Sunday: 390

### Example 3: Gender Distribution in Families

Testing if male and female births are equally probable in families with 4 children each (800 families surveyed).

---

## Chi-Square Test for Independence

The **Chi-Square test for independence** (also known as the Chi-Square test for association) is used to determine whether there is a significant association between two categorical variables in a sample. It helps identify if the occurrence of one variable is dependent on the occurrence of another variable.

### Steps for Chi-Square Test for Independence:

1. **State hypotheses**:

   - H₀: There is no association between the two categorical variables (they are independent)
   - H₁: There is an association between the two categorical variables (they are dependent)

2. **Create a contingency table** with observed frequencies for each combination of categories

3. **Calculate expected frequencies** for each cell assuming independence:

   ```
   Expected frequency = (Row total × Column total) / Grand total
   ```

4. **Compute the Chi-Square test statistic**:

   ```
   χ² = Σ [(Oᵢⱼ - Eᵢⱼ)² / Eᵢⱼ]
   ```

5. **Determine degrees of freedom**: df = (rows - 1) × (columns - 1)

6. **Calculate p-value** and make decision

### Assumptions:

1. **Independence of observations**: Observations should be independent
2. **Categorical variables**: Both variables must be categorical (ordinal or nominal)
3. **Adequate sample size**: Expected frequency for each cell should be at least 5
4. **Fixed marginal totals**: Row and column sums should be fixed before data collection

### Example: Education Level vs Exercise Preference

Investigating association between education level and exercise preference among 150 individuals using a contingency table.

---

## Applications in Machine Learning

The Chi-Square test has several important applications in machine learning:

### 1. Feature Selection

- **Filter-based method**: Rank and select most relevant categorical features
- **Target association**: Measure association between categorical features and target variable
- **Redundancy reduction**: Eliminate irrelevant or redundant features

### 2. Classification Model Evaluation

- **Multi-class problems**: Compare observed vs expected class frequencies in confusion matrix
- **Goodness of fit**: Assess how well model predictions align with actual class distributions

### 3. Exploratory Data Analysis

- **Feature relationships**: Identify relationships between pairs of categorical features
- **Data structure insights**: Understand underlying patterns in categorical data

### 4. Variable Discretization

- **Continuous to categorical**: Determine optimal number of bins for continuous variables
- **Relationship preservation**: Maintain relationship between continuous variable and target

### 5. Decision Tree Construction

- **CHAID algorithm**: Chi-squared Automatic Interaction Detection
- **Splitting criteria**: Determine most significant splitting variables at each node
- **Tree optimization**: Construct more effective and interpretable decision trees

---

## Python Code Examples

### 1. Visualizing Chi-Square Distribution

```python
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Generate samples from standard normal distribution
np.random.seed(42)  # For reproducibility
sample1 = np.random.normal(loc=0, scale=1, size=100)
sample2 = np.random.normal(loc=0, scale=1, size=100)
sample3 = np.random.normal(loc=0, scale=1, size=100)
sample4 = np.random.normal(loc=0, scale=1, size=100)
sample5 = np.random.normal(loc=0, scale=1, size=100)

# Create Chi-Square distributions with different degrees of freedom
x = sample1**2                                    # df = 1
y = sample1**2 + sample2**2                      # df = 2
z = sample1**2 + sample2**2 + sample3**2         # df = 3
u = sample1**2 + sample2**2 + sample3**2 + sample4**2  # df = 4
v = sample1**2 + sample2**2 + sample3**2 + sample4**2 + sample5**2  # df = 5

# Create visualization
plt.figure(figsize=(12, 8))
sns.kdeplot(x, label='df=1', clip=(0, x.max()), linewidth=2)
sns.kdeplot(y, label='df=2', clip=(0, y.max()), linewidth=2)
sns.kdeplot(z, label='df=3', clip=(0, z.max()), linewidth=2)
sns.kdeplot(u, label='df=4', clip=(0, u.max()), linewidth=2)
sns.kdeplot(v, label='df=5', clip=(0, v.max()), linewidth=2)

plt.title('Chi-Square Distribution with Different Degrees of Freedom', fontsize=16, fontweight='bold')
plt.xlabel('Value', fontsize=12)
plt.ylabel('Density', fontsize=12)
plt.legend(title='Degrees of Freedom', fontsize=10)
plt.grid(True, alpha=0.3)
plt.xlim(0, 15)
plt.show()
```

### 2. Calculating P-value from Chi-Square Test Statistic

```python
import scipy.stats as stats

# Example calculation
test_statistic = 9.95  # Chi-Square test statistic
degrees_of_freedom = 4  # Degrees of freedom

# Calculate the p-value using the chi2 survival function (sf)
# sf(x) = 1 - cdf(x), which gives P(X > x)
p_value = stats.chi2.sf(test_statistic, degrees_of_freedom)

print(f"Test Statistic: {test_statistic}")
print(f"Degrees of Freedom: {degrees_of_freedom}")
print(f"P-value: {p_value:.6f}")

# Interpretation
alpha = 0.05
if p_value < alpha:
    print(f"\nResult: Reject H₀ (p-value < {alpha})")
    print("There is significant evidence against the null hypothesis.")
else:
    print(f"\nResult: Fail to reject H₀ (p-value ≥ {alpha})")
    print("There is insufficient evidence against the null hypothesis.")
```

### 3. Chi-Square Goodness-of-Fit Test: Titanic Dataset

```python
import pandas as pd
import numpy as np
from scipy.stats import chisquare
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Titanic dataset
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
data = pd.read_csv(url)

print("Dataset Overview:")
print(data.head())
print(f"\nDataset shape: {data.shape}")

# Analyze passenger class distribution
class_counts = data['Pclass'].value_counts().sort_index()
print(f"\nObserved Passenger Counts by Class:")
print(class_counts)

# Calculate expected counts assuming uniform distribution
total_passengers = len(data)
expected_counts = total_passengers / 3
expected = [expected_counts] * 3

print(f"\nExpected Passenger Counts (assuming uniform distribution):")
for i, exp in enumerate(expected, 1):
    print(f"Class {i}: {exp:.2f}")

# Perform the Chi-Square Goodness of Fit test
chi2, p_value = chisquare(class_counts, expected)

print(f"\n=== CHI-SQUARE GOODNESS-OF-FIT TEST RESULTS ===")
print(f"Chi-Square Statistic: {chi2:.4f}")
print(f"P-value: {p_value:.6f}")
print(f"Degrees of Freedom: {len(class_counts) - 1}")

# Interpret the results
alpha = 0.05
if p_value < alpha:
    print(f"\nConclusion: Reject H₀ (p-value < {alpha})")
    print("The distribution of passengers among classes is NOT uniform.")
else:
    print(f"\nConclusion: Fail to reject H₀ (p-value ≥ {alpha})")
    print("The distribution of passengers among classes is uniform.")

# Visualization
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# Observed vs Expected counts
classes = ['1st Class', '2nd Class', '3rd Class']
x_pos = np.arange(len(classes))

ax1.bar(x_pos - 0.2, class_counts, 0.4, label='Observed', color='skyblue', alpha=0.8)
ax1.bar(x_pos + 0.2, expected, 0.4, label='Expected (Uniform)', color='lightcoral', alpha=0.8)
ax1.set_xlabel('Passenger Class')
ax1.set_ylabel('Number of Passengers')
ax1.set_title('Observed vs Expected Passenger Distribution')
ax1.set_xticks(x_pos)
ax1.set_xticklabels(classes)
ax1.legend()
ax1.grid(True, alpha=0.3)

# Pie chart of observed distribution
ax2.pie(class_counts, labels=classes, autopct='%1.1f%%', startangle=90, colors=['lightblue', 'lightgreen', 'lightyellow'])
ax2.set_title('Actual Distribution of Passengers by Class')

plt.tight_layout()
plt.show()
```

### 4. Chi-Square Test for Independence: Survival vs Class

```python
import pandas as pd
import numpy as np
from scipy.stats import chi2_contingency
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Titanic dataset
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
data = pd.read_csv(url)

# Create contingency table
contingency_table = pd.crosstab(data['Survived'], data['Pclass'], margins=True)
print("Contingency Table (Survival vs Passenger Class):")
print(contingency_table)

# Remove margins for the test
test_table = pd.crosstab(data['Survived'], data['Pclass'])

# Perform the Chi-Square test for independence
chi2, p_value, dof, expected = chi2_contingency(test_table)

print(f"\n=== CHI-SQUARE TEST FOR INDEPENDENCE RESULTS ===")
print(f"Chi-Square Statistic: {chi2:.4f}")
print(f"P-value: {p_value:.6f}")
print(f"Degrees of Freedom: {dof}")
print(f"\nExpected Frequencies:")
expected_df = pd.DataFrame(expected,
                          index=['Did not survive', 'Survived'],
                          columns=['1st Class', '2nd Class', '3rd Class'])
print(expected_df.round(2))

# Interpret the results
alpha = 0.05
if p_value < alpha:
    print(f"\nConclusion: Reject H₀ (p-value < {alpha})")
    print("There IS a significant association between passenger class and survival rate.")
else:
    print(f"\nConclusion: Fail to reject H₀ (p-value ≥ {alpha})")
    print("There is NO significant association between passenger class and survival rate.")

# Calculate survival rates by class
survival_rates = data.groupby('Pclass')['Survived'].agg(['count', 'sum', 'mean'])
survival_rates.columns = ['Total', 'Survived', 'Survival_Rate']
print(f"\nSurvival Rates by Class:")
print(survival_rates)

# Visualizations
fig, axes = plt.subplots(2, 2, figsize=(15, 12))

# 1. Heatmap of observed frequencies
sns.heatmap(test_table, annot=True, fmt='d', cmap='Blues', ax=axes[0,0])
axes[0,0].set_title('Observed Frequencies: Survival vs Class')
axes[0,0].set_xlabel('Passenger Class')
axes[0,0].set_ylabel('Survived (0=No, 1=Yes)')

# 2. Heatmap of expected frequencies
sns.heatmap(expected_df, annot=True, fmt='.1f', cmap='Reds', ax=axes[0,1])
axes[0,1].set_title('Expected Frequencies (assuming independence)')
axes[0,1].set_xlabel('Passenger Class')
axes[0,1].set_ylabel('Survival Status')

# 3. Survival rates by class
survival_rates['Survival_Rate'].plot(kind='bar', ax=axes[1,0], color=['lightcoral', 'lightblue', 'lightgreen'])
axes[1,0].set_title('Survival Rate by Passenger Class')
axes[1,0].set_xlabel('Passenger Class')
axes[1,0].set_ylabel('Survival Rate')
axes[1,0].set_xticklabels(['1st Class', '2nd Class', '3rd Class'], rotation=45)
axes[1,0].grid(True, alpha=0.3)

# 4. Stacked bar chart
survival_data = data.groupby(['Pclass', 'Survived']).size().unstack()
survival_data.plot(kind='bar', stacked=True, ax=axes[1,1], color=['lightcoral', 'lightblue'])
axes[1,1].set_title('Survival Distribution by Class (Stacked)')
axes[1,1].set_xlabel('Passenger Class')
axes[1,1].set_ylabel('Number of Passengers')
axes[1,1].legend(['Did not survive', 'Survived'])
axes[1,1].set_xticklabels(['1st Class', '2nd Class', '3rd Class'], rotation=0)

plt.tight_layout()
plt.show()

# Additional analysis: Effect size (Cramér's V)
n = data.shape[0]
cramers_v = np.sqrt(chi2 / (n * (min(test_table.shape) - 1)))
print(f"\nEffect Size (Cramér's V): {cramers_v:.4f}")

if cramers_v < 0.1:
    effect_size = "negligible"
elif cramers_v < 0.3:
    effect_size = "small"
elif cramers_v < 0.5:
    effect_size = "medium"
else:
    effect_size = "large"

print(f"Effect size interpretation: {effect_size}")
```

### 5. Comprehensive Chi-Square Analysis Function

```python
def chi_square_analysis(data, var1, var2=None, test_type='independence', alpha=0.05, expected_dist=None):
    """
    Comprehensive Chi-Square analysis function

    Parameters:
    -----------
    data: pandas DataFrame
    var1: str, column name for first variable
    var2: str, column name for second variable (for independence test)
    test_type: str, 'independence' or 'goodness_of_fit'
    alpha: float, significance level
    expected_dist: list, expected distribution for goodness-of-fit test
    """

    if test_type == 'independence':
        if var2 is None:
            raise ValueError("var2 must be specified for independence test")

        # Create contingency table
        contingency_table = pd.crosstab(data[var1], data[var2])

        # Perform test
        chi2, p_value, dof, expected = chi2_contingency(contingency_table)

        print(f"=== CHI-SQUARE TEST FOR INDEPENDENCE ===")
        print(f"Variables: {var1} vs {var2}")
        print(f"Contingency Table:")
        print(contingency_table)
        print(f"\nExpected Frequencies:")
        print(pd.DataFrame(expected, index=contingency_table.index, columns=contingency_table.columns).round(2))

    elif test_type == 'goodness_of_fit':
        # Get observed frequencies
        observed = data[var1].value_counts().sort_index()

        if expected_dist is None:
            # Assume uniform distribution
            n_categories = len(observed)
            total_count = observed.sum()
            expected_dist = [total_count / n_categories] * n_categories

        # Perform test
        chi2, p_value = chisquare(observed, expected_dist)
        dof = len(observed) - 1

        print(f"=== CHI-SQUARE GOODNESS-OF-FIT TEST ===")
        print(f"Variable: {var1}")
        print(f"Observed frequencies: {observed.tolist()}")
        print(f"Expected frequencies: {expected_dist}")

    # Common results
    print(f"\nTest Results:")
    print(f"Chi-Square Statistic: {chi2:.4f}")
    print(f"P-value: {p_value:.6f}")
    print(f"Degrees of Freedom: {dof}")

    # Interpretation
    if p_value < alpha:
        print(f"\nConclusion: Reject H₀ (p-value < {alpha})")
        if test_type == 'independence':
            print("There IS a significant association between the variables.")
        else:
            print("The observed distribution does NOT follow the expected distribution.")
    else:
        print(f"\nConclusion: Fail to reject H₀ (p-value ≥ {alpha})")
        if test_type == 'independence':
            print("There is NO significant association between the variables.")
        else:
            print("The observed distribution follows the expected distribution.")

    return {
        'chi2_statistic': chi2,
        'p_value': p_value,
        'degrees_of_freedom': dof,
        'significant': p_value < alpha
    }

# Example usage
# For independence test
# result = chi_square_analysis(data, 'Survived', 'Pclass', test_type='independence')

# For goodness-of-fit test
# result = chi_square_analysis(data, 'Pclass', test_type='goodness_of_fit')
```

---

## Key Takeaways

1. **P-values** measure the strength of evidence against the null hypothesis
2. **T-tests** are used when population standard deviation is unknown
3. **Chi-Square tests** are essential for categorical data analysis
4. **Goodness-of-fit tests** evaluate if data follows a specific distribution
5. **Independence tests** assess relationships between categorical variables
6. **Assumptions must be checked** before applying any statistical test
7. **Visualization** helps in understanding data distribution and relationships
8. **Effect size** provides practical significance beyond statistical significance
9. **Machine learning applications** include feature selection and model evaluation

---

_This comprehensive guide covers hypothesis testing concepts from basic t-tests to advanced Chi-Square applications, with practical Python implementations using modern visualization techniques._
