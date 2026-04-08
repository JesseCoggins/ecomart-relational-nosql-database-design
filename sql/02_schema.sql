-- Dimension tables
CREATE TABLE Region (
    RegionID SERIAL PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL
);

CREATE TABLE Country (
    CountryID SERIAL PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL,
    RegionID INT NOT NULL,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

CREATE TABLE ItemType (
    ItemTypeID SERIAL PRIMARY KEY,
    ItemType VARCHAR(100) NOT NULL
);

CREATE TABLE SalesChannel (
    SalesChannelID SERIAL PRIMARY KEY,
    SalesChannel VARCHAR(50) NOT NULL
);

-- Fact table
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CountryID INT NOT NULL,
    ItemTypeID INT NOT NULL,
    SalesChannelID INT NOT NULL,
    OrderPriority VARCHAR(10) NOT NULL,
    OrderDate DATE NOT NULL,
    ShipDate DATE NOT NULL,
    UnitsSold INT NOT NULL,
    UnitPrice NUMERIC(10, 2) NOT NULL,
    UnitCost NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID),
    FOREIGN KEY (ItemTypeID) REFERENCES ItemType(ItemTypeID),
    FOREIGN KEY (SalesChannelID) REFERENCES SalesChannel(SalesChannelID)
);
