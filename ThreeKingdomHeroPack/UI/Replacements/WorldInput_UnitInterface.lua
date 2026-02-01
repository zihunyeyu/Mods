--[[
-- Copyright (c) 2017-2018 Firaxis Games
--]] -- ===========================================================================
-- INCLUDE BASE FILE
-- ===========================================================================
include("WorldInput");
include("WorldInput_Expansion1");
include("WorldInput_Expansion2");

include "TKH_UnitCommandDefs"

----------------------------------------------------------------
-- Misc Defines
----------------------------------------------------------------
INTERFACEMODE_HEAL_UNIT = DB.MakeHash("INTERFACEMODE_HEAL_UNIT")
INTERFACEMODE_EX_ACTION = DB.MakeHash("INTERFACEMODE_EX_ACTION")
INTERFACEMODE_DEAL_DAMAGE = DB.MakeHash("INTERFACEMODE_DEAL_DAMAGE")
INTERFACEMODE_BURN_VOLCAND = DB.MakeHash("INTERFACEMODE_BURN_VOLCAND")
INTERFACEMODE_TKH_TELEPORT = DB.MakeHash("INTERFACEMODE_TKH_TELEPORT")


INTERFACEMODE_CHANGE_SELECTED_PLOT = DB.MakeHash("INTERFACEMODE_CHANGE_SELECTED_PLOT")
-- ===========================================================================
--	CACHE BASE FUNCTIONS
-- ===========================================================================
TKH_LateInitialize = LateInitialize;

-- ===========================================================================
--	HELPER FUNCTIONS
-- ===========================================================================
-- Is plotID contained in g_targetPlots?
function IsTargetPlot(plotID)
    if (g_targetPlots == nil) then
        return false;
    end

    for _, targetPlotID in ipairs(g_targetPlots) do
        if (targetPlotID == plotID) then
            return true;
        end
    end

    return false;
end

local InterfaceModes = {}
------------------------------------------------------------------------------------------------
-- INTERFACEMODE_HEAL_UNIT
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_HEAL_UNIT = {}
InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_HEAL_UNIT.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_HEAL_UNIT.Action = function(pInputStruct)
    local plotID = UI.GetCursorPlotID();
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);
        local pSelectedUnit = UI.GetHeadSelectedUnit();

        if (pSelectedUnit ~= nil) then
            local tParameters = {};
            tParameters[UnitCommandTypes.PARAM_X] = plot:GetX();
            tParameters[UnitCommandTypes.PARAM_Y] = plot:GetY();
            tParameters[UnitCommandTypes.PARAM_NAME] = "CommandHealUnit";
            UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("Play_MP_Player_Ready");
        else
            print("ERROR: Missing head selected unit");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
    g_targetPlots = {};
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end

    local pUnitAdjPlots = Map.GetNeighborPlots(pSelectedUnit:GetX(), pSelectedUnit:GetY(), 2);
    for i, pAdjPlot in ipairs(pUnitAdjPlots) do
        local len = 0
        for loop, pUnit in ipairs(Units.GetUnitsInPlot(pAdjPlot)) do
            if (pUnit ~= nil) then
                if pUnit:GetOwner() == pSelectedUnit:GetOwner() and IsUnitHurt(pUnit) then
                    len = len + 1
                end
            end
        end
        if len == 1 then
            table.insert(g_targetPlots, pAdjPlot:GetIndex());
        end
    end

    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringAttack);
        UILens.SetLayerHexesArea(g_HexColoringAttack, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringAttack);
    UILens.ClearLayerHexes(g_HexColoringAttack);
end

