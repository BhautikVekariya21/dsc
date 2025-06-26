-- =====================================================
-- COMPLETE LAPTOP DATA ANALYSIS SCRIPT
-- From Raw Data Cleaning to Advanced Feature Engineering
-- =====================================================

-- =====================================================
-- DATABASE SETUP AND INITIAL EXPLORATION
-- =====================================================

-- Use the existing database
USE laptops;

-- Initial data exploration
SELECT * FROM laptops;

-- Display sample records from different parts of dataset
-- Head: First 5 records
SELECT * FROM laptops
ORDER BY `index` LIMIT 5;

-- Tail: Last 5 records
SELECT * FROM laptops
ORDER BY `index` DESC LIMIT 5;

-- Random sample: 5 random records
SELECT * FROM laptops
ORDER BY RAND() LIMIT 5;

-- =====================================================
-- STATISTICAL SUMMARY AND DATA PROFILING
-- =====================================================

-- Complete statistical summary of Price column
SELECT 
    COUNT(Price) OVER() AS total_count,
    MIN(Price) OVER() AS min_price,
    MAX(Price) OVER() AS max_price,
    AVG(Price) OVER() AS avg_price,
    STD(Price) OVER() AS std_price,
    PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
    PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops
ORDER BY `index` LIMIT 1;

-- Check for missing values in Price column
SELECT COUNT(Price) AS non_null_prices
FROM laptops
WHERE Price IS NULL;

-- =====================================================
-- OUTLIER DETECTION AND ANALYSIS
-- =====================================================

-- Identify outliers using IQR method (1.5 * IQR rule)
SELECT * FROM (
    SELECT *,
        PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
        PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
    FROM laptops
) t
WHERE t.Price < t.Q1 - (1.5*(t.Q3 - t.Q1)) OR
      t.Price > t.Q3 + (1.5*(t.Q3 - t.Q1));

-- Price distribution histogram using buckets
SELECT 
    t.buckets,
    COUNT(*) AS frequency,
    REPEAT('*', COUNT(*)/5) AS histogram
FROM (
    SELECT price, 
        CASE 
            WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
            WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
            WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
            WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
            ELSE '>100K'
        END AS 'buckets'
    FROM laptops
) t
GROUP BY t.buckets
ORDER BY 
    CASE t.buckets
        WHEN '0-25K' THEN 1
        WHEN '25K-50K' THEN 2
        WHEN '50K-75K' THEN 3
        WHEN '75K-100K' THEN 4
        WHEN '>100K' THEN 5
    END;

-- =====================================================
-- BACKUP CREATION FOR SAFETY
-- =====================================================

-- Create backup table with same structure as original
CREATE TABLE laptop_backup LIKE laptops;

-- Insert all data into backup table for safety
INSERT INTO laptop_backup
SELECT * FROM laptops;

-- Verify backup table contents
SELECT COUNT(*) AS backup_record_count FROM laptop_backup;

-- =====================================================
-- EXPLORATORY DATA ANALYSIS
-- =====================================================

-- Company distribution analysis
SELECT 
    Company,
    COUNT(Company) AS laptop_count,
    ROUND(COUNT(Company) * 100.0 / (SELECT COUNT(*) FROM laptops), 2) AS percentage
FROM laptops
GROUP BY Company
ORDER BY laptop_count DESC;

-- CPU speed vs Price correlation analysis
SELECT 
    cpu_speed,
    Price,
    CASE 
        WHEN cpu_speed BETWEEN 1.0 AND 2.0 THEN 'Low (1.0-2.0 GHz)'
        WHEN cpu_speed BETWEEN 2.1 AND 2.5 THEN 'Medium (2.1-2.5 GHz)'
        WHEN cpu_speed BETWEEN 2.6 AND 3.0 THEN 'High (2.6-3.0 GHz)'
        ELSE 'Very High (>3.0 GHz)'
    END AS speed_category
FROM laptops
WHERE cpu_speed IS NOT NULL;

-- =====================================================
-- CATEGORICAL DATA ANALYSIS
-- =====================================================

