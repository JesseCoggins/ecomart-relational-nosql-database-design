# EcoMart retail reporting with PostgreSQL and MongoDB

I designed a five-table PostgreSQL database to turn **100,000 sales records** into consistent quarterly, regional and product reports. The regional report identifies Sub-Saharan Africa and Europe as the largest profit totals in the dataset. A separate MongoDB analysis explores member purchases and product attributes. Managers can use these reports to investigate regional performance and product mix.

[Review the PostgreSQL reporting queries](sql/04_queries.sql) · [See the timing comparison](#query-optimization) · [Explore the MongoDB queries](mongo/03_queries.js)

## Relational design

A staging table accepts the sales CSV. SQL then loads five normalized tables. Each order references a country, item type and sales channel, and each country belongs to a region. Storing those relationships once gives the three management reports a consistent definition of region and product. Reusable views expose the aggregations to reporting tools. [Schema](sql/02_schema.sql) · [Staging and load](sql/03_load_from_staging.sql) · [Reporting views](sql/07_views.sql)

![EcoMart entity-relationship diagram linking orders to country, item type and sales channel, and country to region](assets/relational-schema.png)

## Business reporting results

Applying the reporting queries’ 2010–2024 date filter to the included CSV retains all 100,000 orders, dated January 2010 through July 2017. Recomputing `UnitsSold × (UnitPrice − UnitCost)` gives:

| Region | Total modeled sales profit |
|---|---:|
| Sub-Saharan Africa | $10,306,312,642.23 |
| Europe | $10,080,579,491.05 |
| Asia | $5,707,511,516.76 |

These are the three largest regional totals in this scenario. Managers could use the seven-region report to prioritize investigation, then compare order volume and product mix before deciding where to invest. The totals are dataset aggregations, not profit improvements caused by the database. The other reports return 31 year-quarter groups and 12 product types.

## Query optimization

I compared pgAdmin completion times for three management reports before and after indexing. Both runs used the 100,000-order dataset. Each query returned the same number of rows in both runs.

| PostgreSQL report | Rows returned | Before indexing | After indexing |
|---|---:|---:|---:|
| Quarterly revenue and profit | 31 | 80 ms | 73 ms |
| Revenue and profit by region | 7 | 89 ms | 71 ms |
| Product performance by item type | 12 | 89 ms | 76 ms |

The regional report had the largest observed difference at 18 ms. I timed each query once before and once after indexing. Those runs show the observed difference, but I would need repeated runs under comparable conditions to claim a repeatable speedup. [Reporting queries](sql/04_queries.sql) · [Index definitions](sql/05_indexes.sql)

For the product report, I also explored aggregating orders by item type before joining the product names. The repository includes both a subquery and a common table expression for that approach. The MongoDB project separately covers indexes for member purchases and cosmetic product searches. [SQL aggregation examples](sql/06_optimization_examples.sql) · [MongoDB optimization examples](mongo/04_indexes_and_optimization.js)

## NoSQL project

The grocery query ranks members by recorded item purchases. Each document is an item row, so `recordedItemCount` does not count shopping visits. For example, member 3180 has 36 item rows across 10 recorded dates. A visit-frequency analysis would need a separate member/date grouping; dates are only a proxy because the file has no basket identifier.

The cosmetics queries find highly rated products for combination skin and search ingredients for a marketing brief. The ingredient query returns 772 products containing Butylene Glycol, ordered by rating and name. Its equivalent example preserves that result set. A separately labeled business variant requires `Rank >= 4` and returns 574 products; that filter changes the question. The cosmetics index includes skin type and rank, while an unanchored ingredient-substring search can still require scanning text. [Collection definitions](mongo/01_create_collections.js) · [Aggregation and search queries](mongo/03_queries.js)

## Run it yourself

From the repository root, create `ecomart`, then load its schema and sales records. Use a PostgreSQL role with database-creation privileges. The sales import runs in a single transaction; the final count should be 100,000.

~~~sh
psql -v ON_ERROR_STOP=1 -d postgres -f sql/01_create_database.sql
psql -v ON_ERROR_STOP=1 -d ecomart -f sql/02_schema.sql
psql -v ON_ERROR_STOP=1 --single-transaction -d ecomart -f sql/03_load_from_staging.sql
psql -d ecomart -c "SELECT count(*) FROM orders"
~~~

To compare timings yourself, run the three reporting queries before and after applying the index definitions. For MongoDB, create the collections in the separate MongoDB database also named `ecomart`, then import both JSON arrays. The PostgreSQL and MongoDB databases are independent.

~~~sh
mongosh --file mongo/01_create_collections.js
bash mongo/02_import_commands.sh
mongosh --file mongo/03_queries.js
~~~

Run the commands from the repository root. The import script uses `mongoimport` for both arrays. [Index definitions](sql/05_indexes.sql) · [MongoDB import commands](mongo/02_import_commands.sh) · [Dataset notes](data/README.md)

## Data and environment

Data: WGU retail sales, groceries and cosmetics datasets; [source notes](data/README.md).  
Setup: use PostgreSQL/psql and MongoDB/mongosh/mongoimport as described above.

*WGU M.S. in Data Analytics coursework, D597 Data Management.*
