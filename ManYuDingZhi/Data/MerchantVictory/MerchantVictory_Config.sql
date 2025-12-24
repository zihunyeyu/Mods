-- MerchantVictory
-- Author: Konomi
-- DateCreated: 11/16/2023 16:00:33
--------------------------------------------------------------
INSERT INTO Parameters 
	    (ParameterId,							Name,									Description,									Domain,			DefaultValue,		ConfigurationGroup,		ConfigurationId,					GroupId,			SortIndex) 
VALUES  ('PARAMETER_MYN_MERCHANT_VIC',			'LOC_VICTORY_MYN_MERCHANT_NAME',		'LOC_MYN_MERCHANT_VIC_DESCRIPTION',				'bool',			1,					'Game',					'CONFIG_MYN_MERCHANT_VIC',			'Victories',		601);

INSERT INTO ParameterDependencies 
		(ConfigurationGroup,							ConfigurationId,					ConfigurationValue,					Operator,			ParameterId) 
VALUES  ('Game',										'RULESET',							'RULESET_EXPANSION_2',				'Equals',			'PARAMETER_MYN_MERCHANT_VIC');

--INSERT INTO Victories 
		--(Domain,							VictoryType,					Name,									Description,									Icon,		Visible,		ReadOnly,		EnabledByDefault) 
--VALUES  ('Expansion2_Victories',			'VICTORY_MYN_MERCHANT',			'LOC_VICTORY_MYN_MERCHANT_NAME',		'LOC_VICTORY_MYN_MERCHANT_DESCRIPTION',			NULL,		1,				0,				1);
--