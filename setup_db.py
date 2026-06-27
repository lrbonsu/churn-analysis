import pandas as pd
import sqlite3
import os

# ── Paths ──────────────────────────────────────────────
CSV_PATH = "data/telco_churn.csv"
DB_PATH  = "data/churn.db"

# ── Load CSV ───────────────────────────────────────────
df = pd.read_csv(CSV_PATH)

# ── Light cleaning before loading ─────────────────────
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
df["TotalCharges"] = df["TotalCharges"].fillna(0)

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_", regex=False)
)

df["churn"] = df["churn"].map({"Yes": 1, "No": 0})

# ── Write to SQLite ────────────────────────────────────
conn = sqlite3.connect(DB_PATH)
df.to_sql("customers", conn, if_exists="replace", index=False)
conn.close()

print(f"✓ Database created at: {DB_PATH}")
print(f"✓ Rows loaded: {len(df):,}")
print(f"✓ Columns: {list(df.columns)}")