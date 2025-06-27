-- =====================================================
-- WINDOW FUNCTIONS PRACTICE PROBLEMS
-- =====================================================

-- Topics Covered:
-- # Ranking Functions
-- # Cumulative Sum -> sales data
-- # Cumulative Average
-- # Running Average
-- # Percent of total
-- # Percent Change -> stocks data
-- # Percentage change for a specific window -> stocks data
-- # Quantiles/Percentiles - percentile_disc
-- # PERCENTILE_CONT
-- # Segmentation
-- # Cumulative Distribution
-- # Partition By Multiple Columns

-- =====================================================
-- DATASET INFORMATION
-- =====================================================

-- DataSet 1: Northwind
-- URL: https://relational.fit.cvut.cz/dataset/Northwind
-- 
-- How to download the dataset:
-- To download the dataset you need to create connection in your mysql workbench
-- The datasets are publicly available directly from MariaDB database.
-- 
-- Open your favourite MariaDB client (MySQL Workbench)
-- Use following credentials:
--     hostname: relational.fit.cvut.cz
--     port: 3306
--     username: guest
--     password: relational
-- 
-- Drive link: https://drive.google.com/drive/folders/1FMi6g1KDHbn17ikJSi7bE9-THywlxhdu?usp=sharing

-- DataSet 2: Drug Performance Evaluation
-- URL: https://www.kaggle.com/datasets/thedevastator/drug-performance-evaluation?select=Drug_clean.csv
-- Use the *cleaned* csv file

-- =====================================================
-- NORTHWIND DATASET PROBLEMS (1-5)
-- =====================================================

-- Create and use the northwind database
CREATE DATABASE northwind;
USE northwind;

-- Display sample data from all tables
SELECT * FROM nw_order_details;
SELECT * FROM nw_employees;
SELECT * FROM nw_orders;
SELECT * FROM nw_products;
SELECT * FROM nw_suppliers;

-- =====================================================
-- Problem 1: Rank Employee in terms of revenue generation
-- Show employee id, first name, revenue, and rank
-- =====================================================

-- Step 1: Create CTE to calculate total revenue per employee
WITH order_and_employee AS (
    SELECT
        emp.EmployeeID,
        emp.FirstName,
        -- Calculate total revenue by multiplying quantity and unit price
        ROUND(SUM(odt.Quantity * odt.UnitPrice), 2) AS revenue
    FROM nw_orders odr
        JOIN nw_employees emp
            ON emp.EmployeeID = odr.EmployeeID
        JOIN nw_order_details odt
            ON odt.OrderID = odr.OrderID
    GROUP BY 
        emp.EmployeeID, 
        emp.FirstName
)

-- Step 2: Apply RANK() window function to rank employees by revenue
SELECT
    EmployeeID,
    FirstName,
    revenue,
    -- Rank employees by revenue in descending order
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM order_and_employee;

-- =====================================================
-- Problem 2: Show All products cumulative sum of units sold each month
-- =====================================================

-- Calculate monthly sales by product (base query without cumulative sum)
SELECT
    MONTHNAME(odr.OrderDate) AS MonthName,
    MONTH(odr.OrderDate) AS MonthNumber,
    odt.ProductID,
    -- Sum total units sold per product per month
    SUM(odt.Quantity) AS UnitsSold
FROM nw_order_details odt
    JOIN nw_orders odr
        ON odr.OrderID = odt.OrderID
GROUP BY
    MONTHNAME(odr.OrderDate),
    MONTH(odr.OrderDate),
    odt.ProductID;

-- =====================================================
-- Problem 3: Show Percentage of total revenue by each supplier
-- =====================================================

-- Step 1: Calculate total revenue per supplier
WITH revenue_by_supplier AS (
    SELECT 
        supp.SupplierID,
        supp.ContactName,
        -- Calculate total revenue for each supplier
        ROUND(SUM(odt.Quantity * odt.UnitPrice), 2) AS revenue
    FROM nw_products pd 
        JOIN nw_suppliers supp 
            ON pd.SupplierID = supp.SupplierID
        JOIN nw_order_details odt 
            ON odt.ProductID = pd.ProductID
        JOIN nw_orders odr 
            ON odr.OrderID = odt.OrderID
    GROUP BY 
        supp.SupplierID, 
        supp.ContactName
)

