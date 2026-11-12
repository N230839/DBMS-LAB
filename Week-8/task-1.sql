USE taxation_db;

SHOW TABLES;

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

DESCRIBE Income_Record;

SET @taxpayer_id = (SELECT taxpayer_id FROM Taxpayer ORDER BY taxpayer_id LIMIT 1);
SET @category_id = (SELECT category_id FROM Income_Category ORDER BY category_id LIMIT 1);
SET @year_id = (SELECT year_id FROM Financial_Year ORDER BY year_id LIMIT 1);

SET @income_id_1 = (SELECT income_id FROM Income_Record ORDER BY income_id LIMIT 1);
SET @income_id_2 = (SELECT income_id FROM Income_Record ORDER BY income_id LIMIT 1 OFFSET 1);

SET AUTOCOMMIT = 0;
SELECT @@AUTOCOMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = 850000
WHERE income_id = @income_id_1;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

COMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = 850000
WHERE income_id = @income_id_1;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

COMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = 950000
WHERE income_id = @income_id_1;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

ROLLBACK;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

SET @new_income_id = (SELECT COALESCE(MAX(income_id), 0) + 1 FROM Income_Record);

START TRANSACTION;

INSERT INTO Income_Record
    (income_id, taxpayer_id, income_source, amount, received_date,
     remarks, category_id, year_id)
VALUES
    (@new_income_id, @taxpayer_id, 'Lab Transaction Test', 50000.00,
     CURRENT_DATE, 'Temporary row for rollback demonstration',
     @category_id, @year_id);

SELECT * FROM Income_Record
WHERE income_id = @new_income_id;

ROLLBACK;

SELECT * FROM Income_Record
WHERE income_id = @new_income_id;

START TRANSACTION;

DELETE FROM Income_Record
WHERE income_id = @income_id_2;

SELECT * FROM Income_Record
WHERE income_id = @income_id_2;

ROLLBACK;

SELECT * FROM Income_Record
WHERE income_id = @income_id_2;

SET @new_income_id = (SELECT COALESCE(MAX(income_id), 0) + 1 FROM Income_Record);

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 1000
WHERE income_id = @income_id_1;

INSERT INTO Income_Record
    (income_id, taxpayer_id, income_source, amount, received_date,
     remarks, category_id, year_id)
VALUES
    (@new_income_id, @taxpayer_id, 'Lab Combined Transaction', 60000.00,
     CURRENT_DATE, 'Inserted during combined transaction',
     @category_id, @year_id);

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @new_income_id);

COMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 500
WHERE income_id = @income_id_1;

SAVEPOINT income_update;

UPDATE Income_Record
SET amount = amount + 1000
WHERE income_id = @income_id_2;

ROLLBACK TO SAVEPOINT income_update;

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @income_id_2);

COMMIT;

SET @new_income_id = (SELECT COALESCE(MAX(income_id), 0) + 1 FROM Income_Record);

START TRANSACTION;

INSERT INTO Income_Record
    (income_id, taxpayer_id, income_source, amount, received_date,
     remarks, category_id, year_id)
VALUES
    (@new_income_id, @taxpayer_id, 'Savepoint Insert Test', 40000.00,
     CURRENT_DATE, 'Insert before savepoint',
     @category_id, @year_id);

SAVEPOINT after_insert;

UPDATE Income_Record
SET amount = amount + 2000
WHERE income_id = @income_id_2;

ROLLBACK TO SAVEPOINT after_insert;

SELECT * FROM Income_Record
WHERE income_id = @new_income_id;

SELECT * FROM Income_Record
WHERE income_id = @income_id_2;

COMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 100
WHERE income_id = @income_id_1;

SAVEPOINT first_savepoint;

UPDATE Income_Record
SET amount = amount + 200
WHERE income_id = @income_id_2;

SAVEPOINT second_savepoint;

UPDATE Income_Record
SET amount = amount + 300
WHERE income_id = @income_id_1;

ROLLBACK TO SAVEPOINT first_savepoint;

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @income_id_2);

COMMIT;

SET @new_income_id = (SELECT COALESCE(MAX(income_id), 0) + 1 FROM Income_Record);

START TRANSACTION;

INSERT INTO Income_Record
    (income_id, taxpayer_id, income_source, amount, received_date,
     remarks, category_id, year_id)
