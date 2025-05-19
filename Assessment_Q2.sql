
-- Final aggregation: group users into frequency categories and calculate metrics
SELECT
  frequency_category,  -- Frequency segment: High, Medium, or Low
  COUNT(*) AS customer_count,  -- Number of users in each frequency segment
  ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month  -- Average monthly transactions within the segment

FROM (
  -- Subquery: for each user, calculate their average monthly transaction count and assign a frequency segment
  SELECT 
    user_id,  -- The unique identifier for each user
    AVG(monthly_tx_count) AS avg_tx_per_month,  -- Average transactions per month for this user

    -- Define frequency category based on average monthly transactions
    CASE
      WHEN AVG(monthly_tx_count) >= 10 THEN 'High Frequency'
      WHEN AVG(monthly_tx_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category

  FROM (
    -- Innermost subquery: calculate how many transactions each user made per month
    SELECT 
      sa.owner_id AS user_id,  -- User ID from the savings account table
      DATE_FORMAT(sa.transaction_date, '%Y-%m') AS month,  -- Format the transaction date to get the month (e.g. '2025-05')
      COUNT(*) AS monthly_tx_count  -- Total transactions for that user in that month
    FROM savings_savingsaccount AS sa
    GROUP BY sa.owner_id, month  -- Group by user and month to count transactions per user per month
  ) AS monthly_data

  GROUP BY user_id  -- Group by user to compute their average monthly transaction count
) AS user_segments

GROUP BY frequency_category;  -- Final grouping by frequency segment to get total users and average activity



-- Below query help to drill down to active customers with successful transactions

-- Final aggregation: summarize how many active users fall into each transaction frequency category,
-- and compute the average number of transactions per month within each category.
SELECT
  frequency_category,  -- This groups users as 'High', 'Medium', or 'Low' frequency based on their transaction activity

  COUNT(*) AS customer_count,  -- Total number of users in each frequency category (only includes active users)

  ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month  -- Average monthly transaction count across users in each category

FROM (
  -- Second-level subquery: calculates average monthly transaction count for each active user
  SELECT 
    user_id,  -- Unique user ID

    AVG(monthly_tx_count) AS avg_tx_per_month,  -- User's average number of successful transactions per month

    -- Categorize users based on their average monthly transaction count
    CASE
      WHEN AVG(monthly_tx_count) >= 10 THEN 'High Frequency'     -- 10 or more transactions per month
      WHEN AVG(monthly_tx_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- Between 3 and 9
      ELSE 'Low Frequency'                                       -- 2 or fewer
    END AS frequency_category

  FROM (
    -- Innermost subquery: counts how many successful transactions each user made per month
    SELECT 
      uc.id AS user_id,  -- Pulls the user ID from the users table

      DATE_FORMAT(sa.transaction_date, '%Y-%m') AS month,  -- Extracts year and month from transaction date for monthly grouping

      COUNT(*) AS monthly_tx_count  -- Total number of transactions that were successful, for that user in that month

    FROM users_customuser AS uc
    JOIN savings_savingsaccount AS sa ON uc.id = sa.owner_id  -- Join transactions to users

    -- Filters to include only active users and successful transactions
    WHERE uc.is_active = TRUE AND sa.transaction_status = 'success'

    GROUP BY uc.id, month  -- Group by user and month to calculate transaction counts per user per month
  ) AS monthly_data

  GROUP BY user_id  -- Aggregate monthly counts to calculate per-user averages
) AS user_segments

-- Final grouping: count users and average their activity within each frequency category
GROUP BY frequency_category

-- Optional sorting: show higher frequency categories first
ORDER BY avg_transactions_per_month DESC;





