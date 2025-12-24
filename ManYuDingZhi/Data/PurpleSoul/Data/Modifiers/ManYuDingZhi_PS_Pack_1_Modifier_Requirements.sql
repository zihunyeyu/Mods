-- ManYuDingZhi_Modifier_Requirements
-- Author: purple soul
-- DateCreated: 11/2/2024 12:39:04 PM
--------------------------------------------------------------
DROP TABLE IF EXISTS PS_NUMBERS;
CREATE TABLE "PS_NUMBERS" (
'No' INTEGER NOT NULL,
PRIMARY KEY(No)
);
WITH RECURSIVE
  INDICES(i) AS (SELECT 1 UNION ALL SELECT (i + 1) FROM INDICES LIMIT 50)
  INSERT INTO PS_NUMBERS(No) select i from INDICES;
-- REQUIRES_ERA_IS_
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_ERA_IS_'||EraType, 'REQUIREMENTSET_TEST_ALL'
FROM Eras;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_ERA_IS_'||EraType, 'PS_REQ_ERA_IS_'||EraType
FROM Eras;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_ERA_IS_'||EraType, 'REQUIREMENT_GAME_ERA_IS'
FROM Eras;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_ERA_IS_'||EraType, 'EraType', EraType
FROM Eras;
-- PS_REQS_ERA_BEFORE_XX       时代在XX之前（不包含）
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_ERA_BEFORE_'||EraType, 'REQUIREMENTSET_TEST_ALL'
FROM Eras WHERE ChronologyIndex > (SELECT MIN(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_ERA_BEFORE_'||EraType, 'PS_REQ_ERA_BEFORE_'||EraType
FROM Eras WHERE ChronologyIndex > (SELECT MIN(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_ERA_BEFORE_'||EraType, 'REQUIREMENT_GAME_ERA_ATMOST_EXPANSION'
FROM Eras WHERE ChronologyIndex > (SELECT MIN(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_ERA_BEFORE_'||e1.EraType, 'EraType', e2.EraType
FROM Eras e1
INNER JOIN Eras e2 ON e1.ChronologyIndex = e2.ChronologyIndex+1
WHERE e1.EraType <> e2.EraType;
-- PS_REQS_ERA_AFTER_XX       时代在XX之后（不包含）
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_ERA_AFTER_'||EraType, 'REQUIREMENTSET_TEST_ALL'
FROM Eras WHERE ChronologyIndex < (SELECT MAX(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_ERA_AFTER_'||EraType, 'PS_REQ_ERA_AFTER_'||EraType
FROM Eras WHERE ChronologyIndex < (SELECT MAX(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_ERA_AFTER_'||EraType, 'REQUIREMENT_GAME_ERA_ATLEAST_EXPANSION'
FROM Eras WHERE ChronologyIndex < (SELECT MAX(ChronologyIndex) FROM Eras);
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_ERA_AFTER_'||e1.EraType, 'EraType', e2.EraType
FROM Eras e1
INNER JOIN Eras e2 ON e1.ChronologyIndex = e2.ChronologyIndex-1
WHERE e1.EraType <> e2.EraType;
-- PS_REQ_PLAYER_HAS_BUILDING_XX 玩家拥有XX建筑
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLAYER_HAS_'||BuildingType, 'REQUIREMENTSET_TEST_ALL'
FROM Buildings;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLAYER_HAS_'||BuildingType, 'PS_REQ_PLAYER_HAS_'||BuildingType
FROM Buildings;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLAYER_HAS_'||BuildingType, 'REQUIREMENT_PLAYER_HAS_BUILDING'
FROM Buildings;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLAYER_HAS_'||BuildingType, 'BuildingType', BuildingType
FROM Buildings;
-- PS_REQ_PLAYER_HAS_TECH_XX   玩家拥有XX科技
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLAYER_HAS_'||TechnologyType, 'REQUIREMENTSET_TEST_ALL'
FROM Technologies;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLAYER_HAS_'||TechnologyType, 'PS_REQ_PLAYER_HAS_'||TechnologyType
FROM Technologies;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLAYER_HAS_'||TechnologyType, 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'
FROM Technologies;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLAYER_HAS_'||TechnologyType, 'TechnologyType', TechnologyType
FROM Technologies;
-- PS_REQ_PLAYER_HAS_CIVIC_XX  玩家拥有XX市政
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLAYER_HAS_'||CivicType, 'REQUIREMENTSET_TEST_ALL'
FROM Civics;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLAYER_HAS_'||CivicType, 'PS_REQ_PLAYER_HAS_'||CivicType
FROM Civics;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLAYER_HAS_'||CivicType, 'REQUIREMENT_PLAYER_HAS_CIVIC'
FROM Civics;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLAYER_HAS_'||CivicType, 'CivicType', CivicType
FROM Civics;
-- PS_REQ_PLAYER_HAS_CIVIC_XX  玩家拥有XX文明特质
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLAYER_HAS_CIV_'||TraitType, 'REQUIREMENTSET_TEST_ALL'
FROM CivilizationTraits;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLAYER_HAS_CIV_'||TraitType, 'PS_REQ_PLAYER_HAS_CIV_'||TraitType
FROM CivilizationTraits;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLAYER_HAS_CIV_'||TraitType, 'REQUIREMENT_PLAYER_HAS_CIVILIZATION_OR_LEADER_TRAIT'
FROM CivilizationTraits;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLAYER_HAS_CIV_'||TraitType, 'TraitType', TraitType
FROM CivilizationTraits;
-- 
-- PS_REQ_PLAYER_HAS_CIVIC_XX  玩家拥有XX建筑
-- INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
-- SELECT 'PS_REQS_PLAYER_HAS_'||CivicType, 'REQUIREMENTSET_TEST_ALL'
-- FROM Civics;
-- INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
-- SELECT 'PS_REQS_PLAYER_HAS_'||CivicType, 'PS_REQ_PLAYER_HAS_'||CivicType
-- FROM Civics;
-- INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
-- SELECT 'PS_REQ_PLAYER_HAS_'||CivicType, 'REQUIREMENT_PLAYER_HAS_CIVIC'
-- FROM Civics;
-- INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
-- SELECT 'PS_REQ_PLAYER_HAS_'||CivicType, 'CivicType', CivicType
-- FROM Civics;
-- LEADER IS LEADER_XX      玩家领袖是XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_IS_'||LeaderType, 'REQUIREMENTSET_TEST_ALL'
FROM Leaders;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_IS_'||LeaderType, 'PS_REQ_IS_'||LeaderType
FROM Leaders;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_IS_'||LeaderType, 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'
FROM Leaders;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_IS_'||LeaderType, 'LeaderType', LeaderType
FROM Leaders;
-- PLOT地貌类型             单元格地貌是XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLOT_IS_'||FeatureType, 'REQUIREMENTSET_TEST_ALL'
FROM Features;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLOT_IS_'||FeatureType, 'PS_REQ_PLOT_IS_'||FeatureType
FROM Features;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLOT_IS_'||FeatureType, 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'
FROM Features;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLOT_IS_'||FeatureType, 'FeatureType', FeatureType
FROM Features;
-- PLOT改良类型             单元格改良是XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLOT_IS_'||ImprovementType, 'REQUIREMENTSET_TEST_ALL'
FROM Improvements;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLOT_IS_'||ImprovementType, 'PS_REQ_PLOT_IS_'||ImprovementType
FROM Improvements;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLOT_IS_'||ImprovementType, 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'
FROM Improvements;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLOT_IS_'||ImprovementType, 'ImprovementType', ImprovementType
FROM Improvements;
-- PLOT资源类型             单元格资源是XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT	'PS_REQS_PLOT_IS_'||ResourceType,'REQUIREMENTSET_TEST_ALL'
FROM Resources;
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT	'PS_REQS_PLOT_IS_'||ResourceType,'PS_REQ_PLOT_IS_'||ResourceType
FROM Resources;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLOT_IS_'||ResourceType, 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
FROM Resources;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLOT_IS_'||ResourceType, 'ResourceType', ResourceType
FROM Resources;
-- 城市有   BUILDING_XX
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT	'PS_REQS_CITY_HAS_'||BuildingType, 'REQUIREMENTSET_TEST_ALL'
FROM Buildings;                                
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT	'PS_REQS_CITY_HAS_'||BuildingType,'PS_REQ_CITY_HAS_'||BuildingType
FROM Buildings;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_CITY_HAS_'||BuildingType, 'REQUIREMENT_CITY_HAS_BUILDING'
FROM Buildings;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_CITY_HAS_'||BuildingType, 'BuildingType', BuildingType
FROM Buildings;
-- 城市有   DISTRICT_XX
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT	'PS_REQS_CITY_HAS_'||DistrictType, 'REQUIREMENTSET_TEST_ALL'
FROM Districts;                                
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT	'PS_REQS_CITY_HAS_'||DistrictType,'PS_REQ_CITY_HAS_'||DistrictType
FROM Districts;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_CITY_HAS_'||DistrictType, 'REQUIREMENT_CITY_HAS_DISTRICT'
FROM Districts;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_CITY_HAS_'||DistrictType, 'DistrictType', DistrictType
FROM Districts;
-- PLOT X格范围内有区域DISTRICT_XX             
INSERT INTO Requirements (RequirementId, RequirementType, Inverse)
SELECT 'PS_REQ_PLOT_ADJACENT_'||DistrictType, 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES', 0
FROM Districts
UNION SELECT 'PS_REQ_PLOT_NOT_ADJACENT_'||DistrictType, 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES', 1
FROM Districts;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLOT_ADJACENT_'||DistrictType, 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'PS_REQ_PLOT_NOT_ADJACENT_'||DistrictType, 'DistrictType', DistrictType
FROM Districts;
-- DISTRICT类型             DISTRICT_XX
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_IS_'||DistrictType, 'REQUIREMENT_DISTRICT_TYPE_MATCHES'
FROM Districts;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_IS_'||DistrictType, 'DistrictType', DistrictType
FROM Districts;
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_IS_'||DistrictType, 'REQUIREMENTSET_TEST_ALL'
FROM Districts;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_IS_'||DistrictType, 'PS_REQ_IS_'||DistrictType
FROM Districts;
-- ==================================================== --
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQS_PLOT_IS_HOLY_SITE_NOT_ADJACENT_DISTRICT', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_IS_HOLY_SITE_NOT_ADJACENT_DISTRICT', RequirementId
FROM Requirements 
WHERE RequirementId  LIKE 'PS_REQ_PLOT_NOT_ADJACENT_DISTRICT_%'
AND RequirementId!='PS_REQ_PLOT_NOT_ADJACENT_DISTRICT_WONDER';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQS_PLOT_IS_HOLY_SITE_NOT_ADJACENT_DISTRICT', 'PS_REQ_IS_DISTRICT_HOLY_SITE');
-- ==================================================== --
-- 条件：设定在OnPlayerTurnStarted中，通过被宣战后回合数来控制开关PLOT_PROPERTY
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_PROPERTY_DIPLOMACY_DECLARE_WAR', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_PROPERTY_DIPLOMACY_DECLARE_WAR', 'PS_REQ_PROPERTY_DIPLOMACY_DECLARE_WAR');
INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('PS_REQ_PROPERTY_DIPLOMACY_DECLARE_WAR', 'REQUIREMENT_PLOT_PROPERTY_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('PS_REQ_PROPERTY_DIPLOMACY_DECLARE_WAR', 'PropertyName', 'PROPERTY_DIPLOMACY_DECLARE_WAR_MODIFIER'),
('PS_REQ_PROPERTY_DIPLOMACY_DECLARE_WAR', 'PropertyMinimum', 1);
-- ==================================================== --
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_CARTOGRAPHY', 'REQUIREMENTSET_TEST_ALL'),
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_SCIENTIFIC_THEORY', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_CARTOGRAPHY', 'PS_REQ_PLAYER_HAS_TECH_CARTOGRAPHY'),
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_CARTOGRAPHY', 'PS_REQ_IS_LEADER_WILHELMINA'),
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_SCIENTIFIC_THEORY', 'PS_REQ_PLAYER_HAS_TECH_SCIENTIFIC_THEORY'),
('PS_REQS_IS_LEADER_WILHELMINA_AND_HAS_TECH_SCIENTIFIC_THEORY', 'PS_REQ_IS_LEADER_WILHELMINA');
-- ==================================================== --
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_PLOT_PROPERTY_TULIPA_1', 'REQUIREMENTSET_TEST_ALL'),
('PS_REQS_PLOT_PROPERTY_TULIPA_2', 'REQUIREMENTSET_TEST_ALL'),
('PS_REQS_PLOT_PROPERTY_TULIPA_3', 'REQUIREMENTSET_TEST_ALL'),
('PS_REQS_PLOT_PROPERTY_TULIPA_4', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_PLOT_PROPERTY_TULIPA_1', 'PS_REQ_PLOT_PROPERTY_TULIPA_1'),
('PS_REQS_PLOT_PROPERTY_TULIPA_2', 'PS_REQ_PLOT_PROPERTY_TULIPA_2'),
('PS_REQS_PLOT_PROPERTY_TULIPA_3', 'PS_REQ_PLOT_PROPERTY_TULIPA_3'),
('PS_REQS_PLOT_PROPERTY_TULIPA_4', 'PS_REQ_PLOT_PROPERTY_TULIPA_4');
INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('PS_REQ_PLOT_PROPERTY_TULIPA_1', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
('PS_REQ_PLOT_PROPERTY_TULIPA_2', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
('PS_REQ_PLOT_PROPERTY_TULIPA_3', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
('PS_REQ_PLOT_PROPERTY_TULIPA_4', 'REQUIREMENT_PLOT_PROPERTY_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('PS_REQ_PLOT_PROPERTY_TULIPA_1', 'PropertyName', 'PROPERTY_TULIPA_1'),
('PS_REQ_PLOT_PROPERTY_TULIPA_1', 'PropertyMinimum', 1),
('PS_REQ_PLOT_PROPERTY_TULIPA_2', 'PropertyName', 'PROPERTY_TULIPA_2'),
('PS_REQ_PLOT_PROPERTY_TULIPA_2', 'PropertyMinimum', 1),
('PS_REQ_PLOT_PROPERTY_TULIPA_3', 'PropertyName', 'PROPERTY_TULIPA_3'),
('PS_REQ_PLOT_PROPERTY_TULIPA_3', 'PropertyMinimum', 1),
('PS_REQ_PLOT_PROPERTY_TULIPA_4', 'PropertyName', 'PROPERTY_TULIPA_4'),
('PS_REQ_PLOT_PROPERTY_TULIPA_4', 'PropertyMinimum', 1);
-- ==================================================== --
-- 条件：地块为泛滥平原或沼泽或圩田改良。
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'PS_REQ_PLOT_IS_FEATURE_MARSH'),
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'PS_REQ_PLOT_IS_FEATURE_FLOODPLAINS'),
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'PS_REQ_PLOT_IS_FEATURE_FLOODPLAINS_GRASSLAND'),
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'PS_REQ_PLOT_IS_FEATURE_FLOODPLAINS_PLAINS'),
('PS_REQS_ABILITY_GROTE_RIVIEREN_PLOT', 'PS_REQ_PLOT_IS_IMPROVEMENT_POLDER');
-- ==================================================== --
-- 条件：地块为牧场或营地
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_PLOT_IS_PASTURE_OR_CAMP', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_PLOT_IS_PASTURE_OR_CAMP', 'PS_REQ_PLOT_IS_IMPROVEMENT_PASTURE'),
('PS_REQS_PLOT_IS_PASTURE_OR_CAMP', 'PS_REQ_PLOT_IS_IMPROVEMENT_CAMP');
-- ==================================================== --
-- 条件：玩家创立了宗教
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQS_PLAYER_FOUNDED_RELIGION', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQS_PLAYER_FOUNDED_RELIGION', 'REQUIRES_PLAYER_FOUNDED_RELIGION');
-- ==================================================== --
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
-- 条件：单位位于国内
('PS_REQS_UNIT_IN_OWNER_TERRITORY', 'REQUIREMENTSET_TEST_ALL'),
-- 条件：单位位于国内且处于防御
('PS_REQS_UNIT_IN_OWNER_TERRITORY_DEFENSE', 'REQUIREMENTSET_TEST_ALL'),
-- 条件：单位位于国外
('PS_REQS_UNIT_IN_NOT_OWNER_TERRITORY', 'REQUIREMENTSET_TEST_ALL'),
-- 条件：单位位于国外且处于攻击
('PS_REQS_UNIT_IN_NOT_OWNER_TERRITORY_ATTACK', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_UNIT_IN_OWNER_TERRITORY', 'UNIT_IN_OWNER_TERRITORY_REQUIREMENT'),
('PS_REQS_UNIT_IN_OWNER_TERRITORY_DEFENSE', 'UNIT_IN_OWNER_TERRITORY_REQUIREMENT'),
('PS_REQS_UNIT_IN_OWNER_TERRITORY_DEFENSE', 'PLAYER_IS_DEFENDER_REQUIREMENTS'),
('PS_REQS_UNIT_IN_NOT_OWNER_TERRITORY', 'UNIT_IN_NOT_OWNER_TERRITORY_REQUIREMENT'),
('PS_REQS_UNIT_IN_NOT_OWNER_TERRITORY_ATTACK', 'UNIT_IN_NOT_OWNER_TERRITORY_REQUIREMENT'),
('PS_REQS_UNIT_IN_NOT_OWNER_TERRITORY_ATTACK', 'PLAYER_IS_ATTACKER_REQUIREMENTS');
-- ==================================================== --
-- 条件：异大陆；同大陆
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_CITY_IS_OTHER_CONTINENT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
('PS_REQS_CITY_IS_SAME_CONTINENT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_CITY_IS_OTHER_CONTINENT_REQUIREMENTS', 'PS_REQ_CITY_IS_OTHER_CONTINENT_REQUIREMENTS'),
('PS_REQS_CITY_IS_SAME_CONTINENT_REQUIREMENTS', 'PS_REQ_CITY_IS_SAME_CONTINENT_REQUIREMENTS');
INSERT INTO Requirements (RequirementId, RequirementType, Inverse)
VALUES
('PS_REQ_CITY_IS_OTHER_CONTINENT_REQUIREMENTS', 'REQUIREMENT_CITY_IS_OWNER_CAPITAL_CONTINENT', 1),
('PS_REQ_CITY_IS_SAME_CONTINENT_REQUIREMENTS', 'REQUIREMENT_CITY_IS_OWNER_CAPITAL_CONTINENT', 0);
-- ==================================================== --
-- 条件：地块冻土。
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('PS_REQS_ABILITY_EARLY_OCEAN_NAVIGATION_PLOT', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('PS_REQS_ABILITY_EARLY_OCEAN_NAVIGATION_PLOT', 'PS_REQ_PLOT_IS_TERRAIN_CLASS_TUNDRA');
INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('PS_REQ_PLOT_IS_TERRAIN_CLASS_TUNDRA', 'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('PS_REQ_PLOT_IS_TERRAIN_CLASS_TUNDRA', 'TerrainClass', 'TERRAIN_CLASS_TUNDRA');
-- ==================================================== --
-- 条件：巴兹尔二世，战争情况下减少食物，可叠加
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'PS_REQS_PLOT_PROPERTY_DECREASE_FOOD_'||No, 'REQUIREMENTSET_TEST_ALL'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'PS_REQS_PLOT_PROPERTY_DECREASE_FOOD_'||No, 'PS_REQ_PLOT_PROPERTY_DECREASE_FOOD_'||No
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'PS_REQ_PLOT_PROPERTY_DECREASE_FOOD_'||No, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'PS_REQ_PLOT_PROPERTY_DECREASE_FOOD_'||No, 'PropertyName', 'PROPERTY_DECREASE_FOOD_'||No
FROM PS_NUMBERS WHERE No <= 20
UNION SELECT 'PS_REQ_PLOT_PROPERTY_DECREASE_FOOD_'||No, 'PropertyMinimum', 1
FROM PS_NUMBERS WHERE No <= 20;
-- ==================================================== --
-- 条件：威廉明娜，贸易路线增加产出
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_'||No, 'REQUIREMENTSET_TEST_ALL'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_'||No, 'REQ_PLOT_PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_'||No
FROM PS_NUMBERS WHERE No <= 20
UNION SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_'||No, 'PS_REQ_ERA_BEFORE_ERA_MEDIEVAL'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_'||No, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_'||No, 'PropertyName', 'PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_'||No
FROM PS_NUMBERS WHERE No <= 20
UNION SELECT 'REQ_PLOT_PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_'||No, 'PropertyMinimum', 1
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_'||(No*2), 'REQUIREMENTSET_TEST_ALL'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_'||(No*2), 'REQ_PLOT_PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_'||(No*2)
FROM PS_NUMBERS WHERE No <= 20
UNION SELECT 'REQS_PLOT_PROPERTY_INCREASE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_'||(No*2), 'PS_REQ_ERA_AFTER_ERA_CLASSICAL'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_'||(No*2), 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM PS_NUMBERS WHERE No <= 20;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_'||(No*2), 'PropertyName', 'PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_'||(No*2)
FROM PS_NUMBERS WHERE No <= 20
UNION SELECT 'REQ_PLOT_PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_'||(No*2), 'PropertyMinimum', 1
FROM PS_NUMBERS WHERE No <= 20;
-- ==================================================== --
-- 条件：庞德梅克，贸易路线增加产出
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No, 'REQUIREMENTSET_TEST_ALL'
FROM PS_NUMBERS WHERE No <= 50;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No, 'REQ_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No
FROM PS_NUMBERS WHERE No <= 50
;
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM PS_NUMBERS WHERE No <= 50;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No, 'PropertyName', 'PROPERTY_TOTAL_NUM_IMPROVEMENT_CAMP'||No
FROM PS_NUMBERS WHERE No <= 50
UNION SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_CAMP_NUM'||No, 'PropertyMinimum', 1
FROM PS_NUMBERS WHERE No <= 50;
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No, 'REQUIREMENTSET_TEST_ALL'
FROM PS_NUMBERS WHERE No <= 50;
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No, 'REQ_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No
FROM PS_NUMBERS WHERE No <= 50
;
INSERT INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM PS_NUMBERS WHERE No <= 50;
INSERT INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No, 'PropertyName', 'PROPERTY_TOTAL_NUM_IMPROVEMENT_PASTURE'||No
FROM PS_NUMBERS WHERE No <= 50
UNION SELECT 'REQ_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM'||No, 'PropertyMinimum', 1
FROM PS_NUMBERS WHERE No <= 50;