VALUES
    (@new_income_id, @taxpayer_id, 'Savepoint Combined Test', 70000.00,
     CURRENT_DATE, 'Valid inserted row',
     @category_id, @year_id);

UPDATE Income_Record
SET amount = amount + 250
WHERE income_id = @income_id_1;

SAVEPOINT before_delete;

DELETE FROM Income_Record
WHERE income_id = @income_id_2;

ROLLBACK TO SAVEPOINT before_delete;

SELECT * FROM Income_Record
WHERE income_id IN (@new_income_id, @income_id_1, @income_id_2);

COMMIT;

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 10
WHERE income_id = @income_id_1;

SAVEPOINT release_test;

RELEASE SAVEPOINT release_test;

ROLLBACK;

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 50
WHERE income_id = @income_id_1;

SAVEPOINT partial_point;

UPDATE Income_Record
SET amount = amount + 75
WHERE income_id = @income_id_2;

ROLLBACK TO SAVEPOINT partial_point;

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @income_id_2);

ROLLBACK;

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @income_id_2);

CREATE USER IF NOT EXISTS 'tax_clerk1'@'localhost'
IDENTIFIED BY 'Tax@123';

GRANT SELECT ON taxation_db.Taxpayer
TO 'tax_clerk1'@'localhost';

GRANT INSERT ON taxation_db.Income_Record
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

CREATE OR REPLACE VIEW Taxpayer_Income_Summary AS
SELECT taxpayer_id, year_id, category_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id, year_id, category_id;

GRANT SELECT ON taxation_db.Taxpayer_Income_Summary
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

REVOKE INSERT ON taxation_db.Income_Record
FROM 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

CREATE USER IF NOT EXISTS 'tax_data_entry'@'localhost'
IDENTIFIED BY 'Entry@123';

GRANT SELECT, INSERT ON taxation_db.Income_Record
TO 'tax_data_entry'@'localhost';

CREATE USER IF NOT EXISTS 'tax_officer'@'localhost'
IDENTIFIED BY 'Officer@123';

GRANT SELECT, INSERT, UPDATE ON taxation_db.Income_Record
TO 'tax_officer'@'localhost';

GRANT SELECT ON taxation_db.Taxpayer_Income_Summary
TO 'tax_officer'@'localhost';

REVOKE UPDATE ON taxation_db.Income_Record
FROM 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';
SHOW GRANTS FOR 'tax_officer'@'localhost';

SET @new_income_id = (SELECT COALESCE(MAX(income_id), 0) + 1 FROM Income_Record);

START TRANSACTION;

INSERT INTO Income_Record
    (income_id, taxpayer_id, income_source, amount, received_date,
     remarks, category_id, year_id)
VALUES
    (@new_income_id, @taxpayer_id, 'Annual Income Submission', 90000.00,
     CURRENT_DATE, 'Integrated TCL insert',
     @category_id, @year_id);

SELECT * FROM Income_Record
WHERE income_id = @new_income_id;

COMMIT;

SELECT * FROM Income_Record
WHERE income_id = @new_income_id;

START TRANSACTION;

UPDATE Income_Record
SET amount = 999999
WHERE income_id = @income_id_1;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

ROLLBACK;

SELECT * FROM Income_Record
WHERE income_id = @income_id_1;

START TRANSACTION;

UPDATE Income_Record
SET amount = amount + 100
WHERE income_id = @income_id_1;

SAVEPOINT valid_change;

UPDATE Income_Record
SET amount = 999999
WHERE income_id = @income_id_2;

ROLLBACK TO SAVEPOINT valid_change;

COMMIT;

SELECT * FROM Income_Record
WHERE income_id IN (@income_id_1, @income_id_2);

GRANT SELECT, INSERT ON taxation_db.Income_Record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

GRANT SELECT ON taxation_db.Taxpayer_Income_Summary
TO 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

GRANT DELETE ON taxation_db.Income_Record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

REVOKE DELETE ON taxation_db.Income_Record
FROM 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

USE taxation_db;

SHOW TABLES;

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

SELECT @@AUTOCOMMIT;
SET AUTOCOMMIT = 1;

SELECT CURRENT_USER();

SHOW GRANTS FOR 'tax_clerk1'@'localhost';
SHOW GRANTS FOR 'tax_data_entry'@'localhost';
SHOW GRANTS FOR 'tax_officer'@'localhost';
