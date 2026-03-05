-- ============================================================
-- Layer 1c: quant_daily -- 量化建模原始日频（窄表）
-- 覆盖：5个原始采购指标（四资产原始 + 无风险利率）
-- 现阶段：指标未稳定，用窄表 + Python pivot 封装
-- 稳定后：迁移至宽表 asset_returns_daily
-- ============================================================
USE robo_advisor;

CREATE TABLE IF NOT EXISTS quant_daily (
    id               BIGINT        NOT NULL AUTO_INCREMENT,
    ticker           VARCHAR(30)   NOT NULL  COMMENT '如 510300/518880/SHIBOR_1W',
    trade_date       DATE          NOT NULL,
    close_price      DECIMAL(18,6) NULL      COMMENT 'ETF/指数收盘价',
    yield_rate       DECIMAL(10,6) NULL      COMMENT '利率类专用字段（年化%）',
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_ticker_date (ticker, trade_date),
    INDEX idx_trade_date      (trade_date),
    INDEX idx_ticker          (ticker)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='量化建模原始日频数据 — Layer 1c（采购稳定后迁移宽表）';
