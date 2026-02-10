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
TKH_AddActionToTable            = AddActionToTable;
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

function AddActionToTable(actionsTable, action, disabled, toolTipString, actionHash, callbackFunc, callbackVoid1,
                          callbackVoid2, overrideIcon)
    -- local actionsCategoryTable;
    -- if (actionsTable[action.CategoryInUI] ~= nil) then
    --     actionsCategoryTable = actionsTable[action.CategoryInUI];
    -- else
    --     UI.DataError("Operation is in unsupported action category '" .. tostring(action.CategoryInUI) .. "'.");
    --     actionsCategoryTable = actionsTable["SPECIFIC"];
    -- end

    -- -- Wrap every callback function with a call that guarantees the interface
    -- -- mode is reset.  It prevents issues such as selecting range attack and
    -- -- then instead of attacking, choosing another action, which would leave
    -- -- up the range attack lens layer.
    -- local wrappedCallback =
    --     function(void1, void2)
    --         local currentMode = UI.GetInterfaceMode();
    --         if currentMode ~= InterfaceModeTypes.SELECTION then
    --             UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
    --         end
    --         callbackFunc(void1, void2, currentMode);
    --     end;

    -- table.insert(actionsCategoryTable, {
    --     IconId            = (overrideIcon and overrideIcon) or action.Icon,
    --     Disabled          = disabled,
    --     helpString        = toolTipString,
    --     userTag           = actionHash,
    --     CallbackFunc      = wrappedCallback,
    --     CallbackVoid1     = callbackVoid1,
    --     CallbackVoid2     = callbackVoid2,
    --     IsBestImprovement = action.IsBestImprovement,
    --     Sound             = action.Sound
    -- });

    -- -- Hotkey support
    -- if (action.HotkeyId ~= nil) and disabled == false then
    --     local actionId = Input.GetActionId(action.HotkeyId);
    --     if actionId ~= nil then
    --         m_kHotkeyActions[actionId] = wrappedCallback;
    --         m_kHotkeyCV1[actionId] = callbackVoid1;
    --         m_kHotkeyCV2[actionId] = callbackVoid2;
    --         m_kSoundCV1[actionId] = action.Sound;
    --     else
    --         UI.DataError("Cannot set hotkey on Unitpanel for action with icon '" ..
    --         action.IconId .. "' because engine doesn't have actionId of '" .. action.HotkeyId .. "'.");
    --     end
    -- end


    TKH_AddActionToTable(actionsTable, action, disabled, toolTipString, actionHash, callbackFunc, callbackVoid1,
        callbackVoid2, overrideIcon);


    -- print(actionsTable, action, disabled, toolTipString, actionHash, callbackFunc, callbackVoid1,
    --     callbackVoid2, overrideIcon)
end

function GetUnitActionsTable(pUnit)
    local pBaseActionsTable = TKH_GetUnitActionsTable(pUnit);

    -- UnitPanel:         	1	SECONDARY
    -- UnitPanel:         	1	ATTACK
    -- UnitPanel:         	2	OFFENSIVESPY
    -- UnitPanel:         	3	SPECIFIC
    -- UnitPanel:         	4	MOVE
    -- UnitPanel:         	5	INPLACE
    -- UnitPanel:         	6	GAMEMODIFY
    -- UnitPanel: GetUnitActionsTable:	SPECIFIC	table: 00000001B9472C90
    -- UnitPanel:         	userTag	374670040
    -- UnitPanel:         	Disabled	true
    -- UnitPanel:         	CallbackVoid1	-1572680103
    -- UnitPanel:         	CallbackFunc	function: 00000001B94721F0
    -- UnitPanel:         	IconId	ICON_UNITCOMMAND_ACTIVATE_GREAT_PERSON
    -- UnitPanel:         	helpString	隐退[NEWLINE][NEWLINE]把相邻蛮族转到您的控制之下。[NEWLINE][COLOR_RED]进行此操作后，伟人将无法再建造任何单元格改良设施。[ENDCOLOR][NEWLINE][NEWLINE][COLOR:Red]必须靠近一个蛮族单位。[ENDCOLOR]
    -- UnitPanel:         	CallbackVoid2	374670040

    for _, value in pairs(pBaseActionsTable['MOVE']) do
        if value.userTag == UnitOperationTypes.TELEPORT_TO_CITY then
            local lastTurn = pUnit:GetProperty('TeleportToCityTurn')
            -- print('lastTurn', lastTurn, Game.GetCurrentGameTurn(), (lastTurn + 5) < Game.GetCurrentGameTurn())
            if lastTurn and (lastTurn + 5) > Game.GetCurrentGameTurn() then
                value.helpString = value.helpString ..
                    '[NEWLINE][NEWLINE][COLOR:Red]' ..
                    Locale.Lookup('LOC_ACTION_DISABLE_TOOLTIP_LEFT_TURN', (lastTurn + 5) - Game.GetCurrentGameTurn()) ..
                    '[ENDCOLOR]';
                value.Disabled = true;
                break
            else
                value.Disabled = false;
            end
            break
        end
    end


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
