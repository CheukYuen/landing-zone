"""Data quality checks for ETL pipeline.

Run after Step 2 (Layer 1 write), before Step 4 (snapshot aggregation).
"""

import logging

import pandas as pd
from sqlalchemy import text

from src.utils.db import get_engine

logger = logging.getLogger(__name__)

# Core indicators that must not be NULL for a given month
CORE_INDICATORS = [
    "CPI_YOY", "PPI_YOY", "M2_YOY", "PMI_MANU",
    "DR007", "YIELD_10Y", "LPR_1Y",
]


def check_completeness(month: str, engine=None) -> list[str]:
    """Check that all core indicators have values for given month.
    Returns list of missing indicator codes.
    """
    engine = engine or get_engine()
    placeholders = ",".join([f":c{i}" for i in range(len(CORE_INDICATORS))])
    sql = f"""
        SELECT indicator_code
        FROM macro_monthly
        WHERE stat_month = :month
          AND indicator_code IN ({placeholders})
          AND value IS NOT NULL
          AND data_version = (
              SELECT MAX(data_version)
              FROM macro_monthly m2
              WHERE m2.indicator_code = macro_monthly.indicator_code
                AND m2.stat_month = macro_monthly.stat_month
          )
    """
    params = {f"c{i}": c for i, c in enumerate(CORE_INDICATORS)}
    params["month"] = month

    with engine.connect() as conn:
        result = conn.execute(text(sql), params)
        found = {row[0] for row in result}

    missing = [c for c in CORE_INDICATORS if c not in found]
    if missing:
        logger.warning("Missing core indicators for %s: %s", month, missing)
    else:
        logger.info("All core indicators present for %s", month)

    return missing


def check_outliers(month: str, sigma: float = 3.0, engine=None) -> pd.DataFrame:
    """Flag values beyond N sigma from historical mean.
    Returns DataFrame of flagged records.
    """
    engine = engine or get_engine()
    sql = """
        SELECT
            m.indicator_code,
            m.stat_month,
            m.value,
            stats.avg_val,
            stats.std_val
        FROM macro_monthly m
        JOIN (
            SELECT
                indicator_code,
                AVG(value) AS avg_val,
                STDDEV(value) AS std_val
            FROM macro_monthly
            WHERE data_version = (
                SELECT MAX(data_version)
                FROM macro_monthly m2
                WHERE m2.indicator_code = macro_monthly.indicator_code
                  AND m2.stat_month = macro_monthly.stat_month
            )
            GROUP BY indicator_code
        ) stats ON m.indicator_code = stats.indicator_code
        WHERE m.stat_month = :month
          AND m.data_version = (
              SELECT MAX(data_version)
              FROM macro_monthly m2
              WHERE m2.indicator_code = m.indicator_code
                AND m2.stat_month = m.stat_month
          )
          AND stats.std_val > 0
          AND ABS(m.value - stats.avg_val) > :sigma * stats.std_val
    """
    df = pd.read_sql(sql, engine, params={"month": month, "sigma": sigma})

    if not df.empty:
        logger.warning("Outliers detected for %s:\n%s", month, df.to_string())
    else:
        logger.info("No outliers detected for %s", month)

    return df
