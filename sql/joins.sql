-- File: sql_joins.sql
-- Purpose: Demonstrates all types of SQL joins and set operations as per DSMP 2022-23 SQL Joins PDF

-- Sample Tables Used:
-- employees(emp_id, name, department_id, salary)
-- departments(department_id, department_name)
-- projects(project_id, emp_id, project_name)
-- orders(order_id, user_id, city)
-- users(user_id, name, city)
-- categories(category_id, category_name)
-- order_details(order_id, product_id, category_id)

-- --------------------------------------------------
-- 1. INNER JOIN: Returns only matching rows from both tables
-- --------------------------------------------------
SELECT e.emp_id, e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- --------------------------------------------------
-- 2. LEFT JOIN: Returns all rows from the left table and matching from right
-- --------------------------------------------------
SELECT e.emp_id, e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- --------------------------------------------------
-- 3. RIGHT JOIN: Returns all rows from the right table and matching from left
-- --------------------------------------------------
SELECT e.emp_id, e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- --------------------------------------------------
-- 4. FULL OUTER JOIN: Returns all rows from both tables, with NULLs for non-matching
-- (Use UNION for MySQL)
-- --------------------------------------------------
SELECT e.emp_id, e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.emp_id, e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- --------------------------------------------------
-- 5. CROSS JOIN: Cartesian product (all combinations)
-- --------------------------------------------------
SELECT e.name, p.project_name
FROM employees e
CROSS JOIN projects p;

-- --------------------------------------------------
-- 6. SELF JOIN: Joining a table to itself
-- --------------------------------------------------
SELECT A.name AS Employee1, B.name AS Employee2
FROM employees A
JOIN employees B ON A.department_id = B.department_id
WHERE A.emp_id <> B.emp_id;

-- --------------------------------------------------
-- 7. JOINING ON MULTIPLE COLUMNS
-- --------------------------------------------------
SELECT *
FROM employees e
JOIN projects p 
ON e.emp_id = p.emp_id AND e.department_id = p.project_id;

-- --------------------------------------------------
-- 8. JOINING MORE THAN TWO TABLES
-- Example: Find order_id, product category
-- --------------------------------------------------
SELECT o.order_id, c.category_name
FROM order_details od
JOIN categories c ON od.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id;

-- --------------------------------------------------
-- 9. SET OPERATIONS
-- --------------------------------------------------

-- 9.1 UNION: Combines results, removes duplicates
SELECT city FROM users
UNION
SELECT city FROM orders;

-- 9.2 UNION ALL: Combines all results, including duplicates
SELECT city FROM users
UNION ALL
SELECT city FROM orders;

-- 9.3 INTERSECT: Rows common to both (not supported in MySQL directly)
-- For compatible DBs like PostgreSQL or Oracle:
SELECT city FROM users
INTERSECT
SELECT city FROM orders;

-- 9.4 EXCEPT / MINUS: Rows in first but not in second
SELECT city FROM users
EXCEPT
SELECT city FROM orders;

-- --------------------------------------------------
-- 10. FILTERING COLUMNS AND ROWS
-- --------------------------------------------------

-- Filter: Orders placed in Pune
SELECT * FROM orders WHERE city = 'Pune';

-- Filter: Orders under 'Chairs' category
SELECT o.order_id, c.category_name
FROM order_details od
JOIN categories c ON od.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
WHERE c.category_name = 'Chairs';

-- --------------------------------------------------
-- 11. PRACTICE QUERIES
-- --------------------------------------------------

-- 11.1 Most profitable orders
SELECT * FROM orders
ORDER BY profit DESC;

-- 11.2 Customer with max number of orders
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 1;

-- 11.3 Most profitable category
SELECT c.category_name, SUM(o.profit) AS total_profit
FROM order_details od
JOIN categories c ON od.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY c.category_name
ORDER BY total_profit DESC
LIMIT 1;

-- 11.4 Most profitable state (assuming a state column exists)
SELECT state, SUM(profit) AS total_profit
FROM orders
GROUP BY state
ORDER BY total_profit DESC
LIMIT 1;

-- 11.5 Categories with profit > 5000
SELECT c.category_name, SUM(o.profit) AS total_profit
FROM order_details od
JOIN categories c ON od.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY c.category_name
HAVING total_profit > 5000;

-- END OF SQL JOINS DEMO
