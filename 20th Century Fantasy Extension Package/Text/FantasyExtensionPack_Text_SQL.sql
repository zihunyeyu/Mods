-- FantasyExtensionPack_Text_SQL
-- Author: PurpleSoul
-- DateCreated: 11/16/2024 9:03:45 PM
--------------------------------------------------------------
INSERT INTO LocalizedText(Tag, Language, Text)
SELECT REPLACE(Tag, 'LOC_', 'LOC_BUILDING_SWITCH_'), Language, '区域转换：'||Text
FROM LocalizedText WHERE Tag LIKE 'LOC_DISTRICT_%_NAME' AND Language='zh_Hans_CN';

INSERT INTO LocalizedText(Tag, Language, Text)
SELECT REPLACE(REPLACE(Tag, 'LOC_', 'LOC_BUILDING_SWITCH_'), 'NAME', 'DESCRIPTION'), Language, '将现有区域转换为：'||Text
FROM LocalizedText WHERE Tag LIKE 'LOC_DISTRICT_%_NAME' AND Language='zh_Hans_CN';