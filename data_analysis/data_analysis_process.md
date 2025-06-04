# Data Analysis Process

## 1. Asking Questions

Data analysis begins by asking key questions to guide the process.  Important questions include:

* *What features will contribute to my analysis?*
* *What features are not important for my analysis?*
* *Which features have a strong correlation?*
* *Do I need data preprocessing?*
* *What kind of feature manipulation/engineering is required?*

These questions help focus the analysis. For example, Noor Fatima outlines similar guiding questions in her data analysis framework. Domain knowledge and experience also help in refining these questions into a concrete plan.

## 2. Data Wrangling/Munging

**Data wrangling** (or data munging) is the process of cleaning and preparing raw data for analysis.  It involves **transforming and mapping data** from a raw form into a usable format.  The goal is to ensure the data is accurate, complete, and properly structured so it can be analyzed effectively.  In practice, wrangling generally includes gathering, assessing, and cleaning the data. Data analysts often spend most of their time on these tasks.

### 2A: Gathering Data

Data can be gathered from various sources, such as:

* **CSV Files:** Pre-downloaded datasets or exports.
* **APIs:** Web APIs that provide data in JSON or XML.
* **Web Scraping:** Extracting data from websites.
* **Databases:** Querying SQL or NoSQL databases.

For example, Noor Fatima lists *CSV files, APIs, web scraping, and databases* as common data sources.  Gathering data may involve downloading files, calling API endpoints, or scraping HTML tables.

### 2B: Accessing Data

Once the data is collected, we examine its structure and basic properties. Key steps include:

1. **Shape:** Use `df.shape` to find the number of rows and columns (dataset size).
2. **Data types:** Call `df.info()` to see each column’s data type and check for unexpected types.
3. **Missing values:** Identify missing or null values (e.g. with `df.isnull().sum()`) to see which columns have gaps.
4. **Duplicates:** Check for duplicate rows (e.g. `df.duplicated().any()`) or verify if a column has unique values (`is_unique`).
5. **Memory usage:** Observe `df.info()` output (memory usage) to understand the dataset’s size.
6. **Summary statistics:** Use `df.describe()` to get basic statistics (mean, median, quartiles) for numeric columns.

These checks help assess data quality before deep analysis.  Fatima recommends these same checks (shape, types via `info()`, missing values, duplicates, memory, summary stats via `describe()`) as part of the data-access step.

### 2C: Cleaning Data

Cleaning fixes issues found in the data. Common tasks include:

* **Handling missing data:** Impute or remove missing values. For example, fill numeric gaps with the column mean or median (`df.fillna()`), or drop rows/columns if appropriate.
* **Removing duplicates:** Drop duplicate rows with `df.drop_duplicates()` to ensure each entry is unique.
* **Correcting data types:** Convert columns to proper types using `df.astype()`. For instance, change strings to dates (`pd.to_datetime`) or object to numeric types as needed.

Properly cleaning the data (filling missing values, removing extraneous entries, and ensuring correct types) lays the groundwork for reliable analysis.

## 3. Exploratory Data Analysis (EDA)

In the EDA phase, we explore the data’s patterns and relationships. This often involves two sub-steps: *exploring* and *augmenting* the data.

### 3A: Exploring Data

During exploration, we try to understand how features relate. Key activities include:

* **Correlation and covariance:** Compute correlation or covariance matrices to identify pairs of features that move together. This helps spot strong relationships or redundant variables.
* **Univariate analysis:** Examine each variable individually. For example, plot histograms or compute summary stats to understand distributions.
* **Multivariate analysis:** Study two or more variables together. For example, use scatterplots or pivot tables to explore how one feature depends on another.
* **Data visualization:** Plot graphs (scatter plots, bar charts, box plots, etc.) for visual insight into trends or anomalies. Visuals often reveal patterns (like skew or outliers) that raw numbers might not.

These steps are recommended by Fatima for EDA: specifically, correlation studies, univariate and multivariate analysis, and visualizing data.

### 3B: Augmenting Data

Augmenting (or feature engineering) improves the dataset by removing noise and adding useful information:

* **Removing irrelevant data:** Drop columns or outliers that do not contribute to the analysis or may skew results. For instance, filter out anomalous data points (outliers) that can distort trends.
* **Merging dataframes:** Combine multiple datasets or tables (e.g., via joins) to enrich the analysis. For example, merging user data with transaction data gives new features.
* **Adding new columns:** Create derived features from existing data. For example, compute ratios, bin continuous variables, or extract date parts. Fatima notes that adding new (derived) columns is a key part of feature engineering.

These steps help tailor the data for modeling. For example, outlier removal and merging external data can reveal clearer patterns, while new features can capture complex relationships.

## 4. Drawing Conclusions

Final conclusions come from applying statistical or machine learning methods to the prepared data. For instance:

* **Descriptive statistics:** Summarize outcomes (means, medians, survival rates, etc.) and look for notable differences between groups.
* **Inferential statistics:** Use hypothesis tests or confidence intervals to determine if observed effects (like group differences) are significant.
* **Machine learning:** Fit predictive models or classifiers to quantify patterns and make predictions.

These techniques allow us to answer our original questions with evidence.

**Example conclusions:** After analysis, one might conclude answers to the guiding questions. For example:

* **IPL (Rohit Sharma):** By comparing Rohit Sharma’s batting statistics in first vs. second innings (e.g. average runs, strike rate), we may find that one innings shows higher performance. For instance, if his average runs in the second innings is noticeably higher, we could conclude he is a stronger second-innings batsman.
* **Titanic (survival by gender):** Analysis of the Titanic dataset reveals a much higher survival rate for women (67.8%) than for men (32.2%). This indicates that being female significantly increased the chance of survival on the Titanic.
* **Zomato (expensive dining):** Analyzing a Zomato restaurant dataset shows that New Delhi contains both the cheapest and the most expensive restaurants in India. In other words, Delhi stands out for having some of the highest dining costs (as well as some very low ones).

These example conclusions use descriptive stats and domain analysis to answer the posed questions (consistent with drawing conclusions via statistics or ML models).

## 5. Communicating Results

Effective communication of results is crucial for stakeholder understanding and action. Results can be shared through:

* **Storytelling:** Craft a narrative around the data findings, highlighting key insights and their implications.
* **Reports:** Write detailed documents (PDF or web reports) that explain the methodology and findings step by step.
* **Blog posts:** Publish summaries or deep-dives on blogs (e.g. Medium), using visuals and explanations accessible to a broad audience.
* **Presentations (slide decks):** Present findings in meetings or talks using slides (PowerPoint, Google Slides), focusing on clear charts and takeaways.

In all cases, visualizations (plots, infographics) and clear tables help convey insights. For example, summarizing key dataset features in a table can orient readers. An example table of important features and their descriptions might look like:

| Feature    | Description                                       |
| ---------- | ------------------------------------------------- |
| `Survived` | Survival status of a passenger (0 = No, 1 = Yes). |
| `Pclass`   | Passenger class (1 = 1st, 2 = 2nd, 3 = 3rd).      |
| `Sex`      | Passenger gender (`male` or `female`).            |
| `Age`      | Passenger age in years.                           |
| `Fare`     | Ticket fare paid (in GBP).                        |

This kind of table helps non-technical readers understand what each variable means. Overall, combining clear visuals, concise narratives, and reference tables helps ensure the analysis results are effectively communicated.

**Sources:** Concepts summarized from data analysis guides and example analyses.