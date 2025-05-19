-- CTE to count transactions and compute average profit per transaction per user
WITH transactions_count AS (
    SELECT
      owner_id,
      COUNT(*) AS transaction_count,
      AVG(COUNT(*) * 0.001) OVER (PARTITION BY owner_id) AS avg_profit_per_transaction
    FROM `savings_savingsaccount`
    GROUP BY owner_id
), 

-- CTE to calculate customer tenure in months and join with transaction data
tenure_months AS (
    SELECT 
      uc.id AS customer_id,
      CONCAT(uc.first_name, ' ', uc.last_name) AS NAME,
      TIMESTAMPDIFF(MONTH, DATE(uc.created_on), CURDATE()) AS tenure_months,
      tcc.transaction_count,
      tcc.avg_profit_per_transaction
    FROM `users_customuser` uc
    JOIN transactions_count tcc ON tcc.owner_id = uc.id
)

-- Final CLV estimation: annualized transactions * avg profit
SELECT 
  customer_id,
  NAME,
  tenure_months,
  transaction_count,
  (transaction_count / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction  AS estimated_clv
FROM tenure_months
ORDER BY estimated_clv DESC;
