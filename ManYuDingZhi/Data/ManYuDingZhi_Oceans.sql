
INSERT INTO Types (Type,								Kind)
VALUES 	('IMPROVEMENT_MYN_YUTANG',						'KIND_IMPROVEMENT');

INSERT INTO Improvements (ImprovementType,	Name,						PrereqTech,		PlunderType,	PlunderAmount,		Icon,							TraitType,						Description,							Housing,	TilesRequired,	Buildable,		OnePerCity,		Domain,			Workable,	GoodyNotify,	Removable,		Capturable,		SameAdjacentValid)
VALUES	('IMPROVEMENT_MYN_YUTANG',		'LOC_IMPROVEMENT_FISHERY_NAME',	'TECH_SAILING',	'PLUNDER_HEAL',	'50',				'ICON_IMPROVEMENT_FISHERY',		'TRAIT_CIVILIZATION_NO_PLAYER',	'LOC_IMPROVEMENT_FISHERY_DESCRIPTION',	2,			2,				1,				0,				'DOMAIN_SEA',	1,			1,				1,				1,				1);

INSERT INTO Improvement_Adjacencies (ImprovementType,					YieldChangeId)
VALUES	('IMPROVEMENT_MYN_YUTANG',		'SFDH100_IMPROVEMENT_FISHERY_Adja_STRATEGIC'),
		('IMPROVEMENT_MYN_YUTANG',		'SFDH100_IMPROVEMENT_FISHERY_Adja_BONUS'),
		('IMPROVEMENT_MYN_YUTANG',		'SFDH100_IMPROVEMENT_FISHERY_Adja_LUXURY');

INSERT INTO Improvement_YieldChanges (ImprovementType,					YieldType,				 YieldChange)
VALUES	('IMPROVEMENT_MYN_YUTANG',		'YIELD_FOOD'	,		'1'),
		('IMPROVEMENT_MYN_YUTANG',		'YIELD_PRODUCTION'	,	'1'),
		('IMPROVEMENT_MYN_YUTANG',		'YIELD_GOLD'	,		'1');

INSERT INTO Improvement_ValidTerrains (ImprovementType,					TerrainType)
VALUES	('IMPROVEMENT_MYN_YUTANG',		'TERRAIN_COAST');

INSERT INTO Improvement_ValidBuildUnits (ImprovementType,						UnitType)
VALUES	('IMPROVEMENT_MYN_YUTANG',			'UNIT_BUILDER');

INSERT INTO ImprovementModifiers (ImprovementType,						ModifierId) 
VALUES	-- ('IMPROVEMENT_MYN_YUTANG',			'FISHERY_GOVERNOR_PRODUCTION'),
		('IMPROVEMENT_MYN_YUTANG',			'SFDH100_IMPROVEMENT_FISHERY_GOLD');

UPDATE ModifierArguments SET Value = 'IMPROVEMENT_MYN_YUTANG' WHERE ModifierId = 'AQUACULTURE_CAN_BUILD_FISHERY' AND Name = 'ImprovementType';

INSERT INTO CivilopediaPageExcludes (SectionId, PageId) VALUES 
('IMPROVEMENTS', 'IMPROVEMENT_FISHERY');
