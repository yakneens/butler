import pandas as pd
import sys


df = pd.read_csv(sys.argv[1])
df.columns = [c.lower() for c in df.columns]

from sqlalchemy import create_engine
engine = create_engine('postgresql://pcawg_admin:pcawg@run-tracking-db.service.consul:5432/germline_genotype_tracking')

df.to_sql("pcawg_samples", engine)