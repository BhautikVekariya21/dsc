-- =====================================================
-- FLIGHT DATABASE ANALYSIS - FORMATTED QUERIES
-- =====================================================

-- Use the flight database
USE flight;

-- Display all records from flight table
SELECT * 
FROM flight;

-- =====================================================
-- BASIC ANALYSIS QUERIES
-- =====================================================

-- Find the month with the highest number of flights
SELECT 
    MONTHNAME(Date_of_Journey) AS month,
    COUNT(*) AS no_of_flights
FROM flight
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY no_of_flights DESC
LIMIT 1;

-- Find the weekday with the highest average flight price
SELECT 
    DAYNAME(Date_of_Journey) AS weekday,
    AVG(Price) AS weekday_price
FROM flight
GROUP BY DAYNAME(Date_of_Journey)
ORDER BY weekday_price DESC
LIMIT 1;

-- Count IndiGo flights per month (ordered chronologically)
SELECT 
    MONTHNAME(date_of_journey) AS month,
    COUNT(*) AS indigo_flights
FROM flight
WHERE Airline = 'IndiGo'
GROUP BY MONTHNAME(date_of_journey), MONTH(date_of_journey)
ORDER BY MONTH(date_of_journey);

-- =====================================================
-- DATA TRANSFORMATION - DATETIME CONSOLIDATION
-- =====================================================

-- Preview the concatenated journey date format
SELECT 
    CONCAT(Date_of_Journey, ' ', Dep_Time) AS journey_date
FROM flight;

-- Add new journey_date column to combine date and time
ALTER TABLE flight
ADD journey_date DATETIME AFTER Airline;

-- Populate the journey_date column with proper datetime format
UPDATE flight
SET journey_date = STR_TO_DATE(
    CONCAT(Date_of_Journey, ' ', Dep_Time),
    '%Y-%m-%d %H:%i'
);

-- Remove original separate date and time columns
ALTER TABLE flight
DROP COLUMN Date_of_Journey,
DROP COLUMN Dep_Time;

-- Verify the table structure after changes
SELECT * 
FROM flight;

-- Add destination_date column to store arrival datetime
ALTER TABLE flight
ADD destination_date DATETIME AFTER journey_date;

-- Calculate destination_date by adding duration to journey_date
UPDATE flight
SET destination_date = DATE_ADD(journey_date, INTERVAL duration MINUTE);

-- Remove the original duration column (now calculated as difference)
ALTER TABLE flight
DROP COLUMN duration;

-- Final table structure verification
SELECT * 
FROM flight;

-- =====================================================
-- ADVANCED FILTERING QUERIES
-- =====================================================

-- Find flights from Bangalore to Delhi arriving between 10 AM and 2 PM
SELECT 
    *
FROM flight
WHERE 
    Source = 'Banglore'
    AND Destination = 'Delhi'
    AND TIME(destination_date) BETWEEN '10:00:00' AND '14:00:00';

-- Find all flights from Bangalore on weekends
SELECT
    *
FROM flight
WHERE 
    Source = 'Banglore'
    AND DAYNAME(journey_date) IN ('Saturday', 'Sunday');

-- Count flights that travel across different dates (overnight flights)
SELECT 
    COUNT(*) AS flight_travel_on_different_dates
FROM flight
WHERE DATE(journey_date) != DATE(destination_date);

-- =====================================================
-- DURATION ANALYSIS WITH CTE
-- =====================================================

-- Calculate average duration for multi-day flights with stops
WITH avg_time_duration AS (
    SELECT
        journey_date,
        destination_date,
        total_stops,
        TIMESTAMPDIFF(SECOND, journey_date, destination_date) AS duration_seconds
    FROM flight
)
SELECT 
    SEC_TO_TIME(AVG(duration_seconds)) AS avg_duration
FROM avg_time_duration
WHERE
    DATE(journey_date) != DATE(destination_date)
    AND total_stops != 'non-stop';

-- Find Air India flights from Delhi in early March 2019
SELECT 
    * 
FROM flight
WHERE 
    Airline = 'Air India'
    AND Source = 'Delhi'
    AND DATE(destination_date) BETWEEN '2019-03-01' AND '2019-03-10';

