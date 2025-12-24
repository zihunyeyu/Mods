-- TKH_Improvements
-- Author: PurpleSoul
-- DateCreated: 3/11/2025 10:21:33 PM
--------------------------------------------------------------
INSERT OR REPLACE INTO Improvement_ValidTerrains(ImprovementType, TerrainType)
SELECT 'IMPROVEMENT_GREAT_WALL_TKH', TerrainType
FROM Terrains;

INSERT OR REPLACE INTO Improvement_ValidFeatures(ImprovementType, FeatureType)
SELECT 'IMPROVEMENT_GREAT_WALL_TKH', FeatureType
FROM Features;

INSERT OR REPLACE INTO Improvement_ValidResources(ImprovementType, ResourceType, MustRemoveFeature)
SELECT 'IMPROVEMENT_GREAT_WALL_TKH', ResourceType, 0
FROM Resources;

UPDATE Buildings
SET Housing = 1, Entertainment = 1
WHERE OuterDefenseHitPoints > 0; 

DELETE FROM RandomEvent_Damages
WHERE DamageType='POPULATION_LOSS';

UPDATE Districts
SET OnePerCity = 0, RequiresPopulation = 0
WHERE DistrictType = 'DISTRICT_ENCAMPMENT'; 

INSERT OR REPLACE INTO Types(Type,	Kind)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'KIND_IMPROVEMENT');

INSERT OR REPLACE INTO Improvements(ImprovementType,	Name,	Description,	Icon,	PlunderType,	PlunderAmount,	Buildable,	PrereqTech,	DefenseModifier,	GrantFortification)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'LOC_IMPROVEMENT_GREAT_WALL_TKH_NAME',	'LOC_IMPROVEMENT_GREAT_WALL_TKH_EXPANSION2_DESCRIPTION',	'ICON_IMPROVEMENT_GREAT_WALL_TKH',	'PLUNDER_GOLD',	'50',	1,	'TECH_MASONRY',	'6',	'2');

INSERT OR REPLACE INTO Improvement_Adjacencies(ImprovementType,	YieldChangeId)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'GreatWall_Gold_TKH'),
('IMPROVEMENT_GREAT_WALL_TKH',	'GreatWall_Culture_TKH');

INSERT OR REPLACE INTO Improvement_ValidBuildUnits(ImprovementType,	UnitType)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'UNIT_BUILDER');

INSERT OR REPLACE INTO Improvement_YieldChanges(ImprovementType,	YieldType,	YieldChange)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'YIELD_GOLD',	'2'),
('IMPROVEMENT_GREAT_WALL_TKH',	'YIELD_CULTURE',	'0');

INSERT OR REPLACE INTO Improvement_Tourism(ImprovementType,	TourismSource,	PrereqTech,	ScalingFactor)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	'TOURISMSOURCE_CULTURE',	'TECH_FLIGHT',	'100');

INSERT OR REPLACE INTO Adjacency_YieldChanges(ID,	Description,	YieldType,	YieldChange,	TilesRequired,	AdjacentImprovement,	PrereqTech)
VALUES
('GreatWall_Gold_TKH',	'Placeholder',	'YIELD_GOLD',	'1',	'1',	'IMPROVEMENT_GREAT_WALL_TKH',	'TECH_MASONRY'),
('GreatWall_Culture_TKH',	'Placeholder',	'YIELD_CULTURE',	'2',	'1',	'IMPROVEMENT_GREAT_WALL_TKH',	'TECH_CASTLES');

INSERT OR REPLACE INTO Improvements_XP2(ImprovementType,	BuildOnAdjacentPlot,	DisasterResistant)
VALUES
('IMPROVEMENT_GREAT_WALL_TKH',	1,	1);



