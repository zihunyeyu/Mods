-- ManYuDingZhi_Config
-- Author: SFDH100
-- DateCreated: 2023/12/14 20:58:37
--当前共9行
--------------------------------------------------------------
DELETE FROM Players WHERE LeaderType="LEADER_SULEIMAN_ALT";	--删除苏莱曼一世（大帝）
DELETE FROM PlayerItems WHERE LeaderType="LEADER_SULEIMAN_ALT";	--删除苏莱曼一世（大帝）
INSERT OR REPLACE INTO PlayerItems (Domain, CivilizationType, LeaderType, Type, Name, Description, Icon, SortIndex)VALUES
('Players:Expansion2_Players',	'CIVILIZATION_OTTOMAN',	'LEADER_SULEIMAN','UNIT_SFDH100_DARDANELLES',	'LOC_UNIT_SFDH100_DARDANELLES_NAME',	'LOC_UNIT_SFDH100_DARDANELLES_DESCRIPTION',	'ICON_UNIT_BOMBARD',	'10');

-- 两个波斯就留个居鲁士
DELETE FROM Players WHERE LeaderType = 'LEADER_NADER_SHAH';
DELETE FROM PlayerItems WHERE LeaderType = 'LEADER_NADER_SHAH';
DELETE FROM MapLeaders WHERE LeaderType = 'LEADER_NADER_SHAH';
DELETE FROM MapStartPositions WHERE Value = 'LEADER_NADER_SHAH';

DELETE FROM PlayerItems WHERE Type = 'IMPROVEMENT_GOLF_COURSE';

-- 删除莽骑兵
DELETE FROM Players WHERE LeaderType = 'LEADER_T_ROOSEVELT_ROUGHRIDER';
DELETE FROM PlayerItems WHERE LeaderType = 'LEADER_T_ROOSEVELT_ROUGHRIDER';
DELETE FROM MapLeaders WHERE LeaderType = 'LEADER_T_ROOSEVELT_ROUGHRIDER';
DELETE FROM MapStartPositions WHERE Value = 'LEADER_T_ROOSEVELT_ROUGHRIDER';
DELETE FROM DuplicateLeaders WHERE OtherLeaderType = 'LEADER_T_ROOSEVELT_ROUGHRIDER';

-- -拉美西斯和最早的埃及都删了，就留一个托勒密
DELETE FROM Players WHERE LeaderType = 'LEADER_CLEOPATRA';
DELETE FROM PlayerItems WHERE LeaderType = 'LEADER_CLEOPATRA';
DELETE FROM MapLeaders WHERE LeaderType = 'LEADER_CLEOPATRA';
DELETE FROM MapStartPositions WHERE Value = 'LEADER_CLEOPATRA';
DELETE FROM DuplicateLeaders WHERE LeaderType = 'LEADER_CLEOPATRA';
DELETE FROM Players WHERE LeaderType = 'LEADER_RAMSES';
DELETE FROM PlayerItems WHERE LeaderType = 'LEADER_RAMSES';
DELETE FROM MapLeaders WHERE LeaderType = 'LEADER_RAMSES';
DELETE FROM MapStartPositions WHERE Value = 'LEADER_RAMSES';

--两个马里合体，留个曼沙穆萨
DELETE FROM Players WHERE LeaderType = 'LEADER_SUNDIATA_KEITA';
DELETE FROM PlayerItems WHERE LeaderType = 'LEADER_SUNDIATA_KEITA';
DELETE FROM MapLeaders WHERE LeaderType = 'LEADER_SUNDIATA_KEITA';
DELETE FROM MapStartPositions WHERE Value = 'LEADER_SUNDIATA_KEITA';

INSERT INTO GameModePlayerInfoOverrides
		(GameModeType,				Domain,								CivilizationType,			LeaderType,				LeaderAbilityDescription,											CivilizationAbilityDescription)
VALUES 	('GAMEMODE_MONOPOLIES',		'Players:Expansion2_Players',		'CIVILIZATION_AMERICA',		'LEADER_T_ROOSEVELT',	'LOC_TRAIT_LEADER_ANTIQUES_AND_PARKS_MYN_MONOPOLIES_DESCRIPTION',	'LOC_TRAIT_CIVILIZATION_FOUNDING_FATHERS_EXPANSION2_DESCRIPTION');

INSERT INTO PlayerInfoOverrideQueries
		(QueryId)
VALUES 	('MynRooseveltMonopoliesModePlayerInfoOverrides');

INSERT INTO Queries
		(QueryId,											SQL)
VALUES 	('MynRooseveltMonopoliesModePlayerInfoOverrides',	'SELECT * FROM GameModePlayerInfoOverrides WHERE GameModeType = ''GAMEMODE_MONOPOLIES''');

INSERT INTO QueryCriteria
		(QueryId,											ConfigurationGroup,			ConfigurationId,		Operator,			ConfigurationValue)
VALUES 	('MynRooseveltMonopoliesModePlayerInfoOverrides',	'Game',						'GAMEMODE_MONOPOLIES',	'Equals',			'1');

