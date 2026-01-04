INSERT OR REPLACE INTO CivilopediaSections(SectionId,	Name,	Icon,	SortIndex)
VALUES
('EQUIPMENTS',	'LOC_TKH_EQUIPMENT',	'ICON_CIVILOPEDIA_HISTORIC_MOMENTS',	'190');

INSERT OR REPLACE INTO CivilopediaPages(SectionId,	PageId,	PageLayoutId,	Name,	TextKeyPrefix,	Tooltip,	SortIndex)
VALUES
('EQUIPMENTS',	'INTRO',	'Simple',	'LOC_PEDIA_PAGE_INTRO_TITLE',	'LOC_PEDIA_CONCEPTS_PAGE_PRIDE_MOMENTS_1',	'',	'10');

INSERT OR REPLACE INTO CivilopediaPageQueries(SectionId,	PageGroupIdColumn,	TooltipColumn,	SortIndex,	SQL)
VALUES
('EQUIPMENTS',	'PageGroupId',	'Tooltip',	'10',	'SELECT Equipment AS PageId, EquipmentType AS PageGroupId, "Equipment" AS PageLayoutId, Name, null AS Tooltip FROM TKH_Equipments');

INSERT OR REPLACE INTO CivilopediaPageGroupQueries(SectionId,	TooltipColumn,	VisibleIfEmptyColumn,	SortIndexColumn,	SortIndex,	SQL)
VALUES
('EQUIPMENTS',	'Tooltip',	'VisibleIfEmpty',	'SortIndex',	'10',	'SELECT EquipmentType as PageGroupId, Name, null as Tooltip, 1 as VisibleIfEmpty, 0 as SortIndex from TKH_EquipmentTypes');

INSERT OR REPLACE INTO CivilopediaPageLayouts(PageLayoutId,	ScriptTemplate)
VALUES
('Equipment',	'Equipment');