-- Find maximum flight duration for each airline
WITH max_time_duration AS (
    SELECT
        Airline,
        TIMESTAMPDIFF(SECOND, journey_date, destination_date) AS duration_seconds
    FROM flight
)
SELECT 
    Airline,
    SEC_TO_TIME(MAX(duration_seconds)) AS max_duration
FROM max_time_duration
GROUP BY Airline;

-- Find routes with average duration greater than 3 hours
WITH avg_time_duration AS (
    SELECT
        Source,
        Destination,
        TIMESTAMPDIFF(SECOND, journey_date, destination_date) AS duration_seconds
    FROM flight
)
SELECT
    Source,
    Destination,
    SEC_TO_TIME(AVG(duration_seconds)) AS avg_duration
FROM avg_time_duration
GROUP BY Source, Destination
HAVING AVG(duration_seconds) > 10800; -- 3 hours = 10800 seconds

-- =====================================================
-- ADVANCED ANALYSIS QUERIES - ANSWERS TO QUESTIONS 16-30
-- =====================================================

-- 16. Weekday vs Time grid showing frequency of flights from Bangalore to Delhi
SELECT 
    DAYNAME(journey_date) AS weekday,
    CASE 
        WHEN HOUR(journey_date) BETWEEN 0 AND 5 THEN '12AM-6AM'
        WHEN HOUR(journey_date) BETWEEN 6 AND 11 THEN '6AM-12PM'
        WHEN HOUR(journey_date) BETWEEN 12 AND 17 THEN '12PM-6PM'
        WHEN HOUR(journey_date) BETWEEN 18 AND 23 THEN '6PM-12AM'
    END AS time_slot,
    COUNT(*) AS flight_count
FROM flight
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY weekday, time_slot
ORDER BY 
    CASE DAYNAME(journey_date)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END,
    CASE time_slot
        WHEN '12AM-6AM' THEN 1
        WHEN '6AM-12PM' THEN 2
        WHEN '12PM-6PM' THEN 3
        WHEN '6PM-12AM' THEN 4
    END;

-- 17. Weekday vs Time grid showing average flight price from Bangalore to Delhi
SELECT 
    DAYNAME(journey_date) AS weekday,
    CASE 
        WHEN HOUR(journey_date) BETWEEN 0 AND 5 THEN '12AM-6AM'
        WHEN HOUR(journey_date) BETWEEN 6 AND 11 THEN '6AM-12PM'
        WHEN HOUR(journey_date) BETWEEN 12 AND 17 THEN '12PM-6PM'
        WHEN HOUR(journey_date) BETWEEN 18 AND 23 THEN '6PM-12AM'
    END AS time_slot,
    ROUND(AVG(Price), 2) AS avg_price
FROM flight
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY weekday, time_slot
ORDER BY 
    CASE DAYNAME(journey_date)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END,
    CASE time_slot
        WHEN '12AM-6AM' THEN 1
        WHEN '6AM-12PM' THEN 2
        WHEN '12PM-6PM' THEN 3
        WHEN '6PM-12AM' THEN 4
    END;

-- 18. Find the busiest hour of the day for departures
SELECT 
    HOUR(journey_date) AS departure_hour,
    COUNT(*) AS flight_count
FROM flight
GROUP BY HOUR(journey_date)
ORDER BY flight_count DESC
LIMIT 1;

