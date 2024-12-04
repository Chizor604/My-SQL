SELECT * FROM uptraxtech_ltd.student_demographics;

SELECT *
FROM student_demographics;

SELECT * FROM uptraxtech_ltd.student_demographics;

-- SELECTING MUTIPLE COLUMNS
SELECT first_name,last_name,gender
FROM student_demographics;

SELECT * FROM student_fee;

-- Selecting first three columns

SELECT student_id,first_name,last_name;

-- GROUP BY - AGGREGATE FUNCTION
-- WHERE STATEMENT
-- HAVING VS LIKE
-- ORDER BY

-- GROUP BY STATEMENT
-- GROUP BY STATEMENT WORKS WITH AGGREGATES ( SUM, MIN, MAX, COUNT,AVERAGE)

SELECT gender, COUNT(gender), max(age), min(age), avg(age) 
FROM student_demographics
GROUP BY gender;

-- DISTINCT FXN/ STATEMENT shows the unique items in a column
SELECT DISTINCT (gender)
FROM student_demographics;

SELECT DISTINCT (course)
FROM student_fee;

-- ALIAS (AS STATEMENT)
SELECT first_name, last_name AS Other_name
FROM student_demographics;

SELECT gender, count(gender) AS Gender_count
FROM student_demographics
GROUP BY gender;

SELECT gender, count(gender) Gender_count
FROM student_demographics
GROUP BY gender;

-- ORDER BY is used for sorting either alphabetically or numerically
SELECT * 
FROM student_demographics
ORDER BY age DESC;

SELECT course, avg(fee)
FROM student_fee
GROUP BY course;

-- WHERE STATEMENT
SELECT first_name, last_name, age
FROM student_demographics
WHERE age<30;

-- QUERY TO DISPLAY GENDER=FEMALE AND AGE<30
SELECT first_name, last_name,gender, age
FROM student_demographics
WHERE gender= 'female' AND age<30;

SELECT first_name, last_name,gender, age
FROM student_demographics
WHERE gender= 'female' AND NOT age<30;

-- HAVING STATEMENT IS JUST LIKE THE 'WHERE' STATEMENT
SELECT first_name, last_name, gender, age
FROM student_demographics
HAVING age<30;


SELECT first_name, last_name,course
FROM student_fee
HAVING course LIKE "%cyb%";

-- JOINS is used to join two or more tables. 
-- it only happens when there's a primary (or common) key 
-- There are two types of joins - inner (or cross)join, outer join, full join

-- INNER JOIN takes everything on table 1 and matches it to like terms on table 2
-- OUTER JOIN


-- For exampe, let's join student demographics and student fees tables
SELECT *
FROM student_demographics
INNER JOIN student_fee	
	ON student_demographics.first_name = student_fee.first_name;
    
SELECT *
FROM student_demographics AS dem
INNER JOIN student_fee AS fee
	ON student_demographics.first_name = student_fee.first_name;
    
SELECT dem.first_name, fee.last_name, age, gender, birth_date, course,fee, department_id, dem.student_id
FROM student_demographics AS dem
INNER JOIN student_fee	AS fee
	ON dem.first_name = fee.first_name;
    
    -- OUTER JOIN
SELECT *
FROM student_demographics AS dem
RIGHT JOIN student_fee	AS fee
	ON dem.first_name = fee.first_name;
    
SELECT dem.first_name, dem.last_name, dem.student_id, fee, gender, age, department_id, course, birth_date
FROM student_demographics AS dem
JOIN student_fee AS fee
	ON dem.first_name = fee.first_name
WHERE age<30;

SELECT *
FROM student_demographics AS dem
RIGHT JOIN student_fee AS fee
	ON dem.first_name = fee.first_name
RIGHT JOIN course_applied AS c_a
	ON department_id = dept_id
ORDER BY dept_id;

-- UNION 
SELECT first_name, last_name
FROM student_demographics
UNION
SELECT gender,age
FROM student_demographics;

-- JOIN IS LIKE APPEND AND UNION IS LIKE MERGE

-- STRING FUNCTIONS are text functions 

SELECT * 
FROM student_demographics;



SELECT first_name, last_name
FROM student_demographics
UNION
SELECT fee,course
FROM student_fee;

-- UPPER AND LOWER 
SELECT UPPER('emmanuel');
SELECT LOWER('QUEENETH');

SELECT first_name, UPPER(first_name)
FROM student_demographics;

-- CONCATENATE is to join two or more columns together
SELECT first_name,last_name, CONCAT(first_name, ' ', last_name) AS full_name
FROM student_demographics;

-- TRIM is used to remove empty spaces between text
SELECT LTRIM ('            UPTRAX        '); 
SELECT RTRIM('            UPTRAX        ');

