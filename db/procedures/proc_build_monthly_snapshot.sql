-- ============================================================
-- 存储过程：构建月度宽表快照
-- 调用方式：CALL proc_build_monthly_snapshot('2026-02');
-- 执行时机：每月16日 ETL Step 4
-- ============================================================
USE robo_advisor;

DELIMITER $$

CREATE PROCEDURE proc_build_monthly_snapshot(IN p_month CHAR(7))
BEGIN
    -- 删除已有的当月快照（幂等）
    DELETE FROM macro_snapshot_monthly WHERE snap_month = p_month;

    INSERT INTO macro_snapshot_monthly (
        snap_month,
        cpi_yoy, ppi_yoy, m2_yoy, tsf_stock_yoy,
        lpr_1y, yield_10y, dr007, credit_spread_aa,
        pmi_manu, pmi_serv, industry_yoy, fx_cny_mid,
        retail_sales_yoy, export_yoy, urban_unemployment, xauusd_avg,
        spx_eom, hs300_eom, vix_avg, northbound_net_sum, brent_avg,
        pboc_rate_event, fomc_rate_event,
        epu_cn, epu_us, gpr
    )
    SELECT
        p_month AS snap_month,

        -- 宏观核心 (从 macro_monthly 窄表 pivot)
        MAX(CASE WHEN m.indicator_code = 'CPI_YOY'          THEN m.value END) AS cpi_yoy,
        MAX(CASE WHEN m.indicator_code = 'PPI_YOY'          THEN m.value END) AS ppi_yoy,
        MAX(CASE WHEN m.indicator_code = 'M2_YOY'           THEN m.value END) AS m2_yoy,
        MAX(CASE WHEN m.indicator_code = 'TSF_STOCK_YOY'    THEN m.value END) AS tsf_stock_yoy,
        MAX(CASE WHEN m.indicator_code = 'LPR_1Y'           THEN m.value END) AS lpr_1y,
        MAX(CASE WHEN m.indicator_code = 'YIELD_10Y'        THEN m.value END) AS yield_10y,
        MAX(CASE WHEN m.indicator_code = 'DR007'            THEN m.value END) AS dr007,
        MAX(CASE WHEN m.indicator_code = 'CREDIT_SPREAD_AA' THEN m.value END) AS credit_spread_aa,
        MAX(CASE WHEN m.indicator_code = 'PMI_MANU'         THEN m.value END) AS pmi_manu,
        MAX(CASE WHEN m.indicator_code = 'PMI_SERV'         THEN m.value END) AS pmi_serv,
        MAX(CASE WHEN m.indicator_code = 'INDUSTRY_YOY'     THEN m.value END) AS industry_yoy,
        MAX(CASE WHEN m.indicator_code = 'FX_CNY_MID'       THEN m.value END) AS fx_cny_mid,

        -- 宏观非核心
        MAX(CASE WHEN m.indicator_code = 'RETAIL_SALES_YOY'  THEN m.value END) AS retail_sales_yoy,
        MAX(CASE WHEN m.indicator_code = 'EXPORT_YOY'        THEN m.value END) AS export_yoy,
        MAX(CASE WHEN m.indicator_code = 'URBAN_UNEMPLOYMENT' THEN m.value END) AS urban_unemployment,

        -- 行情月度聚合 (从 market_daily 聚合)
        (SELECT AVG(md.close_price) FROM market_daily md
         WHERE md.ticker = 'XAUUSD'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS xauusd_avg,

        (SELECT md.close_price FROM market_daily md
         WHERE md.ticker = 'SPX'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
         ORDER BY md.trade_date DESC LIMIT 1
        ) AS spx_eom,

        (SELECT md.close_price FROM market_daily md
         WHERE md.ticker = '000300.SH'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
         ORDER BY md.trade_date DESC LIMIT 1
        ) AS hs300_eom,

        (SELECT AVG(md.close_price) FROM market_daily md
         WHERE md.ticker = 'VIX'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS vix_avg,

        (SELECT SUM(md.net_flow) FROM market_daily md
         WHERE md.ticker = 'NORTHBOUND_NET'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS northbound_net_sum,

        (SELECT AVG(md.close_price) FROM market_daily md
         WHERE md.ticker = 'BRENT'
           AND md.trade_date >= CONCAT(p_month, '-01')
           AND md.trade_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS brent_avg,

        -- 央行事件文本拼接
        (SELECT GROUP_CONCAT(CONCAT(cb.event_type, '(', cb.change_bp, 'bp)') SEPARATOR '; ')
         FROM central_bank_events cb
         WHERE cb.institution = 'PBOC'
           AND cb.event_date >= CONCAT(p_month, '-01')
           AND cb.event_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS pboc_rate_event,

        (SELECT GROUP_CONCAT(CONCAT(cb.event_type, '(', cb.change_bp, 'bp)') SEPARATOR '; ')
         FROM central_bank_events cb
         WHERE cb.institution = 'FOMC'
           AND cb.event_date >= CONCAT(p_month, '-01')
           AND cb.event_date < DATE_ADD(CONCAT(p_month, '-01'), INTERVAL 1 MONTH)
        ) AS fomc_rate_event,

        -- 新闻政策指数
        MAX(CASE WHEN m.indicator_code = 'EPU_CN' THEN m.value END) AS epu_cn,
        MAX(CASE WHEN m.indicator_code = 'EPU_US' THEN m.value END) AS epu_us,
        MAX(CASE WHEN m.indicator_code = 'GPR'    THEN m.value END) AS gpr

    FROM macro_monthly m
    WHERE m.stat_month = p_month
      AND m.data_version = (
          SELECT MAX(m2.data_version)
          FROM macro_monthly m2
          WHERE m2.indicator_code = m.indicator_code
            AND m2.stat_month = m.stat_month
      );
END$$

DELIMITER ;
