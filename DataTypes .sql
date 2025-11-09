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

SELECT * FROM d atatypes ;

INSERT INTO datatypes (user_id, course_id, price, rating, rating_double, Gender, skills)
VALUES (102, 23, 799.99, 42.52, 12.5678901234567, 'Male', 'Python') ;