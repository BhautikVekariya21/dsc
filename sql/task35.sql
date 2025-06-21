-- ===============================
-- SQL SUBQUERY PRACTICE PROBLEMS
-- ===============================

-- ===============================
-- HOW TO LOAD THE DATASET(S) TO SQL?
-- ===============================

-- Using Python, you can load the large datasets to MySQL database very easily.
-- For that follow the below steps:

-- First create a database in your local machine server:
-- CREATE DATABASE <database_name>;

-- Next, use Python to load the database:
/*
import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv("file/path/to/the/database.csv")

engine = create_engine("mysql+pymysql://<db_username>:<db_password>@<hostname>/<database_name>")
df.to_sql("<table_name>", con=engine)
*/

-- ===============================
-- PROBLEMS 1-6: OLYMPIC DATASET
-- ===============================

-- For problems 1 to 6, use the Olympic dataset.
-- You can get that from: https://drive.google.com/file/d/1EGIRBkbQGByJPvCqDtxtTnXv93oGunFp/view?usp=share_link

-- COLUMN DESCRIPTION:
-- 1.  ID       -> ID of every records to our dataset. It has integer datatype.
-- 2.  Name     -> Name of the athletes.
-- 3.  Sex      -> Gender of the athletes.
-- 4.  Height   -> Height of the athletes
-- 5.  Weight   -> Weight of the athletes
-- 6.  NOC      -> In which country, the athletes belong to. This is actually the country code.
-- 7.  Year     -> In which year, the athlete has participated
-- 8.  Sport    -> What is the sport name in which the athlete participated.
-- 9.  Event    -> Event name of the sport
-- 10. Medal    -> Which medal the athlete got. If the athlete did not get any medal then this cell is blank.
-- 11. country  -> The name of the country.

-- ===============================
-- PROBLEM 1
-- ===============================

-- Display the names of athletes who won a gold medal in the 2008 Olympics 
-- and whose height is greater than the average height of all athletes in the 2008 Olympics.

-- Answer:
SELECT DISTINCT name
FROM olympic 
WHERE name IN (
    SELECT name  
    FROM olympic 
    WHERE year = 2008 
      AND medal = 'Gold'
)
  AND height > (
    SELECT AVG(height)
    FROM olympic
    WHERE year = 2008
);

-- ===============================
-- PROBLEM 2
-- ===============================

-- Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics 
-- and whose weight is less than the average weight of all athletes who won a medal in the 2016 Olympics.

-- Answer:
SELECT DISTINCT name
FROM olympic
WHERE sport = 'Basketball'
  AND year = 2016
  AND medal IN ('Gold', 'Silver', 'Bronze')
  AND weight < (
      SELECT AVG(weight)
      FROM olympic
      WHERE year = 2016
        AND medal IN ('Gold', 'Silver', 'Bronze')
  );

-- ===============================
-- PROBLEM 3
-- ===============================

-- Display the names of all athletes who have won a medal in the sport of swimming 
-- in both the 2008 and 2016 Olympics.

-- Answer:
SELECT DISTINCT name 
FROM olympic 
WHERE sport = 'Swimming'
  AND medal IN ('Gold', 'Silver', 'Bronze')
  AND name IN (
    SELECT name
    FROM olympic
    WHERE sport = 'Swimming'
      AND medal IN ('Gold', 'Silver', 'Bronze')
      AND year = 2008
  )
  AND name IN (
    SELECT name
    FROM olympic
    WHERE sport = 'Swimming'
      AND medal IN ('Gold', 'Silver', 'Bronze')
      AND year = 2016
  );

-- ===============================
-- PROBLEM 4
-- ===============================

-- Display the names of all countries that have won more than 50 medals in a single year.

-- Answer:
WITH winning_team AS (
    SELECT team, year
    FROM olympic
    WHERE medal IN ('Gold', 'Silver', 'Bronze')
)
SELECT team, year
FROM winning_team
GROUP BY team, year
HAVING COUNT(*) > 50
ORDER BY year;

-- ===============================
-- PROBLEM 5
-- ===============================

-- Display the names of all athletes who have won medals in more than one sport in the same year.

-- Answer:
SELECT DISTINCT name
FROM olympic
WHERE medal IN ('Gold', 'Silver', 'Bronze')
  AND name IN (
      SELECT name
      FROM olympic
      WHERE medal IN ('Gold', 'Silver', 'Bronze')
      GROUP BY name, year
      HAVING COUNT(DISTINCT sport) > 1
  );

-- ===============================
-- PROBLEM 6
-- ===============================

-- What is the average weight difference between male and female athletes in the Olympics 
-- who have won a medal in the same event?

-- Answer:
SELECT 
    event,
    ROUND(male_avg - female_avg, 2) AS avg_weight_difference
FROM (
    SELECT 
        event,
        AVG(CASE WHEN sex = 'M' THEN weight ELSE NULL END) AS male_avg,
        AVG(CASE WHEN sex = 'F' THEN weight ELSE NULL END) AS female_avg
    FROM olympic
    WHERE medal IN ('Gold', 'Silver', 'Bronze') 
      AND weight IS NOT NULL
    GROUP BY event
    HAVING COUNT(DISTINCT sex) = 2  -- Ensures both male and female participated
) AS gender_weights;

-- ===============================
-- PROBLEMS 7-10: MEDICAL INSURANCE DATASET
-- ===============================

-- For problems 7 to 10, use the Medical Insurance dataset.
-- Expected columns: age, sex, bmi, children, smoker, region, charges

-- ===============================
-- PROBLEM 7
-- ===============================

-- How many patients have claimed more than the average claim amount for patients 
-- who are smokers and have at least one child, and belong to the southeast region?

-- Answer:
SELECT 
    COUNT(*) AS total_patients
