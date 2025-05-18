/*Transaction Frequency Analysis*/
-- Step 1: Calculate monthly transaction counts per customer

SELECT
    owner_id,
    DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
    COUNT(*) AS monthly_txn_count
FROM savings_savingsaccount
WHERE confirmed_amount > 0
GROUP BY owner_id, txn_month;

-- Step 2: Average transactions per month per customer
SELECT
    owner_id,
    ROUND(AVG(monthly_txn_count), 2) AS avg_txn_per_month
FROM (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id, txn_month
) AS monthly_txns
GROUP BY owner_id
LIMIT 10;

-- Step 3: Categorize frequency
SELECT
    owner_id,
    ROUND(avg_txn_per_month, 2) AS avg_txn_per_month,
    CASE
        WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
        WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM (
        SELECT
            owner_id,
            DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
            COUNT(*) AS monthly_txn_count
        FROM savings_savingsaccount
        WHERE confirmed_amount > 0
        GROUP BY owner_id, txn_month
    ) AS monthly_txns
    GROUP BY owner_id
) AS avg_txns;

-- Step 4: Final Result
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month,
        CASE
            WHEN AVG(monthly_txn_count) >= 10 THEN 'High Frequency'
            WHEN AVG(monthly_txn_count) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
        SELECT
            owner_id,
            DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
            COUNT(*) AS monthly_txn_count
        FROM savings_savingsaccount
        WHERE confirmed_amount > 0
        GROUP BY owner_id, txn_month
    ) AS monthly_txns
    GROUP BY owner_id
) AS categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');


