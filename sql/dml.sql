-- File: dml_commands_mysql.sql
-- Purpose: Demonstrates all DML commands in MySQL with variations

-- --------------------------------------
-- 1. INSERT Command
-- --------------------------------------

-- 1.1 INSERT Single Row
INSERT INTO academic.students (
    student_id, first_name, last_name, date_of_birth, email, gpa, created_at
)
VALUES (
    1, 'John', 'Doe', '2000-05-15', 'john.doe@example.com', 3.75, CURRENT_TIMESTAMP
);

-- 1.2 INSERT Multiple Rows
INSERT INTO academic.students (
    student_id, first_name, last_name, date_of_birth, email, gpa
)
VALUES
    (2, 'Jane', 'Smith', '2001-03-22', 'jane.smith@example.com', 3.90),
    (3, 'Alice', 'Johnson', '1999-11-10', 'alice.johnson@example.com', 3.20);

-- 1.3 INSERT with Default Values (created_at will use default)
INSERT INTO academic.students (
    student_id, first_name, last_name, email, gpa
)
VALUES (
    4, 'Bob', 'Brown', 'bob.brown@example.com', 3.50
);

-- 1.4 INSERT with SELECT
INSERT INTO academic.high_gpa_students (student_id, first_name, last_name, gpa)
SELECT student_id, first_name, last_name, gpa
FROM academic.students
WHERE gpa > 3.5;

-- MySQL does not support RETURNING in INSERT

-- --------------------------------------
-- 2. UPDATE Command
-- --------------------------------------

-- 2.1 UPDATE Single Column
UPDATE academic.students
SET gpa = 3.85
WHERE student_id = 1;

-- 2.2 UPDATE Multiple Columns
UPDATE academic.students
SET 
    email = 'john.doe@newdomain.com',
    gpa = 3.95,
    last_name = 'Doe-Smith'
WHERE student_id = 1;

-- 2.3 UPDATE with Condition
UPDATE academic.students
SET gpa = gpa + 0.1
WHERE gpa < 3.0;

-- 2.4 UPDATE with Subquery
UPDATE academic.courses
JOIN academic.departments ON academic.departments.department_name = 'Computer Science'
SET academic.courses.department_id = academic.departments.department_id
WHERE academic.courses.course_name LIKE '%SQL%';

-- MySQL does not support RETURNING in UPDATE

-- --------------------------------------
-- 3. DELETE Command
-- --------------------------------------

-- 3.1 DELETE Specific Row
DELETE FROM academic.students
WHERE student_id = 4;

-- 3.2 DELETE with Condition
DELETE FROM academic.students
WHERE gpa < 2.0;

-- 3.3 DELETE with Subquery
DELETE FROM academic.student_courses
WHERE course_id = (
    SELECT course_id 
    FROM (SELECT course_id FROM academic.courses WHERE course_name = 'Introduction to SQL') AS sub
);

-- 3.4 DELETE All Rows
DELETE FROM academic.high_gpa_students;

-- MySQL does not support RETURNING in DELETE

-- --------------------------------------
-- 4. SELECT Command
-- --------------------------------------

-- 4.1 Basic SELECT
SELECT * FROM academic.students;

-- 4.2 SELECT Specific Columns
SELECT student_id, first_name, email
FROM academic.students;

-- 4.3 SELECT with WHERE Clause
SELECT first_name, last_name, gpa
FROM academic.students
WHERE gpa > 3.5;

-- 4.4 SELECT with JOIN
SELECT s.first_name, s.last_name, c.course_name
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id;

-- 4.5 SELECT with Aggregation
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM academic.students s
JOIN academic.student_courses sc ON s.student_id = sc.student_id
JOIN academic.courses c ON sc.course_id = c.course_id
JOIN academic.departments d ON c.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(s.gpa) > 3.0;

-- 4.6 SELECT with ORDER BY
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY gpa DESC;

-- 4.7 SELECT with LIMIT and OFFSET
SELECT student_id, first_name, gpa
FROM academic.students
ORDER BY gpa DESC
LIMIT 2 OFFSET 0;

-- 4.8 SELECT with Subquery
SELECT first_name, last_name, gpa
FROM academic.students
WHERE gpa > (
    SELECT AVG(gpa) FROM academic.students
);

-- 4.9 SELECT with DISTINCT
SELECT DISTINCT department_name
FROM academic.departments;

-- 4.10 SELECT with CASE
SELECT first_name, gpa,
       CASE 
           WHEN gpa >= 3.7 THEN 'Excellent'
           WHEN gpa >= 3.0 THEN 'Good'
           ELSE 'Needs Improvement'
       END AS performance
FROM academic.students;

-- --------------------------------------
-- End of DML Commands (MySQL Version)
-- --------------------------------------
