IsChinese                 = Locale.GetCurrentLanguage().Type == 'zh_Hans_CN' or
    Locale.GetCurrentLanguage().Type == 'zh_Hant_HK'
DistrictWonderIndex       = GameInfo.Districts['DISTRICT_WONDER'].Index

MODIFIER_MAX              = 100
MODIFIER_IN_COMING        = "MODIFIER_TRM_ADD_YIELD_FOR_IN_COMING_TRADE_CITY_%s%d"
MODIFIER_OUT_GOING        = "MODIFIER_TRM_ADD_YIELD_FOR_OUT_GOING_TRADE_CITY_%s%d"
MODIFIER_DECIMAL          = "MODIFIER_TRM_ADD_YIELD_FOR_TRADE_CITY_DECIMAL_%s%0.1f"
YIELD_PREFIX              = "YIELD_"

MetalTableNumber          = {}
MetalTableNumber.__index  = function()
    return 0
end
MetalTableString          = {}
MetalTableString.__index  = function()
    return ''
end

TRM_OperationType         = {}
TRM_OperationType.APPLY   = 1
TRM_OperationType.UPDATE  = 2
TRM_OperationType.DESTROY = 4

CalculationClassType      = {}
setmetatable(CalculationClassType, MetalTableNumber)
CalculationClassType.NULL          = -1
CalculationClassType.NORMAL        = 0
CalculationClassType.ADJUST_YIELDS = 1

CalculationMultiplierType          = {}
setmetatable(CalculationMultiplierType, MetalTableNumber)
CalculationMultiplierType.DEFAULT = 0  -- Multiplier = 1    采用默认数值 BaseYields
CalculationMultiplierType.EACH    = 1  -- Multiplier = itemAmount   每个加成资源/建筑/改良等*BaseYields
CalculationMultiplierType.EXIST   = 2  -- Multiplier = itemAmount > 0 and 0 or 1    存在即生效 BaseYields
CalculationMultiplierType.LEVEL   = 4  -- Multiplier = itemAmount % CoefficientX 取等级* BaseYields
CalculationMultiplierType.TIME    = 8  -- Multiplier = x 倍数* BaseYields
CalculationMultiplierType.COMPARE = 16 -- Multiplier = y 满足条件时获得倍数* BaseYields

-- =========================================
-- CalculationRange
-- =========================================

-- 贸易路线加成 限定检测范围
CalculationRangeType              = {}
setmetatable(CalculationRangeType, MetalTableNumber)
CalculationRangeType.NULL             = -1
CalculationRangeType.CITY             = 1 -- 起终点城市
CalculationRangeType.CITIES           = 2 -- 起终点玩家所有城市
CalculationRangeType.PLAYER           = 3 -- 起终点玩家
-- 城市领土中3个单元格以内的每个加成资源将为从此城市发源的  贸易路线+2  金币。必须建在与商业中心区域（要求拥有市场）和  牛资源相邻的单元格上。

CalculationRangeType.NEED_PLAYER_ID   = 100 -- 非限定玩家ID
CalculationRangeType.TRADE_ROUTE_PATH = 101 -- 贸易路线
CalculationRangeType.STATE            = 102 -- 终点城邦

-- =========================================
-- Calculation Item
-- =========================================

-- 限定检测目标
CalculationItemType                   = {}
setmetatable(CalculationItemType, MetalTableNumber)
CalculationItemType.NULL                    = -1
CalculationItemType.MATCH_PLOTS             = 0
CalculationItemType.PLOT                    = 1 -- 单元格
CalculationItemType.RESOURCE                = 2 -- 资源
CalculationItemType.TERRAIN                 = 3 -- 地形
CalculationItemType.IMPROVEMENT             = 4 -- 改良设施
CalculationItemType.DISTRICT                = 5 -- 区域
CalculationItemType.BUILDING                = 6 -- 建筑
CalculationItemType.WONDER                  = 7 -- 奇观（区域）
CalculationItemType.FEATURE                 = 8 -- 地貌
CalculationItemType.GREAT_WORK              = 15 -- 巨作
CalculationItemType.MATCH_PLOT_COUNT        = 50
CalculationItemType.TRADING_POST            = 51 -- 贸易站
CalculationItemType.CONTINENT               = 52 -- 异大陆
CalculationItemType.RIVER                   = 53 -- 河流
CalculationItemType.TRADE_C1TIES            = 54 -- 贸易城市
CalculationItemType.TRADE_CIVILIZATIONS     = 55 -- 贸易城市

