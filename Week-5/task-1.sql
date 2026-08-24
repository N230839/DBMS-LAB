USE paddu;
SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;
SELECT COUNT(*) AS total_income_records
FROM Income_Record;
SELECT SUM(amount) AS total_income
FROM Income_Record;
SELECT AVG(amount) AS average_income
FROM Income_Record;
SELECT MAX(amount) AS highest_income
FROM Income_Record;
SELECT MIN(amount) AS lowest_income
FROM Income_Record;
SELECT category_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY category_id;
SELECT category_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id;
SELECT category_id, AVG(amount) AS average_income
FROM Income_Record
GROUP BY category_id;
SELECT category_id, MAX(amount) AS highest_income
FROM Income_Record
GROUP BY category_id;
SELECT category_id, MIN(amount) AS lowest_income
FROM Income_Record
GROUP BY category_id;
SELECT year_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY year_id;
SELECT year_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY year_id;
SELECT category_id, year_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id, year_id;
SELECT category_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id
HAVING SUM(amount) > 1000000;
SELECT category_id, AVG(amount) AS average_income
FROM Income_Record
GROUP BY category_id
HAVING AVG(amount) > 500000;
SELECT year_id, COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY year_id
HAVING COUNT(*) > 3;
SELECT category_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id
ORDER BY SUM(amount) DESC;
SELECT category_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id
HAVING SUM(amount) > 1000000
ORDER BY SUM(amount) DESC;
SELECT category_id,
       SUM(amount) AS total_income,
       AVG(amount) AS average_income
FROM Income_Record
GROUP BY category_id;
SELECT category_id,
       year_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id, year_id
ORDER BY SUM(amount) DESC
LIMIT 1;
SELECT year_id,
       COUNT(DISTINCT taxpayer_id) AS number_of_taxpayers
FROM Income_Record
GROUP BY year_id;
SELECT category_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY category_id
ORDER BY SUM(amount) DESC
LIMIT 1;
SELECT year_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY year_id
ORDER BY SUM(amount) DESC
LIMIT 1;
SELECT category_id,
       AVG(amount) AS average_income
FROM Income_Record
GROUP BY category_id
ORDER BY AVG(amount) DESC
LIMIT 1;
SELECT category_id,
       COUNT(*) AS number_of_records
FROM Income_Record
GROUP BY category_id
HAVING COUNT(*) > 2;
SELECT year_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY year_id
HAVING SUM(amount) > 1000000;
SELECT category_id,
       COUNT(*) AS number_of_records,
       SUM(amount) AS total_income,
       AVG(amount) AS average_income,
       MAX(amount) AS highest_income,
       MIN(amount) AS lowest_income
FROM Income_Record
GROUP BY category_id;