-- Step 2: Calculate percentage of total revenue using window function
SELECT 
    SupplierID,
    ContactName,
    revenue,
    -- Calculate percentage of total revenue using SUM() OVER()
    ROUND(revenue * 100.0 / SUM(revenue) OVER (), 2) AS revenue_percent
FROM revenue_by_supplier
ORDER BY revenue DESC;

-- =====================================================
-- Problem 4: Show Percentage of total orders by each supplier
-- =====================================================

-- Step 1: Count distinct orders per supplier
WITH total_orders_by_supplier AS (
    SELECT 
        supp.SupplierID,
        supp.ContactName,
        -- Count unique orders for each supplier
        COUNT(DISTINCT odr.OrderID) AS total_by_supplier
    FROM nw_products pd 
        JOIN nw_suppliers supp 
            ON pd.SupplierID = supp.SupplierID
        JOIN nw_order_details odt 
            ON odt.ProductID = pd.ProductID
        JOIN nw_orders odr 
            ON odr.OrderID = odt.OrderID
    GROUP BY 
        supp.SupplierID, 
        supp.ContactName
)

-- Step 2: Calculate percentage of total orders
SELECT 
    SupplierID,
    ContactName,
    total_by_supplier,
    -- Calculate percentage of total orders using window function
    ROUND(total_by_supplier * 100.0 / SUM(total_by_supplier) OVER (), 2) AS order_percent
FROM total_orders_by_supplier
ORDER BY order_percent DESC;

-- =====================================================
-- Problem 5: Show All Products Year Wise report of totalQuantity sold,
-- with percentage change from last year
-- =====================================================

-- Step 1: Aggregate sales data by product and year
WITH product_sales_yearly AS (
    SELECT
        pd.ProductID,
        pd.ProductName,
        YEAR(odr.OrderDate) AS OrderYear,
        -- Sum total quantity sold per product per year
        SUM(odt.Quantity) AS TotalQuantity
    FROM nw_products pd 
        JOIN nw_order_details odt 
            ON odt.ProductID = pd.ProductID
        JOIN nw_orders odr 
            ON odr.OrderID = odt.OrderID
    GROUP BY
        pd.ProductID,
        pd.ProductName,
        YEAR(odr.OrderDate)
)

-- Step 2: Calculate year-over-year percentage change using LAG()
SELECT
    ProductID,
    ProductName,
    OrderYear,
    TotalQuantity,
    -- Calculate percentage change from previous year using LAG() window function
    ROUND(
        (TotalQuantity - LAG(TotalQuantity) OVER (PARTITION BY ProductID ORDER BY OrderYear))
        * 100.0
        / NULLIF(LAG(TotalQuantity) OVER (PARTITION BY ProductID ORDER BY OrderYear), 0),
        2
    ) AS PercentageChange
FROM product_sales_yearly
ORDER BY 
    ProductID, 
    OrderYear;

-- =====================================================
-- DRUG DATASET PROBLEMS (6-15)
-- =====================================================

-- =====================================================
-- Problem 6: For each condition, what is the average satisfaction level 
-- of drugs that are "On Label" vs "Off Label"?
-- =====================================================

-- Calculate average satisfaction by condition and indication using window function
SELECT
    `Condition`,
    Indication,
    Form,
    ROUND(Satisfaction, 2) AS Satisfaction,
    -- Calculate average satisfaction partitioned by condition and indication
    ROUND(
        AVG(Satisfaction) OVER (PARTITION BY `Condition`, Indication),
        2
    ) AS AvgSatisfaction
FROM drug
ORDER BY
    `Condition`,
    Indication;

-- =====================================================
-- Problem 7: For each drug type (RX, OTC, RX/OTC), what is the average 
-- ease of use and satisfaction level of drugs with a price above the 
-- median for their type?
-- =====================================================

