-- File: freedom_ranking_analysis.sql
-- Dataset: Freedom Ranking for Different Countries
-- Source: https://drive.google.com/drive/folders/1wr0J571rlfexEJ4-de6_tz1QvU-cJ0df?usp=share_link

-- --------------------------------------------------------
-- ✅ Q-1:
-- Find out the top 10 countries which have maximum values 
-- in both 'A' (Electoral Process) and 'D' (Freedom of Expression and Belief).
-- Display country names and their A and D values.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    ab.Country,
    ab.A,
    cd.D
FROM country_ab ab
JOIN country_cd cd 
    ON ab.Country = cd.Country AND ab.Edition = cd.Edition
ORDER BY ab.A DESC, cd.D DESC
LIMIT 10;

-- --------------------------------------------------------
-- ✅ Q-2:
-- Find the highest CL (Civil Liberties) value for the year 2020
-- for every region.
-- Sort the result in descending order by CL value.
-- Also display CL values in descending order.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    efg.Region,
    MAX(cl.CL) AS civil_liberty
FROM country_cl cl
JOIN country_efg efg 
    ON cl.Country = efg.Country AND cl.Edition = efg.Edition
WHERE cl.Edition = 2020
GROUP BY efg.Region
ORDER BY civil_liberty DESC;

-- File: sales_analysis_questions.sql
-- Purpose: SQL query space for Sales Dataset
-- Dataset: https://drive.google.com/drive/folders/1bGgNTDy5L_IodNcGHdB_SNCkUI5MUjmY?usp=share_link

-- Tables:
-- * Customer
-- * Employee
-- * Sales
-- * Products

-- --------------------------------------------------------
-- ✅ Q-3:
-- Find top 5 most sold products.
-- (Use sales quantity to determine most sold products)
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    pd.Name AS product_name,
    SUM(sl.Quantity) AS quantity_sum
FROM sales sl
JOIN products pd
    ON sl.ProductID = pd.ProductID
GROUP BY pd.Name
ORDER BY quantity_sum DESC
LIMIT 5;



-- --------------------------------------------------------
-- ✅ Q-4:
-- Find the salesperson who sold the most number of products.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    emp.FirstName,
    emp.LastName,
    SUM(sl.Quantity) AS quantity_sum
FROM sales sl
JOIN employees emp
    ON sl.SalesPersonID = emp.EmployeeID
GROUP BY emp.EmployeeID
ORDER BY quantity_sum DESC
LIMIT 1;



-- --------------------------------------------------------
-- ✅ Q-5:
-- Salesperson name who has the most number of unique customers.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    emp.FirstName,
    emp.LastName,
    COUNT(DISTINCT sl.CustomerID) AS unique_customers
FROM sales sl
JOIN customers cst
    ON sl.CustomerID = cst.CustomerID
JOIN employees emp
    ON emp.EmployeeID = sl.SalesPersonID 
GROUP BY emp.EmployeeID
ORDER BY unique_customers DESC
LIMIT 1;


-- --------------------------------------------------------
-- ✅ Q-6:
-- Salesperson who has generated the most revenue.
-- Show top 5.
-- (Revenue = quantity * product price)
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    emp.FirstName,
    emp.LastName,
    ROUND(SUM(sl.Quantity * pd.Price),2) AS revenue
FROM sales sl
JOIN products pd
    ON sl.ProductID = pd.ProductID
JOIN employees emp
    ON emp.EmployeeID = sl.SalesPersonID 
GROUP BY emp.EmployeeID
ORDER BY revenue DESC 
LIMIT 5;


-- --------------------------------------------------------
-- ✅ Q-7:
-- List all customers who have made more than 10 purchases.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    cst.FirstName,
    cst.LastName,
    count(*) AS no_purchase
FROM customers cst
JOIN sales sl
    ON sl.CustomerID = cst.CustomerID 
GROUP BY cst.FirstName,cst.LastName
HAVING no_purchase > 10;



-- --------------------------------------------------------
-- ✅ Q-8:
-- List all salespeople who have made sales to more than 5 customers.
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    sl.SalesPersonID,
    emp.FirstName,
    emp.LastName,
    count(DISTINCT sl.CustomerID) AS unique_customers
FROM sales sl
JOIN employees emp
    ON sl.SalesPersonID = emp.EmployeeID
GROUP BY sl.SalesPersonID
HAVING unique_customers > 5;



-- --------------------------------------------------------
-- ✅ Q-9:
-- List all pairs of customers who have made purchases with the same salesperson.
-- (Each pair should share at least one common salesperson)
-- --------------------------------------------------------
-- ANSWER:
--
SELECT 
    sl1.SalesPersonID,
    sl1.CustomerID AS Customer1,
    sl2.CustomerID AS Customer2,
    COUNT(*) AS pair_count
FROM sales sl1
JOIN sales sl2
    ON sl1.SalesPersonID = sl2.SalesPersonID
    AND sl1.CustomerID < sl2.CustomerID   -- Avoids (C2,C1) duplicates and self-pairs
GROUP BY 
    sl1.SalesPersonID, sl1.CustomerID, sl2.CustomerID
ORDER BY 
    pair_count DESC;