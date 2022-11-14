-- *** NUMERIC FUNCTION ***
 -- ROUND(number, how many digits to be round off)
 -- CEILING(number) - return smallest integer that is greater than or equal to number
 -- FLOOR(number) - return biggest number that is greater than or equal to number
 -- ABS(number) - return absolute values
 -- RAND() - return random number


 -- *** STRING FUNCTION ***
-- SELECT LENGTH("sky"); -- return the number of letters
-- SELECT UPPER("sky"); -- make letters uppercase
-- SELECT LOWER("Sky");	-- make letters lowercase
-- SELECT LTRIM("   Sky"); -- remove all spaces in the beginning
-- SELECT RTRIM("Sky"); -- remove all spaces after
-- SELECT TRIM("Sky   ") -- remove all spaces either beginning or after
-- SELECT RIGHT("Kindergarten", 4) -- RIGHT(word, how many letters from right) -- returns all the letters from right
-- SELECT LEFT("Kindergarten", 4) -- LEFT(word, how many letters from left) -- returns all the letter from left
-- SELECT SUBSTRINg("Kindergarten", 3, 5) -- SUBSTRING(word, start of string, end of string) -- returns any letters
-- SELECT LOCATE("n", "Kindergarten") -- LOCATE("character", "word") -- returns the position of character in the word
	-- SELECT LOCATE("garten", "Kindergarten")
-- SELECT REPLACE("Kindergarten", "garten", "garden") -- REPLACE(word, word to be replace, new word to replace)
-- SELECT CONCAT("first", "last") -- use to combine words
SELECT CONCAT(first_name, " ", last_name) AS full_name
FROM customers;


-- *** DATE FUNCTIONS ***
-- SELECT NOW() -- return the current date and time
-- SELECT CURDATE() -- return current date
-- SELECT CURTIME() -- return current time
-- SELECT YEAR(NOW()) -- return current year
-- SELECT MONTH(NOW()) -- return current month
-- SELECT DAY(NOW()) -- return current day
-- SELECT HOUR(NOW()), MINUTE(NOW()), SECOND(NOW()) -- return integer values
-- SELECT DAYNAME(NOW()) -- return day name of the date as an string
-- SELECT MONTHNAME(NOW()) -- return month name of the date as an string
-- SELECT EXTRACT(DAY FROM NOW()) -- return the day, year, etc from date.alter

-- ACTIVITY ***
-- get all the orders from the current year. (example current year is 2022)
SELECT *
FROM orders
WHERE YEAR(order_date) = YEAR(NOW())


-- *** FORMATING DATES AND TIMES ***
-- DATE_FORMAT(date value, format) 
-- SELECT DATE_FORMAT(NOW(), "%m-%d-%Y") -- %y return 22, %Y return 2022, return 11-07-2022
-- SELECT TIME_FORMAT(NOW(), "%h:%i:%s %p") -- %H return 24H hour, %h return 12H hour, %i return minutes, %s return seconds, %p return pm/am


-- *** CALCULATING DATES AND TIMES ***
-- SELECT DATE_ADD(NOW(), INTERVAL 1 DAY) -- add one day to the current day, we can replace "DAY" with "YEAR", "MONTH"
									 -- we can add negative value to get the previous day
-- SELECT DATE_SUB(NOW(), INTERVAL 1 DAY)
-- SELECT DATEDIFF("2019-01-05", "2019-01-01") -- calculate difference between to date
SELECT TIME_TO_SEC("9:00") - TIME_TO_SEC("9:02") -- calculate between to time



-- *** the IFNULL and COALESCE functions ***
-- USE sql_store;
-- SELECT 
-- 	order_id,
--     IFNULL(shipper_id, "Not assigned") AS shipper -- in IFNULL we can subtitute if null with another values
-- FROM orders;

-- SELECT 
-- 	order_id,
--     COALESCE(shipper_id, comments, "Not assigned") AS shipper -- we supply a list of values, and this functions will return non null value in the list
-- FROM orders


-- ACTIVITY ***
-- write a query that produce customer and phone number, if there is no phone number replace it with "Unknown"alter
SELECT 
	CONCAT(first_name, " ", last_name) AS customer, 
    IFNULL(phone, "Unknown") AS phone
FROM customers



-- *** the IF function ***
 -- IF(expression, if true = first value, second)

SELECT 
	order_id,
    order_date,
    IF(YEAR(order_date) = YEAR(NOW()), "Active", "Archive") AS category
FROM orders

-- ACTIVITY ***
-- write a query that produce product_id, name, orders, frequency
SELECT 
	product_id,
    name,
    COUNT(*) AS orders,
    IF(COUNT(*) > 1, "Many times", "Once") AS frequency
FROM products 
JOIN order_items USING (product_id)
GROUP BY product_id, name



-- *** the CASE operator ***
SELECT 
	order_id,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN "Active"
        WHEN YEAR(order_date) = YEAR(NOW() - 1) THEN "Last Year"
        WHEN YEAR(order_date) < YEAR(NOW() - 1) THEN "Archived"
        ELSE "Future"
	END AS category
FROM orders