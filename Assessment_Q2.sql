-- Step 1: Calculate the transactions count per user per month
WITH users_by_month AS (
    SELECT 
        uc.id AS owner_id,  -- Get the user ID (owner of the savings account)
        DATE_FORMAT(ss.created_on, '%Y-%m') AS year_month,  -- Format the creation date to 'YYYY-MM' for monthly aggregation
        COUNT(ss.id) AS transactions_count  -- Count the number of transactions for each user per month
    FROM users_customuser uc
    JOIN savings_savingsaccount ss ON uc.id = ss.owner_id  -- Join to get the savings account for each user
    GROUP BY uc.id, year_month  -- Group by user and month to get monthly transaction count per user
),

-- Step 2: Calculate the average transactions per user across all months
avg_transactions_per_user AS (
    SELECT 
        owner_id,  -- User ID
        AVG(transactions_count) AS avg_transactions_per_month  -- Calculate the average number of transactions per month for each user
    FROM users_by_month  -- We use the result from Step 1 here
    GROUP BY owner_id  -- Group by user to get an average per user
)

-- Final Step: Categorize users based on their average transactions per month
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'  -- High frequency if avg is 10 or more
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- Medium frequency if avg is between 3 and 9
        ELSE 'Low Frequency'  -- Low frequency if avg is less than 3
    END AS frequency_category,  -- The frequency category for each user
    COUNT(owner_id) AS user_count,  -- Count the number of users in each frequency category
    AVG(avg_transactions_per_month) AS avg_transactions_per_month  -- Average of average transactions per user in each category
FROM avg_transactions_per_user  -- We use the result from Step 2 here
GROUP BY frequency_category;  -- Group by frequency category to get counts and averages per category
