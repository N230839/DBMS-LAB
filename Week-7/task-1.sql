USE taxation_db;
CREATE VIEW highest_income_view AS
SELECT *
FROM Income_Record
WHERE amount = (SELECT MAX(amount) FROM Income_Record);

SELECT * FROM highest_income_view;

CREATE VIEW lowest_income_view AS
SELECT *
FROM Income_Record
WHERE amount = (SELECT MIN(amount) FROM Income_Record);

SELECT * FROM lowest_income_view;

CREATE VIEW above_average_income AS
SELECT *
FROM Income_Record
WHERE amount > (SELECT AVG(amount) FROM Income_Record);

SELECT * FROM above_average_income;

CREATE VIEW highest_recorded_income AS
SELECT *
FROM Income_Record
WHERE amount = (SELECT MAX(amount) FROM Income_Record);

SELECT * FROM highest_recorded_income;

CREATE VIEW business_owner_view AS
SELECT taxpayer_id, full_name, occupation
FROM Taxpayer
WHERE occupation = 'Business Owner';

SELECT * FROM business_owner_view;

CREATE VIEW taxpayers_with_income AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id;

SELECT * FROM taxpayers_with_income;

CREATE VIEW business_income_taxpayers AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = 'Business';

SELECT * FROM business_income_taxpayers;

CREATE VIEW income_2025_2026 AS
SELECT i.*
FROM Income_Record i
INNER JOIN Financial_Year f
ON i.year_id = f.year_id
WHERE f.year_label = '2025-2026';

SELECT * FROM income_2025_2026;

CREATE VIEW greater_than_min_business_income AS
SELECT i.*
FROM Income_Record i
WHERE i.amount > (
    SELECT MIN(i2.amount)
    FROM Income_Record i2
    INNER JOIN Income_Category c
    ON i2.category_id = c.category_id
    WHERE c.category_name = 'Business'
);

SELECT * FROM greater_than_min_business_income;

CREATE VIEW less_than_max_salary_income AS
SELECT i.*
FROM Income_Record i
WHERE i.amount < (
    SELECT MAX(i2.amount)
    FROM Income_Record i2
    INNER JOIN Income_Category c
    ON i2.category_id = c.category_id
    WHERE c.category_name = 'Salary'
);

SELECT * FROM less_than_max_salary_income;

CREATE VIEW taxpayers_above_average_income AS
SELECT DISTINCT t.*
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.amount > (SELECT AVG(amount) FROM Income_Record);

SELECT * FROM taxpayers_above_average_income;

CREATE VIEW categories_with_income AS
SELECT DISTINCT c.*
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id;

SELECT * FROM categories_with_income;

CREATE VIEW taxpayers_no_investment AS
SELECT t.*
FROM Taxpayer t
WHERE t.taxpayer_id NOT IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM taxpayers_no_investment;

CREATE VIEW highest_income_taxpayer AS
SELECT t.*, i.income_amount
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.income_amount = (SELECT MAX(income_amount) FROM Income_Record);

SELECT * FROM highest_income_taxpayer;

CREATE VIEW greater_than_avg_business_income AS
SELECT i.*
FROM Income_Record i
WHERE i.income_amount > (
    SELECT AVG(i2.income_amount)
    FROM Income_Record i2
    INNER JOIN Income_Category c
    ON i2.category_id = c.category_id
    WHERE c.category_name = 'Business'
);

SELECT * FROM greater_than_avg_business_income;

CREATE VIEW taxpayers_above_avg_total AS
SELECT t.taxpayer_id, t.taxpayer_name, SUM(i.income_amount) AS total_income
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
GROUP BY t.taxpayer_id, t.taxpayer_name
HAVING SUM(i.income_amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT SUM(income_amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) x
);

SELECT * FROM taxpayers_above_avg_total;

CREATE VIEW greater_than_any_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ANY (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM greater_than_any_investment;

CREATE VIEW greater_than_all_investment AS
SELECT *
FROM Income_Record
WHERE income_amount > ALL (
    SELECT i.income_amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM greater_than_all_investment;

CREATE VIEW highest_income_category AS
SELECT c.category_id, c.category_name, i.amount
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id
WHERE i.amount = (SELECT MAX(amount) FROM Income_Record);

SELECT * FROM highest_income_category;

CREATE VIEW highest_income_year AS
SELECT f.year_id, f.year_label, SUM(i.amount) AS total_income
FROM Financial_Year f
INNER JOIN Income_Record i
ON f.year_id = i.year_id
GROUP BY f.year_id, f.year_label
HAVING SUM(i.amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY year_id
    ) x
);

SELECT * FROM highest_income_year;

CREATE VIEW real_highest_income_taxpayer AS
SELECT t.taxpayer_id, t.full_name, i.amount
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.amount = (SELECT MAX(amount) FROM Income_Record);

SELECT * FROM real_highest_income_taxpayer;

CREATE VIEW real_above_average_taxpayers AS
SELECT DISTINCT t.taxpayer_id, t.full_name
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.amount > (SELECT AVG(amount) FROM Income_Record);

SELECT * FROM real_above_average_taxpayers;

CREATE VIEW real_highest_income_category AS
SELECT c.category_id, c.category_name
FROM Income_Category c
INNER JOIN Income_Record i
ON c.category_id = i.category_id
WHERE i.amount = (SELECT MAX(amount) FROM Income_Record);

SELECT * FROM real_highest_income_category;

CREATE VIEW business_no_investment AS
SELECT t.*
FROM Taxpayer t
WHERE t.taxpayer_id IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Business'
)
AND t.taxpayer_id NOT IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM business_no_investment;

CREATE VIEW real_greater_than_all_investment AS
SELECT *
FROM Income_Record
WHERE amount > ALL (
    SELECT i.amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM real_greater_than_all_investment;

CREATE VIEW real_greater_than_any_investment AS
SELECT *
FROM Income_Record
WHERE amount > ANY (
    SELECT i.amount
    FROM Income_Record i
    INNER JOIN Income_Category c
    ON i.category_id = c.category_id
    WHERE c.category_name = 'Investment'
);

SELECT * FROM real_greater_than_any_investment;

CREATE VIEW highest_total_income_taxpayer AS
SELECT t.taxpayer_id, t.full_name, SUM(i.amount) AS total_income
FROM Taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
GROUP BY t.taxpayer_id, t.full_name
HAVING SUM(i.amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) x
);

SELECT * FROM highest_total_income_taxpayer;

CREATE VIEW category_average_income_records AS
SELECT i.*
FROM Income_Record i
INNER JOIN (
    SELECT category_id, AVG(amount) AS average_income
    FROM Income_Record
    GROUP BY category_id
) a
ON i.category_id = a.category_id
WHERE i.amount > a.average_income;

SELECT * FROM category_average_income_records;
