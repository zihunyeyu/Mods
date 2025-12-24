-- UnitPanel_20CFT
-- Author: PurpleSoul
-- DateCreated: 4/10/2025 10:10:59 PM
--------------------------------------------------------------
-- OFFICAL
include 'UnitPanel'
include 'UnitPanel_Expansion1'
include 'UnitPanel_Expansion2'

-- MOD
include('UnitPanel_Klee.lua')
include('DAL_UnitPanel.lua')
include('LagFixHotkey.lua')
include('UnitPanel_BlackDeathScenario.lua')
include('GoldenAge_UnitPanel.lua')
include('UnitPanel_TPT.lua')
include('DL_UnitPanel.lua')
include('UnitPanel_RealRivers.lua')

include('UnitPanel_TKH.lua')
include('UnitPanel_TRM.lua')

-- SUPPORT
include '20CFT_UnitCommandDefs'

-- ===========================================================================
--	CACHE BASE FUNCTIONS
-- ===========================================================================
M20CFT_AddActionButton = AddActionButton;
M20CFT_FilterUnitStatsFromUnitData = FilterUnitStatsFromUnitData;
M20CFT_GetCombatModifierList = GetCombatModifierList;
M20CFT_GetUnitActionsTable = GetUnitActionsTable;
M20CFT_LateInitialize = LateInitialize;
M20CFT_OnShowCombat = OnShowCombat;
M20CFT_ShowSubjectUnitStats = ShowSubjectUnitStats;


M20CFT_ReadUnitData = ReadUnitData
-- ===========================================================================
--	OVERRIDE BASE FUNCTIONS
-- ===========================================================================
function GetUnitActionsTable(pUnit)
	local pBaseActionsTable = M20CFT_GetUnitActionsTable(pUnit);

	-- for commandType, pCommandTable in pairs(m_20CFT_UnitCommands) do
	-- 	local bVisible = true;
	-- 	if (pCommandTable.IsVisible ~= nil) then
	-- 		bVisible = pCommandTable.IsVisible(pUnit);
	-- 	end
	-- 	if (bVisible) then
	-- 		if (pCommandTable.CanUse ~= nil and pCommandTable.CanUse(pUnit) == true) then
	-- 			local sToolTipString = pCommandTable.ActionName or 'Undefined Unit Command';
	-- 			sToolTipString = Locale.Lookup(sToolTipString);

	-- 			if pCommandTable.ActionDescription ~= nil then
	-- 				local helpTooltip = Locale.Lookup(pCommandTable.ActionDescription)
	-- 				if pCommandTable.ResetDescription ~= nil then
	-- 					helpTooltip = pCommandTable.ResetDescription(pUnit)
	-- 				end
	-- 				sToolTipString = sToolTipString ..
	-- 					'[NEWLINE][NEWLINE]' .. helpTooltip;
	-- 			end

	-- 			local pCallback       = function()
	-- 				local pSelectedUnit = UI.GetHeadSelectedUnit();
	-- 				if (pSelectedUnit == nil) then
	-- 					return;
	-- 				end

	-- 				if (pCommandTable.EventName ~= nil) then
	-- 					-- EventName is the name of the GameCore lua script event that should be triggered to start this unit action.
	-- 					local tParameters = {};
	-- 					tParameters[UnitCommandTypes.PARAM_NAME] = pCommandTable.EventName or '';
	-- 					tParameters.CommandSubType = pCommandTable.CommandSubType;
	-- 					tParameters.CommandType = commandType
	-- 					UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
	-- 				elseif (pCommandTable.InterfaceMode ~= nil) then
	-- 					-- InterfaceMode is the InterfaceModeTypes that should be triggered for this unit action
	-- 					UI.SetInterfaceMode(pCommandTable.InterfaceMode);

	-- 					-- WorldInput handles things from here.
	-- 				end
	-- 			end

	-- 			-- 判断行动是否可用，并返回不可用原因
	-- 			local bIsDisabled     = false;
	-- 			local disabledToolTip = nil

	-- 			if (pCommandTable.IsDisabled ~= nil) then
	-- 				disabledToolTip = pCommandTable.IsDisabled(pUnit);
	-- 				-- 无不可用原因时代表行动可用
	-- 				if disabledToolTip ~= nil then
	-- 					bIsDisabled = true
	-- 				end
	-- 			end

	-- 			if (bIsDisabled) then
	-- 				if (disabledToolTip ~= nil) then
	-- 					disabledToolTip = Locale.Lookup(disabledToolTip);
	-- 					sToolTipString = sToolTipString ..
	-- 						'[NEWLINE][NEWLINE]' .. '[COLOR:Red]' .. disabledToolTip .. '[ENDCOLOR]';
	-- 				end
	-- 			end

	-- 			AddActionToTable(pBaseActionsTable, pCommandTable, bIsDisabled, sToolTipString,
	-- 				UnitCommandTypes.EXECUTE_SCRIPT, pCallback);
	-- 		end
	-- 	end
	-- end

	return pBaseActionsTable;
end

function ReadUnitData(unit)
	local kSubjectData = M20CFT_ReadUnitData(unit)

	-- ================MODIFIER================
	local customCommandCharges = unit:GetProperty('ActionCharges')
	if customCommandCharges ~= nil then
		kSubjectData.GreatPersonActionCharges = customCommandCharges
	end
	-- ================MODIFIER================

	return kSubjectData
end

-- ===========================================================================
function LateInitialize()
	M20CFT_LateInitialize();
end
