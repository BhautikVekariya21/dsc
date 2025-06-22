-- =====================================================
-- HEALTH INSURANCE CLAIM ANALYSIS - SQL PROBLEMS
-- =====================================================
-- Dataset: Health Insurance Claim (Kaggle)
-- Note: Avoid using GROUP BY clause to solve the problems
-- =====================================================

-- **PROBLEM 1**
-- What are the top 5 patients who claimed the highest insurance amounts?
-- =====================================================

-- Write your SQL query here:
SELECT 
    patientID,
    claim
FROM (
    SELECT
        patientID,
        claim,
        ROW_NUMBER() OVER (ORDER BY claim DESC) AS row_number_by_claim
    FROM insurance_data
) AS row_calculation
WHERE row_number_by_claim <= 5;

-- **PROBLEM 2** 
-- What is the average insurance claimed by patients based on the number of children they have?
-- =====================================================

-- Write your SQL query here:
SELECT DISTINCT
    children,
    ROUND(AVG(claim) OVER (PARTITION BY children), 2) AS avg_claim_by_children
FROM insurance_data;

-- **PROBLEM 3**
-- What is the highest and lowest claimed amount by patients in each region?
-- =====================================================

-- Write your SQL query here:
SELECT DISTINCT
    region,
    MAX(claim) OVER (PARTITION BY region) AS max_claim_by_region,
    MIN(claim) OVER (PARTITION BY region) AS min_claim_by_region
FROM insurance_data;

-- **PROBLEM 4**
-- What is the percentage of smokers in each age group?
-- =====================================================

-- Write your SQL query here:
SELECT DISTINCT
    age,
    ROUND(
        COUNT(CASE WHEN smoker = 'Yes' THEN 1 END) OVER (PARTITION BY age) * 100.0 /
        COUNT(*) OVER (PARTITION BY age),
        2
    ) AS smoker_percentage
FROM insurance_data;

-- **PROBLEM 5**
-- What is the difference between the claimed amount of each patient and the first claimed amount of that patient?
-- =====================================================

-- Write your SQL query here:
SELECT 
    patientID,
    claim,
    FIRST_VALUE(claim) OVER (ORDER BY patientID ASC) AS first_patient_claim,
    claim - FIRST_VALUE(claim) OVER (ORDER BY patientID ASC) AS claim_difference
FROM insurance_data;

-- **PROBLEM 6**
-- For each patient, 
-- calculate the difference between their claimed amount and the average claimed amount of patients with the same number of children.
-- =====================================================

-- Write your SQL query here:
SELECT 
    patientID,
    claim,
    children,
    ROUND(ABS(claim - AVG(claim) OVER (PARTITION BY children)), 2) AS diff_btw_claim
FROM insurance_data;

-- **PROBLEM 7**
-- Show the patient with the highest BMI in each region and their respective rank.
-- =====================================================

-- Write your SQL query here:
WITH ranked_table AS (
    SELECT
        patientID,
        bmi,
        region,
        RANK() OVER (PARTITION BY region ORDER BY bmi DESC) AS rank_in_region
    FROM insurance_data
)
SELECT *
FROM ranked_table 
WHERE rank_in_region = 1;

-- **PROBLEM 8**
-- Calculate the difference between the claimed amount of each patient 
-- and the claimed amount of the patient who has the highest BMI in their region.
-- =====================================================

-- Write your SQL query here:
WITH ranked_table AS (
    SELECT
        patientID,
        bmi,
        region,
        claim,
        RANK() OVER (PARTITION BY region ORDER BY bmi DESC) AS rank_in_region
    FROM insurance_data
),
highest_bmi AS (
    SELECT 
        region, 
        claim AS max_bmi_claim
    FROM ranked_table 
    WHERE rank_in_region = 1
)
SELECT 
    i.patientID,
    i.bmi,
    i.region,
    i.claim,
    ROUND(i.claim - h.max_bmi_claim, 2) AS claim_diff_from_max_bmi_patient
FROM insurance_data i
JOIN highest_bmi h ON i.region = h.region;

-- **PROBLEM 9**
-- For each patient, calculate the difference in claim amount between the patient 
-- and the patient with the highest claim amount among patients with the same bmi 
-- and smoker status, within the same region. Return the result in descending order difference.
-- =====================================================

-- Write your SQL query here:
SELECT 
    *,
    ROUND(ABS(claim - MAX(claim) OVER (PARTITION BY bmi, smoker, region)), 2) AS diff_in_claim_with_same_bmi_region_smoker
FROM insurance_data
ORDER BY diff_in_claim_with_same_bmi_region_smoker DESC;

-- **PROBLEM 10**
-- For each patient, find the maximum BMI value among their next three records (ordered by age).
-- =====================================================

-- Write your SQL query here:
SELECT 
    *,
    MAX(bmi) OVER (
        ORDER BY age
        ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING
    ) AS max_bmi_in_next3
FROM insurance_data;

-- **PROBLEM 11**
-- For each patient, find the rolling average of the last 2 claims.
-- =====================================================

-- Write your SQL query here:
SELECT 
    *,
    ROUND(AVG(claim) OVER (
        ORDER BY patientID 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_of_last2
FROM insurance_data;

-- **PROBLEM 12**
-- Find the first claimed insurance value for male and female patients, 
-- within each region order the data by patient age in ascending order, 
-- and only include patients who are non-diabetic and have a bmi value between 25 and 30.
-- =====================================================

-- Write your SQL query here:
SELECT 
    *,
    FIRST_VALUE(claim) OVER (PARTITION BY gender, region ORDER BY age ASC) AS first_patient_claim
FROM insurance_data
WHERE diabetic = 'No' AND bmi BETWEEN 25 AND 30;

-- =====================================================
-- END OF PROBLEMS
-- =====================================================