-- =====================================================
-- SQL STRING FUNCTIONS GUIDE WITH MOVIE DATASET EXAMPLES
-- =====================================================

-- STRING DATA TYPES
-- =====================================================

/*
CHAR: Fixed-length strings (padded with spaces)
- Example: CHAR(10) for movie rating codes like 'PG-13     '

VARCHAR: Variable-length strings (only uses needed space)
- Example: VARCHAR(255) for movie names like 'The Dark Knight'

TEXT: Large variable-length strings (up to 65,535 characters)
- Example: TEXT for movie plot summaries

MEDIUMTEXT: Even larger text (up to 16,777,215 characters)
- Example: MEDIUMTEXT for detailed movie reviews

LONGTEXT: Largest text storage (up to 4,294,967,295 characters)
- Example: LONGTEXT for complete movie scripts
*/

-- WILDCARD OPERATORS
-- =====================================================

-- Find movies with names starting with 'The'
SELECT name
FROM movies
WHERE name LIKE 'The%';

-- Find movies with exactly 5-character names
SELECT name, genre
FROM movies
WHERE name LIKE '_____';

-- Find movies containing 'love' anywhere in name
SELECT name, director
FROM movies
WHERE name LIKE '%love%';

-- STRING FUNCTIONS WITH MOVIE EXAMPLES
-- =====================================================

-- 1. UPPER/LOWER - Convert case
SELECT 
    name,
    UPPER(name) AS name_upper,
    LOWER(director) AS director_lower
FROM movies
WHERE year = 2023;

-- 2. CONCAT & CONCAT_WS - Join strings
SELECT 
    CONCAT(name, ' (', year, ')') AS movie_with_year,
    CONCAT_WS(' - ', director, genre, rating) AS movie_info
FROM movies
LIMIT 10;

-- 3. SUBSTR - Extract substring (last 5 characters of name)
SELECT 
    name,
    SUBSTR(name, -5) AS last_5_chars,
    SUBSTR(name, 1, 10) AS first_10_chars
FROM movies
WHERE CHAR_LENGTH(name) >= 10;

-- 4. REPLACE - Replace text
SELECT 
    name,
    REPLACE(name, 'The', 'A') AS modified_name,
    REPLACE(genre, 'Action', 'Adventure') AS modified_genre
FROM movies
WHERE name LIKE 'The%';

-- 5. REVERSE - Reverse string (find palindrome movie names)
SELECT 
    name,
    REVERSE(name) AS reversed_name
FROM movies
WHERE LOWER(name) = LOWER(REVERSE(name));

-- 6. CHAR_LENGTH vs LENGTH - Character vs byte count
SELECT 
    name,
    CHAR_LENGTH(name) AS char_count,
    LENGTH(name) AS byte_count,
    director
FROM movies
WHERE CHAR_LENGTH(name) != LENGTH(name);

-- 7. INSERT - Insert substring at position
SELECT 
    name,
    INSERT(name, 1, 0, '[MOVIE] ') AS labeled_name,
    INSERT(director, 1, 3, 'Dir. ') AS formatted_director
FROM movies
LIMIT 5;

-- 8. LEFT and RIGHT - Extract from start/end
SELECT 
    name,
    LEFT(name, 10) AS name_start,
    RIGHT(name, 5) AS name_end,
    LEFT(year, 2) AS decade_prefix
FROM movies
WHERE CHAR_LENGTH(name) > 10;

-- 9. REPEAT - Repeat string
SELECT 
    name,
    CONCAT(
        REPEAT('★', CAST(score/2 AS UNSIGNED)), 
        REPEAT('☆', 5 - CAST(score/2 AS UNSIGNED))
    ) AS star_rating
FROM movies
WHERE score BETWEEN 1 AND 10;

-- 10. TRIM, LTRIM, RTRIM - Remove whitespace
SELECT 
    name,
    TRIM(name) AS trimmed_name,
    LTRIM(RTRIM(director)) AS clean_director
FROM movies
WHERE name != TRIM(name);

-- 11. SUBSTRING_INDEX - Split strings
SELECT 
    director,
    SUBSTRING_INDEX(director, ' ', 1) AS first_name,
    SUBSTRING_INDEX(director, ' ', -1) AS last_name,
    SUBSTRING_INDEX(genre, '/', 1) AS primary_genre
FROM movies
WHERE director LIKE '% %';

-- 12. STRCMP - Compare strings
SELECT 
    m1.name AS movie1,
    m2.name AS movie2,
    STRCMP(m1.name, m2.name) AS comparison
FROM movies m1
JOIN movies m2 ON m1.name != m2.name
WHERE m1.director = m2.director
LIMIT 10;

-- 13. LOCATE - Find position of substring
SELECT 
    name,
    LOCATE('love', LOWER(name)) AS love_position,
    LOCATE('war', LOWER(name)) AS war_position
FROM movies
WHERE LOCATE('love', LOWER(name)) > 0 
   OR LOCATE('war', LOWER(name)) > 0;

-- 14. LPAD and RPAD - Pad strings
SELECT 
    name,
    LPAD(name, 30, '-') AS left_padded,
    RPAD(CAST(year AS CHAR), 10, '*') AS right_padded
FROM movies
WHERE CHAR_LENGTH(name) < 20;

-- =====================================================
-- END OF STRING FUNCTIONS GUIDE
-- =====================================================