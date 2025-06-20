-- Zomato Database SQL Analysis Queries
-- ======================================

CREATE DATABASE zomato;

-- 1. Select a particular database
USE zomato;

-- 2. Count number of rows
SELECT COUNT(*) FROM order_details;

-- 3. Return n random records
SELECT * FROM restaurants ORDER BY RAND();

-- Note: This is a common trap in SQL due to the way NULL values behave.
-- In your case, you're seeing missing values in the restaurant_rating column.
-- If you're using a CSV file or importing data via Workbench/GUI/etc., empty values might:
-- - Be imported as empty strings '' instead of NULL
-- - Be ignored if not explicitly typed as NULL
-- SELECT COUNT(*) AS empty_string_count
-- FROM orders
-- WHERE restaurant_rating = '';

-- 4. Find null values  
SELECT COUNT(*) AS null_count
FROM orders
WHERE restaurant_rating IS NULL;

-- 5. Find number of orders placed by each customer
SELECT 
    usr.name,
    COUNT(*) AS no_order
FROM users usr 
JOIN orders odr 
    ON odr.user_id = usr.user_id
GROUP BY odr.user_id
ORDER BY no_order DESC;

-- 6. Find restaurant with most number of menu items
SELECT 
    COUNT(*) AS menu_items,
    rst.r_name
FROM restaurants rst
JOIN menu mn
    ON mn.r_id = rst.r_id
GROUP BY rst.r_id
ORDER BY menu_items DESC;

-- 7. Find number of votes and avg rating for all the restaurants
SELECT 
    rst.r_name,
    COUNT(od.restaurant_rating) AS no_votes,
    ROUND(AVG(od.restaurant_rating), 2) AS avg_rating
FROM restaurants rst
JOIN orders od
    ON od.r_id = rst.r_id
GROUP BY rst.r_id, rst.r_name
ORDER BY no_votes DESC, avg_rating DESC;

-- 8. Find the food that is being sold at most number of restaurants
SELECT
    rst.r_name,
    COUNT(*) AS most_sold,
    fd.f_name
FROM order_details od
JOIN food fd
    ON fd.f_id = od.f_id
JOIN menu mn
    ON mn.f_id = od.f_id
JOIN restaurants rst
    ON rst.r_id = mn.r_id
GROUP BY od.f_id 
ORDER BY most_sold DESC;

-- 9. Find restaurant with max revenue in a given month
SELECT 
    rst.r_name,
    MONTHNAME(od.date) AS order_month,
    SUM(od.amount) AS order_amount
FROM restaurants rst
JOIN orders od
    ON od.r_id = rst.r_id
GROUP BY rst.r_id, MONTHNAME(od.date)
ORDER BY order_amount DESC, rst.r_name;

-- 10. Find restaurants with sales > X
SELECT 
    rst.r_name,
    SUM(od.amount) AS order_amount
FROM restaurants rst
JOIN orders od
    ON od.r_id = rst.r_id
GROUP BY rst.r_id
HAVING order_amount > 4100
ORDER BY order_amount DESC;

-- 11. Find customers who have never ordered
SELECT 
    usr.user_id,
    usr.name
FROM users usr
LEFT JOIN orders od
    ON od.user_id = usr.user_id
WHERE od.user_id IS NULL;

-- 12. Show order details of a particular customer in a given date range
SELECT 
    usr.user_id,
    usr.name,
    fd.f_name,
    fd.type,
    rst.r_name
FROM users usr
JOIN orders od
    ON od.user_id = usr.user_id
JOIN order_details odt
    ON odt.order_id = od.order_id
JOIN menu mn
    ON mn.f_id = odt.f_id
JOIN food fd
    ON fd.f_id = mn.f_id
JOIN restaurants rst 
    ON rst.r_id = mn.r_id
WHERE DATE(od.date) BETWEEN '2024-01-10' AND '2025-02-13';

-- 13. Customer favorite food
SELECT
    usr.name,
    SUM(odr.restaurant_rating) AS votes,
    fd.f_name
FROM users usr
JOIN orders odr
    ON odr.user_id = usr.user_id
