-- TKH_UI_Scripts
-- Author: PurpleSoul
-- DateCreated: 6/10/2025 3:44:25 PM
--------------------------------------------------------------

include('TKH_Constant')
include('TKH_Helper')


-- 研究，相邻单位增加属性
function OnUnitSelectionChanged(playerID, unitID, hexI, hexJ, hexK, isSelected, IsEditable)
    if playerID ~= Game.GetLocalPlayer() then
        return;
    end
    local kUnit = nil;
    local pPlayer = Players[playerID];
    if pPlayer ~= nil then
        kUnit = pPlayer:GetUnits():FindID(unitID);
        local kParameters = {};
        kParameters.OnStart = "SetPropertyByAdjacentUnitsUI"
        kParameters.tUnitID = unitID
        UI.RequestPlayerOperation(playerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
    end
end

function CreateEnmies()
    local isCreated = Game:GetProperty('IsHUANGJINGCreated') or false
    if not isCreated then
        local iW, iH;
        iW, iH = Map.GetGridSize();

        local plots = {}

        for x = 0, iW - 1 do
            for y = 0, iH - 1 do
                local i = y * iW + x;
                local pPlot = Map.GetPlotByIndex(i);

                if (pPlot ~= nil and not pPlot:IsMountain() and not pPlot:IsWater()) then
                    local isPlotHasUnitOrCity = IsPlotHasUnitOrCity(pPlot:GetX(), pPlot:GetY(), 5)
                    if not isPlotHasUnitOrCity then
                        local repeatFlag = false
                        for _, index in ipairs(plots) do
                            local _plot = Map.GetPlotByIndex(index)
                            -- local __plot = Map.GetPlotByIndex(index)
                            if Map.GetPlotDistance(pPlot:GetX(), pPlot:GetY(), _plot:GetX(), _plot:GetY()) <= 5 then
                                repeatFlag = true
                                break
                            end
                        end

                        if not repeatFlag then
                            table.insert(plots, i)
                        end
                    end
                end
            end
        end
        GameConfiguration.SetValue('CreateUnitVlaidPlots', plots)
    else
        -- Events.TurnEnd.Remove(CreateEnmies)
        Events.GameCoreEventPublishComplete.Remove(CreateEnmies)
    end
end

function Initialize()
    -- Events.TurnEnd.Add(CreateEnmies)
    -- Events.GameCoreEventPublishComplete.Add(CreateEnmies)

    Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
end

Events.LoadGameViewStateDone.Add(Initialize)
