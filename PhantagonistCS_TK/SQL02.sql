-- SQL02
-- Author: hnoyy
-- DateCreated: 9/3/2023 7:49:56 PM
--------------------------------------------------------------

INSERT or replace  INTO TypeProperties
            (Type,                                            Name,        Value)
VALUES        ('UNIT_PHANTA_SUN_CE_TIGER_RETINUE_WARSHIP',    'LIFESPAN',    10);


INSERT or replace  INTO TypeProperties
            (Type,                                            Name,        Value)
VALUES        ('UNIT_PHANTA_SUN_CE_TIGER_RETINUE_CAVALRY',    'LIFESPAN',    10);




update Units_XP2 set ResourceMaintenanceAmount =  0 WHERE UnitType='UNIT_PHANTA_QINBING';
update Units_XP2 set ResourceMaintenanceAmount =  0 WHERE UnitType='UNIT_PHANTA_WHITE_PLUMED_GUARD';

INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES 
('REQ_NEA_HUAISI_CAN_GET_GREAT_GENERAL', 'REQUIREMENT_PLAYER_CAN_EVER_EARN_GREAT_PERSON_CLASS', 0), 
('REQ_NEA_HUAISI_NOT_MINOR', 'REQUIREMENT_PLAYER_IS_MINOR', 1);

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
('REQ_NEA_HUAISI_CAN_GET_GREAT_GENERAL', 'GreatPersonClass', 'GREAT_PERSON_CLASS_GENERAL');

insert or replace into RequirementSets (RequirementSetId, RequirementSetType ) 
VALUES


('REQSET_NEA_HUAISI_NOT_MINOR', 'REQUIREMENTSET_TEST_ALL');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId ) 
VALUES

('REQSET_NEA_HUAISI_NOT_MINOR', 'REQ_NEA_HUAISI_NOT_MINOR');

update Modifiers set SubjectRequirementSetId =  'REQSET_NEA_HUAISI_NOT_MINOR' WHERE ModifierId='MODIF_NEA_REG_CAPITAL_HUAISI_GRANT_GREAT_GENERAL';

UPDATE Feature_YieldChanges SET YieldChange='1' WHERE FeatureType = 'FEATURE_FOREST';

update Eras set EmbarkedUnitStrength =  15;


insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_OLD_GOD_OBELISK','YIELD_PRODUCTION', '3' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_OLD_GOD_OBELISK');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_OLD_GOD_OBELISK','YIELD_CULTURE', '3' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_OLD_GOD_OBELISK');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_OLD_GOD_OBELISK','YIELD_SCIENCE', '3' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_OLD_GOD_OBELISK');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_OLD_GOD_OBELISK','YIELD_GOLD', '7' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_OLD_GOD_OBELISK');



insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_MONUMENT','YIELD_PRODUCTION', '2' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_MONUMENT');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_MONUMENT','YIELD_CULTURE', '2' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_MONUMENT');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_MONUMENT','YIELD_SCIENCE', '2' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_MONUMENT');
insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_MONUMENT','YIELD_GOLD', '5' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_MONUMENT');

insert or replace into Building_YieldChanges(BuildingType, YieldType, YieldChange) select  'BUILDING_GRANARY','YIELD_FOOD', '9' from Buildings where exists (select BuildingType  from Buildings where BuildingType = 'BUILDING_MONUMENT');


delete from CityNames;
insert or replace into CityNames(CivilizationType, CityName) select  'CIVILIZATION_CHINA','LOC_NEA_SR02_NEWCITY_02';

--insert or replace into CityNames(CivilizationType, CityName) select  'CIVILIZATION_PHANTA_XIONGNU','LOC_NEA_SR02_NEWCITY';
--

update Districts set CitizenSlots = 3 where DistrictType = 'DISTRICT_DAM';
update Districts set CitizenSlots = 1 where DistrictType = 'DISTRICT_AQUEDUCT';
insert or replace into District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) select 'DISTRICT_DAM', 'YIELD_FOOD', 12; 
insert or replace into District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) select 'DISTRICT_AQUEDUCT', 'YIELD_FOOD', 12;



