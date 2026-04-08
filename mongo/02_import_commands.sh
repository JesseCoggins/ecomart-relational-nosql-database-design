#!/usr/bin/env bash

# Run these commands from the repo root or adjust the paths as needed.

mongoimport \
  --db D597Task2 \
  --collection cosmetics \
  --file "data/cosmetics.json" \
  --jsonArray

mongoimport \
  --db D597Task2 \
  --collection groceries \
  --file "data/groceries.json" \
  --jsonArray
