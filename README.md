# EcoMart Relational + NoSQL Database Design

## Overview
This repo packages two database design projects built around the EcoMart scenario:
- a PostgreSQL relational database for transactional analytics
- a MongoDB document database for flexible product and grocery data exploration

The goal was to show database design, data loading, query writing, and query optimization across both relational and non-relational systems.

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

## NoSQL Project Summary
The MongoDB design uses document collections for cosmetics and grocery transaction data. It focuses on:
- member loyalty analysis
- ranking versatile, high-quality cosmetics
- ingredient-based product discovery for trend-driven marketing
- query optimization with indexes and reduced scan patterns

## Data Notes
- The two MongoDB JSON datasets are included in `data/`.
- The original Task 1 relational sales CSV was not present in the local coursework archive, so the PostgreSQL import script is included with a placeholder source path rather than the raw CSV itself.

## Environment Notes
- PostgreSQL was the target platform for the relational portion.
- MongoDB shell and `mongoimport` were the target tools for the document-database portion.
- No Python environment is required for this repo.
