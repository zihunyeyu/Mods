-- ManYuDingZhi
-- Author: SFDH100
-- DateCreated: 2023/8/13 10:29:45
--当前共 144 行
--------------------------------------------------------------
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_MASS_PRODUCTION' 									WHERE ImprovementType = "IMPROVEMENT_LUMBER_MILL"	 AND PrereqTech = 'TECH_STEEL';--伐木场加1生产力的效果转移到批量生产科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_REPLACEABLE_PARTS' 									WHERE ImprovementType = "IMPROVEMENT_PLANTATION"	 AND PrereqTech = 'TECH_SCIENTIFIC_THEORY';--种植园改良设施提供的粮食加1的效果转移到零件规格化科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_REPLACEABLE_PARTS',YieldType = 'YIELD_FOOD' 		WHERE ImprovementType = "IMPROVEMENT_FISHING_BOATS"	 AND PrereqTech = 'TECH_PLASTICS';--塑料渔船+1生产力效果转移到零件规格化科技并改为食物
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_ENGINEERING' 										WHERE ImprovementType = "IMPROVEMENT_QUARRY"		 AND PrereqTech = 'TECH_GUNPOWDER';--火药的采石场加1生产力效果转移到工程科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_CHEMISTRY' 											WHERE ImprovementType = "IMPROVEMENT_QUARRY"		 AND PrereqTech = 'TECH_ROCKETRY';--高级热力学的采石场加1生产力效果转移到化学科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_ROBOTICS' 											WHERE ImprovementType = "IMPROVEMENT_MINE"			 AND PrereqTech = 'TECH_SMART_MATERIALS';--智能材料的矿山加1生产力效果转移到机器人科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_ROBOTICS' 											WHERE ImprovementType = "IMPROVEMENT_QUARRY"		 AND PrereqTech = 'TECH_PREDICTIVE_SYSTEMS';--预报系统的采石场加1生产力效果转移到机器人科技
UPDATE Improvement_BonusYieldChanges SET PrereqTech = 'TECH_ROBOTICS' 											WHERE ImprovementType = "IMPROVEMENT_LUMBER_MILL"	 AND PrereqTech = 'TECH_CYBERNETICS';--量子计算机的伐木场加1生产力效果转移到机器人科技
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_FEUDALISM' 										WHERE ImprovementType = "IMPROVEMENT_CAMP"			 AND YieldType = 'YIELD_FOOD' 		AND PrereqCivic = 'CIVIC_MERCANTILISM';--解锁封建主义后，营地加1粮食
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_GUILDS' 											WHERE ImprovementType = "IMPROVEMENT_CAMP"			 AND YieldType = 'YIELD_PRODUCTION' AND PrereqCivic = 'CIVIC_MERCANTILISM';--解锁公会市政后，营地加1生产力
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_MERCANTILISM',	PrereqTech = NULL				WHERE ImprovementType = "IMPROVEMENT_CAMP"			 AND YieldType = 'YIELD_GOLD'		AND PrereqTech = 'TECH_SYNTHETIC_MATERIALS';--解锁重商主义后，营地加2金币
UPDATE Improvements 				 SET DefenseModifier = 3, PrereqTech = 'TECH_CASTLES'						WHERE ImprovementType = "IMPROVEMENT_FORT";--堡垒初始效果改为加3防御力,改为城堡解锁
UPDATE Improvements 				 SET PrereqTech = 'TECH_HORSEBACK_RIDING'									WHERE ImprovementType = "IMPROVEMENT_LUMBER_MILL";--伐木场改为骑马解锁
DELETE FROM  Improvement_Adjacencies WHERE ImprovementType = 'IMPROVEMENT_FARM' AND YieldChangeId = 'Farms_MechanizedAdjacency';--删除零件规格化原有的农场为邻近的每个农场改良设施+1食物相邻加成
UPDATE Adjacency_YieldChanges 		 SET ObsoleteTech = NULL													WHERE ID = 'Farms_MedievalAdjacency' AND ObsoleteTech = 'TECH_REPLACEABLE_PARTS';--删除封建主义三角田失效问题
UPDATE TechnologyModifiers 	SET TechnologyType = 'TECH_REFINING' 	WHERE TechnologyType = "TECH_COMBUSTION";--水运单位加1移动力移动到精炼科技
UPDATE Districts 	SET PrereqTech = 'TECH_SAILING' 				WHERE (DistrictType = "DISTRICT_HARBOR" OR DistrictType IN (SELECT CivUniqueDistrictType FROM DistrictReplaces WHERE ReplacesDistrictType = 'DISTRICT_HARBOR'));--港口区域由航海术解锁,而不是天文导航
UPDATE Buildings 	SET PrereqTech = 'TECH_CELESTIAL_NAVIGATION'	WHERE BuildingType = "BUILDING_COLOSSUS";--巨像奇观由海上贸易科技解锁,而不再是造船术
UPDATE Buildings 	SET PrereqTech = 'TECH_CONSTRUCTION' 			WHERE BuildingType = "BUILDING_HUEY_TEOCALLI";--休伊神庙奇观由建造科技解锁,而不再是密集阵型科技
UPDATE Buildings 	SET PrereqCivic = 'CIVIC_CIVIL_ENGINEERING' 	WHERE BuildingType = "BUILDING_CRISTO_REDENTOR";--救世基督像改为土木工程解锁
UPDATE Units 		SET PrereqTech = 'TECH_CASTLES' 				WHERE (UnitType = "UNIT_KNIGHT" 			OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_KNIGHT')) AND PrereqTech IS NOT NULL;--骑士由城堡科技解锁,而不再是马镫科技
UPDATE Units 		SET PrereqTech = 'TECH_STIRRUPS'				WHERE (UnitType = "UNIT_COURSER" 		OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_COURSER')) AND PrereqTech IS NOT NULL;--追猎者马镫科技解锁,而不再是城堡科技
UPDATE Units 		SET PrereqTech = 'TECH_MILITARY_SCIENCE' 		WHERE (UnitType = "UNIT_CUIRASSIER" 		OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_CUIRASSIER')) AND PrereqTech IS NOT NULL;--胸甲骑兵由现代军事学解锁,而不再是弹道学
UPDATE Units 		SET PrereqTech = 'TECH_PLASTICS' 				WHERE (UnitType = "UNIT_HELICOPTER" 		OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_HELICOPTER')) AND PrereqTech IS NOT NULL;--直升飞机由塑料科技解锁,而不再是合成材料科技
UPDATE Units 		SET PrereqTech = 'TECH_GUIDANCE_SYSTEMS' 		WHERE (UnitType = "UNIT_MISSILE_CRUISER" OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_MISSILE_CRUISER')) AND PrereqTech IS NOT NULL;--导弹巡洋舰有制导系统科技解锁,而不再是激光科技
UPDATE Units 		SET PrereqTech = 'TECH_LASERS' 					WHERE (UnitType = "UNIT_MODERN_AT"		OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_MODERN_AT')) AND PrereqTech IS NOT NULL;--现代反坦克组由激光解锁,而不再是复合材料
UPDATE Units 		SET PrereqTech = 'TECH_SYNTHETIC_MATERIALS' 	WHERE (UnitType = "UNIT_JET_FIGHTER" 	OR UnitType IN (SELECT CivUniqueUnitType FROM UnitReplaces WHERE ReplacesUnitType = 'UNIT_JET_FIGHTER')) AND PrereqTech IS NOT NULL;--喷气式战斗机由合成材料解锁,而不再是激光科技
--UPDATE Units 		SET PrereqCivic = 'CIVIC_HUMANISM' 				WHERE UnitType = "UNIT_ARCHAEOLOGIST";--考古学家前置到人文主义
--UPDATE Resources 	SET PrereqCivic = 'CIVIC_HUMANISM' 				WHERE ResourceType = "RESOURCE_ANTIQUITY_SITE";--历史遗迹前置到人文主义
UPDATE Boosts SET Unit1Type = 'UNIT_SLINGER', 						BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2																		WHERE TechnologyType = "TECH_ARCHERY";--箭术科技的尤里卡改为拥有两个投石兵
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_HAVE_X_LAND_UNITS',				NumItems = 5																		WHERE TechnologyType = "TECH_BRONZE_WORKING";--铸铜术科技的尤里卡改为拥有5个陆地战斗单位
UPDATE Boosts SET Unit1Type = 'UNIT_SPEARMAN', 						BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2																		WHERE TechnologyType = "TECH_MILITARY_TACTICS";--密集阵型科技的尤里卡改为拥有两个枪兵
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC',				NumItems = 0,	BoostingCivicType = 'CIVIC_FEUDALISM',	GovernmentTierType = NULL	WHERE TechnologyType = "TECH_CASTLES";--城堡科技的尤里卡改为拥有封建主义市政
UPDATE Boosts SET Unit1Type = 'UNIT_MAN_AT_ARMS',					BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2																		WHERE TechnologyType = "TECH_METAL_CASTING";--金属铸造科技的尤里卡改为拥有两个披甲战士
UPDATE Boosts SET Unit1Type = 'UNIT_HORSEMAN',				    	BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2,	BoostingCivicType = NULL											WHERE TechnologyType = "TECH_STIRRUPS";--马镫科技的尤里卡改为拥有两个骑手
--UPDATE Boosts SET Unit1Type = 'UNIT_ARCHER',						BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2																		WHERE TechnologyType = "TECH_MACHINERY";--军事学科技的尤里卡改为拥有两个弓箭手  还原
UPDATE Boosts SET 											BoostClass = 'BOOST_TRIGGER_HAVE_X_UNIQUE_SPECIALTY_DISTRICTS',		NumItems = 2																		WHERE TechnologyType = "TECH_MATHEMATICS";--数学科技的尤里卡改为建造两种不同的特色区域
UPDATE Boosts SET ImprovementType = 'IMPROVEMENT_LUMBER_MILL', 		BoostClass = 'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',			NumItems = 3																		WHERE TechnologyType = "TECH_MASS_PRODUCTION";--批量生产科技的尤里卡改为建造三座伐木场
UPDATE Boosts SET Unit1Type = 'UNIT_TRADER', 						BoostClass = 'BOOST_TRIGGER_MAINTAIN_X_TRADE_ROUTES',		NumItems = 6																		WHERE TechnologyType = "TECH_SQUARE_RIGGING";--横帆装置科技的尤里卡改为拥有6条对外贸易路线
UPDATE Boosts SET Unit1Type = 'UNIT_CROSSBOWMAN', 					BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 3																		WHERE TechnologyType = "TECH_BALLISTICS";--弹道学科技的尤里卡改为拥有两名弩手    新：改为拥有3名弩手
UPDATE Boosts SET Unit1Type = 'UNIT_KNIGHT', 						BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 3																		WHERE TechnologyType = "TECH_MILITARY_SCIENCE";--现代军事学的尤里卡改成拥有三个骑士
UPDATE Boosts SET DistrictType = NULL,								BoostClass = 'BOOST_TRIGGER_CITY_POPULATION',				NumItems = 10																		WHERE TechnologyType = "TECH_SANITATION";--现代医学理论科技的尤里卡改为一个城市的人口达到10
UPDATE Boosts SET Unit1Type = NULL, 								BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS',				NumItems = 2,	BuildingType = 'BUILDING_FACTORY'									WHERE TechnologyType = "TECH_REPLACEABLE_PARTS";--零件规格化科技的尤里卡改为建造两座工厂
UPDATE Boosts SET BuildingType = NULL,								BoostClass = 'BOOST_TRIGGER_ARTIFACT_EXTRACTED',			NumItems = 0																		WHERE TechnologyType = "TECH_REFINING";--精炼科技的尤里卡改为出土一件文物
UPDATE Boosts SET ImprovementType = 'IMPROVEMENT_OIL_WELL',			BoostClass = 'BOOST_TRIGGER_IMPROVE_SPECIFIC_RESOURCE',		NumItems = 1,	ResourceType = 'RESOURCE_OIL'										WHERE TechnologyType = "TECH_COMBUSTION";--内燃机科技的尤里卡改为建造一口油井
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',					NumItems = 0,	BoostingTechType = 'TECH_COMBUSTION'								WHERE TechnologyType = "TECH_FLIGHT";--飞行科技的尤里卡改为解锁内燃机科技
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',					NumItems = 0,	BoostingTechType = 'TECH_ELECTRICITY'								WHERE TechnologyType = "TECH_RADIO";--无线电科技的尤里卡改为解锁供电系统科技
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',	NumItems = 0																		WHERE TechnologyType = "TECH_CHEMISTRY";--化学科技的尤里卡改为间谍或伟人提高
UPDATE Boosts SET Unit1Type = NULL, 								BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS',				NumItems = 1,	BuildingType = 'BUILDING_COAL_POWER_PLANT'							WHERE TechnologyType = "TECH_ELECTRICITY";--供电系统科技的尤里卡改为建造一座燃煤发电站
UPDATE Boosts SET Unit1Type = 'UNIT_ARTILLERY', 					BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 2,	BuildingType = NULL													WHERE TechnologyType = "TECH_ADVANCED_BALLISTICS";--高级弹道学科技的尤里卡改为拥有两个大炮
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',					NumItems = 0,	BoostingTechType = 'TECH_REFINING'									WHERE TechnologyType = "TECH_PLASTICS";--塑料科技的尤里卡改为解锁精炼科技
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',	NumItems = 0																		WHERE TechnologyType = "TECH_COMPUTERS";--电脑科技的尤里卡改为通过大科学家或间谍提升
UPDATE Boosts SET Unit1Type = NULL, 								BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',					NumItems = 0,	BoostingTechType = 'TECH_SATELLITES'								WHERE TechnologyType = "TECH_GUIDANCE_SYSTEMS";--制导系统科技的尤里卡改为解锁卫星科技
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC',				NumItems = 0,	BoostingCivicType = 'CIVIC_CLASS_STRUGGLE'							WHERE TechnologyType = "TECH_ROBOTICS";--机器人技术的尤里卡改为解锁阶级斗争政策
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS',				NumItems = 3,	BuildingType = 'BUILDING_RESEARCH_LAB',		TriggerDescription = 'LOC_BOOST_TRIGGER_SMART_MATERIALS',		TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SMART_MATERIALS'		WHERE TechnologyType = "TECH_SMART_MATERIALS";--智能材料科技的尤里卡改为拥有三个研究实验室
UPDATE Boosts SET 													BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS',				NumItems = 1,	BuildingType = 'BUILDING_FLOOD_BARRIER',	TriggerDescription = 'LOC_BOOST_TRIGGER_PREDICTIVE_SYSTEMS',	TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_PREDICTIVE_SYSTEMS'	WHERE TechnologyType = "TECH_PREDICTIVE_SYSTEMS";--预报系统科技的尤里卡改为一座城市拥有拦洪坝
UPDATE Boosts SET Unit1Type = 'UNIT_GIANT_DEATH_ROBOT', 			BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',			NumItems = 1,												TriggerDescription = 'LOC_BOOST_TRIGGER_ADVANCED_AI',			TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_ADVANCED_AI'			WHERE TechnologyType = "TECH_ADVANCED_AI";--高级人工智能科技的尤里卡改为拥有一台末日机甲
UPDATE Boosts SET BoostingTechType = 'TECH_ADVANCED_POWER_CELLS', 	BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',					NumItems = 0,												TriggerDescription = 'LOC_BOOST_TRIGGER_OFFWORLD_MISSION',		TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_OFFWORLD_MISSION'		WHERE TechnologyType = "TECH_OFFWORLD_MISSION";--可控核聚变的尤里卡改为解锁室温超导技术
DELETE FROM  ObsoletePolicies WHERE PolicyType = 'POLICY_BASTIONS';--棱堡政策卡不会失效
DELETE FROM  ObsoletePolicies WHERE PolicyType = 'POLICY_INSPIRATION';--鼓舞政策卡不会失效
DELETE FROM  ObsoletePolicies WHERE PolicyType = 'POLICY_TRAVELING_MERCHANTS';--旅行商人政策卡不会失效
DELETE FROM  ObsoletePolicies WHERE ObsoletePolicy = 'POLICY_COMMUNICATIONS_OFFICE';--联络处政策卡删除
DELETE FROM  Policies WHERE PolicyType = 'POLICY_INSULAE';--楼房政策卡删了
DELETE FROM  Policies WHERE PolicyType = 'POLICY_CIVIL_PRESTIGE';--民间威望政策卡删了
DELETE FROM  Policies WHERE PolicyType = 'POLICY_COLONIAL_OFFICES';--殖民地办事处政策卡删了
DELETE FROM  Policies WHERE PolicyType = 'POLICY_COMMUNICATIONS_OFFICE';--联络处政策卡删除
INSERT OR REPLACE INTO CivicModifiers (CivicType,ModifierId) 
SELECT 			'CIVIC_MEDIEVAL_FAIRES',	PolicyModifiers.ModifierId		FROM PolicyModifiers WHERE PolicyType = 'POLICY_MEDINA_QUARTER';
UPDATE Policies 	SET PrereqCivic = 'CIVIC_CIVIL_SERVICE'		WHERE PolicyType = "POLICY_TRADE_CONFEDERATION";--贸易联盟政策卡改为行政部门市政解锁
UPDATE Policies 	SET PrereqCivic = 'CIVIC_EXPLORATION'		WHERE PolicyType = "POLICY_COLONIAL_TAXES";--殖民地税收政策卡前置到探索市政
UPDATE Policies 	SET PrereqCivic = 'CIVIC_IDEOLOGY'			WHERE PolicyType = "POLICY_MARKET_ECONOMY";--市场经济政策卡改为意识形态政策解锁
UPDATE Policies 	SET PrereqCivic = 'CIVIC_CIVIL_SERVICE'		WHERE PolicyType = "POLICY_MERCHANT_CONFEDERATION";--商人联盟贸易卡改为行政部门解锁
UPDATE Policies 	SET PrereqCivic = 'CIVIC_DRAMA_POETRY'		WHERE PolicyType = "POLICY_INSPIRATION";--鼓舞贸易卡改为戏剧和诗歌解锁
UPDATE Policies 	SET PrereqCivic = 'CIVIC_RAPID_DEPLOYMENT'	WHERE PolicyType = "POLICY_STRATEGIC_AIR_FORCE";--战略空军政策卡前置到紧急部署政策
UPDATE Policies 	SET PrereqCivic = 'CIVIC_MOBILIZATION'		WHERE PolicyType = "POLICY_INTERNATIONAL_WATERS";--公海政策卡前置到动员政策	
UPDATE Policies		SET PrereqCivic = 'CIVIC_COLONIALISM'		WHERE PolicyType = "POLICY_EXPROPRIATION";--征收前置到殖民主义
UPDATE RequirementArguments 	SET Value = 10		WHERE RequirementId = "REQUIRES_CITY_HAS_HIGH_POPULATION" AND Name = "Amount";--共享教堂、理性主义、大歌剧、自由市场政策卡对人口需求改为10
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_WISSELBANKEN' 		AND ModifierId LIKE "WISSELBANKEN_TRADEROUTEFOOD%";--贸易银行政策卡的效果改成通往盟友城市的对外贸易路线为双方提供2金币2生产力
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_MILITARY_RESEARCH'	AND ModifierId LIKE "MILITARYRESEARCH_%";--军事研究政策卡的效果改为与军营相邻的学院区域每回合提供的科技提高10%
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_PUBLIC_TRANSPORT'	AND ModifierId LIKE "PUBLICTRANSPORT_%";--军事研究政策卡的效果改为与军营相邻的学院区域每回合提供的科技提高10%
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_MARKET_ECONOMY'	AND ModifierId LIKE "MARKETECONOMY_TRADEROUTEGOLD%";--市场经济政策卡的效果改为对外贸易路线加4金币，加2科技，加2文化
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_COLLECTIVIZATION'	AND ModifierId LIKE "COLLECTIVIZATION_INTERNAL_TRADE_%";--集体化政策卡的效果改为农田加1金币加1粮食
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_DEFENSE_OF_MOTHERLAND'	AND ModifierId LIKE "DEFENSEOFMOTHERLAND_%";--保卫祖国政策卡的效果改为被宣战时，所有单位加5力，加1移动力（限制10回合），生产军事单位时加50%的生产力，工厂和军营的维护费为0
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_THIRD_ALTERNATIVE'	AND ModifierId LIKE "THIRDALTERNATIVE_%";--第三选择政策卡得效果改为证券交易所每回合提供2点石油，航空港每回合提供2点铝矿，燃煤发电站每回合提供2点煤炭，核电站每回合提供两点铀矿
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_LOGISTICS'	AND ModifierId LIKE "LOGISTICS_FRIENDLYTERRITORYMOVEMENTBONUS";--后勤改为市中心三格范围内友方单位加1移动力
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_TRIANGULAR_TRADE'	AND ModifierId LIKE "TRIANGULARTRADE_TRADEROUTE%";--三角贸易效果改成非你创立的城市城市出发的贸易路线加10金币，若你还创立了宗教则额外4信仰。
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_MILITARY_ORGANIZATION'	AND ModifierId LIKE "MILITARYORGANIZATION_GREATGENERAL_ARMORY";--军事组织政策卡改为+4大将军点，每有一个军事学院+2
DELETE FROM  PolicyModifiers WHERE PolicyType = 'POLICY_LAISSEZ_FAIRE'	AND ModifierId LIKE "LAISSEZFAIRE_MERCHANT_BANK";--不干涉主义改为每有一个证券交易所+4大商点，每有一个造船厂+2海军点，每有一个码头+4海军点
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_EMPIRE_POPULATION',						NumItems = 5																		WHERE CivicType = "CIVIC_EARLY_EMPIRE";--帝国初期的鼓舞改成文明人口达到5
UPDATE Boosts SET	ResourceType = NULL,							BoostClass = 'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',					NumItems = 0,	ImprovementType = 'IMPROVEMENT_CAMP',	BoostingTechType = NULL		WHERE CivicType = "CIVIC_GAMES_RECREATION";--游戏和娱乐的鼓舞改成改良一个营地
UPDATE Boosts SET	DistrictType = 'DISTRICT_COMMERCIAL_HUB',		BoostClass = 'BOOST_TRIGGER_HAVE_X_DISTRICTS',						NumItems = 1																		WHERE CivicType = "CIVIC_DEFENSIVE_TACTICS";--防御战术的鼓舞改为拥有一个商业区
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_HAVE_X_UNIQUE_SPECIALTY_DISTRICTS',		NumItems = 4																		WHERE CivicType = "CIVIC_CIVIL_SERVICE";--行政部门的鼓舞改成拥有三个特色区域
UPDATE Boosts SET	ImprovementType = 'IMPROVEMENT_FARM',			BoostClass = 'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',					NumItems = 5																		WHERE CivicType = "CIVIC_FEUDALISM";--封建主义的鼓舞改为拥有5个农场改良设施
UPDATE Boosts SET	Unit1Type = 'UNIT_GREAT_ADMIRAL',				BoostClass = 'BOOST_TRIGGER_TRAIN_UNIT',							NumItems = 0																		WHERE CivicType = "CIVIC_NAVAL_TRADITION";--海军传统的鼓舞改成拥有一位海军提督
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_HAVE_X_LAND_UNITS',						NumItems = 7																		WHERE CivicType = "CIVIC_MERCENARIES";--雇佣兵的鼓舞改成拥有7个单位
UPDATE Boosts SET	Unit1Type = 'UNIT_GALLEY',						BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',					NumItems = 3																		WHERE CivicType = "CIVIC_EXPLORATION";--探索市政的鼓舞改为拥有三个海军近战单位
UPDATE Boosts SET	BuildingType = NULL,							BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',							NumItems = 0,	BoostingTechType = 'TECH_CASTLES'									WHERE CivicType = "CIVIC_DIVINE_RIGHT";--君主专制政策的鼓舞改成拥有城堡科技
UPDATE Boosts SET	DistrictType = 'DISTRICT_THEATER',				BoostClass = 'BOOST_TRIGGER_HAVE_X_DISTRICTS',						NumItems = 2,	Unit1Type = NULL													WHERE CivicType = "CIVIC_HUMANISM";--人文主义的鼓舞改成拥有两个剧院
UPDATE Boosts SET	BuildingType = 'BUILDING_POWER_PLANT',			BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS',						NumItems = 1																		WHERE CivicType = "CIVIC_NUCLEAR_PROGRAM";--核计划的鼓舞改成拥有一个核电站
UPDATE Boosts SET	BoostingTechType = 'TECH_FLIGHT',				BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',							NumItems = 0																		WHERE CivicType = "CIVIC_CULTURAL_HERITAGE";--文化遗产的鼓舞改为拥有飞行科技
UPDATE Boosts SET	DistrictType = 'DISTRICT_AERODROME',			BoostClass = 'BOOST_TRIGGER_HAVE_X_DISTRICTS',						NumItems = 2																		WHERE CivicType = "CIVIC_RAPID_DEPLOYMENT";--紧急部署的鼓舞改为拥有两个航空港
UPDATE Boosts SET	Unit1Type = 'UNIT_TRADER', 						BoostClass = 'BOOST_TRIGGER_MAINTAIN_X_TRADE_ROUTES',				NumItems = 8,	BuildingType = NULL													WHERE CivicType = "CIVIC_GLOBALIZATION";--全球化的鼓舞改为拥有8条对外贸易路线
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH',							NumItems = 0,	BoostingTechType = 'TECH_COMPUTERS'									WHERE CivicType = "CIVIC_SOCIAL_MEDIA";--社交媒体的鼓舞改为研究电脑科技
UPDATE Boosts SET	Unit1Type = 'UNIT_MODERN_ARMOR',				BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',					NumItems = 3																		WHERE CivicType = "CIVIC_CORPORATE_LIBERTARIANISM";--第五天灾政体的鼓舞改为拥有三个现代坦克
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_HAVE_X_UNIQUE_SPECIALTY_DISTRICTS',		NumItems = 6																		WHERE CivicType = "CIVIC_CIVIL_ENGINEERING";--土木工程的鼓舞改成拥有六个特色区域
UPDATE Boosts SET													BoostClass = 'BOOST_TRIGGER_CITY_POPULATION',						NumItems = 10																		WHERE CivicType = "CIVIC_URBANIZATION";--城市化的鼓舞改成一个城市的人口达到10
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_AUTOCRACY'			AND  ModifierId NOT LIKE "AUTOCRACY_WONDERS";--删除独裁统治原有效果，保留奇观加速
DELETE FROM  PolicyModifiers			WHERE PolicyType = 'POLICY_GOV_AUTOCRACY'				AND  ModifierId NOT LIKE "AUTOCRACY_WONDERS";--删除独裁统治传承卡原有效果，保留奇观加速
UPDATE ModifierArguments SET Value = 15	WHERE ModifierId = "AUTOCRACY_WONDERS" 					AND Name = "Amount";	--独裁统治固定效果奇观加速提升至15%
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_MONARCHY';--删除君主制原有效果
DELETE FROM  PolicyModifiers 			WHERE PolicyType = 'POLICY_GOV_MONARCHY';--删除君主制传承卡原有效果
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_MERCHANT_REPUBLIC'	AND ModifierId IS "MERCHANT_REPUBLIC_DISTRICTS";--删除商人共和国原有区域加速效果
UPDATE ModifierArguments SET Value = 15	WHERE ModifierId = "MERCHANT_REPUBLIC_GOLD_MODIFIER" 	AND Name = "Amount";	--商人共和国固定效果金币加成提升至15%
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_COMMUNISM'			AND ModifierId IS "COMMUNISM_PRODUCTIVE_PEOPLE";--删除民主主义原有效果
DELETE FROM  PolicyModifiers 			WHERE PolicyType = 'POLICY_GOV_COMMUNISM'				AND ModifierId IS "COMMUNISM_PRODUCTIVE_PEOPLE";--删除民主主义传承卡原有效果
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_DEMOCRACY'			AND  ModifierId NOT LIKE "DEMOCRACY_GOLD_PURCHASE";--删除自由主义原有效果，保留金币折扣
DELETE FROM  PolicyModifiers			WHERE PolicyType = 'POLICY_GOV_DEMOCRACY'				AND  ModifierId NOT LIKE "DEMOCRACY_GOLD_PURCHASE";--删除自由主义传承卡原有效果，保留金币折扣
DELETE FROM  GovernmentModifiers		WHERE GovernmentType = 'GOVERNMENT_CORPORATE_LIBERTARIANISM'			AND  ModifierId NOT LIKE "CORPORATE_LIBERTARIANISM_SCIENCE_PENALTY";--删除第五天灾政体原有效果，保留科技减益
UPDATE ModifierArguments SET Value = 20	WHERE ModifierId = "SYNTHETIC_TECHNOCRACY_CITY_PROJECT_PRODUCTION" 	AND Name = "Amount";	--共产主义固定效果项目加成降低至20%
UPDATE Buildings 	SET PrereqCivic = 'CIVIC_CIVIL_ENGINEERING' 		WHERE BuildingType = "BUILDING_FERRIS_WHEEL";--摩天轮改为土木工程解锁
UPDATE Buildings 	SET PrereqCivic = 'CIVIC_CONSERVATION' 				WHERE BuildingType = "BUILDING_AQUARIUM";--水族馆改为保护地球解锁
UPDATE Districts 	SET PrereqCivic = 'CIVIC_CIVIL_ENGINEERING' 		WHERE DistrictType = "DISTRICT_WATER_ENTERTAINMENT_COMPLEX";--水上乐园改为土木工程解锁
DELETE FROM  Building_YieldDistrictCopies				WHERE BuildingType = 'BUILDING_COAL_POWER_PLANT' AND NewYieldType = 'YIELD_PRODUCTION';--删除燃煤发电厂原有的加成
DELETE FROM  TypeTags				WHERE Type = 'ABILITY_STABLE_TRAINED_UNIT_XP' AND Tag = 'CLASS_SIEGE';--删除马厩对攻城单位的经验加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_ARMORY' AND ModifierId = 'ARMORY_TRAINED_UNIT_XP_MODIFIER';--删除兵工厂的经验加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_MILITARY_ACADEMY' AND ModifierId = 'MILITARY_ACADEMY_ADJUST_RESOURCE_STOCKPILE_CAP';--删除军事学院的战略储存
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_LIGHTHOUSE' AND (ModifierId = 'LIGHTHOUSE_TRAINED_UNIT_XP_MODIFIER' OR ModifierId = 'LIGHTHOUSE_COASTAL_CITY_HOUSING' OR ModifierId = 'LIGHTHOUSE_COAST_FOOD' OR ModifierId = 'LIGHTHOUSE_TRADE_ROUTE_CAPACITY');--删除灯塔的经验加成和住房加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_SHIPYARD' AND (ModifierId = 'SHIPYARD_TRAINED_UNIT_XP_MODIFIER' OR ModifierId = 'SHIPYARD_UNIMPROVED_COAST_PRODUCTION');--删除造船厂的经验加成和生产力加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_SEAPORT' AND (ModifierId = 'SEAPORT_TRAINED_UNIT_XP_MODIFIER' OR ModifierId = 'SEAPORT_TRAINED_CORPS_ARMY_DISCOUNT' OR ModifierId = 'SEAPORT_COAST_GOLD');--删除码头的经验加成和金币加成和军团折扣
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_ZOO' AND (ModifierId = 'ZOO_RAINFOREST_SCIENCE' OR ModifierId = 'ZOO_MARSH_SCIENCE');--删除动物园原效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_STADIUM' AND (ModifierId = 'STADIUM_10_POPULATION_TOURISM' OR ModifierId = 'STADIUM_20_POPULATION_TOURISM');--删除体育场原效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_HANGAR' AND ModifierId = 'HANGAR_TRAINED_AIRCRAFT_XP_MODIFIER';--删除机库经验加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_AIRPORT' AND ModifierId = 'AIRPORT_TRAINED_AIRCRAFT_XP_MODIFIER';--删除机场经验加成
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_AQUARIUM' AND (ModifierId = 'AQUARIUM_REEF_SCIENCE' OR ModifierId = 'AQUARIUM_SEARESOURCE_SCIENCE');--删除水族馆原有效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_GOV_TALL' AND ModifierId = 'GOV_TALL_LOYALTY_DEBUFF';--删除谒见厅忠诚debuff和总督需求
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_GOV_CONQUEST' AND ModifierId = 'GOV_PRODUCTION_BOOST_FROM_CAPTURE';--删除军阀宝座原有效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_GOV_MILITARY' AND ModifierId = 'GOV_HEAL_AFTER_DEFEATING_UNIT';--删除作战部原有效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_GOV_SCIENCE' AND ModifierId = 'GOV_PROJECT_ABILITY';--删除皇家学会原有效果
DELETE FROM  BuildingModifiers		WHERE BuildingType = 'BUILDING_ELECTRONICS_FACTORY' AND ModifierId = 'ELECTRONICSFACTORY_CULTURE';--删除电子厂原有效果
UPDATE HeroClasses 	SET ArtifactGreatWorkType = NULL,EpicGreatWorkType = NULL;--删除英雄遗物