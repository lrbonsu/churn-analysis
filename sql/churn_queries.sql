
-- ============================================================
-- TELCO CHURN ANALYSIS — SQL Queries
-- Database: data/churn.db | Table: customers
-- ============================================================

-- 1. OVERALL CHURN RATE
SELECT
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS total_churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers;

-- 2. CHURN BY CONTRACT TYPE
SELECT
    contract,
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- 3. CHURN BY TENURE BUCKET
SELECT
    CASE
        WHEN tenure BETWEEN 0  AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
    END                                             AS tenure_bucket,
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers
GROUP BY tenure_bucket
ORDER BY churn_rate_pct DESC;

-- 4. CHURN BY PAYMENT METHOD
SELECT
    paymentmethod,
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers
GROUP BY paymentmethod
ORDER BY churn_rate_pct DESC;

-- 5. REVENUE AT RISK
SELECT
    ROUND(SUM(monthlycharges), 2)                   AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN churn = 1
              THEN monthlycharges ELSE 0 END), 2)   AS revenue_lost_to_churn,
    ROUND(SUM(CASE WHEN churn = 1
              THEN monthlycharges ELSE 0 END)
          * 100.0 / SUM(monthlycharges), 1)         AS pct_revenue_at_risk
FROM customers;

-- 6. CHURN BY INTERNET SERVICE
SELECT
    internetservice,
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS churned,
    ROUND(AVG(monthlycharges), 2)                   AS avg_monthly_charges,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers
GROUP BY internetservice
ORDER BY churn_rate_pct DESC;

-- 7. WINDOW FUNCTION — CHURN RANK BY MONTHLY SPEND
SELECT
    customerid,
    monthlycharges,
    tenure,
    contract,
    RANK() OVER (ORDER BY monthlycharges DESC)      AS spend_rank,
    NTILE(4) OVER (ORDER BY monthlycharges)         AS spend_quartile
FROM customers
WHERE churn = 1
ORDER BY monthlycharges DESC
LIMIT 20;

-- 8. HIGH-VALUE CHURNED CUSTOMERS (CTE)
WITH high_value AS (
    SELECT
        customerid,
        monthlycharges,
        totalcharges,
        tenure,
        contract,
        paymentmethod
    FROM customers
    WHERE churn = 1
      AND monthlycharges > (SELECT AVG(monthlycharges) FROM customers)
)
SELECT
    COUNT(*)                                        AS high_value_churned,
    ROUND(AVG(monthlycharges), 2)                   AS avg_monthly_charges,
    ROUND(AVG(tenure), 1)                           AS avg_tenure_months,
    ROUND(SUM(monthlycharges), 2)                   AS total_monthly_revenue_lost
FROM high_value;

-- 9. CHURN RISK MATRIX — TENURE x CONTRACT
SELECT
    CASE
        WHEN tenure BETWEEN 0  AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
    END                                             AS tenure_bucket,
    contract,
    COUNT(*)                                        AS total_customers,
    SUM(churn)                                      AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 1)        AS churn_rate_pct
FROM customers
GROUP BY tenure_bucket, contract
ORDER BY churn_rate_pct DESC;
