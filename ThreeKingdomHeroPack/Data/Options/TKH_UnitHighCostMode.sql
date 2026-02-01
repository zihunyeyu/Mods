-- TKH_UnitHighCostMode
-- Author: PurpleSoul
-- DateCreated: 6/1/2025 10:20:17 AM
--------------------------------------------------------------

-- 剑客
UPDATE Units SET Maintenance=2 WHERE UnitType='UNIT_SWORDSMAN'; 
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_IRON', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_SWORDSMAN';
-- 骑手
UPDATE Units SET Maintenance=2 WHERE UnitType='UNIT_HORSEMAN'; 
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_HORSES', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_HORSEMAN';
-- 石弩
UPDATE Units SET Maintenance=2 WHERE UnitType='UNIT_CATAPULT';
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_IRON', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_CATAPULT';
-- 披甲战士
UPDATE Units SET Maintenance=6 WHERE UnitType='UNIT_MAN_AT_ARMS'; 
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_IRON', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_MAN_AT_ARMS';
-- 追猎者
UPDATE Units SET Maintenance=6 WHERE UnitType='UNIT_COURSER'; 
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_HORSES', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_COURSER';
-- 投石机
UPDATE Units SET Maintenance=15, StrategicResource='RESOURCE_IRON' WHERE UnitType='UNIT_TREBUCHET'; 
-- 弩手
UPDATE Units SET Maintenance=10 WHERE UnitType='UNIT_CROSSBOWMAN'; 
-- 骑士
UPDATE Units SET Maintenance=10 WHERE UnitType='UNIT_KNIGHT'; 
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_HORSES', ResourceMaintenanceAmount=1 WHERE UnitType='UNIT_KNIGHT';
-- 长矛兵
UPDATE Units SET Maintenance=6 WHERE UnitType='UNIT_PIKEMAN'; 
-- 锐士
UPDATE Units SET Maintenance=1 WHERE UnitType='UNIT_PHANTA_RUISHI';
-- 游侠
UPDATE Units SET Maintenance=1 WHERE UnitType='UNIT_PHANTA_YOUXIA';

UPDATE Units SET Maintenance=15 WHERE UnitType='UNIT_WARRIOR_MONK';

-- UPDATE Units SET Maintenance=0 WHERE UnitType='UNIT_CUIRASSIER';
-- UPDATE Units SET Maintenance=0 WHERE UnitType='UNIT_KNIGHT';



INSERT OR IGNORE INTO Units_XP2(UnitType, ResourceCost, ResourceMaintenanceType, ResourceMaintenanceAmount)
VALUES
('UNIT_WARRIOR_MONK', NULL, 'RESOURCE_HORSES', 1),
('UNIT_TREBUCHET', 20, 'RESOURCE_IRON', 1),
('UNIT_PIKEMAN', 0, 'RESOURCE_IRON', 1),
('UNIT_CROSSBOWMAN', 20, 'RESOURCE_IRON', 1),
('UNIT_PHANTA_RUISHI', 20, 'RESOURCE_IRON', 1),
('UNIT_PHANTA_YOUXIA', 0, 'RESOURCE_IRON', 1);