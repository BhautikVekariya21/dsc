-- =====================================================
-- MySQL FLIGHTS CASE STUDY - PRACTICE QUESTIONS
-- Complete set of datetime-based queries for flights analysis
-- =====================================================

-- Initial data exploration
SELECT * FROM campusx.flights;

-- =====================================================
-- BASIC DATETIME QUERIES
-- =====================================================

-- 1. Find the month with most number of flights
-- Write your query here:




-- 2. Which weekday has most costly flights
-- Write your query here:




-- 3. Find number of IndiGo flights every month
-- Write your query here:




-- 4. Find list of all flights that depart between 10AM and 2PM from Delhi to Bangalore
-- Write your query here:




-- 5. Find the number of flights departing on weekends from Bangalore
-- Write your query here:




-- =====================================================
-- ADVANCED DATETIME CALCULATIONS
-- =====================================================

-- 6. Calculate the arrival time for all flights by adding the duration to the departure time
-- First, add a departure datetime column
-- Write your ALTER TABLE statement here:




-- Convert date_of_journey and dep_time to datetime format
-- Write your UPDATE statement here:




-- Add columns for duration in minutes and arrival datetime
-- Write your ALTER TABLE statement here:




-- Extract duration in minutes from duration string (format: "2h 30m")
-- Write your query to test duration conversion here:




-- Update duration_mins column with calculated minutes
-- Write your UPDATE statement here:




-- Calculate arrival time by adding duration to departure time
-- Write your UPDATE statement here:




-- Display the calculated arrival times
-- Write your SELECT statement here:




-- 7. Calculate the arrival date for all flights
-- Write your query here:




-- 8. Find the number of flights which travel on multiple dates
-- Write your query here:




-- 9. Calculate the average duration of flights between all city pairs (format: xh ym)
-- Write your query here:




-- 10. Find all flights which departed before midnight but arrived after midnight having only 0 stops
-- Write your query here:




-- =====================================================
-- GROUPING AND AGGREGATION QUERIES
-- =====================================================

-- 11. Find quarter-wise number of flights for each airline
-- Write your query here:




-- 12. Average time duration for flights that have 1 stop vs more than 1 stop
-- Use CTE (Common Table Expression) for categorization
-- Write your query here:




-- 13. Find all Air India flights in a given date range originating from Delhi
-- Date range: 1st Mar 2019 to 10th Mar 2019
-- Write your query here:




-- 14. Find the longest flight of each airline
-- Write your query here:




-- 15. Find all pairs of cities having average time duration > 3 hours
-- Write your query here:




-- =====================================================
-- ADVANCED ANALYSIS QUERIES
-- =====================================================

-- 16. Make a weekday vs time grid showing frequency of flights from Bangalore to Delhi
-- Time slots: 12AM-6AM, 6AM-12PM, 12PM-6PM, 6PM-12AM
-- Write your query here:




-- 17. Make a weekday vs time grid showing avg flight price from Bangalore to Delhi
-- Time slots: 12AM-6AM, 6AM-12PM, 12PM-6PM, 6PM-12AM
-- Write your query here:




-- =====================================================
-- ADDITIONAL PRACTICE QUESTIONS
-- =====================================================

-- 18. Find the busiest hour of the day for departures
-- Write your query here:




-- 19. Calculate the percentage of flights that arrive the next day
-- Write your query here:




-- 20. Find the airline with the most consistent flight duration (lowest standard deviation)
-- Write your query here:




-- 21. Identify peak travel months for each route
-- Write your query here:




-- 22. Find flights with unusual duration (outliers) - duration > average + 2*standard deviation
-- Write your query here:




-- 23. Calculate the average delay assuming flights should arrive exactly after duration from departure
-- Write your query here:




-- 24. Find the most popular departure time slots for business travelers (Mon-Fri, 6AM-10AM and 6PM-10PM)
-- Write your query here:




-- 25. Analyze seasonal patterns - compare summer (Apr-Jun) vs winter (Dec-Feb) flight patterns
-- Write your query here:




-- =====================================================
-- BONUS COMPLEX QUERIES
-- =====================================================

-- 26. Create a pivot table showing airline vs month flight count
-- Write your query here:




-- 27. Find routes where return flights (if any) have significantly different durations
-- Write your query here:




-- 28. Calculate the cumulative number of flights by date for trend analysis
-- Write your query here:




-- 29. Find the optimal departure time for each route based on minimum average price
-- Write your query here:




-- 30. Identify potential codeshare flights (same route, same time, different airlines)
-- Write your query here:




-- =====================================================
-- PERFORMANCE OPTIMIZATION QUERIES
-- =====================================================

-- Create appropriate indexes for better query performance
-- Write your CREATE INDEX statements here:




-- =====================================================
-- DATA VALIDATION QUERIES
-- =====================================================

-- Check for data quality issues
-- 31. Find flights with impossible durations (negative or > 24 hours)
-- Write your query here:




-- 32. Find flights with departure time after arrival time on the same date
-- Write your query here:




-- 33. Identify missing or NULL values in critical datetime columns
-- Write your query here:




-- =====================================================
-- NOTES AND BEST PRACTICES
-- =====================================================

/*
Key Points to Remember:

1. DateTime Conversion:
   - Use STR_TO_DATE() for converting string to datetime
   - Format: STR_TO_DATE(CONCAT(date_of_journey,' ',dep_time),'%Y-%m-%d %H:%i')

2. Duration Calculations:
   - Parse duration strings using SUBSTRING_INDEX() and REPLACE()
   - Convert to minutes for easier arithmetic
   - Use DATE_ADD() with INTERVAL for adding duration

3. Time Formatting:
   - Use TIME_FORMAT(SEC_TO_TIME(minutes*60),'%kh %im') for xh ym format
   - %k for hour (0-23), %i for minutes with leading zeros

4. Date Functions:
   - DAYNAME() for weekday names
   - MONTHNAME() for month names  
   - QUARTER() for quarters
   - DAYOFWEEK() for numeric day (1=Sunday)

5. Performance Tips:
   - Create indexes on datetime columns used in WHERE clauses
   - Use BETWEEN for date ranges instead of >= and <=
   - Avoid functions in WHERE clauses when possible

6. Common Patterns:
   - Use CASE statements for conditional aggregation
   - Use CTE for complex categorizations
   - Use HAVING for filtering grouped results
*/

-- =====================================================
-- END OF FLIGHTS CASE STUDY PRACTICE QUESTIONS
-- =====================================================