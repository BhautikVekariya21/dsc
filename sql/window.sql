-- ===============================
-- SQL WINDOW FUNCTIONS PRACTICE PROBLEMS
-- ===============================

-- ===============================
-- WHAT ARE WINDOW FUNCTIONS?
-- ===============================

-- Window functions in SQL are analytical functions that perform calculations
-- across a set of rows that are related to the current row, called a "window".
-- A window function calculates a value for each row in the result set based on 
-- a subset of the rows that are defined by a window specification.

-- The window specification is defined using the OVER() clause in SQL, which specifies
-- the partitioning and ordering of the rows that the window function will operate on.
-- The partitioning divides the rows into groups based on a specific column or expression,
-- while the ordering defines the order in which the rows are processed within each group.

-- ===============================
-- HOW TO LOAD THE DATASET(S) TO SQL?
-- ===============================

-- Using Python, you can load the datasets to MySQL database very easily.
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
-- PROBLEMS 1-5: STUDENT DATASET
-- ===============================

-- For problems 1 to 5, use the Student dataset.
-- Expected columns: student_id, name, branch, marks, age, city

-- SAMPLE DATA STRUCTURE:
-- student_id | name    | branch | marks | age | city
-- 1          | Alice   | CSE    | 85    | 20  | Delhi
-- 2          | Bob     | ECE    | 78    | 21  | Mumbai
-- 3          | Charlie | CSE    | 92    | 19  | Delhi

-- ===============================
-- PROBLEM 1: AGGREGATE FUNCTION WITH OVER()
-- ===============================

-- Find all the students who have marks higher than the average marks of their respective branch.

-- Answer:
SELECT *
FROM (
    SELECT *,
           AVG(marks) OVER (PARTITION BY branch) AS avg_branch_marks
    FROM students
) AS st
WHERE st.marks > st.avg_branch_marks;

-- ===============================
-- PROBLEM 2: BASIC WINDOW FUNCTION
-- ===============================

-- Display all students with their marks and the total number of students in their branch.

-- Answer:
SELECT *,
       COUNT(*) OVER(PARTITION BY branch) AS students_per_branch
FROM students;

-- ===============================
-- PROBLEM 3: PARTITION BY WITH ORDERING
-- ===============================

-- Display each student's marks along with the highest marks in their branch.

-- Answer:
SELECT *,
       marks,
       MAX(marks) OVER (PARTITION BY branch) AS max_per_branch
FROM students;

-- ===============================
-- PROBLEM 4: RUNNING TOTALS
-- ===============================

-- Calculate the running total of marks for each branch (ordered by student_id).

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       SUM(marks) OVER(
           PARTITION BY branch
           ORDER BY student_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_sum_branch_wise
FROM students;

-- ===============================
-- PROBLEM 5: PERCENTAGE CALCULATION
-- ===============================

-- Calculate what percentage each student's marks represent of their branch's total marks.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(marks * 100.0 / SUM(marks) OVER (PARTITION BY branch), 2) AS marks_percentage_in_branch
FROM students;

-- ===============================
-- PROBLEMS 6-12: RANKING FUNCTIONS
-- ===============================

-- For problems 6 to 12, use datasets with ranking scenarios.
-- Focus on ROW_NUMBER(), RANK(), and DENSE_RANK() functions.

-- ===============================
-- PROBLEM 6: ROW_NUMBER()
-- ===============================

-- Create a roll number for students based on their branch and marks (highest marks gets roll number 1).

-- Answer:
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY branch ORDER BY marks DESC) AS roll_number
FROM students;

-- ===============================
-- PROBLEM 7: RANK()
-- ===============================

-- Find the rank of each student within their branch based on marks (handle ties with gaps).

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       RANK() OVER (
           PARTITION BY branch 
           ORDER BY marks DESC
       ) AS rank_within_branch
FROM students;

-- ===============================
-- PROBLEM 8: DENSE_RANK()
-- ===============================

-- Find the dense rank of each student within their branch based on marks (handle ties without gaps).

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       DENSE_RANK() OVER(
           PARTITION BY branch
           ORDER BY marks DESC
       ) AS dense_rank_within_branch
FROM students;

-- ===============================
-- PROBLEM 9: TOP N RECORDS
-- ===============================

-- Find the top 2 students from each branch based on marks.

-- Answer:
SELECT * 
FROM (
    SELECT branch,
           student_id,
           name,
           marks,
           ROW_NUMBER() OVER(
               PARTITION BY branch
               ORDER BY marks DESC
           ) AS rank_within_branch
    FROM students 
) AS ranked_students
WHERE rank_within_branch <= 2;

-- ===============================
-- PROBLEM 10: BRANCH TOPPERS
-- ===============================

-- Find the branch toppers (students with the highest marks in each branch).

