--======================沿海经济开发区==============================
-- 效果：+1贸易路线

INSERT INTO DistrictModifiers (DistrictType, ModifierId)
VALUES
('DISTRICT_COASTAL_OPEN_ZONE', 'DISTRICT_COASTAL_OPEN_ZONE_TRADE_ROUTE_CAPACITY');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('DISTRICT_COASTAL_OPEN_ZONE_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 'REQS_PLOT_IS_COASTAL_LAND');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
('DISTRICT_COASTAL_OPEN_ZONE_TRADE_ROUTE_CAPACITY', 'Amount', '1');
-- 条件：需要单元格在沿海陆地
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQS_PLOT_IS_COASTAL_LAND', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQS_PLOT_IS_COASTAL_LAND', 'REQ_PLOT_IS_COASTAL_LAND');
INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('REQ_PLOT_IS_COASTAL_LAND', 'REQUIREMENT_PLOT_IS_COASTAL_LAND');
