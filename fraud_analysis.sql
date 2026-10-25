-- Financial Fraud Analysis


-- 1. Check how transaction amounts are stored
SELECT
    typeof(Amount) AS data_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY typeof(Amount);


-- 2. Overall transaction count and fraud rate
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        AS fraudulent_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        / COUNT(*),
        3
    ) AS fraud_percentage
FROM transactions;


-- 3. Compare average transaction amounts
-- Class 0 = legitimate, Class 1 = fraudulent
SELECT
    Class,
    COUNT(*) AS total_transactions,
    ROUND(AVG(CAST(Amount AS REAL)), 2)
        AS average_amount
FROM transactions
GROUP BY Class;


-- 4. Analyze transactions over 200
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        AS fraudulent_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        / COUNT(*),
        3
    ) AS fraud_percentage
FROM transactions
WHERE CAST(Amount AS REAL) > 200;


-- 5. Compare average amounts for transactions over 200
SELECT
    Class,
    COUNT(*) AS total_transactions,
    ROUND(AVG(CAST(Amount AS REAL)), 2)
        AS average_amount
FROM transactions
WHERE CAST(Amount AS REAL) > 200
GROUP BY Class;


-- 6. Fraud analysis by transaction amount range
SELECT
    CASE
        WHEN CAST(Amount AS REAL) < 50 THEN 'Under 50'
        WHEN CAST(Amount AS REAL) < 100 THEN '50-99'
        WHEN CAST(Amount AS REAL) < 200 THEN '100-199'
        ELSE '200 and above'
    END AS amount_range,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        AS fraud_count,
    ROUND(
        100.0 * SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        / COUNT(*),
        3
    ) AS fraud_rate
FROM transactions
GROUP BY amount_range
ORDER BY MIN(CAST(Amount AS REAL));


-- 7. Fraud analysis by 12-hour time period
-- Time is measured in seconds since the first transaction.
-- 43200 seconds = 12 hours.
SELECT
    CAST(CAST(Time AS REAL) / 43200 AS INTEGER)
        AS time_period,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        AS fraud_count,
    ROUND(
        100.0 * SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END)
        / COUNT(*),
        3
    ) AS fraud_rate
FROM transactions
GROUP BY time_period
ORDER BY time_period;