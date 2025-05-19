SELECT
    s.plan_id,
    s.owner_id,
    
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    
    -- To get the last date a confirmed inflow transaction occurred
    MAX(s.transaction_date) AS last_transaction_date,
    
    -- Calculating the number of days since the last inflow
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days

FROM
    savings_savingsaccount s

-- Joining to the plans_plan table to get plan type details
JOIN
    plans_plan p ON s.plan_id = p.id

-- Only considering actual inflows and relevant plan types (savings or investment)
WHERE
    s.confirmed_amount > 0
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)

-- Grouping by plan and owner to get the latest transaction per account
GROUP BY
    s.plan_id, s.owner_id, p.is_regular_savings, p.is_a_fund

-- Only including accounts with no inflow for more than 365 days
HAVING
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365;
