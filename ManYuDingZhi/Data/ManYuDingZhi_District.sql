-- ManYuDingZhi_District
-- Author: SFDH100
-- DateCreated: 2023/9/5 20:59:09
--当前为 167 行
--------------------------------------------------------------
UPDATE District_CitizenYieldChanges SET YieldChange = 1 	WHERE YieldType IS 'YIELD_SCIENCE' AND DistrictType IS 'DISTRICT_CAMPUS';
UPDATE District_CitizenYieldChanges SET YieldChange = 1		WHERE YieldType IS 'YIELD_CULTURE' AND DistrictType IS 'DISTRICT_THEATER';
UPDATE District_CitizenYieldChanges SET YieldChange = 1		WHERE YieldType IS 'YIELD_FAITH' AND DistrictType IS 'DISTRICT_HOLY_SITE';
UPDATE District_CitizenYieldChanges SET YieldChange = 2		WHERE YieldType IS 'YIELD_GOLD' AND DistrictType IN ('DISTRICT_COMMERCIAL_HUB','DISTRICT_HARBOR','DISTRICT_ENCAMPMENT');
UPDATE District_CitizenYieldChanges SET YieldChange = 1		WHERE YieldType IS 'YIELD_PRODUCTION' AND DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE';
UPDATE District_CitizenYieldChanges SET YieldChange = 2		WHERE YieldType IS 'YIELD_PRODUCTION' AND DistrictType IS 'DISTRICT_ENCAMPMENT';
DELETE FROM District_CitizenYieldChanges WHERE YieldType = 'YIELD_FOOD';
INSERT OR REPLACE INTO District_CitizenYieldChanges (DistrictType,YieldType,YieldChange) VALUES
('DISTRICT_NEIGHBORHOOD',						'YIELD_PRODUCTION',		2),
('DISTRICT_NEIGHBORHOOD',						'YIELD_GOLD',			2),
('DISTRICT_WATER_ENTERTAINMENT_COMPLEX',		'YIELD_GOLD',			2),
('DISTRICT_WATER_ENTERTAINMENT_COMPLEX',		'YIELD_CULTURE',		1),
('DISTRICT_ENTERTAINMENT_COMPLEX',				'YIELD_GOLD',			2),
('DISTRICT_ENTERTAINMENT_COMPLEX',				'YIELD_CULTURE',		1);
INSERT OR REPLACE INTO District_CitizenYieldChanges (DistrictType,YieldType,YieldChange)
SELECT			CivUniqueDistrictType,		'YIELD_FAITH',		1		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HOLY_SITE'
UNION SELECT	CivUniqueDistrictType,		'YIELD_SCIENCE',	1		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_CAMPUS'
UNION SELECT	CivUniqueDistrictType,		'YIELD_CULTURE',	1		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER' OR ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR ReplacesDistrictType IS 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX'
UNION SELECT	CivUniqueDistrictType,		'YIELD_PRODUCTION',	1		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_INDUSTRIAL_ZONE'
UNION SELECT	CivUniqueDistrictType,		'YIELD_PRODUCTION',	2		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD' OR ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT'
UNION SELECT	CivUniqueDistrictType,		'YIELD_GOLD',		2		FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB' OR ReplacesDistrictType IS 'DISTRICT_HARBOR' OR ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT' OR ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD' OR ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR ReplacesDistrictType IS 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX';
INSERT OR REPLACE INTO Building_CitizenYieldChanges (BuildingType,YieldType,YieldChange)
SELECT			BuildingType,		'YIELD_FAITH',		1		FROM Buildings WHERE IsWonder IS 0 AND PrereqDistrict IS 'DISTRICT_HOLY_SITE'
UNION SELECT	BuildingType,		'YIELD_SCIENCE',	1		FROM Buildings WHERE IsWonder IS 0 AND PrereqDistrict IS 'DISTRICT_CAMPUS'
UNION SELECT	BuildingType,		'YIELD_CULTURE',	1		FROM Buildings WHERE IsWonder IS 0 AND PrereqDistrict IS 'DISTRICT_THEATER'
UNION SELECT	BuildingType,		'YIELD_PRODUCTION',	1		FROM Buildings WHERE IsWonder IS 0 AND PrereqDistrict IS 'DISTRICT_INDUSTRIAL_ZONE'
UNION SELECT	BuildingType,		'YIELD_GOLD',		1		FROM Buildings WHERE IsWonder IS 0 AND (PrereqDistrict IS 'DISTRICT_COMMERCIAL_HUB' OR PrereqDistrict IS 'DISTRICT_HARBOR');
UPDATE Districts SET CitizenSlots = 1		WHERE DistrictType IN (SELECT DistrictType FROM District_CitizenYieldChanges);	--所有区域给1专家槽位
DELETE FROM Building_CitizenYieldChanges	WHERE YieldType = 'YIELD_FOOD';
UPDATE Buildings SET CitizenSlots = 1		WHERE BuildingType IN (SELECT BuildingType FROM Building_CitizenYieldChanges) OR (PrereqDistrict IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR PrereqDistrict IS 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' OR PrereqDistrict IS 'DISTRICT_NEIGHBORHOOD');	--所有建筑给1专家槽位
UPDATE Districts SET Entertainment = 0		WHERE DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX';	--娱乐区改成提供1点宜居度
UPDATE Districts SET Entertainment = 3		WHERE DistrictType IS 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX';	--水上乐园改为提供3点宜居度
UPDATE Districts SET Maintenance = 5		WHERE DistrictType IS 'DISTRICT_CANAL' OR DistrictType IS 'DISTRICT_DAM';	--水坝、运河的维护费改为5点
UPDATE Districts SET Maintenance = 2		WHERE DistrictType IS 'DISTRICT_BATH' OR DistrictType IS 'DISTRICT_AQUEDUCT';	--水渠的维护费改为2点
UPDATE Districts SET Maintenance = 5		WHERE DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE';	--工业区的维护费改为5点
UPDATE Districts SET Maintenance = 10		WHERE DistrictType IS 'DISTRICT_SPACEPORT';	--宇航中心的维护费改为10点
UPDATE Districts SET Appeal = 0				WHERE DistrictType IS 'DISTRICT_SPACEPORT';	--宇航中心地基不再给周围的单元格减1魅力
UPDATE Districts SET Appeal = 0				WHERE DistrictType IS 'DISTRICT_AERODROME';	--航空港地基不再给周围的单元格减1魅力
UPDATE Districts SET CitizenSlots = 6		WHERE DistrictType IS 'DISTRICT_NEIGHBORHOOD';	--社区给6专家槽位
UPDATE AppealHousingChanges SET AppealChange = 2		WHERE DistrictType IS 'DISTRICT_NEIGHBORHOOD';	--社区无视魅力给6住房
DELETE FROM District_ValidTerrains			WHERE DistrictType = 'DISTRICT_SPACEPORT' AND (TerrainType IS 'TERRAIN_SNOW' OR TerrainType IS 'TERRAIN_TUNDRA'); --宇航中心不能建造在冻土雪地
UPDATE District_BuildChargeProductions SET PercentProductionPerCharge = 30		WHERE (DistrictType IS 'DISTRICT_CANAL' OR DistrictType IS 'DISTRICT_DAM') AND UnitType IS 'UNIT_MILITARY_ENGINEER';	--建造水坝和运河时可用军事工程师加速，1点使用次数加速30%。
UPDATE District_BuildChargeProductions SET PercentProductionPerCharge = 50		WHERE (DistrictType IS 'DISTRICT_AQUEDUCT' OR DistrictType IS 'DISTRICT_BATH') AND UnitType IS 'UNIT_MILITARY_ENGINEER';	--建造水渠时军事工程师消耗一点数使用次数加速50%。
INSERT OR REPLACE INTO District_BuildChargeProductions (DistrictType,UnitType,PercentProductionPerCharge) VALUES
('DISTRICT_NEIGHBORHOOD',		'UNIT_BUILDER',			20);
INSERT OR REPLACE INTO District_ValidTerrains (DistrictType,TerrainType) VALUES
('DISTRICT_SPACEPORT',		'TERRAIN_GRASS_HILLS'),
('DISTRICT_SPACEPORT',		'TERRAIN_PLAINS_HILLS'),
('DISTRICT_SPACEPORT',		'TERRAIN_DESERT_HILLS');
INSERT OR REPLACE INTO Types (Type,Kind) VALUES
('YIELD_TOKEN',				'KIND_YIELD'),
('YIELD_AMENITY',			'KIND_YIELD');
INSERT OR REPLACE INTO Yields (YieldType,Name,IconString) VALUES
('YIELD_TOKEN',				'LOC_YIELD_TOKEN_NAME',		'[ICON_Envoy]'),
('YIELD_AMENITY',			'LOC_YIELD_AMENITY_NAME',	'[ICON_Amenities]');
INSERT OR REPLACE INTO Adjacency_YieldChanges
(ID,											Description,											YieldType,				YieldChange,		AdjacentWonder,	AdjacentNaturalWonder,		AdjacentRiver,		AdjacentFeature,	AdjacentImprovement,		AdjacentDistrict,					AdjacentResourceClass,		PrereqTech,		ObsoleteTech,	Self) VALUES
('SFDH100_CITY_CENTER_TOKEN',					'LOC_SFDH100_CITY_CENTER_TOKEN',						'YIELD_TOKEN',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			NULL,			0),
('SFDH100_CAMPUS_TOKEN',						'LOC_SFDH100_CAMPUS_TOKEN',								'YIELD_TOKEN',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CAMPUS',					NULL,						NULL,			NULL,			0),
('SFDH100_THEATER_TOKEN',						'LOC_SFDH100_THEATER_TOKEN',							'YIELD_TOKEN',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_THEATER',					NULL,						NULL,			NULL,			0),
('SFDH100_GOVERNMENT_TOKEN',					'LOC_SFDH100_GOVERNMENT_TOKEN',							'YIELD_TOKEN',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_GOVERNMENT',				NULL,						NULL,			NULL,			0),

('SFDH100_CITY_CENTER_AMENITY',					'LOC_SFDH100_CITY_CENTER_AMENITY',						'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			NULL,			0),
('SFDH100_THEATER_AMENITY',						'LOC_SFDH100_THEATER_AMENITY',							'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_THEATER',					NULL,						NULL,			NULL,			0),
('SFDH100_COMMERCIAL_HUB_AMENITY',				'LOC_SFDH100_COMMERCIAL_HUB_AMENITY',					'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_COMMERCIAL_HUB',			NULL,						NULL,			NULL,			0),
('SFDH100_ACROPOLIS_AMENITY',					'LOC_SFDH100_THEATER_AMENITY',							'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_ACROPOLIS',				NULL,						NULL,			NULL,			0),
('SFDH100_DISTRICT_SUGUBA_AMENITY',				'LOC_SFDH100_COMMERCIAL_HUB_AMENITY',					'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_SUGUBA',					NULL,						NULL,			NULL,			0),
('SFDH100_SELF_TOKEN',							'LOC_SFDH100_DISTRICT_SELF_TOKEN',						'YIELD_TOKEN',			1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_AMENITY',						'LOC_SFDH100_DISTRICT_SELF_AMENITY',					'YIELD_AMENITY',		1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_FOOD',							'LOC_SFDH100_DISTRICT_SELF_FOOD',						'YIELD_FOOD',			1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_SCIENCE',						'LOC_SFDH100_DISTRICT_SELF_SCIENCE',					'YIELD_SCIENCE',		1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_CULTURE',						'LOC_SFDH100_DISTRICT_SELF_CULTURE',					'YIELD_CULTURE',		1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_GOLD',							'LOC_SFDH100_DISTRICT_SELF_GOLD',						'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_FAITH',							'LOC_SFDH100_DISTRICT_SELF_FAITH',						'YIELD_FAITH',			1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_SELF_PRODUCTION',						'LOC_SFDH100_DISTRICT_SELF_PRODUCTION',					'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),

('SFDH100_NEIGHBORHOOD_SELF_FOOD',				'LOC_SFDH100_DISTRICT_SELF_FOOD',						'YIELD_FOOD',			2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_NEIGHBORHOOD_SELF_SCIENCE',			'LOC_SFDH100_DISTRICT_SELF_SCIENCE',					'YIELD_SCIENCE',		2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_NEIGHBORHOOD_SELF_CULTURE',			'LOC_SFDH100_DISTRICT_SELF_CULTURE',					'YIELD_CULTURE',		2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_NEIGHBORHOOD_SELF_GOLD',				'LOC_SFDH100_DISTRICT_SELF_GOLD',						'YIELD_GOLD',			2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_NEIGHBORHOOD_SELF_FAITH',				'LOC_SFDH100_DISTRICT_SELF_FAITH',						'YIELD_FAITH',			2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
--('SFDH100_CENTER_SCIENCE_PRINTING',				'LOC_SFDH100_DISTRICT_CITY_CENTER_SCIENCE',				'YIELD_SCIENCE',		2,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						'TECH_PRINTING',NULL,			0),
--('SFDH100_CENTER_SCIENCE',						'LOC_SFDH100_DISTRICT_CITY_CENTER_SCIENCE',				'YIELD_SCIENCE',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			'TECH_PRINTING',0),
('SFDH100_WONDER_FAITH',						'LOC_SFDH100_DISTRICT_WONDER_FAITH',					'YIELD_FAITH',			1,					1,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			0),
--('SFDH100_CENTER_CULTURE_PRINTING',				'LOC_DISTRICT_CULTURE_CITY_CENTER',						'YIELD_CULTURE',		2,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						'TECH_PRINTING',NULL,			0),
--('SFDH100_CENTER_CULTURE',						'LOC_DISTRICT_CULTURE_CITY_CENTER',						'YIELD_CULTURE',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			'TECH_PRINTING',0),
('SFDH100_NATURE_WONDER_CULTURE',				'LOC_SFDH100_DISTRICT_NATURE_WONDER_CULTURE',			'YIELD_CULTURE',		1,					0,				1,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			0),
('SFDH100_NEIGHBORHOOD_SELF_PRODUCTION',		'LOC_SFDH100_DISTRICT_SELF_PRODUCTION',					'YIELD_PRODUCTION',		2,					0,				0,							0,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			1),
('SFDH100_RIVER_PRODUCTION',					'LOC_SFDH100_DISTRICT_RIVER_PRODUCTION',				'YIELD_PRODUCTION',		1,					0,				0,							1,					NULL,				NULL,						NULL,								NULL,						NULL,			NULL,			0),
('SFDH100_HARBOR_GOLD',							'LOC_SFDH100_DISTRICT_HARBOR_GOLD',						'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_HARBOR',					NULL,						NULL,			NULL,			0),
('SFDH100_HARBOR_PRODUCTION',					'LOC_SFDH100_DISTRICT_HARBOR_PRODUCTION',				'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_HARBOR',					NULL,						NULL,			NULL,			0),
('SFDH100_COMMERCIAL_HUB_2_GOLD',				'LOC_SFDH100_DISTRICT_COMMERCIAL_HUB_GOLD',				'YIELD_GOLD',			2,					0,				0,							0,					NULL,				NULL,						'DISTRICT_COMMERCIAL_HUB',			NULL,						NULL,			NULL,			0),
('SFDH100_COMMERCIAL_HUB_GOLD',					'LOC_SFDH100_DISTRICT_COMMERCIAL_HUB_GOLD',				'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_COMMERCIAL_HUB',			NULL,						NULL,			NULL,			0),
('SFDH100_COMMERCIAL_HUB_PRODUCTION',			'LOC_SFDH100_DISTRICT_COMMERCIAL_HUB_PRODUCTION',		'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_COMMERCIAL_HUB',			NULL,						NULL,			NULL,			0),
('SFDH100_FEATURE_REEF_GOLD',					'LOC_SFDH100_DISTRICT_FEATURE_REEF_GOLD',				'YIELD_GOLD',			2,					0,				0,							0,					'FEATURE_REEF',		NULL,						NULL,								NULL,						NULL,			NULL,			0),
('SFDH100_INDUSTRIAL_ZONE_GOLD',				'LOC_SFDH100_DISTRICT_INDUSTRIAL_ZONE_GOLD',			'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_INDUSTRIAL_ZONE',			NULL,						NULL,			NULL,			0),
('SFDH100_ENCAMPMENT_GOLD',						'LOC_SFDH100_DISTRICT_ENCAMPMENT_ZONE_GOLD',			'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_ENCAMPMENT',			    NULL,						NULL,			NULL,			0),
('SFDH100_INDUSTRIAL_ZONE_PRODUCTION',			'LOC_SFDH100_DISTRICT_INDUSTRIAL_ZONE_PRODUCTION',		'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_INDUSTRIAL_ZONE',			NULL,						NULL,			NULL,			0),
('SFDH100_AERODROME_2_GOLD',					'LOC_SFDH100_DISTRICT_AERODROME_GOLD',					'YIELD_GOLD',			2,					0,				0,							0,					NULL,				NULL,						'DISTRICT_AERODROME',				NULL,						NULL,			NULL,			0),
('SFDH100_CENTER_2_GOLD_PRINTING',				'LOC_DISTRICT_CITY_CENTER_GOLD',						'YIELD_GOLD',			2,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						'TECH_PRINTING',NULL,			0),
('SFDH100_CENTER_GOLD_PRINTING',				'LOC_DISTRICT_CITY_CENTER_GOLD',						'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			'TECH_PRINTING',0),
('SFDH100_CENTER_GOLD',							'LOC_DISTRICT_CITY_CENTER_GOLD',						'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			NULL,			0),
('SFDH100_CENTER_PRODUCTION',					'LOC_DISTRICT_CITY_CENTER_PRODUCTION',					'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						'DISTRICT_CITY_CENTER',				NULL,						NULL,			NULL,			0),
('SFDH100_LUXURY_GOLD',							'LOC_SFDH100_DISTRICT_LUXURY_GOLD',						'YIELD_GOLD',			1,					0,				0,							0,					NULL,				NULL,						NULL,								'RESOURCECLASS_LUXURY',		NULL,			NULL,			0),
('SFDH100_STRATEGIC_PRODUCTION',				'LOC_DISTRICT_STRATEGIC_PRODUCTION',					'YIELD_PRODUCTION',		1,					0,				0,							0,					NULL,				NULL,						NULL,								'RESOURCECLASS_STRATEGIC',	NULL,			NULL,			0);
INSERT OR REPLACE INTO District_Adjacencies (DistrictType,YieldChangeId)
SELECT			DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_FOOD'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_PRODUCTION'			FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_SCIENCE'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_CULTURE'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_GOLD'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_FAITH'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_NEIGHBORHOOD' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_NEIGHBORHOOD')
--UNION SELECT	DistrictType,			'SFDH100_CENTER_SCIENCE'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_CAMPUS' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_CAMPUS')
--UNION SELECT	DistrictType,			'SFDH100_CENTER_SCIENCE_PRINTING'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_CAMPUS' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_CAMPUS')
UNION SELECT	DistrictType,			'SFDH100_WONDER_FAITH'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HOLY_SITE'		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HOLY_SITE')
--UNION SELECT	DistrictType,			'SFDH100_CENTER_CULTURE'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_THEATER' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER')
--UNION SELECT	DistrictType,			'SFDH100_CENTER_CULTURE_PRINTING'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_THEATER' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER')
UNION SELECT	DistrictType,			'SFDH100_NATURE_WONDER_CULTURE'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_THEATER' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER')
UNION SELECT	DistrictType,			'SFDH100_NEIGHBORHOOD_SELF_PRODUCTION'			FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_RIVER_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_INDUSTRIAL_ZONE')
UNION SELECT	DistrictType,			'SFDH100_HARBOR_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_INDUSTRIAL_ZONE')
UNION SELECT	DistrictType,			'SFDH100_COMMERCIAL_HUB_2_GOLD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HARBOR' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HARBOR')
UNION SELECT	DistrictType,			'SFDH100_FEATURE_REEF_GOLD'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HARBOR' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HARBOR')
UNION SELECT	DistrictType,			'SFDH100_INDUSTRIAL_ZONE_GOLD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HARBOR' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HARBOR')
UNION SELECT	DistrictType,			'SFDH100_INDUSTRIAL_ZONE_GOLD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'SFDH100_ENCAMPMENT_GOLD'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'SFDH100_CENTER_2_GOLD_PRINTING'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'SFDH100_CENTER_GOLD_PRINTING'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'SFDH100_AERODROME_2_GOLD'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'SFDH100_LUXURY_GOLD'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
UNION SELECT	DistrictType,			'Government_Production'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENCAMPMENT' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT')
UNION SELECT	DistrictType,			'SFDH100_INDUSTRIAL_ZONE_PRODUCTION'			FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENCAMPMENT' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT')
UNION SELECT	DistrictType,			'SFDH100_STRATEGIC_PRODUCTION'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENCAMPMENT' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT')
UNION SELECT	DistrictType,			'SFDH100_SELF_AMENITY'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_CITY_CENTER_AMENITY'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_THEATER_AMENITY'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_COMMERCIAL_HUB_AMENITY'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_ACROPOLIS_AMENITY'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_DISTRICT_SUGUBA_AMENITY'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX' OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENTERTAINMENT_COMPLEX')
UNION SELECT	DistrictType,			'SFDH100_INDUSTRIAL_ZONE_GOLD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_INDUSTRIAL_ZONE_PRODUCTION'			FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_COMMERCIAL_HUB_GOLD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_COMMERCIAL_HUB_PRODUCTION'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_CENTER_GOLD'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_CENTER_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_HARBOR_GOLD'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_HARBOR_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_SELF_SCIENCE'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_CAMPUS' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_CAMPUS')
UNION SELECT	DistrictType,			'SFDH100_SELF_CULTURE'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_THEATER' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER')
--UNION SELECT	DistrictType,			'SFDH100_SELF_GOLD'								FROM	Districts	WHERE	DistrictType IS 'DISTRICT_COMMERCIAL_HUB' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_COMMERCIAL_HUB')
--UNION SELECT	DistrictType,			'SFDH100_SELF_GOLD'								FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HARBOR' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HARBOR')
UNION SELECT	DistrictType,			'SFDH100_SELF_FAITH'							FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HOLY_SITE' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HOLY_SITE')
UNION SELECT	DistrictType,			'SFDH100_SELF_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_INDUSTRIAL_ZONE')
UNION SELECT	DistrictType,			'SFDH100_SELF_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_ENCAMPMENT' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_ENCAMPMENT')
UNION SELECT	DistrictType,			'SFDH100_SELF_GOLD'					        	FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME')
UNION SELECT	DistrictType,			'SFDH100_SELF_PRODUCTION'						FROM	Districts	WHERE	DistrictType IS 'DISTRICT_AERODROME' 		OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_AERODROME');
UPDATE Adjacency_YieldChanges SET YieldChange = 1		WHERE ID IS 'River_Gold';
UPDATE Adjacency_YieldChanges SET YieldChange = 3		WHERE ID IS 'Canal_Production' OR ID IS 'Dam_Production';
INSERT OR REPLACE INTO DistrictModifiers (DistrictType,ModifierId) VALUES
('DISTRICT_CITY_CENTER',						'SFDH100_ENTERTAINMENT_ADJ_AMENITY'),
('DISTRICT_THEATER',							'SFDH100_ENTERTAINMENT_ADJ_AMENITY'),
('DISTRICT_COMMERCIAL_HUB',						'SFDH100_ENTERTAINMENT_ADJ_AMENITY'),
('DISTRICT_ENTERTAINMENT_COMPLEX',				'SFDH100_ENTERTAINMENT_ADJ_AMENITY_MODIFIER'),
('DISTRICT_AQUEDUCT',							'SFDH100_AQUEDUCT_CITY_NO_FRESH_WATER_AMENITY'),
('DISTRICT_SPACEPORT',							'SFDH100_SPACEPORT_ADJ_CENTER_REDUCE_AMENITY');
INSERT OR REPLACE INTO DistrictModifiers (DistrictType,ModifierId)
SELECT			DistrictType,			'SFDH100_THEATER_ADJACENCY_AS_TOURISM'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_THEATER' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_THEATER')
UNION SELECT	DistrictType,			'SFDH100_DISTRICT_PRODUCTION_ADJ_LAKE'				FROM	Districts	WHERE	DistrictType IS 'DISTRICT_INDUSTRIAL_ZONE' 	OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_INDUSTRIAL_ZONE');
-- 港口相邻给粮食改成 相邻海岸的城市的港口固定给2粮食
-- UNION SELECT	DistrictType,			'SFDH100_HARBOR_ADJACENCY_AS_FOOD'					FROM	Districts	WHERE	DistrictType IS 'DISTRICT_HARBOR' 			OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType IS 'DISTRICT_HARBOR');
INSERT OR REPLACE INTO GameModifiers (ModifierId) VALUES
('SFDH100_COASTAL_CITY_HARBOR_FOOD_ATTACH');

