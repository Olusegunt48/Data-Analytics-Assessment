# Data-Analytics-Assessment

📊 Customer Deposit & Transaction Analysis
SQL Reporting & Data Aggregation

🧾 Overview
This project focuses on analyzing user activity and engagement within a financial application, specifically examining how users interact with savings and investment products. Using SQL, I gather insights into deposit behavior, transaction frequency, product type usage, account activity recency, and customer lifetime value (CLV).

The analysis covers multiple dimensions:

Financial product classifications

Transaction frequency segmentation

Inactivity tracking

CLV estimation based on transactional behavior

📂 Data Sources
The queries utilize data from the following tables:

Table Name	Description
users_customuser	Stores user profile information such as ID, name, status, and registration date
savings_savingsaccount	Contains transactional records tied to users and financial plans
plans_plan	Holds metadata for financial products (e.g., is it a savings or investment product?)

1️⃣ Deposit Summary by Product Type
📌 Purpose
This query summarizes each user's total deposits across financial products, categorized as either savings, investment, or both. It calculates how many of each product type the user holds and the sum of their confirmed deposits.

📈 Output Fields
User ID and Full Name

Plan Name: Name of the financial product

Savings Account Count

Investment Account Count

Total Deposited Amount

🎯 Use Case
This helps identify user behavior and preferences in terms of financial product selection and overall contribution.

2️⃣ Dual-Type Product Deposits
📌 Purpose
Focuses on a narrow subset of financial plans that are both a regular savings account and an investment fund. It reports deposit data specifically for these hybrid plans.

📈 Output Fields
User ID and Full Name

Plan Name

Boolean flags: is_regular_savings, is_a_fund (both TRUE)

Total Deposited Amount

🎯 Use Case
Useful for identifying users interacting with advanced or multi-purpose financial products.

3️⃣ Transaction Frequency Segmentation
📌 Purpose
Categorizes users based on how frequently they transact per month on average. Each user is grouped into High, Medium, or Low Frequency based on their activity levels.

📊 Frequency Tiers
High Frequency: ≥ 10 transactions/month

Medium Frequency: 3–9 transactions/month

Low Frequency: < 3 transactions/month

📈 Output Fields
Frequency Category

Customer Count in each category

Average Monthly Transactions

🎯 Use Case
Supports user segmentation for targeted marketing or customer service based on engagement levels.

4️⃣ Active Customers with Successful Transactions
📌 Purpose
Refines the frequency segmentation by filtering only active users who have had successful transactions, giving a more accurate view of reliable, revenue-generating customers.

📈 Output Fields
Frequency Category

Active Customer Count

Average Monthly Transactions

🧪 Filtering Criteria
users_customuser.is_active = TRUE

savings_savingsaccount.transaction_status = 'success'

🎯 Use Case
Helps teams focus retention and growth efforts on actively engaged users who complete transactions successfully.

5️⃣ Account Type & Recent Activity Analysis
📌 Purpose
Tracks account activity across all users with either savings or investment products, identifying the most recent transaction date and calculating days of inactivity (up to 365 days).

🧮 Account Type Classification
Savings & Investment

Savings Only

Investment Only

Other

📈 Output Fields
Plan ID

User ID

Account Type

Last Transaction Date

Days Since Last Transaction

🎯 Use Case
Enables churn analysis and helps detect dormant accounts that may need re-engagement strategies.

6️⃣ Customer Lifetime Value (CLV) Estimation
📌 Purpose
Estimates a simplified CLV per customer using a custom formula based on:

Tenure (in months)

Average transaction value

Assumed profit margin (0.1%)

📐 CLV Formula:
sql
Copy
Edit
Estimated CLV = 
(Transactions per Month) × 12 × (Average Transaction Amount × 0.001)
📈 Output Fields
User ID and Full Name

Tenure in Months

Total Transactions

Estimated CLV (rounded)

🎯 Use Case
Useful for prioritizing high-value users and forecasting revenue potential at an individual user level.

🛠️ Future Enhancements
Introduce time-based trend comparisons (e.g., MoM or YoY growth in deposits or transactions)

Normalize CLV with more realistic cost and profit margin assumptions

Add data visualizations or integrate with BI tools like Tableau or Power BI

Support multi-currency transactions and region-based segmentation

🧑‍💻 Author
Data Analyst: Oluwasegun Oladipupo
SQL Project | 2025

