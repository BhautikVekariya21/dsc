-- File: insurance_claim_tasks.sql
-- Dataset Source: https://www.kaggle.com/datasets/thedevastator/insurance-claim-analysis-demographic-and-health
-- CSV Link: https://docs.google.com/spreadsheets/d/e/2PACX-1vRa1wWwXmzxEvqITxj4OQTeLywlGTTsOTbhSRqKj2lPuGefjlci-DQhgLBPpgWXe8AAUu2WUBqY59X1/pub?gid=1030172542&single=true&output=csv

-- --------------------------------------------------------
-- STEP 1: Create and Use Database
-- --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS insurance_data;
USE insurance_data;

-- View data (optional check)
SELECT * FROM insurance_data;

-- --------------------------------------------------------
-- STEP 2: Tasks with Answers
-- --------------------------------------------------------

-- ✅ Q1: Show records of 'male' patients from 'southwest' region.
SELECT *
FROM insurance_data
WHERE gender = 'male' AND region LIKE 'south%';


-- ✅ Q2: Show all records having BMI in range 30 to 45 (inclusive).
SELECT * 
FROM insurance_data 
WHERE bmi BETWEEN 30 AND 45;


-- ✅ Q3: Show MIN and MAX blood pressure of diabetic patients who smoke.
-- Rename columns as MinBP and MaxBP.
SELECT 
    MIN(bloodpressure) AS MinBP, 
    MAX(bloodpressure) AS MaxBP
FROM insurance_data
WHERE diabetic = 'Yes' AND smoker = 'Yes';


-- ✅ Q4: Find number of unique patients not from 'southwest' region.
SELECT COUNT(DISTINCT patientID) AS unique_patients
FROM insurance_data
WHERE region NOT LIKE 'southwest';


-- ✅ Q5: Total claim amount from male smokers.
SELECT SUM(claim) AS total_claim
FROM insurance_data
WHERE gender = 'male' AND smoker = 'Yes';


-- ✅ Q6: Select all records from any southern region (e.g., southwest, southeast).
SELECT *
FROM insurance_data
WHERE region LIKE 'south%';


-- ✅ Q7: Count of patients with normal blood pressure (90–120 inclusive).
SELECT COUNT(*) AS normal_bp_patients
FROM insurance_data 
WHERE bloodpressure BETWEEN 90 AND 120;


-- ✅ Q8: Count of patients below 17 years with age-based normal BP.
-- Formula: BP between (80 + age*2) and (100 + age*2)
SELECT COUNT(*) AS normal_17_bp_patients
FROM insurance_data 
WHERE age < 17
  AND bloodpressure BETWEEN (80 + age * 2) AND (100 + age * 2);


-- ✅ Q9: Average claim amount for non-smoking diabetic female patients.
SELECT AVG(claim) AS avg_claim_female
FROM insurance_data
WHERE gender = 'female' AND diabetic = 'Yes' AND smoker = 'No';


-- ✅ Q10: Update claim amount to 5000 for PatientID = 1234.
UPDATE insurance_data
SET claim = 5000
WHERE patientID = 1234;


-- ✅ Q11: Delete records of patients who are smokers and have no children.
DELETE FROM insurance_data
WHERE smoker = 'Yes' AND children = 0;