------------------------------------------------------------------------------------------------
-- INTERFACEMODE_EX_ACTION
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_EX_ACTION = {}
InterfaceModes.INTERFACEMODE_EX_ACTION.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_EX_ACTION.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_EX_ACTION.Action = function(pInputStruct)
    local plotID = UI.GetCursorPlotID();
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);
        local commandUnit = UI.GetHeadSelectedUnit()
        local targetUnit = GetPlotFirstUnit(plot)
        if (targetUnit ~= nil) then
            UI.SelectUnit(targetUnit)
            local tParameters = {};
            tParameters[UnitCommandTypes.PARAM_X] = plot:GetX();
            tParameters[UnitCommandTypes.PARAM_Y] = plot:GetY();
            tParameters[UnitCommandTypes.PARAM_NAME] = "CommandRestoreExMove";
            tParameters['TargetUnitID'] = targetUnit:GetID()
            UnitManager.RequestCommand(commandUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);

            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("Play_MP_Player_Ready");
        else
            print("ERROR: Missing head selected unit");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_EX_ACTION.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
    g_targetPlots = {};
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end

    local pUnitAdjPlots = Map.GetNeighborPlots(pSelectedUnit:GetX(), pSelectedUnit:GetY(), 2);
    for i, pAdjPlot in ipairs(pUnitAdjPlots) do
        local len = 0
        for loop, pUnit in ipairs(Units.GetUnitsInPlot(pAdjPlot)) do
            if (pUnit ~= nil) then
                if pUnit:GetOwner() == pSelectedUnit:GetOwner() then
                    if pUnit:GetAttacksRemaining() == 0 or pUnit:GetMovesRemaining() == 0 then
                        len = len + 1
                    end
                end
            end
        end
        if len == 1 then
            table.insert(g_targetPlots, pAdjPlot:GetIndex());
        end
    end

    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringAttack);
        UILens.SetLayerHexesArea(g_HexColoringAttack, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_EX_ACTION.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringAttack);
    UILens.ClearLayerHexes(g_HexColoringAttack);
end

------------------------------------------------------------------------------------------------
-- INTERFACEMODE_DEAL_DAMAGE
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_DEAL_DAMAGE = {}
InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.Action = function(pInputStruct)
    local plotID = UI.GetCursorPlotID();
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);
        local pSelectedUnit = UI.GetHeadSelectedUnit();

        if (pSelectedUnit ~= nil) then
            local tParameters = {};
            tParameters[UnitCommandTypes.PARAM_X] = plot:GetX();
            tParameters[UnitCommandTypes.PARAM_Y] = plot:GetY();
            tParameters[UnitCommandTypes.PARAM_NAME] = "CommandDealDamage";
            UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);

            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("Play_MP_Player_Ready");
        else
            print("ERROR: Missing head selected unit");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
    g_targetPlots = {};
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end

    local pUnitAdjPlots = Map.GetNeighborPlots(pSelectedUnit:GetX(), pSelectedUnit:GetY(), 2);
    local diplomacy = Players[pSelectedUnit:GetOwner()]:GetDiplomacy()
    for i, pAdjPlot in ipairs(pUnitAdjPlots) do
        local len = 0
        for loop, pUnit in ipairs(Units.GetUnitsInPlot(pAdjPlot)) do
            if (pUnit ~= nil and diplomacy:IsAtWarWith(pUnit:GetOwner())) then
                len = len + 1
            end
        end
        if len == 1 then
            table.insert(g_targetPlots, pAdjPlot:GetIndex());
        end
    end

    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringAttack);
        UILens.SetLayerHexesArea(g_HexColoringAttack, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringAttack);
    UILens.ClearLayerHexes(g_HexColoringAttack);
end

------------------------------------------------------------------------------------------------
-- INTERFACEMODE_BURN_VOLCAND
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_BURN_VOLCAND = {}
InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_BURN_VOLCAND.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_BURN_VOLCAND.Action = function(pInputStruct)
    local plotID = UI.GetCursorPlotID();
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);
        local pSelectedUnit = UI.GetHeadSelectedUnit();

        if (pSelectedUnit ~= nil) then
            local tParameters = {};
            tParameters[UnitCommandTypes.PARAM_X] = plot:GetX();
            tParameters[UnitCommandTypes.PARAM_Y] = plot:GetY();
            tParameters[UnitCommandTypes.PARAM_NAME] = "CommandBurnMountain";
            UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);
            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            -- UI.PlaySound("Play_MP_Player_Ready");
        else
            print("ERROR: Missing head selected plot");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
    g_targetPlots = {};
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end

    local pUnitAdjPlots = Map.GetNeighborPlots(pSelectedUnit:GetX(), pSelectedUnit:GetY(), 1)
    for _, pAdjPlot in ipairs(pUnitAdjPlots) do
        if pAdjPlot:IsMountain() then
            table.insert(g_targetPlots, pAdjPlot:GetIndex())
        end
    end

    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringAttack);
        UILens.SetLayerHexesArea(g_HexColoringAttack, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringAttack);
    UILens.ClearLayerHexes(g_HexColoringAttack);