-- Step 1: Rank prices within each drug type to find median
WITH ranked_prices AS (
    SELECT 
        Type,
        Price,
        -- Row number for ascending price order
        ROW_NUMBER() OVER(PARTITION BY Type ORDER BY Price ASC) AS rnk_asc,
        -- Total count of records per type
        COUNT(*) OVER(PARTITION BY Type) AS cnt
    FROM drug
),

-- Step 2: Calculate median price for each drug type
median_prices AS (
    SELECT
        Type,
        -- Calculate median using average of middle values
        AVG(Price) AS median_price
    FROM ranked_prices
    WHERE rnk_asc IN (FLOOR((cnt + 1)/2), CEIL((cnt + 1)/2))
    GROUP BY Type
)

-- Step 3: Get average ease of use and satisfaction for drugs above median price
SELECT 
    d.Type,
    ROUND(AVG(d.EaseOfUse), 2) AS avg_ease_of_use,
    ROUND(AVG(d.Satisfaction), 2) AS avg_satisfaction
FROM drug d 
    JOIN median_prices md 
        ON md.Type = d.Type
WHERE d.Price > md.median_price
GROUP BY d.Type;

-- =====================================================
-- Problem 8: What is the cumulative distribution of EaseOfUse ratings 
-- for each drug type? Show results in descending order by drug type 
-- and cumulative distribution.
-- =====================================================

-- Built-in method using CUME_DIST() window function
SELECT 
    Type,
    EaseOfUse,
    -- Built-in cumulative distribution function
    ROUND(
        CUME_DIST() OVER (
            PARTITION BY Type
            ORDER BY EaseOfUse
        ),
        2
    ) AS cumulative_distribution
FROM drug
ORDER BY 
    Type DESC, 
    cumulative_distribution;

