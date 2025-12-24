-- FantasyExtensionPack_Icons_SQL
-- Author: PurpleSoul
-- DateCreated: 11/30/2024 12:33:01 PM
--------------------------------------------------------------

INSERT INTO IconDefinitions(Name, Atlas, `Index`)
SELECT REPLACE(Name, 'ICON_', 'ICON_BUILDING_SWITCH_'), Atlas, `Index`
FROM IconDefinitions WHERE Name LIKE 'ICON_DISTRICT_%';