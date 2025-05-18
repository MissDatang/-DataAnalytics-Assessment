/*Account Inactivity Alert*/
/*last deposit date for each plan*/

SELECT
    plan_id,
    MAX(transaction_date) AS last_transaction_date
FROM savings_savingsaccount
WHERE confirmed_amount > 0
GROUP BY plan_id;

/*Inactivity Alert*/

SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    COALESCE(s.last_transaction_date, p.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), COALESCE(s.last_transaction_date, p.created_on)) AS inactivity_days
FROM plans_plan p
LEFT JOIN (
    SELECT
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
) s ON p.id = s.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND DATEDIFF(CURDATE(), COALESCE(s.last_transaction_date, p.created_on)) > 365;
