# DataAnalytics-Assessment
This public repository contains my solutions to the CowryWise SQL assessment. In this readme file, I will attempt to explain my approach to solving each question as well as highlighting all issues or complications I faced on the way and how they were resolved. For the queries themselves, kindly find the sql files contained in this repository. Thank you very much!

## 1. High-Value Customers with Multiple Products
* Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits. Using the users_customuser, savings_savingsaccount and plans_plan tables.
* Approach: According to the provided hints, all inflows are recorded in the confirmed_amount column from the savings table. Therefore, actual inflows were recorded as those with confirmed_amount > 0. While the savings and investment accounts were identified with is_regular_savings = 1 and is_a_fund = 1 respectively. Finally, I divided total deposits by 100 to convert from kobo to naira.

## 2. Transaction Frequency Analysis
* Task: Calculate the average number of transactions per customer per month and categorize them into high frequency, medium frequency and low frequency.
* Approach: First, I created a CTE to calculate the number of transactions each customer makes per month. This was done by grouping the savings_savingsaccount table by owner_id, YEAR(transaction_date), and MONTH(transaction_date), and then counting the number of transactions in each month. Next, I categorized the number of transactions into high frequency, medium frequency and low frequency based on the specifications given using a CASE statement. 
* Challenges: It was not explicitly stated what defines a "transaction". Whether it should include both deposits and withdrawals, or just confirmed inflows. I assumed each record in savings_savingsaccount represents a transaction, based on the table name and structure. To resolve this, I treated each row as a transaction for simplicity, pending more precise schema definitions.

## 3. Account Inactivity Alert
* Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) using the plans_plan and savings_savings_account tables. 
* Approach: The solution joins savings_savingsaccount with plans_plan to identify account types, filters for real inflows using confirmed_amount > 0, and groups by account to find the latest transaction date. I then calculated days since last inflow and returned only those with no activity for over 365 days, labeling them as Savings or Investment.
* Challenges: The key requirement was to flag accounts with no inflow transactions, not just any transaction. To resolve this, I filtered rows where confirmed_amount > 0, ensuring only inflow activity is considered.

## 4. Customer Lifetime Value (CLV) Estimation
* Task: Estimate the account tenure, total transactions and estimated CLV. 
* Approach: The query joins users with their savings transactions, filters for actual inflows, and calculates account tenure in months using the difference between the current date and signup date. It then counts total transactions and estimates CLV using the formula: (transactions per month) * 12 * average profit, where profit per transaction is 0.1% of the transaction value. Finally, it orders customers by estimated CLV in descending order.
* Challenges: Similarly to the frequency analysis, transactions had to be defined as only inflows because I was not asked to use the withdrawals_withdrawal table, this could have provided another dimension to the way transactions were calculated. Another challenge was handling customers whose tenure was less than one month. Dividing by zero would cause errors, so I used an IF statement to return 0 for estimated CLV if tenure is zero. Another challenge was converting transaction values from kobo to naira and applying the 0.1% profit correctly, which was resolved by dividing by 100 for naira and multiplying by 0.001.

## Conclusion
While I think I was able to answer all four questions as required based on specifications, data retrieval, aggregation, joins, subqueries, and data manipulation across multiple tables, I think it would have been helpful to get a detailed schema about the columns and how the data was defined. However, I'm aware that this assessment was intended to mimic real world scenarios where the data isn't alsways as clean or detailed as can be. Overall, this was really interesting and I look forward to hearing from you soon. Thank you!