-- Answer:
SELECT * 
FROM (
    SELECT branch,
           student_id,
           name,
           marks,
           MAX(marks) OVER(
               PARTITION BY branch
           ) AS max_marks_in_branch
    FROM students 
) AS topper_students
WHERE marks = max_marks_in_branch;

-- ===============================
-- PROBLEM 11: BOTTOM PERFORMERS
-- ===============================

-- Find the last student (lowest marks) of each branch.

-- Answer:
SELECT *
FROM (
    SELECT branch,
           student_id,
           name,
           marks,
           MIN(marks) OVER (
               PARTITION BY branch
           ) AS lower_performer
    FROM students
) AS lower_students
WHERE marks = lower_performer;

-- ===============================
-- PROBLEM 12: SPECIFIC POSITIONS
-- ===============================

-- Find the 2nd last student and 5th topper of each branch.

-- Answer:
SELECT DISTINCT
    branch,
    NTH_VALUE(student_id, 2) OVER w AS second_lowest_student_id,
    NTH_VALUE(name, 2) OVER w AS second_lowest_name,
    NTH_VALUE(marks, 2) OVER w AS second_lowest_marks
FROM students
WINDOW w AS (
    PARTITION BY branch 
    ORDER BY marks ASC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);

SELECT DISTINCT
    branch,
    NTH_VALUE(student_id, 5) OVER w AS fifth_topper_student_id,
    NTH_VALUE(name, 5) OVER w AS fifth_topper_name,
    NTH_VALUE(marks, 5) OVER w AS fifth_topper_marks
FROM students
WINDOW w AS (
    PARTITION BY branch 
    ORDER BY marks DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);

-- ===============================
-- PROBLEMS 13-18: VALUE FUNCTIONS
-- ===============================

-- For problems 13 to 18, focus on FIRST_VALUE(), LAST_VALUE(), and NTH_VALUE() functions.

-- ===============================
-- PROBLEM 13: FIRST_VALUE()
-- ===============================

-- Display each student with the name of the topper in their branch.

-- Answer:
SELECT *,
       FIRST_VALUE(name) OVER(
           PARTITION BY branch
           ORDER BY marks DESC
       ) AS topper_in_branch
FROM students;

-- ===============================
-- PROBLEM 14: LAST_VALUE() WITH PROPER FRAME
-- ===============================

-- Display each student with the name of the lowest performer in their branch.

-- Answer:
SELECT *,
       FIRST_VALUE(name) OVER(
           PARTITION BY branch
           ORDER BY marks ASC
       ) AS lower_in_branch
FROM students;

-- ===============================
-- PROBLEM 15: NTH_VALUE()
-- ===============================

-- Display each student with the name of the 2nd topper in their branch.

