import pandas as pd
import sys


df = pd.read_csv(sys.argv[1])
df.columns = [c.lower() for c in df.columns]

from sqlalchemy import create_engine
engine = create_engine('postgresql://localhost:5432/germline_genotype_tracking')

try:
    df.to_sql("pcawg_samples", engine)
except ValueError as e:
    if e.strerror != "Table 'pcawg_samples' already exists":
        print e.strerror
        exit(1)
        