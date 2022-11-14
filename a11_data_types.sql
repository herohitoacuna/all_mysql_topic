--  ************** MySQL DATA TYPES ***************
--      String Types
--      Numeric Types
--      Date and Time Types
--      Blob Types - for storing binary data
--      Spatial Types -for storing geography or geographical values



-- **** STRING TYPES ****
-- CHAR(x) fixed-length
-- VARCHAR(x) storing variable length strings, like username, passwords, emails, addresses, etc.
            --  max: 65,535 characters (~64KB)
-- MEDUIMTEXT   max: 16MB
-- LONGTEXT     max: 4GB
-- TINYTEXT     max: 255 bytes
-- TEXT         max: 64KB


--      Be Consistent!
--      VARCHAR(50) for short strings
--      VARCHAR(255) for medium-length string



-- **** INTEGER TYPES ****
-- Use to strore whole numbers that don't have a decimal point like 1,2,3,4

-- TINYINT  max: 1b [-128, 127]
-- UNSIGNED TINYINT [0, 255]
-- SMALLINT max: 2b [-32k, 32k]
-- MEDIUMINT max:3b [-8M, 8M]
-- INT  max: 4b [-2B, 2B]
-- BIGINT max:8B [-9Z, 9Z]



-- **** FIXED-POINT AND FLOATING_POINT TYPES ****
-- DECIMAL(p, s) p = precision - maximum number of digits between 1 and 65, s = sacle - determine the number of digits after decimal point. Example: DECIMAL(9, 2) => 1234567.89
-- DEC
-- NUMERIC
-- FIXED

-- *** USE WHEN THERE IS LARGE DATA
-- FLOAT    4b
-- DOUBLE   8b



-- **** BOOLEAN TYPES ****
-- BOOL or BOOLEAN - store YES or FALSE value
UPDATE posts
SET is_published = TRUE  -- # or FALSE



-- **** ENUMS and SET types ****
-- ENUMS - limited the column from list
-- Example:
ALTER TABLE `sql_store`.`products` 
ADD COLUMN `size` ENUM("small", "medium", "large") NULL AFTER `unit_price`;

-- SET - it set a list



-- **** DATE AND TIME types ****
-- DATE
-- TIME
-- DATETIME     8b
-- TIMESTAMP    4b  (up to 2038)
-- YEAR



-- **** BLOB types ****
-- use to store a large number of binary data such as images, videos, pdf's, word files, and etc.

-- TINYBLOB     max: 255b
-- BLOB         max:65KB
-- MEDIUMBLOB   max:16MB
-- LONGBLOB     max:4GB


-- ***** PROBLEMS WITH STORING FILES WITH A DATABASE
-- Increase database size
-- Slower backups
-- Performace problems
-- More code to read/write images



-- **** JSON types ****
-- JavaScript Object Notation(JSON) = Lightweight format for storing and transferring data over the internet.
UPDATE products
SET properties = " 
{	
	"dimensions": [1, 2, 3],
    "weight": 10,
    "manufacturer": {"name": "sony"} 
    }
"
WHERE product_id = 1;

-- or --- 
UPDATE products
SET properties = JSON_OBJECT(
    "weight", 10, 
    "diemensions", JSON_ARRAY(1, 2, 3), 
    "manufacturer", JSON_OBJECT("name", "sony"))
WHERE product_id = 1;


-- how to extract JSON key value pair
SELECT product_id, JSON_EXTRACT(properties, "$.weight") AS weight
FROM products
WHERE product_id = 1;

---- 
SELECT product_id, properties -> "$.weight" AS weight
FROM products
WHERE product_id = 1;


---- 
SELECT product_id, properties -> "$.dimensions[0]" AS weight
FROM products
WHERE product_id = 1;

--
SELECT product_id, properties ->> "$.manufacturer.name" AS manufacturer
FROM products
WHERE product_id = 1;
-- result = "sony"
-- (use ->>) result = sony


-- JSON_SET - use to update existing JSON data
UPDATE products
SET properties = JSON_SET(
	properties,
    "$.weight", 20,
    "$.age", 10
)
WHERE product_id = 1;

-- JSON_REMOVE
UPDATE products
SET properties = JSON_REMOVE(
	properties,
    "$.age"
)
WHERE product_id = 1;