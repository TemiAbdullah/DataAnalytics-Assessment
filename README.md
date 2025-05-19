# DataAnalytics-Assessment
This public repository contains my solutions to the CowryWise SQL assessment. In this readme file, I will attempt to explain my approach to solving each question as well as highlighting all issues or complications I faced on the way and how they were resolved. For the queries themselves, kindly find the sql files contained in this repository. Thank you very much!

## 1. High-Value Customers with Multiple Products: 
* Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits. Using the users_customuser, savings_savingsaccountand plans_plan tables.
* Approach: According to the provided hints, all inflows are recorded in the confirmed_amount column from the savings table. Therefore, actual inflows were recorded as those with confirmed_amount > 0. While the savings and investment accounts were identified with is_regular_savings = 1 and is_a_fund = 1 respectively. Finally, I divided total deposits by 100 to convert from kobo to naira. 
