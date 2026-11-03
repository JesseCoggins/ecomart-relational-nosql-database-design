# EcoMart Relational + NoSQL Database Design

## Overview
This repo packages two database design projects built around the EcoMart scenario:
- a PostgreSQL relational database for transactional analytics
- a MongoDB document database for flexible product and grocery data exploration

The goal was to show database design, data loading, query writing, and query optimization across both relational and non-relational systems.

## Academic Context
Completed during my M.S. in Data Analytics at Western Governors University (WGU), then packaged here as a public portfolio project.

## What This Repo Shows
- normalized relational schema design in PostgreSQL
- staging-table ETL and dimensional loading patterns
- analytical SQL queries, indexes, CTEs, and views
- MongoDB collection setup, import commands, aggregation queries, and indexing

## Repo Structure
- `sql/01_create_database.sql`
- `sql/02_schema.sql`
- `sql/03_load_from_staging.sql`
- `sql/04_queries.sql`
- `sql/05_indexes.sql`
- `sql/06_optimization_examples.sql`
- `sql/07_views.sql`
- `mongo/01_create_collections.js`
- `mongo/02_import_commands.sh`
- `mongo/03_queries.js`
- `mongo/04_indexes_and_optimization.js`
- `data/Sales_Records.csv`
- `data/cosmetics.json`
- `data/groceries.json`
- `data/README.md`

## Relational Project Summary
The PostgreSQL design models EcoMart sales activity using `Region`, `Country`, `ItemType`, `SalesChannel`, and `Orders` tables. It uses a staging table to load raw sales data and then inserts cleaned, normalized records into the production schema. The analytical layer includes:
- quarterly revenue and profit analysis
- region-level revenue and profit analysis
- product performance by item type
- query optimization with indexes, subqueries, and CTEs
- reusable views for management reporting

![EcoMart entity-relationship diagram showing the links from Orders to Country, ItemType and SalesChannel, and from Country to Region](assets/relational-schema.png)

To load the supplied sales CSV, open a clean PostgreSQL database and run the following from the repository root. The second command stops on errors and rolls back its transaction if the import fails.

~~~shell
psql -v ON_ERROR_STOP=1 -d ecomart -f sql/02_schema.sql
psql -v ON_ERROR_STOP=1 --single-transaction -d ecomart -f sql/03_load_from_staging.sql
psql -d ecomart -c "SELECT count(*) FROM orders"
~~~

The final query should return 100,000 orders.

## Query optimization

The original D597 Task 1 report records how long pgAdmin took to complete three management reports before and after the indexing step. Both runs used the 100,000-order dataset. Each query returned the same number of rows in both runs.

| PostgreSQL report | Rows returned | Before indexing | After indexing |
|---|---:|---:|---:|
| Quarterly revenue and profit | 31 | 80 ms | 73 ms |
| Revenue and profit by region | 7 | 89 ms | 71 ms |
| Product performance by item type | 12 | 89 ms | 76 ms |

The regional report had the largest observed difference at 18 ms. Section F4 records one timing per query in each condition. Establishing a repeatable speedup would require multiple runs under comparable conditions. [Reporting queries](sql/04_queries.sql) · [Index definitions](sql/05_indexes.sql)

For the product report, the coursework also explores aggregating orders by item type before joining the product names. The repository includes both a subquery and a common table expression for that approach. The MongoDB project separately covers indexes for member purchases and cosmetic product searches. [SQL aggregation examples](sql/06_optimization_examples.sql) · [MongoDB optimization examples](mongo/04_indexes_and_optimization.js)

## NoSQL Project Summary
The MongoDB design uses document collections for cosmetics and grocery transaction data. It focuses on:
- member loyalty analysis
- ranking versatile, high-quality cosmetics
- ingredient-based product discovery for trend-driven marketing
- query optimization with indexes and reduced scan patterns

## Data Notes
- The PostgreSQL sales source file is now included as `data/Sales_Records.csv` with `100,000` transactional rows.
- The two MongoDB JSON datasets are included in `data/`.
- The staging-load SQL in `sql/03_load_from_staging.sql` points directly to `data/Sales_Records.csv` for a repo-local import path.

## Environment Notes
- PostgreSQL was the target platform for the relational portion.
- MongoDB shell and `mongoimport` were the target tools for the document-database portion.
- No Python environment is required for this repo.
