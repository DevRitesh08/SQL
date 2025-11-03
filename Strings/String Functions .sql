-- String Functions in SQL



-- 1. LOWER() function: Converts a string to lowercase letters
-- 2. UPPER() function: Converts a string to uppercase letters
-- 3. LENGTH() function: Returns the length of a string in terms of number of characters

SELECT name as OriginalName, LOWER(name) as LowercaseName, UPPER(name) as UppercaseName, LENGTH(name) as NameLength FROM movies.movies ;


-- 4. CONCAT() function: Concatenates two or more strings into one string 
SELECT CONCAT(name, ' (', genre, ')') as MovieWithGenre FROM movies.movies ;


-- 5. CONCAT_WS() function: Concatenates strings with a specified separator , syntax: CONCAT_WS(separator, string1, string2, ...)
SELECT CONCAT_WS(' - ', name, genre, CAST(year AS CHAR)) as MovieDetails FROM movies.movies ;   -- here cast year to char to avoid error , but in some SQL versions its not required


-- 6. SUBSTRING() function: Extracts a substring from a string , syntax: SUBSTRING(string, start_position, length)
SELECT name, SUBSTRING(name, 1, 5) as First5Chars FROM movies.movies ;


7. 
