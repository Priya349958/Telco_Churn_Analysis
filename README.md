# 📊 Telco Customer Churn Analysis

**End-to-end business analytics project analyzing 7,043 telecom customers to identify churn drivers and develop retention strategies with projected $250K annual savings.**

## 🎯 Project Overview

**Business Problem:** TelCo Company experiences 26.54% customer churn rate, resulting in ₹1.67M annual revenue at risk. Leadership requires actionable insights to reduce churn by 15% within 12 months.

**Key Findings:**
- Month-to-month contracts churn at **42.7%** vs **2.8%** for 2-year contracts (15x difference)
- **47.4%** of customers churn within first year (55% of total churn)
- Churned customers paid **21% more** than retained customers (₹74.44 vs ₹61.27)
- Customers without tech support churn at **2.7x** the rate

**Business Impact:**
- 3 targeted recommendations with **₹8.8 lakh** combined savings potential
- Projected **15% churn reduction** (280 customers saved annually)
- **ROI: 2.5x** in Year 1, payback period: 5 months

---

## 🛠️ Tools & Technologies

**Analysis Stack:**
- **Microsoft Excel** - Data cleaning, pivot analysis, interactive dashboards
- **PostgreSQL** - Database management, advanced queries
- **Power BI** - Interactive visualization, DAX measures
- **DBeaver** - SQL client and query execution

**Skills Demonstrated:**
- Advanced Excel (Pivot Tables, VLOOKUP, SUMIFS, Complex Formulas, Dashboards)
- SQL (CTEs, Window Functions, Subqueries, Complex JOINs, 8 production-ready queries)
- Power BI (DAX, Data Modeling, Interactive Dashboards, Conditional Formatting)
- Data Cleaning & Validation (handled missing values, created calculated fields)
- Business Analysis (ROI calculations, segmentation, predictive risk scoring)

---

## 📂 Repository Structure
```
telco-churn-analysis/
├── README.md                      # Project overview (you're here!)
├── 01_Data/                       # Raw dataset and documentation
├── 02_Excel/                      # Excel analysis and dashboards
├── 03_SQL/                        # PostgreSQL queries and results
├── 04_PowerBI/                    # Power BI dashboards and exports
└── 05_Documentation/              # Executive summaries and reports
```

---

## 📊 Key Analyses

### **1. Excel Analysis**

**Exploratory Data Analysis:**
- Cleaned 7,043 customer records (handled 11 missing TotalCharges values)
- Created 4 calculated fields: Churn_Binary, Tenure_Group, MonthlyCharges_Group, Revenue_Lost
- Built 5+ pivot tables analyzing churn across 8 dimensions
- Developed interactive dashboard with slicers for dynamic filtering

**Key Features:**
- 6 KPI cards (Total Customers, Churn Rate, Revenue at Risk, etc.)
- 4 pivot-based visualizations (Contract, Tenure, Service Type, Distribution)
- Risk scoring algorithm identifying high-risk customers
- Cross-validated all metrics with SQL and Power BI

---

### **2. SQL Analysis (PostgreSQL)**

**8 Production-Ready Queries:**

| Query | Purpose | SQL Concepts |
|-------|---------|--------------|
| **1. Comprehensive Overview** | Validate all KPIs and metrics | Aggregation, CASE, ROUND, Subqueries |
| **2. Churn by Contract** | Primary churn driver analysis | GROUP BY, Multiple aggregations |
| **3. Churn by Tenure** | Customer lifecycle analysis | GROUP BY, Custom ordering |
| **4. High-Risk Profiles** | Multi-factor risk segmentation | Multi-column GROUP BY, HAVING, CASE |
| **5. Internet Service** | Service quality deep dive | WHERE filtering, Multi-metric analysis |
| **6. Payment Method** | Payment convenience impact | GROUP BY, Business logic |
| **7. Customer LTV (CTE)** | Forward-looking value analysis | **WITH clause, CTEs, Complex CASE** |
| **8. Retention Curve** | Lifecycle churn patterns | **Window Functions (SUM OVER)** |

**Advanced SQL Features:**
- ✅ Common Table Expressions (CTEs)
- ✅ Window Functions (SUM OVER, AVG OVER, ORDER BY)
- ✅ Complex CASE statements with nested logic
- ✅ Subqueries and derived tables
- ✅ Conditional aggregation (CASE WHEN inside aggregate functions)

**Validation:** All SQL results matched Excel and Power BI within 0.01% tolerance.

---

### **3. Power BI Dashboard**

**Interactive Executive Dashboard (2 pages):**

