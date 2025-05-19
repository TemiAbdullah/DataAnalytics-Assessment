SELECT
    u.id AS customer_id,
    
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Calculating tenure in months from signup date to current date
    PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) AS tenure_months,

    -- Counting total number of inflow transactions
    COUNT(s.id) AS total_transactions,

    -- Estimating CLV based on the provided formula: (total_transactions / tenure) * 12 * avg_profit_per_transaction
    -- avg_profit_per_transaction = 0.001 * AVG(transaction_value)
    ROUND(
        IF(
            PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) = 0,
            0,
            (COUNT(s.id) / PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m'))) * 12 * (0.001 * AVG(s.confirmed_amount / 100.0))  -- convert kobo to naira
        ),
        2
    ) AS estimated_clv

FROM
    users_customuser u

-- Join to transactions (savings account) table
JOIN
    savings_savingsaccount s ON u.id = s.owner_id

-- Considering only actual inflows
WHERE
    s.confirmed_amount > 0

GROUP BY
    u.id, u.first_name, u.last_name, u.date_joined

ORDER BY
    estimated_clv DESC;
