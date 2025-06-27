-- =====================================================
-- MySQL DateTime Reference Guide
-- Complete guide for temporal data types and functions
-- =====================================================

-- =====================================================
-- TEMPORAL DATA TYPES
-- =====================================================

-- DATE: Stores date values in YYYY-MM-DD format
-- Range: '1000-01-01' to '9999-12-31'
CREATE TABLE date_example (
    id INT PRIMARY KEY,
    birth_date DATE,
    hire_date DATE
);

-- TIME: Stores time values in HH:MM:SS format
-- Range: '-838:59:59' to '838:59:59'
CREATE TABLE time_example (
    id INT PRIMARY KEY,
    start_time TIME,
    end_time TIME
);

-- DATETIME: Stores date and time values in YYYY-MM-DD HH:MM:SS format
-- Range: '1000-01-01 00:00:00' to '9999-12-31 23:59:59'
-- Storage: 8 bytes
-- Precision: Up to microseconds (6 digits after decimal)
CREATE TABLE datetime_example (
    id INT PRIMARY KEY,
    created_datetime DATETIME,
    updated_datetime DATETIME(6) -- With microsecond precision
);

-- TIMESTAMP: Stores date and time values in YYYY-MM-DD HH:MM:SS format
-- Range: '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC
-- Storage: 4 bytes
-- Precision: Up to seconds only
-- Auto-converts between time zones (local to UTC)
CREATE TABLE timestamp_example (
    id INT PRIMARY KEY,
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- YEAR: Stores year values in 2-digit or 4-digit format
-- 2-digit range: 70-69 (represents 1970-2069)
-- 4-digit range: 1901-2155
CREATE TABLE year_example (
    id INT PRIMARY KEY,
    birth_year YEAR(4),
    graduation_year YEAR
);

-- =====================================================
-- SAMPLE TABLES FOR DEMONSTRATIONS
-- =====================================================

-- Uber rides table example
CREATE TABLE uber_rides (
    ride_id INT PRIMARY KEY,
    user_id INT,
    cab_id INT,
    start_time DATETIME,
    end_time DATETIME
);

-- Flights table for case study examples
CREATE TABLE flights (
    flight_id INT PRIMARY KEY,
    airline VARCHAR(50),
    departure_city VARCHAR(50),
    arrival_city VARCHAR(50),
    departure_time DATETIME,
    arrival_time DATETIME,
    duration TIME,
    distance_km INT,
    stops INT,
    price DECIMAL(10,2)
);

-- =====================================================
-- CURRENT DATE/TIME FUNCTIONS
-- =====================================================

-- Get current date (YYYY-MM-DD)
SELECT CURDATE() AS current_date;
SELECT CURRENT_DATE() AS current_date_alt;

-- Get current time (HH:MM:SS)
SELECT CURTIME() AS current_time;
SELECT CURRENT_TIME() AS current_time_alt;

-- Get current date and time (YYYY-MM-DD HH:MM:SS)
SELECT NOW() AS current_datetime;
SELECT CURRENT_TIMESTAMP() AS current_timestamp;

-- =====================================================
-- DATE/TIME EXTRACTION FUNCTIONS
-- =====================================================

-- Extract date and time components
SELECT 
    DATE(NOW()) AS date_part,           -- Extract date from datetime
    TIME(NOW()) AS time_part,           -- Extract time from datetime
    YEAR(NOW()) AS year_part,           -- Extract year
    MONTH(NOW()) AS month_part,         -- Extract month (1-12)
    MONTHNAME(NOW()) AS month_name,     -- Extract month name
    DAY(NOW()) AS day_part,             -- Extract day of month
    DAYOFMONTH(NOW()) AS day_of_month,  -- Same as DAY()
    DAYOFWEEK(NOW()) AS day_of_week,    -- Day of week (1=Sunday, 7=Saturday)
    DAYOFYEAR(NOW()) AS day_of_year,    -- Day of year (1-366)
    QUARTER(NOW()) AS quarter_part,     -- Quarter (1-4)
    WEEK(NOW()) AS week_part,           -- Week of year (0-53)
    WEEKOFYEAR(NOW()) AS week_of_year,  -- Same as WEEK()
    HOUR(NOW()) AS hour_part,           -- Extract hour (0-23)
    MINUTE(NOW()) AS minute_part,       -- Extract minute (0-59)
    SECOND(NOW()) AS second_part,       -- Extract second (0-59)
    LAST_DAY(NOW()) AS last_day_month;  -- Last day of the month

-- =====================================================
-- DATE/TIME FORMATTING FUNCTIONS
-- =====================================================

-- Format date values
SELECT 
    DATE_FORMAT(NOW(), '%Y-%m-%d') AS iso_date,
    DATE_FORMAT(NOW(), '%d/%m/%Y') AS uk_date,
    DATE_FORMAT(NOW(), '%M %d, %Y') AS us_long_date,
    DATE_FORMAT(NOW(), '%W, %M %e, %Y') AS full_date;

-- Format time values
SELECT 
    TIME_FORMAT(NOW(), '%H:%i:%s') AS 24_hour_time,
    TIME_FORMAT(NOW(), '%h:%i %p') AS 12_hour_time;

-- Common date format specifiers:
-- %Y = 4-digit year, %y = 2-digit year
-- %M = Month name, %m = Month number (01-12)
-- %D = Day with suffix (1st, 2nd, 3rd), %d = Day number (01-31)
-- %W = Weekday name, %w = Day of week (0=Sunday)
-- %H = Hour (00-23), %h = Hour (01-12)
-- %i = Minutes (00-59), %s = Seconds (00-59)
-- %p = AM/PM

-- =====================================================
-- TYPE CONVERSION FUNCTIONS
-- =====================================================

-- Implicit type conversion examples
SELECT 
    '2023-12-25' + INTERVAL 1 DAY AS implicit_conversion,
    CONCAT('Date: ', CURDATE()) AS string_conversion;

-- Explicit type conversion using STR_TO_DATE()
SELECT 
    STR_TO_DATE('25/12/2023', '%d/%m/%Y') AS converted_date,
    STR_TO_DATE('Dec 25, 2023 15:30:45', '%M %d, %Y %H:%i:%s') AS converted_datetime;

-- Convert string to date/time formats
SELECT 
    CAST('2023-12-25' AS DATE) AS cast_to_date,
    CAST('15:30:45' AS TIME) AS cast_to_time,
    CAST('2023-12-25 15:30:45' AS DATETIME) AS cast_to_datetime;

-- =====================================================
-- DATE/TIME ARITHMETIC FUNCTIONS
-- =====================================================

-- Calculate differences between dates/times
SELECT 
    DATEDIFF('2023-12-25', '2023-01-01') AS days_difference,
    TIMEDIFF('15:30:00', '12:15:30') AS time_difference;

-- Add and subtract intervals
SELECT 
    DATE_ADD(NOW(), INTERVAL 1 DAY) AS tomorrow,
    DATE_ADD(NOW(), INTERVAL 1 WEEK) AS next_week,
    DATE_ADD(NOW(), INTERVAL 1 MONTH) AS next_month,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS next_year,
    DATE_SUB(NOW(), INTERVAL 1 DAY) AS yesterday;

-- Add and subtract time
SELECT 
    ADDTIME(NOW(), '02:30:00') AS add_time,
    SUBTIME(NOW(), '01:15:30') AS subtract_time;

-- Complex interval calculations
SELECT 
    DATE_ADD('2023-01-01', INTERVAL '1-6' YEAR_MONTH) AS year_month_add,
    DATE_ADD('2023-01-01 12:00:00', INTERVAL '1 2:30:15' DAY_SECOND) AS day_second_add;

-- =====================================================
-- DATETIME vs TIMESTAMP COMPARISON EXAMPLES
-- =====================================================

-- Create comparison table
CREATE TABLE datetime_vs_timestamp (
    id INT PRIMARY KEY,
    dt_column DATETIME,
    ts_column TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO datetime_vs_timestamp (id, dt_column, ts_column) 
VALUES (1, '2023-02-24 11:46:00', '2023-02-24 11:46:00');

-- Key differences demonstration:
-- 1. Range: DATETIME ('1000-01-01' to '9999-12-31') vs TIMESTAMP ('1970-01-01' to '2038-01-19')
-- 2. Storage: DATETIME (8 bytes) vs TIMESTAMP (4 bytes)
-- 3. Time zone: DATETIME (no conversion) vs TIMESTAMP (UTC conversion)
-- 4. Precision: DATETIME (microseconds) vs TIMESTAMP (seconds)
-- 5. Auto-update: TIMESTAMP supports ON UPDATE CURRENT_TIMESTAMP

-- =====================================================
-- USEFUL DATETIME UTILITY QUERIES
-- =====================================================

-- Get first and last day of current month
SELECT 
    DATE_FORMAT(CURDATE(), '%Y-%m-01') AS first_day_of_month,
    LAST_DAY(CURDATE()) AS last_day_of_month;

-- Get age in years
SELECT 
    TIMESTAMPDIFF(YEAR, '1990-05-15', CURDATE()) AS age_in_years;

-- Get business days between two dates (excluding weekends)
SELECT 
    DATEDIFF('2023-12-31', '2023-01-01') - 
    (WEEK('2023-12-31') - WEEK('2023-01-01')) * 2 AS business_days_approx;

-- Get timezone information
SELECT 
    @@global.time_zone AS global_timezone,
    @@session.time_zone AS session_timezone;

-- =====================================================
-- PERFORMANCE TIPS AND BEST PRACTICES
-- =====================================================

/*
Performance Tips:
1. Use appropriate indexes on date/time columns for better query performance
2. TIMESTAMP is more storage-efficient than DATETIME (4 vs 8 bytes)
3. Use DATE instead of DATETIME when time is not needed
4. Avoid functions in WHERE clauses; use range conditions instead

Example of efficient date range query:
Good: WHERE date_column >= '2023-01-01' AND date_column < '2024-01-01'
Bad:  WHERE YEAR(date_column) = 2023

5. Use TIMESTAMP for audit columns (created_at, updated_at)
6. Consider partitioning large tables by date ranges
7. Use UTC timezone for TIMESTAMP columns in multi-timezone applications
*/

-- Create indexes for better performance
CREATE INDEX idx_flights_departure_time ON flights(departure_time);
CREATE INDEX idx_flights_departure_city_time ON flights(departure_city, departure_time);

-- =====================================================
-- END OF MySQL DATETIME REFERENCE GUIDE
-- =====================================================