update Units set StrategicResource ='RESOURCE_IRON' where UnitType = 'UNIT_CATAPULT'; 
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType,  ResourceMaintenanceAmount ) select  'UNIT_CATAPULT',5,'RESOURCE_IRON',0; 
--
update Units set StrategicResource ='RESOURCE_IRON' where UnitType = 'UNIT_TREBUCHET'; 
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType,  ResourceMaintenanceAmount ) select  'UNIT_TREBUCHET',5,'RESOURCE_IRON',0; 
--



--UPDATE Technologies SET Cost = 500 WHERE EraType = 'ERA_ANCIENT';
--UPDATE Technologies SET Cost = 1200 WHERE EraType = 'ERA_CLASSICAL';
--UPDATE Technologies SET Cost = 3600 WHERE EraType = 'ERA_MEDIEVAL';
--UPDATE Technologies SET Cost = 10000 WHERE EraType = 'ERA_RENAISSANCE';
--UPDATE Technologies SET Cost = 20000 WHERE EraType = 'ERA_INDUSTRIAL';
--UPDATE Technologies SET Cost = 40000 WHERE EraType = 'ERA_MODERN';
--UPDATE Technologies SET Cost = 60000 WHERE EraType = 'ERA_ATOMIC';
--UPDATE Technologies SET Cost = 90000 WHERE EraType = 'ERA_INFORMATION';
--UPDATE Technologies SET Cost = 120000 WHERE EraType = 'ERA_FUTURE';
--
--UPDATE Civics SET Cost = 500 WHERE EraType = 'ERA_ANCIENT';
--UPDATE Civics SET Cost = 1200 WHERE EraType = 'ERA_CLASSICAL';
--UPDATE Civics SET Cost = 3600 WHERE EraType = 'ERA_MEDIEVAL';
--UPDATE Civics SET Cost = 10000 WHERE EraType = 'ERA_RENAISSANCE';
--UPDATE Civics SET Cost = 20000 WHERE EraType = 'ERA_INDUSTRIAL';
--UPDATE Civics SET Cost = 40000 WHERE EraType = 'ERA_MODERN';
--UPDATE Civics SET Cost = 60000 WHERE EraType = 'ERA_ATOMIC';
--UPDATE Civics SET Cost = 90000 WHERE EraType = 'ERA_INFORMATION';
--UPDATE Civics SET Cost = 120000 WHERE EraType = 'ERA_FUTURE';
--
--

DELETE FROM Improvements WHERE PrereqTech='TECH_SEASTEADS';
DELETE FROM Improvements WHERE PrereqTech='TECH_PREDICTIVE_SYSTEMS';
DELETE FROM Improvement_BonusYieldChanges WHERE PrereqTech='TECH_CYBERNETICS';
DELETE FROM Improvement_BonusYieldChanges WHERE PrereqTech='TECH_SMART_MATERIALS';
DELETE FROM Improvement_BonusYieldChanges WHERE PrereqTech='TECH_PREDICTIVE_SYSTEMS';
DELETE FROM Improvement_BonusYieldChanges WHERE PrereqTech='TECH_PREDICTIVE_SYSTEMS';


DELETE FROM Policies WHERE PrereqCivic='CIVIC_SMART_POWER_DOCTRINE';
DELETE FROM Policies WHERE PrereqCivic='CIVIC_INFORMATION_WARFARE';
DELETE FROM Policies WHERE PrereqCivic='CIVIC_EXODUS_IMPERATIVE';
DELETE FROM Policies WHERE PrereqCivic='CIVIC_CULTURAL_HEGEMONY';


DELETE FROM Projects WHERE PrereqCivic='CIVIC_GLOBAL_WARMING_MITIGATION';
DELETE FROM Projects WHERE PrereqTech='TECH_SMART_MATERIALS';


UPDATE Technologies SET Cost = Cost*5 WHERE EraType = 'ERA_ANCIENT';
UPDATE Technologies SET Cost = Cost*6 WHERE EraType = 'ERA_CLASSICAL';
UPDATE Technologies SET Cost = Cost*25 WHERE EraType = 'ERA_MEDIEVAL';
UPDATE Technologies SET Cost = Cost*150 WHERE EraType = 'ERA_RENAISSANCE';
UPDATE Technologies SET Cost = Cost*150 WHERE EraType = 'ERA_INDUSTRIAL';
UPDATE Technologies SET Cost = Cost*150 WHERE EraType = 'ERA_MODERN';
UPDATE Technologies SET Cost = Cost*150 WHERE EraType = 'ERA_ATOMIC';
UPDATE Technologies SET Cost = Cost*180 WHERE EraType = 'ERA_INFORMATION';
UPDATE Technologies SET Cost = Cost*182 WHERE EraType = 'ERA_FUTURE';

