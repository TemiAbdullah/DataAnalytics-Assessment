SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Count of funded savings accounts (is_regular_savings = 1 AND confirmed_amount > 0)
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN s.id 
        END) AS savings_count,

    -- Count of funded investment plans (is_a_fund = 1 AND confirmed_amount > 0)
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN s.id 
        END) AS investment_count,

    -- Total confirmed inflows from all funded savings and investment accounts
    ROUND(SUM(CASE 
        WHEN s.confirmed_amount > 0 THEN s.confirmed_amount 
        ELSE 0 
        END) / 100, 2) AS total_deposits

FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id
LEFT JOIN plans_plan p ON p.id = s.plan_id

GROUP BY u.id, u.first_name, u.last_name

HAVING savings_count > 0 AND investment_count > 0

ORDER BY total_deposits DESC;
