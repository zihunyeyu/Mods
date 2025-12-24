-- TKH_LuxuryTax
-- Author: PurpleSoul
-- DateCreated: 6/8/2025 12:20:22 PM
--------------------------------------------------------------

INSERT INTO DistrictModifiers (DistrictType, ModifierId)
VALUES
('DISTRICT_CITY_CENTER', 'MODIFIER_TKH_DECREASE_YIELD_LUXURY_TAX_CITY');

INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('MODIFIER_TKH_DECREASE_YIELD_LUXURY_TAX_CITY', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 'REQS_PLOT_PROPERTY_BROKEN');

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
('MODIFIER_TKH_DECREASE_YIELD_LUXURY_TAX_CITY', 'Amount', '-50,-50'),
('MODIFIER_TKH_DECREASE_YIELD_LUXURY_TAX_CITY', 'YieldType', 'YIELD_FOOD,YIELD_PRODUCTION');


INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQS_PLOT_PROPERTY_BROKEN', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQS_PLOT_PROPERTY_BROKEN', 'REQ_PLOT_PROPERTY_BROKEN');

INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('REQ_PLOT_PROPERTY_BROKEN', 'REQUIREMENT_PLOT_PROPERTY_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('REQ_PLOT_PROPERTY_BROKEN', 'PropertyName', 'PROPERTY_LUXURY_TAX_CITY_BROKEN'),
('REQ_PLOT_PROPERTY_BROKEN', 'PropertyMinimum', '1');
