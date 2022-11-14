-- ***** TRIGGER *****
-- A block of SQL code that automatically get executed before or after an insert, update or delete statement
DELIMITER $$
-- tablename_after_insert/delete/upate
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    -- NEW keyword return the new column we added
    -- OLD keyword return the old column
    WHERE invoice_id = NEW.invoice_id;
END $$

DELIMITER ;


-- how to use it
INSERT INTO payments
VALUES (DEFAULT, 5, 3, "2019-01-01", 10, 1);


-- ACTIVITy ***
-- Create a trigger that gets fired when we
-- delete a payment
DELIMITER $$

CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END $$

DELIMITER ;


-- to test
DELETE 
FROM payments
WHERE payment_id = 11;



-- *** VIEW TRIGGERS ***
SHOW TRIGGERS;
SHOW TRIGGERS LIKE "payments%"


-- *** DROPPING TRIGGERS ***
DROP TRIGGER IF EXISTS payments_after_insert;

-- best practice
DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$

DELIMITER ;


-- *** USING TRIGGERS FOR AUDITING ***
USE sql_invoicing;

CREATE TABLE payments_audit
(
	client_id 	INT 			NOT NULL,
    date 		DATE 			NOT NULL,
    amount 		DECIMAL(9, 2) 	NOT NULL,
    action_type VARCHAR(50) 	NOT NULL,
    action_date DATETIME 		NOT NULL
)

---- 
DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, "Insert", NOW());
END $$

DELIMITER ;


---
DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete;

CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments _audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, "Delete", NOW());
END $$

DELIMITER ;


--- 
INSERT INTO payments
VALUES (DEFAULT, 5, 3, "2019-01-01", 10, 1);

DELETE FROM payments
WHERE payment_id = 15;



--- ********** EVENTS *************
-- A task (or block of SQL code) that gets executed according to a schedule
-- example we can run it everyday at 10am or every once a month
-- with event we can automate our databse maintance

-- before we can schedule an event, we need to turn on MySQL event scheduler
SHOW VARIABLES LIKE "event%";
SET GLOBAL event_scheduler = ON;

-- How to create EVENT
DELIMITER $$

CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE 
	-- AT "2019-05-01" -- use "AT" if we like to execute it once
    EVERY 1 YEAR STARTS  "2019-01-01" ENDSS "2029-01-01"
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$

DElIMITER ;


-- *** Viewing, Dropping and Altering Events ***
SHOW EVENTS;
SHOW EVENTS LIKE "yearly%";
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;
ALTER EVENT yearly_delete_stale_audit_rows DISABLE; -- we can disable or enable an event