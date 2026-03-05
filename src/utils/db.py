"""Database connection utilities."""

import os
from contextlib import contextmanager

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


def get_engine(url: str | None = None):
    """Create a SQLAlchemy engine from URL or environment variable."""
    db_url = url or os.getenv(
        "DATABASE_URL",
        "mysql+pymysql://root:@localhost:3306/robo_advisor?charset=utf8mb4",
    )
    return create_engine(db_url, pool_pre_ping=True, pool_recycle=3600)


@contextmanager
def get_connection(engine=None):
    """Yield a raw DBAPI connection, auto-close on exit."""
    eng = engine or get_engine()
    conn = eng.connect()
    try:
        yield conn
    finally:
        conn.close()


SessionLocal = sessionmaker(bind=get_engine())
