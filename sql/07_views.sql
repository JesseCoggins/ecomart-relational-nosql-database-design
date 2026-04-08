-- Revenue and profit by region
CREATE VIEW RevenueByRegion AS
SELECT
    r.RegionName AS Region,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
JOIN Country c ON o.CountryID = c.CountryID
JOIN Region r ON c.RegionID = r.RegionID
GROUP BY r.RegionName;

SELECT * FROM RevenueByRegion ORDER BY TotalProfit DESC;

-- Product performance
CREATE VIEW ProductPerformance AS
SELECT
    it.ItemType AS ProductType,
    SUM(o.UnitsSold) AS TotalUnitsSold,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
JOIN ItemType it ON o.ItemTypeID = it.ItemTypeID
GROUP BY it.ItemType;

SELECT * FROM ProductPerformance ORDER BY TotalProfit DESC LIMIT 15;

-- Quarterly trends
CREATE VIEW QuarterlyTrends AS
SELECT
    DATE_PART('quarter', o.OrderDate) AS Quarter,
    DATE_PART('year', o.OrderDate) AS Year,
    SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
    SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
FROM Orders o
GROUP BY DATE_PART('year', o.OrderDate), DATE_PART('quarter', o.OrderDate);

SELECT * FROM QuarterlyTrends WHERE Year = 2015 ORDER BY Quarter;
