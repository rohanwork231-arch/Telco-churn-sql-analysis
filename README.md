# 📊 Telecommunications Customer Churn Analysis | SQL

## 📌 Project Overview
SQL-based analysis of **7,000+ telecommunications customer records** to identify churn patterns, quantify revenue risk, and provide data-driven recommendations for customer retention strategies.

---

## 🎯 Business Problem
A telecommunications provider was experiencing a **26.5% customer churn rate**, resulting in significant monthly recurring revenue loss. The company needed to:
- Identify which customer segments were at highest risk of churning
- Quantify the revenue impact of customer churn
- Understand key drivers influencing customer retention
- Prioritize retention efforts on the most vulnerable customers

---

## 🛠️ Tools & Technologies
- **Database:** PostgreSQL
- **SQL Techniques:** 
  - Data type casting and cleaning
  - Window functions (RANK OVER)
  - Multi-level GROUP BY aggregations
  - CASE statements for categorical encoding
  - Subqueries and CTEs
  - HAVING clause for filtered aggregations

---

## 📂 Dataset
**33 attributes** including:
- Customer demographics (gender, senior citizen status, partner, dependents)
- Account information (tenure, contract type, payment method)
- Services (phone, internet, streaming, security, backup)
- Billing (monthly charges, total charges)
- Churn indicators (churn label, churn value, churn score, churn reason)

---

## 🔍 Analysis Performed

### 1. **Data Preparation**
- Created clean table with proper data types (TEXT → INT/DECIMAL conversions)
- Handled missing values using NULLIF
- Encoded categorical variables (senior_citizen: Yes/No → 1/0)

### 2. **Overall Churn Metrics**
- Calculated total customers, churned customers, and churn rate percentage
- Analyzed total monthly revenue and revenue lost from churn

### 3. **Segmentation Analysis**
- **By Contract Type:** Identified churn rates for Month-to-month, One year, Two year contracts
- **By Payment Method:** Analyzed churn across Electronic check, Mailed check, Bank transfer, Credit card
- **By Internet Service:** Compared churn for Fiber optic, DSL, No internet service
- **Multi-dimensional:** Combined contract + payment + internet service for granular insights

### 4. **Tenure Analysis**
- Segmented customers into tenure buckets (0-1 Year, 1-2 Years, 2-4 Years, 4+ Years)
- Identified churn patterns based on customer lifetime

### 5. **Revenue Impact Analysis**
- Quantified revenue at risk from high-churn segments
- Calculated revenue lost by segment combination
- Analyzed average monthly charges by contract type

### 6. **Risk Prioritization**
- Used RANK() window function to identify **top 10 highest-risk customers** by churn score
- Enabled targeted retention interventions

---

## 📈 Key Findings

| Finding | Impact |
|---------|--------|
| **Overall Churn Rate** | 26.5% of customer base |
| **Highest-Risk Segment** | Month-to-month + Electronic check + Fiber optic = **60.37% churn rate** |
| **Annual Revenue at Risk** | **$1.67M** from churned customers |
| **Tenure Insight** | Customers in first year show significantly higher churn |
| **Contract Impact** | Month-to-month contracts have 3x higher churn than long-term contracts |
| **Top 10 At-Risk Customers** | Identified for immediate retention action |

---

## 💡 Business Recommendations

1. **Targeted Retention Campaigns**
   - Focus on month-to-month customers with electronic check payments
   - Prioritize fiber optic service customers showing early churn signals

2. **Contract Incentives**
   - Offer promotional pricing to convert month-to-month to annual contracts
   - Reduce churn risk by locking in customers with longer commitments

3. **Payment Method Optimization**
   - Encourage migration from electronic check to auto-pay methods
   - Offer incentives for switching to credit card or bank transfer

4. **Early Engagement**
   - Implement onboarding programs for customers in first 12 months
   - Proactive outreach to high churn-score customers identified in analysis

5. **Resource Prioritization**
   - Focus retention budget on highest churn-score customers identified in analysis
   - Use churn score rankings to prioritize intervention efforts

---

## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `telco_churn_analysis.sql` | Complete SQL analysis code with all queries |
| `README.md` | Project documentation |

---

## 🚀 How to Run

Import the dataset into a PostgreSQL database.

Execute telco_churn_analysis.sql.

Review query outputs for churn metrics and segmentation insights.

---

## 🎓 Skills Demonstrated

✅ Advanced SQL querying (window functions, aggregations, subqueries)  
✅ Data cleaning and type conversion  
✅ Multi-dimensional segmentation analysis  
✅ Business metrics calculation (churn rate, revenue impact)  
✅ Risk prioritization and scoring   
✅ Translating data insights into actionable business recommendations

---

## 🙋 About Me
**Rohan Singh** – Aspiring Data Analyst skilled in SQL, Python, Power BI, and Excel.

📧 rohan.work231@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/rohan-singh-b88286340)  
💻 [GitHub](https://github.com/rohanwork231-arch)
