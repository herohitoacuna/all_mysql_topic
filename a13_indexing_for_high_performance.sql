-- *********** INDEXING FOR HIGH PERFORMANCE ***********
-- Indexes speed up our queries
-- Indexes are data structure that database engine use to quickly find data.

-- COST OF INDEXES:
--      Increase the database
--      Slow down the writes

-- Reserve indexes for performance critical queries
-- Design indexes based on your queries, not your tables.


-- *********** CREATING INDEXES ************
EXPLAIN SELECT customer_id FROM customers WHERE state = "CA";

CREATE INDEX idx_state ON customers (state);


-- ACTIVITY ***
-- Write a query to find customers with more than
-- 1000 points
EXPlAIN SELECT customer_id FROM customers WHERE points > 1000;

SELECT customer_id FROM customers WHERE points > 1000;

CREATE INDEX idx_points ON customers (points);



-- ******** VIEWING INDEXES ********
SHOW INDEXES IN customers;


-- ********* PREFIX INDEXES *****
-- prefix indexes use for creating indexes in string column. We dont want to make an index and search for all strings in column that will take so much memory in our database.
CREATE INDEX idx_lastname ON customers (lastt_name(20));

SELECT 
    COUNT(DISTINCT LEFT(last_name, 1)), 
    COUNT(DISTINCT LEFT(last_name, 5)), -- > optimal prefix length
    COUNT(DISTINCT LEFT(last_name, 10))  
FROM customers;



-- *********** FULL-TEXT INDEXES ***************
-- we use full-text index to build fast and flexible applications in our search engines.
CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);

SELECT 
	*, 
	MATCH(title, body) AGAINST("react redux") -- return the relevancy of row
FROM posts 
WHERE MATCH(title, body) AGAINST("react -redux +form" IN BOOLEAN MODE);

-- fulltext = use it when you want to build a search engine in your application where you can search for a long string columns
-- prefix = use it when you want to search only for short string like fullname, lastname, and etc.



-- ************** COMPOSITE INDEXES ************
USE sql_store;

CREATE INDEX idx_state_points ON customers (state, points);

EXPLAIN SELECT customer_id FROM customers
WHERE state = "CA" AND points > 1000;

-- sometimes its better to use the composite index than using two indexes because two indexes can take up so much space and do the half job only.



-- ************** ORDER OF COLUMNS IN COMPOSITE INDEXES **************

-- ORDER OF COLUMNS:
--      We should order our columns base on the column wherein most frequently used first.
--      Put the columns with a higher cardinality first.
--      take your queries into account

EXPLAIN SELECT customer_id 
FROM customers
USE INDEX(idx_state_lastname)
WHERE state LIKE "A%" AND last_name LIKE "%A%";

CREATE INDEX idx_lastname_state ON customers (last_name, state);

CREATE INDEX idx_state_lastname ON customers (state, last_name);



-- ************ WHEN INDEXES ARE IGNORED ***************
-- ALways isolate your column.
EXPLAIN SELECT customer_id FROM customers
WHERE points + 10 > 2010; -- > search for 1010 data

-- 
EXPLAIN SELECT customer_id FROM customers
WHERE points > 2000; -- > search for 3 data


-- *********** USING INDEXES FOR SORTING ************
EXPLAIN SELECT customer_id FROM customers 
WHERE state = "CA"
ORDER BY points ;

SHOW STATUS LIKE "last_query_cost";

-- dont sort unless its necessary
-- filesort = using this can become more cost in our database

-- (a, b)
-- ways to sort our data
-- a
-- a, b
-- a DESC, b DESC



-- **************** COVERINGstate INDEXES **************
EXPLAIN SELECT customer_id, state FROM customers; 
SHOW STATUS LIKE "last_query_cost";

-- use indexes where in most commonly used column



-- **************** INDEX MAINTENANCE ***************
-- always check the existing indexes so that you will not duplicate the index
-- index (a ,b) is the same as index (a)