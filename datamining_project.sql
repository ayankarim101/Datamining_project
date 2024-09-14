-- create schema retailshop; 

use retailshop;

select * from online_retail;

-- Beginner Queries

-- Query 1: Define Metadata in SQL Tool 
CREATE TABLE online_retail (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(10),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID VARCHAR(10),
    Country VARCHAR(100)
);

-- Query 2: Distribution of Order Values Across All Customers
SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID
ORDER BY TotalOrderValue DESC;

--  Query3: Unique Products Purchased by Each Customer
SELECT 
    CustomerID,
    COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM 
    online_retail
GROUP BY 
    CustomerID
ORDER BY 
    UniqueProductsPurchased DESC;
    
-- Query4: Customers Who Have Made Only a Single Purchase
SELECT 
    CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

-- Query 5: Most Commonly Purchased Products Together
SELECT 
    a.StockCode AS ProductA,
    b.StockCode AS ProductB,
    COUNT(*) AS TimesPurchasedTogether
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY a.StockCode, b.StockCode
ORDER BY TimesPurchasedTogether DESC
LIMIT 10;

-- Advance Queries

-- 1. Customer Segmentation by Purchase Frequency
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
    CASE 
        WHEN COUNT(DISTINCT InvoiceNo) > 20 THEN 'High'
        WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 5 AND 20 THEN 'Medium'
        ELSE 'Low'
    END AS FrequencySegment
FROM 
    online_retail
GROUP BY 
    CustomerID
ORDER BY 
    PurchaseFrequency DESC;

-- 2. Average Order Value by Country
SELECT 
    Country,
    AVG(TotalOrderValue) AS AverageOrderValue
FROM (
    SELECT 
        Country,
        InvoiceNo,
        SUM(Quantity * UnitPrice) AS TotalOrderValue
    FROM online_retail
    GROUP BY Country, InvoiceNo
) AS OrderValues
GROUP BY Country
ORDER BY AverageOrderValue DESC;


-- 3. Customer Churn Analysis
SELECT 
    CustomerID
FROM 
    online_retail
GROUP BY 
    CustomerID
HAVING 
    MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y')) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 4. Product Affinity Analysis 
SELECT 
    a.StockCode AS ProductA,
    b.StockCode AS ProductB,
    COUNT(*) AS TimesPurchasedTogether
FROM 
    online_retail a
JOIN 
    online_retail b 
ON 
    a.InvoiceNo = b.InvoiceNo 
    AND a.StockCode < b.StockCode
GROUP BY 
    a.StockCode, b.StockCode
    
ORDER BY 
    TimesPurchasedTogether DESC
LIMIT 10;

-- 5. Time-Based Analysis
-- Monthly Sales Pattern:
SELECT 
    DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y'), '%Y-%m') AS Month,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM 
    online_retail
GROUP BY 
    Month
ORDER BY 
    Month;

-- Quarterly Sales Pattern:
SELECT 
    CONCAT(YEAR(STR_TO_DATE(InvoiceDate, '%m/%d/%Y')), '-Q', QUARTER(STR_TO_DATE(InvoiceDate, '%m/%d/%Y'))) AS Quarter,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM 
    online_retail
GROUP BY 
    Quarter
ORDER BY 
    Quarter;
