-- *** SUBQUERIES ***
-- Find products that are more
-- expensive than Lettuce (id = 3)
SELECT *
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
);

-- ACTIVITY ***
-- In sql_hr database
-- 	 Find employees whose earn more than average
SELECT *
FROM employees
WHERE salary > 
	(SELECT AVG(salary)
	FROM employees);


-- *** subqueries using IN Operator ***
-- Find the products that have never been ordered

-- USE sql_store;
SELECT * 
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
	FROM order_items
)

-- ACTIVITY ***
-- Find clients without invoices

-- USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
	FROM invoices
);


-- *** SUBQUARIES vs JOINS ***
-- USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
	FROM invoices
);

SELECT *
FROM clients
LEFT JOIN invoices USING (client_id)
WHERE invoice_id IS NULL;

-- ACTIVITY ***
-- Find customers who have ordered lettuce (id = 3)
-- 	 Select customer_id, first_name, last_name

-- USE sql_store;
-- Using JOIN
SELECT DISTINCT
	customer_id,
    first_name,
    last_name
FROM orders o
JOIN order_items oi USING (order_id)
JOIN customers c USING (customer_id)
WHERE oi.product_id = 3;

-- Using SUBQUERIES
SELECT 
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id
    FROM orders
    WHERE order_id IN (
		SELECT order_id
        FROM order_items
        WHERE product_id = 3
    )
);

-- Using SUBQUERIES and JOIN
SELECT 
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT o.customer_id
    FROM order_items oi
    JOIN orders o USING (order_id)
    WHERE product_id = 3
)


-- *** the ALL keyword ***
-- Select invoices larger than all invoices of
-- client 3

-- USE sql_invoicing;
SELECT * 
FROM invoices 
WHERE invoice_total > (
	SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
);

-- using ALL keyword
SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
    -- > this subquery returns multiple values, using ALL keyword it will compare to all multiple values
)


-- *** the ANY keyword ***
-- Select clients with at least two invoices
SELECT *
FROM clients
WHERE client_id IN (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) > 2
)

-- another solution
SELECT *
FROM clients
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) > 2
)


-- *** Correlated Subqueries ***
-- Select employees whose salary is
-- above the average in their office

-- PSUEDOCODE: 
-- 	for each employee
-- 	 calculate the avg salary for employees.office
-- 	 return employee if salary > avg

-- USE sql_hr;
SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id 
)


-- ACTIVITY ***
-- Get invoices that are larger than
-- client's average invoice amount

-- USE sql_invoicing;
SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
)


-- *** the EXISTS Operator ***
-- Select clients that have an invoice
SELECT *
FROM clients
WHERE client_id IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- with exists keyword
-- recommended with millions of rows
SELECT *
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
    -- with this subquery with exists keyword doesn't return anything but it will lookup in every row
);


-- ACTIVITY ***
-- Find the products that have never been ordered

-- USE sql_store;
SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT product_id
    FROM order_items
);

-- using exists keyword
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
)


-- *** Subqueries in the SELECT Clause
-- USE sql_invoicing;
SELECT 
	invoice_id, 
    invoice_total,
	(SELECT AVG(invoice_total)
		FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference
FROM invoices

-- ACTIVITyY ***
-- write a query that produce client_id, name, total_sales, average, difference

SELECT 
	client_id,
    c.name,
    SUM(invoice_total) AS total_sales, -- > (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales
    (SELECT AVG(invoice_total) FROM invoices) AS average,
    SUM(invoice_total) - (SELECT average) as difference --> (SELECT total_sales - average) AS difference
FROM clients c
LEFT JOIN invoices i USING(client_id) -- > you can remove this
GROUP BY client_id
ORDER BY client_id



-- *** Subqueries in the FROM clause ***
SELECT *
 FROM(
	 SELECT 
		client_id,
		c.name,
		(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c
) AS sales_summary
WHERE total_sales IS NOT NULL

-- takeaway
-- you can write subqueries FROM clause statemet and reserve it for only simple queries



