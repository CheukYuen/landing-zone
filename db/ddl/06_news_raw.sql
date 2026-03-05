-- ============================================================
-- Layer 1e: news_raw -- 原始新闻文本（大表，为LLM RAG预留）
-- 覆盖：Wind资讯/东方财富/同花顺（WIND_NEWS）
-- 设计要点：FULLTEXT INDEX 支持全文检索
-- ============================================================
USE robo_advisor;

CREATE TABLE IF NOT EXISTS news_raw (
    id               BIGINT        NOT NULL AUTO_INCREMENT,
    pub_time         DATETIME      NOT NULL  COMMENT '发布时间',
    source           VARCHAR(40)   NOT NULL  COMMENT 'Wind/东方财富/同花顺',
    title            VARCHAR(255)  NOT NULL,
    body             MEDIUMTEXT    NULL      COMMENT '正文全文',
    tags_industry    VARCHAR(255)  NULL      COMMENT '行业标签（逗号分隔）',
    tags_company     VARCHAR(255)  NULL,
    tags_event       VARCHAR(120)  NULL      COMMENT '事件类型标签',
    sentiment_score  DECIMAL(5,4)  NULL      COMMENT '情绪得分[-1,1]',
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_pub_time             (pub_time),
    INDEX idx_source               (source),
    FULLTEXT INDEX ft_title_body   (title, body)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='原始新闻文本 — Layer 1e';
