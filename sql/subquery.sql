-- SQL Subquery Practice Questions
-- ===============================

-- IMPORTANT NOTES:
-- * A subquery is a SELECT statement nested inside another SELECT, INSERT, UPDATE, or DELETE statement
-- * The subquery is executed first, and its result is used as a parameter or condition for the outer query
-- * This topic is slightly difficult and needs a lot of practice
-- * The scope of inner query determines how it interacts with the outer query

-- TYPES OF SUBQUERIES:
-- 1. Based on the result it returns: Scalar, Row, Table
-- 2. Based on working: Independent, Correlated

-- WHERE CAN SUBQUERIES BE USED:
-- SELECT, FROM, WHERE, HAVING, INSERT, UPDATE, DELETE

-- ===============================
-- INDEPENDENT SUBQUERY - SCALAR SUBQUERY
-- ===============================

-- 1. Find the movie with highest profit (vs ORDER BY)
-- Question: Write a query to find the movie with the highest profit using subquery
-- Answer:
SELECT
    *
FROM movies
WHERE gross - budget = (
    SELECT MAX(gross - budget)
FROM movies
);

-- 2. Find how many movies have a rating > the avg of all the movie ratings (Find the count of above average movies)
-- Question: Count movies with rating above average using subquery
-- Answer:
SELECT
    COUNT(*)
FROM movies
WHERE votes > (
    SELECT AVG(votes)
FROM movies
);

-- 3. Find the highest rated movie of 2000
-- Question: Find the movie with highest rating specifically from year 2000
-- Answer:
SELECT
    *
FROM movies
WHERE votes = (
    SELECT MAX(votes)
FROM movies
WHERE year = 2000
);

-- 4. Find the highest rated movie among all movies whose number of votes are > the dataset avg votes
-- Question: Find highest rated movie where votes > average votes of all movies
-- Answer:
SELECT
    *
FROM movies
WHERE votes = (
    SELECT MAX(votes)
FROM movies
WHERE votes > (
        SELECT AVG(votes)
FROM movies
    )
);

-- ===============================
-- INDEPENDENT SUBQUERY - ROW SUBQUERY (One Col Multi Rows)
-- ===============================

-- 5. Find all users who never ordered
-- Question: Find users who have no orders using subquery
-- Answer:
SELECT
    *
FROM users
WHERE user_id NOT IN (
    SELECT user_id
FROM orders
);

-- 6. Find all the movies made by top 3 directors (in terms of total gross income)
-- Question: Get movies by the 3 directors with highest total gross income
-- Answer:
WITH
    ranked_directors
    AS
    (
        SELECT director, SUM(gross) AS total_gross
        FROM movies
        GROUP BY director
    ),
    top3
    AS
    (
        SELECT director
        FROM ranked_directors
        ORDER BY total_gross DESC
    LIMIT 3
)
SELECT *
FROM movies
    
    
    
    
    
WHERE director IN
(SELECT director
FROM top3);

-- 7. Find all movies of all those actors whose filmography's avg rating > 8.5 (take 25000 votes as cutoff)
-- Question: Find movies of actors whose average rating > 8.5 with vote cutoff of 25000
-- Answer:
SELECT *
FROM movies
WHERE star IN (
    SELECT star
FROM movies
WHERE votes > 25000
GROUP BY star
HAVING AVG(score) > 8.5
);

-- ===============================
-- INDEPENDENT SUBQUERY - TABLE SUBQUERY (Multi Col Multi Row)
-- ===============================

-- 8. Find the most profitable movie of each year
-- Question: Get the highest profit movie for each year using subquery
-- Answer:
SELECT *
FROM movies
WHERE (year, gross - budget) IN (
    SELECT year,
    MAX(gross - budget)
FROM movies
GROUP BY year
);

-- 9. Find the highest rated movie of each genre (votes cutoff of 25000)
-- Question: Find top rated movie per genre with minimum 25000 votes
-- Answer:
SELECT *
FROM movies
WHERE (genre, score) IN (
    SELECT genre,
    MAX(score)
FROM movies
WHERE votes > 25000
GROUP BY genre
);

-- 10. Find the highest grossing movies of top 5 actor/director combo in terms of total gross income
-- Question: Get highest grossing movies from top 5 actor-director combinations
-- Answer:
WITH
    top5_combos
    AS
    (
        SELECT star, director, SUM(gross) AS total_gross
        FROM movies
        GROUP BY star, director
        ORDER BY total_gross DESC
    LIMIT 5
)
SELECT *
FROM movies
    
    
WHERE
(star, director) IN
(
    SELECT star, director
FROM top5_combos
);

-- ===============================
-- CORRELATED SUBQUERY
-- ===============================

-- 11. Find all the movies that have a rating higher than the average rating of movies in the same genre
-- Question: Find movies with rating > average rating of their genre
-- Answer:
SELECT *
FROM movies AS m1
WHERE score > (
    SELECT AVG(score)
FROM movies AS m2
WHERE m2.genre = m1.genre
);

-- 12. Find the favorite food of each customer
-- Question: Determine each customer's most ordered food item
-- Answer:
WITH
    customer_food_frequency
    AS
    (
        SELECT
            u.user_id,
            u.name AS customer_name,
            f.f_id,
            f.f_name,
            COUNT(*) AS order_frequency
        FROM orders o
            JOIN order_details od ON od.order_id = o.order_id
            JOIN users u ON u.user_id = o.user_id
            JOIN food f ON f.f_id = od.f_id
        GROUP BY u.user_id, u.name, f.f_id, f.f_name
    )
