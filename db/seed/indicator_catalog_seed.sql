-- ============================================================
-- indicator_catalog 初始化种子数据
-- 来源：数据采购清单 v1.2（93个指标，5大类）
-- 使用：mysql -u root -p robo_advisor < indicator_catalog_seed.sql
-- ============================================================
USE robo_advisor;

INSERT INTO indicator_catalog
    (indicator_code, indicator_name, category, data_source, frequency, value_type, unit, history_window, target_table, is_active, notes)
VALUES
-- === 宏观核心 (macro_core) ===
('CPI_YOY',          '居民消费价格指数同比',              'macro_core', 'NBS',      'monthly', 'yoy',   '%',    '近10年', 'macro_monthly', 1, '通胀核心指标，上升通常对应紧缩预期，影响债券定价'),
('CPI_MOM',          '居民消费价格指数环比',              'macro_core', 'NBS',      'monthly', 'mom',   '%',    '近10年', 'macro_monthly', 1, '环比变化反映短期通胀压力'),
('PPI_YOY',          '工业生产者出厂价格指数同比',         'macro_core', 'NBS',      'monthly', 'yoy',   '%',    '近10年', 'macro_monthly', 1, '工业品通缩/通胀指标，影响上游企业利润'),
('M2_YOY',           'M2广义货币供应量同比',              'macro_core', 'PBOC',     'monthly', 'yoy',   '%',    '近10年', 'macro_monthly', 1, '货币政策松紧核心指标'),
('TSF_STOCK_YOY',    '社会融资规模存量同比',              'macro_core', 'PBOC',     'monthly', 'yoy',   '%',    '近10年', 'macro_monthly', 1, '实体经济信用扩张速度'),
('LPR_1Y',           '1年期贷款市场报价利率',             'macro_core', 'PBOC',     'monthly', 'rate',  '%',    '近5年',  'macro_monthly', 1, '实际贷款定价基准，央行政策利率传导终端'),
('YIELD_10Y',        '10年期国债到期收益率',              'macro_core', 'CCDC',     'daily',   'rate',  '%',    '近10年', 'macro_monthly', 1, '无风险利率基准，资产定价锚'),
('DR007',            '存款类机构7天质押式回购加权利率',     'macro_core', 'CFETS',   'daily',   'level', '%',    '近10年', 'macro_monthly', 1, '比SHIBOR更真实地反映银行间流动性松紧'),
('CREDIT_SPREAD_AA', 'AA级企业债信用利差',                'macro_core', 'Wind',     'daily',   'level', 'bp',   '近10年', 'macro_monthly', 1, '信用风险溢价指标，利差走扩反映风险偏好下降'),
('PMI_MANU',         '制造业采购经理指数',                'macro_core', 'NBS',      'monthly', 'index', '点',   '近10年', 'macro_monthly', 1, '>50扩张，<50收缩，领先经济指标'),
('PMI_SERV',         '非制造业商务活动指数',              'macro_core', 'NBS',      'monthly', 'index', '点',   '近10年', 'macro_monthly', 1, '服务业景气度'),
('INDUSTRY_YOY',     '规模以上工业增加值同比',             'macro_core', 'NBS',      'monthly', 'yoy',   '%',    '近10年', 'macro_monthly', 1, '实体经济产出核心指标'),
('FX_CNY_MID',       '人民币兑美元中间价',                'macro_core', 'PBOC',     'daily',   'level', 'CNY/USD', '近10年', 'macro_monthly', 1, '汇率政策信号，影响跨境资金流'),
('SHIBOR_3M',        '3个月上海银行间同业拆放利率',        'macro_core', 'CFETS',   'daily',   'rate',  '%',    '近10年', 'macro_monthly', 1, '中期资金成本参考'),

