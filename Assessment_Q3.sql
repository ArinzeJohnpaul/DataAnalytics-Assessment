SELECT  
  ss.`plan_id`,  -- Selecting the plan ID from the savings account table
  ss.`owner_id`, -- Selecting the owner ID from the savings account table
  CASE  
    WHEN pp.is_a_fund = 1 THEN 'Investments' -- Categorizing as 'Investments' if the plan is a fund
    WHEN pp.`is_regular_savings` = 1 THEN 'Savings' -- Categorizing as 'Savings' if the plan is a regular savings plan
  END AS `type`,  
  MAX(DATE(transaction_date)) AS last_transaction_date, -- Fetching the most recent transaction date
  DATEDIFF(CURDATE(), MAX(DATE(transaction_date))) AS inactive_days -- Calculating the number of days since the last transaction
FROM  
  `savings_savingsaccount` ss  
JOIN plans_plan pp ON ss.`plan_id` = pp.`id` -- Joining the savings account table with the plans table based on plan ID
WHERE  
   pp.`is_regular_savings` = 1  
   OR pp.`is_a_fund` -- Filtering records to include only regular savings plans or investment funds
GROUP BY  
  ss.`owner_id`,  
  ss.`plan_id`,  
  pp.`description`  
HAVING inactive_days <= 365; -- Filtering to include only plans with activity in the past year