SELECT birth_date, LEFT(birth_date,4),RIGHT(birth_date,2)
FROM student_demographics;

-- SUBSTRING enables you to specify a position to pick a character from a text range
SELECT birth_date, 
LEFT(birth_date,4),
RIGHT(birth_date,2),
SUBSTRING(birth_date,6,2)
FROM student_demographics;

-- COMMON TABLE EXPRESSION (CTE)
-- CASE FUNCTIONS enables us to use logic to query a db; its whats responsible for grouping

SELECT first_name, age,
CASE
WHEN age<30 THEN "Young"
WHEN age>=30 THEN "Adult"
END AS age_group
FROM student_demographics;

SELECT first_name, age,
CASE
WHEN age BETWEEN 20 AND 25 THEN "Young"
WHEN age BETWEEN 26 AND 30 THEN "Adult"
WHEN age BETWEEN 31 AND 35 THEN "Old"
WHEN age>35 THEN "Aged"
END AS age_group
FROM student_demographics;

SELECT first_name, last_name, age, birth_date, 
CASE
WHEN birth_date BETWEEN '1980-01-01' AND '1990-12-31' THEN "Baby Boomers"
WHEN birth_date BETWEEN '1991-01-01' AND '1999-12-31' THEN "Millenials"
WHEN birth_date BETWEEN '2000-01-01' AND '2010-12-31' THEN "Gen Z"
END AS age_generation
FROM student_demographics
ORDER BY age_generation;

-- COMMON TABLE EXPRESSION CTE in  SQL is a temporary result set that you can reference within a select, insert, update or delete statement.
-- It is defined usimg the keyword and helps makes complex queries more readable and maintainable.

SELECT gender, avg(age), min(age), max(age), sum(fee), avg(fee),min(fee),max(fee)
FROM student_demographics as dem
INNER JOIN student_fee	as fee
	ON dem.first_name = fee.first_name
GROUP BY gender;

-- CTE EXAMPLE
WITH CTE AS 
(SELECT gender, avg(age) as avg_age, min(age), max(age), sum(fee), avg(fee),min(fee),max(fee)
FROM student_demographics as dem
INNER JOIN student_fee	as fee
	ON dem.first_name = fee.first_name
GROUP BY gender)

SELECT avg_age, gender
FROM CTE;

				-- DATA CLEANING IN SQL 29/11/2024

-- CHECKING FOR MISSING VALUES(NULLS)
-- Identifying rows with missiing values in specific columns
SELECT *
FROM student_demographics
WHERE first_name IS NULL;

-- Identifying rows with missiing values in any column
SELECT *
FROM student_demographics
WHERE first_name IS NULL OR last_name IS NULL OR gender IS NULL;

-- Counting Missing Values
SELECT count(*) AS missing_count
FROM student_demographics
WHERE first_name IS NULL;

-- Removing or Replacing Missing Values
DELETE FROM student_demographics
WHERE first_name IS NULL;

-- Replace Missing Values Using COALESCE()
SELECT first_name,
COALESCE(first_name, 'Unknown') AS cleaned_column
FROM student_demographics;

-- Replace Missing Values with the column mean (numerical data)
UPDATE student_fee
SET fee = (
	SELECT AVG(fee)
	FROM student_fee
	WHERE fee IS NOT NULL
)
WHERE fee IS NULL;

-- CHATGPT	MySQL doesn't allow directly referencing the target table (student_fee) in a subquery when updating it.
-- To fix it, you can use a temporary table or a common table expression.
-- (CTE) ti=o first calculate the average and then perform the update
UPDATE student_fee
SET fee = (SELECT avg_fee FROM (SELECT AVG(fee) AS avg_fee FROM student_fee WHERE fee IS NOT NULL) AS temp_avg)
WHERE fee IS NULL;

WITH AvgFee AS (
	SELECT AVG(fee) AS avg_fee
	FROM student_fee
	WHERE fee IS NOT NULL
)
UPDATE student_fee
SET fee = (SELECT avg_fee FROM AvgFee)
WHERE fee IS NULL;

 -- 4TH DECEMBER 2024
 -- Removing Duplicates 
 CREATE TEMPORARY TABLE temp_table as
 SELECT *
 FROM student_demographics
 WHERE first_name IN (
 SELECT min(first_name)
 FROM student_demographics
 GROUP BY first_name, last_name 
 );
 
 
 SELECT * FROM temp_table;
 
 DELETE FROM student_demographics;
 INSERT INTO student_demographics SELECT * FROM temp_table;
 DROP TEMPORARY TABLE temp_table;
 
 -- Verifying Removal
 -- After deletion, run the duplicate-check query again to ensure all duplicates have been removed
 
 SELECT first_name, last_name, count(*)
 FROM student_demographics
 GROUP BY first_name,