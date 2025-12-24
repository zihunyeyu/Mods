-- ManYuDingZhi_Building
-- Author: SFDH100
-- DateCreated: 2023/9/5 20:58:15
--当前649行
--------------------------------------------------------------
INSERT OR REPLACE INTO Types (Type,Kind) VALUES
('BUILDING_SFDH100_ART_COLLEGE',				'KIND_BUILDING'),
('BUILDING_SFDH100_CAREER_COLLEGE',				'KIND_BUILDING'),
('BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',		'KIND_BUILDING'),
('BUILDING_SFDH100_ARSENAL',					'KIND_BUILDING'),
('BUILDING_SFDH100_NAVAL_BASE',					'KIND_BUILDING'),
('BUILDING_SFDH100_NAVAL_ACADEMY',				'KIND_BUILDING'),
('BUILDING_SFDH100_STAGE',						'KIND_BUILDING'),
('BUILDING_SFDH100_AIRFORCE_BASE',				'KIND_BUILDING');
--UPDATE Buildings 					SET Cost = Cost*2, OuterDefenseHitPoints = OuterDefenseHitPoints+50	WHERE BuildingType = "BUILDING_CASTLE";	--中世纪城墙+50外部防御并且造价翻倍
--UPDATE Buildings 					SET Cost = Cost*2, OuterDefenseHitPoints = OuterDefenseHitPoints+50	WHERE BuildingType = "BUILDING_STAR_FORT";	--文艺复兴城墙+50外部防御并且造价翻倍
UPDATE Buildings 					SET Housing = 1											WHERE BuildingType = "BUILDING_WATER_MILL";	--水磨+1住房
UPDATE Buildings 					SET Housing = 3,Entertainment = 1						WHERE BuildingType = "BUILDING_SEWER";	--下水道+1宜居
UPDATE Buildings 					SET Housing = 1											WHERE BuildingType = "BUILDING_UNIVERSITY";	--大学+1住房
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_UNIVERSITY" AND GreatPersonClassType = "GREAT_PERSON_CLASS_SCIENTIST";	--大学+2大科点
UPDATE Buildings 					SET Maintenance = 10									WHERE BuildingType = "BUILDING_RESEARCH_LAB";	--研究实验室-10维护费
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_RESEARCH_LAB" AND YieldType = "YIELD_SCIENCE";	--研究实验室+0科
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_RESEARCH_LAB" AND GreatPersonClassType = "GREAT_PERSON_CLASS_SCIENTIST";	--研究实验室+4大科点
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 12						WHERE BuildingType = "BUILDING_RESEARCH_LAB" AND YieldType = "YIELD_SCIENCE";	--研究实验室供电充足+12科
UPDATE Buildings 					SET AdjacentDistrict = NULL								WHERE BuildingType = "BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION";	--极地科考站不需要相邻学院
DELETE FROM BuildingPrereqs																	WHERE Building = "BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION";	--极地科考站不需要研究实验室
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 6									WHERE BuildingType = "BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION" AND GreatPersonClassType = "GREAT_PERSON_CLASS_SCIENTIST";	--极地科考站+6大科点
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_SHRINE" AND GreatPersonClassType = "GREAT_PERSON_CLASS_PROPHET";	--神社+2大仙点
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_TEMPLE" AND GreatPersonClassType = "GREAT_PERSON_CLASS_PROPHET";	--寺庙+2大仙点
UPDATE Buildings 					SET Housing = 1											WHERE BuildingType = "BUILDING_BARRACKS";	--兵营+1住房
UPDATE Building_YieldChanges 		SET YieldChange = 2										WHERE BuildingType = "BUILDING_BARRACKS" AND YieldType = "YIELD_PRODUCTION";	--兵营+2锤
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_BARRACKS" AND GreatPersonClassType = "GREAT_PERSON_CLASS_GENERAL";	--兵营+2大将点
UPDATE Buildings					SET Housing = 1, Cost = 90								WHERE (BuildingType = "BUILDING_STABLE" OR BuildingType = "BUILDING_ORDU");	--马厩+1住房
UPDATE Building_YieldChanges 		SET YieldChange = 2										WHERE (BuildingType = "BUILDING_STABLE" OR BuildingType = "BUILDING_ORDU") AND YieldType = "YIELD_PRODUCTION";	--马厩+2锤
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE (BuildingType = "BUILDING_STABLE" OR BuildingType = "BUILDING_ORDU") AND GreatPersonClassType = "GREAT_PERSON_CLASS_GENERAL";	--马厩+2大将点
UPDATE Building_YieldChanges 		SET YieldChange = 5										WHERE BuildingType = "BUILDING_ARMORY" AND YieldType = "YIELD_PRODUCTION";	--兵工厂+5锤
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 0									WHERE BuildingType = "BUILDING_ARMORY" AND GreatPersonClassType = "GREAT_PERSON_CLASS_GENERAL";	--兵工厂+0大将点
UPDATE Buildings 					SET Housing = 1											WHERE BuildingType = "BUILDING_MILITARY_ACADEMY";	--军事学院+1住房
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 8									WHERE BuildingType = "BUILDING_MILITARY_ACADEMY" AND GreatPersonClassType = "GREAT_PERSON_CLASS_GENERAL";	--军事学院+8大将点
UPDATE Building_YieldChanges 		SET YieldChange = 5										WHERE BuildingType = "BUILDING_MARKET" AND YieldType = "YIELD_GOLD";	--市场+5金
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_MARKET" AND GreatPersonClassType = "GREAT_PERSON_CLASS_MERCHANT";	--市场+2大商点
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_BANK" AND YieldType = "YIELD_GOLD";	--银行+8金
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_BANK" AND GreatPersonClassType = "GREAT_PERSON_CLASS_MERCHANT";	--银行+2大商点
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_STOCK_EXCHANGE" AND GreatPersonClassType = "GREAT_PERSON_CLASS_MERCHANT";	--证券+4大商点
UPDATE Buildings 					SET Maintenance = 5										WHERE BuildingType = "BUILDING_WORKSHOP";	--工作坊-5维护费
UPDATE Building_YieldChanges 		SET YieldChange = 5										WHERE BuildingType = "BUILDING_WORKSHOP" AND YieldType = "YIELD_PRODUCTION";	--工作坊+5锤
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_WORKSHOP" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--工作坊+2大工
UPDATE Buildings 					SET Maintenance = 10									WHERE BuildingType = "BUILDING_FACTORY";	--工厂-10维护费
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_FACTORY" AND YieldType = "YIELD_PRODUCTION";	--工厂+0锤
UPDATE Buildings_XP2 				SET RequiredPower = 6									WHERE BuildingType = "BUILDING_FACTORY";	--工厂-6电
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_FACTORY" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--工厂+4大工
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 12						WHERE BuildingType = "BUILDING_FACTORY" AND YieldType = "YIELD_PRODUCTION";	--工厂供电充足+12生产力
UPDATE Buildings 					SET Maintenance = 10									WHERE BuildingType = "BUILDING_ELECTRONICS_FACTORY";	--电子厂-10维护费
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_ELECTRONICS_FACTORY" AND YieldType = "YIELD_PRODUCTION";	--电子厂+0锤
UPDATE Buildings_XP2 				SET RequiredPower = 6									WHERE BuildingType = "BUILDING_ELECTRONICS_FACTORY";	--电子厂-6电
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_ELECTRONICS_FACTORY" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--电子厂+4大工
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 12						WHERE BuildingType = "BUILDING_ELECTRONICS_FACTORY" AND YieldType = "YIELD_PRODUCTION";	--电子厂供电充足+12生产力
UPDATE Buildings 					SET Maintenance = 20,Entertainment = -1					WHERE BuildingType = "BUILDING_COAL_POWER_PLANT";	--燃煤-20维护费-1宜居
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 0									WHERE BuildingType = "BUILDING_COAL_POWER_PLANT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--燃煤+0大工
UPDATE Buildings 					SET Maintenance = 20									WHERE BuildingType = "BUILDING_FOSSIL_FUEL_POWER_PLANT";	--燃油-20维护费
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_FOSSIL_FUEL_POWER_PLANT" AND YieldType = "YIELD_PRODUCTION";	--燃油+0锤
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_FOSSIL_FUEL_POWER_PLANT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--燃油+2大工
UPDATE Resource_Consumption 		SET PowerProvided = 6, CO2perkWh = CO2perkWh/2								WHERE ResourceType = "RESOURCE_OIL";	--燃油排放减半
UPDATE Buildings 					SET RegionalRange = 9, Maintenance = 30					WHERE BuildingType = "BUILDING_POWER_PLANT";	--核电辐射9格		, Coast = 1
UPDATE Building_YieldChanges 		SET YieldChange = 12									WHERE BuildingType = "BUILDING_POWER_PLANT" AND (YieldType = "YIELD_PRODUCTION" OR YieldType = "YIELD_SCIENCE");	--核电+12锤科
UPDATE Building_GreatPersonPoints 	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_POWER_PLANT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ENGINEER";	--核电+4大工点
UPDATE Buildings_XP2				SET NuclearReactor = 0									WHERE BuildingType = 'BUILDING_POWER_PLANT';--核电站不会爆炸
UPDATE Resource_Consumption 		SET CO2perkWh = 0										WHERE ResourceType = "RESOURCE_URANIUM";	--核电不排放
DELETE FROM Projects																		WHERE ProjectType = 'PROJECT_RECOMMISSION_REACTOR';--删除核电项目
UPDATE Buildings 					SET Housing = 2											WHERE BuildingType = "BUILDING_LIGHTHOUSE";	--灯塔+2住房
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_LIGHTHOUSE" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ADMIRAL";	--灯塔+2大海点
UPDATE Modifiers 					SET SubjectRequirementSetId = null						WHERE ModifierId = "LIGHTHOUSE_TRADE_ROUTE_CAPACITY";	--去除灯塔贸易路线容量限制
UPDATE Buildings 					SET Maintenance = 5										WHERE BuildingType = "BUILDING_SHIPYARD";	--造船厂-5维护费
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_SHIPYARD" AND YieldType = "YIELD_FOOD";	--造船厂+0粮
UPDATE Buildings 					SET Housing = 0											WHERE BuildingType = "BUILDING_SEAPORT";	--码头+0住房
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_SEAPORT" AND YieldType = "YIELD_GOLD";	--码头+0金
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_SEAPORT" AND YieldType = "YIELD_FOOD";	--码头+0粮
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_SEAPORT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ADMIRAL";	--码头+2海军点
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 2									WHERE BuildingType = "BUILDING_AMPHITHEATER" AND GreatPersonClassType = "GREAT_PERSON_CLASS_WRITER";	--古罗马剧场+2大作点
UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE BuildingType = "BUILDING_AMPHITHEATER" AND YieldType = "YIELD_CULTURE";	--艺术+8文
UPDATE Building_YieldChanges 		SET YieldChange = 8										WHERE BuildingType = "BUILDING_MUSEUM_ART" AND YieldType = "YIELD_CULTURE";	--艺术+8文
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 0									WHERE BuildingType = "BUILDING_MUSEUM_ART" AND GreatPersonClassType = "GREAT_PERSON_CLASS_WRITER";	--艺术+0大作点
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 4									WHERE BuildingType = "BUILDING_MUSEUM_ART" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ARTIST";	--艺术+4大艺点
UPDATE Building_YieldChanges 		SET YieldChange = 8										WHERE BuildingType = "BUILDING_MUSEUM_ARTIFACT" AND YieldType = "YIELD_CULTURE";	--考古+8文
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 0									WHERE BuildingType = "BUILDING_MUSEUM_ARTIFACT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_WRITER";	--考古+0大作点
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 0									WHERE BuildingType = "BUILDING_MUSEUM_ARTIFACT" AND GreatPersonClassType = "GREAT_PERSON_CLASS_ARTIST";	--考古+4大艺点
--UPDATE Building_YieldChanges 		SET YieldChange = 0										WHERE (BuildingType = "BUILDING_BROADCAST_CENTER" OR BuildingType = "BUILDING_FILM_STUDIO") AND YieldType = "YIELD_CULTURE";	--广播+0文
UPDATE Buildings 					SET RegionalRange = 6									WHERE (BuildingType = "BUILDING_BROADCAST_CENTER" OR BuildingType = "BUILDING_FILM_STUDIO");	--广播辐射6格
UPDATE Building_GreatPersonPoints	SET PointsPerTurn = 8									WHERE (BuildingType = "BUILDING_BROADCAST_CENTER" OR BuildingType = "BUILDING_FILM_STUDIO") AND GreatPersonClassType = "GREAT_PERSON_CLASS_MUSICIAN";	--广播+8大音点
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 8							WHERE BuildingType = "BUILDING_BROADCAST_CENTER" AND YieldType = "YIELD_CULTURE";	--广播供电充足+8文
UPDATE Buildings 					SET RegionalRange = 0,	Entertainment = 2				WHERE BuildingType = "BUILDING_ZOO";	--动物园辐射0格(对应ub不变)+2宜居
UPDATE Buildings 					SET RegionalRange = 0,	Entertainment = 2				WHERE BuildingType = "BUILDING_STADIUM";	--体育场辐射0格,+2宜居
UPDATE Buildings 					SET Entertainment = 2									WHERE BuildingType = "BUILDING_AQUATICS_CENTER";	--水上中心+2宜居
UPDATE Building_YieldChanges 		SET YieldChange = 4										WHERE BuildingType = "BUILDING_HANGAR" AND YieldType = "YIELD_PRODUCTION";	--机库+4锤
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 4							WHERE BuildingType = "BUILDING_AIRPORT" AND YieldType = "YIELD_PRODUCTION";	--机场供电充足+4锤
UPDATE Buildings 					SET Cost = 100											WHERE GovernmentTierRequirement = "Tier1";	--市政广场1级建筑100锤
UPDATE Buildings 					SET Cost = 250											WHERE GovernmentTierRequirement = "Tier2";	--市政广场2级建筑250锤
UPDATE Buildings 					SET Cost = 350											WHERE GovernmentTierRequirement = "Tier3";	--市政广场3级建筑350锤
UPDATE Building_GreatWorks 			SET NumSlots = 5										WHERE BuildingType = "BUILDING_GOV_CULTURE" AND GreatWorkSlotType = 'GREATWORKSLOT_PALACE';	--国家历史博物馆著作槽改为5
UPDATE Buildings 					SET Cost = 150,	Entertainment = 0, PrereqTech = 'TECH_SANITATION'		WHERE PrereqDistrict = "DISTRICT_NEIGHBORHOOD" AND IsWonder = 0;	--社区建筑改为300锤
UPDATE Building_YieldChanges 		SET YieldChange = 4										WHERE BuildingType = "BUILDING_SHOPPING_MALL" AND YieldType = "YIELD_GOLD";	--购物中心+4金币
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 2							WHERE BuildingType = "BUILDING_SHOPPING_MALL" AND YieldType = "YIELD_GOLD";	--购物中心供电充足+2金币
UPDATE Building_YieldChanges 		SET YieldChange = 2										WHERE BuildingType = "BUILDING_FOOD_MARKET" AND YieldType = "YIELD_FOOD";	--食品市场+2粮
UPDATE Building_YieldChangesBonusWithPower 		SET YieldChange = 4							WHERE BuildingType = "BUILDING_FOOD_MARKET" AND YieldType = "YIELD_FOOD";	--食品市场供电充足+4粮
UPDATE Buildings_XP2 				SET EntertainmentBonusWithPower = 1						WHERE BuildingType = "BUILDING_FOOD_MARKET";	--食品市场供电充足+1宜居
/*--新建筑废案
INSERT OR REPLACE INTO Buildings	
(				BuildingType,							Name,												Description,												PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement)
SELECT			'BUILDING_SFDH100_ART_COLLEGE',			'LOC_BUILDING_SFDH100_ART_COLLEGE_NAME',			'LOC_BUILDING_SFDH100_ART_COLLEGE_DESCRIPTION',				PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_UNIVERSITY'
UNION SELECT	'BUILDING_SFDH100_CAREER_COLLEGE',		'LOC_BUILDING_SFDH100_CAREER_COLLEGE_NAME',			'LOC_BUILDING_SFDH100_CAREER_COLLEGE_DESCRIPTION',			PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,0,		Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,5,				IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_UNIVERSITY'
UNION SELECT	'BUILDING_SFDH100_SIEGE_WEAPON_FACTORY','LOC_BUILDING_SFDH100_SIEGE_WEAPON_FACTORY_NAME',	'LOC_BUILDING_SFDH100_SIEGE_WEAPON_FACTORY_DESCRIPTION',	PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_ARMORY'
UNION SELECT	'BUILDING_SFDH100_ARSENAL',				'LOC_BUILDING_SFDH100_ARSENAL_NAME',				'LOC_BUILDING_SFDH100_ARSENAL_DESCRIPTION',					PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,5,				IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_MILITARY_ACADEMY'
UNION SELECT	'BUILDING_SFDH100_NAVAL_BASE',			'LOC_BUILDING_SFDH100_NAVAL_BASE_NAME',				'LOC_BUILDING_SFDH100_NAVAL_BASE_DESCRIPTION',				PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_SHIPYARD'
UNION SELECT	'BUILDING_SFDH100_NAVAL_ACADEMY',		'LOC_BUILDING_SFDH100_NAVAL_ACADEMY_NAME',			'LOC_BUILDING_SFDH100_NAVAL_ACADEMY_DESCRIPTION',			PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,1,		Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_SEAPORT'
UNION SELECT	'BUILDING_SFDH100_STAGE',				'LOC_BUILDING_SFDH100_STAGE_NAME',					'LOC_BUILDING_SFDH100_STAGE_DESCRIPTION',					PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_AMPHITHEATER'
UNION SELECT	'BUILDING_SFDH100_AIRFORCE_BASE',		'LOC_BUILDING_SFDH100_AIRFORCE_BASE_NAME',			'LOC_BUILDING_SFDH100_AIRFORCE_BASE_DESCRIPTION',			PrereqTech,		PrereqCivic,	Cost,MaxPlayerInstances,MaxWorldInstances,Capital,PrereqDistrict,AdjacentDistrict,RequiresPlacement,RequiresRiver,OuterDefenseHitPoints,Housing,Entertainment,AdjacentResource,Coast,EnabledByReligion,AllowsHolyCity,PurchaseYield,MustPurchase,Maintenance,	IsWonder,TraitType,OuterDefenseStrength,CitizenSlots,MustBeLake,MustNotBeLake,RegionalRange,AdjacentToMountain,ObsoleteEra,RequiresReligion,GrantFortification,DefenseModifier,InternalOnly,RequiresAdjacentRiver,Quote,QuoteAudio,MustBeAdjacentLand,AdvisorType,AdjacentCapital,AdjacentImprovement,CityAdjacentTerrain,UnlocksGovernmentPolicy,GovernmentTierRequirement FROM Buildings WHERE BuildingType = 'BUILDING_AIRPORT';
INSERT OR REPLACE INTO BuildingPrereqs (Building,PrereqBuilding)
SELECT			'BUILDING_SFDH100_ART_COLLEGE',			PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_UNIVERSITY'
UNION SELECT	Building,								'BUILDING_SFDH100_ART_COLLEGE'				FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_UNIVERSITY'
UNION SELECT	'BUILDING_SFDH100_CAREER_COLLEGE',		PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_UNIVERSITY'
UNION SELECT	Building,								'BUILDING_SFDH100_CAREER_COLLEGE'			FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_UNIVERSITY'
UNION SELECT	'BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_ARMORY'
UNION SELECT	Building,								'BUILDING_SFDH100_SIEGE_WEAPON_FACTORY'		FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_ARMORY'
UNION SELECT	'BUILDING_SFDH100_ARSENAL',				PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_MILITARY_ACADEMY'
UNION SELECT	Building,								'BUILDING_SFDH100_ARSENAL'					FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_MILITARY_ACADEMY'
UNION SELECT	'BUILDING_SFDH100_NAVAL_BASE',			PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_SHIPYARD'
UNION SELECT	Building,								'BUILDING_SFDH100_NAVAL_BASE'				FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_SHIPYARD'
UNION SELECT	'BUILDING_SFDH100_NAVAL_ACADEMY',		PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_SEAPORT'
UNION SELECT	Building,								'BUILDING_SFDH100_NAVAL_ACADEMY'			FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_SEAPORT'
UNION SELECT	'BUILDING_SFDH100_STAGE',				PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_AMPHITHEATER'
UNION SELECT	Building,								'BUILDING_SFDH100_STAGE'					FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_AMPHITHEATER'
UNION SELECT	'BUILDING_SFDH100_AIRFORCE_BASE',		PrereqBuilding 								FROM BuildingPrereqs WHERE Building = 'BUILDING_AIRPORT'
UNION SELECT	Building,								'BUILDING_SFDH100_AIRFORCE_BASE'			FROM BuildingPrereqs WHERE PrereqBuilding = 'BUILDING_AIRPORT';
INSERT OR REPLACE INTO MutuallyExclusiveBuildings (Building,MutuallyExclusiveBuilding) VALUES
('BUILDING_SFDH100_ART_COLLEGE',				'BUILDING_UNIVERSITY'),
('BUILDING_SFDH100_ART_COLLEGE',				'BUILDING_SFDH100_CAREER_COLLEGE'),
('BUILDING_UNIVERSITY',							'BUILDING_SFDH100_ART_COLLEGE'),
('BUILDING_SFDH100_CAREER_COLLEGE',				'BUILDING_UNIVERSITY'),
('BUILDING_SFDH100_CAREER_COLLEGE',				'BUILDING_SFDH100_ART_COLLEGE'),
('BUILDING_UNIVERSITY',							'BUILDING_SFDH100_CAREER_COLLEGE'),
('BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',		'BUILDING_ARMORY'),
('BUILDING_ARMORY',								'BUILDING_SFDH100_SIEGE_WEAPON_FACTORY'),
('BUILDING_SFDH100_ARSENAL',					'BUILDING_MILITARY_ACADEMY'),
('BUILDING_MILITARY_ACADEMY',					'BUILDING_SFDH100_ARSENAL'),
('BUILDING_SFDH100_NAVAL_BASE',					'BUILDING_SHIPYARD'),
('BUILDING_SHIPYARD',							'BUILDING_SFDH100_NAVAL_BASE'),
('BUILDING_SFDH100_NAVAL_ACADEMY',				'BUILDING_SEAPORT'),
('BUILDING_SEAPORT',							'BUILDING_SFDH100_NAVAL_ACADEMY'),
('BUILDING_SFDH100_STAGE',						'BUILDING_AMPHITHEATER'),
('BUILDING_AMPHITHEATER',						'BUILDING_SFDH100_STAGE'),
('BUILDING_SFDH100_AIRFORCE_BASE',				'BUILDING_AIRPORT'),
('BUILDING_AIRPORT',							'BUILDING_SFDH100_AIRFORCE_BASE');
*/
INSERT OR REPLACE INTO Building_YieldChanges (BuildingType,YieldType,YieldChange) VALUES
/*('BUILDING_SFDH100_ART_COLLEGE',				'YIELD_CULTURE',								2),
('BUILDING_SFDH100_ART_COLLEGE',				'YIELD_SCIENCE',								4),
('BUILDING_SFDH100_CAREER_COLLEGE',				'YIELD_SCIENCE',								4),
('BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',		'YIELD_PRODUCTION',								5),
('BUILDING_SFDH100_NAVAL_ACADEMY',				'YIELD_SCIENCE',								4),
('BUILDING_SFDH100_STAGE',						'YIELD_CULTURE',								2),
('BUILDING_SFDH100_STAGE',						'YIELD_GOLD',									2),*/
('BUILDING_HYDROELECTRIC_DAM',					'YIELD_PRODUCTION',								6),
('BUILDING_AQUATICS_CENTER',					'YIELD_CULTURE',								2),
('BUILDING_AQUATICS_CENTER',					'YIELD_GOLD',									5),
('BUILDING_STADIUM',							'YIELD_CULTURE',								2),
('BUILDING_STADIUM',							'YIELD_GOLD',									5),
('BUILDING_ZOO',								'YIELD_SCIENCE',								2),
-- ('BUILDING_LIGHTHOUSE',							'YIELD_GOLD',									5),         -- 灯塔的+5金币砍掉
('BUILDING_LIGHTHOUSE',							'YIELD_FOOD',									2),
('BUILDING_MILITARY_ACADEMY',					'YIELD_SCIENCE',								4);
INSERT OR REPLACE INTO Building_GreatPersonPoints (BuildingType,GreatPersonClassType,PointsPerTurn) VALUES
/*('BUILDING_SFDH100_ART_COLLEGE',				'GREAT_PERSON_CLASS_ARTIST',					1),
('BUILDING_SFDH100_ART_COLLEGE',				'GREAT_PERSON_CLASS_SCIENTIST',					1),
('BUILDING_SFDH100_CAREER_COLLEGE',				'GREAT_PERSON_CLASS_SCIENTIST',					1),
('BUILDING_SFDH100_CAREER_COLLEGE',				'GREAT_PERSON_CLASS_ENGINEER',					1),
('BUILDING_SFDH100_NAVAL_BASE',					'GREAT_PERSON_CLASS_ADMIRAL',					4),
('BUILDING_SFDH100_NAVAL_ACADEMY',				'GREAT_PERSON_CLASS_ADMIRAL',					8),
('BUILDING_SFDH100_STAGE',						'GREAT_PERSON_CLASS_WRITER',					2),*/
('BUILDING_FOSSIL_FUEL_POWER_PLANT',			'GREAT_PERSON_CLASS_MERCHANT',					2),
('BUILDING_GOV_SCIENCE',						'GREAT_PERSON_CLASS_SCIENTIST',					4),
('BUILDING_GOV_SCIENCE',						'GREAT_PERSON_CLASS_ENGINEER',					4),
('BUILDING_GOV_CULTURE',						'GREAT_PERSON_CLASS_ARTIST',					8),
('BUILDING_GOV_CULTURE',						'GREAT_PERSON_CLASS_MUSICIAN',					2),
('BUILDING_GOV_CULTURE',						'GREAT_PERSON_CLASS_WRITER',					2),
('BUILDING_ELECTRONICS_FACTORY',				'GREAT_PERSON_CLASS_MUSICIAN',					4),
('BUILDING_SHIPYARD',							'GREAT_PERSON_CLASS_GENERAL',					1),
('BUILDING_SEAPORT',							'GREAT_PERSON_CLASS_MERCHANT',					2),
('BUILDING_POWER_PLANT',						'GREAT_PERSON_CLASS_SCIENTIST',					4),
('BUILDING_LIBRARY',							'GREAT_PERSON_CLASS_WRITER',					1);
INSERT OR REPLACE INTO Building_YieldDistrictCopies (BuildingType,OldYieldType,NewYieldType) VALUES
--('BUILDING_SFDH100_NAVAL_BASE',			'YIELD_GOLD',									'YIELD_PRODUCTION'),
('BUILDING_BROADCAST_CENTER',			'YIELD_CULTURE',								'YIELD_CULTURE'),
('BUILDING_AMPHITHEATER',				'YIELD_CULTURE',								'YIELD_CULTURE'),
('BUILDING_SEAPORT',					'YIELD_GOLD',									'YIELD_GOLD'),
('BUILDING_SHIPYARD',					'YIELD_GOLD',									'YIELD_PRODUCTION'),
--('BUILDING_LIGHTHOUSE',					'YIELD_GOLD',									'YIELD_GOLD'),
--('BUILDING_FOSSIL_FUEL_POWER_PLANT',	'YIELD_PRODUCTION',								'YIELD_PRODUCTION'),
('BUILDING_ELECTRONICS_FACTORY',		'YIELD_PRODUCTION',								'YIELD_PRODUCTION'),
('BUILDING_FACTORY',					'YIELD_PRODUCTION',								'YIELD_PRODUCTION'),
('BUILDING_BANK',						'YIELD_GOLD',									'YIELD_GOLD'),
('BUILDING_RESEARCH_LAB',				'YIELD_SCIENCE',								'YIELD_SCIENCE');
UPDATE Buildings 	SET Description = 'LOC_BUILDING_UNIVERSITY_DESCRIPTION'			WHERE BuildingType = "BUILDING_UNIVERSITY";
UPDATE Buildings	SET Description = 'LOC_BUILDING_LIBRARY_DESCRIPTION'			WHERE BuildingType = "BUILDING_LIBRARY";
UPDATE Buildings	SET Description = 'LOC_BUILDING_BANK_DESCRIPTION'				WHERE BuildingType = "BUILDING_BANK";
UPDATE Buildings	SET Description = 'LOC_BUILDING_STOCK_EXCHANGE_DESCRIPTION'		WHERE BuildingType = "BUILDING_STOCK_EXCHANGE";
UPDATE Buildings	SET Description = 'LOC_BUILDING_WORKSHOP_DESCRIPTION'			WHERE BuildingType = "BUILDING_WORKSHOP";
UPDATE Buildings	SET Description = 'LOC_BUILDING_AMPHITHEATER_DESCRIPTION'			WHERE BuildingType = "BUILDING_AMPHITHEATER";
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
/* ('BUILDING_SFDH100_ART_COLLEGE',			'SFDH100_CITY_ART_COLLEGE_RADIO_MUSICIAN_POINT'),
('BUILDING_SFDH100_CAREER_COLLEGE',			'SFDH100_CITY_CAREER_COLLEGE_SCIENCE_POPULATION'),
('BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',	'SFDH100_CITY_SIEGE_WEAPON_FACTORY_PORDUCTION'),
('BUILDING_SFDH100_SIEGE_WEAPON_FACTORY',	'SFDH100_CITY_SIEGE_WEAPON_FACTORY_UNIT_GRANT_MORE_XP'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_HORSES'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_IRON'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_NITER'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_COAL'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_ALUMINUM'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_CAN_SEE_OIL'),
('BUILDING_SFDH100_ARSENAL',				'SFDH100_CITY_ARSENAL_ADJUST_RESOURCE_STOCKPILE_CAP'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_MELEE_PRODUCTION'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_RANGED_PRODUCTION'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_CARRIER_PRODUCTION'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_RAIDER_PRODUCTION'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_MORE_XP'),
('BUILDING_SFDH100_NAVAL_BASE',				'SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_EXTRA_HEAL'),
('BUILDING_SFDH100_NAVAL_ACADEMY',			'SEAPORT_CITY_NAVAL_ACADEMY_FREE_PROMOTION'),
('BUILDING_SFDH100_NAVAL_ACADEMY',			'SFDH100_CITY_NAVAL_ACADEMY_GRANT_MORE_XP_AND_STRENGTH'),
('BUILDING_SFDH100_NAVAL_ACADEMY',			'SEAPORT_TRAINED_CORPS_ARMY_DISCOUNT'),
('BUILDING_SFDH100_STAGE',					'SEAPORT_CITY_STAGE_FAITH_PER_POPULATION'),
('BUILDING_SFDH100_AIRFORCE_BASE',			'SFDH100_CITY_AIRFORCE_BASE_GRANT_MORE_XP_AND_STRENGTH'), */
('BUILDING_ELECTRONICS_FACTORY',	'SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6'),
('BUILDING_ELECTRONICS_FACTORY',	'SFDH100_CITY_ELECTRONICS_POPULATION_PRODUCTION'),
('BUILDING_ELECTRONICS_FACTORY',	'SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD'),
('BUILDING_STABLE',					'SFDH100_CITY_ARSENAL_CAN_SEE_HORSES'),
('BUILDING_BARRACKS',				'SFDH100_CITY_ARSENAL_CAN_SEE_IRON'),
('BUILDING_GOV_SCIENCE',			'SFDH100_GOV_SCIENCE_MANHATTAN_PROJECT_RESEARCH'),
('BUILDING_GOV_SCIENCE',			'SFDH100_GOV_SCIENCE_OPERATION_IVY_RESEARCH'),
('BUILDING_GOV_SCIENCE',			'SFDH100_GOV_SCIENCE_NUCLEAR_DEVICE_PRODUCTION'),
('BUILDING_GOV_SCIENCE',			'SFDH100_GOV_SCIENCE_THERMONUCLEAR_DEVICE_PRODUCTION'),
('BUILDING_GOV_MILITARY',			'SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_STEALTH_TECHNOLOGY'),
('BUILDING_GOV_MILITARY',			'SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_TELECOMMUNICATIONS'),
('BUILDING_AIRPORT',				'SFDH100_CITY_AIRPORT_ADJ_CENTER_REDUCE_AMENITY'),
('BUILDING_AIRPORT',				'SFDH100_CITY_AIRPORT_POPULATION_GOLD'),
('BUILDING_FOOD_MARKET',			'SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS_WITH_POWER'),
('BUILDING_FOOD_MARKET',			'SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS'),
('BUILDING_SHOPPING_MALL',			'SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS_WITH_POWER'),
('BUILDING_SHOPPING_MALL',			'SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS'),
('BUILDING_CASTLE',					'SFDH100_CITY_CASTLE_ADJUST_INFLUENCE_POINTS_PER_TURN'),
('BUILDING_GOV_CULTURE',			'SFDH100_CITY_GOV_CULTURE_DOUBLE_ARTIFACT_TOURISM'),
('BUILDING_GOV_CULTURE',			'SFDH100_CITY_GOV_CULTURE_DOUBLE_SCULPTURE_TOURISM'),
('BUILDING_GOV_CULTURE',			'SFDH100_CITY_GOV_CULTURE_DOUBLE_PORTRAIT_TOURISM'),
('BUILDING_GOV_CULTURE',			'SFDH100_CITY_GOV_CULTURE_DOUBLE_LANDSCAPE_TOURISM'),
('BUILDING_GOV_CULTURE',			'SFDH100_CITY_GOV_CULTURE_DOUBLE_RELIGIOUS_TOURISM'),
('BUILDING_GOV_SCIENCE',			'SFDH100_CITY_GOV_SCIENCE_PROJECT_PRODUCTION'),
('BUILDING_GOV_SCIENCE',			'SFDH100_CITY_GOV_SCIENCE_GRANT_UNIT_GREAT_SCIENTIST'),
('BUILDING_GOV_MILITARY',			'SFDH100_CITY_GOV_MILITARY_UNIT_MOVEMENT'),
('BUILDING_GOV_MILITARY',			'SFDH100_CITY_GOV_MILITARY_UNITS_ADJUST_HEAL_PER_TURN'),
('BUILDING_GOV_MILITARY',			'SFDH100_CITY_GOV_MILITARY_UNITS_GRANT_STRENGTH'),
('BUILDING_GOV_SPIES',				'SFDH100_CITY_GOV_SPIES_UNIT_SPY_PRODUCTION'),
('BUILDING_GOV_CITYSTATES',			'SFDH100_CITY_GOV_CITYSTATES_TWO_INFLUENCE_TOKEN'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_MILITARY_UNITS_PRODUCTION'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_LOYALTY'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_HORSES'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_IRON'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_NITER'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_COAL'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_ALUMINUM'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_OIL'),
('BUILDING_GOV_CONQUEST',			'SFDH100_CITY_GOV_CONQUEST_CAN_SEE_URANIUM'),
('BUILDING_AIRPORT',				'SFDH100_CITY_AIRPORT_INTERNATIONAL_TRADE_GOLD'),
('BUILDING_AQUARIUM',				'SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_CULTURE_WITHIN_9'),
('BUILDING_AQUARIUM',				'SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_GOLD_WITHIN_9'),
('BUILDING_AQUARIUM',				'SFDH100_CITY_AQUARIUM_FEATURE_REEF_SCIENCE_WITHIN_9'),
('BUILDING_AQUARIUM',				'SFDH100_CITY_AQUARIUM_FEATURE_REEF_GOLD_WITHIN_9'),
('BUILDING_AQUARIUM',				'SFDH100_CITY_AQUARIUM_SEA_RESOURCE_SCIENCE_WITHIN_9'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_9'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_9'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_9'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_6'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_6'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_6'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_RADIO_AMENITY_WITHIN_6'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_RADIO_GOLD_WITHIN_6'),
('BUILDING_STADIUM',				'SFDH100_CITY_STADIUM_RADIO_CULTURE_WITHIN_6'),
('BUILDING_ZOO',					'SFDH100_CITY_ZOO_LAND_TERRAIN_SCIENCE_WITHIN_6'),
('BUILDING_ZOO',					'SFDH100_CITY_ZOO_AMENITY_WITHIN_6'),
('BUILDING_BROADCAST_CENTER',		'SFDH100_CITY_BROADCAST_CENTER_CULTURE'),
--('BUILDING_AMPHITHEATER',			'SFDH100_CITY_AMPHITHEATER_CULTURE_PER_POPULATION'),
--('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_COAST_GOLD_IMPROVED'),
--('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_DISTRICT_TOURISM'),
('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD'),
('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION'),
('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD'),
('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING'),
('BUILDING_SEAPORT',				'SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM'),
('BUILDING_SHIPYARD',				'SFDH100_CITY_SHIPYARD_COAST_PRODUCTION_IMPROVED'),
('BUILDING_SHIPYARD',				'SFDH100_CITY_SHIPYARD_LUMBER_MILL_PRODUCTION_IMPROVED'),
('BUILDING_SHIPYARD',				'SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION'),
('BUILDING_LIGHTHOUSE',				'SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_CAPACITY'),
('BUILDING_LIGHTHOUSE',				'SFDH100_CITY_LIGHTHOUSE_FISHBOAT_GOLD_BONUS'),
--('BUILDING_LIGHTHOUSE',				'SFDH100_CITY_LIGHTHOUSE_COAST_FOOD_IMPROVED'),
('BUILDING_POWER_PLANT',			'SFDH100_CITY_POWER_PLANT_GAIN_GOLD_WITHIN_9'),
('BUILDING_COAL_POWER_PLANT',		'SFDH100_CITY_COAL_PLANT_GAIN_GOLD_WITHIN_6'),
('BUILDING_FACTORY',				'SFDH100_CITY_FACTORY_ADJ_REDUCE_AMENITY'),
('BUILDING_FACTORY',				'SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD'),
('BUILDING_WORKSHOP',				'SFDH100_CITY_WORKSHOP_LUXURY_PLOT_GOLD'),
('BUILDING_BANK',					'SFDH100_CITY_BANK_INTERNATIONAL_TRADE_GOLD'),
--('BUILDING_BANK',					'SFDH100_CITY_BANK_GOLD_MODIFIER'),
('BUILDING_MILITARY_ACADEMY',		'SFDH100_CITY_TRAIN_UNIT_FREE_PROMOTION'),
('BUILDING_STABLE',					'SFDH100_CITY_TRAIN_LIGHT_CAVALRY_UNIT_PRODUCTION'),
('BUILDING_STABLE',					'SFDH100_CITY_TRAIN_HEAVY_CAVALRY_UNIT_PRODUCTION'),
('BUILDING_BARRACKS',				'SFDH100_CITY_TRAIN_MELEE_UNIT_PRODUCTION'),
('BUILDING_BARRACKS',				'SFDH100_CITY_TRAIN_RANGED_UNIT_PRODUCTION'),
('BUILDING_BARRACKS',				'SFDH100_CITY_TRAIN_ANTI_CAVALRY_UNIT_PRODUCTION'),
('BUILDING_UNIVERSITY',				'SFDH100_CITY_UNIVERSITY_SCIENCE_PER_POP'),
('BUILDING_LIBRARY',				'SFDH100_CITIES_LIBRARY_PROPHET_BONUS'),
('BUILDING_LIBRARY',				'SFDH100_CITIES_LIBRARY_SCIENCE');
INSERT OR REPLACE INTO Modifiers (ModifierId,ModifierType,RunOnce,Permanent,OwnerRequirementSetId,SubjectRequirementSetId) VALUES
('SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6',					'MODIFIER_SFDH100_DISTRICTS_ATTACH_MODIFIER',						0,	0,	'SFDH100_HAS_COMPUTERS_REQUIREMENTS','SFDH100_BUILDING_ELECTRONICS_FACTORY_WITHIN_6'),
('SFDH100_CITY_ELECTRONICS_POPULATION_PRODUCTION',				'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								NULL),
('SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD',	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'BUILDING_IS_FACTORY'),
('SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER','MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,	0,	NULL,								NULL),
('SFDH100_GOV_SCIENCE_MANHATTAN_PROJECT_RESEARCH',				'MODIFIER_PLAYER_CITIES_ADJUST_PROJECT_PRODUCTION',					0,	0,	NULL,								NULL),
('SFDH100_GOV_SCIENCE_OPERATION_IVY_RESEARCH',					'MODIFIER_PLAYER_CITIES_ADJUST_PROJECT_PRODUCTION',					0,	0,	NULL,								NULL),
('SFDH100_GOV_SCIENCE_NUCLEAR_DEVICE_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ADJUST_PROJECT_PRODUCTION',					0,	0,	NULL,								NULL),
('SFDH100_GOV_SCIENCE_THERMONUCLEAR_DEVICE_PRODUCTION',			'MODIFIER_PLAYER_CITIES_ADJUST_PROJECT_PRODUCTION',					0,	0,	NULL,								NULL),
('SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_STEALTH_TECHNOLOGY',	'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',						1,	1,	NULL,								NULL),
('SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_TELECOMMUNICATIONS',	'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',						1,	1,	NULL,								NULL),
('SFDH100_CITY_AIRPORT_ADJ_CENTER_REDUCE_AMENITY',				'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					0,	0,	NULL,								'SFDH100_AERODROME_ADJACENT_TO_CITY_CENTER'),
('SFDH100_CITY_AIRPORT_POPULATION_GOLD',						'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								NULL),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS_WITH_POWER',		'MODIFIER_SFDH100_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,	0,	'CITY_IS_POWERED',					'DISTRICT_IS_NEIGHBORHOOD'),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS',					'MODIFIER_SFDH100_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,	0,	NULL,								'DISTRICT_IS_NEIGHBORHOOD'),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS_WITH_POWER',	'MODIFIER_SFDH100_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,	0,	'CITY_IS_POWERED',					'DISTRICT_IS_NEIGHBORHOOD'),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS',				'MODIFIER_SFDH100_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,	0,	NULL,								'DISTRICT_IS_NEIGHBORHOOD'),
('SFDH100_CITY_CASTLE_ADJUST_INFLUENCE_POINTS_PER_TURN',		'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN',					0,	0,	NULL,								NULL),
('SFDH100_CITY_ART_COLLEGE_RADIO_MUSICIAN_POINT',				'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS',						0,	0,	NULL,								'SFDH100_HAS_RADIO'),
('SFDH100_CITY_CAREER_COLLEGE_SCIENCE_POPULATION',				'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								NULL),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_PORDUCTION',				'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_UNIT_GRANT_MORE_XP',		'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',				0,	0,	NULL,								NULL),
('SFDH100_CITY_ARSENAL_CAN_SEE_HORSES',							'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_HOURSES'),
('SFDH100_CITY_ARSENAL_CAN_SEE_IRON',							'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_IRON'),
('SFDH100_CITY_ARSENAL_CAN_SEE_NITER',							'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_NITER'),
('SFDH100_CITY_ARSENAL_CAN_SEE_COAL',							'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_COAL'),
('SFDH100_CITY_ARSENAL_CAN_SEE_ALUMINUM',						'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_ALUMINUM'),
('SFDH100_CITY_ARSENAL_CAN_SEE_OIL',							'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_OIL'),
('SFDH100_CITY_ARSENAL_ADJUST_RESOURCE_STOCKPILE_CAP',			'MODIFIER_PLAYER_ADJUST_RESOURCE_STOCKPILE_CAP',					0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_MELEE_PRODUCTION',				'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RANGED_PRODUCTION',				'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_CARRIER_PRODUCTION',			'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RAIDER_PRODUCTION',				'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_MORE_XP',			'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',				0,	0,	NULL,								NULL),
('SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_EXTRA_HEAL',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',								0,	0,	NULL,								'SFDH100_BUILDING_NAVAL_BASE_WITHIN_3'),
('SEAPORT_CITY_NAVAL_ACADEMY_FREE_PROMOTION',					'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE',				0,	0,	NULL,								'SFDH100_UNIT_IS_NAVAL'),
('SFDH100_CITY_NAVAL_ACADEMY_GRANT_MORE_XP_AND_STRENGTH',		'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',				0,	0,	NULL,								NULL),
('SEAPORT_CITY_STAGE_FAITH_PER_POPULATION',						'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								NULL),
('SFDH100_CITY_AIRFORCE_BASE_GRANT_MORE_XP_AND_STRENGTH',		'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',				0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_ARTIFACT_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_SCULPTURE_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_PORTRAIT_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_LANDSCAPE_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_RELIGIOUS_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_SCIENCE_PROJECT_PRODUCTION',					'MODIFIER_PLAYER_CITIES_ADJUST_ALL_PROJECTS_PRODUCTION',			0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_SCIENCE_GRANT_UNIT_GREAT_SCIENTIST',			'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',			1,	1,	NULL,								NULL),
('SFDH100_CITY_GOV_MILITARY_UNIT_MOVEMENT',						'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',							0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_MILITARY_UNITS_ADJUST_HEAL_PER_TURN',		'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN',						0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_MILITARY_UNITS_GRANT_STRENGTH',				'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',								0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_SPIES_UNIT_SPY_PRODUCTION',					'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION',						0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CITYSTATES_TWO_INFLUENCE_TOKEN',				'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN',							1,	1,	NULL,								NULL),
('SFDH100_CITY_GOV_CONQUEST_MILITARY_UNITS_PRODUCTION',			'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION',			0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CONQUEST_LOYALTY',							'MODIFIER_PLAYER_CITIES_ADJUST_IDENTITY_PER_TURN',					0,	0,	NULL,								NULL),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_HORSES',					'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_HOURSES'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_IRON',						'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_IRON'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_NITER',						'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_NITER'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_COAL',						'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_COAL'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_ALUMINUM',					'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_ALUMINUM'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_OIL',						'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_OIL'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_URANIUM',					'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',			0,	0,	NULL,								'SFDH100_PLAYER_CAN_SEE_URANIUM'),
('SFDH100_CITY_AIRPORT_INTERNATIONAL_TRADE_GOLD',				'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,	0,	NULL,								NULL),
('SFDH100_CITY_BROADCAST_CENTER_CULTURE',						'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					0,	0,	NULL,								'SFDH100_HAS_SATELLITES'),
('SFDH100_CITY_AMPHITHEATER_CULTURE_PER_POPULATION',			'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								NULL),
--('SFDH100_CITY_SEAPORT_COAST_GOLD_IMPROVED',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'SFDH100_PLOT_HAS_COAST_IMPROVEMENT'),
--('SFDH100_CITY_SEAPORT_DISTRICT_TOURISM',						'MODIFIER_CITY_DISTRICTS_ADJUST_TOURISM_CHANGE',					0,	0,	NULL,								'DISTRICT_IS_HARBOR'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD',							'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD_MODIFIER',				'MODIFIER_BUILDING_YIELD_CHANGE',									0,	0,	NULL,								NULL),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION',					'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION_MODIFIER',			'MODIFIER_BUILDING_YIELD_CHANGE',									0,	0,	NULL,								NULL),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD',							'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD_MODIFIER',				'MODIFIER_BUILDING_YIELD_CHANGE',									0,	0,	NULL,								NULL),
('SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING',						'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING_MODIFIER',				'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING',						0,	0,	NULL,								NULL),
('SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM',						'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM_MODIFIER',				'MODIFIER_PLAYER_DISTRICT_ADJUST_TOURISM_CHANGE',					0,	0,	NULL,								NULL),
('SFDH100_CITY_SHIPYARD_COAST_PRODUCTION_IMPROVED',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'SFDH100_PLOT_HAS_COAST_IMPROVEMENT'),
('SFDH100_CITY_SHIPYARD_LUMBER_MILL_PRODUCTION_IMPROVED',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'SFDH100_PLOT_HAS_LUMBER_MILL_IMPROVEMENT'),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'SFDH100_BUILDING_SHIPYARD_WITHIN_6'),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION_MODIFIER',		'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'SFDH100_BUILDING_SHIPYARD_WITHIN_6'),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION_MODIFIER',		'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'SFDH100_BUILDING_SHIPYARD_WITHIN_6'),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION_MODIFIER',		'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'SFDH100_BUILDING_SHIPYARD_WITHIN_6'),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION_MODIFIER',		'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_CAPACITY',		'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',								0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_MODIFIER',		'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',						0,	0,	NULL,								NULL),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_DOMESTICGOLD_BONUS',		'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC',		0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_INTERNATIONALGOLD_BONUS',	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,	0,	NULL,								'PLOT_IS_OR_ADJACENT_TO_COAST'),
('SFDH100_CITY_LIGHTHOUSE_FISHBOAT_GOLD_BONUS',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'PLOT_HAS_FISHINGBOATS_REQUIREMENTS'),
('SFDH100_CITY_LIGHTHOUSE_COAST_FOOD_IMPROVED',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'SFDH100_PLOT_HAS_COAST_IMPROVEMENT'),
('SFDH100_CITY_FACTORY_ADJ_REDUCE_AMENITY',						'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					0,	0,	NULL,								'SFDH100_INDUSTRIAL_ZONE_ADJACENT_TO_CITY_CENTER'),
('SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							0,	0,	NULL,								'BUILDING_IS_FACTORY'),
('SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER',		'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,	0,	NULL,								NULL),
('SFDH100_CITY_WORKSHOP_LUXURY_PLOT_GOLD',						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',						0,	0,	NULL,								'SFDH100_CITY_PLOT_HAS_LUXURY'),
('SFDH100_CITY_BANK_INTERNATIONAL_TRADE_GOLD',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,	0,	NULL,								NULL),
('SFDH100_CITY_BANK_GOLD_MODIFIER',								'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',					0,	0,	NULL,								NULL),
('SFDH100_CITY_TRAIN_UNIT_FREE_PROMOTION',						'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE',				0,	0,	NULL,								'ARMORY_LAND_REQUIREMENTS'),
('SFDH100_CITY_TRAIN_LIGHT_CAVALRY_UNIT_PRODUCTION',			'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_TRAIN_HEAVY_CAVALRY_UNIT_PRODUCTION',			'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_TRAIN_MELEE_UNIT_PRODUCTION',					'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_TRAIN_RANGED_UNIT_PRODUCTION',					'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_TRAIN_ANTI_CAVALRY_UNIT_PRODUCTION',				'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',				0,	0,	NULL,								NULL),
('SFDH100_CITY_UNIVERSITY_SCIENCE_PER_POP',						'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',			0,	0,	NULL,								'SFDH100_CITY_HAS_8_POPULATION'),
('SFDH100_CITIES_LIBRARY_PROPHET_BONUS',						'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT',					0,	0,	'PLAYER_FOUNDED_RELIGION_REQUIREMENTS',	NULL),
('SFDH100_CITIES_LIBRARY_SCIENCE',								'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',				1,	1,	NULL,								NULL);
INSERT OR REPLACE INTO Modifiers (ModifierId,ModifierType,SubjectStackLimit,OwnerRequirementSetId,SubjectRequirementSetId) VALUES
('SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6_MODIFIER',			'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_CHANGE',						1,				NULL,								NULL),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_CULTURE_WITHIN_9',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_AQUARIUM_HAS_RESOURCE_SHIPWRECK_WITHIN_9'),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_GOLD_WITHIN_9',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_AQUARIUM_HAS_RESOURCE_SHIPWRECK_WITHIN_9'),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_SCIENCE_WITHIN_9',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_AQUARIUM_HAS_FEATURE_REEF_WITHIN_9'),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_GOLD_WITHIN_9',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_AQUARIUM_HAS_FEATURE_REEF_WITHIN_9'),
('SFDH100_CITY_AQUARIUM_SEA_RESOURCE_SCIENCE_WITHIN_9',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_AQUARIUM_HAS_SEA_RESOURCE_WITHIN_9'),
('SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_9',			'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_9'),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_9',				'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_9'),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_9',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_9'),
('SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_6',			'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_6',				'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_6',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_SATELLITES_IS_POWERED',	'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_STADIUM_RADIO_AMENITY_WITHIN_6',					'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					1,				'SFDH100_RADIO_IS_POWERED',			'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_STADIUM_RADIO_GOLD_WITHIN_6',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_RADIO_IS_POWERED',			'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_STADIUM_RADIO_CULTURE_WITHIN_6',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				'SFDH100_RADIO_IS_POWERED',			'SFDH100_BUILDING_STADIUM_WITHIN_6'),
('SFDH100_CITY_ZOO_LAND_TERRAIN_SCIENCE_WITHIN_6',				'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								1,				NULL,								'SFDH100_BUILDING_ZOO_HAS_LAND_FEATURE_WITHIN_6'),
('SFDH100_CITY_ZOO_AMENITY_WITHIN_6',							'MODIFIER_PLAYER_DISTRICT_ADJUST_DISTRICT_AMENITY',					1,				NULL,								'SFDH100_BUILDING_ZOO_HAS_CITY_CENTER_WITHIN_6'),
('SFDH100_CITY_POWER_PLANT_GAIN_GOLD_WITHIN_9',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				NULL,								'SFDH100_BUILDING_POWER_PLANT_PLANT_WITHIN_9'),
('SFDH100_CITY_COAL_PLANT_GAIN_GOLD_WITHIN_6',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',					1,				NULL,								'SFDH100_BUILDING_COAL_POWER_PLANT_WITHIN_6');
INSERT OR REPLACE INTO ModifierArguments (ModifierId,Name,Value) VALUES
('SFDH100_CITY_ELECTRONICS_POPULATION_PRODUCTION',				'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_CITY_ELECTRONICS_POPULATION_PRODUCTION',				'Amount',				0.5),
('SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD',		'ModifierId',			'SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER'),
('SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER','YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_ELECTRONICS_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER','Amount',				3),
('SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6',					'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_CSFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6_MODIFIEROAST_FOOD_MODIFIER'),
('SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6_MODIFIER',			'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_ELECTRONICS_CULTURE_WITHIN_6_MODIFIER',			'Amount',				5),
('SFDH100_GOV_SCIENCE_MANHATTAN_PROJECT_RESEARCH',				'ProjectType',			'PROJECT_MANHATTAN_PROJECT'),
('SFDH100_GOV_SCIENCE_MANHATTAN_PROJECT_RESEARCH',				'Amount',				20),
('SFDH100_GOV_SCIENCE_OPERATION_IVY_RESEARCH',					'ProjectType',			'PROJECT_OPERATION_IVY'),
('SFDH100_GOV_SCIENCE_OPERATION_IVY_RESEARCH',					'Amount',				20),
('SFDH100_GOV_SCIENCE_NUCLEAR_DEVICE_PRODUCTION',				'ProjectType',			'PROJECT_BUILD_NUCLEAR_DEVICE'),
('SFDH100_GOV_SCIENCE_NUCLEAR_DEVICE_PRODUCTION',				'Amount',				20),
('SFDH100_GOV_SCIENCE_THERMONUCLEAR_DEVICE_PRODUCTION',			'ProjectType',			'PROJECT_BUILD_THERMONUCLEAR_DEVICE'),
('SFDH100_GOV_SCIENCE_THERMONUCLEAR_DEVICE_PRODUCTION',			'Amount',				20),
('SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_STEALTH_TECHNOLOGY',	'TechType',				'TECH_STEALTH_TECHNOLOGY'),
('SFDH100_GOV_MILITARY_GRANT_BOOST_TECH_TELECOMMUNICATIONS',	'TechType',				'TECH_TELECOMMUNICATIONS'),
('SFDH100_CITY_AIRPORT_ADJ_CENTER_REDUCE_AMENITY',				'Amount',				-1),
('SFDH100_CITY_AIRPORT_POPULATION_GOLD',						'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_AIRPORT_POPULATION_GOLD',						'Amount',				0.5),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS_WITH_POWER',		'YieldType',			'YIELD_FOOD'),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS_WITH_POWER',		'Amount',				4),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS',					'YieldType',			'YIELD_FOOD'),
('SFDH100_FOOD_MARKET_NEIGHBORHOOD_FOOD_BONUS',					'Amount',				2),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS_WITH_POWER',	'YieldType',			'YIELD_GOLD'),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS_WITH_POWER',	'Amount',				2),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS',				'YieldType',			'YIELD_GOLD'),
('SFDH100_SHOPPING_MALL_NEIGHBORHOOD_GOLD_BONUS',				'Amount',				4),
('SFDH100_CITY_CASTLE_ADJUST_INFLUENCE_POINTS_PER_TURN',		'Amount',				1),
('SFDH100_CITY_ART_COLLEGE_RADIO_MUSICIAN_POINT',				'GreatPersonClassType',	'GREAT_PERSON_CLASS_MUSICIAN'),
('SFDH100_CITY_ART_COLLEGE_RADIO_MUSICIAN_POINT',				'Amount',				1),
('SFDH100_CITY_CAREER_COLLEGE_SCIENCE_POPULATION',				'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_CITY_CAREER_COLLEGE_SCIENCE_POPULATION',				'Amount',				0.5),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_PORDUCTION',				'UnitPromotionClass',	'PROMOTION_CLASS_SIEGE'),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_PORDUCTION',				'EraType',				'NO_ERA'),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_PORDUCTION',				'Amount',				50),
('SFDH100_CITY_SIEGE_WEAPON_FACTORY_UNIT_GRANT_MORE_XP',		'AbilityType',			'ABILITY_SFDH100_SIEGE_WEAPON_FACTORY_UNIT_MORE_XP'),
('SFDH100_CITY_ARSENAL_CAN_SEE_HORSES',							'ResourceType',			'RESOURCE_HORSES'),
('SFDH100_CITY_ARSENAL_CAN_SEE_HORSES',							'Amount',				2),
('SFDH100_CITY_ARSENAL_CAN_SEE_IRON',							'ResourceType',			'RESOURCE_IRON'),
('SFDH100_CITY_ARSENAL_CAN_SEE_IRON',							'Amount',				2),
('SFDH100_CITY_ARSENAL_CAN_SEE_NITER',							'ResourceType',			'RESOURCE_NITER'),
('SFDH100_CITY_ARSENAL_CAN_SEE_NITER',							'Amount',				2),
('SFDH100_CITY_ARSENAL_CAN_SEE_COAL',							'ResourceType',			'RESOURCE_COAL'),
('SFDH100_CITY_ARSENAL_CAN_SEE_COAL',							'Amount',				2),
('SFDH100_CITY_ARSENAL_CAN_SEE_ALUMINUM',						'ResourceType',			'RESOURCE_ALUMINUM'),
('SFDH100_CITY_ARSENAL_CAN_SEE_ALUMINUM',						'Amount',				2),
('SFDH100_CITY_ARSENAL_CAN_SEE_OIL',							'ResourceType',			'RESOURCE_OIL'),
('SFDH100_CITY_ARSENAL_CAN_SEE_OIL',							'Amount',				2),
('SFDH100_CITY_ARSENAL_ADJUST_RESOURCE_STOCKPILE_CAP',			'Amount',				20),
('SFDH100_CITY_NAVAL_BASE_NAVAL_MELEE_PRODUCTION',				'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_MELEE'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_MELEE_PRODUCTION',				'EraType',				'NO_ERA'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_MELEE_PRODUCTION',				'Amount',				10),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RANGED_PRODUCTION',				'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_RANGED'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RANGED_PRODUCTION',				'EraType',				'NO_ERA'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RANGED_PRODUCTION',				'Amount',				10),
('SFDH100_CITY_NAVAL_BASE_NAVAL_CARRIER_PRODUCTION',			'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_CARRIER'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_CARRIER_PRODUCTION',			'EraType',				'NO_ERA'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_CARRIER_PRODUCTION',			'Amount',				10),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RAIDER_PRODUCTION',				'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_RAIDER'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RAIDER_PRODUCTION',				'EraType',				'NO_ERA'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_RAIDER_PRODUCTION',				'Amount',				10),
('SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_MORE_XP',			'AbilityType',			'ABILITY_SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_MORE_XP'),
('SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_GRANT_EXTRA_HEAL',			'AbilityType',			'ABILITY_SFDH100_CITY_NAVAL_BASE_NAVAL_UNIT_EXTRA_HEAL'),
('SEAPORT_CITY_NAVAL_ACADEMY_FREE_PROMOTION',					'Amount',				-1),
('SFDH100_CITY_NAVAL_ACADEMY_GRANT_MORE_XP_AND_STRENGTH',		'AbilityType',			'ABILITY_SFDH100_NAVAL_ACADEMY_MORE_XP_AND_STRENGTH'),
('SEAPORT_CITY_STAGE_FAITH_PER_POPULATION',						'YieldType',			'YIELD_FAITH'),
('SEAPORT_CITY_STAGE_FAITH_PER_POPULATION',						'Amount',				0.33),
('SFDH100_CITY_AIRFORCE_BASE_GRANT_MORE_XP_AND_STRENGTH',		'AbilityType',			'ABILITY_SFDH100_AIRFORCE_BASE_MORE_XP_AND_STRENGTH'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_ARTIFACT_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_ARTIFACT'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_ARTIFACT_TOURISM',			'ScalingFactor',		200),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_SCULPTURE_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_SCULPTURE'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_SCULPTURE_TOURISM',			'ScalingFactor',		200),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_PORTRAIT_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_PORTRAIT'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_PORTRAIT_TOURISM',			'ScalingFactor',		200),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_LANDSCAPE_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_LANDSCAPE'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_LANDSCAPE_TOURISM',			'ScalingFactor',		200),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_RELIGIOUS_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_RELIGIOUS'),
('SFDH100_CITY_GOV_CULTURE_DOUBLE_RELIGIOUS_TOURISM',			'ScalingFactor',		200),
('SFDH100_CITY_GOV_SCIENCE_PROJECT_PRODUCTION',					'Amount',				30),
('SFDH100_CITY_GOV_SCIENCE_GRANT_UNIT_GREAT_SCIENTIST',			'GreatPersonClassType',	'GREAT_PERSON_CLASS_SCIENTIST'),
('SFDH100_CITY_GOV_SCIENCE_GRANT_UNIT_GREAT_SCIENTIST',			'Amount',				1),
('SFDH100_CITY_GOV_MILITARY_UNIT_MOVEMENT',						'Amount',				1),
('SFDH100_CITY_GOV_MILITARY_UNITS_ADJUST_HEAL_PER_TURN',		'Type',					'ALL'),
('SFDH100_CITY_GOV_MILITARY_UNITS_ADJUST_HEAL_PER_TURN',		'Amount',				5),
('SFDH100_CITY_GOV_MILITARY_UNITS_GRANT_STRENGTH',				'AbilityType',			'ABILITY_SFDH100_CITY_GOV_MILITARY_UNIT_STRENGTH'),
('SFDH100_CITY_GOV_SPIES_UNIT_SPY_PRODUCTION',					'UnitType',				'UNIT_SPY'),
('SFDH100_CITY_GOV_SPIES_UNIT_SPY_PRODUCTION',					'Amount',				20),
('SFDH100_CITY_GOV_CITYSTATES_TWO_INFLUENCE_TOKEN',				'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_HORSES',					'ResourceType',			'RESOURCE_HORSES'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_HORSES',					'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_IRON',						'ResourceType',			'RESOURCE_IRON'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_IRON',						'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_NITER',						'ResourceType',			'RESOURCE_NITER'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_NITER',						'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_COAL',						'ResourceType',			'RESOURCE_COAL'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_COAL',						'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_ALUMINUM',					'ResourceType',			'RESOURCE_ALUMINUM'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_ALUMINUM',					'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_OIL',						'ResourceType',			'RESOURCE_OIL'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_OIL',						'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_URANIUM',					'ResourceType',			'RESOURCE_URANIUM'),
('SFDH100_CITY_GOV_CONQUEST_CAN_SEE_URANIUM',					'Amount',				2),
('SFDH100_CITY_GOV_CONQUEST_MILITARY_UNITS_PRODUCTION',			'Amount',				10),
('SFDH100_CITY_GOV_CONQUEST_LOYALTY',							'Amount',				8),
('SFDH100_CITY_AIRPORT_INTERNATIONAL_TRADE_GOLD',				'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_AIRPORT_INTERNATIONAL_TRADE_GOLD',				'Amount',				3),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_CULTURE_WITHIN_9',	'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_CULTURE_WITHIN_9',	'Amount',				2),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_GOLD_WITHIN_9',		'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_AQUARIUM_RESOURCE_SHIPWRECK_GOLD_WITHIN_9',		'Amount',				2),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_SCIENCE_WITHIN_9',			'YieldType',			'YIELD_SCIENCE'),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_SCIENCE_WITHIN_9',			'Amount',				2),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_GOLD_WITHIN_9',			'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_AQUARIUM_FEATURE_REEF_GOLD_WITHIN_9',			'Amount',				5),
('SFDH100_CITY_AQUARIUM_SEA_RESOURCE_SCIENCE_WITHIN_9',			'YieldType',			'YIELD_SCIENCE'),
('SFDH100_CITY_AQUARIUM_SEA_RESOURCE_SCIENCE_WITHIN_9',			'Amount',				1),
('SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_9',			'Amount',				2),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_9',				'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_9',				'Amount',				2),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_9',			'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_9',			'Amount',				2),
('SFDH100_CITY_STADIUM_SATELLITES_AMENITY_WITHIN_6',			'Amount',				1),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_6',				'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_STADIUM_SATELLITES_GOLD_WITHIN_6',				'Amount',				1),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_6',			'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_STADIUM_SATELLITES_CULTURE_WITHIN_6',			'Amount',				1),
('SFDH100_CITY_STADIUM_RADIO_AMENITY_WITHIN_6',					'Amount',				1),
('SFDH100_CITY_STADIUM_RADIO_GOLD_WITHIN_6',					'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_STADIUM_RADIO_GOLD_WITHIN_6',					'Amount',				1),
('SFDH100_CITY_STADIUM_RADIO_CULTURE_WITHIN_6',					'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_STADIUM_RADIO_CULTURE_WITHIN_6',					'Amount',				1),
('SFDH100_CITY_ZOO_LAND_TERRAIN_SCIENCE_WITHIN_6',				'YieldType',			'YIELD_SCIENCE'),
('SFDH100_CITY_ZOO_LAND_TERRAIN_SCIENCE_WITHIN_6',				'Amount',				1),
('SFDH100_CITY_ZOO_AMENITY_WITHIN_6',							'Amount',				1),
('SFDH100_CITY_BROADCAST_CENTER_CULTURE',						'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_BROADCAST_CENTER_CULTURE',						'Amount',				1),
('SFDH100_CITY_AMPHITHEATER_CULTURE_PER_POPULATION',			'YieldType',			'YIELD_CULTURE'),
('SFDH100_CITY_AMPHITHEATER_CULTURE_PER_POPULATION',			'Amount',				0.33),
--('SFDH100_CITY_SEAPORT_COAST_GOLD_IMPROVED',					'YieldType',			'YIELD_GOLD'),
--('SFDH100_CITY_SEAPORT_COAST_GOLD_IMPROVED',					'Amount',				2),
--('SFDH100_CITY_SEAPORT_DISTRICT_TOURISM',						'Amount',				10),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD',							'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD_MODIFIER'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD_MODIFIER',				'BuildingType',			'BUILDING_SEAPORT'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD_MODIFIER',				'YieldType',			'YIELD_FOOD'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_FOOD_MODIFIER',				'Amount',				2),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION',					'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION_MODIFIER'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION_MODIFIER',			'BuildingType',			'BUILDING_SEAPORT'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION_MODIFIER',			'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_PRODUCTION_MODIFIER',			'Amount',				2),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD',							'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD_MODIFIER'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD_MODIFIER',				'BuildingType',			'BUILDING_SEAPORT'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD_MODIFIER',				'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_GOLD_MODIFIER',				'Amount',				6),
('SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING',						'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING_MODIFIER'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_HOUSING_MODIFIER',				'Amount',				2),
('SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM',						'ModifierId',			'SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM_MODIFIER'),
('SFDH100_CITY_SEAPORT_ADJ_COAST_TOURISM_MODIFIER',				'Amount',				6),
('SFDH100_CITY_SHIPYARD_COAST_PRODUCTION_IMPROVED',				'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_CITY_SHIPYARD_COAST_PRODUCTION_IMPROVED',				'Amount',				1),
('SFDH100_CITY_SHIPYARD_LUMBER_MILL_PRODUCTION_IMPROVED',		'YieldType',			'YIELD_PRODUCTION'),
('SFDH100_CITY_SHIPYARD_LUMBER_MILL_PRODUCTION_IMPROVED',		'Amount',				1),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION',				'ModifierId',			'SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION_MODIFIER'),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION_MODIFIER',		'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_MELEE'),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION_MODIFIER',		'EraType',				'NO_ERA'),
('SFDH100_CITY_SHIPYARD_NAVAL_MELEE_PRODUCTION_MODIFIER',		'Amount',				20),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION',				'ModifierId',			'SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION_MODIFIER'),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION_MODIFIER',		'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_RANGED'),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION_MODIFIER',		'EraType',				'NO_ERA'),
('SFDH100_CITY_SHIPYARD_NAVAL_RANGED_PRODUCTION_MODIFIER',		'Amount',				20),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION',				'ModifierId',			'SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION_MODIFIER'),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION_MODIFIER',		'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_CARRIER'),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION_MODIFIER',		'EraType',				'NO_ERA'),
('SFDH100_CITY_SHIPYARD_NAVAL_CARRIER_PRODUCTION_MODIFIER',		'Amount',				20),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION',				'ModifierId',			'SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION_MODIFIER'),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION_MODIFIER',		'UnitPromotionClass',	'PROMOTION_CLASS_NAVAL_RAIDER'),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION_MODIFIER',		'EraType',				'NO_ERA'),
('SFDH100_CITY_SHIPYARD_NAVAL_RAIDER_PRODUCTION_MODIFIER',		'Amount',				20),
('SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_CAPACITY',		'ModifierId',			'SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_MODIFIER'),
('SFDH100_CITY_LIGHTHOUSE_ADJ_COAST_TRADE_ROUTE_MODIFIER',		'Amount',				1),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_DOMESTICGOLD_BONUS',		'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_DOMESTICGOLD_BONUS',		'Amount',				2),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_INTERNATIONALGOLD_BONUS',	'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_LIGHTHOUSE_TRADE_ROUTE_INTERNATIONALGOLD_BONUS',	'Amount',				2),
('SFDH100_CITY_LIGHTHOUSE_FISHBOAT_GOLD_BONUS',					'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_LIGHTHOUSE_FISHBOAT_GOLD_BONUS',					'Amount',				1),
('SFDH100_CITY_LIGHTHOUSE_COAST_FOOD_IMPROVED',					'YieldType',			'YIELD_FOOD'),
('SFDH100_CITY_LIGHTHOUSE_COAST_FOOD_IMPROVED',					'Amount',				1),
('SFDH100_CITY_POWER_PLANT_GAIN_GOLD_WITHIN_9',					'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_POWER_PLANT_GAIN_GOLD_WITHIN_9',					'Amount',				5),
('SFDH100_CITY_COAL_PLANT_GAIN_GOLD_WITHIN_6',					'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_COAL_PLANT_GAIN_GOLD_WITHIN_6',					'Amount',				5),
('SFDH100_CITY_FACTORY_ADJ_REDUCE_AMENITY',						'Amount',				-1),
('SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD',				'ModifierId',			'SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER'),
('SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER',		'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_FACTORY_INTERNATIONAL_TRADE_GOLD_MODIFIER',		'Amount',				2),
('SFDH100_CITY_WORKSHOP_LUXURY_PLOT_GOLD',						'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_WORKSHOP_LUXURY_PLOT_GOLD',						'Amount',				1),
('SFDH100_CITY_BANK_INTERNATIONAL_TRADE_GOLD',					'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_BANK_INTERNATIONAL_TRADE_GOLD',					'Amount',				3),
('SFDH100_CITY_BANK_GOLD_MODIFIER',								'YieldType',			'YIELD_GOLD'),
('SFDH100_CITY_BANK_GOLD_MODIFIER',								'Amount',				10),
('SFDH100_CITY_TRAIN_UNIT_FREE_PROMOTION',						'Amount',				-1),
('SFDH100_CITY_TRAIN_LIGHT_CAVALRY_UNIT_PRODUCTION',			'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY'),
('SFDH100_CITY_TRAIN_LIGHT_CAVALRY_UNIT_PRODUCTION',			'EraType',				'NO_ERA'),
('SFDH100_CITY_TRAIN_LIGHT_CAVALRY_UNIT_PRODUCTION',			'Amount',				10),
('SFDH100_CITY_TRAIN_HEAVY_CAVALRY_UNIT_PRODUCTION',			'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY'),
('SFDH100_CITY_TRAIN_HEAVY_CAVALRY_UNIT_PRODUCTION',			'EraType',				'NO_ERA'),
('SFDH100_CITY_TRAIN_HEAVY_CAVALRY_UNIT_PRODUCTION',			'Amount',				10),
('SFDH100_CITY_TRAIN_MELEE_UNIT_PRODUCTION',					'UnitPromotionClass',	'PROMOTION_CLASS_MELEE'),
('SFDH100_CITY_TRAIN_MELEE_UNIT_PRODUCTION',					'EraType',				'NO_ERA'),
('SFDH100_CITY_TRAIN_MELEE_UNIT_PRODUCTION',					'Amount',				10),
('SFDH100_CITY_TRAIN_RANGED_UNIT_PRODUCTION',					'UnitPromotionClass',	'PROMOTION_CLASS_RANGED'),
('SFDH100_CITY_TRAIN_RANGED_UNIT_PRODUCTION',					'EraType',				'NO_ERA'),
('SFDH100_CITY_TRAIN_RANGED_UNIT_PRODUCTION',					'Amount',				10),
('SFDH100_CITY_TRAIN_ANTI_CAVALRY_UNIT_PRODUCTION',				'UnitPromotionClass',	'PROMOTION_CLASS_ANTI_CAVALRY'),
('SFDH100_CITY_TRAIN_ANTI_CAVALRY_UNIT_PRODUCTION',				'EraType',				'NO_ERA'),
('SFDH100_CITY_TRAIN_ANTI_CAVALRY_UNIT_PRODUCTION',				'Amount',				10),
('SFDH100_CITY_UNIVERSITY_SCIENCE_PER_POP',						'YieldType',			'YIELD_SCIENCE'),
('SFDH100_CITY_UNIVERSITY_SCIENCE_PER_POP',						'Amount',				0.5),
('SFDH100_CITIES_LIBRARY_PROPHET_BONUS',						'GreatPersonClassType',	'GREAT_PERSON_CLASS_PROPHET'),
('SFDH100_CITIES_LIBRARY_PROPHET_BONUS',						'Amount',				1),
('SFDH100_CITIES_LIBRARY_SCIENCE',								'BuildingType',			'BUILDING_LIBRARY'),
('SFDH100_CITIES_LIBRARY_SCIENCE',								'YieldType',			'YIELD_SCIENCE'),
('SFDH100_CITIES_LIBRARY_SCIENCE',								'Amount',				0.5);
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId)
SELECT 			'BUILDING_ARMORY',					'SFDH100_CITY_TRAIN_'||PromotionClassType||'_PRODUCTION' 						FROM UnitPromotionClasses	WHERE PromotionClassType IN('PROMOTION_CLASS_RECON','PROMOTION_CLASS_MELEE','PROMOTION_CLASS_RANGED','PROMOTION_CLASS_ANTI_CAVALRY','PROMOTION_CLASS_LIGHT_CAVALRY','PROMOTION_CLASS_HEAVY_CAVALRY','PROMOTION_CLASS_SUPPORT')
UNION SELECT	CivUniqueBuildingType,				'SFDH100_CITY_BANK_INTERNATIONAL_TRADE_GOLD'									FROM BuildingReplaces		WHERE ReplacesBuildingType IS 'BUILDING_BANK'
UNION SELECT	'BUILDING_ZOO',						'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_CULTURE' 					FROM TerrainClasses
UNION SELECT	'BUILDING_ZOO',						'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_TOURISM' 					FROM TerrainClasses
UNION SELECT	'BUILDING_ZOO',						'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_BUILDING_SCIENCE' 					FROM TerrainClasses;
--UNION SELECT	'BUILDING_SFDH100_STAGE',			'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_CULTURE'					FROM GreatWorkObjectTypes
--UNION SELECT	'BUILDING_SFDH100_STAGE',			'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_TOURISM'					FROM GreatWorkObjectTypes;
INSERT OR REPLACE INTO TechnologyModifiers (TechnologyType,ModifierId)
SELECT			'TECH_ECONOMICS',													'SFDH100_CITY_STOCK_EXCHANGE_IMPROVE_'||ResourceType||'_GOLD'										FROM Resources			  WHERE ResourceClassType IS 'RESOURCECLASS_LUXURY' OR ResourceClassType IS 'RESOURCECLASS_STRATEGIC';
INSERT OR REPLACE INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId)
SELECT 			'SFDH100_CITY_TRAIN_'||PromotionClassType||'_PRODUCTION' ,			'MODIFIER_SFDH100_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION',	NULL 										FROM UnitPromotionClasses WHERE PromotionClassType IN('PROMOTION_CLASS_RECON','PROMOTION_CLASS_MELEE','PROMOTION_CLASS_RANGED','PROMOTION_CLASS_ANTI_CAVALRY','PROMOTION_CLASS_LIGHT_CAVALRY','PROMOTION_CLASS_HEAVY_CAVALRY','PROMOTION_CLASS_SUPPORT')
UNION SELECT	'SFDH100_CITY_STOCK_EXCHANGE_IMPROVE_'||ResourceType||'_GOLD',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',	'SFDH100_HAS_IMPROVED_'||ResourceType		FROM Resources			  WHERE ResourceClassType IS 'RESOURCECLASS_LUXURY' OR ResourceClassType IS 'RESOURCECLASS_STRATEGIC'
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_CULTURE',		'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',			'SFDH100_PLAYER_HAS_HUMANISM'				FROM GreatWorkObjectTypes
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_TOURISM',		'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					'SFDH100_PLAYER_HAS_HUMANISM'				FROM GreatWorkObjectTypes
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_CULTURE',		'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					'SFDH100_CITY_ON_'||TerrainClassType		FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_TOURISM',		'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					'SFDH100_CITY_ON_'||TerrainClassType		FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_BUILDING_SCIENCE',		'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					'SFDH100_CITY_ON_'||TerrainClassType		FROM TerrainClasses;
INSERT OR REPLACE INTO Modifiers (ModifierId,ModifierType,SubjectStackLimit, SubjectRequirementSetId)
SELECT			'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_CULTURE_MODIFIER',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		1,		'SFDH100_DISTRICT_IS_CITY_CENTER'	FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_TOURISM_MODIFIER',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_CHANGE',		1,		'SFDH100_DISTRICT_IS_CITY_CENTER'	FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_BUILDING_SCIENCE_MODIFIER','MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',	1,		NULL								FROM TerrainClasses;
INSERT OR REPLACE INTO ModifierArguments (ModifierId,Name,Value)
SELECT			'SFDH100_CITY_TRAIN_'||PromotionClassType||'_PRODUCTION' ,			'BuildingType',				PromotionClassType 			FROM UnitPromotionClasses WHERE PromotionClassType IN('PROMOTION_CLASS_RECON','PROMOTION_CLASS_MELEE','PROMOTION_CLASS_RANGED','PROMOTION_CLASS_ANTI_CAVALRY','PROMOTION_CLASS_LIGHT_CAVALRY','PROMOTION_CLASS_HEAVY_CAVALRY','PROMOTION_CLASS_SUPPORT')
UNION SELECT	'SFDH100_CITY_TRAIN_'||PromotionClassType||'_PRODUCTION' ,			'EraType',					'NO_ERA' 					FROM UnitPromotionClasses WHERE PromotionClassType IN('PROMOTION_CLASS_RECON','PROMOTION_CLASS_MELEE','PROMOTION_CLASS_RANGED','PROMOTION_CLASS_ANTI_CAVALRY','PROMOTION_CLASS_LIGHT_CAVALRY','PROMOTION_CLASS_HEAVY_CAVALRY','PROMOTION_CLASS_SUPPORT')
UNION SELECT	'SFDH100_CITY_TRAIN_'||PromotionClassType||'_PRODUCTION' ,			'Amount',					15 							FROM UnitPromotionClasses WHERE PromotionClassType IN('PROMOTION_CLASS_RECON','PROMOTION_CLASS_MELEE','PROMOTION_CLASS_RANGED','PROMOTION_CLASS_ANTI_CAVALRY','PROMOTION_CLASS_LIGHT_CAVALRY','PROMOTION_CLASS_HEAVY_CAVALRY','PROMOTION_CLASS_SUPPORT')
UNION SELECT	'SFDH100_CITY_STOCK_EXCHANGE_IMPROVE_'||ResourceType||'_GOLD',		'BuildingType',				'BUILDING_STOCK_EXCHANGE'	FROM Resources			  WHERE ResourceClassType IS 'RESOURCECLASS_LUXURY' OR ResourceClassType IS 'RESOURCECLASS_STRATEGIC'
UNION SELECT	'SFDH100_CITY_STOCK_EXCHANGE_IMPROVE_'||ResourceType||'_GOLD',		'YieldType',				'YIELD_GOLD'				FROM Resources			  WHERE ResourceClassType IS 'RESOURCECLASS_LUXURY' OR ResourceClassType IS 'RESOURCECLASS_STRATEGIC'
UNION SELECT	'SFDH100_CITY_STOCK_EXCHANGE_IMPROVE_'||ResourceType||'_GOLD',		'Amount',					5							FROM Resources			  WHERE ResourceClassType IS 'RESOURCECLASS_LUXURY' OR ResourceClassType IS 'RESOURCECLASS_STRATEGIC'
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_CULTURE',		'GreatWorkObjectType',		GreatWorkObjectType			FROM GreatWorkObjectTypes
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_CULTURE',		'YieldType',				'YIELD_FAITH'				FROM GreatWorkObjectTypes
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_CULTURE',		'ScalingFactor',			200							FROM GreatWorkObjectTypes
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_TOURISM',		'GreatWorkObjectType',		GreatWorkObjectType			FROM GreatWorkObjectTypes
UNION SELECT	'SEAPORT_CITY_STAGE_'||GreatWorkObjectType||'_DOUBLE_TOURISM',		'ScalingFactor',			200							FROM GreatWorkObjectTypes
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_CULTURE',		'ModifierId',				'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_CULTURE_MODIFIER'	FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_CITIES_TOURISM',		'ModifierId',				'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_TOURISM_MODIFIER'	FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_FOR_'||TerrainClassType||'_BUILDING_SCIENCE',		'ModifierId',				'SFDH100_CITY_ZOO_'||TerrainClassType||'_BUILDING_SCIENCE_MODIFIER'	FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_CULTURE_MODIFIER',	'YieldType',				'YIELD_CULTURE'				FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_CULTURE_MODIFIER',	'Amount',					2							FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_CITIES_TOURISM_MODIFIER',	'Amount',					2							FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_BUILDING_SCIENCE_MODIFIER','BuildingType',				'BUILDING_ZOO'				FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_BUILDING_SCIENCE_MODIFIER','YieldType',				'YIELD_SCIENCE'				FROM TerrainClasses
UNION SELECT	'SFDH100_CITY_ZOO_'||TerrainClassType||'_BUILDING_SCIENCE_MODIFIER','Amount',					1							FROM TerrainClasses;
UPDATE Modifiers 					SET SubjectRequirementSetId = NULL							WHERE ModifierId = "GOV_TALL_AMENITY_BUFF";	--删除谒见厅总督就职需求
UPDATE Modifiers 					SET SubjectRequirementSetId = NULL							WHERE ModifierId = "GOV_TALL_HOUSING_BUFF";	--删除谒见厅总督就职需求
UPDATE Modifiers 					SET SubjectRequirementSetId = 'BUILDING_IS_RESEARCH_LAB'	WHERE ModifierId = "AMUNDSEN_ADDSCIENCEYIELD";	--极地科考站加成需要研究实验室
UPDATE Modifiers 					SET SubjectRequirementSetId = 'BUILDING_IS_RESEARCH_LAB'	WHERE ModifierId = "AMUNDSEN_ADDPRODUCTIONYIELD";	--极地科考站加成需要研究实验室
UPDATE ModifierArguments 			SET Value = 2												WHERE ModifierId = "GOV_TALL_HOUSING_BUFF" AND Name = "Amount";	--谒见厅住房改为2
UPDATE ModifierArguments 			SET Value = 5												WHERE ModifierId = "GOVCITYSTATES_ADJUST_FAVOR" AND Name = "Amount";	--外交部外交支持改为5
UPDATE ModifierArguments			SET Value = 10												WHERE ModifierId = "BARRACKS_TRAINED_UNIT_XP" 	AND Name = "Amount";	--兵营经验加成改为10%
UPDATE ModifierArguments			SET Value = 5												WHERE ModifierId = "BARRACKS_ADJUST_RESOURCE_STOCKPILE_CAP" 	AND Name = "Amount";	--兵营战略储存上限改为5
UPDATE ModifierArguments			SET Value = 10												WHERE ModifierId = "STABLE_TRAINED_UNIT_XP" 	AND Name = "Amount";	--马厩经验加成改为10%
UPDATE ModifierArguments			SET Value = 5												WHERE ModifierId = "STABLE_ADJUST_RESOURCE_STOCKPILE_CAP" 	AND Name = "Amount";	--马厩战略储存上限改为5
UPDATE ModifierArguments			SET Value = 20												WHERE ModifierId = "MILITARY_ACADEMY_TRAINED_UNIT_XP" 	AND Name = "Amount";	--军事学院经验加成改为20%
UPDATE ModifierArguments			SET Value = 5												WHERE ModifierId = "SHOPPING_MALL_TOURISM" 	AND Name = "Amount";	--购物中心旅游业绩改为5
UPDATE ModifierArguments			SET Value = 10												WHERE ModifierId = "AMUNDSEN_ADDSCIENCEYIELD" 	AND Name = "Amount";	--极地科考站的科技值加成改为10%
UPDATE ModifierArguments			SET Value = 10												WHERE ModifierId = "AMUNDSEN_SNOW_ADDSCIENCEYIELD" 	AND Name = "Amount";	--极地科考站的科技值额外加成改为10%


