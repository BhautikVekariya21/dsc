-- File: order_by_group_by_concise_mysql.sql
-- Purpose: Demonstrates concise variations of ORDER BY and GROUP BY clauses in MySQL

-- ----------------------------------------------------------
-- ✅ SQL EXECUTION ORDER (REFERENCE)
-- 1. FROM           -- Tables to query
-- 2. JOIN           -- Table joins
-- 3. WHERE          -- Row-level filtering
-- 4. GROUP BY       -- Grouping rows
-- 5. HAVING         -- Filtering groups
-- 6. SELECT         -- Selecting/returning columns
-- 7. ORDER BY       -- Sorting result set
-- 8. LIMIT          -- Limiting number of rows
-- ----------------------------------------------------------

-- --------------------------------------
-- 1. ORDER BY Clause
-- --------------------------------------

-- 1.1 ORDER BY Single Column (Ascending)
SELECT student_id, first_name, last_name
FROM academic.students
ORDER BY last_name ASC;

-- 1.2 ORDER BY Single Column (Descending)
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY gpa DESC;

-- 1.3 ORDER BY Multiple Columns
SELECT d.department_name, c.course_name
FROM academic.courses c
JOIN academic.departments d ON c.department_id = d.department_id
ORDER BY d.department_name ASC, c.course_name ASC;

-- 1.4 ORDER BY Column Position
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY 3 DESC;

-- 1.5 ORDER BY Expression (MySQL uses YEAR() instead of EXTRACT for simplicity)
SELECT student_id, first_name, date_of_birth
FROM academic.students
ORDER BY YEAR(date_of_birth) ASC;

-- 1.6 ORDER BY with NULL Handling (MySQL does not support NULLS LAST, use IS NULL)
SELECT student_id, first_name, email
FROM academic.students
ORDER BY email IS NULL, email ASC;

-- 1.7 ORDER BY with Custom Logic (CASE)
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY 
    CASE 
        WHEN gpa >= 3.5 THEN 1
        WHEN gpa >= 3.0 THEN 2
        ELSE 3
    END ASC;

-- 1.8 ORDER BY with Tie-Breaker
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY gpa DESC, first_name ASC;

-- 1.9 ORDER BY with LIMIT
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY gpa DESC
LIMIT 2;

-- --------------------------------------
-- 2. GROUP BY Clause
-- --------------------------------------

-- 2.1 GROUP BY Single Column
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name;

-- 2.2 GROUP BY Multiple Columns
SELECT d.department_name, c.course_name, COUNT(sc.student_id) AS student_count
FROM academic.student_courses sc
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name, c.course_name;

-- 2.3 GROUP BY with HAVING
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(s.gpa) > 3.2;

-- 2.4 GROUP BY with Multiple Aggregates
SELECT c.course_name, 
       MIN(s.gpa) AS min_gpa, 
       MAX(s.gpa) AS max_gpa, 
       AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
GROUP BY c.course_name;

-- 2.5 GROUP BY with Expression (YEAR instead of EXTRACT)
SELECT YEAR(date_of_birth) AS birth_year, 
       COUNT(*) AS student_count
FROM academic.students
GROUP BY YEAR(date_of_birth);

-- 2.6 GROUP BY with ROLLUP (MySQL supports ROLLUP)
SELECT d.department_name, c.course_name, COUNT(sc.student_id) AS student_count
FROM academic.student_courses sc
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name, c.course_name WITH ROLLUP;

-- 2.7 to 2.9 GROUPING SETS / CUBE / GROUPING() – Not supported in MySQL
-- You can simulate them manually via UNION ALL or custom logic if needed.

-- --------------------------------------
-- 3. Combining ORDER BY and GROUP BY
-- --------------------------------------

-- 3.1 GROUP BY with ORDER BY (Aggregate)
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_gpa DESC;

-- 3.2 GROUP BY with ORDER BY (Multiple Columns)
SELECT c.course_name, COUNT(sc.student_id) AS student_count
FROM academic.student_courses sc
JOIN academic.courses c ON sc.course_id = c.course_id
GROUP BY c.course_name
ORDER BY student_count DESC, c.course_name ASC;

-- 3.3 GROUP BY with HAVING and ORDER BY
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(s.gpa) > 3.0
ORDER BY avg_gpa DESC;

-- 3.4 GROUP BY with ROLLUP and ORDER BY
SELECT d.department_name, c.course_name, COUNT(sc.student_id) AS student_count
FROM academic.student_courses sc
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name, c.course_name WITH ROLLUP
ORDER BY d.department_name IS NULL, d.department_name, student_count DESC;

-- --------------------------------------
-- End of ORDER BY and GROUP BY Examples (MySQL version)
-- --------------------------------------
