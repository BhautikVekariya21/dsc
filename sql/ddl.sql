-- File: ddl.sql
-- Purpose: Demonstrates all DDL commands in MySQL with named PRIMARY KEY constraints using CONSTRAINT syntax

-- --------------------------------------
-- 1. CREATE Command
-- --------------------------------------

-- 1.1 CREATE DATABASE
CREATE DATABASE school_db;

-- 1.2 USE DATABASE
USE school_db;

-- 1.3 CREATE TABLE
CREATE TABLE school_db.students
(
    student_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    gpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT student_pk PRIMARY KEY (student_id),
    CONSTRAINT chk_gpa CHECK (gpa >= 0 AND gpa <= 4.0)
);

-- 1.4 CREATE TABLE with Composite Primary Key
CREATE TABLE school_db.student_courses
(
    student_id INT,
    course_id INT,
    enrollment_date DATE NOT NULL,
    CONSTRAINT student_course_pk PRIMARY KEY (student_id, course_id)
);

-- 1.5 CREATE TABLE with FOREIGN KEY
CREATE TABLE school_db.departments
(
    department_id INT NOT NULL,
    department_name VARCHAR(100) UNIQUE,
    CONSTRAINT department_pk PRIMARY KEY (department_id)
);

CREATE TABLE school_db.courses
(
    course_id INT NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    CONSTRAINT course_pk PRIMARY KEY (course_id),
    CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES school_db.departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 1.6 CREATE INDEX
CREATE INDEX idx_student_email ON school_db.students(email);

-- 1.7 CREATE UNIQUE INDEX
CREATE UNIQUE INDEX idx_unique_course_name ON school_db.courses(course_name);

-- 1.8 CREATE VIEW
CREATE VIEW school_db.student_summary
AS
    SELECT student_id, first_name, last_name, email
    FROM school_db.students
    WHERE gpa > 3.0;

-- --------------------------------------
-- 2. ALTER Command
-- --------------------------------------

-- 2.1 Add Column
ALTER TABLE school_db.students
ADD phone_number VARCHAR(15);

-- 2.2 Modify Column
ALTER TABLE school_db.students
MODIFY phone_number VARCHAR
(20);

-- 2.3 Drop Column
ALTER TABLE school_db.students
DROP COLUMN phone_number;

-- 2.4 Add Constraint
ALTER TABLE school_db.students
ADD CONSTRAINT chk_email_format CHECK (email
REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- 2.5 Drop Constraint
ALTER TABLE school_db.students
DROP CHECK chk_email_format;

-- 2.6 Rename Column
ALTER TABLE school_db.students
CHANGE email email_address VARCHAR
(100) UNIQUE;

-- 2.7 Rename Table
RENAME TABLE school_db.students TO school_db.student_records;

-- 2.8 Add Primary Key
ALTER TABLE school_db.courses
ADD CONSTRAINT course_pk PRIMARY KEY (course_id);

-- 2.9 Add Foreign Key
ALTER TABLE school_db.student_courses
ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES school_db.student_records(student_id);

-- --------------------------------------
-- 3. DROP Command
-- --------------------------------------

-- 3.1 DROP TABLE
DROP TABLE IF EXISTS school_db.student_courses;

-- 3.2 DROP INDEX
DROP INDEX idx_student_email ON school_db.students;

-- 3.3 DROP DATABASE
DROP DATABASE IF EXISTS school_db;

-- 3.4 DROP VIEW
DROP VIEW IF EXISTS school_db.student_summary;

-- 3.5 DROP CONSTRAINT
ALTER TABLE school_db.student_records
DROP CHECK chk_email_format;

-- --------------------------------------
-- 4. TRUNCATE Command
-- --------------------------------------

-- 4.1 TRUNCATE TABLE
TRUNCATE TABLE school_db.student_records;

-- 4.2 TRUNCATE with CASCADE
SET FOREIGN_KEY_CHECKS
= 0;
TRUNCATE TABLE school_db.student_records;
SET FOREIGN_KEY_CHECKS
= 1;

-- --------------------------------------
-- 5. Constraints in Detail
-- --------------------------------------

-- 5.1 NOT NULL Constraint
CREATE TABLE school_db.teachers
(
    teacher_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    CONSTRAINT teacher_pk PRIMARY KEY (teacher_id)
);

-- 5.3 PRIMARY KEY Constraint
CREATE TABLE school_db.classes
(
    class_id INT,
    course_id INT NOT NULL,
    class_room VARCHAR(10),
    CONSTRAINT class_pk PRIMARY KEY (class_id)
);

-- 5.4 FOREIGN KEY Constraint
CREATE TABLE school_db.class_schedule
(
    schedule_id INT NOT NULL,
    class_id INT,
    day_of_week VARCHAR(10),
    CONSTRAINT schedule_pk PRIMARY KEY (schedule_id),
    CONSTRAINT fk_class FOREIGN KEY (class_id) REFERENCES school_db.classes(class_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5.5 CHECK Constraint
CREATE TABLE school_db.exams
(
    exam_id INT NOT NULL,
    course_id INT,
    exam_date DATE,
    max_score INT,
    CONSTRAINT chk_max_score CHECK (max_score <= 100),
    CONSTRAINT exam_pk PRIMARY KEY (exam_id)
);

-- 5.6 DEFAULT Constraint
CREATE TABLE school_db.attendance
(
    attendance_id INT NOT NULL,
    student_id INT,
    class_id INT,
    attendance_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(10) DEFAULT 'Present',
    CONSTRAINT attendance_pk PRIMARY KEY (attendance_id)
);

-- --------------------------------------
-- 6. Additional CREATE Variations
-- --------------------------------------

-- 6.1 CREATE TABLE AS (via SELECT)
CREATE TABLE school_db.high_gpa_students AS
SELECT student_id, first_name, last_name, gpa
FROM school_db.student_records
WHERE gpa > 3.5;

-- 6.2 CREATE TEMPORARY TABLE
CREATE TEMPORARY TABLE school_db.temp_student
(
    student_id INT NOT NULL,
    first_name VARCHAR
(50),
    CONSTRAINT temp_student_pk PRIMARY KEY
(student_id)
);

-- 6.4 CREATE SEQUENCE (MySQL uses AUTO_INCREMENT instead)
CREATE TABLE school_db.new_students
(
    student_id INT NOT NULL
    AUTO_INCREMENT,
    first_name VARCHAR
    (50),
    CONSTRAINT new_student_pk PRIMARY KEY
    (student_id)
);

-- --------------------------------------
-- End of MySQL-Compatible DDL Commands
-- --------------------------------------
