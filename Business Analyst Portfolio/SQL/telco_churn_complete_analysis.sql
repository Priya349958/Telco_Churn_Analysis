/*=====================================================
QUERY 1: Comprehensive Churn Metrics Dashboard
Purpose: Complete snapshot of churn situation
Business Question: What is our overall churn situation?
=====================================================*/

SELECT 
    -- Customer Counts
    COUNT(*) as total_customers, --Count of total customers
    SUM(churn_binary) as churned_customers, --Count of churned customers
    COUNT(*) - SUM(churn_binary) as retained_customers, --Count of current retained customers
    
    -- Churn Rate
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate_percent, --Churn Rate i.e; Churned customers/Total customers*100
    ROUND(100.0 * (COUNT(*) - SUM(churn_binary)) / COUNT(*), 2) as retention_rate_percent, --Retention Rate i.e; Retaained customers/Total customers*100
    
    -- Revenue Metrics
    ROUND(SUM(revenue_lost), 2) as annual_revenue_at_risk, --Revenue lost annually from churned customers
    ROUND(SUM(revenue_lost) / 12, 2) as monthly_recurring_revenue_lost, --Monthly revenue lost due to churned customers
    
    -- Average Charges (Churned vs Retained)
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN monthly_charges END), 2) as avg_monthly_charge_churned, --Average monthly revenue lost
    ROUND(AVG(CASE WHEN churn = 'No' THEN monthly_charges END), 2) as avg_monthly_charge_retained, --Average monthly revenue retained
    ROUND(
        AVG(CASE WHEN churn = 'Yes' THEN monthly_charges END) - 
        AVG(CASE WHEN churn = 'No' THEN monthly_charges END), 
        2
    ) as price_sensitivity_gap, --Difference between monthly revenue lost and monthly revenue retained i.e; if the calculated value is positive, revenue lost > revenue retained
    
    -- Customer Lifetime Metrics
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN total_charges END), 2) as total_lifetime_value_lost, --Total value lost from churned customers
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN total_charges END), 2) as avg_lifetime_value_per_churned, --Average value lost from churned customers
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN tenure END), 2) as avg_tenure_churned_months, --Average tenure of churned customers
    ROUND(AVG(CASE WHEN churn = 'No' THEN tenure END), 2) as avg_tenure_retained_months --Average tenure of retained customers

FROM customers;

/*
Business Overview:
As a whole we can see that 26.54% of our customers are churned with an annual revenue risk of Rs. 16,69,570.20. 
It also shows that we need to take immediate action as the amount we would be getting from our churned customers is greater than that of retained customers (price_sensitivity_gap>0)
The churned customers are mostly from <2 year tenure group and long-term customers are mostly retained
*/

/*=====================================================
QUERY 2: Churn Analysis by Contract Type
Purpose: Identify which contract types are highest risk
Business Question: Which contracts lose the most customers?
=====================================================*/

SELECT 
    contract as contract_type,
    
    -- Customer Metrics
    COUNT(*) as total_customers, --Returns total customers in each contract type
    SUM(churn_binary) as churned_customers, -- Returns churned customers from each contract type
    COUNT(*) - SUM(churn_binary) as retained_customers, --Returns retained customers from each contract type
    
    -- Churn Rate
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate_percent, --Returns churn rate for each contract type
    
    -- Revenue Impact
    ROUND(SUM(revenue_lost), 2) as annual_revenue_at_risk, --Returns annual revenue lost under each contract type
    ROUND(SUM(revenue_lost) / 12, 2) as monthly_revenue_lost, --Returns total monthly revenue lost under each contract type
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN monthly_charges END), 2) as avg_monthly_charge_churned, --Returns average monthly revenue lost under each contract type
    
    -- Customer Base Percentage
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) as pct_of_customer_base, --Returns percentage of customers in each contract type
    
    -- Churn Contribution 
    ROUND(
        100.0 * SUM(churn_binary) / (SELECT SUM(churn_binary) FROM customers),
        2
    ) as pct_of_total_churn -- Returns what % of total churn comes from this segment

FROM customers
GROUP BY contract
ORDER BY churn_rate_percent DESC;

/*
 Business Overview:
 Month-to-Month contracts lose the most customers with 42.71% churn rate and an annual revenue risk of Rs. 14,50,165.20
 Month-to-month contracts contribute almost 89% of the churned customers
 */

/*=====================================================
QUERY 3: Churn Analysis by Customer Tenure
Purpose: Identify when customers are most likely to churn
Business Question: Do we have a first-year retention problem?
=====================================================*/