-- 神谕和耶稣像还可以修在山上
INSERT OR REPLACE INTO Building_ValidTerrains (BuildingType, TerrainType)
VALUES (  'BUILDING_ORACLE'  ,'TERRAIN_GRASS_MOUNTAIN'           ),
       (  'BUILDING_ORACLE'  ,'TERRAIN_PLAINS_MOUNTAIN'          ),
       (  'BUILDING_ORACLE'  ,'TERRAIN_TUNDRA_MOUNTAIN'          ),
       (  'BUILDING_ORACLE'  ,'TERRAIN_SNOW_MOUNTAIN'            ),
       (  'BUILDING_ORACLE'  ,'TERRAIN_DESERT_MOUNTAIN'          ),
       (  'BUILDING_CRISTO_REDENTOR'  ,'TERRAIN_GRASS_MOUNTAIN'           ),
       (  'BUILDING_CRISTO_REDENTOR'  ,'TERRAIN_PLAINS_MOUNTAIN'          ),
       (  'BUILDING_CRISTO_REDENTOR'  ,'TERRAIN_TUNDRA_MOUNTAIN'          ),
       (  'BUILDING_CRISTO_REDENTOR'  ,'TERRAIN_SNOW_MOUNTAIN'            ),
       (  'BUILDING_CRISTO_REDENTOR'  ,'TERRAIN_DESERT_MOUNTAIN'          );


