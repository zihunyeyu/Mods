CREATE TABLE TCEP_UNIT_TAG
(
	UnitType TEXT,
    Tag TEXT
);

INSERT OR IGNORE INTO TCEP_UNIT_TAG(UnitType, Tag)
VALUES
('BATTLE_LAND', 'CLASS_RECON'),			-- 侦查	
('BATTLE_LAND', 'CLASS_MELEE'),			-- 近战
('BATTLE_LAND', 'CLASS_RANGED'),		-- 远程
('BATTLE_LAND', 'CLASS_SIEGE'),			-- 攻城
('BATTLE_LAND', 'CLASS_HEAVY_CAVALRY'),	-- 重骑兵
('BATTLE_LAND', 'CLASS_LIGHT_CAVALRY'),	-- 轻骑兵
('BATTLE_LAND', 'CLASS_ANTI_CAVALRY'),	-- 抗骑兵
('BATTLE_LAND', 'CLASS_RANGED_CAVALRY'),-- 远程骑兵
('BATTLE_LAND', 'CLASS_HEAVY_CHARIOT'),	-- 重骑兵
('BATTLE_LAND', 'CLASS_LIGHT_CHARIOT'),	-- 轻骑兵
('BATTLE_LAND', 'CLASS_WARRIOR_MONK');	-- 武僧

-- 沿海经济开放区 所有港口相邻加成表
CREATE TABLE COZ_Adjacency_Districts
(
	id INTEGER PRIMARY KEY,
	District TEXT NOT NULL UNIQUE
);
-- 查找所有港口，包括港口的替代
INSERT INTO COZ_Adjacency_Districts(District) VALUES ("DISTRICT_HARBOR");
INSERT INTO COZ_Adjacency_Districts(District)
SELECT CivUniqueDistrictType AS District FROM DistrictReplaces 
WHERE ReplacesDistrictType == "DISTRICT_HARBOR";

-- 插入非重复相邻加成表
CREATE TABLE COZ_Adjacency_YieldChanges
(
	ID TEXT NOT NULL UNIQUE, 
	Description TEXT, 
	YieldType TEXT, 
	YieldChange INTEGER, 
	TilesRequired INTEGER, 
	AdjacentDistrict TEXT
);
INSERT OR IGNORE INTO COZ_Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
SELECT District || '_SCIENCE' || '_COZ', 'LOC_COZ_SCIENCE_FROM_HARBOR', 'YIELD_SCIENCE', 1, 1, District
FROM COZ_Adjacency_Districts;

INSERT OR IGNORE INTO COZ_Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
SELECT replace(ID, 'SCIENCE', 'CULTURE'), replace(Description, 'SCIENCE', 'CULTURE'), 'YIELD_CULTURE', YieldChange, TilesRequired, AdjacentDistrict
FROM COZ_Adjacency_YieldChanges;

INSERT OR IGNORE INTO Adjacency_YieldChanges(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
SELECT * FROM COZ_Adjacency_YieldChanges;

INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) 
SELECT "DISTRICT_COASTAL_OPEN_ZONE", ID 
FROM COZ_Adjacency_YieldChanges;


CREATE TABLE Farm_Adjacency_Districts
(
	DistrictType TEXT PRIMARY KEY,
    YieldType TEXT
);

INSERT INTO Farm_Adjacency_Districts (DistrictType, YieldType)
VALUES
('DISTRICT_HOLY_SITE', 'YIELD_FAITH'),
('DISTRICT_CAMPUS', 'YIELD_SCIENCE'),
('DISTRICT_HARBOR', 'YIELD_GOLD'),
('DISTRICT_COMMERCIAL_HUB', 'YIELD_GOLD'),
('DISTRICT_THEATER', 'YIELD_CULTURE'),
('DISTRICT_INDUSTRIAL_ZONE', 'YIELD_PRODUCTION');