-- Answer:
SELECT *,
       NTH_VALUE(name, 2) OVER (
           PARTITION BY branch
           ORDER BY marks DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS second_topper_in_branch
FROM students;

-- ===============================
-- PROBLEM 16: FIRST_VALUE() WITH ORDERING
-- ===============================

-- Show the earliest admitted student in each branch (based on student_id).

-- Answer:
SELECT *,
       FIRST_VALUE(name) OVER (
           PARTITION BY branch
           ORDER BY student_id ASC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS first_admission_in_branch
FROM students;

-- ===============================
-- PROBLEM 17: LAST_VALUE() WITH UNBOUNDED FOLLOWING
-- ===============================

-- Show the most recently admitted student in each branch.

-- Answer:
SELECT *,
       LAST_VALUE(name) OVER (
           PARTITION BY branch
           ORDER BY student_id ASC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS recent_admission_in_branch
FROM students;

-- ===============================
-- PROBLEM 18: NTH_VALUE() WITH NULL HANDLING
-- ===============================

-- Show the 3rd highest marks in each branch, display NULL if less than 3 students.

-- Answer:
SELECT DISTINCT
    branch,
    NTH_VALUE(marks, 3) OVER (
        PARTITION BY branch
        ORDER BY marks DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS third_highest_marks
FROM students;

-- ===============================
-- PROBLEMS 19-25: FRAME CLAUSE PRACTICE
-- ===============================

-- Understanding different frame specifications and their impact on calculations.

-- ===============================
-- PROBLEM 19: UNBOUNDED PRECEDING TO CURRENT ROW
-- ===============================

-- Calculate cumulative average marks for each student within their branch.
-- Frame: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- Answer:
SELECT *,
       ROUND(
           AVG(marks) OVER (
               PARTITION BY branch
               ORDER BY student_id
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ), 2
       ) AS cumulative_avg_marks
FROM students;

-- ===============================
-- PROBLEM 20: N PRECEDING TO N FOLLOWING
-- ===============================

-- Calculate moving average of marks considering 1 student before and 1 student after.
-- Frame: ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

-- Answer:
SELECT *,
       ROUND(
           AVG(marks) OVER (
               ORDER BY student_id
               ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
           ), 2
       ) AS moving_avg_marks
FROM students;

-- ===============================
-- PROBLEM 21: UNBOUNDED PRECEDING TO UNBOUNDED FOLLOWING
-- ===============================

-- Show each student's marks as a percentage of total branch marks.
-- Frame: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(marks * 100.0 / SUM(marks) OVER (
           PARTITION BY branch
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ), 2) AS marks_percentage_in_branch
FROM students;

-- ===============================
-- PROBLEM 22: CURRENT ROW TO N FOLLOWING
-- ===============================

-- Calculate sum of marks from current student to next 2 students in branch.
-- Frame: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       SUM(marks) OVER (
           PARTITION BY branch
           ORDER BY marks
           ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
       ) AS sum_of_marks_in_branch
FROM students;

-- ===============================
-- PROBLEM 23: N PRECEDING TO CURRENT ROW
-- ===============================

-- Calculate sum of marks from previous 2 students to current student.
-- Frame: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       SUM(marks) OVER (
           PARTITION BY branch
           ORDER BY student_id
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS sum_last_3_students
FROM students;

-- ===============================
-- PROBLEM 24: RANGE VS ROWS
-- ===============================

-- Compare ROWS and RANGE frame specifications for duplicate marks.
-- Show difference between ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
-- and RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING

-- Answer:
-- Assuming duplicate marks exist for testing difference
SELECT student_id,
       name,
       branch,
       marks,
       SUM(marks) OVER (
           ORDER BY marks 
           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ) AS sum_with_rows,
       SUM(marks) OVER (
           ORDER BY marks 
           RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ) AS sum_with_range
FROM students
ORDER BY marks;

-- ===============================
-- PROBLEM 25: CUSTOM FRAME WITH COMPLEX CALCULATION
-- ===============================

-- Calculate rolling minimum and maximum marks within a frame of 3 preceding to 1 following.
-- Frame: ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       MIN(marks) OVER (
           PARTITION BY branch
           ORDER BY student_id
           ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING
       ) AS rolling_min_marks,
       MAX(marks) OVER (
           PARTITION BY branch
           ORDER BY student_id
           ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING
       ) AS rolling_max_marks
FROM students;

-- ===============================
-- PROBLEMS 26-30: LEAD & LAG FUNCTIONS
-- ===============================

-- For problems 26 to 30, use datasets with time-series or sequential data.

-- ===============================
-- PROBLEM 26: BASIC LAG()
-- ===============================

-- Show each student's marks along with the previous student's marks in the same branch.

-- Answer:
SELECT *,
       LAG(marks) OVER (
           PARTITION BY branch
           ORDER BY student_id
       ) AS lag_marks
FROM students;

-- ===============================
-- PROBLEM 27: BASIC LEAD()
-- ===============================

-- Show each student's marks along with the next student's marks in the same branch.

-- Answer:
SELECT *,
       LEAD(marks) OVER (
           PARTITION BY branch
           ORDER BY student_id
       ) AS lag_marks
FROM students;

-- ===============================
-- PROBLEM 28: LAG() WITH OFFSET AND DEFAULT
-- ===============================

-- Show each student's marks with marks from 2 positions back, default to 0 if not available.

-- Answer:
SELECT *,
       LAG(marks, 2, 0) OVER (
           PARTITION BY branch
           ORDER BY student_id
       ) AS lag_marks_by2
FROM students;

-- ===============================
-- PROBLEM 29: LEAD() FOR COMPARISON
-- ===============================

-- Calculate the difference between current student's marks and next student's marks.

-- Answer:
SELECT *,
       marks - LEAD(marks, 1, 0) OVER (
           PARTITION BY branch
           ORDER BY student_id
       ) AS diff_in_lead
FROM students;

-- ===============================
-- PROBLEM 30: COMPLEX LEAD/LAG SCENARIO
-- ===============================

-- Find students whose marks are higher than both previous and next student in their branch.

-- Answer:
WITH ranked_students AS (
    SELECT student_id,
           name,
           branch,
           marks,
           LAG(marks) OVER (PARTITION BY branch ORDER BY student_id) AS prev_marks,
           LEAD(marks) OVER (PARTITION BY branch ORDER BY student_id) AS next_marks
    FROM students
)
SELECT *
FROM ranked_students
WHERE marks > COALESCE(prev_marks, -1)
  AND marks > COALESCE(next_marks, -1);

-- ===============================
-- PROBLEMS 31-35: CUMULATIVE CALCULATIONS
-- ===============================

-- For problems 31 to 35, focus on cumulative sum, cumulative average, and running calculations.

-- ===============================
-- PROBLEM 31: CUMULATIVE SUM
-- ===============================

-- Calculate the cumulative sum of marks for each branch (ordered by student_id).
-- Cumulative sum calculates the sum of values up to a given point in time, 
-- including all previous values in the calculation.

-- Answer:
SELECT *,
       SUM(marks) OVER (
           PARTITION BY branch 
           ORDER BY student_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_marks
FROM students;

-- ===============================
-- PROBLEM 32: CUMULATIVE AVERAGE
-- ===============================

-- Calculate the cumulative average of marks for each branch (ordered by student_id).
-- Cumulative average calculates the average of values up to a given point in time,
-- including all previous values in the calculation.

-- Answer:
SELECT *,
       ROUND(
           AVG(marks) OVER (
               PARTITION BY branch 
               ORDER BY student_id
               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
           ), 2
       ) AS cumulative_avg
FROM students;

-- ===============================
-- PROBLEM 33: RUNNING AVERAGE WITH FRAME
-- ===============================

-- Calculate a 3-period running average of marks within each branch.

-- Answer:
SELECT *,
       ROUND(
           AVG(marks) OVER (
               PARTITION BY branch 
               ORDER BY student_id
               ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
           ), 2
       ) AS running_avg_marks
FROM students;

-- ===============================
-- PROBLEM 34: CUMULATIVE COUNT
-- ===============================

-- Show the cumulative count of students in each branch (ordered by marks descending).

-- Answer:
SELECT *,
       COUNT(*) OVER (
           PARTITION BY branch 
           ORDER BY marks DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_count
FROM students;

-- ===============================
-- PROBLEM 35: RUNNING MIN/MAX
-- ===============================

-- Calculate running minimum and maximum marks within each branch.

-- Answer:
SELECT *,
       MIN(marks) OVER (
           PARTITION BY branch 
           ORDER BY student_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS min_marks,
       MAX(marks) OVER (
           PARTITION BY branch 
           ORDER BY student_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS max_marks
FROM students;

-- ===============================
-- PROBLEMS 36-40: PERCENTAGE CALCULATIONS
-- ===============================

-- For problems 36 to 40, focus on percentage calculations using window functions.

-- ===============================
-- PROBLEM 36: PERCENT OF TOTAL
-- ===============================

-- Calculate what percentage each student's marks represent of the total marks in their branch.
-- Percent of total refers to the percentage or proportion of a specific value 
-- in relation to the total value.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(
           marks * 100.0 / 
           SUM(marks) OVER (
               PARTITION BY branch
               ORDER BY marks
               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
           ), 2
       ) AS marks_percentage_in_branch
FROM students;

-- ===============================
-- PROBLEM 37: PERCENT CHANGE
-- ===============================

-- Calculate the percentage change in marks compared to the previous student in the same branch.
-- Percent change expresses the difference between two values as a percentage 
-- of the original value.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(
           100.0 * (marks - LAG(marks) OVER (PARTITION BY branch ORDER BY student_id)) 
           / NULLIF(LAG(marks) OVER (PARTITION BY branch ORDER BY student_id), 0), 2
       ) AS percent_change
FROM students;

-- ===============================
-- PROBLEM 38: PERCENT OF TOTAL (OVERALL)
-- ===============================

-- Calculate what percentage each student's marks represent of the total marks across all branches.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(
           marks * 100.0 / SUM(marks) OVER(), 2
       ) AS percent_contribution_total
FROM students;

-- ===============================
-- PROBLEM 39: CUMULATIVE PERCENTAGE
-- ===============================

-- Calculate the cumulative percentage of marks within each branch.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(
           marks * 100 / SUM(marks) OVER(
               PARTITION BY branch
               ORDER BY marks
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ), 2 
       ) AS cumpercentage
FROM students;

-- ===============================
-- PROBLEM 40: PERCENTAGE RANK
-- ===============================

-- Calculate the percentage rank of each student within their branch.

-- Answer:
WITH percent_data AS (
    SELECT student_id,
           name,
           branch,
           marks,
           ROUND(
               marks * 100.0 / SUM(marks) OVER (
                   PARTITION BY branch
                   ORDER BY marks
               ), 2
           ) AS percentage_by_branch
    FROM students
)
SELECT *,
       RANK() OVER (
           PARTITION BY branch
           ORDER BY percentage_by_branch
       ) AS percentage_rank_in_branch
FROM percent_data;

-- ===============================
-- PROBLEMS 41-46: PERCENTILES & QUANTILES
-- ===============================

-- For problems 41 to 46, use PERCENTILE_CONT, PERCENTILE_DISC, and related functions.

-- ===============================
-- PROBLEM 41: MEDIAN MARKS (ALL STUDENTS)
-- ===============================

-- Find the median marks of all students using PERCENTILE_CONT.
-- A Quantile divides data into equally sized intervals. The 50th percentile 
-- (median) represents the value below which 50% of the data falls.

-- Answer:
WITH ranked_students AS (
    SELECT marks,
           ROW_NUMBER() OVER (ORDER BY marks) AS rn,
           COUNT(*) OVER () AS total_count
    FROM students
)
SELECT ROUND(AVG(marks), 2) AS median_marks
FROM ranked_students
WHERE rn IN (
    FLOOR((total_count + 1) / 2),
    FLOOR((total_count + 2) / 2)
);

-- ===============================
-- PROBLEM 42: BRANCH-WISE MEDIAN
-- ===============================

-- Find branch-wise median of student marks using PERCENTILE_CONT.

-- Answer:
WITH ranked_students AS (
    SELECT branch,
           marks,
           ROW_NUMBER() OVER (PARTITION BY branch ORDER BY marks) AS rn,
           COUNT(*) OVER (PARTITION BY branch) AS total_count
    FROM students
)
SELECT branch,
       ROUND(AVG(marks), 2) AS median_marks
FROM ranked_students
WHERE rn IN (
    FLOOR((total_count + 1) / 2),
    FLOOR((total_count + 2) / 2)
)
GROUP BY branch;

-- ===============================
-- PROBLEM 43: PERCENTILE_CONT VS PERCENTILE_DISC
-- ===============================

-- Compare 75th percentile using both PERCENTILE_CONT and PERCENTILE_DISC for each branch.
-- Note: MySQL 8.0+ does not support PERCENTILE_CONT or PERCENTILE_DISC. 
-- Emulate PERCENTILE_CONT using ROW_NUMBER() with interpolation and PERCENTILE_DISC by selecting the nearest actual value.
-- PERCENTILE_CONT calculates continuous percentile (interpolated value).
-- PERCENTILE_DISC calculates discrete percentile (nearest actual data point).

-- Disclaimer: As of MySQL 8.4 (June 2025), PERCENTILE_CONT and PERCENTILE_DISC are not supported natively. 
-- These functions are available in other RDBMS like PostgreSQL, SQL Server, Oracle, and MariaDB (since 10.3.3).
-- The solution below emulates both functions using ROW_NUMBER() and COUNT(). For native support, 
-- consider using MariaDB or external tools like Python (pandas.quantile) for large datasets.

-- Answer:
WITH ranked AS (
    SELECT branch,
           marks,
           ROW_NUMBER() OVER (PARTITION BY branch ORDER BY marks) AS rn,
           COUNT(*) OVER (PARTITION BY branch) AS cnt
    FROM students
)
SELECT branch,
       marks AS percentile_75_disc
FROM ranked
WHERE rn = CEIL(cnt * 0.75);

-- ===============================
-- PROBLEM 44: QUARTILES
-- ===============================

-- Calculate Q1 (25th percentile), Q2 (50th percentile), and Q3 (75th percentile) for each branch.
-- Note: MySQL 8.0+ does not support native quartile functions like PERCENTILE_CONT or PERCENTILE_DISC.
-- Quartiles are emulated using ROW_NUMBER() and COUNT() to approximate the 25th, 50th, and 75th percentiles with interpolation.
-- Quartiles divide the dataset into four equal parts: Q1 (25%), Q2 (50%, median), Q3 (75%).

-- Disclaimer: As of MySQL 8.4 (June 2025), there are no built-in functions for directly calculating quartiles (e.g., PERCENTILE_CONT or PERCENTILE_DISC).
-- These are supported in other RDBMS like PostgreSQL, SQL Server, Oracle, and MariaDB (since 10.3.3).
-- The solution below emulates quartiles by calculating interpolated values for the 25th, 50th, and 75th percentiles.
-- For large datasets or native support, consider using MariaDB or external tools like Python (pandas.quantile).

-- Answer:
WITH RankedStudents AS (
    SELECT branch,
           marks,
           ROW_NUMBER() OVER (PARTITION BY branch ORDER BY marks) AS row_num,
           COUNT(*) OVER (PARTITION BY branch) AS total_rows
    FROM students
),
PercentileCalculation AS (
    SELECT branch,
           marks,
           row_num,
           total_rows,
           (row_num - 1) * 1.0 / (total_rows - 1) AS percentile
    FROM RankedStudents
)
SELECT branch,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.24 AND 0.26 OR percentile = 0.25 THEN marks END), 2) AS Q1,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.49 AND 0.51 OR percentile = 0.50 THEN marks END), 2) AS Q2,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.74 AND 0.76 OR percentile = 0.75 THEN marks END), 2) AS Q3
FROM PercentileCalculation
GROUP BY branch;

-- ===============================
-- PROBLEM 45: DECILES
-- ===============================

-- Divide students into 10 equal groups (deciles) based on marks within each branch.
-- Note: MySQL 8.0+ supports the NTILE() function, which is used to divide ordered data into a specified number of buckets.
-- Deciles split the data into 10 equal groups, where decile 1 represents the top 10% of marks and decile 10 the bottom 10%.
-- The solution uses NTILE(10) to assign each student a decile rank within their branch.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       NTILE(10) OVER (
           PARTITION BY branch
           ORDER BY marks ASC
       ) AS decile
FROM students;

-- ===============================
-- PROBLEM 46: CUSTOM PERCENTILES
-- ===============================

-- Calculate 10th, 30th, 70th, and 90th percentiles for marks in each branch.
-- Note: MySQL 8.0+ does not support PERCENTILE_CONT or PERCENTILE_DISC.
-- The solution emulates percentiles using ROW_NUMBER() and COUNT() with interpolation to approximate the 10th, 30th, 70th, and 90th percentiles.
-- Percentiles represent the value below which a given percentage of data falls (e.g., 10th percentile is the value below which 10% of marks lie).

-- Disclaimer: As of MySQL 8.4 (June 2025), PERCENTILE_CONT and PERCENTILE_DISC are not supported natively.
-- These functions are available in other RDBMS like PostgreSQL, SQL Server, Oracle, and MariaDB (since 10.3.3).
-- The solution below emulates custom percentiles by interpolating values around the target percentile positions.
-- For large datasets or native support, consider using MariaDB or external tools like Python (pandas.quantile).

-- Answer:
WITH rank_calculation AS (
    SELECT branch,
           marks,
           ROW_NUMBER() OVER (
               PARTITION BY branch 
               ORDER BY marks ASC
           ) AS row_num,
           COUNT(*) OVER (
               PARTITION BY branch
           ) AS row_per_branch
    FROM students
),
percentile_calculation AS (
    SELECT branch,
           marks,
           row_num,
           row_per_branch,
           (row_num - 1) * 1.0 / (row_per_branch - 1) AS percentile
    FROM rank_calculation
)
SELECT branch,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.09 AND 0.11 THEN marks END), 2) AS p10,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.29 AND 0.31 THEN marks END), 2) AS p30,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.69 AND 0.71 THEN marks END), 2) AS p70,
       ROUND(AVG(CASE WHEN percentile BETWEEN 0.89 AND 0.91 THEN marks END), 2) AS p90
