-- =====================================================
-- MYSQL DATA TYPES AND DATABASE NORMALIZATION GUIDE
-- =====================================================

-- =====================================================
-- MYSQL DATA TYPES OVERVIEW
-- =====================================================

/*
MySQL supports various data types grouped into several categories:
1. Numeric Data Types
2. String/Text Data Types
3. Date and Time Data Types
4. JSON Data Type
5. Spatial Data Types
*/

-- =====================================================
-- 1. NUMERIC DATA TYPES
-- =====================================================

-- Create a demonstration table for numeric data types
CREATE TABLE numeric_types_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Integer Types
    tiny_int_col TINYINT,           -- Range: -128 to 127 (1 byte)
    small_int_col SMALLINT,         -- Range: -32,768 to 32,767 (2 bytes)
    medium_int_col MEDIUMINT,       -- Range: -8,388,608 to 8,388,607 (3 bytes)
    int_col INT,                    -- Range: -2,147,483,648 to 2,147,483,647 (4 bytes)
    big_int_col BIGINT,             -- Range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (8 bytes)
    
    -- Unsigned Integer Types
    unsigned_tiny TINYINT UNSIGNED, -- Range: 0 to 255
    unsigned_int INT UNSIGNED,      -- Range: 0 to 4,294,967,295
    
    -- Fixed-Point Types
    decimal_col DECIMAL(10,2),      -- Fixed precision: 10 digits total, 2 after decimal
    numeric_col NUMERIC(8,3),       -- Same as DECIMAL
    
    -- Floating-Point Types
    float_col FLOAT,                -- Single precision (4 bytes)
    double_col DOUBLE,              -- Double precision (8 bytes)
    real_col REAL,                  -- Same as DOUBLE
    
    -- Bit Type
    bit_col BIT(8)                  -- Bit field (1 to 64 bits)
);

-- =====================================================
-- 2. STRING/TEXT DATA TYPES
-- =====================================================

-- Create a demonstration table for string data types
CREATE TABLE string_types_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Fixed-Length String
    char_col CHAR(10),              -- Fixed length, max 255 characters
    
    -- Variable-Length String
    varchar_col VARCHAR(255),       -- Variable length, max 65,535 characters
    
    -- Text Types
    tiny_text_col TINYTEXT,         -- Max 255 characters
    text_col TEXT,                  -- Max 65,535 characters
    medium_text_col MEDIUMTEXT,     -- Max 16,777,215 characters
    long_text_col LONGTEXT,         -- Max 4,294,967,295 characters
    
    -- Binary Types
    binary_col BINARY(16),          -- Fixed-length binary data
    varbinary_col VARBINARY(255),   -- Variable-length binary data
    
    -- BLOB Types (Binary Large Objects)
    tiny_blob_col TINYBLOB,         -- Max 255 bytes
    blob_col BLOB,                  -- Max 65,535 bytes
    medium_blob_col MEDIUMBLOB,     -- Max 16,777,215 bytes
    long_blob_col LONGBLOB,         -- Max 4,294,967,295 bytes
    
    -- Enumeration Type
    enum_col ENUM('small', 'medium', 'large', 'extra_large'),
    
    -- Set Type
    set_col SET('read', 'write', 'execute', 'delete')
);

-- =====================================================
-- 3. DATE AND TIME DATA TYPES
-- =====================================================

-- Create a demonstration table for date/time data types
CREATE TABLE datetime_types_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Date Type
    date_col DATE,                  -- Format: YYYY-MM-DD (Range: 1000-01-01 to 9999-12-31)
    
    -- Time Type
    time_col TIME,                  -- Format: HH:MM:SS (Range: -838:59:59 to 838:59:59)
    
    -- DateTime Type
    datetime_col DATETIME,          -- Format: YYYY-MM-DD HH:MM:SS (Range: 1000-01-01 00:00:00 to 9999-12-31 23:59:59)
    
    -- Timestamp Type
    timestamp_col TIMESTAMP,        -- Format: YYYY-MM-DD HH:MM:SS (Range: 1970-01-01 00:00:01 to 2038-01-19 03:14:07)
    
    -- Year Type
    year_col YEAR                   -- Format: YYYY (Range: 1901 to 2155)
);