-- Touchscreen analysis by company
SELECT 
    Company,
    SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
    SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no',
    ROUND(SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS touchscreen_percentage
FROM laptops
GROUP BY Company
ORDER BY touchscreen_percentage DESC;

-- CPU brand distribution analysis
SELECT DISTINCT cpu_brand FROM laptops;

-- CPU brand distribution by company
SELECT 
    Company,
    SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'intel',
    SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd',
    SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'samsung'
FROM laptops
GROUP BY Company
ORDER BY Company;

-- =====================================================
-- CATEGORICAL-NUMERICAL BIVARIATE ANALYSIS
-- =====================================================

-- Price statistics by company
SELECT 
    Company,
    COUNT(*) AS laptop_count,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(STD(price), 2) AS std_price
FROM laptops
GROUP BY Company
ORDER BY avg_price DESC;

-- Price analysis by screen size categories
SELECT 
    screen_size,
    COUNT(*) AS count,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM laptops
GROUP BY screen_size
ORDER BY avg_price DESC;

-- =====================================================
-- MISSING VALUE HANDLING
-- =====================================================

-- Identify records with missing prices
SELECT * FROM laptops
WHERE price IS NULL;

-- Method 1: Replace missing values with overall mean price
-- UPDATE laptops
-- SET price = (SELECT AVG(price) FROM laptops WHERE price IS NOT NULL)
-- WHERE price IS NULL;

-- Method 2: Replace missing values with company-specific mean price
UPDATE laptops l1
SET price = (
    SELECT AVG(price) 
    FROM laptops l2 
    WHERE l2.Company = l1.Company 
    AND l2.price IS NOT NULL
)
WHERE price IS NULL;

-- Verify no missing prices remain
SELECT COUNT(*) AS missing_price_count
FROM laptops
WHERE price IS NULL;

-- =====================================================
-- ADVANCED FEATURE ENGINEERING
-- =====================================================

-- Create PPI (Pixels Per Inch) feature for screen quality measurement
ALTER TABLE laptops ADD COLUMN ppi INTEGER;

UPDATE laptops
SET ppi = ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/Inches);

-- Verify PPI calculation and find highest PPI laptops
SELECT 
    Company,
    TypeName,
    Inches,
    resolution_width,
    resolution_height,
    ppi
FROM laptops
ORDER BY ppi DESC
LIMIT 10;

-- Create screen size categories
ALTER TABLE laptops ADD COLUMN screen_size VARCHAR(255) AFTER Inches;

UPDATE laptops
SET screen_size = 
    CASE 
        WHEN Inches < 14.0 THEN 'small'
        WHEN Inches >= 14.0 AND Inches < 17.0 THEN 'medium'
        ELSE 'large'
    END;

-- =====================================================
-- ONE-HOT ENCODING FOR CATEGORICAL VARIABLES
-- =====================================================

-- GPU brand one-hot encoding
SELECT 
    `index`,
    Company,
    gpu_brand,
    CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'gpu_intel',
    CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'gpu_amd',
    CASE WHEN gpu_brand = 'nvidia' THEN 1 ELSE 0 END AS 'gpu_nvidia',
    CASE WHEN gpu_brand = 'arm' THEN 1 ELSE 0 END AS 'gpu_arm'
FROM laptops
ORDER BY `index`;

-- CPU brand one-hot encoding
SELECT 
    `index`,
    Company,
    cpu_brand,
    CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'cpu_intel',
    CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'cpu_amd',
    CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END AS 'cpu_samsung'
FROM laptops
ORDER BY `index`;

-- Operating system one-hot encoding
SELECT 
    `index`,
    Company,
    OpSys,
    CASE WHEN OpSys = 'Windows' THEN 1 ELSE 0 END AS 'os_windows',
    CASE WHEN OpSys = 'macOS' THEN 1 ELSE 0 END AS 'os_macos',
    CASE WHEN OpSys = 'Linux' THEN 1 ELSE 0 END AS 'os_linux',
    CASE WHEN OpSys = 'Chrome OS' THEN 1 ELSE 0 END AS 'os_chrome',
    CASE WHEN OpSys = 'No OS' THEN 1 ELSE 0 END AS 'os_none'
FROM laptops
ORDER BY `index`;

-- =====================================================
-- ADVANCED ANALYTICS AND INSIGHTS
-- =====================================================

-- Performance score calculation (combining multiple factors)
SELECT 
    `index`,
    Company,
    TypeName,
    cpu_speed,
    Ram,
    primary_storage,
    ppi,
    price,
    -- Calculate performance score (weighted combination)
    ROUND(
        (cpu_speed * 0.3) + 
        (Ram * 0.002) + 
        (primary_storage * 0.0001) + 
        (ppi * 0.01) + 
        (CASE WHEN memory_type = 'SSD' THEN 2 ELSE 1 END),
        2
    ) AS performance_score,
    -- Price-to-performance ratio
    ROUND(price / (
        (cpu_speed * 0.3) + 
        (Ram * 0.002) + 
        (primary_storage * 0.0001) + 
        (ppi * 0.01) + 
        (CASE WHEN memory_type = 'SSD' THEN 2 ELSE 1 END)
    ), 2) AS price_to_performance_ratio
FROM laptops
WHERE cpu_speed IS NOT NULL 
  AND Ram IS NOT NULL 
  AND primary_storage IS NOT NULL 
  AND ppi IS NOT NULL
ORDER BY performance_score DESC;