-- === 宏观非核心 (macro_secondary) ===
('RETAIL_SALES_YOY', '社会消费品零售总额同比',             'macro_secondary', 'NBS',  'monthly', 'yoy', '%',   '近10年', 'macro_monthly', 1, '内需消费指标'),
('FAI_YOY',          '固定资产投资累计同比',               'macro_secondary', 'NBS',  'monthly', 'cumulative_yoy', '%', '近10年', 'macro_monthly', 1, '投资端景气度'),
('EXPORT_YOY',       '出口金额累计同比',                   'macro_secondary', 'GAC',  'monthly', 'cumulative_yoy', '%', '近10年', 'macro_monthly', 1, '外需指标'),
('IMPORT_YOY',       '进口金额累计同比',                   'macro_secondary', 'GAC',  'monthly', 'cumulative_yoy', '%', '近10年', 'macro_monthly', 1, '内需+大宗商品需求'),
('URBAN_UNEMPLOYMENT','城镇调查失业率',                    'macro_secondary', 'NBS',  'monthly', 'level', '%',  '近5年',  'macro_monthly', 1, '就业市场松紧'),
('REAL_ESTATE_INV_YOY','房地产开发投资累计同比',           'macro_secondary', 'NBS',  'monthly', 'cumulative_yoy', '%', '近10年', 'macro_monthly', 1, '地产链景气度'),
('M1_YOY',           'M1狭义货币供应量同比',               'macro_secondary', 'PBOC', 'monthly', 'yoy', '%',   '近10年', 'macro_monthly', 1, 'M1-M2剪刀差反映企业活期存款意愿'),
('NEW_LOANS',        '新增人民币贷款',                     'macro_secondary', 'PBOC', 'monthly', 'level', '亿元', '近10年', 'macro_monthly', 1, '信贷投放量'),
('TSF_MONTHLY',      '社会融资规模增量（当月）',            'macro_secondary', 'PBOC', 'monthly', 'level', '亿元', '近10年', 'macro_monthly', 1, '当月融资规模'),
('GDP_YOY',          '国内生产总值同比',                   'macro_secondary', 'NBS',  'quarterly', 'yoy', '%', '近10年', 'macro_monthly', 1, '季频，经济增长总量指标'),
('CPI_FOOD_YOY',     '食品价格同比',                      'macro_secondary', 'NBS',  'monthly', 'yoy', '%',   '近10年', 'macro_monthly', 1, 'CPI结构拆分，猪周期观察'),
('CPI_NONFOOD_YOY',  '非食品价格同比',                    'macro_secondary', 'NBS',  'monthly', 'yoy', '%',   '近10年', 'macro_monthly', 1, '核心通胀代理'),
('LPR_5Y',           '5年期以上LPR',                      'macro_secondary', 'PBOC', 'monthly', 'rate', '%',  '近5年',  'macro_monthly', 1, '房贷利率基准'),
('FCI',              '金融条件指数',                       'macro_secondary', 'Wind', 'monthly', 'index', '点', '近5年', 'macro_monthly', 1, '综合金融松紧度'),