end



------------------------------------------------------------------------------------------------
-- INTERFACEMODE_CHANGE_SELECTED_PLOT
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT = {}
InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.Action = function(pInputStruct)
    local iPlayer = Game.GetLocalPlayer();
    local plotID = UI.GetCursorPlotID();
    local unitID = PlayerConfigurations[iPlayer]:GetValue('TKH_COMMAND_UNIT_ID')
    local commandUnit = UnitManager.GetUnit(iPlayer, unitID)

    if commandUnit == nil then
        print("ERROR: Missing command unit");
        return false
    end
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);

        if (plot ~= nil) then
            local kParameters = {};
            kParameters.OnStart = "CommandChangeSelectedPlot";
            kParameters.iX = plot:GetX()
            kParameters.iY = plot:GetY()
            kParameters.UnitID = unitID
            kParameters.CommandType = 'UNITCOMMAND_CHANGE_SELECTED_PLOT'
            UI.RequestPlayerOperation(iPlayer, PlayerOperations.EXECUTE_SCRIPT, kParameters)
            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("Play_MP_Player_Ready");
        else
            print("ERROR: Missing head selected plot");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.WAIT);
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end
    g_targetPlots = GetCommandValidPlots(pSelectedUnit, 'UNITCOMMAND_CHANGE_SELECTED_PLOT')
    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringAttack);
        UILens.SetLayerHexesArea(g_HexColoringAttack, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringAttack);
    UILens.ClearLayerHexes(g_HexColoringAttack);
end

------------------------------------------------------------------------------------------------
-- INTERFACEMODE_TKH_TELEPORT
------------------------------------------------------------------------------------------------
InterfaceModes.INTERFACEMODE_TKH_TELEPORT = {}
InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnMouseEnd = function(pInputStruct)
    if g_isMouseDragging then
        g_isMouseDragging = false;
    elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
        InterfaceModes.INTERFACEMODE_TKH_TELEPORT.Action(pInputStruct);
    end
    EndDragMap();
    g_isMouseDownInWorld = false;
    return true;
end
InterfaceModes.INTERFACEMODE_TKH_TELEPORT.Action = function(pInputStruct)
    local plotID = UI.GetCursorPlotID();
    if Map.IsPlot(plotID) and IsTargetPlot(plotID) then
        local plot = Map.GetPlotByIndex(plotID);
        local pSelectedUnit = UI.GetHeadSelectedUnit();

        if (pSelectedUnit ~= nil) then
            local tParameters = {};
            tParameters[UnitCommandTypes.PARAM_X] = plot:GetX();
            tParameters[UnitCommandTypes.PARAM_Y] = plot:GetY();
            tParameters[UnitCommandTypes.PARAM_NAME] = "CommandTeleport";
            UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.EXECUTE_SCRIPT, tParameters);

            UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
            UI.PlaySound("Play_MP_Player_Ready");
            UI.LookAtPlotScreenPosition(plot:GetX(), plot:GetY(), 0.5, 0.5);
        else
            print("ERROR: Missing head selected unit");
        end
    end
    return true;