CalculationItemType.SPEC1AL_DATA            = 100
CalculationItemType.GREAT_PEOPLE_POINT      = 101 -- 伟人点数
CalculationItemType.ENVOY                   = 102 -- 终点城邦的使者数量
CalculationItemType.TRIBUTARY               = 103 -- 玩家附属城邦
CalculationItemType.POPULATION              = 104 -- 人口
CalculationItemType.RELATIONSHIP            = 105 -- 关系
CalculationItemType.UNLOCK_TECH             = 106 -- 解锁科技
CalculationItemType.UNLOCK_CIVIC            = 107 -- 解锁市政
CalculationItemType.AMENITIES               = 108 -- 宜居度
CalculationItemType.FOLLOWER_OF_RELIGION    = 109 -- 信徒数量
-- CalculationItemType.FOLLOWER_OF_DOMAIN_RELIGION = 110 -- 信徒数量（仅限本城市的主流宗教）
-- CalculationItemType.FOLLOWER_OF_FOUNDED_RELIGION = 111 -- 信徒数量（仅限本城市所建宗教）

CalculationItemType.COUNTERS                = 150
CalculationItemType.FOUNDED_NATURAL_W0NDERS = 151 -- 已发现自然奇观数量
CalculationItemType.UNITS_KILLED            = 152 -- 击杀单位数量
CalculationItemType.TRADE_R0UTE             = 153 -- 贸易路线

CalculationItemName                         = {}
setmetatable(CalculationItemName, MetalTableString)
CalculationItemName[CalculationItemType.NULL]                    = 'DEFAULT'
CalculationItemName[CalculationItemType.RESOURCE]                = 'LOC_RESOURCE_NAME'
CalculationItemName[CalculationItemType.IMPROVEMENT]             = 'LOC_TECH_FILTER_IMPROVEMENTS'
CalculationItemName[CalculationItemType.BUILDING]                = 'LOC_HUD_CITY_BUILDINGS'
CalculationItemName[CalculationItemType.WONDER]                  = 'LOC_CATEGORY_WONDER_NAME'
CalculationItemName[CalculationItemType.DISTRICT]                = 'LOC_CIVICS_KEY_DISTRICT'
CalculationItemName[CalculationItemType.POPULATION]              = 'LOC_PRODUCTION_MANAGER_FILTER_POPULATION'
CalculationItemName[CalculationItemType.PLOT]                    = 'LOC_PLOT_NAME'
CalculationItemName[CalculationItemType.TRADING_POST]            = 'LOC_HUD_CITY_TRADING_POSTS'
CalculationItemName[CalculationItemType.TERRAIN]                 = 'LOC_WORLDBUILDER_ATTRIBUTE_TERRAIN'
CalculationItemName[CalculationItemType.FEATURE]                 = 'LOC_WORLDBUILDER_PLACEMENT_MODE_FEATURES'
CalculationItemName[CalculationItemType.GREAT_PEOPLE_POINT]      = 'LOC_GOVT_ACCUMULATED_BONUS_BRIEF_CLASSREP'
CalculationItemName[CalculationItemType.ENVOY]                   = 'LOC_CITY_STATES_ENVOYS'
CalculationItemName[CalculationItemType.TRIBUTARY]               = 'LOC_TRIBUTARY_NAME'
CalculationItemName[CalculationItemType.GREAT_WORK]              = 'LOC_GREAT_WORKS'
CalculationItemName[CalculationItemType.CONTINENT]               = 'LOC_HUD_CONTINENT_LENS'
CalculationItemName[CalculationItemType.RIVER]                   = 'LOC_TOOLTIP_RIVER'
CalculationItemName[CalculationItemType.FOUNDED_NATURAL_W0NDERS] = 'LOC_HOF_GRAPH_PLAYER_NATURAL_WONDERS'
CalculationItemName[CalculationItemType.UNITS_KILLED]            = 'LOC_HOF_GRAPH_PLAYER_UNITS_KILLED'
CalculationItemName[CalculationItemType.TRADE_R0UTE]             = 'LOC_TOP_PANEL_TRADE_ROUTES'
CalculationItemName[CalculationItemType.TRADE_C1TIES]            = 'LOC_CITY_NAME_BLANK'
CalculationItemName[CalculationItemType.RELATIONSHIP]            = 'LOC_PEDIA_CONCEPTS_PAGE_DIPLO_12_CHAPTER_CONTENT_TITLE'
CalculationItemName[CalculationItemType.UNLOCK_TECH]             = 'LOC_GOSSIPDESC_RESEARCH_TECH'
CalculationItemName[CalculationItemType.UNLOCK_CIVIC]            = 'LOC_GOSSIPDESC_CULTURVATE_CIVIC'
CalculationItemName[CalculationItemType.AMENITIES]               = 'LOC_TECH_FILTER_AMENITIES'
CalculationItemName[CalculationItemType.FOLLOWER_OF_RELIGION]    = 'LOC_HOF_GRAPH_RELIGION_FOLLOWERS'



