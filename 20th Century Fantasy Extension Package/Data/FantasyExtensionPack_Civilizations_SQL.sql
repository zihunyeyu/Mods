INSERT OR IGNORE INTO CityNames(CivilizationType, CityName)
SELECT 'CIVILIZATION_REPUBLIC_OF_CHINA', CityName
FROM CityNames WHERE CivilizationType = 'CIVILIZATION_CHINA'
UNION SELECT 'CIVILIZATION_SOVIET_REPUBLIC_OF_CHINA', CityName
FROM CityNames WHERE CivilizationType = 'CIVILIZATION_CHINA';

INSERT OR IGNORE INTO CivilizationInfo(CivilizationType, Header, Caption)
SELECT 'CIVILIZATION_REPUBLIC_OF_CHINA', Header, Caption
FROM CivilizationInfo WHERE CivilizationType = 'CIVILIZATION_CHINA'
UNION SELECT 'CIVILIZATION_SOVIET_REPUBLIC_OF_CHINA', Header, Caption
FROM CivilizationInfo WHERE CivilizationType = 'CIVILIZATION_CHINA';

INSERT OR IGNORE INTO CivilizationCitizenNames(CivilizationType, CitizenName, Female)
SELECT 'CIVILIZATION_REPUBLIC_OF_CHINA', CitizenName, Female
FROM CivilizationCitizenNames WHERE CivilizationType = 'CIVILIZATION_CHINA'
UNION SELECT 'CIVILIZATION_SOVIET_REPUBLIC_OF_CHINA', CitizenName, Female
FROM CivilizationCitizenNames WHERE CivilizationType = 'CIVILIZATION_CHINA';

INSERT INTO NamedRiverCivilizations(CivilizationType, NamedRiverType)
SELECT 'CIVILIZATION_REPUBLIC_OF_CHINA', NamedRiverType
FROM NamedRiverCivilizations WHERE CivilizationType='CIVILIZATION_CHINA'
UNION SELECT 'CIVILIZATION_SOVIET_REPUBLIC_OF_CHINA', NamedRiverType
FROM NamedRiverCivilizations WHERE CivilizationType='CIVILIZATION_CHINA';

