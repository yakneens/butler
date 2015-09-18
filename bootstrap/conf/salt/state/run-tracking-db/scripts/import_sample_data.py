import pandas as pd
df = pd.read_csv('pcawg_sample_list_august_2015.csv')
df.columns = [c.lower() for c in df.columns]

from sqlalchemy import create_engine
engine = create_engine('postgresql://pcawg_admin:pcawg@localhost:5432/germline_genotype_tracking')

df.to_sql("pcawg_samples", engine)