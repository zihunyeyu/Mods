-- 20CFT_UnitCommandDefs
-- Author: PurpleSoul
-- DateCreated: 4/10/2025 10:11:19 PM
--------------------------------------------------------------
include("TKH_Helper");


-- ===========================================================================
--	Variables
-- ===========================================================================
m_20CFT_UnitCommands                                            = {};

-- ===========================================================================
--	UNITCOMMAND_HEAL_UNIT
-- ===========================================================================
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT                      = {};
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT.EventName            = nil
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT.Properties           = {};
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT.IsVisible            = function(pUnit)
	return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT.CanUse               = function(pUnit)
	return IsUnitHasCommand(pUnit, 'UNITCOMMAND_HEAL_UNIT') and pUnit:GetMovesRemaining() > 0
end
m_20CFT_UnitCommands.UNITCOMMAND_HEAL_UNIT.IsDisabled           = function(pUnit)
	local isActionUsed = pUnit:GetProperty("isActionUsed")

	if isActionUsed == true then
		return 'LOC_ACTION_DISABLE_TOOLTIP_NO_USE_TIME';
	end

	if (pUnit:GetMovesRemaining() == 0) then
		return 'LOC_ACTION_DISABLE_TOOLTIP_NO_MOVEMENT'
	end

	local isExist = IsExistHurtUnitInRangeX(pUnit, 2);
	if (isExist == false) then
		return 'LOC_ACTION_DISABLE_TOOLTIP_NO_TARGET';
	end

	return nil;
end

