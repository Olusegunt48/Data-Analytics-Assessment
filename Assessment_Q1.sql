-- This query retrieves information about users' savings and investment accounts,
-- including the types of financial products they’re linked to and the total deposits involved.

SELECT 
  sa.owner_id,                     -- The user ID associated with the savings account
  
  pp.name,                         -- The name of the financial product or plan
  
  SUM(pp.is_regular_savings = TRUE) AS savings_account,     -- Counts how many times this product is marked as a regular savings account (binary sum)
  
  SUM(pp.is_a_fund = TRUE) AS investment_account,           -- Counts how many times this product is marked as an investment/fund (binary sum)
  
  SUM(sa.confirmed_amount) AS total_deposit                 -- Total confirmed deposits made under this user and product combination

FROM users_customuser AS uc
-- Join the savings accounts table to get account-level details linked to each user
JOIN savings_savingsaccount AS sa 
  ON uc.id = sa.owner_id

-- Join the plans table to get product details associated with each savings account
JOIN plans_plan AS pp 
  ON sa.plan_id = pp.id

-- Filter to include only records where the product is either a regular savings or an investment product
WHERE pp.is_regular_savings = TRUE OR pp.is_a_fund = TRUE

-- Group the results by user, product name, and product type flags to ensure distinct counts
GROUP BY 
  sa.owner_id, 
  pp.name;
  
  
# This below query is to check if the 2 conditions are met. (if it is a savings account and at the same time an investment account)

-- This query returns a list of users and the total deposits they've made 
-- into financial products that are classified as both a regular savings account and an investment fund.

SELECT 
  sa.owner_id,                        -- The unique identifier for the user who owns the savings account

  pp.name,                            -- The name of the financial plan or product the user is enrolled in

  pp.is_regular_savings AS savings_account,   -- A flag indicating whether the product is a regular savings account (will always be TRUE due to WHERE clause)

  pp.is_a_fund AS investment_account,         -- A flag indicating whether the product is classified as an investment fund (also always TRUE in this context)

  SUM(sa.confirmed_amount) AS total_deposit   -- The total amount of confirmed deposits made into this plan by this user

FROM users_customuser AS uc
-- Join to the savings accounts table to associate each user with their savings account(s)
JOIN savings_savingsaccount AS sa 
  ON uc.id = sa.owner_id

-- Join to the plans table to get the name and type of each financial product
JOIN plans_plan AS pp 
  ON sa.plan_id = pp.id

-- Filter to include only those plans that are BOTH a regular savings account AND an investment fund
WHERE pp.is_regular_savings = TRUE 
  AND pp.is_a_fund = TRUE

-- Group the results by user, product name, and the two boolean flags
-- Even though the boolean fields are filtered to TRUE, they are still included in the GROUP BY to satisfy SQL rules
GROUP BY 
  sa.owner_id, 
  pp.name;


