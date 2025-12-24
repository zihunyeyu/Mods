--====================================================
-- 效果：建造区域及区域内建筑时间减半。
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType)
SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType||'_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType||'_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'
FROM Districts;
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType, 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType, 'Amount', 100
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType, 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType, 'Amount', 50
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType||'_BUILDING', 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_50PERCENT_'||DistrictType||'_BUILDING', 'Amount', 50
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType||'_BUILDING', 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||DistrictType||'_BUILDING', 'Amount', 100
FROM Districts;
--====================================================
-- 效果：建造建筑时间减半。
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType)
SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||BuildingType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'
FROM Buildings;
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||BuildingType, 'BuildingType', BuildingType
FROM Buildings
UNION SELECT 'MODIFIER_BOOST_PRODUCTION_100PERCENT_'||BuildingType, 'Amount', 100
FROM Buildings;
--====================================================
-- 效果：区域、建筑、改良释放文化炸弹。
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType)
SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||BuildingType, 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER'
FROM Buildings
UNION SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||DistrictType, 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER'
FROM Districts
UNION SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||ImprovementType, 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER'
FROM Improvements;
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||BuildingType, 'BuildingType', BuildingType
FROM Buildings
UNION SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||DistrictType, 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER_'||ImprovementType, 'ImprovementType', ImprovementType
FROM Improvements;
--====================================================
-- 效果：区域XX提供宜居度。
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
SELECT 'MODIFIER_'||DistrictType||'_ADJUST_EXTRA_ENTERTAINMENT', 'MODIFIER_PLAYER_DISTRICTS_ADJUST_EXTRA_ENTERTAINMENT', 'PS_REQS_IS_'||DistrictType
FROM Districts;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MODIFIER_'||DistrictType||'_ADJUST_EXTRA_ENTERTAINMENT', 'Amount', '1'
FROM Districts;
--====================================================
-- 效果：解锁特质
-- UNIQUE_ABILITIES = TRAITS
-- LEADER_TRAITS
CREATE TABLE CCTraits
(
       TraitType TEXT PRIMARY KEY,
       FOREIGN KEY(TraitType) REFERENCES Traits(TraitType)
);
CREATE TABLE CCTraitsModifiers
(
       TraitType TEXT,
       ModifierId TEXT,
       FOREIGN KEY(TraitType) REFERENCES Traits(TraitType),
       FOREIGN KEY(ModifierId) REFERENCES Modifiers(ModifierId)
);
INSERT OR IGNORE INTO CCTraits
SELECT TraitType FROM LeaderTraits 
WHERE 
(SELECT COUNT(1) AS NUM FROM Units WHERE Units.TraitType = LeaderTraits.TraitType) = 0 AND
(SELECT COUNT(1) AS NUM FROM Improvements WHERE Improvements.TraitType = LeaderTraits.TraitType) = 0 AND
(SELECT COUNT(1) AS NUM FROM Buildings WHERE Buildings.TraitType = LeaderTraits.TraitType) = 0;
INSERT OR IGNORE INTO CCTraits
SELECT TraitType FROM CivilizationTraits 
WHERE 
(SELECT COUNT(1) AS NUM FROM Units WHERE Units.TraitType = CivilizationTraits.TraitType) = 0 AND
(SELECT COUNT(1) AS NUM FROM Improvements WHERE Improvements.TraitType = CivilizationTraits.TraitType) = 0 AND
(SELECT COUNT(1) AS NUM FROM Buildings WHERE Buildings.TraitType = CivilizationTraits.TraitType) = 0;
INSERT OR IGNORE INTO CCTraitsModifiers (TraitType, ModifierId)
SELECT  CCTraits.TraitType,TraitModifiers.ModifierId
FROM CCTraits
JOIN TraitModifiers ON CCTraits.TraitType = TraitModifiers.TraitType;
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
SELECT  'UNIQUE_'||ModifierId, 'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER', 'REQS_UNIQUE_'||ModifierId
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT  'UNIQUE_'||ModifierId
       ,'ModifierId'
       ,ModifierId
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType)
SELECT  'REQS_UNIQUE_'||ModifierId
       ,'REQUIREMENTSET_TEST_ALL'
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId)
SELECT  'REQS_UNIQUE_'||ModifierId
       ,'REQ_UNIQUE_'||ModifierId
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT  'REQ_UNIQUE_'||ModifierId
       ,'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||ModifierId
       ,'PropertyName'
       ,'UNIQUE_PROPERTY_'||ModifierId
FROM CCTraitsModifiers;
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||ModifierId
       ,'PropertyMinimum'
       ,1
FROM CCTraitsModifiers;
-- UNIQUE_UNITS
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
SELECT  'UNIQUE_'||UnitType
       ,'MODIFIER_PLAYER_ADJUST_VALID_UNIT_BUILD'
       ,'REQS_UNIQUE_'||UnitType
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT  'UNIQUE_'||UnitType
       ,'UnitType'
       ,UnitType
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType)
SELECT  'REQS_UNIQUE_'||UnitType
       ,'REQUIREMENTSET_TEST_ALL'
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId)
SELECT  'REQS_UNIQUE_'||UnitType
       ,'REQ_UNIQUE_'||UnitType
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT  'REQ_UNIQUE_'||UnitType
       ,'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||UnitType
       ,'PropertyName'
       ,'UNIQUE_PROPERTY_'||UnitType
FROM Units
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||UnitType
       ,'PropertyMinimum'
       ,1
FROM Units
WHERE TraitType != '';
-- UNIQUE_IMPROVEMENTS
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
SELECT  'UNIQUE_'||ImprovementType
       ,'MODIFIER_PLAYER_ADJUST_VALID_IMPROVEMENT'
       ,'REQS_UNIQUE_'||ImprovementType
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT  'UNIQUE_'||ImprovementType
       ,'ImprovementType'
       ,ImprovementType
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType)
SELECT  'REQS_UNIQUE_'||ImprovementType
       ,'REQUIREMENTSET_TEST_ALL'
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId)
SELECT  'REQS_UNIQUE_'||ImprovementType
       ,'REQ_UNIQUE_'||ImprovementType
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT  'REQ_UNIQUE_'||ImprovementType
       ,'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||ImprovementType
       ,'PropertyName'
       ,'UNIQUE_PROPERTY_'||ImprovementType
FROM Improvements
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||ImprovementType
       ,'PropertyMinimum'
       ,1
FROM Improvements
WHERE TraitType != '';
-- UNIQUE_BUILDINGS
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
SELECT  'UNIQUE_'||BuildingType
       ,'MODIFIER_PLAYER_ADJUST_VALID_BUILDING'
       ,'REQS_UNIQUE_'||BuildingType
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT  'UNIQUE_'||BuildingType
       ,'BuildingType'
       ,BuildingType
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSets(RequirementSetId, RequirementSetType)
SELECT  'REQS_UNIQUE_'||BuildingType
       ,'REQUIREMENTSET_TEST_ALL'
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementSetRequirements(RequirementSetId, RequirementId)
SELECT  'REQS_UNIQUE_'||BuildingType
       ,'REQ_UNIQUE_'||BuildingType
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT  'REQ_UNIQUE_'||BuildingType
       ,'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||BuildingType
       ,'PropertyName'
       ,'UNIQUE_PROPERTY_'||BuildingType
FROM Buildings
WHERE TraitType != '';
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT  'REQ_UNIQUE_'||BuildingType
       ,'PropertyMinimum'
       ,1
FROM Buildings
WHERE TraitType != '';