**Page 1: Executive Overview**
- 6 KPI cards with key performance indicators
- 4 visualizations: Churn by Contract, Churn by Tenure, Tech Support Impact, Customer Distribution
- 4 interactive slicers (Contract, Internet Service, Tenure, Tech Support)
- Cross-filtering enabled across all visuals

**Page 2: Business Recommendations**
- Detailed findings with financial impact
- 3 specific recommendations with ROI projections
- Implementation timeline and success metrics
- Total projected savings: $8.8 lakh annually

---

## 🔍 Key Findings

### **Finding #1: Contract Type Drives Churn**

**Data:**
- Month-to-month: 42.7% churn (3,875 customers)
- One-year: 11.3% churn (1,473 customers)
- Two-year: 2.8% churn (1,695 customers)
- **15x difference** between MTM and 2-year contracts

**Insight:** Month-to-month contracts account for 88.5% of total churn despite being only 55% of customer base.

**Recommendation:** Incentivize long-term contracts with 20-30% discounts
- Expected Impact: Convert 30% of MTM to annual contracts

---

### **Finding #2: First-Year Retention Crisis**

**Data:**
- 0-1 Year tenure: 47.4% churn rate (2,175 customers)
- 4+ Years tenure: 9.5% churn rate (1,683 customers)
- First-year customers account for 55% of total churn

**Insight:** We're losing customers before they become loyal. Critical intervention window is months 1-12.

**Recommendation:** Implement structured onboarding program
- Month 1: Welcome call + setup assistance
- Month 3: Service optimization check-in
- Month 6: Loyalty reward + contract upgrade offer

---

### **Finding #3: Tech Support Impact**

**Data:**
- Without tech support: 41.7% churn
- With tech support: 15.2% churn
- **2.7x difference**

**Insight:** Fiber optic customers particularly vulnerable (41.9% churn) with low tech support adoption (28%).

**Recommendation:** Bundle complimentary tech support with Fiber packages
- 6 months free tech support for all Fiber customers

---

### **Finding #4: Price Sensitivity**

**Data:**
- Churned customers: $74.44/month average
- Retained customers: $61.27/month average
- **$13.17 gap (21% premium)**

**Insight:** Higher-paying customers showing elevated churn risk, indicating price/value perception issue.

**Recommendation:** Value enhancement strategy (bundle additional services rather than reduce prices)

---

## 🎯 Methodology

### **1. Data Preparation**
- **Source:** Kaggle Telco Customer Churn Dataset
- **Records:** 7,043 customers, 21 variables
- **Cleaning:** Handled 11 missing TotalCharges values (tenure = 0 customers)
- **Feature Engineering:** Created 4 calculated fields for segmentation

### **2. Exploratory Analysis (Excel)**
- Built pivot tables across 8 dimensions
- Identified key churn patterns
- Created interactive dashboard with slicers
- Calculated risk scores and revenue impact

### **3. Deep-Dive Analysis (SQL)**
- Loaded data into PostgreSQL database
- Wrote 8 queries from basic to advanced
- Used CTEs for customer lifetime value analysis
- Applied window functions for retention curves
- Validated all calculations against Excel

### **4. Visualization (Power BI)**
- Direct connection to PostgreSQL
- Built 2-page interactive dashboard
- Enabled cross-filtering and drill-down
- Exported for stakeholder access

### **5. Business Recommendations**
- Quantified ROI for each initiative
- Developed implementation timeline
- Defined success metrics and KPIs
- Created executive presentation

---

## 📈 Results & Validation

**Cross-Platform Validation:**

| Metric | Excel | SQL | Power BI | Status |
|--------|-------|-----|----------|--------|
| Total Customers | 7,043 | 7,043 | 7,043 | ✅ Match |
| Churned Customers | 1,869 | 1,869 | 1,869 | ✅ Match |
| Churn Rate | 26.54% | 26.54% | 26.54% | ✅ Match |
| Annual Revenue at Risk | ₹16,69,570 | ₹16,69,570 | ₹16,69,570 | ✅ Match |
| Avg Monthly Charge (Churned) | ₹74.44 | ₹74.44 | ₹74.44 | ✅ Match |

**All metrics validated within 0.01% tolerance across three platforms.**

---

## 💡 Key Learnings

**Technical Skills:**
- Mastered window functions for lifecycle analysis
- Learned to validate findings across multiple platforms
- Developed end-to-end analytics workflow from raw data to executive presentation

**Business Skills:**
- Translated technical findings into dollar-value recommendations
- Learned to identify actionable insights vs. descriptive statistics
- Practiced stakeholder communication (technical → executive level)

**Project Management:**
- Organized complex multi-tool project with clear structure
- Documented assumptions and methodology for reproducibility
- Version controlled all code and tracked data lineage