-- 19. Calculate the percentage of flights that arrive the next day
SELECT 
    ROUND(
        (COUNT(CASE WHEN DATE(destination_date) > DATE(journey_date) THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS next_day_arrival_percentage
FROM flight;

-- 20. Find airline with most consistent flight duration (lowest standard deviation)
WITH duration_stats AS (
    SELECT 
        Airline,
        TIMESTAMPDIFF(MINUTE, journey_date, destination_date) AS duration_minutes
    FROM flight
),
airline_consistency AS (
    SELECT 
        Airline,
        STDDEV(duration_minutes) AS duration_stddev,
        COUNT(*) AS flight_count
    FROM duration_stats
    GROUP BY Airline
    HAVING COUNT(*) >= 10  -- Only airlines with sufficient data
)
SELECT 
    Airline,
    ROUND(duration_stddev, 2) AS standard_deviation_minutes
FROM airline_consistency
ORDER BY duration_stddev ASC
LIMIT 1;

-- 21. Identify peak travel months for each route
WITH monthly_route_counts AS (
    SELECT 
        Source,
        Destination,
        MONTHNAME(journey_date) AS month,
        MONTH(journey_date) AS month_num,
        COUNT(*) AS flight_count
    FROM flight
    GROUP BY Source, Destination, month, month_num
),
route_peak_months AS (
    SELECT 
        Source,
        Destination,
        month,
        flight_count,
        ROW_NUMBER() OVER (PARTITION BY Source, Destination ORDER BY flight_count DESC) AS rn
    FROM monthly_route_counts
)
SELECT 
    Source,
    Destination,
    month AS peak_month,
    flight_count
FROM route_peak_months
WHERE rn = 1;

-- 22. Find flights with unusual duration (outliers)
WITH duration_stats AS (
    SELECT 
        *,
        TIMESTAMPDIFF(MINUTE, journey_date, destination_date) AS duration_minutes
    FROM flight
),
overall_stats AS (
    SELECT 
        AVG(duration_minutes) AS avg_duration,
        STDDEV(duration_minutes) AS stddev_duration
    FROM duration_stats
)
SELECT 
    ds.*,
    ROUND(ds.duration_minutes, 2) AS flight_duration_minutes,
    ROUND(os.avg_duration, 2) AS avg_duration_minutes,
    ROUND(os.stddev_duration, 2) AS stddev_duration_minutes
FROM duration_stats ds
CROSS JOIN overall_stats os
WHERE ds.duration_minutes > (os.avg_duration + 2 * os.stddev_duration);

-- 23. Calculate average delay (assuming flights should arrive exactly after duration from departure)
-- Note: This assumes the original duration was the scheduled duration
WITH flight_analysis AS (
    SELECT 
        *,
        TIMESTAMPDIFF(MINUTE, journey_date, destination_date) AS actual_duration_minutes
    FROM flight
)
SELECT 
    ROUND(AVG(actual_duration_minutes), 2) AS avg_actual_duration_minutes
FROM flight_analysis;

-- 24. Find most popular departure time slots for business travelers (Mon-Fri, 6AM-10AM and 6PM-10PM)
SELECT 
    CASE 
        WHEN HOUR(journey_date) BETWEEN 6 AND 9 THEN '6AM-10AM (Morning Business)'
        WHEN HOUR(journey_date) BETWEEN 18 AND 21 THEN '6PM-10PM (Evening Business)'
    END AS business_time_slot,
    COUNT(*) AS flight_count
FROM flight
WHERE DAYOFWEEK(journey_date) BETWEEN 2 AND 6  -- Monday to Friday
    AND (
        (HOUR(journey_date) BETWEEN 6 AND 9) OR 
        (HOUR(journey_date) BETWEEN 18 AND 21)
    )
GROUP BY business_time_slot
ORDER BY flight_count DESC;

-- 25. Analyze seasonal patterns - Summer vs Winter flight patterns
SELECT 
    CASE 
        WHEN MONTH(journey_date) IN (4, 5, 6) THEN 'Summer (Apr-Jun)'
        WHEN MONTH(journey_date) IN (12, 1, 2) THEN 'Winter (Dec-Feb)'
    END AS season,
    COUNT(*) AS flight_count,
    ROUND(AVG(Price), 2) AS avg_price,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, journey_date, destination_date)), 2) AS avg_duration_minutes
FROM flight
WHERE MONTH(journey_date) IN (4, 5, 6, 12, 1, 2)
GROUP BY season;

-- =====================================================
-- BONUS COMPLEX QUERIES (26-30)
-- =====================================================

-- 26. Create pivot table showing airline vs month flight count
SELECT 
    Airline,
    SUM(CASE WHEN MONTH(journey_date) = 1 THEN 1 ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(journey_date) = 2 THEN 1 ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(journey_date) = 3 THEN 1 ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(journey_date) = 4 THEN 1 ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(journey_date) = 5 THEN 1 ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(journey_date) = 6 THEN 1 ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(journey_date) = 7 THEN 1 ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(journey_date) = 8 THEN 1 ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(journey_date) = 9 THEN 1 ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(journey_date) = 10 THEN 1 ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(journey_date) = 11 THEN 1 ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(journey_date) = 12 THEN 1 ELSE 0 END) AS Dec
