"""ETL: Load macro monthly indicators from raw files into macro_monthly table.

Usage:
    python -m src.etl.load_macro_monthly --file data/raw/nbs/统计局_20260211.xlsx
"""

import argparse
import logging

import pandas as pd
from sqlalchemy import text

from src.utils.db import get_engine

logger = logging.getLogger(__name__)


def load(file_path: str, engine=None):
    """Read a raw macro data file, clean, and insert into macro_monthly."""
    engine = engine or get_engine()
    logger.info("Loading macro monthly data from %s", file_path)

    # TODO: Implement file parsing logic per vendor format
    # - Skip metadata header rows
    # - Map columns to indicator_code
    # - Handle NaN / empty strings -> NULL
    # - Insert with data_version tracking
    raise NotImplementedError("Implement per vendor file format")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True, help="Path to raw data file")
    args = parser.parse_args()
    load(args.file)
