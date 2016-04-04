import pandas as pd
import sys
from os import environ


df = pd.read_csv(sys.argv[1], sep="\t")
df.columns = [c.lower() for c in df.columns]

from sqlalchemy import create_engine

DB_URL = environ.get('DB_URL')

if not DB_URL:
    raise ValueError("DB_URL not present in the environment")

engine = create_engine(DB_URL)

try:
    df.to_sql("pcawg_samples", engine)
except ValueError as e:
    if str(e) != "Table 'pcawg_samples' already exists.":
        print str(e)
        exit(1)
    else:
        print str(e)

engine.dispose()