-- TKH_UnitTags
-- Author: PurpleSoul
-- DateCreated: 5/18/2025 9:01:27 AM
--------------------------------------------------------------

INSERT OR REPLACE INTO TypeTags(Type, Tag)
VALUES
('ABILITY_FASCISM_ATTACK_BUFF', 'CLASS_WARRIOR_MONK');

INSERT OR REPLACE INTO Tags (Tag, Vocabulary)
VALUES
('CLASS_TKH_CAVALRY', 'ABILITY_CLASS'),
('CLASS_TKH_UNIT', 'ABILITY_CLASS'),
('CLASS_TKH_HERO', 'ABILITY_CLASS'),
('CLASS_TKH_SP_UNIT', 'ABILITY_CLASS'),
('CLASS_RANGED_EXCEPT_UNIT_HERO_TKH_DIAO_CHAN', 'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT Type , 'CLASS_TKH_CAVALRY'
FROM TypeTags tt 
WHERE tt.Tag LIKE 'CLASS_%_CAVALRY' AND tt.Tag NOT LIKE '%ANTI_CAVALRY' AND tt.Type IN (SELECT UnitType FROM Units);

-- INSERT OR REPLACE INTO TypeTags (Type, Tag)
-- SELECT DISTINCT tt.Type, 'CLASS_CAVALRY'
-- FROM TypeTags tt
-- JOIN Units u ON tt.Type = u.UnitType AND (tt.Tag = 'CLASS_LIGHT_CAVALRY' OR tt.Tag = 'CLASS_HEAVY_CAVALRY' OR tt.Tag = 'CLASS_RANGED_CAVALRY');

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT DISTINCT tt.Type, 'CLASS_TKH_UNIT'
FROM TypeTags tt
JOIN Units u ON tt.Type = u.UnitType
LEFT JOIN HeroClasses hc ON tt.Type = hc.UnitType
WHERE hc.UnitType IS NULL;

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT DISTINCT tt.Type, 'CLASS_TKH_HERO'
FROM TypeTags tt
JOIN Units u ON tt.Type = u.UnitType
LEFT JOIN HeroClasses hc ON tt.Type = hc.UnitType
WHERE hc.UnitType IS NOT NULL;


INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT DISTINCT tt.Type, 'CLASS_TKH_SP_UNIT'
FROM TypeTags tt
JOIN Units u ON tt.Type = u.UnitType
WHERE u.UnitType LIKE 'UNIT_HERO_TKH_%_GUARD';



INSERT OR REPLACE INTO Tags (Tag, Vocabulary)
SELECT Tag||'_TKH_UNIT', 'ABILITY_CLASS'
FROM TypeTags WHERE Type = 'ABILITY_FASCISM_ATTACK_BUFF'
UNION SELECT Tag||'_TKH_HERO', 'ABILITY_CLASS'
FROM TypeTags WHERE Type = 'ABILITY_FASCISM_ATTACK_BUFF';

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT tt.Type, tt.Tag||'_TKH_UNIT'
FROM TypeTags tt
WHERE tt.Type IN (SELECT UnitType FROM Units)
  AND tt.Type NOT LIKE '%UNIT_HERO_TKH%'
  AND tt.Type NOT IN (SELECT UnitType FROM HeroClasses)
  AND tt.Tag IN (
      SELECT Tag 
      FROM TypeTags 
      WHERE Type = 'ABILITY_FASCISM_ATTACK_BUFF'
  );

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT tt.Type, tt.Tag||'_TKH_HERO'
FROM TypeTags tt
WHERE tt.Type IN (SELECT UnitType FROM Units)
  AND tt.Type IN (SELECT UnitType FROM HeroClasses)
  AND tt.Tag IN (
      SELECT Tag 
      FROM TypeTags 
      WHERE Type = 'ABILITY_FASCISM_ATTACK_BUFF'
  );

INSERT OR REPLACE INTO TypeTags (Type, Tag)
SELECT Type , 'CLASS_RANGED_EXCEPT_UNIT_HERO_TKH_DIAO_CHAN'
FROM TypeTags tt 
WHERE tt.Type != 'UNIT_HERO_TKH_DIAO_CHAN' AND tt.Tag == 'CLASS_RANGED' AND tt.Type IN (SELECT UnitType FROM Units);
  -- 
