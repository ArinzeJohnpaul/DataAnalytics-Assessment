# DataAnalytics-Assessment


### This project contains a series of SQL queries designed to extract insights from savings and user-related data, including transaction behavior, customer tenure, and estimated Customer Lifetime Value (CLV). The queries are written for a MySQL database and focus on business intelligence-style reporting.

---

### ✅ Per-Question Explanations

#### 1. **Day Difference Between Transaction Date and Today**

```sql
SELECT DATEDIFF(CURDATE(), transaction_date) AS day_difference ...
```

* **Approach**: Used MySQL’s `DATEDIFF()` function to compute the number of days between a transaction date and the current date.
* **Use Case**: Helps identify how long ago the last transaction occurred, useful for inactivity or churn analysis.

---

#### 2. **Day Difference per Plan and User**

```sql
SELECT 
  ss.plan_id, ss.owner_id, pp.description, MAX(DATE(transaction_date)), ...
```

* **Approach**: Used `MAX(transaction_date)` per user-plan group to identify the most recent transaction, then calculated the day difference from today.
* **Insight**: Highlights when a user last interacted with a particular plan.

---

#### 3. **Difference in Months Between Last Transaction and Today**

```sql
TIMESTAMPDIFF(MONTH, MAX(DATE(transaction_date)), CURDATE()) AS month_difference
```

* **Approach**: Switched from `DATEDIFF()` to `TIMESTAMPDIFF(MONTH, ...)` for results in full months.
* **Why**: Monthly intervals are more useful for long-term planning and metrics like retention or renewal cycles.

---

#### 4. **Tenure Calculation for Users**

```sql
TIMESTAMPDIFF(MONTH, DATE(created_on), CURDATE()) AS tenure
```

* **Approach**: Calculated customer tenure in full months since account creation.
* **Use Case**: Foundational for normalizing activity (e.g., transactions per month).

---

#### 5. **Currency Conversion from Kobo to Naira**

```sql
SELECT amount / 100 AS amount_in_naira ...
```

* **Approach**: Simple division to convert from kobo (₦1 = 100 kobo).
* **Use Case**: Standardizing amounts for financial reporting or display.

---

#### 6. **Customer Lifetime Value (CLV) Estimation**

```sql
(transaction_count / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction AS estimated_clv
```

* **Approach**:

  * Used two CTEs:

    * One for transaction count and average profit.
    * One for tenure calculation and joining with user data.
  * Estimated CLV by projecting average monthly transaction rate over 12 months and multiplying by average profit.
* **Assumption**: Profit is estimated as `0.001` per transaction; can be customized.

---

### ⚠️ Challenges & Solutions

| Challenge                                         | Solution                                                                                                      |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Calculating aggregated date differences per group | Used `MAX(transaction_date)` within `GROUP BY`, then applied `DATEDIFF()` or `TIMESTAMPDIFF()` on the result. |
| Avoiding division by zero in CLV calculation      | Used `NULLIF(tenure_months, 0)` to prevent division errors.                                                   |
| Converting monetary values from kobo to naira     | Used simple division (`amount / 100`) and optionally formatted to 2 decimal places using `ROUND()`.           |
| Estimating CLV without subqueries for each row    | Used CTEs and window functions to structure the logic cleanly and efficiently.                                |

---

### 📂 Files

* `clv_analysis.sql` – Contains the complete CLV and tenure calculation query
* `transaction_recency.sql` – Queries for recency analysis per user/plan
* `tenure_query.sql` – Query to calculate tenure in months
* `amount_conversion.sql` – Kobo-to-naira conversion logic

---

### 💡 Next Steps

* Add filtering for specific user segments (e.g., active vs. inactive users).
* Introduce profit margin adjustments based on plan type.
* Format currency outputs for display (e.g., ₦ with decimals).

---

Would you like me to format this into an actual `README.md` file you can commit to GitHub?
