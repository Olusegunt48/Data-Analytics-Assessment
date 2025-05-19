SELECT
  uc.id AS customer_id,  -- Customer/user ID

  CONCAT(uc.first_name, ' ', uc.last_name) AS name,  -- Full name of the user

  TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months,  -- Tenure in months

  COUNT(sa.id) AS total_transactions,  -- Total number of transactions by the user

  -- Simplified CLV formula using profit per transaction = 0.1% of average transaction value
  ROUND((COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()), 0)) * 12 * (AVG(sa.confirmed_amount) * 0.001), 2) AS estimated_clv

FROM users_customuser AS uc
JOIN savings_savingsaccount AS sa 
  ON uc.id = sa.owner_id

GROUP BY uc.id, uc.first_name, uc.last_name, uc.date_joined

ORDER BY estimated_clv DESC;
