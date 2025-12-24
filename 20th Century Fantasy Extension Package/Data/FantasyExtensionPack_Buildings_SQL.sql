-- FantasyExtensionPack_Buildings_SQL
-- Author: PurpleSoul
-- DateCreated: 11/30/2024 12:08:22 PM
--------------------------------------------------------------

INSERT INTO Types(Type, Kind)
SELECT 'BUILDING_SWITCH_'||CivUniqueDistrictType, 'KIND_BUILDING'
FROM DistrictReplaces
UNION SELECT 'TRAIT_BUILDING_SWITCH_'||CivUniqueDistrictType, 'KIND_TRAIT'
FROM DistrictReplaces;

INSERT INTO Traits(TraitType)
SELECT 'TRAIT_BUILDING_SWITCH_'||CivUniqueDistrictType
FROM DistrictReplaces;

INSERT INTO Buildings(BuildingType, Name, Description, PrereqDistrict, Cost, TraitType)
SELECT  'BUILDING_SWITCH_'||CivUniqueDistrictType, 
        'LOC_BUILDING_SWITCH_'||CivUniqueDistrictType||'_NAME', 
        'LOC_BUILDING_SWITCH_'||CivUniqueDistrictType||'_DESCRIPTION', ReplacesDistrictType, 10,
        'TRAIT_BUILDING_SWITCH_'||CivUniqueDistrictType
FROM DistrictReplaces;	

INSERT INTO CivilopediaPageExcludes(SectionId, PageId)
SELECT 'BUILDINGS', 'BUILDING_SWITCH_'||CivUniqueDistrictType
FROM DistrictReplaces;


-- INSERT INTO LeaderTraits(LeaderType, TraitType)
-- SELECT 'LEADER_DENGXIAOPING_ALT', 'TRAIT_BUILDING_SWITCH_'||CivUniqueDistrictType
-- FROM DistrictReplaces;