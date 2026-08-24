USE paddu;

-- PART A 
SHOW TABLES;
SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

-- LEVEL 1 

-- Task 1
SELECT t.full_name, i.income_source
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id;

-- Task 2
SELECT t.full_name, c.category_name
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id;

-- Task 3
SELECT i.income_id, i.income_source, i.amount, f.year_label
FROM Income_Record AS i
INNER JOIN Financial_Year AS f
ON i.year_id = f.year_id;

-- Task 4
SELECT t.full_name, t.annual_income, i.amount AS income_amount
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id;

-- Task 5
SELECT t.full_name, i.income_source, c.category_name, f.year_label
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id
INNER JOIN Financial_Year AS f
ON i.year_id = f.year_id;

-- LEVEL 2 

-- Task 1
SELECT t.full_name, i.income_source AS organization
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id
WHERE c.category_name = 'Salary';

-- Task 2
SELECT t.full_name, t.occupation, i.income_source
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id
WHERE c.category_name = 'Business';

-- Task 3
SELECT t.*, f.start_date, f.end_date
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Financial_Year AS f
ON i.year_id = f.year_id;

-- Task 4
SELECT t.*, c.description AS category_description
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id;

-- Task 5
SELECT t.full_name AS taxpayer_name,
       t.pan_number,
       t.occupation,
       i.income_source,
       c.category_name AS income_category,
       i.amount AS income_amount,
       f.year_label AS financial_year,
       f.start_date,
       f.end_date
FROM Taxpayer AS t
INNER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN Income_Category AS c
ON i.category_id = c.category_id
INNER JOIN Financial_Year AS f
ON i.year_id = f.year_id;

-- LEVEL 3 

-- Task 1
SELECT t.taxpayer_id, t.full_name, i.income_id, i.income_source, i.amount
FROM Taxpayer AS t
LEFT OUTER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id;

-- Task 2
SELECT c.category_id, c.category_name, i.income_id, i.income_source, i.amount
FROM Income_Record AS i
RIGHT OUTER JOIN Income_Category AS c
ON i.category_id = c.category_id;

-- Task 3
SELECT t.taxpayer_id, t.full_name, i.income_id, i.income_source, i.amount
FROM Taxpayer AS t
LEFT OUTER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id
UNION
SELECT t.taxpayer_id, t.full_name, i.income_id, i.income_source, i.amount
FROM Taxpayer AS t
RIGHT OUTER JOIN Income_Record AS i
ON t.taxpayer_id = i.taxpayer_id;

-- Task 4
SELECT t.taxpayer_id, t.full_name, f.year_id, f.year_label
FROM Taxpayer AS t
CROSS JOIN Financial_Year AS f;

-- Task 5
SELECT a.full_name AS taxpayer_1,
       b.full_name AS taxpayer_2,
       a.occupation
FROM Taxpayer AS a
INNER JOIN Taxpayer AS b
ON a.occupation = b.occupation
AND a.taxpayer_id < b.taxpayer_id;
