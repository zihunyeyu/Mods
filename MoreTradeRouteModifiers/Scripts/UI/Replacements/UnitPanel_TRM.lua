-- =============UnitPanel=============
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
-- include('UnitPanel_20CFT.lua')

-- =============UnitPanel=============
include('TRM_Helper')
include('TTK_ToolkitsCore')

include('TRM_TradeRouteModifierInstance')

TRM_TradeUnitView = TradeUnitView

function TradeUnitView(viewData)
    if viewData.IsTradeUnit then
        local hideTradeYields = true;
        local originPlayer = Players[Game.GetLocalPlayer()];
        local originCities = originPlayer:GetCities();
        for _, city in originCities:Members() do
            local outgoingRoutes = city:GetTrade():GetOutgoingRoutes();
            for i, route in ipairs(outgoingRoutes) do
                if viewData.UnitID == route.TraderUnitID then
                    -- Add Origin Yields
                    Controls.TradeResourceList:DestroyAllChildren();

                    -- =====================MODIFIER=====================
                    local tradeRouteID = table.concat(
                    { route.OriginCityPlayer, route.OriginCityID, route.DestinationCityPlayer, route.DestinationCityID },
                        '-')
                    local cityTRMYields = GetCityTradeRouteModifierYieldsByTradeRouteID(city, tradeRouteID)[1]
                    for j, yieldInfo in pairs(route.OriginYields) do
                        local amount = yieldInfo.Amount
                        local yieldDetails = GameInfo.Yields[yieldInfo.YieldIndex]
                        if cityTRMYields and cityTRMYields[yieldDetails.YieldType] then
                            amount = amount + cityTRMYields[yieldDetails.YieldType].BaseAmount +
                            cityTRMYields[yieldDetails.YieldType].MutilpierAmount
                        end
                        if amount > 0 then
                            AddTradeResourceEntry(yieldDetails, Round(amount, 1));
                            hideTradeYields = false;
                        end
                    end

                    -- =====================MODIFIER=====================
                end
            end
        end

        Controls.TradeYieldGrid:SetHide(hideTradeYields);
        Controls.TradeUnitContainer:SetHide(false);
    else
        Controls.TradeUnitContainer:SetHide(true);
    end
end
