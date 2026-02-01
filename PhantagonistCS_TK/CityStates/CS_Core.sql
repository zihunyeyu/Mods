-- Liu Che

INSERT INTO	Types
		(Type,									Kind			)
VALUES	('UNIT_PHANTA_LIU_XIE',					'KIND_UNIT'		),
		('ABILITY_PHANTA_LIU_XIE',				'KIND_ABILITY'	);

INSERT INTO Tags
		(Tag,							Vocabulary		)
VALUES	('CLASS_PHANTA_LIU_XIE',		'ABILITY_CLASS'	);

INSERT INTO TypeTags
		(Type,									Tag					)
VALUES	('UNIT_PHANTA_LIU_XIE',					'CLASS_PHANTA_LIU_XIE'	),
		('UNIT_PHANTA_LIU_XIE',					'CLASS_LANDCIVILIAN'	),
		('ABILITY_PHANTA_LIU_XIE',				'CLASS_PHANTA_LIU_XIE'	);

INSERT INTO Units
			(UnitType,				Name,								Description,							BaseSightRange,		BaseMoves,		Domain,				FormationClass,					CanCapture,			Cost,		CanTrain)
VALUES		('UNIT_PHANTA_LIU_XIE',	'LOC_UNIT_PHANTA_LIU_XIE_NAME',		'LOC_UNIT_PHANTA_LIU_XIE_DESCRIPTION',	'2',				'2',			'DOMAIN_LAND',		'FORMATION_CLASS_CIVILIAN',		'0',				'1',				0);

INSERT INTO UnitAiInfos
			(UnitType,						AiType							)
VALUES		('UNIT_PHANTA_LIU_XIE',			'UNITTYPE_CIVILIAN'				);

INSERT INTO UnitCaptures
			(CapturedUnitType,				BecomesUnitType							)
VALUES		('UNIT_PHANTA_LIU_XIE',			'UNIT_PHANTA_LIU_XIE'				);

INSERT INTO UnitAbilities
		(UnitAbilityType,							Name,											Description					)
VALUES	('ABILITY_PHANTA_LIU_XIE',			'LOC_UNIT_PHANTA_LIU_XIE_NAME',			'LOC_ABILITY_PHANTA_LIU_XIE_DESCRIPTION'	);

-- Initial Iron and Horses



-- Custom ModifierType

INSERT INTO Types (Type, Kind) VALUES 
('MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_RESOURCE_IN_CITY', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES 
('MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_RESOURCE_IN_CITY', 'COLLECTION_PLAYER_CAPITAL_CITY', 'EFFECT_GRANT_FREE_RESOURCE_IN_CITY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_INITIAL_RESOURCE_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_INITIAL_RESOURCE_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

----------
----------

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_MAJOR_CIV', 'MODFEAT_PHANTA_CS_TK_INITIAL_HORSES');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_INITIAL_HORSES', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_RESOURCE_IN_CITY', 1, 1, 0, 'REQSET_CS_TK_INITIAL_RESOURCE_PLAYER_HAS_CAPITAL', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_INITIAL_HORSES', 'Amount', '15'), 
('MODFEAT_PHANTA_CS_TK_INITIAL_HORSES', 'ResourceType', 'RESOURCE_HORSES');

----------
----------

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_MAJOR_CIV', 'MODFEAT_PHANTA_CS_TK_INITIAL_IRON');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_INITIAL_IRON', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_RESOURCE_IN_CITY', 1, 1, 0, 'REQSET_CS_TK_INITIAL_RESOURCE_PLAYER_HAS_CAPITAL', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_INITIAL_IRON', 'Amount', '45'), 
('MODFEAT_PHANTA_CS_TK_INITIAL_IRON', 'ResourceType', 'RESOURCE_IRON');

-- Horses and Iron from Encampment buildings

-- Custom ModifierType

--INSERT INTO Types (Type, Kind) VALUES 
--('MODTYPE_PHANTA_CS_TK_PLAYER_CITIES_ADJUST_FREE_RESOURCE_EXTRACTION', 'KIND_MODIFIER');

--INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES 
--('MODTYPE_PHANTA_CS_TK_PLAYER_CITIES_ADJUST_FREE_RESOURCE_EXTRACTION', 'COLLECTION_OWNER', 'EFFECT_GRANT_FREE_RESOURCE_EXTRACTED');

----------
----------

--INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
--('TRAIT_LEADER_MAJOR_CIV', 'MODFEAT_PHANTA_CS_TK_STABLE_HORSES');

--INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
--('MODFEAT_PHANTA_CS_TK_STABLE_HORSES', 'MODTYPE_PHANTA_CS_TK_PLAYER_CITIES_ADJUST_FREE_RESOURCE_EXTRACTION', 0, 0, 0, NULL, 'REQSET_PHANTA_CS_TK_STABLE');

--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
--('MODFEAT_PHANTA_CS_TK_STABLE_HORSES', 'Amount', '1'), 
--('MODFEAT_PHANTA_CS_TK_STABLE_HORSES', 'ResourceType', 'RESOURCE_HORSES');

-- RequirementSets

--INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
--('REQSET_PHANTA_CS_TK_STABLE', 'REQUIREMENTSET_TEST_ALL');

--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
--('REQSET_PHANTA_CS_TK_STABLE', 'REQ_PHANTA_CS_TK_STABLE');

-- Requirements

--INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
--('REQ_PHANTA_CS_TK_STABLE', 'REQUIREMENT_CITY_HAS_BUILDING');

--INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
--('REQ_PHANTA_CS_TK_STABLE', 'BuildingType', 'BUILDING_STABLE');


----------
----------

--INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
--('TRAIT_LEADER_MAJOR_CIV', 'MODFEAT_PHANTA_CS_TK_BARRACKS_IRON');

--INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
--('MODFEAT_PHANTA_CS_TK_BARRACKS_IRON', 'MODTYPE_PHANTA_CS_TK_PLAYER_CITIES_ADJUST_FREE_RESOURCE_EXTRACTION', 0, 0, 0, NULL, 'REQSET_PHANTA_CS_TK_BARRACKS');

--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
--('MODFEAT_PHANTA_CS_TK_BARRACKS_IRON', 'Amount', '1'), 
--('MODFEAT_PHANTA_CS_TK_BARRACKS_IRON', 'ResourceType', 'RESOURCE_IRON');

-- RequirementSets

--INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
--('REQSET_PHANTA_CS_TK_BARRACKS', 'REQUIREMENTSET_TEST_ALL');

--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
--('REQSET_PHANTA_CS_TK_BARRACKS', 'REQ_PHANTA_CS_TK_BARRACKS');

-- Requirements

--INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
--('REQ_PHANTA_CS_TK_BARRACKS', 'REQUIREMENT_CITY_HAS_BUILDING');

--INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
--('REQ_PHANTA_CS_TK_BARRACKS', 'BuildingType', 'BUILDING_BARRACKS');

----------
----------

--INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES 
--('DISTRICT_CAMPUS', 'MODFEAT_PHANTA_GRANT_LIU_XIE_TEST');

--INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
--('MODFEAT_PHANTA_GRANT_LIU_XIE_TEST', 'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY', 0, 0, 0, NULL, NULL);

--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
--('MODFEAT_PHANTA_GRANT_LIU_XIE_TEST', 'AllowUniqueOverride', 'false'), 
--('MODFEAT_PHANTA_GRANT_LIU_XIE_TEST', 'Amount', '1'), 
--('MODFEAT_PHANTA_GRANT_LIU_XIE_TEST', 'UnitType', 'UNIT_PHANTA_LIU_XIE');


----------
----------

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES 
('ABILITY_PHANTA_LIU_XIE', 'MODFEAT_PHANTA_LIU_XIE_FAVOR');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_LIU_XIE_FAVOR', 'MODIFIER_PLAYER_ADJUST_EXTRA_FAVOR_PER_TURN', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_LIU_XIE_FAVOR', 'Amount', '3');

----------
----------

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES 
('ABILITY_PHANTA_LIU_XIE', 'MODFEAT_PHANTA_LIU_XIE_INFLUENCE');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_LIU_XIE_INFLUENCE', 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_LIU_XIE_INFLUENCE', 'Amount', '5');

----------
----------

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES 
('ABILITY_PHANTA_LIU_XIE', 'MODFEAT_PHANTA_LIU_XIE_WAR_WEARINESS');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_LIU_XIE_WAR_WEARINESS', 'MODIFIER_PLAYER_ADJUST_WAR_WEARINESS', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_LIU_XIE_WAR_WEARINESS', 'Amount', '-30'), 
('MODFEAT_PHANTA_LIU_XIE_WAR_WEARINESS', 'Overall', 'true');