FROM percentile_calculation
GROUP BY branch;

-- ===============================
-- PROBLEMS 47-50: SEGMENTATION & DISTRIBUTION
-- ===============================

-- For problems 47 to 50, focus on NTILE and CUME_DIST functions.

-- ===============================
-- PROBLEM 47: NTILE SEGMENTATION
-- ===============================

-- Divide students into 4 equal segments (quartiles) within each branch using NTILE.
-- Segmentation using NTILE divides a dataset into equal-sized groups based on criteria.

-- Answer:
SELECT 
    student_id,
    name,
    branch,
    marks,
    NTILE(4) OVER (
        PARTITION BY branch
        ORDER BY marks ASC
    ) AS quartile
FROM students;

-- ===============================
-- PROBLEM 48: NTILE WITH DIFFERENT SEGMENTS
-- ===============================

-- Create 5 equal segments of students based on marks across all branches.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       NTILE(4) OVER (ORDER BY student_id) AS pentile
FROM students;

-- ===============================
-- PROBLEM 49: CUMULATIVE DISTRIBUTION
-- ===============================

-- Calculate the cumulative distribution of marks within each branch using CUME_DIST.
-- CUME_DIST answers: "What percentage of rows have a value less than or equal to the current row?"
-- Note: MySQL 8.0+ supports CUME_DIST as a window function, which returns a value between 0 and 1 representing the proportion of rows with a value less than or equal to the current row's value within the partition.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       ROUND(CUME_DIST() OVER (PARTITION BY branch ORDER BY marks), 4) AS cumulative_distribution
FROM students;

