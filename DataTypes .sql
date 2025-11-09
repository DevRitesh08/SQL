-- Active: 1752601825439@@127.0.0.1@3306@temp
create table temp.datatypes (
    user_id TINYINT,    -- range -128 to 127
    course_id TINYINT UNSIGNED  -- range 0 to 255
)

INSERT INTO datatypes VALUES(200,200) ;     -- This will give error as 200 is out of range for TINYINT

SELECT * FROM datatypes ;

ALTER Table datatypes
ADD COLUMN price DECIMAL(5,2) ;   -- total 5 digits with 2 digits after decimal point

UPDATE datatypes
SET price = 123.45;     -- valid , but can't add data above 999.99

UPDATE datatypes
SET price = 123.475;    -- valid, but will be rounded to 123.48

ALTER Table datatypes
ADD COLUMN rating FLOAT ;   -- single precision floating point number that can store up to 7 digits (after decimal point) and before decimal point it can store up to 38 digits

ALTER Table datatypes
ADD COLUMN  rating_double DOUBLE ;   -- double precision floating point number that can store up to 15 digits (after decimal point) and before decimal point it can store up to 308 digits

SELECT * FROM datatypes ;

UPDATE datatypes
SET rating = 4.5678901 , rating_double = 4.5678901234567 ;  -- valid because within precision limit

UPDATE datatypes
SET rating = 4.56789012 , rating_double = 4.567890123456789123 ;  -- valid, but will be rounded to fit precision limit

ALTER Table datatypes
ADD COLUMN  Gender ENUM('Male', 'Female' , 'Other') AFTER user_id ;   -- ENUM data type can store only predefined values

UPDATE datatypes
SET Gender = 'Male' ;   -- valid  

UPDATE datatypes
SET Gender = 'M' ;     -- invalid, will give error

ALTER Table datatypes
ADD COLUMN  skills SET('C', 'C++' , 'Java' , 'Python' , 'SQL' , 'DSA' , 'Web Development' , 'Machine Learning' , 'Data Visualization' , 'statistics' , 'Deep Learning') AFTER course_id ;   -- SET data type can store multiple predefined values

SELECT * FROM datatypes ;

INSERT INTO datatypes (user_id, course_id, price, rating, rating_double, Gender, skills)
VALUES (101, 10, 499.99, 4.5, 4.5678901234567, 'Female', 'Python,SQL,Data Visualization') ;

INSERT INTO datatypes (user_id, course_id, price, rating, rating_double, Gender, skills)
VALUES (101, 10, 499.99, 4.5, 4.5678901234567, 'Female', 'Python,SQL,Ruby') ;   -- invalid, 'Ruby' is not a predefined value in SET

-- cant use update for adding values to SET datatype, need to use CONCAT function but when using CONCAT we need to ensure that we dont add duplicate values
-- e.g. if 'Python' is already present in skills, we should not add it again
UPDATE datatypes
SET skills = CONCAT(skills, ',C++')
WHERE FIND_IN_SET('C++', skills) = 0 ;   -- only add C++ if not already present

SELECT * FROM datatypes ;

INSERT INTO datatypes (user_id, course_id, price, rating, rating_double, Gender, skills)
VALUES (102, 23, 799.99, 42.52, 12.5678901234567, 'Male', 'Python') ;

ALTER Table datatypes
ADD COLUMN  Certificate MEDIUMBLOB ;

UPDATE datatypes
SET Certificate = LOAD_FILE('D:/Confidential/ApnaCollege.jpg')
WHERE user_id = 101;  -- or whichever user you want to add certificate to

ALTER Table datatypes
ADD COLUMN latLong GEOMETRY ;   -- to store geographical data like latitude and longitude points

UPDATE datatypes
SET latLong = ST_GeomFromText('POINT(40.7128 -74.0060)')  -- Example: New York City coordinates
WHERE user_id = 101;  -- or whichever user you want to add geographical data to 

SELECT * FROM datatypes ;
-- to view the geographical data in a more readable format
SELECT user_id, ST_AsText(latLong) AS latLong FROM datatypes ;
-- to get latitude and longitude separately
SELECT user_id, ST_X(latLong) AS latitude, ST_Y(latLong) AS longitude FROM datatypes ;


ALTER Table datatypes
ADD COLUMN description JSON ;   -- to store JSON data

UPDATE datatypes
SET description = '{"course":"Data Science","duration":"6 months","level":"Intermediate"}'
WHERE user_id = 101;  

SELECT * FROM datatypes ;

SELECT JSON_EXTRACT(description, '$.course') AS course_name
FROM datatypes ;