INSERT OR REPLACE INTO Types (Type, Kind) VALUES
('SFDH100_MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',						'KIND_MODIFIER');
INSERT OR REPLACE INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
('SFDH100_MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',						'COLLECTION_CITY_DISTRICTS',			'EFFECT_ADJUST_DISTRICT_YIELD_CHANGE');

INSERT OR REPLACE INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId) VALUES
('SFDH100_HARBOR_ADJACENCY_AS_FOOD',						'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',			NULL),
('SFDH100_COASTAL_CITY_HARBOR_FOOD_ATTACH',					'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',			                            'REQSET_MYN_PLOT_IS_COASTAL_LAND'),
('SFDH100_COASTAL_CITY_HARBOR_FOOD',						'SFDH100_MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',			            'DISTRICT_IS_HARBOR'),
('SFDH100_DISTRICT_PRODUCTION_ADJ_LAKE',					'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_CHANGE',		                        'SFDH100_DISTRICT_ADJACENT_TO_LAKE'),
('SFDH100_THEATER_ADJACENCY_AS_TOURISM',					'MODIFIER_SFDH100_DISTRICT_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',		NULL),
('SFDH100_ENTERTAINMENT_ADJ_AMENITY',						'MODIFIER_SFDH100_DISTRICTS_ATTACH_MODIFIER',								'SFDH100_PLOT_ADJACENT_IS_ENTERTAINMENT'),
('SFDH100_ENTERTAINMENT_ADJ_AMENITY_MODIFIER',				'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',							NULL),
('SFDH100_AQUEDUCT_CITY_NO_FRESH_WATER_AMENITY',			'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY',							'SFDH100_CITY_HAS_NO_FRESH_WATER'),
('SFDH100_SPACEPORT_ADJ_CENTER_REDUCE_AMENITY',				'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',							'SFDH100_PLOT_ADJACENT_TO_CITY_CENTER');
INSERT OR REPLACE INTO ModifierArguments (ModifierId,Name,Value) VALUES
('SFDH100_HARBOR_ADJACENCY_AS_FOOD',						'YieldTypeToMirror',	'YIELD_GOLD'),
('SFDH100_HARBOR_ADJACENCY_AS_FOOD',						'YieldTypeToGrant',		'YIELD_FOOD'),
('SFDH100_COASTAL_CITY_HARBOR_FOOD_ATTACH',					'ModifierId',			'SFDH100_COASTAL_CITY_HARBOR_FOOD'),
('SFDH100_COASTAL_CITY_HARBOR_FOOD',						'YieldType',			'YIELD_FOOD'),
('SFDH100_COASTAL_CITY_HARBOR_FOOD',						'Amount',			    2),
('SFDH100_DISTRICT_PRODUCTION_ADJ_LAKE',					'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_DISTRICT_PRODUCTION_ADJ_LAKE',					'Amount',				1),
('SFDH100_THEATER_ADJACENCY_AS_TOURISM',					'YieldType',			'YIELD_CULTURE'),
('SFDH100_THEATER_ADJACENCY_AS_TOURISM',					'Amount',				100),
('SFDH100_ENTERTAINMENT_ADJ_AMENITY',						'ModifierId',			'SFDH100_ENTERTAINMENT_ADJ_AMENITY_MODIFIER'),
('SFDH100_ENTERTAINMENT_ADJ_AMENITY_MODIFIER',				'Amount',				1),
('SFDH100_AQUEDUCT_CITY_NO_FRESH_WATER_AMENITY',			'Amount',				1),
('SFDH100_SPACEPORT_ADJ_CENTER_REDUCE_AMENITY',				'Amount',				-1);

