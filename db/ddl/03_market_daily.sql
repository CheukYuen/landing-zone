-- ============================================================
-- Layer 1b: market_daily -- 行情日频时序（窄表）
-- 覆盖：15个 ticker（股指/波动率/资金流向/大宗商品）
-- ============================================================
USE robo_advisor;

CREATE TABLE IF NOT EXISTS market_daily (
    id               BIGINT        NOT NULL AUTO_INCREMENT,
    ticker           VARCHAR(30)   NOT NULL  COMMENT '如 SPX / 000001.SH / VIX',
    trade_date       DATE          NOT NULL  COMMENT '交易日',
    close_price      DECIMAL(18,6) NULL      COMMENT '收盘价/指数点位',
    volume           DECIMAL(20,2) NULL      COMMENT '成交量（如有）',
    net_flow         DECIMAL(18,4) NULL      COMMENT '净流入额，仅资金流向类（亿元）',
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_ticker_date (ticker, trade_date),
    INDEX idx_trade_date      (trade_date),
    INDEX idx_ticker          (ticker)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='行情日频时序数据 — Layer 1b';
