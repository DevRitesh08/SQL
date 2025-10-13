----
-- SubQuery
----

SELECT * FROM movies.movies;
-- Find the highest rated movie from movies table
-- Method 1 :
SELECT MAX(score) FROM movies.movies;
SELECT * FROM movies.movies
WHERE score = 9.3;
-- Method 2 : using subquery
SELECT * FROM movies.movies
WHERE score = (SELECT MAX(score) FROM movies.movies);