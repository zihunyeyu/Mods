-- MerchantVictory_Text
-- Author: Konomi
-- DateCreated: 11/17/2023 16:03:24
--------------------------------------------------------------
INSERT INTO LocalizedText 
		(Language,		Tag,															Text)
VALUES	('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_NAME',								'美联储'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_DESCRIPTION',						'商业中心4级建筑，每个文明限造一座，只能使用 [ICON_Gold] 金币购买。该城市没有市政广场、宫殿或外交区时：若你不处于第4级政体，该城市解锁商业胜利系列项目；所有城市-2 [ICON_Amenities] 宜居度；你的文明每控制一个城邦，每回合产出的 [ICON_Gold] 金币增加5%。如果已经有一座中央银行则无法修建。'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_2_NAME',								'中央银行'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_2_DESCRIPTION',						'商业中心4级建筑，每个文明限造一座。所有城市+10% [ICON_Gold] 金币、+1 [ICON_Amenities] 宜居度。世界上每有一座中央银行，商业胜利第五阶段等待胜利的回合便+2。如果已经有一座美联储则无法修建。'),
		--('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_NAME',								'无形之手的锁喉'),
		--('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_DESCRIPTION',							'完成后30回合内每回合-1000 [ICON_Gold] 金币（标准速度下）。完成5次该项目后获得商业胜利。'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_1_NAME',								'覆手为雨'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_1_DESCRIPTION',						'商业胜利第一阶段项目，完成后30回合内每回合-1000 [ICON_Gold] 金币（标准速度下），解锁下阶段项目“此即自由”。产品效果翻倍，其它文明对你的好感度减1。其它文明若每回合获得的金币不足500，则其每回合获得的金币减25%。'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_2_NAME',								'此即自由'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_2_DESCRIPTION',						'商业胜利第二阶段项目，完成后30回合内每回合-2000 [ICON_Gold] 金币（标准速度下），解锁下阶段项目“愚者自愚”。你的对外贸易路线+10 [ICON_Gold] 金币，所有城市+1 [ICON_Amenities] 宜居度，每回合+10 [ICON_GREATMERCHANT] 大商人点数。所有单位-10 [ICON_STRENGTH] 战斗力，其它文明对你的好感度减1。若其它文明贸易路线不足10条，则其30回合内对外贸易路线-10 [ICON_Gold] 金币。'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_3_NAME',								'愚者自愚'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_3_DESCRIPTION',						'商业胜利第三阶段项目，完成后30回合内每回合-3000 [ICON_Gold] 金币（标准速度下），解锁下阶段项目“世界被我们踩在脚下”。随机一个文明将对你宣战。所有城市-2 [ICON_Amenities] 宜居度。若你的军事力量小于2000，你失败。'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_4_NAME',								'世界被我们踩在脚下'),
		('zh_Hans_CN',	'LOC_PROJECT_MYN_MERCHANT_4_DESCRIPTION',						'商业胜利第四阶段项目，完成后30回合内每回合-4000 [ICON_Gold] 金币（标准速度下）。所有文明将对你宣战，所有城市-8忠诚度。等待若干回合后即可获得商业胜利。'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_1_TOOLTIP',								'完成第一阶段项目“{LOC_PROJECT_MYN_MERCHANT_1_NAME}”。[NEWLINE]{LOC_PROJECT_MYN_MERCHANT_1_NAME}：{LOC_PROJECT_MYN_MERCHANT_1_DESCRIPTION}'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_2_TOOLTIP',								'完成第二阶段项目“{LOC_PROJECT_MYN_MERCHANT_2_NAME}”。[NEWLINE]{LOC_PROJECT_MYN_MERCHANT_2_NAME}：{LOC_PROJECT_MYN_MERCHANT_2_DESCRIPTION}'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_3_TOOLTIP',								'完成第三阶段项目“{LOC_PROJECT_MYN_MERCHANT_3_NAME}”。[NEWLINE]{LOC_PROJECT_MYN_MERCHANT_3_NAME}：{LOC_PROJECT_MYN_MERCHANT_3_DESCRIPTION}'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_4_TOOLTIP',								'完成第四阶段项目“{LOC_PROJECT_MYN_MERCHANT_4_NAME}”。[NEWLINE]{LOC_PROJECT_MYN_MERCHANT_4_NAME}：{LOC_PROJECT_MYN_MERCHANT_4_DESCRIPTION}'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_5_TOOLTIP',								'共需等待{1_Num} [ICON_Turn] 回合获得商业胜利，已等待{2_Num}回合。'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_DUMMY_DISLIKE_NAME',					'-1好感度'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_DUMMY_TRADEROUTE_NAME',				'此即自由惩罚'),
		('zh_Hans_CN',	'LOC_BUILDING_MYN_MERCHANT_DUMMY_UNLOCK_PROJECT_NAME',			'解锁商业胜利项目'),
		
		('zh_Hans_CN',	'LOC_DIPLO_WARNING_MYN_MERCHANT_UNWELCOME_REASON_ANY',			'………（冷漠）'),
		('zh_Hans_CN',	'LOC_DIPLO_MODIFIER_DESCRIPTION_MYN_MERCHANT_UNWELCOME',		'精英的傲慢'),
		('zh_Hans_CN',	'LOC_MODIFIER_PROJECT_MYN_MERCHANT_2_COMBAT_STRENGTH',			'此即自由项目-10'),
		
		('zh_Hans_CN',	'LOC_TOOLTIP_MYN_MERCHANT_CONGRESS_BUTTON',						'商业'),
		('zh_Hans_CN',	'LOC_VICTORY_MYN_MERCHANT_NAME',								'商业胜利'),
		('zh_Hans_CN',	'LOC_MYN_MERCHANT_VIC_DESCRIPTION',								'用您的财富，让整个世界臣服。用黄金铸造永恒的金融霸权吧。'),
		('zh_Hans_CN',	'LOC_VICTORY_MYN_MERCHANT_TEXT',								'正如我们所认同的，世界需要我们去推动。芸芸众生，盲目且短视。我们将用我们的权力带领他们去往一个更美好的世界。'),
		('zh_Hans_CN',	'LOC_VICTORY_MYN_MERCHANT_DESCRIPTION',							'为获得[COLOR:ResGoldLabelCS]商业[ENDCOLOR]胜利，您必须建造商业中心4级建筑美联储。若城市拥有美联储而不拥有市政广场、宫殿或外交区，且您不处于四级政体时，该城市将解锁4个商业胜利系列项目。完成四个项目并等待5 [ICON_Turn] 回合即可获得商业胜利。[NEWLINE][NEWLINE]为了反制即将商业胜利的对手，可建造同为商业中心4级建筑的中央银行。世界上每有一座中央银行，商业胜利第五阶段等待胜利的回合便+2。美联储和中央银行无法同时拥有。此外，在第五阶段，若美联储处于被掠夺状态，则等待胜利的倒计时无法减少。[NEWLINE][NEWLINE]开启该胜利后，任何文明若 [ICON_Gold] 国库为0、每回合 [ICON_Gold] 金币为负，则未拥有市政广场、宫殿或外交区的城市叛变为自由城市。'),
		('zh_Hans_CN',	'LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT',						'正处于第{1_Num}阶段'),
		('zh_Hans_CN',	'LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT_FINISHED',				'已完成');
		