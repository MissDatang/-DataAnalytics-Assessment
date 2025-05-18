### Q1: High-Value Customers with Multiple Products

**Objective:**  
Identify customers who have both at least one funded savings plan and one funded investment plan, and rank them by total deposits.

**Approach:**  
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` tables.
- Used `is_regular_savings = 1` to identify savings plans and `is_a_fund = 1` for investment plans.
- Used `CASE WHEN` inside `COUNT(DISTINCT ...)` to count each type per customer.
- Summed `confirmed_amount` (converted from kobo to naira).
- Applied a `HAVING` filter to return only customers with at least one of each plan type.

## Challenges and How I Resolved Them
**Challenge** 
The `name` field in `users_customuser` was `NULL` for all rows.  

**Solution** 
Used `CONCAT(first_name, ' ', last_name)` to create full names.

---

### Q2: Transaction Frequency Analysis

**Objective:**  
Classify customers based on their average monthly transaction frequency into High, Medium, or Low frequency.

**Approach:**  
1. Grouped deposit transactions per customer by month using `DATE_FORMAT(transaction_date, '%Y-%m')`.
2. Calculated the average number of monthly transactions per user.
3. Categorized users using `CASE WHEN`:
  - High (≥ 10/month)
  - Medium (3–9/month)
  - Low (≤ 2/month)
  4. Aggregated customers into these categories and calculated average frequency per group.

## Challenges and How I Resolved Them

**Challenge**
The `name` field in `users_customuser` was `NULL` for all rows.  

**Solution** 
Used `CONCAT(first_name, ' ', last_name)` to create full names.

---

### Q3: Account Inactivity Alert

**Objective:**  
Identify savings or investment plans with no inflow transactions in the last 365 days.

**Approach:**  
1. Joined `plans_plan` with the most recent `transaction_date` per `plan_id` from `savings_savingsaccount`.
2. Used `IFNULL` to fallback to `created_on` for plans with no transactions.
3. Calculated `inactivity_days` using `DATEDIFF(CURDATE(), last_transaction_date)`.
4. Filtered results for plans inactive for more than 365 days.

## Challenges and How I Resolved Them

**Challenge** 
Some plans had no transactions, which returned `NULL` for `last_transaction_date`.  

**Solution** 
Used `IFNULL(last_transaction_date, created_on)` to handle fallback logic.

---

### Q4: Customer Lifetime Value (CLV)

**Objective:**  
Estimate CLV using tenure and transaction volume, assuming 0.1% profit per transaction.

**Approach:**  
1. Calculated customer tenure using `TIMESTAMPDIFF(MONTH, date_joined, CURDATE())`.
2. Counted total transactions and summed `confirmed_amount` (still in kobo).
3. Used the simplified formula:  
  `CLV = (total_transaction_value * 0.001) * (12 / tenure_months)`
4. Rounded and ordered results by CLV descending.

## Challenges and How I Resolved Them

**Challenge** 
Division by zero error when tenure in months was 0.  

**Solution** 
Added a `HAVING` clause to exclude customers with zero-month tenure.

---

## Notes

- All transaction amounts are stored in **kobo** and converted to **naira** using `/100`.
- Only deposit transactions (`confirmed_amount > 0`) were considered for inflow-based questions.

---

## Author

**Sola Longe**  