----------------------------------------
-- GUIYANG
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GUIYANG',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_GUIYANG',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_GUIYANG_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GUIYANG',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GUIYANG',	'LOC_CIVILIZATION_PHANTA_CS_TK_GUIYANG_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_GUIYANG_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_GUIYANG_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GUIYANG',		'LOC_CITY_NAME_PHANTA_CS_TK_GUIYANG');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GUIYANG',		'LOC_CIVILIZATION_PHANTA_CS_TK_GUIYANG_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GUIYANG',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GUIYANG',		'CIVILIZATION_PHANTA_CS_TK_GUIYANG',	'LOC_CITY_NAME_PHANTA_CS_TK_GUIYANG');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GUIYANG',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_GUIYANG_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_GUIYANG_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_GUIYANG_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GUIYANG',		'MINOR_CIV_PHANTA_CS_TK_GUIYANG_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_GUIYANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_GUIYANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_GUIYANG_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- LINGLING
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LINGLING',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_LINGLING',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_LINGLING_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LINGLING',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LINGLING',	'LOC_CIVILIZATION_PHANTA_CS_TK_LINGLING_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_LINGLING_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_LINGLING_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LINGLING',		'LOC_CITY_NAME_PHANTA_CS_TK_LINGLING');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LINGLING',		'LOC_CIVILIZATION_PHANTA_CS_TK_LINGLING_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LINGLING',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LINGLING',		'CIVILIZATION_PHANTA_CS_TK_LINGLING',	'LOC_CITY_NAME_PHANTA_CS_TK_LINGLING');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LINGLING',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_LINGLING_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_LINGLING_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_LINGLING_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LINGLING',		'MINOR_CIV_PHANTA_CS_TK_LINGLING_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_LINGLING_TRAIT', 'MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_LINGLING_TRAIT', 'MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_LINGLING_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- CHANGSHA
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHANGSHA',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_CHANGSHA',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_CHANGSHA_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHANGSHA',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHANGSHA',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHANGSHA_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHANGSHA_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHANGSHA_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHANGSHA',		'LOC_CITY_NAME_PHANTA_CS_TK_CHANGSHA');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHANGSHA',		'LOC_CIVILIZATION_PHANTA_CS_TK_CHANGSHA_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHANGSHA',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHANGSHA',		'CIVILIZATION_PHANTA_CS_TK_CHANGSHA',	'LOC_CITY_NAME_PHANTA_CS_TK_CHANGSHA');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHANGSHA',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_CHANGSHA_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHANGSHA_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHANGSHA_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHANGSHA',		'MINOR_CIV_PHANTA_CS_TK_CHANGSHA_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHANGSHA_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHANGSHA_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_CHANGSHA_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- WULING
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WULING',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_WULING',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_WULING_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WULING',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WULING',	'LOC_CIVILIZATION_PHANTA_CS_TK_WULING_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_WULING_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_WULING_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WULING',		'LOC_CITY_NAME_PHANTA_CS_TK_WULING');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WULING',		'LOC_CIVILIZATION_PHANTA_CS_TK_WULING_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WULING',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WULING',		'CIVILIZATION_PHANTA_CS_TK_WULING',	'LOC_CITY_NAME_PHANTA_CS_TK_WULING');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WULING',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_WULING_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_WULING_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_WULING_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WULING',		'MINOR_CIV_PHANTA_CS_TK_WULING_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WULING_TRAIT', 'MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WULING_TRAIT', 'MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_WULING_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- JINCHENG
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINCHENG',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_JINCHENG_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINCHENG',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINCHENG',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINCHENG_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINCHENG_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINCHENG_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINCHENG',		'LOC_CITY_NAME_PHANTA_CS_TK_JINCHENG');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG',		'LOC_CIVILIZATION_PHANTA_CS_TK_JINCHENG_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG',		'CIVILIZATION_PHANTA_CS_TK_JINCHENG',	'LOC_CITY_NAME_PHANTA_CS_TK_JINCHENG');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINCHENG',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_JINCHENG_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINCHENG_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINCHENG_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG',		'MINOR_CIV_PHANTA_CS_TK_JINCHENG_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINCHENG_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINCHENG_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_JINCHENG_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- FUHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_FUHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_FUHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_FUHAN',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_FUHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_FUHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_FUHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_FUHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_FUHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_FUHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_FUHAN_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN',		'CIVILIZATION_PHANTA_CS_TK_FUHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_FUHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_FUHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_FUHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_FUHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_FUHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN',		'MINOR_CIV_PHANTA_CS_TK_FUHAN_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_FUHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_FUHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_FUHAN_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- HENEI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HENEI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_HENEI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HENEI',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HENEI',	'LOC_CIVILIZATION_PHANTA_CS_TK_HENEI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_HENEI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_HENEI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HENEI',		'LOC_CITY_NAME_PHANTA_CS_TK_HENEI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI',		'LOC_CIVILIZATION_PHANTA_CS_TK_HENEI_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI',		'CIVILIZATION_PHANTA_CS_TK_HENEI',	'LOC_CITY_NAME_PHANTA_CS_TK_HENEI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HENEI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_HENEI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_HENEI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_HENEI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI',		'MINOR_CIV_PHANTA_CS_TK_HENEI_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HENEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HENEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_HENEI_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- CHENLIU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHENLIU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_CHENLIU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHENLIU',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHENLIU',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHENLIU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHENLIU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHENLIU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHENLIU',		'LOC_CITY_NAME_PHANTA_CS_TK_CHENLIU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU',		'LOC_CIVILIZATION_PHANTA_CS_TK_CHENLIU_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU',		'CIVILIZATION_PHANTA_CS_TK_CHENLIU',	'LOC_CITY_NAME_PHANTA_CS_TK_CHENLIU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHENLIU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_CHENLIU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHENLIU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHENLIU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU',		'MINOR_CIV_PHANTA_CS_TK_CHENLIU_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHENLIU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHENLIU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_CHENLIU_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- YIZHOU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YIZHOU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_YIZHOU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YIZHOU',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YIZHOU',	'LOC_CIVILIZATION_PHANTA_CS_TK_YIZHOU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_YIZHOU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_YIZHOU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YIZHOU',		'LOC_CITY_NAME_PHANTA_CS_TK_YIZHOU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU',		'LOC_CIVILIZATION_PHANTA_CS_TK_YIZHOU_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU',		'CIVILIZATION_PHANTA_CS_TK_YIZHOU',	'LOC_CITY_NAME_PHANTA_CS_TK_YIZHOU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YIZHOU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_YIZHOU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_YIZHOU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_YIZHOU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU',		'MINOR_CIV_PHANTA_CS_TK_YIZHOU_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YIZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YIZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_YIZHOU_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- JINHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_JINHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINHAN',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_JINHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_JINHAN_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN',		'CIVILIZATION_PHANTA_CS_TK_JINHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_JINHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_JINHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN',		'MINOR_CIV_PHANTA_CS_TK_JINHAN_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_JINHAN_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- BAIBO
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BAIBO',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BAIBO',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BAIBO',	'LOC_CIVILIZATION_PHANTA_CS_TK_BAIBO_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_BAIBO_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_BAIBO_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BAIBO',		'LOC_CITY_NAME_PHANTA_CS_TK_BAIBO');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO',		'LOC_CIVILIZATION_PHANTA_CS_TK_BAIBO_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO',		'CIVILIZATION_PHANTA_CS_TK_BAIBO',	'LOC_CITY_NAME_PHANTA_CS_TK_BAIBO');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BAIBO',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_BAIBO_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_BAIBO_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO',		'MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed).
--== May purchase melee units, anti-cavalry units and recon units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BAIBO_TRAIT', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BAIBO_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- RUNAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_RUNAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_RUNAN',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_RUNAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_RUNAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_RUNAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_RUNAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_RUNAN',		'LOC_CITY_NAME_PHANTA_CS_TK_RUNAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_RUNAN_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN',		'CIVILIZATION_PHANTA_CS_TK_RUNAN',	'LOC_CITY_NAME_PHANTA_CS_TK_RUNAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_RUNAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_RUNAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_RUNAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN',		'MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_RUNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_RUNAN_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- TAISHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_TAISHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_TAISHAN',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_TAISHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_TAISHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_TAISHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_TAISHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_TAISHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_TAISHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_TAISHAN_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN',		'CIVILIZATION_PHANTA_CS_TK_TAISHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_TAISHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_TAISHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_TAISHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_TAISHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN',		'MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_TAISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_TAISHAN_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- HEISHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HEISHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HEISHAN',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HEISHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_HEISHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_HEISHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_HEISHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HEISHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_HEISHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_HEISHAN_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN',		'CIVILIZATION_PHANTA_CS_TK_HEISHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_HEISHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_HEISHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_HEISHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_HEISHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN',		'MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_HEISHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_HEISHAN_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');


