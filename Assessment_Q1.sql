SELECT
  uc.id AS owner_id,
  CONCAT(uc.`first_name`, ' ', uc.`last_name`) AS NAME,-- Concatenate the user's first and last name as NAME
  COUNT(CASE WHEN pp.is_regular_savings = 1 THEN 1 END) AS savings_count, -- Count the number of savings accounts where is_regular_savings = 1
  COUNT(CASE WHEN pp.`is_a_fund`= 1 THEN 1 END) AS investment_count,-- Count the number of investments where is_fixed_investment = 1
  ROUND(SUM(ss.`confirmed_amount`)/100, 2) AS total_deposit -- Sum the total amount deposited by the user across transactions while converting it to naira
FROM
  `users_customuser` uc
  INNER JOIN `savings_savingsaccount` ss ON uc.id = ss.`owner_id` -- Join with the savings_savingsaccount table to get the user's savings information
  INNER JOIN `plans_plan` pp ON pp.id = ss.`plan_id` -- Join with the plans_plan table to get details about the type of plan (savings or investment)
GROUP BY
  uc.`id`  -- Group the results by user ID to aggregate data per user   
-- Filter to include only users who have at least one savings and one investment plan
HAVING
  savings_count >= 1 
  AND investment_count >= 1   
-- Sort the results in ascending order of total deposited amoun
ORDER BY
  total_deposit DESC;

