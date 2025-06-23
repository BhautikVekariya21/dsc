-- ========================================
-- LAPTOP DATABASE CLEANING AND TRANSFORMATION SCRIPT
-- ========================================

-- ========================================
-- DATABASE SETUP
-- ========================================

-- Create new database for laptop data
CREATE DATABASE laptops;

-- Switch to the laptops database
USE laptops;

-- ========================================
-- INITIAL DATA EXPLORATION
-- ========================================

-- View all data in laptops table
SELECT * FROM laptops;

-- ========================================
-- BACKUP CREATION
-- ========================================

-- Create backup table with same structure as original
CREATE TABLE laptop_back LIKE laptops;

-- Insert all data into backup table for safety
INSERT INTO laptop_back
SELECT * FROM laptops;

-- Verify backup table contents
SELECT * FROM laptop_back;

-- Check initial table size in KB
SELECT DATA_LENGTH/1024 AS table_size_kb 
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptops'
  AND TABLE_NAME = 'laptops';


-- ========================================
-- DATA CLEANING - COLUMN REMOVAL
-- ========================================

-- View current table structure
SELECT * FROM laptops;

-- Remove unnecessary unnamed column
ALTER TABLE laptops DROP COLUMN `Unnamed: 0`;

-- Verify column removal
SELECT * FROM laptops;

-- ========================================
-- DATA CLEANING - NULL RECORD REMOVAL
-- ========================================

-- Delete records where ALL important fields are NULL
DELETE FROM laptops
WHERE 
    Company IS NULL AND
    TypeName IS NULL AND
    Inches IS NULL AND
    ScreenResolution IS NULL AND
    Cpu IS NULL AND
    Ram IS NULL AND
    Memory IS NULL AND
    Gpu IS NULL AND
    OpSys IS NULL AND
    Weight IS NULL AND
    Price IS NULL;

-- Check remaining record count after cleanup
SELECT COUNT(*) FROM laptops;

-- Verify data after null record removal
SELECT * FROM laptops;

-- ========================================
-- DATA TYPE OPTIMIZATION - INCHES COLUMN
-- ========================================

-- Convert Inches column to proper decimal format (max 5 digits, 1 decimal place)
ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(5,1);

-- ========================================
-- DATA CLEANING - RAM COLUMN
-- ========================================

-- Remove 'GB' suffix from RAM values
UPDATE laptops
SET Ram = REPLACE(Ram, 'GB', '');

-- Verify RAM column changes
SELECT * FROM laptops;

-- Convert RAM column to decimal data type
ALTER TABLE laptops MODIFY COLUMN Ram DECIMAL(10,1);

-- ========================================
-- DATA CLEANING - WEIGHT COLUMN
-- ========================================

-- Remove 'kg' suffix from Weight values
UPDATE laptops
SET Weight = REPLACE(Weight, 'kg', '');

-- Verify Weight column changes
SELECT * FROM laptops;

-- ========================================
-- DATA CLEANING - PRICE COLUMN
-- ========================================

-- Round price values to nearest integer
UPDATE laptops
SET Price = ROUND(Price);

-- Verify Price column changes
SELECT * FROM laptops;

-- Convert Price column to integer data type
ALTER TABLE laptops MODIFY COLUMN Price INTEGER;

-- ========================================
-- DATA STANDARDIZATION - OPERATING SYSTEM
-- ========================================

-- Check all unique operating systems in the data
SELECT DISTINCT OpSys FROM laptops;

-- Check specific OS count (Chrome OS example)
SELECT COUNT(*) AS chrome_os_count
FROM laptops
WHERE OpSys = 'Chrome OS';

-- Apply OS standardization with NULL handling
-- Categories: macos, windows, linux, N/A, other
UPDATE laptops
SET OpSys = 
    CASE 
        WHEN OpSys IS NULL THEN 'other'
        WHEN OpSys LIKE '%mac%' THEN 'macos'
        WHEN OpSys LIKE 'windows%' THEN 'windows'
        WHEN OpSys LIKE '%linux%' THEN 'linux'
        WHEN OpSys = 'No OS' THEN 'N/A'
        ELSE 'other'
    END;

-- Verify OS standardization
SELECT * FROM laptops;

-- Check distinct OS values after standardization
SELECT DISTINCT OpSys FROM laptops;

-- ========================================
-- COLUMN RESTRUCTURING - GPU INFORMATION
-- ========================================

-- Add new columns for GPU brand and name
ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

-- Extract GPU brand (first word of GPU string)
UPDATE laptops 
SET gpu_brand = SUBSTRING_INDEX(Gpu, ' ', 1);

-- Verify GPU brand extraction
SELECT * FROM laptops;

