-- USE sql_store;

-- we can use an arithmetic expression to get another value
SELECT 
    last_name, first_name, points, (points + 10) * 100 AS "discount factor"
FROM
    customers;

--use to get all the distinct value
SELECT DISTINCT state 
FROM customers

--ACTIVITY
-- Retrieve name, unit_price and new_price(unit_price * 1.1) of all products
SELECT name, unit_price, unit_price * 1.1 AS new_price 
FROM products;

-- use WHERE keyword to find specific data. Use comparison operator to filter data
SELECT *
FROM customers
WHERE birth_date > "1990-01-01";

-- ACTIVITY
-- Get the orders placed this year
SELECT *
FROM orders
WHERE order_date > "2018-01-01";

-- AND, OR and NOT Operators
SELECT * 
FROM customers
WHERE birth_Date >  "1990-01-01" AND points > 1000;
-- two conditions must be true

SELECT * 
FROM customers
WHERE birth_Date >  "1990-01-01" OR points > 1000;
-- atleast one condition must true

SELECT * 
FROM customers
WHERE birth_Date >  "1990-01-01" OR points > 1000 AND
 state = "VA"

-- we can use parenthesis
SELECT * 
FROM customers
WHERE birth_Date >  "1990-01-01" OR 
(points > 1000 AND state = "VA")

SELECT * 
FROM customers
WHERE NOT (birth_Date >  "1990-01-01" OR points > 1000)

--ACTIVITY
-- From the order_items table, get the items
--  for order #6
--  where the total price is greater than 30
SELECT * 
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > 30;

-- IN Operator
SELECT * 
FROM customers
WHERE state IN ("VA", "FL", "GA")

SELECT * 
FROM customers
WHERE state NOT IN ("VA", "FL", "GA")

--ACTIVITY
--  Return products with
--      quantity in stock equal to 49, 38, 72
SELECT * 
FROM products
WHERE quantity_in_stock IN (49, 38, 72)

-- BETWEEN Operator
-- use to select in a range
SELECT * 
FROM customers
WHERE points >= 1000 AND points <= 3000

--or you can make this
SELECT * 
FROM customers
WHERE points BETWEEN 1000 AND 3000

--ACTIVITY
--  return customers born
--      between 1/1/1990 and 1/1/2000
SELECT *
FROM customers
WHERE birth_date BETWEEN "1990-01-01" AND "2000-01-01";

-- LIKE Operator
-- Use to select a specific string patterns
SELECT *
FROM customers
WHERE last_name LIKE "brush";

SELECT *
FROM customers
WHERE last_name LIKE "b%";
-- last_name start with b

SELECT *
FROM customers
WHERE last_name LIKE "%b%";
-- last_name with b 

SELECT *
FROM customers
WHERE last_name LIKE "_y";
-- last_name with one character first and end with y

SELECT *
FROM customers
WHERE last_name LIKE "b____y";
-- last_name start with b and have 4 characters before it ends in y

-- % any number of characters
-- _ single character

--ACTIVITY
--  Get the customers whose
--      addresses contain TRAIL or AVENUE
--      phone numbers end with 9
SELECT *
FROM customers
WHERE address LIKE "%trail%" OR 
	  address LIKE "%avenue%";
      
SELECT *
FROM customers
WHERE phone LIKE "%9";


--REGEXP
SELECT *
FROM customers
WHERE last_name REGEXP "^field";
-- "^" use to represent the beginning of the string

SELECT *
FROM customers
WHERE last_name REGEXP "field$"
-- "$" use to represent the end of the string

SELECT *
FROM customers
WHERE last_name REGEXP "field|mac|rose"
-- "|" use to search multiple words

-- we can also combine with another search pattern
SELECT *
FROM customers
WHERE last_name REGEXP "^field|mac|rose";

SELECT *
FROM customers
WHERE last_name REGEXP "[gim]e";
-- "[]" we can place a letter inside the bracket that shows before "e";

SELECT *
FROM customers
WHERE last_name REGEXP "e[gim]";

-- we can also put a range in the bracket
SELECT *
FROM customers
WHERE last_name REGEXP "[a-h]e"

-- ^ beginning
-- $ end
-- | logical or
-- [abcd] to match the list in the bracket
-- [a-f] to match the range in the bracket

--ACTIVITY
-- Get the customers whose
--  first names are ELKA or AMBUR
SELECT *
FROM customers
WHERE first_name REGEXP "elka|ambur";
--  last names end with EY or ON
SELECT *
FROM customers
WHERE last_name REGEXP "ey$|on$";
--  last names start with MY or CONTAINS SE
SELECT *
FROM customers
WHERE last_name REGEXP "^my|se";
--  last names contain B followed by R or U
SELECT *
FROM customers
WHERE last_name REGEXP "b[ru]";


--NULL Operator
SELECT * 
FROM customers
WHERE phone IS NOT NULL;

--ACTIVITY
-- Get the orders that are not shipped
SELECT * 
FROM orders
WHERE shipper_id IS NULL;

--ORDER BY clause
SELECT *
FROM customers
ORDER BY first_name DESC; 
--by default it is sorted by ascending order, you can sorted it descending order by adding "DESC"

--ACTIVITY
-- get order items with id #2 and sort it by desc total price
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;


--LIMIT clause
-- Always use in the last part of the query
SELECT * 
FROM customers
LIMIT 3;
-- if limit is exceed the data from database it show all the data.

--pagination
--page 1: 1 - 3
--page 2: 4 - 6
--page 3: 7 - 9
SELECT * 
FROM customers
LIMIT 6,3;
--it will skipped 6 data first then showed the next 3 data

-- ACTIVITY
-- Get the top three loyal customers
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;
