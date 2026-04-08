-- Raw-load staging table
CREATE TABLE StagingTable (
    Region VARCHAR(100),
    Country VARCHAR(100),
    ItemType VARCHAR(100),
    SalesChannel VARCHAR(50),
    OrderPriority VARCHAR(10),
    OrderDate DATE,
    OrderID INT PRIMARY KEY NOT NULL,
    ShipDate DATE,
    UnitsSold INT,
    UnitPrice NUMERIC(10, 2),
    UnitCost NUMERIC(10, 2),
    TotalRevenue NUMERIC(15, 2),
    TotalCost NUMERIC(15, 2),
    TotalProfit NUMERIC(15, 2)
);

-- Replace the file path below with the actual Task 1 sales CSV location.
\copy public.stagingtable (
    region,
    country,
    itemtype,
    saleschannel,
    orderpriority,
    orderdate,
    orderid,
    shipdate,
    unitssold,
    unitprice,
    unitcost,
    totalrevenue,
    totalcost,
    totalprofit
) FROM 'path/to/sales_records.csv'
DELIMITER ','
CSV HEADER
QUOTE '"'
ESCAPE '''';

-- Verify there are no duplicate order IDs in the staging load.
SELECT orderid, COUNT(*)
FROM stagingtable
GROUP BY orderid
HAVING COUNT(*) > 1;

-- Load normalized dimensions
INSERT INTO Region (RegionName)
SELECT DISTINCT Region
FROM StagingTable
WHERE Region IS NOT NULL;

INSERT INTO Country (CountryName, RegionID)
SELECT DISTINCT st.Country, r.RegionID
FROM StagingTable st
JOIN Region r ON st.Region = r.RegionName
WHERE st.Country IS NOT NULL;

INSERT INTO ItemType (ItemType)
SELECT DISTINCT ItemType
FROM StagingTable
WHERE ItemType IS NOT NULL;

INSERT INTO SalesChannel (SalesChannel)
SELECT DISTINCT SalesChannel
FROM StagingTable
WHERE SalesChannel IS NOT NULL;

-- Load fact table
INSERT INTO Orders (
    OrderID,
    CountryID,
    ItemTypeID,
    SalesChannelID,
    OrderPriority,
    OrderDate,
    ShipDate,
    UnitsSold,
    UnitPrice,
    UnitCost
)
SELECT
    st.OrderID,
    c.CountryID,
    it.ItemTypeID,
    sc.SalesChannelID,
    st.OrderPriority,
    st.OrderDate,
    st.ShipDate,
    st.UnitsSold,
    st.UnitPrice,
    st.UnitCost
FROM StagingTable st
JOIN Country c ON st.Country = c.CountryName
JOIN ItemType it ON st.ItemType = it.ItemType
JOIN SalesChannel sc ON st.SalesChannel = sc.SalesChannel;

-- Optional cleanup after load
DROP TABLE StagingTable;