-- =====================================================
-- 4. JSON DATA TYPE
-- =====================================================

-- Create a demonstration table for JSON data type
CREATE TABLE json_demo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_data JSON,                 -- Stores JSON documents
    preferences JSON
);

-- Insert sample JSON data
INSERT INTO json_demo (user_data, preferences) VALUES 
(
    '{"name": "John Doe", "age": 30, "city": "New York"}',
    '{"theme": "dark", "notifications": true, "language": "en"}'
);

-- =====================================================
-- DATA TYPE DESCRIPTIONS AND CHARACTERISTICS
-- =====================================================

/*
NUMERIC DATA TYPES:

1. TINYINT: 
   - Size: 1 byte
   - Range: -128 to 127 (signed), 0 to 255 (unsigned)
   - Use: Small integers, boolean values, status codes

2. SMALLINT:
   - Size: 2 bytes
   - Range: -32,768 to 32,767 (signed), 0 to 65,535 (unsigned)
   - Use: Small to medium integers

3. MEDIUMINT:
   - Size: 3 bytes
   - Range: -8,388,608 to 8,388,607 (signed), 0 to 16,777,215 (unsigned)
   - Use: Medium-sized integers

4. INT/INTEGER:
   - Size: 4 bytes
   - Range: -2,147,483,648 to 2,147,483,647 (signed), 0 to 4,294,967,295 (unsigned)
   - Use: Standard integers, primary keys, counters

5. BIGINT:
   - Size: 8 bytes
   - Range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (signed)
   - Use: Large integers, timestamps, large counters

6. DECIMAL/NUMERIC:
   - Size: Variable (depends on precision)
   - Precision: Exact numeric values
   - Use: Financial calculations, precise decimal values

7. FLOAT:
   - Size: 4 bytes
   - Precision: Approximate (7 decimal digits)
   - Use: Scientific calculations where approximation is acceptable

8. DOUBLE:
   - Size: 8 bytes
   - Precision: Approximate (15-17 decimal digits)
   - Use: High-precision scientific calculations

STRING DATA TYPES:

1. CHAR:
   - Fixed length (0-255 characters)
   - Padded with spaces
   - Use: Fixed-length codes, abbreviations

2. VARCHAR:
   - Variable length (0-65,535 characters)
   - No padding
   - Use: Variable-length text, names, descriptions

3. TEXT Types:
   - TINYTEXT: 0-255 characters
   - TEXT: 0-65,535 characters
   - MEDIUMTEXT: 0-16,777,215 characters
   - LONGTEXT: 0-4,294,967,295 characters
   - Use: Large text content, articles, documents

4. BINARY/VARBINARY:
   - Store binary data
   - Similar to CHAR/VARCHAR but for binary strings
   - Use: Binary data, hashes, encoded data

5. BLOB Types:
   - Store binary large objects
   - Same size limits as TEXT types
   - Use: Images, files, binary documents

6. ENUM:
   - Predefined set of values
   - Stored as integers internally
   - Use: Status fields, categories with fixed options

7. SET:
   - Multiple values from predefined set
   - Stored as bitmask
   - Use: Multiple selections, permissions

DATE/TIME DATA TYPES:

1. DATE:
   - Only date (YYYY-MM-DD)
   - Use: Birth dates, event dates

2. TIME:
   - Only time (HH:MM:SS)
   - Use: Duration, time of day

3. DATETIME:
   - Date and time combined
   - Not affected by timezone
   - Use: Timestamps, event logging

4. TIMESTAMP:
   - Date and time with timezone awareness
   - Automatically updated
   - Use: Record creation/modification times

5. YEAR:
   - Four-digit year
   - Use: Birth years, graduation years
*/

-- =====================================================
-- DATABASE NORMALIZATION
-- =====================================================

/*
NORMALIZATION:
Database normalization is the process of organizing data in a database to reduce 
redundancy and improve data integrity. It involves decomposing tables to eliminate 
data redundancy and undesirable characteristics like insertion, update, and deletion anomalies.

OBJECTIVES OF NORMALIZATION:
1. Eliminate redundant data
2. Ensure data dependencies make sense
3. Reduce storage space
4. Prevent data anomalies
5. Ensure referential integrity
*/

