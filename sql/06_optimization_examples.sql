-- Optimization example 1: pre-aggregate in a subquery before joining
SELECT
    it.ItemType AS ProductType,
    aggregated.TotalUnitsSold,
    aggregated.TotalRevenue,
    aggregated.TotalProfit
FROM ItemType it
JOIN (
    SELECT
        o.ItemTypeID,
        SUM(o.UnitsSold) AS TotalUnitsSold,
        SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
        SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
    FROM Orders o
    WHERE o.OrderDate BETWEEN '2010-01-01' AND '2024-12-31'
    GROUP BY o.ItemTypeID
) aggregated ON it.ItemTypeID = aggregated.ItemTypeID
ORDER BY aggregated.TotalProfit DESC;

-- Optimization example 2: use a CTE to simplify and reuse aggregation work
WITH AggregatedData AS (
    SELECT
        o.ItemTypeID,
        SUM(o.UnitsSold) AS TotalUnitsSold,
        SUM(o.UnitsSold * o.UnitPrice) AS TotalRevenue,
        SUM((o.UnitsSold * o.UnitPrice) - (o.UnitsSold * o.UnitCost)) AS TotalProfit
    FROM Orders o
    WHERE o.OrderDate BETWEEN '2010-01-01' AND '2024-12-31'
    GROUP BY o.ItemTypeID
)
SELECT
    it.ItemType AS ProductType,
    ad.TotalUnitsSold,
    ad.TotalRevenue,
    ad.TotalProfit
FROM AggregatedData ad
JOIN ItemType it ON it.ItemTypeID = ad.ItemTypeID
ORDER BY ad.TotalProfit DESC;
