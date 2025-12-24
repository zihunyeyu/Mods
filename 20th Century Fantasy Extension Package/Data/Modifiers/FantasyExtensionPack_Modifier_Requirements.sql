-- 玩家为LEADER_XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_IS_'||LeaderType, 'REQUIREMENTSET_TEST_ALL'
FROM Leaders;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_IS_'||LeaderType, 'REQ_IS_'||LeaderType
FROM Leaders;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_IS_'||LeaderType, 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'
FROM Leaders;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_IS_'||LeaderType, 'LeaderType', LeaderType
FROM Leaders;

-- 玩家拥有TRAIT_XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_HAS_'||TraitType, 'REQUIREMENTSET_TEST_ALL'
FROM Traits;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_HAS_'||TraitType, 'REQ_HAS_'||TraitType
FROM Traits;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_HAS_'||TraitType, 'REQUIREMENT_PLAYER_HAS_CIVILIZATION_OR_LEADER_TRAIT'
FROM Traits;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_HAS_'||TraitType, 'TraitType', TraitType
FROM Traits;

-- 区域是DISTRICT_XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_DISTRICT_IS_'||DistrictType, 'REQUIREMENTSET_TEST_ALL'
FROM Districts;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_DISTRICT_IS_'||DistrictType, 'REQ_DISTRICT_IS_'||DistrictType
FROM Districts;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_DISTRICT_IS_'||DistrictType, 'REQUIREMENT_DISTRICT_TYPE_MATCHES'
FROM Districts;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_DISTRICT_IS_'||DistrictType, 'DistrictType', DistrictType
FROM Districts;

-- 城市拥有DISTRICT_XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_HAS_'||DistrictType, 'REQUIREMENTSET_TEST_ALL'
FROM Districts;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_HAS_'||DistrictType, 'REQ_HAS_'||DistrictType
FROM Districts;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_HAS_'||DistrictType, 'REQUIREMENT_CITY_HAS_DISTRICT'
FROM Districts;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_HAS_'||DistrictType, 'DistrictType', DistrictType
FROM Districts;

-- PLOT改良类型
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_IS_'||ImprovementType, 'REQUIREMENTSET_TEST_ALL'
FROM Improvements;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_IS_'||ImprovementType, 'REQ_PLOT_IS_'||ImprovementType
FROM Improvements;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_IS_'||ImprovementType, 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'
FROM Improvements;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_IS_'||ImprovementType, 'ImprovementType', ImprovementType
FROM Improvements;

-- PLOT相邻DISTRICT_XX
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQS_PLOT_ADJACENT_'||DistrictType, 'REQUIREMENTSET_TEST_ALL'
FROM Districts;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQS_PLOT_ADJACENT_'||DistrictType, 'REQ_PLOT_ADJACENT_'||DistrictType
FROM Districts;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_PLOT_ADJACENT_'||DistrictType, 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES'
FROM Districts;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_PLOT_ADJACENT_'||DistrictType, 'DistrictType', DistrictType
FROM Districts
UNION SELECT 'REQ_PLOT_ADJACENT_'||DistrictType, 'MinRange', 1
FROM Districts
UNION SELECT 'REQ_PLOT_ADJACENT_'||DistrictType, 'MaxRange', 1
FROM Districts;