-- =====================================================
-- UNNORMALIZED TABLE EXAMPLE
-- =====================================================

-- Example of an unnormalized table with multiple issues
CREATE TABLE unnormalized_student_courses (
    student_id INT,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_phone VARCHAR(15),
    student_address TEXT,
    course_id1 INT,
    course_name1 VARCHAR(100),
    course_credits1 INT,
    instructor1 VARCHAR(100),
    course_id2 INT,
    course_name2 VARCHAR(100),
    course_credits2 INT,
    instructor2 VARCHAR(100),
    course_id3 INT,
    course_name3 VARCHAR(100),
    course_credits3 INT,
    instructor3 VARCHAR(100)
);

-- =====================================================
-- FIRST NORMAL FORM (1NF)
-- =====================================================

/*
FIRST NORMAL FORM (1NF) RULES:
1. Each table cell should contain a single value
2. Each record needs to be unique
3. No repeating groups or arrays
4. All entries in a column must be of the same data type
*/

-- Converting to 1NF: Eliminate repeating groups
CREATE TABLE first_nf_student_courses (
    student_id INT,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_phone VARCHAR(15),
    student_address TEXT,
    course_id INT,
    course_name VARCHAR(100),
    course_credits INT,
    instructor VARCHAR(100),
    PRIMARY KEY (student_id, course_id)
);

-- Sample data for 1NF
INSERT INTO first_nf_student_courses VALUES
(1, 'John Doe', 'john@email.com', '123-456-7890', '123 Main St', 101, 'Database Systems', 3, 'Dr. Smith'),
(1, 'John Doe', 'john@email.com', '123-456-7890', '123 Main St', 102, 'Data Structures', 4, 'Dr. Johnson'),
(2, 'Jane Smith', 'jane@email.com', '098-765-4321', '456 Oak Ave', 101, 'Database Systems', 3, 'Dr. Smith'),
(2, 'Jane Smith', 'jane@email.com', '098-765-4321', '456 Oak Ave', 103, 'Web Development', 3, 'Dr. Brown');

-- =====================================================
-- SECOND NORMAL FORM (2NF)
-- =====================================================

/*
SECOND NORMAL FORM (2NF) RULES:
1. Must be in 1NF
2. No partial dependencies on primary key
3. All non-key attributes must be fully functionally dependent on the primary key
*/

-- Converting to 2NF: Remove partial dependencies
CREATE TABLE students_2nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_phone VARCHAR(15),
    student_address TEXT
);

CREATE TABLE courses_2nf (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_credits INT,
    instructor VARCHAR(100)
);

CREATE TABLE student_enrollments_2nf (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_2nf(course_id)
);

-- Sample data for 2NF
INSERT INTO students_2nf VALUES
(1, 'John Doe', 'john@email.com', '123-456-7890', '123 Main St'),
(2, 'Jane Smith', 'jane@email.com', '098-765-4321', '456 Oak Ave');

INSERT INTO courses_2nf VALUES
(101, 'Database Systems', 3, 'Dr. Smith'),
(102, 'Data Structures', 4, 'Dr. Johnson'),
(103, 'Web Development', 3, 'Dr. Brown');

INSERT INTO student_enrollments_2nf VALUES
(1, 101, '2024-01-15', 'A'),
(1, 102, '2024-01-15', 'B+'),
(2, 101, '2024-01-16', 'A-'),
(2, 103, '2024-01-16', 'B');

-- =====================================================
-- THIRD NORMAL FORM (3NF)
-- =====================================================

/*
THIRD NORMAL FORM (3NF) RULES:
1. Must be in 2NF
2. No transitive dependencies
3. Non-key attributes should not depend on other non-key attributes
*/

-- Converting to 3NF: Remove transitive dependencies
CREATE TABLE students_3nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_phone VARCHAR(15),
    student_address TEXT
);

CREATE TABLE instructors_3nf (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100),
    department VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE courses_3nf (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_credits INT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors_3nf(instructor_id)
);

CREATE TABLE student_enrollments_3nf (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_3nf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_3nf(course_id)
);