INSERT INTO RequirementSets (RequirementSetId,RequirementSetType) VALUES
('REQSET_MYN_PLOT_IS_COASTAL_LAND',				'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId,RequirementId) VALUES
('REQSET_MYN_PLOT_IS_COASTAL_LAND',				'PLOT_IS_COASTAL_LAND_XP2');


INSERT OR IGNORE INTO District_Adjacencies (DistrictType,			YieldChangeId)
SELECT			dr1.CivUniqueDistrictType,			da1.YieldChangeId 
FROM DistrictReplaces dr1 JOIN District_Adjacencies da1 ON dr1.ReplacesDistrictType = da1.DistrictType
WHERE da1.DistrictType = 'DISTRICT_INDUSTRIAL_ZONE';

UPDATE Districts SET CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = '0', Cost = '100' WHERE DistrictType = 'DISTRICT_AQUEDUCT';  -- 水渠固定为50锤
UPDATE Districts SET CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = '0', Cost = '160' WHERE DistrictType = 'DISTRICT_DAM';  -- 水坝造价固定为80锤

--水渠不能建雪地上
INSERT into District_ValidTerrains(DistrictType, TerrainType) values
('DISTRICT_AQUEDUCT',		'TERRAIN_TUNDRA'),
('DISTRICT_AQUEDUCT',		'TERRAIN_TUNDRA_HILLS'),
('DISTRICT_AQUEDUCT',		'TERRAIN_GRASS'),
('DISTRICT_AQUEDUCT',		'TERRAIN_GRASS_HILLS'),
('DISTRICT_AQUEDUCT',		'TERRAIN_PLAINS'),
('DISTRICT_AQUEDUCT',		'TERRAIN_PLAINS_HILLS'),
('DISTRICT_AQUEDUCT',		'TERRAIN_DESERT'),
('DISTRICT_AQUEDUCT',		'TERRAIN_DESERT_HILLS'),
('DISTRICT_BATH',			'TERRAIN_TUNDRA'),
('DISTRICT_BATH',			'TERRAIN_TUNDRA_HILLS'),
('DISTRICT_BATH',			'TERRAIN_GRASS'),
('DISTRICT_BATH',			'TERRAIN_GRASS_HILLS'),
('DISTRICT_BATH',			'TERRAIN_PLAINS'),
('DISTRICT_BATH',			'TERRAIN_PLAINS_HILLS'),
('DISTRICT_BATH',			'TERRAIN_DESERT'),
('DISTRICT_BATH',			'TERRAIN_DESERT_HILLS');

-- [NEED FIX]
--冻土水渠-1住房
-- insert or ignore into DistrictModifiers(DistrictType, ModifierId) values
-- 	('DISTRICT_AQUEDUCT',		'AQUEDUCT_TUNDRA_COST_HOUSING'),
-- 	('DISTRICT_BATH',			'AQUEDUCT_TUNDRA_COST_HOUSING');

-- insert or ignore into Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) values
-- 	('AQUEDUCT_TUNDRA_COST_HOUSING',		'MODIFIER_ADJUST_HOUSING_IN_DISTRICT',		'RS_PLOT_IS_TERRAIN_CLASS_TUNDRA');

-- insert or ignore into ModifierArguments(ModifierId, Name, Value) values
-- 	('AQUEDUCT_TUNDRA_COST_HOUSING',		'Amount',		-1);

