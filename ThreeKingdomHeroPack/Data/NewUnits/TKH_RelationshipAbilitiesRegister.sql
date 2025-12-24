-- TKH_RelationshipAbilitiesRegister
-- Author: 10704
-- DateCreated: 11/6/2025 6:12:15 PM
--------------------------------------------------------------
INSERT INTO TKH_RelationshipAbilities(Name, Heroes) 
VALUES 
('HEIBEITINGZHU', 'YAN_LIANG,WEN_CHOU'),
('YINGXIONGMEINV', 'LV_BU,DIAO_CHAN'),
('BIYISHUANGFEI', 'LIU_BEI,SUN_SHANGXIANG'),
('YIMUTONGBAO', 'SUN_CE,SUN_QUAN,SUN_SHANGXIANG'),
('NANMANRUQIN', 'MU_LU,MENG_HUO'),
('DONGWUHUZHU', 'SUN_QUAN,ZHOU_TAI'),
('CAOSHISHUANGJIE', 'CAO_CAO,CAO_REN'),
('CAOSHIHUWEI', 'CAO_CAO,DIAN_WEI,XU_CHU'),
('WUHUSHANGJIANG', 'GUAN_YU,ZHANG_FEI,ZHAO_YUN,MA_CHAO,HUANG_ZHONG'),
('TAOYUAN', 'LIU_BEI,GUAN_YU,ZHANG_FEI'),
-- EXTENSION 3
('NANMANTUANJIE', 'MENG_HUO,ZHU_RONG,MU_LU,WU_TUGU,SHA_MOKE,DUO_SI');


INSERT INTO Types(Type, Kind)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'KIND_ABILITY'  FROM split WHERE splid != ''
UNION SELECT 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'KIND_ABILITY'  FROM split WHERE splid != '';

INSERT INTO TypeTags(Type, Tag)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'CLASS_HERO_TKH_'||splid  FROM split WHERE splid != ''
UNION SELECT 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'CLASS_HERO_TKH_'||splid  FROM split WHERE splid != '';

INSERT INTO UnitAbilities(UnitAbilityType)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'ABILITY_RELATIONSHIP_'||Name||'_'||splid FROM split WHERE splid != '';

INSERT INTO UnitAbilities(UnitAbilityType, Description, Inactive, Permanent)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'LOC_ABILITY_MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 1, 0  FROM split WHERE splid != '';

INSERT INTO UnitAbilityModifiers(UnitAbilityType, ModifierId)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'ABILITY_RELATIONSHIP_'||s1.Name||'_'||s1.splid, 'MODIFIER_ABILITY_RELATIONSHIP_'||s1.Name||'_'||s2.splid
FROM split AS s1 JOIN split AS s2
WHERE s1.splid != s2.splid AND s1.splid != '' AND s2.splid != '' AND s1.Name == s2.Name;

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY', 'AOE5_REQUIREMENTS' FROM split WHERE splid != '';

INSERT INTO ModifierArguments(ModifierId, Name, Value)
WITH split(Name,splid,idsstr) AS
(
  SELECT  Name,'',Heroes||',' FROM TKH_RelationshipAbilities
  UNION ALL 
   SELECT Name,substr(idsstr, 0, instr(idsstr, ',')),substr(idsstr, instr(idsstr, ',')+1)
    FROM split WHERE idsstr!=''
)
SELECT 'MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid, 'AbilityType', 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_'||Name||'_'||splid FROM split WHERE splid != '';


UPDATE Modifiers
SET SubjectRequirementSetId='REQS_NOT_SELF_PLOT' WHERE ModifierId LIKE 'MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_%';
