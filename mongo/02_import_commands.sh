#!/usr/bin/env bash

# Run these commands from the repo root or adjust the paths as needed.

mongoimport \
  --db ecomart \
  --collection cosmetics \
  --file "data/cosmetics.json" \
  --jsonArray

mongoimport \
  --db ecomart \
  --collection groceries \
  --file "data/groceries.json" \
  --jsonArray