----------------------------------------
-- KUAIJI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUAIJI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUAIJI',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUAIJI',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUAIJI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUAIJI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUAIJI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUAIJI',		'LOC_CITY_NAME_PHANTA_CS_TK_KUAIJI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI',		'LOC_CIVILIZATION_PHANTA_CS_TK_KUAIJI_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI',		'CIVILIZATION_PHANTA_CS_TK_KUAIJI',	'LOC_CITY_NAME_PHANTA_CS_TK_KUAIJI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUAIJI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_KUAIJI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_KUAIJI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI',		'MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed).
--== May purchase melee units, anti-cavalry units and recon units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUAIJI_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUAIJI_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- CANGWU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CANGWU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CANGWU',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CANGWU',	'LOC_CIVILIZATION_PHANTA_CS_TK_CANGWU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_CANGWU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_CANGWU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CANGWU',		'LOC_CITY_NAME_PHANTA_CS_TK_CANGWU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU',		'LOC_CIVILIZATION_PHANTA_CS_TK_CANGWU_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU',		'CIVILIZATION_PHANTA_CS_TK_CANGWU',	'LOC_CITY_NAME_PHANTA_CS_TK_CANGWU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CANGWU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_CANGWU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_CANGWU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU',		'MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CANGWU_TRAIT', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CANGWU_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- YAMATAI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YAMATAI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YAMATAI',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YAMATAI',	'LOC_CIVILIZATION_PHANTA_CS_TK_YAMATAI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_YAMATAI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_YAMATAI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YAMATAI',		'LOC_CITY_NAME_PHANTA_CS_TK_YAMATAI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI',		'LOC_CIVILIZATION_PHANTA_CS_TK_YAMATAI_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI',		'CIVILIZATION_PHANTA_CS_TK_YAMATAI',	'LOC_CITY_NAME_PHANTA_CS_TK_YAMATAI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_YAMATAI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_YAMATAI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_YAMATAI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI',		'MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_YAMATAI_TRAIT', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_YAMATAI_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- BYEONHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BYEONHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BYEONHAN',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BYEONHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_BYEONHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_BYEONHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_BYEONHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BYEONHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_BYEONHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_BYEONHAN_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN',		'CIVILIZATION_PHANTA_CS_TK_BYEONHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_BYEONHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_BYEONHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_BYEONHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_BYEONHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN',		'MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_BYEONHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_BYEONHAN_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');


----------------------------------------
-- QIANG
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QIANG',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_QIANG_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QIANG',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QIANG',	'LOC_CIVILIZATION_PHANTA_CS_TK_QIANG_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_QIANG_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_QIANG_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QIANG',		'LOC_CITY_NAME_PHANTA_CS_TK_QIANG');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG',		'LOC_CIVILIZATION_PHANTA_CS_TK_QIANG_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG',		'CIVILIZATION_PHANTA_CS_TK_QIANG',	'LOC_CITY_NAME_PHANTA_CS_TK_QIANG');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QIANG',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_QIANG_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_QIANG_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_QIANG_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG',		'MINOR_CIV_PHANTA_CS_TK_QIANG_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed).
--== You gain a free light cavalry unit when you become this City-State・s suzerain for the first time.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QIANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_QIANG_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QIANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_QIANG_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_QIANG_GRANT_LIGHT_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_LIGHT_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_QIANG_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_QIANG_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

----------------------------------------
-- DI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_DI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_DI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DI',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DI',	'LOC_CIVILIZATION_PHANTA_CS_TK_DI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_DI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_DI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DI',		'LOC_CITY_NAME_PHANTA_CS_TK_DI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DI',		'LOC_CIVILIZATION_PHANTA_CS_TK_DI_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DI',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DI',		'CIVILIZATION_PHANTA_CS_TK_DI',	'LOC_CITY_NAME_PHANTA_CS_TK_DI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_DI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_DI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_DI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DI',		'MINOR_CIV_PHANTA_CS_TK_DI_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed).
--== You gain a free light cavalry unit when you become this City-State・s suzerain for the first time.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_DI_TRAIT', 'MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_DI_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_DI_TRAIT', 'MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_DI_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_DI_GRANT_LIGHT_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_LIGHT_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_DI_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_DI_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');