-- ===============================
-- PROBLEM 50: COMBINED SEGMENTATION ANALYSIS
-- ===============================

-- Show students with their NTILE segment, CUME_DIST, and PERCENT_RANK within their branch.
-- Note: MySQL 8.0+ supports NTILE, CUME_DIST, and PERCENT_RANK as window functions.
-- NTILE(4) divides students into 4 equal segments (quartiles) based on marks.
-- CUME_DIST returns the proportion of rows with a value less than or equal to the current row's marks.
-- PERCENT_RANK returns the relative rank of each row within the partition as a value between 0 and 1.

-- Answer:
SELECT student_id,
       name,
       branch,
       marks,
       NTILE(4) OVER (PARTITION BY branch ORDER BY marks DESC) AS quartile,
       ROUND(CUME_DIST() OVER (PARTITION BY branch ORDER BY marks), 4) AS cumulative_distribution,
       ROUND(PERCENT_RANK() OVER (PARTITION BY branch ORDER BY marks), 4) AS percent_rank
FROM students;

-- ===============================
-- PROBLEMS 51-55: MULTIPLE PARTITION COLUMNS
-- ===============================

-- For problems 51 to 55, practice using multiple columns in PARTITION BY clause.

-- ===============================
-- PROBLEM 51: PARTITION BY MULTIPLE COLUMNS
-- ===============================

