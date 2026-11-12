USE taxation_db;

SHOW TABLES;

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

DELIMITER //

DROP PROCEDURE IF EXISTS welcome_taxation//
CREATE PROCEDURE welcome_taxation()
BEGIN
    SELECT 'Welcome to TaxationDB' AS message;
END//

DROP PROCEDURE IF EXISTS show_taxpayer_details//
CREATE PROCEDURE show_taxpayer_details(IN p_taxpayer_id INT)
BEGIN
    SELECT full_name, annual_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END//

DROP PROCEDURE IF EXISTS calculate_income_percentage//
CREATE PROCEDURE calculate_income_percentage(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_income * 0.10 AS ten_percent_income;
END//

DROP PROCEDURE IF EXISTS display_taxpayer_information//
CREATE PROCEDURE display_taxpayer_information(IN p_taxpayer_id INT)
BEGIN
    SELECT full_name, pan_number, occupation, annual_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END//

DROP PROCEDURE IF EXISTS check_taxpayer_status//
CREATE PROCEDURE check_taxpayer_status(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_active INT;

    SELECT is_active
    INTO v_active
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_active = 1 THEN
        SELECT 'Active' AS taxpayer_status;
    ELSE
        SELECT 'Inactive' AS taxpayer_status;
    END IF;
END//

DROP FUNCTION IF EXISTS check_taxable_status//
CREATE FUNCTION check_taxable_status(p_amount DECIMAL(12,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_amount > 0 THEN
        RETURN 'Taxable';
    ELSE
        RETURN 'Non-Taxable';
    END IF;
END//

DROP PROCEDURE IF EXISTS display_numbers//
CREATE PROCEDURE display_numbers()
BEGIN
    DECLARE v_count INT DEFAULT 1;

    WHILE v_count <= 10 DO
        SELECT v_count AS number_value;
        SET v_count = v_count + 1;
    END WHILE;
END//

DROP PROCEDURE IF EXISTS classify_taxpayer_income//
CREATE PROCEDURE classify_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income > 1000000 THEN
        SELECT 'High Income' AS income_category;
    ELSEIF v_income >= 500000 THEN
        SELECT 'Medium Income' AS income_category;
    ELSE
        SELECT 'Low Income' AS income_category;
    END IF;
END//

DROP FUNCTION IF EXISTS get_annual_income//
CREATE FUNCTION get_annual_income(p_taxpayer_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    RETURN v_income;
END//

DROP PROCEDURE IF EXISTS display_active_taxpayers//
CREATE PROCEDURE display_active_taxpayers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_occupation VARCHAR(100);

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income, occupation
        FROM Taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor INTO v_name, v_income, v_occupation;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_occupation AS occupation;
    END LOOP;

    CLOSE taxpayer_cursor;
END//

DROP PROCEDURE IF EXISTS find_taxpayer//
CREATE PROCEDURE find_taxpayer(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_not_found = 1;

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SELECT v_name AS taxpayer_name,
               v_income AS annual_income;
    END IF;
END//

DROP PROCEDURE IF EXISTS update_taxpayer_income//
CREATE PROCEDURE update_taxpayer_income(
    IN p_taxpayer_id INT,
    IN p_new_income DECIMAL(12,2)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_count > 0 THEN
        UPDATE Taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;

        SELECT 'Income updated successfully' AS message;
    ELSE
        SELECT 'Taxpayer not found' AS message;
    END IF;
END//

DROP PROCEDURE IF EXISTS classify_income_case//
CREATE PROCEDURE classify_income_case(IN p_income DECIMAL(12,2))
BEGIN
    CASE
        WHEN p_income > 1000000 THEN
            SELECT 'High' AS income_category;
        WHEN p_income >= 500000 THEN
            SELECT 'Medium' AS income_category;
        ELSE
            SELECT 'Low' AS income_category;
    END CASE;
END//

DROP PROCEDURE IF EXISTS display_income_records//
CREATE PROCEDURE display_income_records(IN p_taxpayer_id INT)
BEGIN
    SELECT income_source, category_id, amount, received_date, year_id
    FROM Income_Record
    WHERE taxpayer_id = p_taxpayer_id;
END//

DROP PROCEDURE IF EXISTS display_all_income_records//
CREATE PROCEDURE display_all_income_records()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_income_id INT;
    DECLARE v_source VARCHAR(100);
    DECLARE v_amount DECIMAL(12,2);
    DECLARE v_year_id INT;

    DECLARE income_cursor CURSOR FOR
        SELECT income_id, income_source, amount, year_id
        FROM Income_Record;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN income_cursor;

    read_loop: LOOP
        FETCH income_cursor
        INTO v_income_id, v_source, v_amount, v_year_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_income_id AS income_id,
               v_source AS income_source,
               v_amount AS amount,
               v_year_id AS year_id;
    END LOOP;

    CLOSE income_cursor;
END//

DROP FUNCTION IF EXISTS classify_income_amount//
CREATE FUNCTION classify_income_amount(p_amount DECIMAL(12,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_amount <= 500000 THEN
        RETURN 'No Tax Category';
    ELSEIF p_amount <= 1000000 THEN
        RETURN 'Moderate Income';
    ELSE
        RETURN 'High Income';
    END IF;
END//

DELIMITER ;

CALL welcome_taxation();

CALL show_taxpayer_details(1);

CALL calculate_income_percentage(1);

CALL display_taxpayer_information(1);

CALL check_taxpayer_status(1);

SELECT check_taxable_status(500000) AS taxable_status;

CALL display_numbers();

CALL classify_taxpayer_income(1);

SELECT full_name, get_annual_income(taxpayer_id) AS annual_income
FROM Taxpayer;

CALL display_active_taxpayers();

CALL find_taxpayer(1);

CALL update_taxpayer_income(1, 850000);

CALL classify_income_case(850000);

CALL display_income_records(1);

CALL display_all_income_records();

SELECT full_name,
       classify_income_amount(annual_income) AS income_classification
FROM Taxpayer;
