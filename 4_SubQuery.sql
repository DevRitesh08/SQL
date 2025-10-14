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

---- Question 1.
-- Find the most profitable movie of each year
SELECT * FROM movies.movies
WHERE (year, (gross - budget)) IN (SELECT year, MAX(gross - budget) 
                                    FROM movies.movies 
                                    GROUP BY year);

---- Question 2.
-- Find the highest rated movie of each genre votes cutoff 25000
-- first find the max score of each genre
SELECT genre, max(score) FROM movies.movies
where votes > 25000
GROUP BY genre;
-- then find the movies with those genre and score
SELECT * FROM movies.movies
WHERE (genre, score) IN (SELECT genre, max(score) FROM movies.movies
                        where votes > 25000
                        GROUP BY genre) AND votes > 25000;  

---- Question 3.
-- Find the highest grossing movies of top 5 actor/director combo in terms of total gross collection
-- first find the top 5 actor/director combo in terms of total gross collection and also get their max grossing movie
SELECT star, director, MAX(gross) 
FROM movies.movies
GROUP BY star, director 
ORDER BY SUM(gross) DESC
LIMIT 5;
-- cannot use above query in subquery because of limit so we will use common table expression (CTE)
WITH TopCombos AS (
    SELECT star, director, MAX(gross) 
    FROM movies.movies
    GROUP BY star, director 
    ORDER BY SUM(gross) DESC
    LIMIT 5
)
SELECT * FROM movies.movies 
WHERE (star, director , gross) IN (SELECT * FROM TopCombos)


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------
-- correlated Subquery : Scalar Correlated Subquery
-------

---- Question 1.
-- Find all movies that have a rating higher than the average rating of movies in the same genre.

-- SELECT * FROM movies.movies
-- WHERE score > AVG(genre) -- but this genre is varying 

SELECT * FROM movies.movies m1
WHERE score > (SELECT AVG(score) FROM movies.movies m2 WHERE m1.genre = m2.genre);
-- Here m1 is outer query and m2 is inner query , and m1.genre is varying for each row of outer query so this is called correlated subquery
-- This query will be slower because for each row of outer query the inner query will be executed

---- Question 2.
-- Find the favourite food of each customer.
SELECT  name , f_name , COUNT(*) FROM zomato.users t1
JOIN zomato.orders t2 ON t1.user_id = t2.user_id
JOIN zomato.order_details t3 ON t2.order_id = t3.order_id
JOIN zomato.food t4 ON t3.f_id = t4.f_id
GROUP BY t1.user_id, t1.name, t4.f_id, t4.f_name ; -- in sql all non aggregated columns should be in group by clause because sql does not know which value to pick from those non aggregated columns

-- Now from the above result we have to pick the food with max count for each user
with fav_food AS (
    SELECT  t2.user_id ,name, f_name , COUNT(*) AS food_count FROM zomato.users t1
    JOIN zomato.orders t2 ON t1.user_id = t2.user_id
    JOIN zomato.order_details t3 ON t2.order_id = t3.order_id
    JOIN zomato.food t4 ON t3.f_id = t4.f_id
    GROUP BY t1.user_id, t1.name, t4.f_id, t4.f_name 
)
SELECT * FROM fav_food t1
WHERE food_count = (SELECT MAX(food_count) FROM fav_food t2 WHERE t1.user_id = t2.user_id);

------------
-----------
-- till now we have just used subqueries in WHERE clause.






-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-----------
-- Subquery in SELECT clause
-----------

---- Question 1.
-- Get the percentage of votes for each movie compared to the total number of votes .
SELECT name , (votes/(SELECT SUM(votes) FROM movies.movies)) * 100 AS vote_percentage
FROM movies.movies;
-- here it is not a correlated subquery because the inner query is not dependent on the outer query , and we can just use the sum of votes directly in the outer query because it is a single value

---- Question 2.
-- Display all movie names , genre , score and avg(score) of genre 
SELECT name , genre , score , (SELECT ROUND(AVG(score), 2) FROM movies.movies m2 WHERE m1.genre = m2.genre) AS avg_genre_score
FROM movies.movies m1;

-----------
-- Subquery in FROM clause
-----------

-- Question 1.
-- display average rating of all the restaurants .


