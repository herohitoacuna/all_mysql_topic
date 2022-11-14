-- AGGREGATE FUNCTIONS
-- aggregate functions - piece of code can be reuse to summarize data

-- MAX(which column or expression) - use to get the maximum value
-- MIN(which column or expression) - use to get the minimum value
-- AVG(which column or expression) - use to get the average
-- SUM(which column or expression)
-- COUNT(which column or expression)

-- USE sql_invoicing;

SELECT 
	MAX(invoice_total) AS highest,
	MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total * 1.1) AS total,
    -- COUNT(invoice_total) AS number_of_invoices,
    -- COUNT(payment_date) AS count_of_payment,
    COUNT(DISTINCT client_id) AS total_records
FROM invoices
WHERE invoice_date > "2019-07-01"


-- ACTIVITY
-- write a SQL query in invoices table to get date_range, total_sales, total_payments and what_we_expect
SELECT
	"First half of 2019" AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN "2019-01-01" AND "2019-06-30"
UNION
SELECT
	"Second half of 2019" AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN "2019-07-01" AND "2019-12-31"
UNION
SELECT
	"Total" AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN "2019-01-01" AND "2019-12-31";



-- *** GROUP BY clause ***
-- group by single column
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date >= "2019-07-01"
GROUP BY client_id
ORDER BY total_sales DESC

--groub by multiple columns
SELECT 
	state,
	city,
	SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state, city


-- ACTIVITY **
-- write a query that will get the date, payment_method and total_payments
SELECT 
	p.date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY p.date, pm.name
ORDER BY p.date;



-- *** the HAVING clause ***
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales
FROM invoices
-- WHERE -- > we can filter data before our rows are grouped
GROUP BY client_id
HAVING total_sales > 500 --> we can filter data after our rows are grouped

------
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices  > 5 


-- ACTIVITY ***
-- Get the customers
-- 		located in Virginia
-- 		who have spent more than $100

-- USE sql_store;
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) As total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE state = "VA"	
GROUP BY 
	c.customer_id,
    c.first_name,
    c.last_name
HAVING total_sales > 100


-- *** the ROLLUP Operator ***
-- USE sql_invoicing;
SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING(client_id)
GROUP BY state, city WITH ROLLUP


-- ACTIVITY **
-- get the total amount in different payment_method
SELECT 
	pm.name AS payment_method,
    SUM(amount) AS total
FROM payments p 
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;