-- Extract GPU name (remaining text after brand, trimmed)
UPDATE laptops
SET gpu_name = TRIM(REPLACE(Gpu, gpu_brand, ''));

-- Verify GPU name extraction
SELECT * FROM laptops;

-- Remove original GPU column (no longer needed)
ALTER TABLE laptops DROP COLUMN Gpu;

-- ========================================
-- COLUMN RESTRUCTURING - CPU INFORMATION
-- ========================================

-- Add new columns for CPU details
ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

-- Extract CPU brand (first word of CPU string)
UPDATE laptops
SET cpu_brand = SUBSTRING_INDEX(Cpu, ' ', 1);

-- Extract CPU speed (last word, remove GHz suffix)
UPDATE laptops
SET cpu_speed = CAST(
    TRIM(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '')) 
    AS DECIMAL(5,1)
);

-- Verify CPU brand and speed extraction
SELECT * FROM laptops;

-- Extract CPU name (middle portion, first 2 words after brand removal)
UPDATE laptops
SET cpu_name = SUBSTRING_INDEX(
    SUBSTRING_INDEX(
        TRIM(REPLACE(Cpu, cpu_brand, '')),
        ' ',
        3
    ),
    ' ',
    2
);

-- Remove original CPU column (no longer needed)
ALTER TABLE laptops 
DROP COLUMN Cpu;

-- Verify CPU column restructuring
SELECT * FROM laptops;

-- ========================================
-- COLUMN RESTRUCTURING - SCREEN RESOLUTION
-- ========================================

-- Preview resolution extraction (width x height format)
SELECT ScreenResolution,
    SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1) AS width,
    SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1) AS height
FROM laptops;

-- Add new columns for resolution components
ALTER TABLE laptops 
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

-- Verify new columns added
SELECT * FROM laptops;

-- Extract width and height from resolution string (e.g., "1920x1080")
UPDATE laptops
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1),
    resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1);

-- ========================================
-- FEATURE EXTRACTION - TOUCHSCREEN
-- ========================================

-- Add touchscreen indicator column (1 = has touchscreen, 0 = no touchscreen)
ALTER TABLE laptops 
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

-- Set touchscreen flag based on 'Touch' keyword in ScreenResolution
UPDATE laptops
SET touchscreen = ScreenResolution LIKE '%Touch%';

-- Verify touchscreen feature extraction
SELECT * FROM laptops;

-- Remove original ScreenResolution column (data extracted to separate columns)
ALTER TABLE laptops
DROP COLUMN ScreenResolution;

-- Verify ScreenResolution column removal
SELECT * FROM laptops;

-- ========================================
-- COLUMN RESTRUCTURING - MEMORY/STORAGE
-- ========================================

-- Preview current memory data format
SELECT Memory FROM laptops;

-- Add new columns for detailed storage information
ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

-- Categorize storage types based on memory string content
-- Types: SSD, HDD, Hybrid, Flash Storage
UPDATE laptops
SET memory_type = 
    CASE
        WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
        WHEN Memory LIKE '%SSD%' THEN 'SSD'
        WHEN Memory LIKE '%HDD%' THEN 'HDD'
        WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
        WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
        WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
        ELSE NULL
    END;

-- Extract storage capacity values using regex
-- Primary storage: before '+' sign
-- Secondary storage: after '+' sign (0 if no '+' present)
UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory, '+', 1), '[0-9]+'),
    secondary_storage = CASE 
        WHEN Memory LIKE '%+%' 
        THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory, '+', -1), '[0-9]+') 
        ELSE 0 
    END;

-- ========================================
-- DATA NORMALIZATION - STORAGE UNITS
-- ========================================

-- Preview storage unit conversion (TB to GB)
-- Values <= 2 are assumed to be in TB and need conversion to GB
SELECT 
    primary_storage,
    CASE 
        WHEN primary_storage <= 2 THEN primary_storage * 1024 
        ELSE primary_storage 
    END AS normalized_primary,
    secondary_storage,
    CASE 
        WHEN secondary_storage <= 2 THEN secondary_storage * 1024 
        ELSE secondary_storage 
    END AS normalized_secondary
FROM laptops;

-- Convert TB values to GB (multiply by 1024)
-- This standardizes all storage values to GB units
UPDATE laptops
SET primary_storage = CASE 
        WHEN primary_storage <= 2 THEN primary_storage * 1024 
        ELSE primary_storage 
    END,
    secondary_storage = CASE 
        WHEN secondary_storage <= 2 THEN secondary_storage * 1024 
        ELSE secondary_storage 
    END;

-- ========================================
-- FINAL RESULT
-- ========================================

-- View final cleaned and structured data
SELECT * FROM laptops;

-- ========================================
-- SCRIPT COMPLETE
-- ========================================