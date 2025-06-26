-- ===============================================================================
-- ADVANCED SQL COMPLETE GUIDE
-- Topics: Stored Procedures, Transactions, Views, Materialized Views, UDFs
-- Database Systems: MySQL 8.0+, Oracle 21c
-- Author: SQL Learning Guide
-- Date: June 2025
-- ===============================================================================

-- This guide provides a comprehensive overview of advanced SQL features,
-- including detailed explanations, advantages, disadvantages, and examples.
-- It is designed for MySQL 8.0+ and Oracle 21c, with specific notes for differences.

-- ===============================================================================
-- TABLE OF CONTENTS
-- 1. Stored Procedures
-- 2. Transactions
-- 3. Views
-- 4. Materialized Views
-- 5. User-Defined Functions (UDFs)
-- ===============================================================================

-- ===============================================================================
-- 1. STORED PROCEDURES
-- ===============================================================================

/*
STORED PROCEDURES OVERVIEW:
A stored procedure is a named block of SQL statements and procedural logic 
stored in the database, executable by users or applications.

ADVANTAGES:
- Improved Performance: Precompiled and optimized by the database
- Enhanced Security: Granular permissions and access control
- Encapsulation: Centralizes complex business logic
- Consistency: Ensures uniform execution of operations
- Reduced Network Traffic: Minimizes data transfer
- Code Reusability: Callable multiple times
- Parameter Support: Handles input and output parameters

DISADVANTAGES:
- Database-Specific: Limited portability across DBMS
- Debugging Complexity: Challenging to troubleshoot
- Version Control Issues: Hard to manage changes
- Limited IDE Support: Fewer development tools available
- Performance Monitoring: Difficult to profile
- Maintenance Overhead: Additional objects to manage
*/

-- Drop existing procedures if they exist to avoid conflicts
DROP PROCEDURE IF EXISTS HelloWorld;
DROP PROCEDURE IF EXISTS CreateNewUser;
DROP PROCEDURE IF EXISTS ShowUserOrders;
DROP PROCEDURE IF EXISTS PlaceOrder;

-- Change delimiter for procedure definitions
DELIMITER //

-- 1.1 Hello World Stored Procedure
CREATE PROCEDURE HelloWorld()
BEGIN
    -- A simple procedure to display a message
    SELECT 'Hello, World! This is my first stored procedure.' AS Message;
END //

-- 1.2 Create New User Stored Procedure
CREATE PROCEDURE CreateNewUser(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    OUT p_user_id INT,
    OUT p_result_message VARCHAR(200)
)
BEGIN
    -- Variables for validation
    DECLARE v_user_exists INT DEFAULT 0;
    DECLARE v_email_exists INT DEFAULT 0;
    
    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result_message = 'Error: Failed to create user due to database error';
        SET p_user_id = -1;
    END;
    
    -- Begin transaction
    START TRANSACTION;
    
    -- Check for existing username
    SELECT COUNT(*) INTO v_user_exists 
    FROM users 
    WHERE username = p_username;
    
    -- Check for existing email
    SELECT COUNT(*) INTO v_email_exists 
    FROM users 
    WHERE email = p_email;
    
    -- Input validation and logic
    IF p_username IS NULL OR p_username = '' THEN
        SET p_result_message = 'Error: Username cannot be empty';
        SET p_user_id = -1;
    ELSEIF p_email IS NULL OR p_email = '' THEN
        SET p_result_message = 'Error: Email cannot be empty';
        SET p_user_id = -1;
    ELSEIF v_user_exists > 0 THEN
        SET p_result_message = 'Error: Username already exists';
        SET p_user_id = -1;
    ELSEIF v_email_exists > 0 THEN
        SET p_result_message = 'Error: Email already exists';
        SET p_user_id = -1;
    ELSE
        -- Insert new user
        INSERT INTO users (username, email, first_name, last_name, created_at)
        VALUES (p_username, p_email, p_first_name, p_last_name, NOW());
        
        -- Retrieve generated ID
        SET p_user_id = LAST_INSERT_ID();
        SET p_result_message = CONCAT('Success: User created with ID ', p_user_id);
        
        -- Commit transaction
        COMMIT;
    END IF;
    
    -- Rollback on error
    IF p_user_id = -1 THEN
        ROLLBACK;
    END IF;
