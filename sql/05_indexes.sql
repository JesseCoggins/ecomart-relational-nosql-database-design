-- Indexes on frequently filtered or joined columns
CREATE INDEX idx_orders_orderdate ON Orders(OrderDate);
CREATE INDEX idx_orders_itemtypeid ON Orders(ItemTypeID);
CREATE INDEX idx_orders_countryid ON Orders(CountryID);
-- Note: this is redundant with the primary key's implicit index, but it is preserved here to match the original project work.
CREATE INDEX idx_itemtype_itemtypeid ON ItemType(ItemTypeID);
