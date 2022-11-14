-- *** STORED PROCEDURE ***
-- is a database object hat contains a block of SQL code
-- Store and organize SQL 
-- Faster execution
-- Data security


-- *** CREATING STORED PROCEDURE ***
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$

DELIMITER ;

-- to call
CALL get_clients();


-- ACTIVITy ***
-- Create a stored procedure called
--  get_invoices_with_balance
--  to return all the invoices with a balance > 0
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT * 
    FROM invoices_with_balance
    WHERE balance > 0;
END$$
DELIMITER ;



-- *** Creating Procedures Using MySQLWorkbench ***
-- right click on the stored procedure and click create stored procedure


-- *** Dropping Stored Procedures ***
DROP PROCEDURE IF EXISTS get_clients;

DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;
-- better to practice the DROP PROCEDURE IF EXISTS and save it to repository.



-- *** PARAMETERS IN STORED PROCEDURE ***
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
    (
		state CHAR(2) -- VARCHAR- variable length string to storing names, phone numbers, messages and etc.
    )
BEGIN
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;



-- ACTIVITY ***
-- Write a stored procedure to return invoices
-- for a given client
-- 
-- get_invoices_by_client

DROP PROCEDURE IF EXISTS get_invoices_by_client;

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
    (
		client_id INT
    )
BEGIN
	SELECT * FROM invoices i
    WHERE i.client_id = client_id;
END$$
DELIMITER ;



-- *** PARAMETERS with DEFAULT VALUES ***
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
    (
		state CHAR(2)
    )
BEGIN
	IF state IS NULL OR "" THEN 
		SET state = "CA";
	END IF;
    
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;



----
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
    (
		state CHAR(2)
    )
BEGIN
	IF state IS NULL THEN 
		SELECT * FROM clients;
	ELSE
		SELECT * FROM clients c
		WHERE c.state = state;
	END IF;
END$$
DELIMITER ;



-- OR instead of using IF state is NULL THEN
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
    (
		state CHAR(2)
    )
BEGIN
		SELECT * FROM clients c
		WHERE c.state = IFNULL(state, c.state); -- 1 = 1
END$$
DELIMITER ;


-- ACTIVITY ***
-- Write a stored procedure called get_payments
-- with two parameters
---
--      client_id => INT
--      payment_method_id => TINYINT
-- return
DROP PROCEDURE IF EXISTS get_payments;

CREATE PROCEDURE `get_payments`
(
	client_id INT,
    payment_method_id TINYINT
)
BEGIN
	SELECT *
    FROM payments p
    WHERE 
		p.client_id = IFNULL(client_id, p.client_id) AND 
        p.payment_method = IFNULL(payment_method_id, p.payment_method);
END



-- *** PARAMETER VAlidation ***
CREATE PROCEDURE `make_payment`(
	invoice_id INT,
    payment_amount DECIMAL(9, 2), -- 123456789.01
    payment_date DATE
)
BEGIN
	UPDATE invoices i
    SET 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
    WHERE i.invoice_id = invoice_id;
END


---- data validation using IF
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_payment`(
	invoice_id INT,
    payment_amount DECIMAL(9, 2), -- 123456789.01
    payment_date DATE
)
BEGIN
	IF payment_amount <= 0 THEN
		SIGNAL SQLSTATE "22003" SET MESSAGE_TEXT = "Invalid payment amount";
	END IF;
	UPDATE invoices i
    SET 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
    WHERE i.invoice_id = invoice_id;
END



-- *** OUTPUT PARAMETERS ***
CREATE PROCEDURE `get_unpaid_invoices_for_client`(
	client_id INT,
    OUT invoices_count INT, -- this marks as output parameters, so we can use them to get values out o this procedure
    OUT invoices_total DECIMAL(9, 2)
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id AND payment_total = 0;
END

-- result 
set @invoices_count = 0; -- > called user variables
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;


-- *** VARIABLES ***
-- User or session variables
SET @invoice_count = 0

-- Local Variables
-- Dont stay in memory for the entire user session. As soon as execution, these variables are freed up.
-- Usually use to perform calculation in our STORE PROCEDURE

-- Local Variables
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_risk_factor`()
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
	DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices;
    
    SET risk_factor = invoices_total / invoices_count * 5;
    
    SELECT risk_factor;
-- Buss Logic
--  risk_factor = invoice_total / invoice_count * 5
END



-- *** FUNCTIONS ***
-- create your function
-- return only a single value
-- cannot return multiple rows and column

CREATE DEFINER=`root`@`localhost` FUNCTION `get_risk_factor_for_client`(
	client_id INT
) RETURNS int
    READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
	DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoices_total / invoices_count * 5;
    
	RETURN IFNULL(risk_factor, 0);
END


-- how to use your function
SELECT 
	client_id, 
    name,
    get_risk_factor_for_client(client_id)
FROM clients;


-- how to drop a function
DROP FUNCTION IF EXISTS get_risk_factor_for_client;