-- Sample data for 3NF
INSERT INTO instructors_3nf VALUES
(1, 'Dr. Smith', 'Computer Science', 'smith@university.edu'),
(2, 'Dr. Johnson', 'Computer Science', 'johnson@university.edu'),
(3, 'Dr. Brown', 'Information Technology', 'brown@university.edu');

INSERT INTO students_3nf VALUES
(1, 'John Doe', 'john@email.com', '123-456-7890', '123 Main St'),
(2, 'Jane Smith', 'jane@email.com', '098-765-4321', '456 Oak Ave');

INSERT INTO courses_3nf VALUES
(101, 'Database Systems', 3, 1),
(102, 'Data Structures', 4, 2),
(103, 'Web Development', 3, 3);

INSERT INTO student_enrollments_3nf VALUES
(1, 101, '2024-01-15', 'A'),
(1, 102, '2024-01-15', 'B+'),
(2, 101, '2024-01-16', 'A-'),
(2, 103, '2024-01-16', 'B');

-- =====================================================
-- BOYCE-CODD NORMAL FORM (BCNF)
-- =====================================================

/*
BOYCE-CODD NORMAL FORM (BCNF) RULES:
1. Must be in 3NF
2. For every functional dependency X → Y, X must be a candidate key
3. Eliminates all anomalies based on functional dependencies
4. More restrictive than 3NF
*/

-- Example where 3NF table needs BCNF normalization
CREATE TABLE student_advisor_3nf_issue (
    student_id INT,
    course_id INT,
    advisor_id INT,
    advisor_name VARCHAR(100),
    PRIMARY KEY (student_id, course_id)
    -- Issue: advisor_id → advisor_name (non-key determining non-key)
);

-- Converting to BCNF
CREATE TABLE advisors_bcnf (
    advisor_id INT PRIMARY KEY,
    advisor_name VARCHAR(100),
    department VARCHAR(100)
);

CREATE TABLE student_course_advisor_bcnf (
    student_id INT,
    course_id INT,
    advisor_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_3nf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_3nf(course_id),
    FOREIGN KEY (advisor_id) REFERENCES advisors_bcnf(advisor_id)
);

-- =====================================================
-- DATABASE ANOMALIES
-- =====================================================

/*
DATABASE ANOMALIES:
Problems that occur in poorly designed databases due to data redundancy and 
lack of proper normalization.

TYPES OF ANOMALIES:

1. INSERTION ANOMALY:
   - Cannot insert data without having unnecessary or unrelated data
   - Example: Cannot add a new course without enrolling a student

2. UPDATE ANOMALY:
   - Need to update the same information in multiple places
   - Risk of inconsistent data if update is partial
   - Example: Updating instructor name requires changes in multiple records

3. DELETION ANOMALY:
   - Deleting a record causes loss of other valuable information
   - Example: Deleting last student in a course removes course information
*/

-- Example demonstrating anomalies in unnormalized table
CREATE TABLE anomaly_example (
    student_id INT,
    student_name VARCHAR(100),
    course_id INT,
    course_name VARCHAR(100),
    instructor VARCHAR(100),
    instructor_phone VARCHAR(15)
);

INSERT INTO anomaly_example VALUES
(1, 'John Doe', 101, 'Database Systems', 'Dr. Smith', '555-1234'),
(2, 'Jane Smith', 101, 'Database Systems', 'Dr. Smith', '555-1234'),
(3, 'Bob Johnson', 102, 'Data Structures', 'Dr. Jones', '555-5678');

/*
ANOMALY DEMONSTRATIONS:

1. INSERTION ANOMALY:
   - Cannot add new course without enrolling a student
   - Cannot add instructor information without a course assignment

2. UPDATE ANOMALY:
   - If Dr. Smith changes phone number, must update multiple records
   - Risk of inconsistency if some records are missed

3. DELETION ANOMALY:
   - If Bob Johnson drops out, we lose all information about Data Structures course
   - If all students drop Database Systems, we lose Dr. Smith's information
*/

-- =====================================================
-- ADVANTAGES AND DISADVANTAGES OF NORMALIZATION
-- =====================================================