-- ModifierType


INSERT INTO Types (Type, Kind) VALUES 
('MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers
		(ModifierType,													CollectionType,		EffectType)
VALUES	('MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER',	'COLLECTION_PLAYER_CAPITAL_CITY',	'EFFECT_GRANT_UNIT_OF_CLASS_AND_APPLY_ABILITY');


----------------------------------------
-- WANCHENG
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WANCHENG',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_WANCHENG_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WANCHENG',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WANCHENG',	'LOC_CIVILIZATION_PHANTA_CS_TK_WANCHENG_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_WANCHENG_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_WANCHENG_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WANCHENG',		'LOC_CITY_NAME_PHANTA_CS_TK_WANCHENG');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG',		'LOC_CIVILIZATION_PHANTA_CS_TK_WANCHENG_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG',		'CIVILIZATION_PHANTA_CS_TK_WANCHENG',	'LOC_CITY_NAME_PHANTA_CS_TK_WANCHENG');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WANCHENG',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_WANCHENG_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_WANCHENG_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_WANCHENG_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG',		'MINOR_CIV_PHANTA_CS_TK_WANCHENG_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WANCHENG_TRAIT', 'MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_WANCHENG_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_WANCHENG_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_WANCHENG_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_WANCHENG_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WANCHENG_TRAIT', 'MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_WANCHENG_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');

----------------------------------------
-- JIANGXIA
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JIANGXIA',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_JIANGXIA_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JIANGXIA',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JIANGXIA',	'LOC_CIVILIZATION_PHANTA_CS_TK_JIANGXIA_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_JIANGXIA_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_JIANGXIA_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JIANGXIA',		'LOC_CITY_NAME_PHANTA_CS_TK_JIANGXIA');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA',		'LOC_CIVILIZATION_PHANTA_CS_TK_JIANGXIA_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA',		'CIVILIZATION_PHANTA_CS_TK_JIANGXIA',	'LOC_CITY_NAME_PHANTA_CS_TK_JIANGXIA');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JIANGXIA',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_JIANGXIA_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_JIANGXIA_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_JIANGXIA_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA',		'MINOR_CIV_PHANTA_CS_TK_JIANGXIA_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JIANGXIA_TRAIT', 'MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_JIANGXIA_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_JIANGXIA_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_JIANGXIA_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_JIANGXIA_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JIANGXIA_TRAIT', 'MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_JIANGXIA_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');


----------------------------------------
-- XIANBEI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_XIANBEI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_XIANBEI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_XIANBEI',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_XIANBEI',	'LOC_CIVILIZATION_PHANTA_CS_TK_XIANBEI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_XIANBEI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_XIANBEI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_XIANBEI',		'LOC_CITY_NAME_PHANTA_CS_TK_XIANBEI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI',		'LOC_CIVILIZATION_PHANTA_CS_TK_XIANBEI_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI',		'CIVILIZATION_PHANTA_CS_TK_XIANBEI',	'LOC_CITY_NAME_PHANTA_CS_TK_XIANBEI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_XIANBEI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_XIANBEI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_XIANBEI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_XIANBEI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI',		'MINOR_CIV_PHANTA_CS_TK_XIANBEI_TRAIT');

-- Suzerain Bonus
--==== You gain a free light cavalry unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards light cavalry units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_XIANBEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_XIANBEI_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_XIANBEI_GRANT_LIGHT_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_LIGHT_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_XIANBEI_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_XIANBEI_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_XIANBEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_XIANBEI_LIGHT_CAVALRY_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_LIGHT_CAVALRY');


----------------------------------------
-- SOUTHERN_XIONGNU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',	'LOC_CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'LOC_CITY_NAME_PHANTA_CS_TK_SOUTHERN_XIONGNU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'LOC_CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',	'LOC_CITY_NAME_PHANTA_CS_TK_SOUTHERN_XIONGNU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_SOUTHERN_XIONGNU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_SOUTHERN_XIONGNU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU',		'MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU_TRAIT');

-- Suzerain Bonus
--==== You gain a free light cavalry unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards light cavalry units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU_TRAIT', 'MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_SOUTHERN_XIONGNU_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_GRANT_LIGHT_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_LIGHT_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_SOUTHERN_XIONGNU_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_SOUTHERN_XIONGNU_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU_TRAIT', 'MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_SOUTHERN_XIONGNU_LIGHT_CAVALRY_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_LIGHT_CAVALRY');


----------------------------------------
-- LIAOXI_WUHUAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',		'LOC_CITY_NAME_PHANTA_CS_TK_LIAOXI_WUHUAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN',		'CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',	'LOC_CITY_NAME_PHANTA_CS_TK_LIAOXI_WUHUAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_LIAOXI_WUHUAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_LIAOXI_WUHUAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_LIAOXI_WUHUAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN',		'MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN_TRAIT');

-- Suzerain Bonus
--==== You gain a free light cavalry unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards light cavalry units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_LIAOXI_WUHUAN_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_GRANT_LIGHT_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_LIGHT_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_LIAOXI_WUHUAN_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_LIAOXI_WUHUAN_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_LIAOXI_WUHUAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_LIAOXI_WUHUAN_LIGHT_CAVALRY_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_LIGHT_CAVALRY');



