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

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use movies;

---------
------ independent  Subquery : Scalar Subquery
---------

---- Question 1. 
-- Find the movie with the highest profit (vs order by)
-- Using Subquery
SELECT * FROM movies
WHERE (gross - budget) = (SELECT MAX(gross - budget) FROM movies);
-- Using Order By
SELECT * FROM movies
ORDER BY (gross - budget) DESC LIMIT 1;

---- Now which query is faster ? 
-- 2nd Query is faster on a large dataset because it uses indexing and avoids the overhead of a subquery, making it more efficient for retrieving the result. whereas the first query is slower because it has to compute the subquery for each row in the outer query, leading to increased processing time. but on a small dataset subquery is faster .


---- Question 2.
-- Find how many movies have a rating > the avg of all the movie ratings (Find the count of above avg movies) .
SELECT count(*) as above_avg_count FROM movies
where score > (SELECT AVG(score) from movies) ;

---- Question 3.
-- Find the highest avg movie of 2000
SELECT * FROM movies.movies
WHERE year = 2000 AND score = (SELECT MAX(score) FROM movies.movies WHERE year = 2000);

---- Question 4.
-- Find the highest rated movie among all movies whose number of votes are > the dataset avg votes count
SELECT * FROM movies.movies
WHERE votes > (SELECT AVG(votes) FROM movies.movies)
ORDER BY score DESC LIMIT 1;
-- or 
SELECT * FROM movies.movies
WHERE score = (SELECT MAX(score) FROM movies.movies WHERE votes > (SELECT AVG(votes) FROM movies.movies));  -- this is slower


---------
------ independent  Subquery : Row Subquery (One col Multi rows ==> that is given by the inner query)
---------

use zomato;

---- Question 1.
-- Find all users who have never placed an order.
SELECT * FROM zomato.users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM zomato.orders);


---- Question 2.
-- Find all movies made by top 3 directors (in terms of gross collection)
SELECT * FROM movies.movies
where director IN (SELECT director FROM movies.movies GROUP BY director ORDER BY SUM(gross) DESC LIMIT 3) ; -- this will not work because mysql does not allow limit in subquery


-- Query to get top 3 directors based on total gross collection
SELECT director FROM movies.movies GROUP BY director ORDER BY SUM(gross) DESC LIMIT 3;

-- Join version of the above query
SELECT m.*
FROM movies.movies m
JOIN (
    SELECT director
    FROM movies.movies
    GROUP BY director
    ORDER BY SUM(gross) DESC
    LIMIT 3
) top_directors
ON m.director = top_directors.director;

-- using common table expression (CTE)
WITH TopDirectors AS ( SELECT director from movies.movies 
                        GROUP BY director 
                        ORDER BY SUM(gross) DESC 
                        LIMIT 3 )
SELECT * FROM movies.movies 
WHERE director IN (SELECT director FROM TopDirectors);



---- Question 3.
-- Find all movies of all those actors whose filmography's avg rating > 8.5 (take 25000 votes as a benchmark for a movie to be considered in avg rating calculation) .

-- getting the stars whose avg rating > 8.5
SELECT star FROM movies.movies
where votes > 25000
GROUP BY star
HAVING AVG(score) > 8.5;

-- getting the movies of those stars
SELECT * FROM movies.movies
WHERE star IN (SELECT star FROM movies.movies
                where votes > 25000
                GROUP BY star
                HAVING AVG(score) > 8.5) ;




---------
------ independent  Subquery : Table Subquery (Multi col Multi rows ==> that is given by the inner query)
---------