-- Rank students by marks within each combination of branch and city.

-- Answer:
SELECT student_id,
       name,
       branch,
       city,
       marks,
       RANK() OVER (PARTITION BY branch, city ORDER BY marks ASC) AS rank_in_branch_city
FROM students;

-- ===============================
-- PROBLEM 52: COMPLEX PARTITIONING
-- ===============================

-- Calculate average marks for students partitioned by branch and age group 
-- (age groups: <=20, >20).

-- Answer:
SELECT student_id,
       name,
       branch,
       age,
       marks,
       CASE 
           WHEN age <= 20 THEN 'Age <= 20'
           ELSE 'Age > 20'
       END AS age_group,
       ROUND(AVG(marks) OVER (PARTITION BY branch, 
                                         CASE 
                                             WHEN age <= 20 THEN 'Age <= 20'
                                             ELSE 'Age > 20'
                                         END), 2) AS avg_marks_by_branch_agegroup
FROM students
ORDER BY branch, age_group, student_id;

-- ===============================
-- PROBLEM 53: HIERARCHICAL RANKING
-- ===============================

-- Create a ranking system: first by branch, then by city within branch, 
-- then by marks within each city-branch combination.

-- Answer:
SELECT student_id,
       name,
       branch,
       city,
       marks,
       RANK() OVER (PARTITION BY branch, city ORDER BY marks DESC) AS rank_within_branch_city