END //

-- 1.3 Show User Orders Stored Procedure
CREATE PROCEDURE ShowUserOrders(
    IN p_user_id INT
)
BEGIN
    -- Variable to check user existence
    DECLARE v_user_exists INT DEFAULT 0;
    
    -- Verify user exists
    SELECT COUNT(*) INTO v_user_exists 
    FROM users 
    WHERE user_id = p_user_id;
    
    -- Logic based on user existence
    IF v_user_exists = 0 THEN
        SELECT 'Error: User not found' AS Error_Message;
    ELSE
        -- Retrieve order details
        SELECT 
            o.order_id,
            o.order_date,
            o.total_amount,
            o.status,
            u.username,
            u.email,
            COUNT(oi.item_id) AS total_items
        FROM orders o
        INNER JOIN users u ON o.user_id = u.user_id
        LEFT JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.user_id = p_user_id
        GROUP BY o.order_id, o.order_date, o.total_amount, o.status, u.username, u.email
        ORDER BY o.order_date DESC;
    END IF;
END //

-- 1.4 Place Order Stored Procedure
CREATE PROCEDURE PlaceOrder(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2),
    OUT p_order_id INT,
    OUT p_result_message VARCHAR(200)
)
BEGIN
    -- Variables for validation
    DECLARE v_user_exists INT DEFAULT 0;
    DECLARE v_product_exists INT DEFAULT 0;
    DECLARE v_stock_available INT DEFAULT 0;
    DECLARE v_total_amount DECIMAL(10,2);
    
    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result_message = 'Error: Failed to place order due to database error';
        SET p_order_id = -1;
    END;
    
    -- Begin transaction
    START TRANSACTION;
    
    -- Check user existence
    SELECT COUNT(*) INTO v_user_exists 
    FROM users 
    WHERE user_id = p_user_id;
    
    -- Check product existence and stock
    SELECT COUNT(*), COALESCE(MAX(stock_quantity), 0) 
    INTO v_product_exists, v_stock_available
    FROM products 
    WHERE product_id = p_product_id;
    
    -- Calculate total amount
    SET v_total_amount = p_quantity * p_unit_price;
    
    -- Validation logic
    IF v_user_exists = 0 THEN
        SET p_result_message = 'Error: User not found';
        SET p_order_id = -1;
        ROLLBACK;
    ELSEIF v_product_exists = 0 THEN
        SET p_result_message = 'Error: Product not found';
        SET p_order_id = -1;
        ROLLBACK;
    ELSEIF p_quantity <= 0 THEN
        SET p_result_message = 'Error: Quantity must be greater than 0';
        SET p_order_id = -1;
        ROLLBACK;
    ELSEIF v_stock_available < p_quantity THEN
        SET p_result_message = CONCAT('Error: Insufficient stock. Available: ', v_stock_available);
        SET p_order_id = -1;
        ROLLBACK;
    ELSE
        -- Insert order
        INSERT INTO orders (user_id, order_date, total_amount, status)
        VALUES (p_user_id, NOW(), v_total_amount, 'PENDING');
        
        -- Get order ID
        SET p_order_id = LAST_INSERT_ID();
        
        -- Insert order items
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);
        
        -- Update stock
        UPDATE products 
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;
        
        -- Success message
        SET p_result_message = CONCAT('Success: Order placed with ID ', p_order_id);
        
        -- Commit transaction
        COMMIT;
    END IF;
END //

-- Reset delimiter
DELIMITER ;

-- Stored Procedure Usage Examples
CALL HelloWorld();

CALL CreateNewUser('john_doe', 'john@example.com', 'John', 'Doe', @user_id, @message);
SELECT @user_id AS User_ID, @message AS Result_Message;

