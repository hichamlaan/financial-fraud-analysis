SELECT
    CAST(CAST(Time AS REAL) / 43200 AS INTEGER) AS time_period,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(
        100.0 * SUM(CASE WHEN Class = '1' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS fraud_rate
FROM transactions
GROUP BY time_period
ORDER BY time_period;