/*
ADVANTAGES OF NORMALIZATION:

1. REDUCED DATA REDUNDANCY:
   - Eliminates duplicate data storage
   - Saves storage space
   - Reduces data inconsistency

2. IMPROVED DATA INTEGRITY:
   - Ensures data accuracy and consistency
   - Reduces chances of data corruption
   - Better referential integrity

3. EASIER MAINTENANCE:
   - Updates need to be made in only one place
   - Reduces the risk of inconsistent data
   - Simplified data modification operations

4. IMPROVED SECURITY:
   - Better access control at table level
   - Sensitive data can be isolated
   - Granular permission management

5. BETTER QUERY PERFORMANCE:
   - Smaller tables mean faster searches
   - More efficient indexing
   - Reduced I/O operations

6. FLEXIBILITY:
   - Easier to modify database structure
   - Better adaptability to changing requirements
   - Supports future enhancements

DISADVANTAGES OF NORMALIZATION:

1. INCREASED COMPLEXITY:
   - More tables to manage
   - Complex relationships between tables
   - Steeper learning curve for developers

2. QUERY COMPLEXITY:
   - Requires more JOIN operations
   - Complex queries for simple data retrieval
   - Potential for slower query performance with many JOINs

3. INCREASED STORAGE OVERHEAD:
   - More primary and foreign keys
   - Additional indexes required
   - Metadata overhead

4. POTENTIAL PERFORMANCE ISSUES:
   - Multiple table joins can be expensive
   - May require query optimization
   - Can impact read-heavy operations

5. DEVELOPMENT TIME:
   - More time to design and implement
   - Additional planning required
   - More complex application code

DISADVANTAGES WITHOUT NORMALIZATION:

1. DATA REDUNDANCY:
   - Same data stored in multiple places
   - Wasted storage space
   - Increased storage costs

2. DATA INCONSISTENCY:
   - Different values for same data item
   - Difficult to maintain data accuracy
   - Unreliable reporting

3. UPDATE ANOMALIES:
   - Must update data in multiple locations
   - Risk of partial updates
   - Data integrity issues

4. INSERT ANOMALIES:
   - Cannot store certain data without other unrelated data
   - Forced to enter dummy or null values
   - Logical data entry issues

5. DELETE ANOMALIES:
   - Loss of valuable data when deleting records
   - Unintended data loss
   - Information preservation issues

6. MAINTENANCE DIFFICULTIES:
   - Hard to modify database structure
   - Difficult to ensure data quality
   - Complex data validation requirements

7. SECURITY CONCERNS:
   - Difficult to implement granular access control
   - Sensitive data mixed with regular data
   - Compliance issues

8. SCALABILITY PROBLEMS:
   - Poor performance with large datasets
   - Difficult to optimize queries
   - Inefficient resource utilization
*/

-- =====================================================
-- PRACTICAL EXAMPLES OF NORMALIZATION BENEFITS
-- =====================================================

-- Example: E-commerce system normalization

-- Unnormalized (Poor Design)
CREATE TABLE orders_unnormalized (
    order_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address TEXT,
    product_name VARCHAR(100),
    product_price DECIMAL(10,2),
    quantity INT,
    total_amount DECIMAL(10,2)
);

-- Normalized (Good Design)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_price DECIMAL(10,2),
    category_id INT,
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================================================
-- SUMMARY
-- =====================================================

/*
NORMALIZATION SUMMARY:

1NF (First Normal Form):
- Eliminate repeating groups
- Each cell contains single value
- Unique records

2NF (Second Normal Form):
- Must be in 1NF
- Remove partial dependencies
- Non-key attributes fully dependent on primary key

3NF (Third Normal Form):
- Must be in 2NF
- Remove transitive dependencies
- Non-key attributes don't depend on other non-key attributes

BCNF (Boyce-Codd Normal Form):
- Must be in 3NF
- Every determinant is a candidate key
- Eliminates all anomalies based on functional dependencies

BEST PRACTICES:
1. Normalize to 3NF for most applications
2. Consider BCNF for critical systems
3. Denormalize selectively for performance when needed
4. Always analyze trade-offs between normalization and performance
5. Use proper indexing strategies
6. Regular database maintenance and optimization
*/