FROM students
ORDER BY branch, city, rank_within_branch_city;

-- ===============================
-- PROBLEM 54: MULTIPLE PARTITION AGGREGATIONS
-- ===============================

-- Show total students and average marks for each branch-city combination.

-- Answer:
SELECT student_id,
       name,
       branch,
       city,
       marks,
       COUNT(*) OVER (PARTITION BY branch, city) AS total_students_in_branch_city,
       ROUND(AVG(marks) OVER (PARTITION BY branch, city), 2) AS avg_marks_in_branch_city
FROM students
ORDER BY branch, city;

-- ===============================
-- PROBLEM 55: COMPLEX MULTI-LEVEL ANALYSIS
-- ===============================

-- For each student, show:
-- 1. Their rank within their city
-- 2. Their rank within their branch  
-- 3. Their rank within their branch-city combination

-- Answer:

-- ===============================
-- PROBLEMS 56-60: SALES/REVENUE DATASET
-- ===============================

-- For problems 56 to 60, use a Sales/Revenue dataset.
-- Expected columns: month, year, revenue, customer_id, product_category

-- SAMPLE DATA STRUCTURE:
-- month | year | revenue | customer_id | product_category
-- 1     | 2023 | 10000  | C001        | Electronics
-- 2     | 2023 | 12000  | C001        | Electronics

-- ===============================
-- PROBLEM 56: MONTH-OVER-MONTH GROWTH
-- ===============================

-- Calculate the Month-over-Month (MoM) revenue growth percentage.

-- Answer:

-- ===============================
-- PROBLEM 57: TOP CUSTOMERS PER MONTH
-- ===============================

-- Find the top 2 most paying customers of each month.

-- Answer:

-- ===============================
-- PROBLEM 58: CUMULATIVE REVENUE
-- ===============================

-- Calculate cumulative revenue for each year.

-- Answer:

-- ===============================
-- PROBLEM 59: YEAR-OVER-YEAR COMPARISON
-- ===============================

-- Compare current month's revenue with the same month in the previous year.

-- Answer:

-- ===============================
-- PROBLEM 60: REVENUE RANKING BY CATEGORY
-- ===============================

-- Rank customers by revenue within each product category for each month.

-- Answer:

-- ===============================
-- PROBLEM 61: USING COALESCE WITH LAG
-- ===============================

-- Show each student's marks along with the previous student's marks in the same branch.
-- If the previous student's marks are NULL, display 0 as the default value.

-- Answer:

-- ===============================
-- PRACTICE NOTES:
-- ===============================

-- * Always specify proper ORDER BY clause in window functions for consistent results
-- * Use appropriate PARTITION BY to divide data into logical groups
-- * Be careful with LAST_VALUE() - often needs UNBOUNDED FOLLOWING in frame clause
-- * LEAD() and LAG() are useful for comparing consecutive rows
-- * Frame clauses (ROWS/RANGE) control which rows are included in calculations
-- * ROW_NUMBER() always gives unique numbers, RANK() creates gaps, DENSE_RANK() doesn't
-- * Test window functions with small datasets first to understand behavior

-- ===============================
-- COMMON WINDOW FUNCTION PATTERNS:
-- ===============================

-- 1. BASIC AGGREGATION PATTERN:
-- SELECT column_name,
--        aggregate_function(column) OVER (PARTITION BY partition_column)
-- FROM table_name;

-- 2. RANKING PATTERN:
-- SELECT column_name,
--        ranking_function() OVER (PARTITION BY partition_column ORDER BY order_column)
-- FROM table_name;

