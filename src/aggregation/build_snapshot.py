"""Aggregation: Build monthly snapshot (Layer 2) from Layer 1 tables.

Calls the stored procedure proc_build_monthly_snapshot.

Usage:
    python -m src.aggregation.build_snapshot --month 2026-02
"""

import argparse
import logging

from sqlalchemy import text

from src.utils.db import get_engine

logger = logging.getLogger(__name__)


def build(month: str, engine=None):
    """Call stored procedure to build monthly snapshot for given month."""
    engine = engine or get_engine()
    logger.info("Building monthly snapshot for %s", month)

    with engine.connect() as conn:
        conn.execute(text("CALL proc_build_monthly_snapshot(:month)"), {"month": month})
        conn.commit()

    logger.info("Snapshot for %s built successfully", month)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("--month", required=True, help="Target month YYYY-MM")
    args = parser.parse_args()
    build(args.month)