SELECT 
    tenure_group,
    
    -- Customer Counts
    COUNT(*) as total_customers, --Returns total customers in each tenure group
    SUM(churn_binary) as churned_customers, --Returns total churned customers from these tenure groups
    
    -- Churn Rate
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate_percent, --Returns churn rate from each tenure group
    
    -- Revenue Impact
    ROUND(SUM(revenue_lost), 2) as annual_revenue_at_risk, --Returns annual revenue lost under each tenure group
    ROUND(100.0 * SUM(revenue_lost)/ (select SUM(revenue_lost) from customers), 2) as pct_of_total_annual_revenue_at_risk, --Returns % of annual revenue at risk from each tenure group
    
    -- Average Metrics
    ROUND(AVG(monthly_charges), 2) as avg_monthly_charge, --Returns average monthly charges in each tenure group
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN tenure END), 2) as avg_tenure_months_before_churn, --Returns average tenure of the churned customers
    
    -- Percentage of Total Churn from this Group
    ROUND(
        100.0 * SUM(churn_binary) / (SELECT SUM(churn_binary) FROM customers), 
        2
    ) as pct_of_total_churn --Returns % of customers churned from each tenure group

FROM customers
GROUP BY tenure_group 
ORDER BY tenure_group;

/*
 Business Overview:
 Yes, we do have 1st year retention problem with almost 47.44% churn rate and annual revenue at risk of Rs.8,27,451 which is almost 50% of overall revenue at risk
*/

/*=====================================================
QUERY 4: High-Risk Customer Profile Analysis
Purpose: Identify combinations of factors with highest churn
Business Question: What customer profile is riskiest?
=====================================================*/

SELECT 
    contract,
    internet_service,
    tech_support,
    tenure_group,
    
    -- Segment Size
    COUNT(*) as customer_count, --Total number of customers in each of these groups
    
    -- Churn Metrics
    SUM(churn_binary) as churned, --Total churned customers from these groups
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate, --Churn rate of each group
    
    -- Revenue Impact
    ROUND(SUM(revenue_lost), 2) as revenue_at_risk, --Total annual revenue at risk of each group
    
    -- Risk Level Classification
    CASE 
        WHEN ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) >= 50 THEN 'CRITICAL' 
        WHEN ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) >= 35 THEN 'HIGH'
        WHEN ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) >= 20 THEN 'MEDIUM'
        ELSE 'LOW'
    END as risk_level -- Shows which of these groups have the highest churn and at risk

FROM customers
GROUP BY contract, internet_service, tech_support, tenure_group
HAVING COUNT(*) >= 20  -- Only segments with meaningful sample size
ORDER BY churn_rate DESC
LIMIT 20;

/*
Business Overview:
The most riskiest customer profile is found to be Fiber optic, with no tech support, 0-1 tenure group.
It has got a churn rate of ~71%
*/

/*=====================================================
QUERY 5: Internet Service Type Deep Dive
Purpose: Understand why Fiber has higher churn than DSL
Business Question: What's causing high Fiber churn?
=====================================================*/

