
-- This query retrieves all active user accounts (based on recent transactions),
-- classifies the type of financial product they are linked to (Savings, Investment, or both),
-- and shows how recently each account had a transaction, capped at the past 365 days.

SELECT 
  sa.plan_id,                      -- The ID of the financial product or plan linked to the account
  sa.owner_id,                     -- The ID of the user who owns the savings account

  -- Determine the type of account based on plan flags
  CASE
    WHEN pp.is_regular_savings = TRUE AND pp.is_a_fund = TRUE THEN 'Savings & Investment' -- Both flags are true
    WHEN pp.is_regular_savings = TRUE THEN 'Savings'                                      -- Only savings flag is true
    WHEN pp.is_a_fund = TRUE THEN 'Investment'                                            -- Only investment flag is true
    ELSE 'Other'                                                                          -- Catch-all for plans without any flags
  END AS type,

  MAX(sa.transaction_date) AS last_transaction_date,              -- Most recent transaction date for this account
  DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days -- Number of days since that last transaction

FROM savings_savingsaccount AS sa
JOIN plans_plan AS pp 
  ON sa.plan_id = pp.id                     -- Link account to the product plan

-- Filter: only include plans that are flagged as either a savings product or an investment product
WHERE pp.is_regular_savings = TRUE OR pp.is_a_fund = TRUE

-- Group by account and user to prepare for aggregate calculations (like MAX())
GROUP BY sa.plan_id, sa.owner_id

-- Filter: include only accounts with activity in the last 365 days
HAVING DATEDIFF(CURDATE(), MAX(sa.transaction_date)) <= 365

-- Sort by inactivity (most inactive to least inactive, but all still within 1 year)
ORDER BY inactivity_days DESC;



