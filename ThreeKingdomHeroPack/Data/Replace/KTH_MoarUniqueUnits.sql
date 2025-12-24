-- KTH_MoarUniqueUnits
-- Author: PurpleSoul
-- DateCreated: 3/1/2025 11:06:46 PM
--------------------------------------------------------------
-- DELETE FROM ConfigEnabledUniqueUnits WHERE OwnerType='CIVILIZATION_CHINA';

DELETE FROM CivilizationTraits WHERE TraitType='TRAIT_CIVILIZATION_UNIT_CHINESE_SHIGONG';
DELETE FROM CivilizationTraits WHERE TraitType='TRAIT_CIVILIZATION_UNIT_CHINESE_CHOKONU';



DELETE FROM Units WHERE UnitType='UNIT_CHINESE_CHOKONU';
DELETE FROM Units WHERE UnitType='UNIT_CHINESE_SHIGONG';
-- UNIT_CHINESE_CHOKONU
-- UNIT_CHINESE_SHIGONG