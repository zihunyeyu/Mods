-- ===========================================================================
--	Unit Panel Replacement/Extension
--	Pirates Scenario
-- ===========================================================================
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

-- SUPPORT
include 'TKH_UnitCommandDefs'




-- ===========================================================================
--	CACHE BASE FUNCTIONS
-- ===========================================================================
TKH_AddActionButton             = AddActionButton;
TKH_FilterUnitStatsFromUnitData = FilterUnitStatsFromUnitData;
-- TKH_GetCombatModifierList       = GetCombatModifierList;
TKH_GetUnitActionsTable         = GetUnitActionsTable;
TKH_LateInitialize              = LateInitialize;
TKH_OnShowCombat                = OnShowCombat;
-- TKH_ShowCombatAssessment        = ShowCombatAssessment;
TKH_ShowSubjectUnitStats        = ShowSubjectUnitStats;

TKH_ReadUnitData                = ReadUnitData

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local m_kCombatResults          = {};


-- ===========================================================================
--	OVERRIDE BASE FUNCTIONS
-- ===========================================================================
function GetUnitActionsTable(pUnit)
    local pBaseActionsTable = TKH_GetUnitActionsTable(pUnit);

    for commandType, pCommandTable in pairs(m_TKH_UnitCommands) do
        local bVisible = true;
        if (pCommandTable.IsVisible ~= nil) then
            bVisible = pCommandTable.IsVisible(pUnit);
        end
        if (bVisible) then
            if (pCommandTable.CanUse ~= nil and pCommandTable.CanUse(pUnit) == true) then
                local sToolTipString = pCommandTable.ActionName or 'Undefined Unit Command';
                sToolTipString = Locale.Lookup(sToolTipString);

                if pCommandTable.ActionDescription ~= nil then
                    local helpTooltip = Locale.Lookup(pCommandTable.ActionDescription)
                    if pCommandTable.ResetDescription ~= nil then
                        helpTooltip = pCommandTable.ResetDescription(pUnit)
                    end
                    sToolTipString = sToolTipString .. '[NEWLINE][NEWLINE]' .. helpTooltip

                    local actionCharges = pUnit:GetProperty('CustomCommandActionCharges') or {}

                    local commandCharges = actionCharges[commandType]
                    if commandCharges then
                        local actionMax = commandCharges[2]

                        local extraActions = pUnit:GetProperty('ExtraActions') or {}
                        if extraActions[commandType] and extraActions[commandType][1] == EXTRA_ACTION_TYPE.MAX then
                            actionMax = actionMax + extraActions[commandType][2]
                        end

                        local actionChargesTooltip = Locale.Lookup('LOC_UNITCOMMAND_LEFT_ACTION_CHARGES_HELP',
                            commandCharges[1], actionMax)
                        sToolTipString = sToolTipString .. '[NEWLINE][NEWLINE]' .. actionChargesTooltip
                    end
                end

                local pCallback = function()
                    local pSelectedUnit = UI.GetHeadSelectedUnit();
                    if (pSelectedUnit == nil) then
                        return;
                    end
                    -- ================= 传入行动UNIT_TYPE =============
                    PlayerConfigurations[pSelectedUnit:GetOwner()]:SetValue('TKH_COMMAND_UNIT_ID', pSelectedUnit:GetID());
                    -- ============= 特殊命令 =============
                    if commandType == 'UNITCOMMAND_BUILD_IMPROVEMENT' then
                        local tParameters = {};
                        tParameters[UnitOperationTypes.PARAM_X] = pSelectedUnit:GetX();
                        tParameters[UnitOperationTypes.PARAM_Y] = pSelectedUnit:GetY();
                        tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE] = GameInfo.Improvements
                            ['IMPROVEMENT_GREAT_WALL_TKH'].Index
                        UnitManager.RequestOperation(pSelectedUnit, UnitOperationTypes.BUILD_IMPROVEMENT, tParameters);
                    end

                    -- ============= 特殊命令 =============
                    if (pCommandTable.EventName ~= nil) then
                        local tParameters = {};
                        tParameters[UnitCommandTypes.PARAM_NAME] = pCommandTable.EventName or '';
                        tParameters.CommandSubType = pCommandTable.CommandSubType;
                        tParameters.CommandType = commandType
                        UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
                    elseif (pCommandTable.InterfaceMode ~= nil) then
                        UI.SetInterfaceMode(pCommandTable.InterfaceMode)
                    end
                end

                -- 判断行动是否可用，并返回不可用原因
                local bIsDisabled = false;
                local disabledToolTip = nil

                if (pCommandTable.IsDisabled ~= nil) then
                    disabledToolTip = pCommandTable.IsDisabled(pUnit);
                    -- 无不可用原因时代表行动可用
                    if disabledToolTip ~= nil then
                        bIsDisabled = true
                    end
                end

                if (bIsDisabled) then
                    if (disabledToolTip ~= nil) then
                        disabledToolTip = Locale.Lookup(disabledToolTip);
                        sToolTipString = sToolTipString .. '[NEWLINE][NEWLINE]' .. '[COLOR:Red]' .. disabledToolTip ..
                            '[ENDCOLOR]';
                    end
                end

                AddActionToTable(pBaseActionsTable, pCommandTable, bIsDisabled, sToolTipString,
                    UnitCommandTypes.EXECUTE_SCRIPT, pCallback);
            end
        end
    end

    return pBaseActionsTable;
end

function ReadUnitData(unit)
    local kSubjectData = TKH_ReadUnitData(unit)

    -- ================MODIFIER================
    local customCommandCharges = unit:GetProperty('CustomCommandActionCharges')
    if customCommandCharges ~= nil then
        for key, value in pairs(customCommandCharges) do
            if type(value) == 'table' then
                kSubjectData.GreatPersonActionCharges = value[1]
            end
        end
    end
    -- ================MODIFIER================

    return kSubjectData
end

-- ===========================================================================


-- ===========================================================================
function LateInitialize()
    TKH_LateInitialize();
end