CALL ShowUserOrders(1);

CALL PlaceOrder(1, 101, 2, 25.99, @order_id, @order_message);
SELECT @order_id AS Order_ID, @order_message AS Result_Message;

-- ===============================================================================
-- 2. TRANSACTIONS
-- ===============================================================================

/*
TRANSACTIONS OVERVIEW:
A transaction is a sequence of operations treated as a single unit of work,
following the "all or none" principle to ensure data integrity.

ACID PROPERTIES:
- Atomicity: All operations complete or none do
- Consistency: Database remains in a valid state
- Isolation: Transactions are independent of each other
- Durability: Committed changes are permanently saved

ADVANTAGES:
- Data Integrity: Maintains consistent database state
- Concurrency Control: Manages simultaneous access
- Error Recovery: Allows rollback on failure
- Business Logic Enforcement: Ensures rules are followed
- Performance Optimization: Batches operations

DISADVANTAGES:
- Performance Overhead: Extra processing required
- Lock Contention: May cause blocking or deadlocks
- Memory Usage: Transaction logs consume resources
- Complexity: Requires careful planning
- Recovery Time: Large rollbacks can be slow
*/

-- 2.1 Autocommit Demonstration
SELECT @@autocommit AS Current_Autocommit_Setting;

CREATE TABLE Test_Autocommit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Test_Autocommit (message) VALUES ('This will be automatically committed');
SELECT * FROM Test_Autocommit;

-- 2.2 Disable Autxit and Manual Transaction Control
SET autocommit = 0;
SELECT @@autocommit AS Autocommit_Disabled;

INSERT INTO Test_Autocommit (message) VALUES ('This needs manual commit');
SELECT * FROM Test_Autocommit;

COMMIT;

-- 2.3 Start Transaction Examples
START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('Transaction without commit');
SELECT * FROM Test_Autocommit;
-- No commit; changes lost on session end

START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('Transaction with commit');
INSERT INTO Test_Autocommit (message) VALUES ('Another insert in same transaction');
SELECT * FROM Test_Autocommit;
COMMIT;

START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('First operation');
INSERT INTO Test_Autocommit (message) VALUES ('Second operation');
COMMIT;

-- 2.4 Rollback Examples
START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('This will be rolled back');
SELECT * FROM Test_Autocommit;
ROLLBACK;
SELECT * FROM Test_Autocommit;

-- 2.5 Savepoint Examples
START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('Before savepoint');
SAVEPOINT sp1;
INSERT INTO Test_Autocommit (message) VALUES ('After savepoint');
INSERT INTO Test_Autocommit (message) VALUES ('Another after savepoint');
ROLLBACK TO SAVEPOINT sp1;
COMMIT;
SELECT * FROM Test_Autocommit WHERE message LIKE '%savepoint%';

-- 2.6 Rollback and Commit Together
START TRANSACTION;
INSERT INTO Test_Autocommit (message) VALUES ('Step 1 - Will be kept');
SAVEPOINT step1;
INSERT INTO Test_Autocommit (message) VALUES ('Step 2 - Will be rolled back');
INSERT INTO Test_Autocommit (message) VALUES ('Step 3 - Will be rolled back');
ROLLBACK TO SAVEPOINT step1;
INSERT INTO Test_Autocommit (message) VALUES ('Step 4 - After rollback');
COMMIT;
SELECT * FROM Test_Autocommit WHERE message LIKE 'Step%' ORDER BY id;

-- 2.7 Cleanup
SET autocommit = 1;
DROP TABLE IF EXISTS Test_Autocommit;

-- ===============================================================================
-- 3. VIEWS
-- ===============================================================================

