-- ============================================================
-- Layer 2: macro_snapshot_monthly -- 月度宽表快照
-- 用途：LLM prompt 输入 / Markdown 月报渲染
-- 来源：每月16日由存储过程从 Layer 1 聚合生成
-- 查询：SELECT * WHERE snap_month='2026-02' -> 1行，直接用
-- ============================================================
USE robo_advisor;

CREATE TABLE IF NOT EXISTS macro_snapshot_monthly (
    snap_month              CHAR(7)        NOT NULL  COMMENT '快照月份 YYYY-MM',

    -- 宏观核心指标
    cpi_yoy                 DECIMAL(8,4)   NULL      COMMENT 'CPI同比(%)',
    ppi_yoy                 DECIMAL(8,4)   NULL      COMMENT 'PPI同比(%)',
    m2_yoy                  DECIMAL(8,4)   NULL      COMMENT 'M2同比(%)',
    tsf_stock_yoy           DECIMAL(8,4)   NULL      COMMENT '社融存量同比(%)',
    lpr_1y                  DECIMAL(8,4)   NULL      COMMENT '1年期LPR(%)',
    yield_10y               DECIMAL(8,4)   NULL      COMMENT '10年国债收益率月均(%)',
    dr007                   DECIMAL(8,4)   NULL      COMMENT 'DR007月均(%)',
    credit_spread_aa        DECIMAL(8,4)   NULL      COMMENT 'AA信用利差月均(bp)',
    pmi_manu                DECIMAL(8,4)   NULL      COMMENT '制造业PMI',
    pmi_serv                DECIMAL(8,4)   NULL      COMMENT '非制造业PMI',
    industry_yoy            DECIMAL(8,4)   NULL      COMMENT '工业增加值同比(%)',
    fx_cny_mid              DECIMAL(8,4)   NULL      COMMENT '人民币中间价月均',

    -- 宏观非核心指标
    retail_sales_yoy        DECIMAL(8,4)   NULL      COMMENT '社零同比(%)',
    export_yoy              DECIMAL(8,4)   NULL      COMMENT '出口累计同比(%)',
    urban_unemployment      DECIMAL(8,4)   NULL      COMMENT '城镇调查失业率(%)',
    xauusd_avg              DECIMAL(10,4)  NULL      COMMENT '黄金月均价(USD/oz)',

    -- 行情月度聚合
    spx_eom                 DECIMAL(12,4)  NULL      COMMENT '标普500月末收盘',
    hs300_eom               DECIMAL(12,4)  NULL      COMMENT '沪深300月末收盘',
    vix_avg                 DECIMAL(8,4)   NULL      COMMENT 'VIX月均',
    northbound_net_sum      DECIMAL(16,4)  NULL      COMMENT '北向资金月度净流入(亿元)',
    brent_avg               DECIMAL(10,4)  NULL      COMMENT '布伦特原油月均(USD/桶)',

    -- 政策事件文本摘要
    pboc_rate_event         VARCHAR(200)   NULL      COMMENT '当月PBOC利率/RRR事件',
    fomc_rate_event         VARCHAR(200)   NULL      COMMENT '当月FOMC决议摘要',

    -- 新闻政策指数
    epu_cn                  DECIMAL(10,4)  NULL      COMMENT '中国EPU指数',
    epu_us                  DECIMAL(10,4)  NULL      COMMENT '美国EPU指数',
    gpr                     DECIMAL(10,4)  NULL      COMMENT '地缘政治风险指数',

    generated_at            TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
                                           COMMENT '聚合生成时间',
    PRIMARY KEY (snap_month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='月度宽表快照，供LLM/报告直接消费 — Layer 2';
