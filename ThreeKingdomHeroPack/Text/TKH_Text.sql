-- TKH_Text
-- Author: PurpleSoul
-- DateCreated: 5/24/2025 11:56:22 PM
--------------------------------------------------------------

INSERT OR REPLACE INTO LocalizedText(Tag, Language, Text)
SELECT Tag, Language, Text||'占领单位 [ICON_Strength] 防御力+6，并自动获得2回合防御工事。'
WHERE Tag='LOC_IMPROVEMENT_GREAT_WALL_EXPANSION2_DESCRIPTION' AND Language='zh_Hans_CN';

-- UPDATE LOC_PROMOTION_ROUT_DESCRIPTION
