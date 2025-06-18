-- File: logical_sql_execution_order.sql
-- Purpose: Illustrate logical query execution order in SQL

-- --------------------------------------------------------
-- ✅ Logical Query Execution Order in SQL
-- --------------------------------------------------------
-- 1. FROM        -- Identify the source table(s)
-- 2. ON          -- Apply join conditions (if any)
-- 3. JOIN        -- Combine rows from multiple tables
-- 4. WHERE       -- Filter rows before grouping
-- 5. GROUP BY    -- Group the filtered rows
-- 6. HAVING      -- Filter groups after aggregation
-- 7. SELECT      -- Pick columns to include in result
-- 8. DISTINCT    -- Remove duplicates (if specified)
-- 9. ORDER BY    -- Sort the result set
-- 10. LIMIT/OFFSET -- Restrict number of rows returned

-- --------------------------------------------------------

-- --------------------------------------------------------

-- File: sleep_efficiency_questions.sql
-- Purpose: Analysis based on the Sleep Efficiency Dataset
-- Dataset Source: https://www.kaggle.com/datasets/equilibriumm/sleep-efficiency

-- --------------------------------------------------------
-- Column Descriptions:
-- id                    -- Unique identifier for each test subject
-- age                   -- Age of the test subject
-- gender                -- Gender of the test subject
-- bedtime               -- Time subject goes to bed
-- wakeup_time           -- Time subject wakes up
-- sleep_duration        -- Total hours slept
-- sleep_efficiency      -- % of time in bed actually asleep
-- rem_sleep_percentage  -- % of sleep time spent in REM sleep
-- deep_sleep_percentage -- % of sleep time spent in deep sleep
-- light_sleep_percentage-- % of sleep time spent in light sleep
-- awakenings            -- Number of awakenings during the night
-- caffeine_consumption  -- mg of caffeine consumed in last 24 hrs
-- alcohol_consumption   -- oz of alcohol consumed in last 24 hrs
-- smoking_status        -- 1 = smoker, 0 = non-smoker
-- exercise_frequency    -- Number of exercise sessions per week
-- --------------------------------------------------------

-- STEP 1: Create database if not exists
CREATE DATABASE IF NOT EXISTS sleep_efficiency;

-- STEP 2: Use the created database
USE sleep_efficiency;

-- View entire table
SELECT * FROM sleep_efficiency;

-- --------------------------------------------------------
-- ✅ Problem 1:
-- Find out the average sleep duration of top 15 male candidates 
-- whose sleep duration is equal to 7.5 or greater than 7.5.
-- Hint: Use WHERE + ORDER BY + LIMIT + AVG
-- --------------------------------------------------------
SELECT AVG(sleep_duration) AS avg_sleep_duration
FROM (
    SELECT sleep_duration
    FROM sleep_efficiency
    WHERE sleep_duration >= 7.5 AND gender = 'Male'
    ORDER BY sleep_duration DESC
    LIMIT 15
) AS top_15_males;

-- --------------------------------------------------------
-- ✅ Problem 2:
-- Show average deep sleep time for both genders.
-- Round result at 2 decimal places.
-- Note: deep_sleep_time = (sleep_duration * deep_sleep_percentage) / 100
-- --------------------------------------------------------
SELECT 
    gender, 
    ROUND(AVG((sleep_duration * deep_sleep_percentage) / 100), 2) AS avg_deep_sleep_time
FROM sleep_efficiency
GROUP BY gender;

-- --------------------------------------------------------
-- ✅ Problem 3:
-- Find the 10th to 30th lowest light sleep percentage records
-- where deep sleep percentage is between 25 and 45.
-- Show only: age, light_sleep_percentage, deep_sleep_percentage
-- --------------------------------------------------------
SELECT 
    age, 
    light_sleep_percentage, 
    deep_sleep_percentage
FROM sleep_efficiency
WHERE deep_sleep_percentage BETWEEN 25 AND 45
ORDER BY light_sleep_percentage ASC
LIMIT 10, 20;

-- --------------------------------------------------------
-- ✅ Problem 4:
-- Group by exercise_frequency and smoking_status.
-- Show average deep sleep time, average light sleep time, 
-- and average REM sleep time.
-- Note: Calculate sleep times using their percentage and sleep_duration.
-- --------------------------------------------------------
SELECT 
    exercise_frequency,
    smoking_status,
    ROUND(AVG((deep_sleep_percentage * sleep_duration) / 100), 2) AS avg_deep_sleep_time,
    ROUND(AVG((light_sleep_percentage * sleep_duration) / 100), 2) AS avg_light_sleep_time,
    ROUND(AVG((rem_sleep_percentage * sleep_duration) / 100), 2) AS avg_rem_sleep_time
