-- ============================================
-- TELECOMMUNICATIONS CUSTOMER CHURN ANALYSIS
-- PostgreSQL SQL Project
-- ============================================

-- ============================================
-- 1. DROP TABLES (FOR SAFE RE-RUN)
-- ============================================

DROP TABLE IF EXISTS telco_raw;
DROP TABLE IF EXISTS telco_customers;

-- ============================================
-- 2. CREATE RAW TABLE
-- ============================================

CREATE TABLE telco_raw (
    customer_id TEXT,
    count TEXT,
    country TEXT,
    state TEXT,
    city TEXT,
    zip_code TEXT,
    lat_long TEXT,
    latitude TEXT,
    longitude TEXT,
    gender TEXT,
    senior_citizen TEXT,
    partner TEXT,
    dependents TEXT,
    tenure_months TEXT,
    phone_service TEXT,
    multiple_lines TEXT,
    internet_service TEXT,
    online_security TEXT,
    online_backup TEXT,
    device_protection TEXT,
    tech_support TEXT,
    streaming_tv TEXT,
    streaming_movies TEXT,
    contract TEXT,
    paperless_billing TEXT,
    payment_method TEXT,
    monthly_charges TEXT,
    total_charges TEXT,
    churn_label TEXT,
    churn_value TEXT,
    churn_score TEXT,
    cltv TEXT,
    churn_reason TEXT
);

-- ============================================
-- 3. CREATE CLEANED TABLE WITH TYPE CASTING
-- ============================================

CREATE TABLE telco_customers AS
SELECT
    customer_id,
    count::INT AS count,
    country,
    state,
    city,
    zip_code::INT AS zip_code,
    lat_long,
    latitude::DECIMAL(10,6) AS latitude,
    longitude::DECIMAL(10,6) AS longitude,
    gender,

    CASE 
        WHEN senior_citizen = 'Yes' THEN 1
        ELSE 0
    END AS senior_citizen,

    partner,
    dependents,
    tenure_months::INT AS tenure_months,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges::DECIMAL(10,2) AS monthly_charges,

    NULLIF(TRIM(total_charges),'')::DECIMAL(10,2) AS total_charges,

    churn_label,
    churn_value::INT AS churn_value,
    churn_score::INT AS churn_score,
    cltv::INT AS cltv,
    churn_reason
FROM telco_raw;

-- ============================================
-- 4. BASIC CHURN METRICS
-- ============================================

-- Total number of customers

SELECT COUNT(*) FROM telco_customers;

-- Overall churn rate

SELECT 
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100.0 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_percent
FROM telco_customers;

-- Total monthly revenue

SELECT 
    ROUND(SUM(monthly_charges),2) AS total_monthly_revenue
FROM telco_customers;

-- Monthly revenue lost due to churn

SELECT 
    ROUND(SUM(monthly_charges),2) AS revenue_lost
FROM telco_customers
WHERE churn_value = 1;

-- Average tenure: churned vs retained customers

SELECT 
    churn_label,
    ROUND(AVG(tenure_months),2) AS avg_tenure
FROM telco_customers
GROUP BY churn_label;

-- ============================================
-- 5. SEGMENTATION ANALYSIS
-- ============================================

-- Churn by contract type

SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY contract
ORDER BY churn_rate DESC;

-- Churn by payment method

SELECT
    payment_method,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY payment_method
ORDER BY churn_rate DESC;

-- Churn by internet service type

SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY internet_service
ORDER BY churn_rate DESC;

-- Multi-dimensional churn segmentation
-- Contract + Payment Method + Internet Service

SELECT
    contract,
    payment_method,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY contract, payment_method, internet_service
HAVING COUNT(*) > 50
ORDER BY churn_rate DESC;

-- =============================================
-- 6. REVENUE IMPACT ANALYSIS
-- =============================================

-- Monthly revenue at risk (high churn segment example)

SELECT
    SUM(monthly_charges) AS monthly_revenue_at_risk
FROM telco_customers
WHERE contract = 'Month-to-month'
  AND payment_method = 'Electronic check'
  AND internet_service = 'Fiber optic'
  AND churn_value = 1;

-- Revenue lost by segment combination (customers > 50)

SELECT
    contract,
    payment_method,
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END),2) AS revenue_lost
FROM telco_customers
GROUP BY contract, payment_method, internet_service
HAVING COUNT(*) > 50
ORDER BY revenue_lost DESC;

-- Average charges comparison by contract type
-- Comparing overall avg vs churned-customer avg

SELECT
    contract,
    ROUND(AVG(monthly_charges),2) AS avg_monthly_charge,
    ROUND(AVG(CASE WHEN churn_value = 1 THEN monthly_charges END),2) AS avg_charge_churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY contract
ORDER BY churn_rate DESC;

-- =============================================
-- 7. TENURE ANALYSIS
-- =============================================

-- Customer churn by tenure bucket
-- Identifies lifecycle-based churn patterns

SELECT
    CASE
        WHEN tenure_months <= 12 THEN '0-1 Year'
        WHEN tenure_months <= 24 THEN '1-2 Years'
        WHEN tenure_months <= 48 THEN '2-4 Years'
        ELSE '4+ Years'
    END AS tenure_bucket,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned,
    ROUND(100.0 * SUM(churn_value) / COUNT(*),2) AS churn_rate
FROM telco_customers
GROUP BY tenure_bucket
ORDER BY churn_rate DESC;

-- =============================================
-- 8. REVENUE DISTRIBUTION
-- =============================================

-- Revenue contribution by contract type
-- Shows which contract types generate largest revenue share

SELECT
    contract,
    ROUND(SUM(monthly_charges),2) AS total_revenue,
    ROUND(100.0 * SUM(monthly_charges) /
          (SELECT SUM(monthly_charges) FROM telco_customers),2)
          AS revenue_percentage
FROM telco_customers
GROUP BY contract
ORDER BY revenue_percentage DESC;

-- =============================================
-- 9. RISK PRIORITIZATION
-- =============================================

-- Top 10 highest churn-score customers
-- Uses window function RANK() to prioritize intervention

SELECT *
FROM (
    SELECT
        customer_id,
        contract,
        payment_method,
        internet_service,
        monthly_charges,
        churn_score,
        RANK() OVER (ORDER BY churn_score DESC) AS risk_rank
    FROM telco_customers
) t
WHERE risk_rank <= 10;