-- 3. VALUE FUNCTION PATTERN:
-- SELECT column_name,
--        value_function() OVER (PARTITION BY partition_column ORDER BY order_column frame_clause)
-- FROM table_name;

-- 4. LEAD/LAG PATTERN:
-- SELECT column_name,
--        LAG/LEAD(column, offset, default) OVER (PARTITION BY partition_column ORDER BY order_column)
-- FROM table_name;

-- ===============================
-- FRAME CLAUSE REFERENCE:
-- ===============================

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- -- From start of partition to current row

-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING  
-- -- From current row to end of partition

-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- -- Entire partition (all rows)

-- ROWS BETWEEN n PRECEDING AND m FOLLOWING
-- -- n rows before current row to m rows after current row

-- ROWS BETWEEN n PRECEDING AND CURRENT ROW
-- -- n rows before current row to current row

-- ROWS BETWEEN CURRENT ROW AND n FOLLOWING
-- -- Current row to n rows after current row

-- ===============================
-- WINDOW FUNCTION CATEGORIES:
-- ===============================

-- ANALYTICAL FUNCTIONS:
-- SUM(), AVG(), COUNT(), MIN(), MAX()
-- Used with OVER() clause for window-based calculations

-- RANKING FUNCTIONS:
-- ROW_NUMBER()    - Unique sequential numbers
-- RANK()          - Ranking with gaps for ties  
-- DENSE_RANK()    - Ranking without gaps for ties
-- PERCENT_RANK()  - Percentage ranking (0 to 1)
-- CUME_DIST()     - Cumulative distribution (0 to 1)

-- VALUE FUNCTIONS:
-- FIRST_VALUE()   - First value in window
-- LAST_VALUE()    - Last value in window  
-- NTH_VALUE()     - Nth value in window

-- OFFSET FUNCTIONS:
-- LAG()           - Previous row value
-- LEAD()          - Next row value

-- PERCENTILE FUNCTIONS:
-- PERCENTILE_CONT() - Continuous percentile (interpolated)
-- PERCENTILE_DISC() - Discrete percentile (actual data point)

-- DISTRIBUTION FUNCTIONS:
-- NTILE()         - Divide into N equal groups
-- CUME_DIST()     - Cumulative distribution percentage

-- ===============================
-- ADVANCED CONCEPTS & BEST PRACTICES
-- ===============================

-- FRAME TYPES:
-- ROWS    - Physical number of rows
-- RANGE   - Logical range of values (handles ties differently)

-- PERCENTILE DIFFERENCES:
-- PERCENTILE_CONT - Returns interpolated value (may not exist in data)
-- PERCENTILE_DISC - Returns actual value from dataset

-- EXAMPLE WITH DATA [1,2,3,4,4,5]:
-- PERCENTILE_CONT(0.5) might return 3.5 (interpolated)
-- PERCENTILE_DISC(0.5) would return 3 or 4 (actual values)

-- SEGMENTATION STRATEGIES:
-- NTILE(4) - Quartiles (4 equal groups)
-- NTILE(10) - Deciles (10 equal groups)  
-- NTILE(100) - Percentiles (100 equal groups)

-- CUMULATIVE CALCULATIONS:
-- Always use proper ordering for meaningful results
-- UNBOUNDED PRECEDING ensures calculation from start
-- CURRENT ROW includes current row in calculation

-- MULTIPLE PARTITIONS:
-- Use when analysis requires multiple grouping levels
-- Example: PARTITION BY branch, city for city-wise analysis within branches
-- Can create hierarchical analysis structures

-- PERFORMANCE CONSIDERATIONS:
-- 1. Proper indexing on PARTITION BY and ORDER BY columns
-- 2. Limit window frame size when possible
-- 3. Avoid unnecessary PARTITION BY columns
-- 4. Use appropriate data types for calculations
-- 5. Consider using CTEs for complex window function chains

-- COMMON PITFALLS:
-- 1. Forgetting ORDER BY in ranking functions
-- 2. Incorrect frame specification with LAST_VALUE()
-- 3. Not handling NULL values in LAG/LEAD functions
-- 4. Mixing ROWS and RANGE frame types incorrectly
-- 5. Using window functions in WHERE clause (use HAVING or subqueries)

-- RECOMMENDATIONS:
-- 1. Always test window functions with ORDER BY for predictable results
-- 2. Use meaningful PARTITION BY clauses to group related data
-- 3. Understand the difference between ROWS and RANGE frame types
-- 4. Be explicit with frame clauses when using FIRST_VALUE/LAST_VALUE
-- 5. Use appropriate NULL handling with LEAD/LAG functions
-- 6. Consider performance impact of window functions on large datasets
-- 7. Use CTEs or subqueries to break down complex window function logic
-- 8. Test percentile functions with edge cases (empty sets, single values)
-- 9. Validate NTILE results with uneven data distributions
-- 10. Document complex window function logic for future maintenance