WITH monthly_txn AS (
    SELECT
        s.owner_id,
        YEAR(s.transaction_date) AS txn_year,
        MONTH(s.transaction_date) AS txn_month,
        COUNT(*) AS transactions_in_month
    FROM
        savings_savingsaccount s
    GROUP BY
        s.owner_id,
        YEAR(s.transaction_date),
        MONTH(s.transaction_date)
),

-- Calculating the average number of transactions per customer per month
avg_txn_per_customer AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_txn_per_month
    FROM
        monthly_txn
    GROUP BY
        owner_id
),

-- Categorizing customers based on their average monthly transactions
categorized_customers AS (
    SELECT
        owner_id,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM
        avg_txn_per_customer
)

-- Aggregating the results by category
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM
    categorized_customers
GROUP BY
    frequency_category;