delete FROM Technologies WHERE EraType = 'ERA_FUTURE';


UPDATE Civics SET Cost = Cost*2 WHERE EraType = 'ERA_ANCIENT';
UPDATE Civics SET Cost = Cost*4 WHERE EraType = 'ERA_CLASSICAL';
UPDATE Civics SET Cost = Cost*20 WHERE EraType = 'ERA_MEDIEVAL';
UPDATE Civics SET Cost = Cost*50 WHERE EraType = 'ERA_RENAISSANCE';
UPDATE Civics SET Cost = Cost*80 WHERE EraType = 'ERA_INDUSTRIAL';
UPDATE Civics SET Cost = Cost*100 WHERE EraType = 'ERA_MODERN';
UPDATE Civics SET Cost = Cost*100 WHERE EraType = 'ERA_ATOMIC';
UPDATE Civics SET Cost = Cost*110 WHERE EraType = 'ERA_INFORMATION';
UPDATE Civics SET Cost = Cost*122 WHERE EraType = 'ERA_FUTURE';

delete FROM Civics WHERE EraType = 'ERA_FUTURE';

UPDATE Districts SET Cost = Cost*1.35;
UPDATE Buildings SET Cost = Cost*1.35;
UPDATE Units SET Cost = Cost*1.35;


--UPDATE Technologies SET Cost = Cost*3;
--UPDATE Civics SET Cost = Cost*3;

--UPDATE Technologies_XP2 SET RandomPrereqs = 0;

UPDATE Civics SET Cost = 10 WHERE CivicType = 'CIVIC_MILITARY_TRADITION';

CREATE TABLE IF NOT EXISTS TechnologyRandomCosts (Cost INT, TechnologyType TEXT); 
UPDATE TechnologyRandomCosts SET Cost = 666676666;

--
--UPDATE TechnologyRandomCosts SET Cost = 2000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_ANCIENT');
--UPDATE TechnologyRandomCosts SET Cost = 6000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_CLASSICAL');
--UPDATE TechnologyRandomCosts SET Cost = 15000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_MEDIEVAL');
--UPDATE TechnologyRandomCosts SET Cost = 30000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_RENAISSANCE');
--UPDATE TechnologyRandomCosts SET Cost = 60000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_INDUSTRIAL');
--UPDATE TechnologyRandomCosts SET Cost = 120000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_MODERN');
--UPDATE TechnologyRandomCosts SET Cost = 250000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_ATOMIC');
--UPDATE TechnologyRandomCosts SET Cost = 450000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_INFORMATION');
--UPDATE TechnologyRandomCosts SET Cost = 750000 WHERE TechnologyType IN (SELECT TechnologyType FROM Technologies WHERE EraType = 'ERA_FUTURE');
--

CREATE TABLE IF NOT EXISTS CivicRandomCosts (Cost INT, CivicType TEXT); 		
UPDATE CivicRandomCosts SET Cost = 666676666;					

--UPDATE CivicRandomCosts SET Cost = 2000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_ANCIENT');
--UPDATE CivicRandomCosts SET Cost = 6000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_CLASSICAL');
--UPDATE CivicRandomCosts SET Cost = 15000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_MEDIEVAL');
--UPDATE CivicRandomCosts SET Cost = 30000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_RENAISSANCE');
--UPDATE CivicRandomCosts SET Cost = 60000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_INDUSTRIAL');
--UPDATE CivicRandomCosts SET Cost = 120000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_MODERN');
--UPDATE CivicRandomCosts SET Cost = 250000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_ATOMIC');
--UPDATE CivicRandomCosts SET Cost = 450000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_INFORMATION');
--UPDATE CivicRandomCosts SET Cost = 750000 WHERE CivicType IN (SELECT CivicType FROM Civics WHERE EraType = 'ERA_FUTURE');
--