-- === 行情数据 (market) ===
('SPX',              '标普500指数',       'market', 'Yahoo/Wind', 'daily', 'index', '点',      '近10年', 'market_daily', 1, '美股大盘基准'),
('IXIC',             '纳斯达克综合指数',   'market', 'Yahoo/Wind', 'daily', 'index', '点',      '近10年', 'market_daily', 1, '美股科技股基准'),
('HSI',              '恒生指数',           'market', 'Yahoo/Wind', 'daily', 'index', '点',      '近10年', 'market_daily', 1, '港股基准'),
('000001.SH',        '上证综指',           'market', 'Wind',       'daily', 'index', '点',      '近10年', 'market_daily', 1, 'A股大盘代表'),
('000300.SH',        '沪深300指数',        'market', 'Wind',       'daily', 'index', '点',      '近10年', 'market_daily', 1, 'A股核心宽基'),
('000905.SH',        '中证500指数',        'market', 'Wind',       'daily', 'index', '点',      '近10年', 'market_daily', 1, 'A股中盘代表'),
('VIX',              'CBOE波动率指数',     'market', 'CBOE',       'daily', 'index', '点',      '近10年', 'market_daily', 1, '全球恐慌指数，>30通常对应市场显著下跌'),
('XAUUSD',           '黄金现货价格',       'market', 'Yahoo/Wind', 'daily', 'level', 'USD/oz',  '近10年', 'market_daily', 1, '避险资产+通胀对冲'),
('BRENT',            '布伦特原油期货',     'market', 'Yahoo/Wind', 'daily', 'level', 'USD/桶',  '近10年', 'market_daily', 1, '大宗商品风向标，影响PPI'),
('NORTHBOUND_NET',   '北向资金净流入',     'market', 'Wind',       'daily', 'level', '亿元',    '近5年',  'market_daily', 1, '外资情绪代理'),
('DXY',              '美元指数',           'market', 'Yahoo/Wind', 'daily', 'index', '点',      '近10年', 'market_daily', 1, '美元强弱，影响新兴市场资金流'),
('US10Y',            '美国10年期国债收益率','market', 'Yahoo/Wind', 'daily', 'rate',  '%',       '近10年', 'market_daily', 1, '全球无风险利率锚'),
('USDCNY',           '美元兑人民币即期汇率','market', 'Wind',       'daily', 'level', 'CNY/USD', '近10年', 'market_daily', 1, '即期汇率，区别于中间价'),

-- === 量化建模 (quant) ===
('510300',           '沪深300ETF',         'quant', 'Wind', 'daily', 'level', 'CNY', '近10年', 'quant_daily', 1, '权益类核心资产'),
('518880',           '黄金ETF',            'quant', 'Wind', 'daily', 'level', 'CNY', '近10年', 'quant_daily', 1, '避险配置资产'),
('NHCI',             '南华商品指数',        'quant', 'Wind', 'daily', 'index', '点',  '近10年', 'quant_daily', 1, '商品类资产代理'),
('SHIBOR_1W',        '1周SHIBOR',          'quant', 'CFETS','daily', 'rate',  '%',   '近10年', 'quant_daily', 1, '无风险利率代理（短端）'),
('CN_BOND_10Y',      '中国10年国债收盘价',  'quant', 'Wind', 'daily', 'level', 'CNY', '近10年', 'quant_daily', 1, '债券类资产代理'),

-- === 新闻政策 (news_policy) ===
('EPU_CN',           '中国经济政策不确定性指数', 'news_policy', 'EPU官网',   'monthly', 'index', '点', '近10年', 'macro_monthly', 1, '政策不确定性量化指标'),
('EPU_US',           '美国经济政策不确定性指数', 'news_policy', 'EPU官网',   'monthly', 'index', '点', '近10年', 'macro_monthly', 1, '美国政策不确定性'),
('GPR',              '地缘政治风险指数',         'news_policy', 'GPR官网',   'monthly', 'index', '点', '近10年', 'macro_monthly', 1, '地缘政治冲突量化指标'),
('PBOC_RATE_EVENT',  'PBOC利率/准备金率事件',    'news_policy', 'PBOC公告',  'event',   'level', NULL, '近10年', 'central_bank_events', 1, '央行利率调整和准备金率变动'),
('FOMC_RATE_EVENT',  'FOMC利率决议事件',         'news_policy', 'Fed公告',   'event',   'level', NULL, '近10年', 'central_bank_events', 1, '美联储利率决议'),
('PBOC_OMO',         'PBOC公开市场操作',         'news_policy', 'PBOC公告',  'event',   'level', '亿元', '近5年', 'central_bank_events', 1, '逆回购/MLF净投放'),
('WIND_NEWS',        'Wind资讯/东方财富/同花顺', 'news_policy', 'Wind/东方财富', 'daily', 'level', NULL, '近3年', 'news_raw', 1, '原始新闻文本，供RAG检索');
