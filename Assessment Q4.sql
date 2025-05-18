/*Customer Lifetime Value (CLV) Estimation*/

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        ((SUM(s.confirmed_amount) * 0.001) * 12) / 
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()),
        2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, CONCAT(u.first_name, ' ', u.last_name), u.date_joined
HAVING tenure_months > 0
ORDER BY estimated_clv DESC;