----------------------------------------
-- SHANYUE
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SHANYUE',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_SHANYUE_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SHANYUE',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SHANYUE',	'LOC_CIVILIZATION_PHANTA_CS_TK_SHANYUE_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_SHANYUE_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_SHANYUE_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SHANYUE',		'LOC_CITY_NAME_PHANTA_CS_TK_SHANYUE');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE',		'LOC_CIVILIZATION_PHANTA_CS_TK_SHANYUE_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE',		'CIVILIZATION_PHANTA_CS_TK_SHANYUE',	'LOC_CITY_NAME_PHANTA_CS_TK_SHANYUE');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_SHANYUE',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_SHANYUE_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_SHANYUE_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_SHANYUE_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE',		'MINOR_CIV_PHANTA_CS_TK_SHANYUE_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_SHANYUE_TRAIT', 'MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_SHANYUE_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_SHANYUE_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_SHANYUE_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_SHANYUE_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_SHANYUE_TRAIT', 'MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_SHANYUE_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');

----------------------------------------
-- WU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_WU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_WU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WU',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WU',	'LOC_CIVILIZATION_PHANTA_CS_TK_WU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_WU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_WU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WU',		'LOC_CITY_NAME_PHANTA_CS_TK_WU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WU',		'LOC_CIVILIZATION_PHANTA_CS_TK_WU_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WU',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WU',		'CIVILIZATION_PHANTA_CS_TK_WU',	'LOC_CITY_NAME_PHANTA_CS_TK_WU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_WU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_WU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_WU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WU',		'MINOR_CIV_PHANTA_CS_TK_WU_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WU_TRAIT', 'MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_WU_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_WU_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_WU_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_WU_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WU_TRAIT', 'MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_WU_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');


----------------------------------------
-- CHEN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHEN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_CHEN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHEN',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHEN',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHEN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHEN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHEN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHEN',		'LOC_CITY_NAME_PHANTA_CS_TK_CHEN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN',		'LOC_CIVILIZATION_PHANTA_CS_TK_CHEN_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN',		'CIVILIZATION_PHANTA_CS_TK_CHEN',	'LOC_CITY_NAME_PHANTA_CS_TK_CHEN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHEN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_CHEN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHEN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHEN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN',		'MINOR_CIV_PHANTA_CS_TK_CHEN_TRAIT');

-- Suzerain Bonus
--==== You gain a free ranged unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards ranged units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHEN_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_CHEN_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_EFFECT'),
('MODFEAT_PHANTA_CS_TK_CHEN_GRANT_RANGED_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_RANGED');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_CHEN_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_CHEN_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHEN_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_CHEN_RANGED_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_RANGED');

----------------------------------------
-- GOGURYEO
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GOGURYEO',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_GOGURYEO_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GOGURYEO',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GOGURYEO',	'LOC_CIVILIZATION_PHANTA_CS_TK_GOGURYEO_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_GOGURYEO_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_GOGURYEO_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GOGURYEO',		'LOC_CITY_NAME_PHANTA_CS_TK_GOGURYEO');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO',		'LOC_CIVILIZATION_PHANTA_CS_TK_GOGURYEO_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO',		'CIVILIZATION_PHANTA_CS_TK_GOGURYEO',	'LOC_CITY_NAME_PHANTA_CS_TK_GOGURYEO');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_GOGURYEO',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_GOGURYEO_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_GOGURYEO_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_GOGURYEO_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO',		'MINOR_CIV_PHANTA_CS_TK_GOGURYEO_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_GOGURYEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_GOGURYEO_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_GOGURYEO_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_GOGURYEO_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_GOGURYEO_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_GOGURYEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_GOGURYEO_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');

----------------------------------------
-- MAHAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MAHAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_MAHAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MAHAN',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MAHAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_MAHAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_MAHAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_MAHAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MAHAN',		'LOC_CITY_NAME_PHANTA_CS_TK_MAHAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_MAHAN_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN',		'CIVILIZATION_PHANTA_CS_TK_MAHAN',	'LOC_CITY_NAME_PHANTA_CS_TK_MAHAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MAHAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_MAHAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_MAHAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_MAHAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN',		'MINOR_CIV_PHANTA_CS_TK_MAHAN_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_MAHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_MAHAN_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_MAHAN_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_MAHAN_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_MAHAN_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_MAHAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_MAHAN_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');


----------------------------------------
-- CHIYANG
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHIYANG',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_CHIYANG_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHIYANG',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHIYANG',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHIYANG_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHIYANG_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_CHIYANG_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHIYANG',		'LOC_CITY_NAME_PHANTA_CS_TK_CHIYANG');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG',		'LOC_CIVILIZATION_PHANTA_CS_TK_CHIYANG_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG',		'CIVILIZATION_PHANTA_CS_TK_CHIYANG',	'LOC_CITY_NAME_PHANTA_CS_TK_CHIYANG');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_CHIYANG',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_CHIYANG_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHIYANG_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_CHIYANG_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG',		'MINOR_CIV_PHANTA_CS_TK_CHIYANG_TRAIT');

-- Suzerain Bonus
--==== You gain a free heavy cavalry unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards heavy cavalry units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHIYANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_CHIYANG_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_CHIYANG_GRANT_HEAVY_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_HEAVY_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_CHIYANG_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_CHIYANG_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_CHIYANG_TRAIT', 'MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_CHIYANG_HEAVY_CAVALRY_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_HEAVY_CAVALRY');