FROM flight
GROUP BY Airline;

-- 27. Find routes where return flights have significantly different durations
WITH route_durations AS (
    SELECT 
        Source,
        Destination,
        AVG(TIMESTAMPDIFF(MINUTE, journey_date, destination_date)) AS avg_duration
    FROM flight
    GROUP BY Source, Destination
),
return_route_comparison AS (
    SELECT 
        r1.Source AS origin,
        r1.Destination AS destination,
        r1.avg_duration AS forward_duration,
        r2.avg_duration AS return_duration,
        ABS(r1.avg_duration - r2.avg_duration) AS duration_difference
    FROM route_durations r1
    JOIN route_durations r2 ON r1.Source = r2.Destination AND r1.Destination = r2.Source
    WHERE r1.Source < r2.Source  -- Avoid duplicates
)
SELECT *
FROM return_route_comparison
WHERE duration_difference > 60  -- More than 1 hour difference
ORDER BY duration_difference DESC;

-- 28. Calculate cumulative number of flights by date for trend analysis
SELECT 
    DATE(journey_date) AS flight_date,
    COUNT(*) AS daily_flights,
    SUM(COUNT(*)) OVER (ORDER BY DATE(journey_date)) AS cumulative_flights
FROM flight
GROUP BY DATE(journey_date)
ORDER BY flight_date;

-- 29. Find optimal departure time for each route based on minimum average price
WITH route_time_pricing AS (
    SELECT 
        Source,
        Destination,
        HOUR(journey_date) AS departure_hour,
        AVG(Price) AS avg_price
    FROM flight
    GROUP BY Source, Destination, HOUR(journey_date)
),
optimal_times AS (
    SELECT 
        Source,
        Destination,
        departure_hour,
        avg_price,
        ROW_NUMBER() OVER (PARTITION BY Source, Destination ORDER BY avg_price ASC) AS price_rank
    FROM route_time_pricing
)
SELECT 
    Source,
    Destination,
    CONCAT(departure_hour, ':00') AS optimal_departure_time,
    ROUND(avg_price, 2) AS min_avg_price
FROM optimal_times
WHERE price_rank = 1;

-- 30. Identify potential codeshare flights (same route, same time, different airlines)
SELECT 
    f1.Source,
    f1.Destination,
    f1.journey_date,
    f1.Airline AS airline_1,
    f2.Airline AS airline_2,
    f1.Price AS price_1,
    f2.Price AS price_2
FROM flight f1
JOIN flight f2 ON 
    f1.Source = f2.Source
    AND f1.Destination = f2.Destination
    AND f1.journey_date = f2.journey_date
    AND f1.Airline != f2.Airline
WHERE f1.Airline < f2.Airline  -- Avoid duplicate pairs
ORDER BY f1.journey_date;

-- =====================================================
-- PERFORMANCE OPTIMIZATION
-- =====================================================

-- Create indexes for better query performance
CREATE INDEX idx_journey_date ON flight(journey_date);
CREATE INDEX idx_destination_date ON flight(destination_date);
CREATE INDEX idx_source_destination ON flight(Source, Destination);
CREATE INDEX idx_airline ON flight(Airline);
CREATE INDEX idx_price ON flight(Price);

-- =====================================================
-- DATA VALIDATION QUERIES
-- =====================================================

-- 31. Find flights with impossible durations (negative or > 24 hours)
SELECT *
FROM flight
WHERE TIMESTAMPDIFF(MINUTE, journey_date, destination_date) < 0
   OR TIMESTAMPDIFF(MINUTE, journey_date, destination_date) > 1440;  -- 24 hours = 1440 minutes

-- 32. Find flights with departure time after arrival time on same date
SELECT *
FROM flight
WHERE DATE(journey_date) = DATE(destination_date)
  AND TIME(journey_date) >= TIME(destination_date);

-- 33. Identify missing or NULL values in critical datetime columns
SELECT 
    COUNT(*) AS total_records,
    COUNT(journey_date) AS journey_date_count,
    COUNT(destination_date) AS destination_date_count,
    COUNT(*) - COUNT(journey_date) AS journey_date_nulls,
    COUNT(*) - COUNT(destination_date) AS destination_date_nulls
FROM flight;