FROM insurance_data
WHERE smoker = 'Yes' 
  AND children >= 1 
  AND region = 'southeast'
  AND charges > (
      SELECT AVG(charges)
      FROM insurance_data
      WHERE smoker = 'Yes' 
        AND children >= 1 
        AND region = 'southeast'
  );

-- ===============================
-- PROBLEM 8
-- ===============================

-- How many patients have claimed more than the average claim amount for patients 
-- who are not smokers and have a BMI greater than the average BMI for patients who have at least one child?

-- Answer:
SELECT 
    COUNT(*) AS total_patients
FROM insurance_data
WHERE smoker = 'No' 
  AND bmi > (
      SELECT AVG(bmi)
      FROM insurance_data
      WHERE children >= 1
  )
  AND charges > (
      SELECT AVG(charges)
      FROM insurance_data
      WHERE smoker = 'No'
  );

-- ===============================
-- PROBLEM 9
-- ===============================

-- How many patients have claimed more than the average claim amount for patients 
-- who have a BMI greater than the average BMI for patients who are diabetic, 
-- have at least one child, and are from the southwest region?

-- Note: This problem assumes there's a 'diabetic' column in the dataset.
-- If not available, you may need to define diabetic criteria based on other columns.

-- Answer:
SELECT 
    COUNT(*) AS total_patients
FROM insurance_data
WHERE bmi > (
      SELECT AVG(bmi)
      FROM insurance_data
      WHERE diabetic = 'Yes' 
        AND children >= 1
        AND region = 'southwest'
  )
  AND charges > (
      SELECT AVG(charges)
      FROM insurance_data
  );

-- ===============================
-- PROBLEM 10
-- ===============================

-- What is the difference in the average claim amount between patients who are smokers 
-- and patients who are non-smokers, and have the same BMI and number of children?

-- Answer:
SELECT 
    ROUND(ABS(AVG(smoker_avg - non_smoker_avg)), 2) AS avg_claim_difference
FROM (
    SELECT
        bmi,
        children,
        AVG(CASE WHEN smoker = 'Yes' THEN charges ELSE NULL END) AS smoker_avg,
        AVG(CASE WHEN smoker = 'No' THEN charges ELSE NULL END) AS non_smoker_avg
    FROM insurance_data
    GROUP BY bmi, children
    HAVING smoker_avg IS NOT NULL AND non_smoker_avg IS NOT NULL
) AS filtered_comparison;

-- ===============================
-- PRACTICE NOTES:
-- ===============================

-- * Remember to handle NULL values appropriately in your subqueries
-- * Use appropriate aggregate functions (COUNT, AVG, SUM, etc.) based on the problem requirements
-- * Pay attention to filtering conditions in both outer and inner queries
-- * Consider using EXISTS/NOT EXISTS for complex existence checks
-- * Test your subqueries independently before combining them
-- * Use proper table aliases to avoid ambiguity
-- * Consider performance implications of correlated vs independent subqueries

-- ===============================
-- COMMON SUBQUERY PATTERNS:
-- ===============================

-- 1. SCALAR SUBQUERY PATTERN:
-- SELECT column_name 
-- FROM table_name 
-- WHERE column_name OPERATOR (
--     SELECT aggregate_function(column_name) 
--     FROM table_name 
--     WHERE condition
-- );

-- 2. ROW SUBQUERY PATTERN:
-- SELECT column_name 
-- FROM table_name 
-- WHERE column_name IN (
--     SELECT column_name 
--     FROM table_name 
--     WHERE condition
-- );

-- 3. CORRELATED SUBQUERY PATTERN:
-- SELECT column_name 
-- FROM table_name t1 
-- WHERE column_name OPERATOR (
--     SELECT aggregate_function(column_name) 
--     FROM table_name t2 
--     WHERE t2.column = t1.column
-- );

-- 4. EXISTS PATTERN:
-- SELECT column_name 
-- FROM table_name t1 
-- WHERE EXISTS (
--     SELECT 1 
--     FROM table_name t2 
--     WHERE t2.column = t1.column 
--       AND condition
-- );

-- ===============================
-- SQL ALIASING BEST PRACTICES
-- ===============================

-- CORRECT ALIASING (no quotes):
-- SELECT column_name AS alias_name
-- SELECT column_name alias_name  -- AS keyword is optional

-- INCORRECT ALIASING:
-- SELECT column_name AS 'alias_name'  -- Wrong: This creates a string literal

-- SPECIAL CHARACTERS OR SPACES IN ALIASES:
-- MySQL:      SELECT name AS `user name`
-- PostgreSQL: SELECT name AS "user name"  
-- SQL Server: SELECT name AS [user name]

-- TABLE ALIASES:
-- SELECT o.name FROM orders o
-- SELECT o.name FROM orders AS o  -- Both are correct

-- TESTING ALIAS BEHAVIOR:
-- SELECT 'hello' AS test;     -- Creates column named 'test'
-- SELECT 'hello' 'test';      -- Creates string literal (avoid this)

-- ===============================
-- DATABASE-SPECIFIC ALIAS SYNTAX
-- ===============================

-- | DATABASE    | COLUMN ALIAS WITH SPACES    | TABLE ALIAS |
-- |-------------|----------------------------|-------------|
-- | MySQL       | `alias name` or "alias"    | table_alias |
-- | PostgreSQL  | "alias name"               | table_alias |
-- | SQL Server  | [alias name]               | table_alias |
-- | Oracle      | "alias name"               | table_alias |
-- | SQLite      | "alias name" or 'alias'    | table_alias |

-- RECOMMENDATIONS:
-- 1. Use snake_case for aliases without special characters
-- 2. Avoid spaces in aliases when possible for better portability
-- 3. Be consistent with your aliasing style throughout your project
-- 4. Always test aliases in your specific database system