SELECT *
FROM customer_food_frequency AS cff1
WHERE order_frequency = (
    SELECT MAX(order_frequency)
FROM customer_food_frequency AS cff2
WHERE cff2.user_id = cff1.user_id
);

-- ===============================
-- USAGE WITH SELECT
-- ===============================

-- 13. Get the percentage of votes for each movie compared to the total number of votes
-- Question: Calculate vote percentage for each movie relative to total votes
-- Answer:
SELECT
    name,
    votes,
    ROUND((votes * 100.0 / (SELECT SUM(votes)
    FROM movies)), 2) AS vote_percentage
FROM movies
ORDER BY vote_percentage DESC;

-- 14. Display all movie names, genre, score and avg(score) of genre
-- Question: Show movie details with genre average score (Why is this inefficient?)
-- Answer:
SELECT
    name,
    genre,
    score,
    (SELECT AVG(score)
    FROM movies m2
    WHERE m2.genre = m1.genre) AS genre_avg_score
FROM movies m1
ORDER BY genre, score DESC;

-- More efficient approach using window function:
-- SELECT 
--     name,
--     genre,
--     score,
--     AVG(score) OVER (PARTITION BY genre) AS genre_avg_score
-- FROM movies
-- ORDER BY genre, score DESC;

-- ===============================
-- USAGE WITH FROM
-- ===============================

-- 15. Display average rating of all the restaurants
-- Question: Show average rating across all restaurants using subquery in FROM
-- Answer:
SELECT
    r_name,
    ROUND(avg_rating, 2) AS average_rating
FROM (
    SELECT
        r.r_name,
        AVG(o.restaurant_rating) AS avg_rating
    FROM orders o
        JOIN restaurants r ON o.r_id = r.r_id
    GROUP BY r.r_name
) AS restaurant_ratings
ORDER BY average_rating DESC;

-- ===============================
-- USAGE WITH HAVING
-- ===============================

-- 16. Find genres having avg score > avg score of all the movies
-- Question: Find genres whose average score exceeds overall movie average
-- Answer:
SELECT
    genre,
    ROUND(AVG(score), 2) AS genre_avg_score,
    (SELECT ROUND(AVG(score), 2)
    FROM movies) AS overall_avg_score
FROM movies
GROUP BY genre
HAVING AVG(score) > (
    SELECT AVG(score)
FROM movies
)
ORDER BY genre_avg_score DESC;

-- ===============================
-- SUBQUERY IN INSERT
-- ===============================

-- 17. Populate a already created loyal_customers table with records of only those customers who have ordered food more than 3 times
-- Question: Insert customers with >3 orders into loyal_customers table
-- Answer:
INSERT INTO loyal_customers
    (user_id, name, order_count)
SELECT
    o.user_id,
    u.name,
    COUNT(*) AS order_count
FROM orders o
    JOIN users u ON u.user_id = o.user_id
GROUP BY o.user_id, u.name
HAVING COUNT(*) > 3;

-- ===============================
-- SUBQUERY IN UPDATE
-- ===============================

-- 18. Populate the money col of loyal_customer table using the orders table. Provide a 10% app money to all customers based on their order value
-- Question: Update money column with 10% of customer's total order value
-- Answer:
UPDATE loyal_customers lc
SET money
=
(
    SELECT ROUND(SUM(amount) * 0.10, 2)
FROM orders o
WHERE o.user_id = lc.user_id
);

-- ===============================
-- SUBQUERY IN DELETE
-- ===============================

-- 19. Delete all the loyal customers record who has ordered less than 150 in money
-- Question: Remove customer records who had less than 150 in money column
-- Answer:

-- MySQL doesn't allow modifying a table (DELETE or UPDATE) and selecting from the same table 
-- in a subquery unless you use a derived (nested) subquery.

-- This won't work in MySQL:
-- DELETE FROM loyal_customers 
-- WHERE user_id IN (
--     SELECT user_id 
--     FROM loyal_customers
--     WHERE money < 150
-- );

-- Correct approach for MySQL:
DELETE FROM loyal_customers
WHERE user_id IN (
    SELECT user_id
FROM (
        SELECT user_id
    FROM loyal_customers
    WHERE money < 150
    ) AS customers_to_delete
);

-- Alternative approach:
-- DELETE FROM loyal_customers
-- WHERE money < 150;

-- ===============================
-- ADDITIONAL PRACTICE EXAMPLES
-- ===============================

-- 20. Find movies that earned more than the average earning of their release year
SELECT *
FROM movies m1
WHERE gross > (
    SELECT AVG(gross)
FROM movies m2
WHERE m2.year = m1.year
);

-- 21. Find customers who have ordered all available food items
SELECT u.user_id, u.name
FROM users u
WHERE NOT EXISTS (
    SELECT f.f_id
FROM food f
WHERE NOT EXISTS (
        SELECT 1
FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
WHERE o.user_id = u.user_id
    AND od.f_id = f.f_id
    )
);

-- 22. Find the second highest grossing movie
SELECT *
FROM movies
WHERE gross = (
    SELECT MAX(gross)
FROM movies
WHERE gross < (
        SELECT MAX(gross)
FROM movies
    )
);

-- ===============================
-- PERFORMANCE TIPS:
-- ===============================
-- * Correlated subqueries can be slow - consider JOINs or window functions as alternatives
-- * Use EXISTS instead of IN when checking for existence (better performance with NULLs)
-- * Scalar subqueries should return exactly one row and one column
-- * Test subqueries independently before embedding them
-- * Consider using CTEs (Common Table Expressions) for complex subqueries
-- * Be aware of NULL handling in subqueries (especially with NOT IN)
-- ===============================