-- Manual method using COUNT() with window frame
SELECT 
    Type,
    EaseOfUse,
    -- Manual calculation of cumulative distribution
    ROUND(
        COUNT(*) OVER (
            PARTITION BY Type
            ORDER BY EaseOfUse
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 1.0
        / COUNT(*) OVER (PARTITION BY Type),
        2
    ) AS manual_cume_dist
FROM drug
ORDER BY 
    Type DESC, 
    manual_cume_dist;

-- =====================================================
-- Problem 9: What is the median satisfaction level for each medical condition? 
-- Show results in descending order by median satisfaction level.
-- =====================================================

-- Step 1: Rank satisfaction levels within each condition
WITH ranked AS (
    SELECT
        `Condition`,
        Satisfaction,
        -- Row number for ordered satisfaction levels
        ROW_NUMBER() OVER (
            PARTITION BY `Condition`
            ORDER BY Satisfaction
        ) AS rn,
        -- Total count per condition
        COUNT(*) OVER (PARTITION BY `Condition`) AS cnt
    FROM drug
),

-- Step 2: Calculate median satisfaction for each condition
medians AS (
    SELECT
        `Condition`,
        -- Calculate median: for odd count pick middle, for even count average two middle values
        AVG(Satisfaction) AS median_satisfaction
    FROM ranked
    WHERE
        -- Odd case: pick middle row
        (cnt % 2 = 1 AND rn = (cnt + 1) / 2)
        OR
        -- Even case: average two middle rows
        (cnt % 2 = 0 AND rn IN (cnt / 2, cnt / 2 + 1))
    GROUP BY `Condition`
)

-- Step 3: Display results ordered by median satisfaction
SELECT
    `Condition`,
    ROUND(median_satisfaction, 2) AS median_satisfaction
FROM medians
ORDER BY median_satisfaction DESC;

-- =====================================================
-- Problem 10: What is the running average of the price of drugs for each 
-- medical condition? Show results in ascending order by medical condition 
-- and drug name.
-- =====================================================

-- Calculate running average price using AVG() with window frame
SELECT
    `Condition`,
    Drug,
    ROUND(Price) AS Price,
    -- Running average from start of partition to current row
    ROUND(
        AVG(Price) OVER (
            PARTITION BY `Condition`
            ORDER BY Drug
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS RunningAvgPrice
FROM drug
ORDER BY
    `Condition` ASC,
    Drug ASC;

-- =====================================================
-- Problem 11: What is the percentage change in the number of reviews for 
-- each drug between the previous row and the current row?
-- =====================================================

-- Calculate percentage change using LAG() window function
SELECT
    Drug,
    ROUND(reviews) AS reviews,
    -- Calculate percentage change from previous row
    ROUND(
        (reviews - LAG(reviews) OVER (
            PARTITION BY Drug
            ORDER BY Drug
        ))
        / NULLIF(LAG(reviews) OVER (
            PARTITION BY Drug
            ORDER BY Drug
        ), 0) * 100,
        2
    ) AS percent_change
FROM drug
ORDER BY percent_change DESC;

-- =====================================================
-- Problem 12: What is the percentage of total satisfaction level for each 
-- drug type (RX, OTC, RX/OTC)?
-- =====================================================

-- Calculate percentage of total satisfaction within each drug type
SELECT
    Drug,
    Type,
    ROUND(Satisfaction, 2) AS Satisfaction,
    -- Calculate percentage of total satisfaction within drug type
    ROUND(
        Satisfaction * 100.0
        / SUM(Satisfaction) OVER (PARTITION BY Type),
        2
    ) AS satisfaction_percentage
FROM drug
ORDER BY 
    Type DESC, 
    satisfaction_percentage DESC;

-- =====================================================
-- Problem 13: What is the cumulative sum of effective ratings for each 
-- medical condition and drug form combination?
-- =====================================================

-- Calculate cumulative sum of effectiveness by condition and form
SELECT 
    `Condition`,
    Drug,
    Form,
    ROUND(effective, 2) AS effective,
    -- Cumulative sum partitioned by condition and form
    ROUND(SUM(effective) OVER(PARTITION BY `Condition`, Form), 3) AS cum_sum
FROM drug
ORDER BY 
    `Condition`,
    Form,
    Drug;

-- =====================================================
-- Problem 14: What is the rank of the average ease of use for each drug type 
-- (RX, OTC, RX/OTC)?
-- =====================================================

-- Calculate average ease of use by drug type and rank them
SELECT 
    Type,
    ROUND(AVG(EaseOfUse), 2) AS avg_easeofuse,
    -- Rank drug types by average ease of use
    RANK() OVER(ORDER BY AVG(EaseOfUse) DESC) AS ease_rank
FROM drug
GROUP BY Type
ORDER BY ease_rank;

-- =====================================================
-- Problem 15: For each condition, what is the average effectiveness of the 
-- top 3 most reviewed drugs?
-- =====================================================

-- Step 1: Rank drugs by number of reviews within each condition
WITH ranked_drugs AS (
    SELECT
        *,
        -- Rank drugs by review count within each condition
        RANK() OVER (
            PARTITION BY `condition`
            ORDER BY reviews DESC
        ) AS rnk
    FROM drug
)

-- Step 2: Calculate average effectiveness for top 3 drugs per condition
SELECT
    `condition`,
    ROUND(AVG(effective), 2) AS avg_of_effective_top3
FROM ranked_drugs
WHERE rnk <= 3  -- Only top 3 most reviewed drugs
GROUP BY `condition`
ORDER BY avg_of_effective_top3 DESC;

-- =====================================================
-- ADDITIONAL PRACTICE PROBLEMS
-- =====================================================

-- =====================================================
-- Additional Problem 1: Find the top 3 employees by revenue in each region
-- =====================================================

-- Step 1: Calculate revenue per employee per region
WITH employee_revenue AS (
    SELECT
        emp.EmployeeID,
        emp.FirstName,
        emp.LastName,
        odr.ShipRegion,
        -- Calculate total revenue per employee per region
        SUM(odt.UnitPrice * odt.Quantity) AS revenue
    FROM nw_employees emp
        JOIN nw_orders odr 
            ON emp.EmployeeID = odr.EmployeeID
        JOIN nw_order_details odt 
            ON odr.OrderID = odt.OrderID
    GROUP BY
        emp.EmployeeID,
        emp.FirstName,
        emp.LastName,
        odr.ShipRegion
)

-- Step 2: Rank employees within each region and select top 3
SELECT *
FROM (
    SELECT
        *,
        -- Rank employees by revenue within each region
        RANK() OVER (PARTITION BY ShipRegion ORDER BY revenue DESC) AS rk
    FROM employee_revenue
) ranked_employees
WHERE rk <= 3  -- Top 3 employees per region
ORDER BY 
    ShipRegion, 
    revenue DESC;

-- =====================================================
-- Additional Problem 2: Calculate the moving average of order amounts 
-- over the last 3 orders for each customer
-- =====================================================

-- Step 1: Calculate order amounts per order
WITH order_amounts AS (
    SELECT
        odr.OrderID,
        odr.CustomerID,
        odr.OrderDate,
        -- Calculate total amount per order
        SUM(odt.UnitPrice * odt.Quantity) AS OrderAmount
    FROM nw_orders odr
        JOIN nw_order_details odt 
            ON odr.OrderID = odt.OrderID
    GROUP BY
        odr.OrderID,
        odr.CustomerID,
        odr.OrderDate
)

-- Step 2: Calculate 3-order moving average
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    OrderAmount,
    -- Moving average over last 3 orders (including current)
    ROUND(
        AVG(OrderAmount) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS MovingAvgLast3
FROM order_amounts
ORDER BY 
    CustomerID, 
    OrderDate;

-- =====================================================
-- Additional Problem 3: Find the percentile rank of each product's unit price 
-- within its category
-- =====================================================

-- Calculate percentile rank of unit prices within categories
SELECT
    CategoryID,
    ProductID,
    ProductName,
    UnitPrice,
    -- Calculate percentile rank within category
    ROUND(
        PERCENT_RANK() OVER (
            PARTITION BY CategoryID
            ORDER BY UnitPrice
        ),
        2
    ) AS PercentileRank
FROM nw_products
ORDER BY 
    CategoryID, 
    PercentileRank;

-- =====================================================
-- Additional Problem 4: Calculate the year-over-year growth rate of sales 
-- for each product category
-- =====================================================

-- Step 1: Calculate yearly sales by category
WITH category_yearly_sales AS (
    SELECT
        p.CategoryID,
        YEAR(odr.OrderDate) AS OrderYear,
        -- Calculate total sales per category per year
        SUM(odt.UnitPrice * odt.Quantity) AS TotalSales
    FROM nw_products p
        JOIN nw_order_details odt 
            ON p.ProductID = odt.ProductID
        JOIN nw_orders odr 
            ON odr.OrderID = odt.OrderID
    GROUP BY
        p.CategoryID,
        YEAR(odr.OrderDate)
)

-- Step 2: Calculate year-over-year growth using LAG()
SELECT
    CategoryID,
    OrderYear,
    TotalSales,
    -- Calculate YoY growth percentage using LAG()
    ROUND(
        (TotalSales - LAG(TotalSales) OVER (PARTITION BY CategoryID ORDER BY OrderYear))
        * 100.0
        / NULLIF(LAG(TotalSales) OVER (PARTITION BY CategoryID ORDER BY OrderYear), 0),
        2
    ) AS YoYGrowthPercent
FROM category_yearly_sales
ORDER BY 
    CategoryID, 
    OrderYear;

-- =====================================================
-- Additional Problem 5: Find customers whose order frequency is in the 
-- top 25th percentile (top quartile)
-- =====================================================

-- Step 1: Count orders per customer
WITH customer_order_counts AS (
    SELECT
        CustomerID,
        -- Count total orders per customer
        COUNT(*) AS NumOrders
    FROM nw_orders
    GROUP BY CustomerID
),

-- Step 2: Divide customers into quartiles based on order frequency
ranked_orders AS (
    SELECT
        *,
        -- Divide into 4 quartiles (NTILE(4))
        NTILE(4) OVER (ORDER BY NumOrders DESC) AS quartile
    FROM customer_order_counts
)

-- Step 3: Select customers in top quartile (quartile 1)
SELECT *
FROM ranked_orders
WHERE quartile = 1  -- Top 25th percentile
ORDER BY NumOrders DESC;

-- =====================================================
-- WINDOW FUNCTION REFERENCE GUIDE
-- =====================================================

/*
COMMON WINDOW FUNCTIONS:

1. RANKING FUNCTIONS:
   - ROW_NUMBER(): Assigns unique sequential integers (1,2,3,4...)
   - RANK(): Assigns rank with gaps for ties (1,2,2,4...)
   - DENSE_RANK(): Assigns rank without gaps for ties (1,2,2,3...)
   - PERCENT_RANK(): Percentage rank (0 to 1)
   - CUME_DIST(): Cumulative distribution (0 to 1)
   - NTILE(n): Divides rows into n roughly equal groups

2. AGGREGATE FUNCTIONS AS WINDOW FUNCTIONS:
   - SUM() OVER(): Running/cumulative sum
   - AVG() OVER(): Running/cumulative average
   - COUNT() OVER(): Running count
   - MIN() OVER(): Running minimum
   - MAX() OVER(): Running maximum

3. VALUE FUNCTIONS:
   - LAG(column, offset): Access previous row value
   - LEAD(column, offset): Access next row value
   - FIRST_VALUE(): First value in window
   - LAST_VALUE(): Last value in window
   - NTH_VALUE(column, n): Nth value in window

4. STATISTICAL FUNCTIONS:
   - PERCENTILE_CONT(): Continuous percentile (interpolated)
   - PERCENTILE_DISC(): Discrete percentile (actual value)
   - STDDEV(): Standard deviation
   - VARIANCE(): Variance

WINDOW FRAME SYNTAX:
ROWS BETWEEN frame_start AND frame_end
RANGE BETWEEN frame_start AND frame_end

Frame boundaries:
- UNBOUNDED PRECEDING: Start of partition
- N PRECEDING: N rows before current row
- CURRENT ROW: Current row
- N FOLLOWING: N rows after current row
- UNBOUNDED FOLLOWING: End of partition

PARTITION BY: Divides result set into partitions (groups)
ORDER BY: Defines order within partition for calculations

SYNTAX EXAMPLES:
- ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC)
- SUM(sales) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
- LAG(price, 1) OVER (PARTITION BY product ORDER BY date)
- PERCENT_RANK() OVER (ORDER BY salary)
- AVG(amount) OVER (PARTITION BY customer ORDER BY date 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
*/

-- =====================================================
-- NOTES FOR PROBLEM SOLVING
-- =====================================================

/*
Tips for solving window function problems:

1. IDENTIFY THE WINDOW FUNCTION TYPE:
   - Ranking: ROW_NUMBER, RANK, DENSE_RANK for ordering/ranking
   - Cumulative: SUM, AVG with OVER clause for running totals
   - Comparison: LAG, LEAD for previous/next row comparisons
   - Statistical: PERCENTILE functions for distribution analysis

2. DETERMINE THE PARTITION:
   - What groups should calculations be done within?
   - Use PARTITION BY to group data (similar to GROUP BY)
   - Example: PARTITION BY customer_id, product_category

3. DETERMINE THE ORDERING:
   - What order should rows be processed in?
   - Use ORDER BY within OVER clause
   - Example: ORDER BY date, ORDER BY sales DESC

4. FRAME SPECIFICATION (when needed):
   - Do you need all rows in partition or a subset?
   - Use ROWS/RANGE BETWEEN for custom window frames
   - Example: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW

5. COMMON PATTERNS:
   - Running totals: SUM(amount) OVER (ORDER BY date)
   - Percentage of total: value / SUM(value) OVER() * 100
   - Previous value comparison: LAG(value) OVER (ORDER BY date)
   - Top N per group: ROW_NUMBER() OVER (PARTITION BY group ORDER BY value)
   - Moving averages: AVG(value) OVER (ORDER BY date ROWS BETWEEN n PRECEDING AND CURRENT ROW)

6. PERFORMANCE TIPS:
   - Window functions are processed after WHERE clause
   - Use appropriate indexes on PARTITION BY and ORDER BY columns
   - Consider using CTEs for complex multi-step window function queries
*/

-- =====================================================
-- END OF WINDOW FUNCTIONS PRACTICE
-- =====================================================