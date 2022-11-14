-- *** CREATING VIEWS ***
-- VIEWS - the View is a virtual table created by a query by joining one or more tables

-- USE sql_invoicing;
CREATE VIEW sales_by_client AS
SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name
-- we can use our views with another query


-- ACTIVIY ***
-- Create a view to see the balance
-- for each client

-- clients_balance

--client_id
-- name
-- balance
CREATE VIEW clients_balance AS
SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total - payment_total) AS balance
FROM invoices i
JOIN clients c USING(client_id)
GROUP BY client_id, name
ORDER BY balance DESC



-- *** ALTERING OR DROPPING VIEWS ***
DROP VIEW sales_by_client;
-- remove view sales_by_client

CREATE OR REPLACE VIEW sales_by_client AS
SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name
-- to update save the file and add the repository


-- *** UPDATING VIEWS ***
-- If data dont have,
-- DISTINCT
-- Aggregate Functions
-- GROUP BY / HAVING
-- UNION
-- the VIEW is updatable. We can use UPDATE, DELETE

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT 
 invoice_id,
 number,
 client_id,
 invoice_total,
 payment_total,
 invoice_total - payment_total AS balance,
 invoice_date,
 due_date, 
 payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0;


-----
DELETE FROM invoices_with_balance
WHERE invoice_id = 1

-----
UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2



-- *** THE WITH OPTION CHECK ***
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT 
 invoice_id,
 number,
 client_id,
 invoice_total,
 payment_total,
 invoice_total - payment_total AS balance,
 invoice_date,
 due_date, 
 payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION -- prevent update or delete statements from excluding rows from the view


-- *** Other Benefits of Views ***
-- Simplify queries -- provide abstraction over our database table
-- Reduce the impact of changes 
-- Reduce access to the data