----------------------------------------
-- MEI
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MEI',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_MEI',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_MEI_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MEI',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MEI',	'LOC_CIVILIZATION_PHANTA_CS_TK_MEI_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_MEI_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_MEI_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MEI',		'LOC_CITY_NAME_PHANTA_CS_TK_MEI');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MEI',		'LOC_CIVILIZATION_PHANTA_CS_TK_MEI_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MEI',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MEI',		'CIVILIZATION_PHANTA_CS_TK_MEI',	'LOC_CITY_NAME_PHANTA_CS_TK_MEI');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_MEI',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_MEI_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_MEI_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_MEI_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_MEI',		'MINOR_CIV_PHANTA_CS_TK_MEI_TRAIT');

-- Suzerain Bonus
--==== You gain a free heavy cavalry unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards heavy cavalry units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_MEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_MEI_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_EFFECT'),
('MODFEAT_PHANTA_CS_TK_MEI_GRANT_HEAVY_CAVALRY_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_HEAVY_CAVALRY');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_MEI_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_MEI_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_MEI_TRAIT', 'MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_MEI_HEAVY_CAVALRY_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_HEAVY_CAVALRY');


----------------------------------------
-- JINGNAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINGNAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_JINGNAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINGNAN',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINGNAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINGNAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINGNAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_JINGNAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINGNAN',		'LOC_CITY_NAME_PHANTA_CS_TK_JINGNAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_JINGNAN_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN',		'CIVILIZATION_PHANTA_CS_TK_JINGNAN',	'LOC_CITY_NAME_PHANTA_CS_TK_JINGNAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_JINGNAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_JINGNAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINGNAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_JINGNAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN',		'MINOR_CIV_PHANTA_CS_TK_JINGNAN_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINGNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_JINGNAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_JINGNAN_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');

----------------------------------------
-- DONGYE
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DONGYE',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_DONGYE_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DONGYE',		'CityStateCategory',	'TRADE');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DONGYE',	'LOC_CIVILIZATION_PHANTA_CS_TK_DONGYE_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_DONGYE_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_DONGYE_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DONGYE',		'LOC_CITY_NAME_PHANTA_CS_TK_DONGYE');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE',		'LOC_CIVILIZATION_PHANTA_CS_TK_DONGYE_NAME',	0,					'LEADER_MINOR_CIV_TRADE',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE',	'MINOR_CIV_BONUS_TRADE');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE',		'CIVILIZATION_PHANTA_CS_TK_DONGYE',	'LOC_CITY_NAME_PHANTA_CS_TK_DONGYE');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_DONGYE',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY',	'COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_DONGYE_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_DONGYE_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_DONGYE_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE',		'MINOR_CIV_PHANTA_CS_TK_DONGYE_TRAIT');

-- Suzerain Bonus
--== +1 Trade Route capacity.
--== Trade Routes gain +5 Gold.

--==== 1 Trade Route capacity

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_DONGYE_TRAIT', 'MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_CAPACITY', 'Amount', '1');

--==== 2 Trade Route gold

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_DONGYE_TRAIT', 'MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD', 'Amount', '5'), 
('MODFEAT_PHANTA_CS_TK_DONGYE_TRADE_ROUTE_GOLD', 'YieldType', 'YIELD_GOLD');


----------------------------------------
-- OKJEO
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_OKJEO',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_OKJEO',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_OKJEO',	'LOC_CIVILIZATION_PHANTA_CS_TK_OKJEO_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_OKJEO_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_OKJEO_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_OKJEO',		'LOC_CITY_NAME_PHANTA_CS_TK_OKJEO');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO',		'LOC_CIVILIZATION_PHANTA_CS_TK_OKJEO_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO',		'CIVILIZATION_PHANTA_CS_TK_OKJEO',	'LOC_CITY_NAME_PHANTA_CS_TK_OKJEO');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_OKJEO',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_OKJEO_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_OKJEO_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO',		'MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_OKJEO_TRAIT', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_OKJEO_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');

----------------------------------------
-- QINGZHOU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QINGZHOU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QINGZHOU',		'CityStateCategory',	'RELIGIOUS');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QINGZHOU',	'LOC_CIVILIZATION_PHANTA_CS_TK_QINGZHOU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_QINGZHOU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_QINGZHOU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QINGZHOU',		'LOC_CITY_NAME_PHANTA_CS_TK_QINGZHOU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU',		'LOC_CIVILIZATION_PHANTA_CS_TK_QINGZHOU_NAME',	0,					'LEADER_MINOR_CIV_RELIGIOUS',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU',	'MINOR_CIV_BONUS_RELIGIOUS');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU',		'CIVILIZATION_PHANTA_CS_TK_QINGZHOU',	'LOC_CITY_NAME_PHANTA_CS_TK_QINGZHOU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_QINGZHOU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY',	'COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_QINGZHOU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_QINGZHOU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU',		'MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT');

-- Suzerain Bonus
--== Killing a unit provides Faith equal to 25% of the defeated unit・s Combat Strength (at standard speed)..
--== May purchase cavalry units with Faith.

--==== 1 Faith per kill

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL', 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL', 'PercentDefeatedStrength', '25'), 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PER_KILL', 'YieldType', 'YIELD_FAITH');

--==== 2 Faith purchase - MELEE

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_MELEE', 'Tag', 'CLASS_MELEE');

