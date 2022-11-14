-- JOIN is use to combine multiple tables
SELECT *
FROM orders
INNER JOIN customers 
	ON orders.customer_id = customers.customer_id;

--if you want to select a column that has in both table you must prefixing it using its table
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders
INNER JOIN customers 
	ON orders.customer_id = customers.customer_id;


-- we can give a alias into the repeatetive names
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
INNER JOIN customers c
	ON o.customer_id = c.customer_id;

-- ACTIVITY
-- in order_items table write a query that will shows the order_id, product_id, name, quantity and unit_price
SELECT order_id, oi.product_id, name, quantity, oi.unit_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id


-- JOINING Across Database
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
    ON oi.product_id = p.product_id


-- SELF JOINS
--use to join other column in the same table
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;


-- JOINING MULTIPLE TABLES
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name as status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id

--ACTIVITY
-- JOIN multiple tables and get the name of the client and their payment method
SELECT 
	p.date, 
    p.invoice_id, 
    p.amount,
    c.name,
    pm.name
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;


--COMPOUND JOIN CONDITIONS
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id


-- IMPLICIT JOIN SYNTAX
-- Explicit Join Syntax
SELECT *
FROM orders o 
JOIN customers c
	ON o.customer_id = c.customer_id;
    
-- Implicit Join Syntax
SELECT * 
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;
-- If you forget the WHERE keyword you will get cross join
-- cross join, join the two tables


-- OUTER JOIN
SELECT 
	c.customer_id,
	c.first_name,
    o.order_id
FROM customers c
RIGHT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id
-- LEFT JOIN all the record in the left table wether the condition is met or not
-- RIGHT JOIn return all the record in the right table wether the condition is met or not.
-- the position of table is determine wether what is table specify first. Left first then right last

--ACTIVITY
--products table & orders table
-- list all the products and quantity even there is no quantity
SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM order_items oi
RIGHT JOIN products p
	ON oi.product_id = p.product_id;


--OUTER JOIN BETWEEN MULTIPLE TABLES
SELECT 
	c.customer_id,
	c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id

--ACTIVITY
-- get all the details in order tables using outer join
SELECT 
	o.order_date,
    o.order_id,
    c.first_name,
    s.name AS shipper,
    os.name AS status
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id


-- SELF OUTER JOINS
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;


-- USING CLAUSE
USE sql_store;

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id)
-- USING keyword use if the column is the same in the different table

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id AND oi.product_id = oin.product_id
    USING (order_id, product_id)
-- example of USING keyword if there is composite data

--ACTIVITY
-- in payment table get all the data using JOIN and USING keyword
USE sql_invoicing;

SELECT 
 	p.date,
    c.name AS client,
    p.amount,
    pm.name AS payment_method
FROM payments p
JOIN clients c
	USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id


-- NATURAL JOINS
-- not recommended to use because it shows unexpected result
USE sql_store;

SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c


-- CROSS JOINS
-- use to combine and join every record from the first table with every record in the second table.
SELECT 
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

--ACTIVITY
-- Do a cross join between shippers and products
-- 		using the implicit syntax
SELECT 
    sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

-- 		and then using the explicit syntax
SELECT 
    sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;


-- UNIONS
-- use to combine all the query to produce one result
SELECT 
	order_id,
    order_date,
    "Active" AS status
FROM orders
WHERE order_date >= "2019-01-01"
UNION
SELECT 
	order_id,
    order_date,
    "Archive" AS status
FROM orders
WHERE order_date < "2019-01-01"

-----
SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;


-- ACTIVITY
-- using UNION, label the type of membership of customer. If points <2000 = bronze, 2000 - 3000 = silver,  >3000 = gold
SELECT 
	customer_id, 
    first_name, 
    points, 
    "Bronze" AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
	customer_id, 
    first_name, 
    points, 
    "Silver" AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id, 
    first_name, 
    points, 
    "Gold" AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;