FROM sleep_efficiency
GROUP BY exercise_frequency, smoking_status;

-- --------------------------------------------------------
-- ✅ Problem 5:
-- Group by awakenings and show:
-- AVG caffeine consumption,
-- AVG deep sleep time,
-- AVG alcohol consumption
-- Only for people who exercise at least 3 days a week.
-- Order by awakenings DESC.
-- --------------------------------------------------------
SELECT 
    awakenings,
    ROUND(AVG(caffeine_consumption), 2) AS avg_caffeine_consumption,
    ROUND(AVG((deep_sleep_percentage * sleep_duration) / 100), 2) AS avg_deep_sleep_time,
    ROUND(AVG(alcohol_consumption), 2) AS avg_alcohol_consumption
FROM sleep_efficiency
WHERE exercise_frequency >= 3
GROUP BY awakenings
ORDER BY awakenings DESC;

-- Purpose: Solve Problem 6 from Power Generation Dataset
-- Dataset Source: https://www.kaggle.com/datasets/arvindnagaonkar/power-generation-data

-- --------------------------------------------------------
-- Problem 6:
-- Display those power stations which have:
-- - Average 'Monitored Cap.(MW)' between 1000 and 2000 (inclusive),
-- - Count (number of occurrences) of the power station > 200.
-- Also, display the average and count, and sort results in ascending order.
-- --------------------------------------------------------

SELECT 
    `Power Station`,                                           
    ROUND(AVG(`Monitored Cap.(MW)`), 2) AS monitored_capacity, 
    COUNT(*) AS occurrences                                    
FROM power
WHERE `Monitored Cap.(MW)` BETWEEN 1000 AND 2000
GROUP BY `Power Station`
HAVING COUNT(*) > 200
ORDER BY `Power Station` ASC;

-- File: college_and_shipping_analysis.sql
-- Purpose: Analysis for education cost & logistics data
-- Dataset Sources:
-- - Avg Cost of Undergrad College by State: https://www.kaggle.com/datasets/kfoster150/avg-cost-of-undergrad-college-by-state
-- - Discount & Shipment Dataset: [dataset link missing for Problem 10]

-- --------------------------------------------------
-- PROBLEM 7:
-- Display top 10 states with lowest average value 
-- where:
-- - Year IN (2013, 2017, 2021)
-- - Type = 'Public In-State'
-- - Number of occurrences BETWEEN 6 and 10
-- --------------------------------------------------
SELECT 
    State, 
    ROUND(AVG(Value), 2) AS avg_value, 
    COUNT(*) AS occurences
FROM education_cost 
WHERE 
    Year IN (2013, 2017, 2021) 
    AND Type = 'Public In-State' 
GROUP BY State 
HAVING COUNT(*) BETWEEN 6 AND 10 
ORDER BY avg_value ASC
LIMIT 10;


-- --------------------------------------------------
-- PROBLEM 8:
-- Best state in terms of low education cost (Tuition Fees only)
-- for Public type universities (including In-State and Out-of-State)
-- --------------------------------------------------
SELECT 
    State, 
    ROUND(AVG(value), 2) AS avg_min_tuition_cost
FROM education_cost
WHERE 
    Expense = 'Fees/Tuition'
    AND Type IN ('Public In-State', 'Public Out-of-State')
GROUP BY state
ORDER BY avg_tuition_cost ASC
LIMIT 1;


-- --------------------------------------------------
-- PROBLEM 9:
-- 2nd costliest state for Private education in year 2021.
-- Consider both Tuition and Room expenses.
-- --------------------------------------------------
SELECT 
    state, 
    ROUND(AVG(value), 2) AS avg_max_tuition_cost
FROM education_cost
WHERE 
    expense IN ('Fees/Tuition', 'Room/Board')
    AND type = 'Private'
    AND year = 2021
GROUP BY state
ORDER BY avg_max_tuition_cost DESC 
LIMIT 1 OFFSET 1;

-- --------------------------------------------------
-- PROBLEM 10:
-- Display total and average Discount_offered for all combinations of:
-- - Mode_of_Shipment
-- - Warehouse_block
-- Where:
-- - Gender = 'M'
-- - Product_importance = 'High'
-- Sort by:
-- - Mode_of_Shipment DESC
-- - Warehouse_block ASC
-- --------------------------------------------------
SELECT
    mode_of_shipment,
    warehouse_block,
    COUNT(*) AS total,
    ROUND(AVG(discount_offered), 2) AS avg_discount_offered
FROM shipping_ecommerce
WHERE
    gender = 'M' 
    AND product_importance = 'high'
GROUP BY
    mode_of_shipment,
    warehouse_block
ORDER BY
    mode_of_shipment DESC,
    warehouse_block ASC;
