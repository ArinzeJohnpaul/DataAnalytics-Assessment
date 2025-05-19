# This project contains SQL queries designed to extract insights from a financial platform’s user activity. Key areas include identifying multi-product users, analyzing transaction frequency, calculating tenure and customer lifetime value (CLV), and converting currency data.

---
##  Per-Question Explanations

### 1. **User Engagement by Product Usage**
- **Query Goal**:  to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
- **Key Metrics**:
  - `savings_count`: Count of accounts linked to regular savings plans.
  - `investment_count`: Count of accounts linked to fund-based investment plans.
  - `total_deposit`: Total confirmed deposits, converted from kobo to naira using:

  
- **Purpose**: Spot high-engagement users and understand their deposit volume across product categories.
- **Logic**:
  - Joins `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
  - Filters to only include users with at least one savings and one investment plan.
  - Orders by total deposit (descending) to highlight highest contributors.
---

### 2. **Transaction Frequency Segmentation**
**Query Goal:** Segment users based on how frequently they transact monthly.

- **Logic**:

First CTE (users_by_month) calculates the number of transactions per user for each year-month combination.

Second CTE (avg_transactions_per_user) computes each user's average monthly transaction count.

The final query classifies users as:

- High Frequency: ≥ 10 transactions/month

- Medium Frequency: 3–9 transactions/month

- Low Frequency: < 3 transactions/month

Use Case: Helpful for identifying power users vs dormant accounts for targeted outreach or rewards programs.

---

### 3. **Recent Activity by Plan Type**


**Query Goal:** Identify users with Savings or Investment accounts who have had activity in the last 365 days.

**Key Logic:**

Uses a CASE statement to classify each plan as Savings or Investments.

- Finds each user’s most recent transaction date using MAX(DATE(transaction_date)).

- Computes days of inactivity using:

**Use Case:** Useful for identifying users still engaged on the platform and differentiating between types of financial behavior (savings vs investment).

---

### 4. **Customer Lifetime Value (CLV) Estimation**

* **Goal**: Estimate expected user value based on past behavior.
* **Logic**:

  * Count transactions per user.
  * Compute user tenure.
  * Project average monthly transactions over 12 months.
  * Multiply by assumed average profit (₦0.001 per transaction).
* **Key Expression**:

  ```sql
  (transaction_count / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction
  ```


---

##  Challenges & Solutions

| Challenge                                             | Solution                                                     |
| ----------------------------------------------------- | ------------------------------------------------------------ |
| Avoiding divide-by-zero in tenure-based calculations  | Used `NULLIF(tenure_months, 0)`                              |
| Formatting currency values                            | Applied `ROUND(..., 2)` for precision                        |
| Segmenting users by logic-heavy criteria              | Broke down steps using CTEs and `CASE` statements            |
| Ensuring data integrity when aggregating across joins | Used inner joins and grouped by user ID to avoid duplication |

---

## File Overview

| File                                     | Description                                                           |
| ---------------------------------------- | --------------------------------------------------------------------- |
| `Assessment_Q1.sql`                      | High-Value Customers with Multiple Products                           |
| `Assessment_Q2.sql`                      | Transaction Frequency Analysis                                        |
| `Assessment_Q3.sql`                      | Account Inactivity Alert                                              |
| `Assessment_Q4.sql`                      | Customer Lifetime Value (CLV) Estimation                                     |

---
