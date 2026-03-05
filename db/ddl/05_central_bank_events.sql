-- ============================================================
-- Layer 1d: central_bank_events -- 央行政策事件（事件驱动，非时序）
-- 覆盖：PBOC_RATE_EVENT / FOMC_RATE_EVENT / PBOC_OMO
-- ============================================================
USE robo_advisor;

CREATE TABLE IF NOT EXISTS central_bank_events (
    id               INT           NOT NULL AUTO_INCREMENT,
    event_date       DATE          NOT NULL  COMMENT '决议/操作日期',
    institution      ENUM('PBOC','FOMC','OTHER') NOT NULL,
    event_type       VARCHAR(60)   NOT NULL  COMMENT '如 LPR调降/降准/逆回购净投放',
    change_bp        DECIMAL(8,2)  NULL      COMMENT '变动幅度（基点），降息为负值',
    prior_rate       DECIMAL(8,4)  NULL      COMMENT '调整前利率(%)',
    new_rate         DECIMAL(8,4)  NULL      COMMENT '调整后利率(%)',
    net_injection    DECIMAL(16,2) NULL      COMMENT 'OMO净投放量（亿元）',
    market_expect    VARCHAR(120)  NULL      COMMENT '市场预期（如有）',
    raw_text         TEXT          NULL      COMMENT '原始公告摘要',
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_event_date  (event_date),
    INDEX idx_institution (institution)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='央行政策事件日历 — Layer 1d';