end
InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnInterfaceModeChange = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
    g_targetPlots = {};
    local pSelectedUnit = UI.GetHeadSelectedUnit();
    if (pSelectedUnit == nil) then
        return;
    end

    local jumpParams = GetCommandParameters(GetUnitType(pSelectedUnit), 'UNITCOMMAND_TKH_TELEPORT')
    if not jumpParams then
        return
    end

    local range = 3
    for _, row in ipairs(jumpParams) do
        if row.Name == 'Range' then
            range = tonumber(row.Value) or 3
        end
    end

    local pUnitAdjPlots = Map.GetNeighborPlots(pSelectedUnit:GetX(), pSelectedUnit:GetY(), range) or {}
    for _, pAdjPlot in ipairs(pUnitAdjPlots) do
        table.insert(g_targetPlots, pAdjPlot:GetIndex());
    end

    -- g_HexColoringAttack    = UILens.CreateLensLayerHash("Hex_Coloring_Attack");
    -- g_HexColoringMovement  = UILens.CreateLensLayerHash("Hex_Coloring_Movement");
    -- g_HexColoringPlacement = UILens.CreateLensLayerHash("Hex_Coloring_Placement");

    if (table.count(g_targetPlots) ~= 0) then
        local eLocalPlayer = Game.GetLocalPlayer();
        UILens.ToggleLayerOn(g_HexColoringMovement);
        UILens.SetLayerHexesArea(g_HexColoringMovement, eLocalPlayer, g_targetPlots);
    end
end
InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnInterfaceModeLeave = function(eNewMode)
    UIManager:SetUICursor(CursorTypes.NORMAL);
    UILens.ToggleLayerOff(g_HexColoringMovement);
    UILens.ClearLayerHexes(g_HexColoringMovement);
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function LateInitialize()
    TKH_LateInitialize();

    InterfaceModeMessageHandler[INTERFACEMODE_HEAL_UNIT] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_HEAL_UNIT][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_HEAL_UNIT][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_HEAL_UNIT][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_HEAL_UNIT.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_HEAL_UNIT][KeyEvents.KeyUp] = OnPlacementKeyUp;

    InterfaceModeMessageHandler[INTERFACEMODE_EX_ACTION] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_EX_ACTION][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_EX_ACTION.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_EX_ACTION][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_EX_ACTION.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_EX_ACTION][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_EX_ACTION.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_EX_ACTION][KeyEvents.KeyUp] = OnPlacementKeyUp;

    InterfaceModeMessageHandler[INTERFACEMODE_DEAL_DAMAGE] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_DEAL_DAMAGE][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_DEAL_DAMAGE][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_DEAL_DAMAGE][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_DEAL_DAMAGE.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_DEAL_DAMAGE][KeyEvents.KeyUp] = OnPlacementKeyUp;

    InterfaceModeMessageHandler[INTERFACEMODE_BURN_VOLCAND] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_BURN_VOLCAND][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_BURN_VOLCAND][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_BURN_VOLCAND][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_BURN_VOLCAND.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_BURN_VOLCAND][KeyEvents.KeyUp] = OnPlacementKeyUp;


    InterfaceModeMessageHandler[INTERFACEMODE_CHANGE_SELECTED_PLOT] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_CHANGE_SELECTED_PLOT][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_CHANGE_SELECTED_PLOT][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_CHANGE_SELECTED_PLOT][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_CHANGE_SELECTED_PLOT.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_CHANGE_SELECTED_PLOT][KeyEvents.KeyUp] = OnPlacementKeyUp;

    InterfaceModeMessageHandler[INTERFACEMODE_TKH_TELEPORT] = {};
    InterfaceModeMessageHandler[INTERFACEMODE_TKH_TELEPORT][INTERFACEMODE_ENTER] =
        InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnInterfaceModeChange;
    InterfaceModeMessageHandler[INTERFACEMODE_TKH_TELEPORT][INTERFACEMODE_LEAVE] =
        InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnInterfaceModeLeave;
    InterfaceModeMessageHandler[INTERFACEMODE_TKH_TELEPORT][MouseEvents.LButtonUp] =
        InterfaceModes.INTERFACEMODE_TKH_TELEPORT.OnMouseEnd
    InterfaceModeMessageHandler[INTERFACEMODE_TKH_TELEPORT][KeyEvents.KeyUp] = OnPlacementKeyUp;
end
