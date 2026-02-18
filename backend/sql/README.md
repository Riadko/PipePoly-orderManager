How to apply the simplified inventory SQL scripts

If you don't have the `psql` CLI installed, use one of:
- PGAdmin, DBeaver, or TablePlus to run the SQL files.
- Or install psql on Windows via PostgreSQL installer or via Chocolatey: `choco install postgresql`

Recommended order:
1. db_schema_inventory_simplified.sql  -> ensures tables exist and inventory_segments dropped
2. setup_inventory_pieces.sql         -> inserts inventory rows for all pieces/dimensions

Run each script in your DB GUI or via psql with:

psql -U postgres -d pipepoly -f path\to\db_schema_inventory_simplified.sql
psql -U postgres -d pipepoly -f path\to\setup_inventory_pieces.sql

Adjust user / database names as needed.