-- Market segment analysis
SELECT 
    CASE 
        WHEN price < 30000 THEN 'Budget'
        WHEN price BETWEEN 30000 AND 60000 THEN 'Mid-range'
        WHEN price BETWEEN 60000 AND 100000 THEN 'Premium'
        ELSE 'High-end'
    END AS market_segment,
    COUNT(*) AS laptop_count,
    ROUND(AVG(cpu_speed), 2) AS avg_cpu_speed,
    ROUND(AVG(Ram), 1) AS avg_ram,
    ROUND(AVG(primary_storage), 0) AS avg_storage,
    ROUND(AVG(ppi), 0) AS avg_ppi
FROM laptops
WHERE price IS NOT NULL
GROUP BY 
    CASE 
        WHEN price < 30000 THEN 'Budget'
        WHEN price BETWEEN 30000 AND 60000 THEN 'Mid-range'
        WHEN price BETWEEN 60000 AND 100000 THEN 'Premium'
        ELSE 'High-end'
    END
ORDER BY 
    CASE 
        WHEN market_segment = 'Budget' THEN 1
        WHEN market_segment = 'Mid-range' THEN 2
        WHEN market_segment = 'Premium' THEN 3
        WHEN market_segment = 'High-end' THEN 4
    END;

-- =====================================================
-- CORRELATION ANALYSIS
-- =====================================================

-- Correlation between various numerical features and price
SELECT 
    'RAM vs Price' AS correlation_type,
    ROUND(
        (COUNT(*) * SUM(Ram * price) - SUM(Ram) * SUM(price)) / 
        (SQRT(COUNT(*) * SUM(Ram * Ram) - SUM(Ram) * SUM(Ram)) * 
         SQRT(COUNT(*) * SUM(price * price) - SUM(price) * SUM(price))), 4
    ) AS correlation_coefficient
FROM laptops
WHERE Ram IS NOT NULL AND price IS NOT NULL

UNION ALL

SELECT 
    'CPU Speed vs Price' AS correlation_type,
    ROUND(
        (COUNT(*) * SUM(cpu_speed * price) - SUM(cpu_speed) * SUM(price)) / 
        (SQRT(COUNT(*) * SUM(cpu_speed * cpu_speed) - SUM(cpu_speed) * SUM(cpu_speed)) * 
         SQRT(COUNT(*) * SUM(price * price) - SUM(price) * SUM(price))), 4
    ) AS correlation_coefficient
FROM laptops
WHERE cpu_speed IS NOT NULL AND price IS NOT NULL

UNION ALL

SELECT 
    'Screen Size vs Price' AS correlation_type,
    ROUND(
        (COUNT(*) * SUM(Inches * price) - SUM(Inches) * SUM(price)) / 
        (SQRT(COUNT(*) * SUM(Inches * Inches) - SUM(Inches) * SUM(Inches)) * 
         SQRT(COUNT(*) * SUM(price * price) - SUM(price) * SUM(price))), 4
    ) AS correlation_coefficient
FROM laptops
WHERE Inches IS NOT NULL AND price IS NOT NULL;

-- =====================================================
-- FINAL DATA QUALITY CHECK
-- =====================================================

-- Comprehensive data quality report
SELECT 
    'Total Records' AS metric,
    COUNT(*) AS value
FROM laptops

UNION ALL

SELECT 
    'Records with Price' AS metric,
    COUNT(*) AS value
FROM laptops
WHERE price IS NOT NULL

UNION ALL

SELECT 
    'Unique Companies' AS metric,
    COUNT(DISTINCT Company) AS value
FROM laptops

UNION ALL

SELECT 
    'Unique GPU Brands' AS metric,
    COUNT(DISTINCT gpu_brand) AS value
FROM laptops

UNION ALL

SELECT 
    'Unique CPU Brands' AS metric,
    COUNT(DISTINCT cpu_brand) AS value
FROM laptops

UNION ALL

SELECT 
    'Touchscreen Laptops' AS metric,
    SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS value
FROM laptops;

-- =====================================================
-- FINAL CLEANED DATASET PREVIEW
-- =====================================================

-- Display final cleaned and enhanced dataset structure
SELECT 
    `index`,
    Company,
    TypeName,
    Inches,
    screen_size,
    resolution_width,
    resolution_height,
    ppi,
    Touchscreen,
    cpu_brand,
    cpu_name,
    cpu_speed,
    Ram,
    memory_type,
    primary_storage,
    secondary_storage,
    gpu_brand,
    gpu_name,
    OpSys,
    Weight,
    price
FROM laptops
ORDER BY `index`
LIMIT 10;

-- =====================================================
-- SCRIPT EXECUTION COMPLETE
-- =====================================================

/*
SUMMARY OF TRANSFORMATIONS APPLIED:
1. Statistical profiling and outlier detection
2. Missing value imputation using company-specific means
3. Feature engineering: PPI calculation, screen size categorization
4. One-hot encoding for categorical variables
5. Performance scoring and market segmentation
6. Correlation analysis between features and price
7. Comprehensive data quality assessment

The dataset is now ready for machine learning modeling and advanced analytics.
*/