JOIN order_details odt
    ON odt.order_id = odr.order_id
JOIN menu mn
    ON mn.f_id = odt.f_id
JOIN food fd
    ON fd.f_id = mn.f_id
GROUP BY usr.user_id, fd.f_id
ORDER BY votes DESC;

-- 14. Find most costly restaurants (Avg price/dish)
SELECT 
    rst.r_name,
    fd.f_name,
    ROUND(AVG(mn.price), 2) AS avg_price
FROM orders odr
JOIN restaurants rst
    ON odr.r_id = rst.r_id
JOIN order_details odt
    ON odt.order_id = odr.order_id
JOIN menu mn
    ON mn.f_id = odt.f_id AND mn.r_id = rst.r_id
JOIN food fd
    ON fd.f_id = mn.f_id
GROUP BY rst.r_id, fd.f_id
ORDER BY avg_price DESC;

-- 15. Find delivery partner compensation using formula: (# deliveries * 100 + 1000 * avg_rating)
SELECT
    dp.partner_name,
    ROUND(AVG(odr.delivery_rating), 2) AS avg_delivery_rating,
    COUNT(*) * 100 + 1000 * ROUND(AVG(odr.delivery_rating), 2) AS compensation
FROM delivery_partner dp
JOIN orders odr
    ON odr.partner_id = dp.partner_id
GROUP BY odr.partner_id
ORDER BY compensation DESC, avg_delivery_rating DESC;

-- 16. Find revenue per month for a restaurant
SELECT
    rst.r_name,
    SUM(odr.amount) AS revenue_per_month,
    MONTHNAME(odr.date) AS month
FROM orders odr
JOIN restaurants rst
    ON rst.r_id = odr.r_id
GROUP BY rst.r_id, MONTHNAME(odr.date)
ORDER BY revenue_per_month DESC;

-- 17. Find correlation between delivery time and total rating
SELECT
    (SUM(delivery_time * total_rating) - SUM(delivery_time) * SUM(total_rating) / COUNT(*)) /
    (SQRT(SUM(POW(delivery_time, 2)) - POW(SUM(delivery_time), 2) / COUNT(*)) *
     SQRT(SUM(POW(total_rating, 2)) - POW(SUM(total_rating), 2) / COUNT(*))) AS correlation
FROM (
    SELECT 
        delivery_time, 
        (delivery_rating + restaurant_rating) AS total_rating
    FROM orders
    WHERE delivery_rating IS NOT NULL AND restaurant_rating IS NOT NULL
) AS derived;

-- 18. Find correlation between # orders and avg price for all restaurants
SELECT
    (
        SUM(order_count * avg_price) - SUM(order_count) * SUM(avg_price) / COUNT(*)
    ) /
    (
        SQRT(
            SUM(POW(order_count, 2)) - POW(SUM(order_count), 2) / COUNT(*)
        ) *
        SQRT(
            SUM(POW(avg_price, 2)) - POW(SUM(avg_price), 2) / COUNT(*)
        )
    ) AS correlation
FROM (
    SELECT 
        rst.r_id,
        COUNT(DISTINCT od.order_id) AS order_count,
        AVG(mn.price) AS avg_price
    FROM restaurants rst
    JOIN orders od ON od.r_id = rst.r_id
    JOIN menu mn ON mn.r_id = rst.r_id
    GROUP BY rst.r_id
) AS restaurant_stats;

-- 19. Find all the veg restaurants
SELECT 
    DISTINCT rst.r_name AS veg_restro
FROM orders odr
JOIN order_details odt
    ON odt.order_id = odr.order_id
JOIN restaurants rst
    ON odr.r_id = rst.r_id
JOIN food fd
    ON fd.f_id = odt.f_id
WHERE fd.type = 'Veg'
ORDER BY veg_restro DESC;

-- 20. Find min and max order value for all the customers
SELECT 
    usr.name,
    MIN(odr.amount) AS min_order,
    MAX(odr.amount) AS max_order
FROM orders odr
JOIN users usr
    ON usr.user_id = odr.user_id
GROUP BY usr.user_id;