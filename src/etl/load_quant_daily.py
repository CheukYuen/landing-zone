"""ETL: Load quant daily data into quant_daily table.

Usage:
    python -m src.etl.load_quant_daily --file data/raw/wind/quant_data_20260216.csv
"""

import argparse
import logging

import pandas as pd
from sqlalchemy import text

from src.utils.db import get_engine

logger = logging.getLogger(__name__)


def load(file_path: str, engine=None):
    """Read a raw quant data file, clean, and insert into quant_daily."""
    engine = engine or get_engine()
    logger.info("Loading quant daily data from %s", file_path)

    # TODO: Implement file parsing logic
    # - Parse ticker, trade_date, close_price / yield_rate
    # - Handle duplicates via ON DUPLICATE KEY UPDATE
    raise NotImplementedError("Implement per vendor file format")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True, help="Path to raw data file")
    args = parser.parse_args()
    load(args.file)
