-- String Functions in SQL



-- 1. LOWER() function: Converts a string to lowercase letters
-- 2. UPPER() function: Converts a string to uppercase letters
-- 3. LENGTH() function: Returns the length of a string in terms of number of characters , it returns byte length in some SQL versions
-- 4. CHAR_LENGTH() function: Returns the length of a string in terms of number of characters (same as LENGTH() in most SQL versions) it returns character length


SELECT name as OriginalName, LOWER(name) as LowercaseName, UPPER(name) as UppercaseName, LENGTH(name) as NameLength FROM movies.movies ;

SELECT name , LENGTH(name) , CHAR_LENGTH(name) FROM movies.movies 
WHERE LENGTH(name) != CHAR_LENGTH(name) ;  -- to check if any difference in length functions ==> usually no difference unless special characters are present


-- 5. CONCAT() function: Concatenates two or more strings into one string 
SELECT CONCAT(name, ' (', genre, ')') as MovieWithGenre FROM movies.movies ;


-- 6. CONCAT_WS() function: Concatenates strings with a specified separator , syntax: CONCAT_WS(separator, string1, string2, ...)
SELECT CONCAT_WS(' - ', name, genre, CAST(year AS CHAR)) as MovieDetails FROM movies.movies ;   -- here cast year to char to avoid error , but in some SQL versions its not required


-- 7. SUBSTRING() function: Extracts a substring from a string , syntax: SUBSTRING(string, start_position, length)
SELECT name, SUBSTRING(name, 1, 5) as First5Chars_using_SUBSTRING FROM movies.movies ;  -- SUBSTR() can also be used in some SQL versions
SELECT name, SUBSTR(name, 1, 5) as First5Chars_USING_SUBSTR FROM movies.movies ;
SELECT name, SUBSTR(name, -5) as Last5Chars_USING_SUBSTR FROM movies.movies ;   -- negative start position to get last n characters
SELECT name, SUBSTR(name, -4,3) as Last5Chars_USING_SUBSTR FROM movies.movies ;  -- negative start position with length to get substring
SELECT name, SUBSTR(name, -4,-2) as Last5Chars_USING_SUBSTR FROM movies.movies ;  -- negative start position with negative length to get substring will give different results in different SQL versions


-- 8. REPLACE() function: Replaces all occurrences of a specified substring with another substring . syntax: REPLACE(original_string, substring_to_replace, replacement_substring)
-- can be used to change specific parts of a string also valid for other data types like text
SELECT REPLACE("hello world", 'world', 'SQL') as ReplacedString ;

-- 9. REVERSE() function: Reverses the characters in a string

-- find all movies whose name is palindrome ( same when read from front or back)
SELECT name FROM movies.movies WHERE name = REVERSE(name) ;


-- 10. TRIM() function: Removes leading and trailing whitespace from a string . syntax: TRIM(string)
SELECT TRIM('   hello world   ') as TrimmedString ;
-- can also remove specific characters from start and end using LEADING , TRAILING , BOTH
SELECT TRIM(BOTH 'x' FROM 'xxxhelloxxx') as TrimmedString2 ;  -- removes 'x' from both ends


-- 11. LTRIM() and RTRIM() functions: Removes leading (LTRIM) or trailing (RTRIM) whitespace from a string . syntax: LTRIM(string) , RTRIM(string)
SELECT LTRIM('   hello world   ') as LeftTrimmedString , RTRIM('   hello world   ') as RightTrimmedString ;     -- can use LENGTH to verify spaces removed


-- 12. INSERT() function: Inserts a substring into a string at a specified position , syntax: INSERT(original_string, position, length_to_replace, substring_to_insert)
SELECT INSERT('hello world', 7, 5, 'SQL') as ModifiedString ;  -- replaces 5 characters from position 7 with 'SQL'
SELECT INSERT('hello world', 6, 0, ' beautiful ') as ModifiedString2 ;  -- inserts ' beautiful ' at position 6 without replacing any characters


-- 13. LEFT() and RIGHT() functions: Extracts a specified number of characters from the left or right side of a string . syntax: LEFT(string, number_of_characters) , RIGHT(string, number_of_characters)
SELECT name, LEFT(name, 4) as First4Chars, RIGHT(name, 4) as Last4Chars FROM movies.movies ;


-- 14. REPEAT() function: Repeats a string a specified number of times , syntax: REPEAT(string, number_of_times)
SELECT REPEAT('ha', 5) as RepeatedString ;  -- outputs 'hahahahaha'


-- 15. LOCATE() function: Returns the position of the first occurrence of a substring within a string , syntax: LOCATE(substring, string, [start_position])
SELECT LOCATE('world', 'hello world, welcome to the world of SQL', 10) as PositionOfWorld ;  -- start searching from position 10 , should return position of second 'world'
SELECT LOCATE('man', name) as PositionOfMan FROM movies.movies WHERE name LIKE '%man%' ;  -- find position of 'man' in movie names containing 'man'


-- 16. SUBSTRING_INDEX() function: Returns the substring from a string before a specified number of occurrences of a delimiter , syntax: SUBSTRING_INDEX(string, delimiter, number_of_occurrences)
SELECT SUBSTRING_INDEX(name, ' ', 1) as FirstWord FROM movies.movies ;  -- get first word of movie names
SELECT SUBSTRING_INDEX(name, ' ', -1) as LastWord FROM movies.movies ;  -- get last word of movie names
SELECT SUBSTRING_INDEX(name, ' ', 2) as FirstTwoWords FROM movies.movies ;  -- get first two words of movie names


-- 17. STRCMP() function: Compares two strings and returns 0 if they are equal , a negative number if the first string is less than the second , and a positive number if the first string is greater than the second . syntax: STRCMP(string1, string2)
SELECT STRCMP('apple', 'banana') as ComparisonResult1 , STRCMP('banana', 'apple') as ComparisonResult2 , STRCMP('apple', 'apple') as ComparisonResult3 ,  STRCMP('MALE', 'male') as ComparisonResult4lo ;  -- case sensitive comparison


-- 18. LPAD() and RPAD() functions: Pads a string on the left (LPAD) or right (RPAD) with a specified character to a certain length . syntax: LPAD(string, target_length, pad_string) , RPAD(string, target_length, pad_string)
SELECT LPAD('hello', 10, '*') as LeftPaddedString , RPAD('hello', 10, '#') as RightPaddedString ;  -- pads 'hello' to length 10 with '*' on left and '#' on right