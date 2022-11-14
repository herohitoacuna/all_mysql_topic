-- COLUMN ATTRIBUTES
--VARCHAR(50) - if user store 5 characters it will save 5 characters
-- CHAR(50)- if user store 5 characters it will add more 45 characters 
-- PK -primary key
-- NN - not null
-- AI - auto increment, commonly use in ID
-- Deafault / Expression - default value if value is not indicated.


-- INSERT ROW INTO A TABLE
INSERT INTO customers
VALUES (
    DEFAULT
    "John", 
    "Smith", 
    "1990-01-01",
    DEFAULT 
    "address",
    "city",
    "CA"
    DEFAULT
    )

-- OR -- 
INSERT INTO customers(
    first_name, 
    last_name, 
    birth_date, 
    address, 
    city, 
    state)
VALUES (
    "John", 
    "Smith", 
    "1990-01-01", 
    "address",
    "city",
    "CA"
    )
--  we can indicate which column that we will add a data so that we dont need to use DEFAULT KEYWORD


-- INSERT MULTIPLE ROWS IN TABLE
INSERT INTO shippers(name)
VALUES ("Shipper1"),
        ("Shipper2"),
        ("Shipper3")


-- ACTIVITY 
-- 	Insert three rows in the products table
INSERT INTO products(name, quantity_in_stock, unit_price)
VALUES ("Product1", 10, 1.95),
	("Product2", 11, 1.95),
	("Product3", 12, 1.95)


-- HIERARCHICAL ROWS
INSERT INTO orders(customer_id, order_date, status)
VALUES (1, "2019-01-02", "1");

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.95),
    (LAST_INSERT_ID(), 2, 1, 3.95);

-- LAST_INSERT_ID() is a function use to select the last ID number inserted 


-- CREATING A COPY OF A TABLE
CREATE TABLE orders_archive AS
SELECT * FROM orders  -- > sub query is a select statement that is part of another SQL statement
-- PK and AI is ignored when you copy 

-- using sub query to select a filter data and copy it to another data base
INSERT INTO orders_archive
SELECT * 
FROM orders
WHERE order_date < "2019-01-01";


-- ACTIVITY
-- create a copy of the invoices into a new table called invoices_archive however instead a client_id, use join to get the client_name.
-- select also client with payment date
-- USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT 
	i.invoice_id,
    i.number,
    c.name,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
JOIN clients c
	ON i.client_id = c.client_id
WHERE payment_date IS NOT NULL;


-- UPDATING SINGLE ROW
UPDATE invoices 
SET payment_total = 10, payment_date = "2019-03-01"
WHERE invoice_id = 1;

-- if we mistakenly updated wrong row but the colum of that row have a default values
UPDATE invoices 
SET payment_total = DEFAULT, payment_date = DEFAULT
WHERE invoice_id = 1;

UPDATE invoices 
SET payment_total = invoice_total * 0.5,
 payment_date = due_date
WHERE invoice_id = 3;


-- UPDATE MULTIPLE ROWS
UPDATE invoices 
SET payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id = 3;

-- ACTIVITY
-- Write a SQL statemnet to
-- 	give any cutomers born before 1990
-- 	50 extra points
USE sql_store; 

UPDATE customers
SET points = points + 50
WHERE birth_date < "1990-01-01"


-- USING SUBQUERIES IN UPDATES
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = 
	(SELECT client_id
	FROM clients
	WHERE name = "Myworks");

-- subquery filter multiple data--- 
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN 
	(SELECT client_id
	FROM clients
	WHERE state IN  ("CA", "NY"));

-- best practice, use to select the data that you wanna update
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date;
SELECT *        -- > you can comment this after you know the data is correct
FROM invoices -- > you can comment this after you know the data is correct
WHERE payment_date IS NULL


-- ACTIVITY
-- update the comments of customer with more than 3000 points, regard them with gold customers
-- if they placed and order, update the comments column and set it to  gold  customer
-- USE sql_store;
UPDATE orders
SET comments = "gold customer"
WHERE customer_id IN 
		(SELECT customer_id
		FROM customers
		WHERE points > 3000);


-- DELETING ROWS
DELETE FROM invoices
WHERE invoice_id = (
		SELECT * 
		FROM clients
		WHERE name = "Myworks");
        