/*
VIEWS OVERVIEW:
A view is a virtual table derived from an SQL query, presenting data like a 
real table without physically storing it. Views are dynamically updated 
when queried, reflecting changes in underlying tables.

ADVANTAGES:
- Data Security: Masks sensitive data
- Query Simplification: Simplifies complex queries
- Data Abstraction: Hides database complexity
- Consistent Interface: Stable despite table changes
- Access Control: Limits data per user role
- Code Reusability: Shares common queries

DISADVANTAGES:
- Performance Overhead: Executes query each time
- Update Limitations: Not all views are updatable
- Dependency Issues: Affected by base table changes
- Debugging Complexity: Harder to optimize
- No Indexing: Direct indexes not possible
- Memory Usage: Complex views use resources

EXECUTION NOTE:
Querying a view is identical to querying a table; the database engine 
processes it transparently.
*/

-- Create sample tables
CREATE TABLE IF NOT EXISTS Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    position VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- Insert sample data
INSERT INTO Departments (dept_name, location, budget) VALUES
('Human Resources', 'New York', 500000.00),
('Information Technology', 'San Francisco', 1200000.00),
('Finance', 'Chicago', 800000.00),
('Marketing', 'Los Angeles', 600000.00);

INSERT INTO Employees (emp_name, dept_id, salary, hire_date, position) VALUES
('John Smith', 1, 55000.00, '2020-01-15', 'HR Manager'),
('Jane Doe', 2, 85000.00, '2019-03-22', 'Senior Developer'),
('Mike Johnson', 2, 75000.00, '2021-06-10', 'Database Administrator'),
('Sarah Wilson', 3, 65000.00, '2020-11-05', 'Financial Analyst'),
('David Brown', 4, 60000.00, '2022-02-14', 'Marketing Specialist');

-- 3.1 Simple View
CREATE VIEW Vw_Employee_Basic AS
SELECT 
    emp_id,
    emp_name,
    position,
    hire_date
FROM Employees;

SELECT * FROM Vw_Employee_Basic;
SELECT emp_name, position FROM Vw_Employee_Basic WHERE emp_id = 1;

-- 3.2 Complex View with Joins
CREATE VIEW Vw_Employee_Department_Details AS
SELECT 
    e.emp_id,
    e.emp_name,
    e.position,
    e.salary,
    e.hire_date,
    d.dept_name,
    d.location,
    d.budget,
    ROUND((e.salary / d.budget) * 100, 2) AS Salary_Budget_Percentage,
    DATEDIFF(CURDATE(), e.hire_date) AS Days_Employed,
    CASE 
        WHEN e.salary >= 80000 THEN 'Senior'
        WHEN e.salary >= 60000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS Salary_Grade
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id;

SELECT * FROM Vw_Employee_Department_Details;
SELECT emp_name, dept_name, Salary_Grade FROM Vw_Employee_Department_Details 
WHERE Salary_Grade = 'Senior';

-- 3.3 Aggregate View
CREATE VIEW Vw_Department_Summary AS
SELECT 
    d.dept_id,
    d.dept_name,
    d.location,
    d.budget,
    COUNT(e.emp_id) AS Employee_Count,
    COALESCE(AVG(e.salary), 0) AS Avg_Salary,
    COALESCE(SUM(e.salary), 0) AS Total_Salaries,
    COALESCE(MAX(e.salary), 0) AS Highest_Salary,
    COALESCE(MIN(e.salary), 0) AS Lowest_Salary
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name, d.location, d.budget;

SELECT * FROM Vw_Department_Summary;
SELECT dept_name, Employee_Count, Avg_Salary FROM Vw_Department_Summary 
ORDER BY Avg_Salary DESC;

-- 3.4 View Update Mechanism
/*
UPDATABLE VIEWS:
Views are updatable if they:
- Reference one table
- Exclude aggregates, DISTINCT, GROUP BY, HAVING
- Avoid subqueries in SELECT
- Include all NOT NULL columns
*/
SELECT * FROM Vw_Employee_Basic WHERE emp_id = 1;
UPDATE Employees SET emp_name = 'John Smith Updated' WHERE emp_id = 1;
SELECT * FROM Vw_Employee_Basic WHERE emp_id = 1;