-- 祭祀建筑大教堂会提一个音乐巨作槽和三个宗教巨作槽，本体提供10信仰，加个效果，此城的信仰加10％，宗教旅游业绩加30％，所需生产力改为200（联机速）
UPDATE Buildings SET Cost = '400', Description = 'LOC_BUILDING_CATHEDRAL_EXPANSION2_DESCRIPTION' WHERE BuildingType = 'BUILDING_CATHEDRAL';
UPDATE Building_YieldChanges SET YieldChange = '10' WHERE BuildingType = 'BUILDING_CATHEDRAL' AND YieldType = 'YIELD_FAITH';
INSERT OR REPLACE INTO Building_GreatWorks (BuildingType,GreatWorkSlotType,	NumSlots)VALUES
('BUILDING_CATHEDRAL', 			'GREATWORKSLOT_CATHEDRAL',		 				'3'),
('BUILDING_CATHEDRAL', 			'GREATWORKSLOT_MUSIC',		 					'1');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES 
('BUILDING_CATHEDRAL', 'CATHEDRAL_MYN_CITY_FAITH'),
('BUILDING_CATHEDRAL', 'CATHEDRAL_MYN_CITY_RELIGIOUS_TOURISM');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('CATHEDRAL_MYN_CITY_FAITH', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 0, 0, 0, NULL, NULL),
('CATHEDRAL_MYN_CITY_RELIGIOUS_TOURISM', 'MODIFIER_SINGLE_CITY_ADJUST_TOURISM', 0, 0, 0, NULL, NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('CATHEDRAL_MYN_CITY_FAITH', 'Amount', '10'), 
('CATHEDRAL_MYN_CITY_FAITH', 'YieldType', 'YIELD_FAITH'),
('CATHEDRAL_MYN_CITY_RELIGIOUS_TOURISM', 'Religious', '1'), 
('CATHEDRAL_MYN_CITY_RELIGIOUS_TOURISM', 'ScalingFactor', '130');

-- 祭祀建筑中的宝塔效果改为：造价99生产力（联机速），加5信仰，加2文化，加4金币，加1遗物槽
UPDATE Buildings SET Cost = '198' WHERE BuildingType = 'BUILDING_PAGODA';
INSERT OR REPLACE INTO Building_YieldChanges (BuildingType,YieldType,	YieldChange)VALUES
('BUILDING_PAGODA', 			'YIELD_FAITH',		 					'5'),
('BUILDING_PAGODA', 			'YIELD_CULTURE',		 				'2'),
('BUILDING_PAGODA', 			'YIELD_GOLD',		 					'4');
INSERT OR REPLACE INTO Building_GreatWorks (BuildingType,GreatWorkSlotType,	NumSlots)VALUES
('BUILDING_PAGODA', 			'GREATWORKSLOT_RELIC',		 				'1');
DELETE FROM BuildingModifiers WHERE BuildingType = 'BUILDING_PAGODA';
