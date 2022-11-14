-- ******** TRANSACTIONS *************
-- A group of SQL statements that represent a single unit of work
-- We use transactions where we want to make multiple changes to a database and we want all the these changes to succeed or fail together as a single unit


-- Transaction Properties
-- ACID Properties:
-- Atomicity 
    -- means our transactions are like atoms,  theyere aunbreakable. Each transaction is a single unit of work, no matter how many statements it contains.
-- Consistency
    -- means with these transactions, our database will always remain in a consistent state. We won't end up with an order without an item.
-- Isolation 
    -- means our transactions are isolated or protected from each other if they tried to modify the same data, so they cannot interfere with each other.
-- Durability
    -- means once a transaction is committed the changes made by the transaction are permanent. So if you have a power failure or system crash, we're not going to lose the system changes.



-- *** CREATING TRANSACTIONS ***
USE sql_store;

START TRANSACTION;

INSERT INTO orders ( customer_id, order_date, status)
VALUES (1, "2019-01-01", 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT;
-- success
-- if one of the query is failed, it rolled back all the changes that are made



-- *** CONCURRENCY and LOCKING ***
-- CONCURRENCY - more than 1 user accessing the database that are trying to retrieve or modify.
-- MySQL by default it will wait to commit the first transaction before other session can modify the data.



-- *** CONCURENCY PROBLEMS ***
-- LOST UPDATES - happens when 2 transactions update the same row and one that commits last overwrites the changes made earlier
-- DIRTY READS - happens when a transaction read data that hasn't been committed yet.
-- NON-REPEATING READS -happens when you read the same data twice in transaction but get different result
-- PHANTOM READS - happens when we miss one or more rows in our query because another transaction changes the data and we're not aware of the changes.



-- *** TRANSACTION ISOLATION LEVELS ***

-- TRANSACTION ISOLATION | LOST UPDATES    |   DIRTY READS | NON-REPEATING READS   | PHANTOM READS

-- READ UNCOMMITTED
-- READ COMMITTED                                   +
-- REPEATABLE READ            +                     +                   +
-- SERIALIZABLE               +                     +                   +                   +

-- low level of isolation means more concurrency or more people can make changes at the same time but more concurrency problems we'll encounter.
-- high level of isolation means we dont need to think about the problem but we need more resources because it takes much more memory to lock or isolate every transaction


-- DEFAULT Isolation is REPEATABLE READ ******


-- *** HOW TO SET ISOLATION LEVEL ***
SHOW VARIABLES LIKE "%transaction_isolation";
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;


-- *** READ UNCOMMITTED isolation level *** 
-- session 1
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 20
WHERE customer_id = 1;
ROLLBACK;

-- session 2
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT points
FROM customers
WHERE customer_id = 1;

-- result:
    -- points 
    -- 20



-- *** READ COMMITTED isolation level *** 
-- session 1
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = 20 -- change it into 30
WHERE customer_id = 1;
COMMIT;

-- session 2
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT points FROM customers WHERE customer_id = 1; -- execute the session 1 and we can get result 20
SELECT points FROM customers WHERE customer_id = 1; -- execute the session 1 and we can get result 30
COMMIT;



-- REPEATABLE READ Isolation level
-- *** REPEATABLE READ isolation level *** 
-- session 1
USE sql_store;
START TRANSACTION;
UPDATE customers
SET state = "VA"
WHERE customer_id = 1;
COMMIT;

-- session 2
USE sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM customers WHERE state = "VA"; -- we can get consistent data even there is another transaction modify our data
COMMIT;



-- *** SEREALIZABLE isolation level *** 
-- session 1
USE sql_store;
START TRANSACTION;
UPDATE customers
SET state = "VA"
WHERE customer_id = 3;
COMMIT;


USE sql_store;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM customers WHERE state = "VA"; -- it will wait until the session 1 commit his changes
COMMIT;



-- *** DEADLOCKS ***
-- DEADLOCKS happen when each transactions cannot complete because each transaction holds a lock that other need, both transactions wait for each other and never release their lock.
USE sql_store;
START TRANSACTION;
UPDATE orders SET status = 1 WHERE order_id = 1;
UPDATE customers SET state = "VA" WHERE customer_id = 1;
COMMIT;

-- minimize the deadlocks
-- 	follow the same order when updating multiple records
--  keep your transaction small and short in duration so they're not likely to collide with other transactions