UPDATE Vw_Employee_Basic SET emp_name = 'John Smith Final' WHERE emp_id = 1;
SELECT * FROM Vw_Employee_Basic WHERE emp_id = 1;
SELECT * FROM Employees WHERE emp_id = 1;

-- 3.5 View Security Example
CREATE VIEW Vw_Employee_Public AS
SELECT 
    emp_id,
    emp_name,
    position,
    hire_date,
    CASE 
        WHEN salary >= 80000 THEN 'High'
        WHEN salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS Salary_Range
FROM Employees;

SELECT * FROM Vw_Employee_Public;

-- ===============================================================================
-- 4. MATERIALIZED VIEWS
-- ===============================================================================

/*
MATERIALIZED VIEWS OVERVIEW:
A materialized view physically stores query results, unlike regular views, 
improving performance for complex queries by caching data.

MYSQL NOTE:
MySQL lacks native materialized views; we simulate them with tables and 
triggers or procedures.

ORACLE 21C NOTE:
Oracle supports materialized views natively with advanced refresh options.

ADVANTAGES:
- Query Performance: Precomputed results
- CPU Efficiency: Reduces query execution
- Network Efficiency: Less data transfer
- Snapshot Isolation: Point-in-time data
- Offline Availability: Data persists

DISADVANTAGES:
- Storage Overhead: Requires extra space
- Refresh Complexity: Data freshness management
- Update Lag: Possible staleness
- Maintenance Cost: Additional objects
- Synchronization Issues: Risk of inconsistency
- Resource Intensive: Refresh can be costly
*/