DescriptionIcon = {}
setmetatable(DescriptionIcon, MetalTableString)
DescriptionIcon[CalculationItemType.NULL]                    = ''
DescriptionIcon[CalculationItemType.RESOURCE]                = ' [ICON_TRM_RESOURCE] '
DescriptionIcon[CalculationItemType.IMPROVEMENT]             = ' [ICON_Charges] '
DescriptionIcon[CalculationItemType.BUILDING]                = ' [ICON_Buildings] '
DescriptionIcon[CalculationItemType.WONDER]                  = ' [ICON_TRM_WONDER] '
DescriptionIcon[CalculationItemType.DISTRICT]                = ' [ICON_District] '
DescriptionIcon[CalculationItemType.POPULATION]              = ' [ICON_Citizen] '
DescriptionIcon[CalculationItemType.TERRAIN]                 = ' [ICON_Terrain] '
DescriptionIcon[CalculationItemType.TRADING_POST]            = ' [ICON_TradingPost] '
DescriptionIcon[CalculationItemType.FEATURE]                 = ' [ICON_TRM_FEATURE] '
DescriptionIcon[CalculationItemType.GREAT_PEOPLE_POINT]      = ' [ICON_GreatPerson] '
DescriptionIcon[CalculationItemType.ENVOY]                   = ' [ICON_Envoy] '
DescriptionIcon[CalculationItemType.TRIBUTARY]               = ' [ICON_Envoy] '
DescriptionIcon[CalculationItemType.GREAT_WORK]              = ' [ICON_GreatWork_WRITING] '
DescriptionIcon[CalculationItemType.CONTINENT]               = ' [ICON_TRM_CONTINENT] '
DescriptionIcon[CalculationItemType.RIVER]                   = ' [ICON_TRM_RIVER] '
DescriptionIcon[CalculationItemType.FOUNDED_NATURAL_W0NDERS] = ' [ICON_TRM_WONDER] '
DescriptionIcon[CalculationItemType.UNITS_KILLED]            = ' [ICON_Unit] '
DescriptionIcon[CalculationItemType.TRADE_R0UTE]             = ' [ICON_TradeRoute] '
DescriptionIcon[CalculationItemType.TRADE_C1TIES]            = ' [ICON_Government] '
DescriptionIcon[CalculationItemType.RELATIONSHIP]            = ' [ICON_TRM_RELATIONSHIP] '

DescriptionIcon[CalculationItemType.UNLOCK_TECH]             = ' [ICON_TechBoosted] '
DescriptionIcon[CalculationItemType.UNLOCK_CIVIC]            = ' [ICON_CivicBoosted] '
DescriptionIcon[CalculationItemType.AMENITIES]               = ' [ICON_Amenities] '
DescriptionIcon[CalculationItemType.FOLLOWER_OF_RELIGION]    = ' [ICON_Religion] '