--==== 2 Faith purchase - ANTI_CAVALRY

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_ANTI_CAVALRY', 'Tag', 'CLASS_ANTI_CAVALRY');

--==== 2 Faith purchase - RECON

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_QINGZHOU_TRAIT', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON', 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_QINGZHOU_FAITH_PURCHASE_RECON', 'Tag', 'CLASS_RECON');


----------------------------------------
-- KUNAKOKU
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_KUNAKOKU_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUNAKOKU_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUNAKOKU_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_KUNAKOKU_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',		'LOC_CITY_NAME_PHANTA_CS_TK_KUNAKOKU');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU',		'LOC_CIVILIZATION_PHANTA_CS_TK_KUNAKOKU_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU',		'CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',	'LOC_CITY_NAME_PHANTA_CS_TK_KUNAKOKU');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_KUNAKOKU',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_KUNAKOKU_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_KUNAKOKU_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_KUNAKOKU_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU',		'MINOR_CIV_PHANTA_CS_TK_KUNAKOKU_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUNAKOKU_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_KUNAKOKU_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_KUNAKOKU_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_KUNAKOKU_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_KUNAKOKU_TRAIT', 'MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_KUNAKOKU_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');


----------------------------------------
-- WUXIMAN
----------------------------------------
INSERT INTO	Types
		(Type,									Kind)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WUXIMAN',			'KIND_CIVILIZATION'),
		('LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN',		'KIND_LEADER'),
		('MINOR_CIV_PHANTA_CS_TK_WUXIMAN_TRAIT',		'KIND_TRAIT');

INSERT INTO TypeProperties
		(Type,								Name,					Value)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WUXIMAN',		'CityStateCategory',	'MILITARISTIC');

INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,										RandomCityNameDepth,	StartingCivilizationLevelType,		Ethnicity)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WUXIMAN',	'LOC_CIVILIZATION_PHANTA_CS_TK_WUXIMAN_NAME',	'LOC_CIVILIZATION_PHANTA_CS_TK_WUXIMAN_DESCRIPTION',	'LOC_CIVILIZATION_PHANTA_CS_TK_WUXIMAN_ADJECTIVE',	1,						'CIVILIZATION_LEVEL_CITY_STATE',	'ETHNICITY_ASIAN');

INSERT INTO	CityNames
		(CivilizationType,					CityName)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WUXIMAN',		'LOC_CITY_NAME_PHANTA_CS_TK_WUXIMAN');

INSERT INTO Leaders
		(LeaderType,							Name,									IsBarbarianLeader,	InheritFrom,					SceneLayers,	Sex,	SameSexPercentage)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN',		'LOC_CIVILIZATION_PHANTA_CS_TK_WUXIMAN_NAME',	0,					'LEADER_MINOR_CIV_MILITARISTIC',	0,				'Male',	0);

INSERT INTO Leaders_XP2
		(LeaderType,						MinorCivBonusType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN',	'MINOR_CIV_BONUS_MILITARISTIC');

INSERT INTO CivilizationLeaders
		(LeaderType,							CivilizationType,				CapitalName)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN',		'CIVILIZATION_PHANTA_CS_TK_WUXIMAN',	'LOC_CITY_NAME_PHANTA_CS_TK_WUXIMAN');

INSERT INTO	PlayerColors
		(Type,								Usage,			PrimaryColor,							SecondaryColor,									TextColor)
VALUES	('CIVILIZATION_PHANTA_CS_TK_WUXIMAN',		'Minor',		'COLOR_PLAYER_CITY_STATE_PRIMARY',		'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY',	'COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY');

INSERT INTO Traits
		(TraitType,							Name,										Description)
VALUES	('MINOR_CIV_PHANTA_CS_TK_WUXIMAN_TRAIT',	'LOC_LEADER_TRAIT_PHANTA_CS_TK_WUXIMAN_NAME',		'LOC_LEADER_TRAIT_PHANTA_CS_TK_WUXIMAN_DESCRIPTION');

INSERT INTO	LeaderTraits
		(LeaderType,							TraitType)
VALUES	('LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN',		'MINOR_CIV_PHANTA_CS_TK_WUXIMAN_TRAIT');

-- Suzerain Bonus
--==== You gain a free melee unit when you become this City-State・s suzerain for the first time.
--==== +20% Production towards melee units.

--==== 1 Grant unit

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WUXIMAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN', 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE', 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 0, 0, 0, NULL, NULL, 1),
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_EFFECT', 'MODTYPE_PHANTA_CS_TK_PLAYER_CAPITAL_CITY_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', 1, 1, 0, 'REQSET_CS_TK_WUXIMAN_PLAYER_HAS_CAPITAL', NULL, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_EFFECT'),
('MODFEAT_PHANTA_CS_TK_WUXIMAN_GRANT_MELEE_EFFECT', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQSET_CS_TK_WUXIMAN_PLAYER_HAS_CAPITAL', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQSET_CS_TK_WUXIMAN_PLAYER_HAS_CAPITAL', 'REQUIRES_CAPITAL_CITY');

--==== 2 Unit production

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('MINOR_CIV_PHANTA_CS_TK_WUXIMAN_TRAIT', 'MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION_ATTACH');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'PLAYER_IS_SUZERAIN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION_ATTACH', 'ModifierId', 'MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION');

----------
----------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION', 'Amount', '20'), 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION', 'EraType', 'NO_ERA'), 
('MODFEAT_PHANTA_CS_TK_WUXIMAN_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE');