SELECT 
    internet_service,
    
    -- Customer Metrics
    COUNT(*) as total_customers, --Total customers based on internet type
    SUM(churn_binary) as churned_customers, --Churned customers within each type
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate, --Churn rate of each internet type
    
    -- Service Adoption Metrics
    ROUND(100.0 * SUM(CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_with_tech_support, --% of customers with tech support within each type
    ROUND(100.0 * SUM(CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_with_online_security, --% of customers with online security within each type
    ROUND(100.0 * SUM(CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_with_backup, --% of customers with online backup within each type
    
    -- Pricing Metrics
    ROUND(AVG(monthly_charges), 2) as avg_monthly_charge, --Average monthly charges from each service type
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN monthly_charges END), 2) as avg_charge_churned, --Average monthly charge of churned customers from each type
    ROUND(AVG(CASE WHEN churn = 'No' THEN monthly_charges END), 2) as avg_charge_retained, --Average monthly charge of retained customers from each type
    
    -- Contract Mix
    ROUND(100.0 * SUM(CASE WHEN contract = 'Month-to-month' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_month_to_month, --% of customers with month-to-month contract within each type
    
    -- Revenue Impact
    ROUND(SUM(revenue_lost), 2) as annual_revenue_at_risk --Annual revenue at risk for each type

FROM customers
WHERE internet_service != 'No'  -- Exclude customers without internet
GROUP BY internet_service
ORDER BY churn_rate DESC;

/*
 Business Overview:
 High fiber churn could be due to lack of technical support (only ~28% customers with technical support)
 It could also be due to online security issues (only ~27% of customers in fiber have online security) 
 */
 
-- =====================================================
-- QUERY 6: Payment Method Analysis
-- Purpose: Understand payment convenience impact on retention
-- Business Question: Should we incentivize auto-pay?
-- =====================================================

SELECT 
    payment_method,
    
    -- Customer Counts
    COUNT(*) as total_customers, 
    SUM(churn_binary) as churned_customers,
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate,
    
    -- Revenue Metrics
    ROUND(AVG(monthly_charges), 2) as avg_monthly_charge,
    ROUND(SUM(revenue_lost), 2) as annual_revenue_at_risk,
    
    -- Paperless Billing Adoption
    ROUND(100.0 * SUM(CASE WHEN paperless_billing = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_paperless, --% of customers that use paperless billing
    
    -- Tenure Metrics
    ROUND(AVG(tenure), 2) as avg_tenure_months, --Average tenure of customers in each payment method
    
    -- Customer Base %
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) as pct_of_customers, --% of customers using each payment method
    
    -- Recommendation
    CASE 
        WHEN ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) < 20 THEN 'Promote this method'
        WHEN ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) > 40 THEN 'Investigate issues'
        ELSE 'Monitor'
    END as recommendation --Shouws which payment method can be promoted and which needs to be investigated based on their churn rate

FROM customers
GROUP BY payment_method
ORDER BY churn_rate DESC;

/*
 Auto-pay methods (Bank transfer and Credit card) have the most retained customers and are the most convenient as compared to the others.
 These methods can be promoted while electronic check method needs to be investigated to find out the issues.
 */

/*=====================================================
QUERY 7: Customer Lifetime Value (CLV) Analysis
Purpose: Calculate potential revenue loss from churned customers
Used: CTE (Common Table Expression)
Business Question: What future value did we lose?
=====================================================*/

WITH customer_ltv AS (
    SELECT 
        customer_id,
        contract,
        internet_service,
        tenure,
        tenure_group,
        monthly_charges,
        total_charges,
        churn,
        churn_binary,
        -- Calculate estimated remaining lifetime value (assuming 6-year max)
        CASE 
            WHEN churn = 'No' THEN monthly_charges * (72 - tenure)
            ELSE 0 
        END as potential_future_value,
        -- Calculate CLV lost for churned customers
        CASE 
            WHEN churn = 'Yes' THEN monthly_charges * (72 - tenure)
            ELSE 0
        END as clv_lost
    FROM customers
)
SELECT 
    contract,
    internet_service,
    
    -- Segment Size
    COUNT(*) as customers,
    SUM(churn_binary) as churned,
    ROUND(100.0 * SUM(churn_binary) / COUNT(*), 2) as churn_rate,
    
    -- Historical Value
    ROUND(AVG(total_charges), 2) as avg_historical_value, --Average of total amount paid till now
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN total_charges END), 2) as total_historical_value_lost, --Total amount that is lost from churned customers
    
    -- Potential Future Value (if retained)
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN clv_lost END), 2) as avg_future_value_lost_per_customer, --Average potential amount lost in future given the customer tenure is 6 years
    ROUND(SUM(clv_lost), 2) as total_future_value_lost, --Total potential amount lost in future from churned customers over a period of 6 years
    
    -- Total CLV Impact (historical + future)
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN total_charges END) + SUM(clv_lost), 2) as total_clv_impact --Current loss + Future potential loss

FROM customer_ltv
GROUP BY contract, internet_service
ORDER BY total_clv_impact DESC;

-- =====================================================
-- QUERY 8: Retention Curve / Cohort Analysis
-- Purpose: Show when customers churn during their lifecycle
-- Used: Window Functions (SUM OVER, AVG OVER)
-- Business Question: At what point do we lose customers?
-- =====================================================

WITH tenure_cohorts AS (
    SELECT 
        tenure,
        COUNT(*) as total_customers,
        SUM(churn_binary) as churned_customers,
        COUNT(*) - SUM(churn_binary) as retained_customers
    FROM customers
    GROUP BY tenure
)
SELECT 
    tenure as months,
    total_customers,
    churned_customers,
    retained_customers,
    
    -- Churn Rate for this tenure month
    ROUND(100.0 * churned_customers / total_customers, 2) as churn_rate_at_month,
    
    -- Cumulative metrics (Window Function)
    SUM(total_customers) OVER (ORDER BY tenure) as cumulative_customers, --Total customers till the current month
    SUM(churned_customers) OVER (ORDER BY tenure) as cumulative_churned, --Churned customers till the current month 
    
    -- Survival Rate (what % of customers make it to this month)
    ROUND(
        100.0 * SUM(retained_customers) OVER (ORDER BY tenure) / 
        SUM(total_customers) OVER (ORDER BY tenure),
        2
    ) as survival_rate_percent
    
FROM tenure_cohorts
WHERE tenure <= 60  -- Focus on first 5 years
ORDER BY tenure;

/*
 Business Overview:
 We are loosing the most customers in the 1st month
 */
