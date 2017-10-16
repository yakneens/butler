import os

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.orm.scoping import scoped_session
from sqlalchemy.pool import NullPool

DB_URL = os.environ.get('DB_URL')

if not DB_URL:
    raise ValueError("DB_URL not present in the environment")

Base = automap_base()
engine = create_engine(DB_URL, poolclass=NullPool)
Base.prepare(engine, reflect=True)

session_factory = sessionmaker(bind=engine, expire_on_commit=False)
Session = scoped_session(session_factory)
Base.query = Session.query_property()