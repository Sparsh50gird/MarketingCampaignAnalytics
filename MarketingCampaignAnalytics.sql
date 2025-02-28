CREATE DATABASE DB1
SELECT * FROM Marketing

EXEC sp_rename 'Marketing.c_date', 'campaign_date', 'COLUMN';

SELECT DISTINCT* FROM Marketing

SELECT campaign_name FROM Marketing GROUP BY campaign_name

SELECT ROUND(SUM(mark_spent),2) AS TOTAL_MARKET_SPEND,SUM(REVENUE) AS TOTAL_REVENUE FROM Marketing


SELECT TOP 1 category, SUM(revenue) AS TOTAL_REVENUE FROM Marketing 
GROUP BY category
-- Influencer category is giving the maximum revenue


SELECT TOP 1 category, SUM(mark_spent) AS MARKET_SPENT FROM Marketing GROUP BY category
ORDER BY SUM(mark_spent) 


--ROMI return on marketing investments, how effective is marketing campaign, one metric that shows effectiveness of every rupee spent.
--It is calculated ( Total earning (Revenue) - Marketing cost ) / Marketing cost )


--ROMI 
SELECT ROUND(SUM(mark_spent),0) AS TOTAL_MARKETING_SPEND,SUM(revenue) AS TOTAL_REVENUE, ROUND((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent),3) AS ROMI FROM Marketing


--ROMI BY CAMPAIGNS
SELECT campaign_name, ROUND((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent),3) AS ROMI FROM Marketing GROUP BY campaign_name

--Performance of the campaign depending on the date - on which date did we spend the most money on advertising,
--when we got the biggest revenue when conversion rates were high and low? What were the average order values?

SELECT* FROM Marketing




--Click-through rate(CTR). percentage of people who clicked at banner (Clicks/ Impressions)
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Marketing';

SELECT ROUND((SUM(CAST(clicks AS FLOAT))/SUM(impressions))*100,4) AS CTR FROM Marketing

-- Activity status on weekdays vs weekends

SELECT TOP 5 * FROM Marketing

SELECT DATENAME(WEEKDAY,campaign_date) AS 'DAY OF THE WEEK', COUNT(orders) AS ORDER_COUNT,SUM(revenue) AS REVENUE FROM Marketing
GROUP BY DATENAME(WEEKDAY,campaign_date) ORDER BY REVENUE
--THE ORDER COUNT IS SAME ON EACH DAY BUT MAXIMUM REVENUE IS GENERATED ON SUNDAY


-----------------------------------------------------------------------

--Average revenue generated during weekdays vs weekends

WITH Marketing_Categorized AS (
    SELECT 
        CASE 
            WHEN DATENAME(WEEKDAY, campaign_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
            ELSE 'Weekday'
        END AS Day_Type,
        Revenue,orders
    FROM Marketing
)
SELECT 
    Day_Type,
    ROUND(AVG(Revenue),3) AS Avg_Revenue, COUNT(orders) AS ORDERS_CNT
FROM Marketing_Categorized
GROUP BY Day_Type;

----------------------------------------------------------------------------

--Conversion 1 conversion from visitors to leads for this campaign (Leads/Click)

SELECT campaign_name, SUM(impressions)/SUM(clicks) AS CONVERSION1 FROM Marketing GROUP BY campaign_name


--Conversion 2 conversion rate from leads to sales (Orders/Leads)

SELECT campaign_name, SUM(orders)/SUM(leads) AS CONVERSION2 FROM Marketing GROUP BY campaign_name


--Average order value (AOV) Average order value for this campaign (Revenue/Number of Orders)

SELECT ROUND(SUM(revenue)/ COUNT(orders),3) AS AVG_ORDER_VALUE FROM Marketing 

--Cost per click (CPC) how much does it cost us to attract 1 click (on average)
--(Marketing spending/Clicks)

SELECT ROUND(SUM(mark_spent)/SUM(clicks),2)AS COST_PER_CLICK FROM Marketing


--Cost per lead (CPL) how much does it cost us to attract 1 lead (on average)
--(Marketing spending/Leads)

SELECT ROUND(SUM(mark_spent)/SUM(leads),2) AS COST_PER_CLICK FROM Marketing


--Customer acquisition cost (CAC) -- how much does it cost us to attract 1 order (on average)
--(marketing spend/ orders)

SELECT ROUND(SUM(mark_spent)/SUM(orders),2) AS CAC FROM Marketing


--Gross  Profit or loss after deducting marketing cost (Revenue-Marketing spending)

SELECT ROUND(SUM(revenue)-SUM(mark_spent),2) AS GROSSPL FROM Marketing

--monthly recurring revenue


--crr




WITH DailyRevenue AS (
    SELECT 
        campaign_date,  
        SUM(revenue) AS DailyReccRevenue
    FROM Marketing
    GROUP BY campaign_date
)
SELECT 
    campaign_date, 
    DailyReccRevenue, 
    LAG(DailyReccRevenue, 1, NULL) OVER (ORDER BY campaign_date) AS PreviousDayRevenue,
    ( 
        (DailyReccRevenue - LAG(DailyReccRevenue, 1, NULL) OVER (ORDER BY campaign_date)) 
        / NULLIF(LAG(DailyReccRevenue, 1, NULL) OVER (ORDER BY campaign_date), 0) 
    ) * 100 AS PercentChange
FROM DailyRevenue
ORDER BY campaign_date;





SELECT * FROM Marketing
SELECT DATENAME(MONTH,campaign_date) FROM Marketing

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Marketing'

