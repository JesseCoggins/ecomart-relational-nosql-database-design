# Data Notes

Included in this repo:
- `Sales_Records.csv`
- `cosmetics.json`
- `groceries.json`

Notes:
- `Sales_Records.csv` is the restored Task 1 relational source file used for the PostgreSQL staging-table import.
- The file contains `100,000` rows and matches the column mapping used in `sql/03_load_from_staging.sql`.

## Origin and reuse

These are the course-supplied inputs used for WGU D597: `Sales_Records.csv` for the relational sales database and `groceries.json` / `cosmetics.json` for the separate MongoDB exercises. “EcoMart” is the reporting scenario, not a claim of client work.

The course materials reviewed identify the dataset and scenario but do not state an upstream redistribution license. The repository’s MIT license covers the project code, not a new license grant for third-party data. No claim that the records are synthetic is made.
