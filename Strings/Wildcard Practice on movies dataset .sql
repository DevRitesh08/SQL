-- we have two wildcard in like operator :
-- 1. % (percent) : represents zero, one, or multiple characters
-- 2. _ (underscore) : represents a single character

-- the movies dataset 
SELECT * FROM movies.movies ;

-- 1. Find all movies that has exactly 4 letter in their name
SELECT name FROM movies.movies WHERE name LIKE '____';

-- 2. Find all movies that starts with 'The' and ends with 's'
SELECT name FROM movies.movies WHERE name LIKE 'The%s';
-- 3. Find all movies that has 'Man' in their name
SELECT * FROM movies.movies WHERE name LIKE '%Man%';