-- 4.1 MySQL Materialized View Simulation
CREATE TABLE Mv_Department_Statistics (
    dept_id INT,
    dept_name VARCHAR(50),
    employee_count INT,
    avg_salary DECIMAL(10,2),
    total_salaries DECIMAL(12,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (dept_id)
);

DELIMITER //
CREATE PROCEDURE RefreshDepartmentStatistics()
BEGIN
    DELETE FROM Mv_Department_Statistics;
    INSERT INTO Mv_Department_Statistics (dept_id, dept_name, employee_count, avg_salary, total_salaries)
    SELECT 
        d.dept_id,
        d.dept_name,
        COUNT(e.emp_id) AS Employee_Count,
        COALESCE(AVG(e.salary), 0) AS Avg_Salary,
        COALESCE(SUM(e.salary), 0) AS Total_Salaries
    FROM Departments d
    LEFT JOIN Employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.dept_name;
END //
DELIMITER ;

CALL RefreshDepartmentStatistics();
SELECT * FROM Mv_Department_Statistics;

-- 4.2 MySQL Trigger-Based Refresh
DELIMITER //

CREATE TRIGGER Tr_Employee_Insert_Mv 
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    CALL RefreshDepartmentStatistics();
END //

CREATE TRIGGER Tr_Employee_Update_Mv 
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    CALL RefreshDepartmentStatistics();
END //

CREATE TRIGGER Tr_Employee_Delete_Mv 
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    CALL RefreshDepartmentStatistics();
END //

DELIMITER ;

INSERT INTO Employees (emp_name, dept_id, salary, hire_date, position) 
VALUES ('New Employee', 1, 50000.00, CURDATE(), 'Assistant');
SELECT * FROM Mv_Department_Statistics WHERE dept_id = 1;

-- 4.3 Oracle 21c Materialized Views (Reference Only)
/*
CREATE MATERIALIZED VIEW Mv_Emp_Dept_Oracle
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT 
    e.emp_id,
    e.emp_name,
    e.salary,
    d.dept_name,
    d.location
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

CREATE MATERIALIZED VIEW Mv_Dept_Summary_Oracle
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
START WITH SYSDATE
NEXT SYSDATE + 1/24
AS
SELECT 
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS Employee_Count,
    AVG(e.salary) AS Avg_Salary
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

EXEC DBMS_MVIEW.REFRESH('Mv_Dept_Summary_Oracle', 'C');

CREATE MATERIALIZED VIEW LOG ON Employees
WITH ROWID, SEQUENCE (emp_id, emp_name, salary, dept_id)
INCLUDING NEW VALUES;
*/

-- ===============================================================================
-- 5. USER-DEFINED FUNCTIONS (UDFs)
-- ===============================================================================

/*
UDFs OVERVIEW:
User-defined functions are custom routines that encapsulate logic for reuse 
across queries, returning scalar values or performing calculations.

ADVANTAGES:
- Code Reusability: Single definition, multiple uses
- Modularity: Simplifies complex logic
- Maintainability: Centralizes logic
- Performance: Optimized execution
- Type Safety: Enforces parameter types
- Consistency: Uniform results

DISADVANTAGES:
- Debugging Complexity: Harder to trace
- Performance Overhead: Function call cost
- Database Dependency: Vendor-specific
- Limited Functionality: Restricted scope
- Version Control: Change tracking issues
- Testing Challenges: Needs DB tools
*/

-- Drop existing functions
DROP FUNCTION IF EXISTS CalculateAge;
DROP FUNCTION IF EXISTS FormatCurrency;
DROP FUNCTION IF EXISTS GetEmployeeGrade;
DROP FUNCTION IF EXISTS CalculateBonus;

-- 5.1 Scalar Functions
DELIMITER //

CREATE FUNCTION CalculateAge(birth_date DATE)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE age INT;
    SET age = FLOOR(DATEDIFF(CURDATE(), birth_date) / 365.25);
    RETURN age;
END //

CREATE FUNCTION FormatCurrency(amount DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CONCAT('$', FORMAT(amount, 2));
END //

CREATE FUNCTION GetEmployeeGrade(salary DECIMAL(10,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(10);
    IF salary >= 80000 THEN
        SET grade = 'A';
    ELSEIF salary >= 60000 THEN
        SET grade = 'B';
    ELSEIF salary >= 40000 THEN
        SET grade = 'C';
    ELSE
        SET grade = 'D';
    END IF;
    RETURN grade;
END //

CREATE FUNCTION CalculateBonus(
    salary DECIMAL(10,2), 
    performance_rating DECIMAL(3,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bonus DECIMAL(10,2);
    DECLARE bonus_percentage DECIMAL(5,4);
    IF performance_rating >= 4.5 THEN
        SET bonus_percentage = 0.15;
    ELSEIF performance_rating >= 3.5 THEN
        SET bonus_percentage = 0.10;
    ELSEIF performance_rating >= 2.5 THEN
        SET bonus_percentage = 0.05;
    ELSE
        SET bonus_percentage = 0.00;
    END IF;
    SET bonus = salary * bonus_percentage;
    RETURN bonus;
END //

DELIMITER ;

-- 5.2 Using UDFs
ALTER TABLE Employees ADD COLUMN birth_date DATE;
ALTER TABLE Employees ADD COLUMN performance_rating DECIMAL(3,2) DEFAULT 3.0;

UPDATE Employees SET birth_date = '1985-05-15', performance_rating = 4.2 WHERE emp_id = 1;
UPDATE Employees SET birth_date = '1988-09-22', performance_rating = 4.8 WHERE emp_id = 2;
UPDATE Employees SET birth_date = '1990-12-10', performance_rating = 3.8 WHERE emp_id = 3;
UPDATE Employees SET birth_date = '1987-03-18', performance_rating = 3.2 WHERE emp_id = 4;
UPDATE Employees SET birth_date = '1992-11-25', performance_rating = 2.8 WHERE emp_id = 5;

SELECT 
    emp_name,
    salary,
    FormatCurrency(salary) AS Formatted_Salary,
    CalculateAge(birth_date) AS Age,
    GetEmployeeGrade(salary) AS Grade,
    performance_rating,
    FormatCurrency(CalculateBonus(salary, performance_rating)) AS Bonus
FROM Employees;

-- ===============================================================================
-- END OF GUIDE
-- Save this file as 'Advanced_SQL_Guide.sql' for reference and execution.
-- ===============================================================================