USE paddu;

SELECT *
FROM Income_Record
WHERE amount = (
    SELECT MAX(amount)
    FROM Income_Record
);

SELECT *
FROM Income_Record
WHERE amount = (
    SELECT MIN(amount)
    FROM Income_Record
);

SELECT *
FROM Income_Record
WHERE amount > (
    SELECT AVG(amount)
    FROM Income_Record
);

SELECT *
FROM Income_Record
WHERE amount = (
    SELECT MAX(amount)
    FROM Income_Record
);

SELECT *
FROM Taxpayer
WHERE occupation = 'Business Owner';


SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);

SELECT *
FROM Income_Record
WHERE year_id IN (
    SELECT year_id
    FROM Financial_Year
    WHERE year_label = '2025-2026'
);

SELECT *
FROM Income_Record
WHERE amount > (
    SELECT MIN(amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);

SELECT *
FROM Income_Record
WHERE amount < (
    SELECT MAX(amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Salary'
    )
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount > (
        SELECT AVG(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount = (
        SELECT MAX(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Income_Record
WHERE amount > (
    SELECT AVG(amount)
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount > (
        SELECT AVG(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Income_Record
WHERE amount > ANY (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

SELECT *
FROM Income_Record
WHERE amount > ALL (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
    WHERE amount = (
        SELECT MAX(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Financial_Year
WHERE year_id IN (
    SELECT year_id
    FROM Income_Record
    GROUP BY year_id
    HAVING SUM(amount) = (
        SELECT MAX(total_income)
        FROM (
            SELECT year_id,
                   SUM(amount) AS total_income
            FROM Income_Record
            GROUP BY year_id
        ) AS yearly_income
    )
);

SELECT taxpayer_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT taxpayer_id,
               SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_totals
);


SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount = (
        SELECT MAX(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount > (
        SELECT AVG(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
    WHERE amount = (
        SELECT MAX(amount)
        FROM Income_Record
    )
);

SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
)
AND taxpayer_id NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

SELECT *
FROM Income_Record
WHERE amount > ALL (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

SELECT *
FROM Income_Record
WHERE amount > ANY (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

SELECT taxpayer_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT taxpayer_id,
               SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_totals
);

SELECT ir.*
FROM Income_Record ir
JOIN (
    SELECT category_id,
           AVG(amount) AS average_income
    FROM Income_Record
    GROUP BY category_id
) AS category_average
ON ir.category_id = category_average.category_id
WHERE ir.amount > category_average.average_income;
select * from income_record;