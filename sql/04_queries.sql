-- 1. Quarterly revenue and profit
SELECT
    DATE_PART('quarter', o.OrderDate) AS Quarter,
    DATE_PART('year', o.OrderDate) AS Year,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
WHERE o.OrderDate BETWEEN '2010-01-01' AND '2024-12-31'
GROUP BY DATE_PART('year', o.OrderDate), DATE_PART('quarter', o.OrderDate)
ORDER BY Year, Quarter;

-- 2. Revenue and profit by region
SELECT
    r.RegionName AS Region,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
JOIN Country c ON o.CountryID = c.CountryID
JOIN Region r ON c.RegionID = r.RegionID
WHERE o.OrderDate BETWEEN '2010-01-01' AND '2024-12-31'
GROUP BY r.RegionName
ORDER BY TotalProfit DESC;

-- 3. Product performance by item type
SELECT
    it.ItemType AS ProductType,
    SUM(o.UnitsSold) AS TotalUnitsSold,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
JOIN ItemType it ON o.ItemTypeID = it.ItemTypeID
WHERE o.OrderDate BETWEEN '2010-01-01' AND '2024-12-31'
GROUP BY it.ItemType
ORDER BY TotalProfit DESC;
