include('TRM_Helper')
include('TRM_TradeRouteModifierInstance')

GameEvents = ExposedMembers.GameEvents

-- Get idle Trade Units by Player ID
function GetIdleTradeUnits(playerID)
    local idleTradeUnits = {};
    -- Loop through the Players units
    local localPlayerUnits = Players[playerID]:GetUnits();
    for i, unit in localPlayerUnits:Members() do
        -- Find any trade units
        local unitInfo = GameInfo.Units[unit:GetUnitType()];
        if unitInfo.MakeTradeRoute then
            local doestradeUnitHasRoute = false;
            -- Determine if those trade units are busy by checking outgoing routes from the players cities
            local localPlayerCities = Players[playerID]:GetCities();
            for i, city in localPlayerCities:Members() do
                local routes = city:GetTrade():GetOutgoingRoutes();
                for i, route in ipairs(routes) do
                    if route.TraderUnitID == unit:GetID() then
                        doestradeUnitHasRoute = true;
                    end
                end
            end
            -- If this trade unit isn't attached to an outgoing route then they are idle
            if not doestradeUnitHasRoute then
                table.insert(idleTradeUnits, unit);
            end
        end
    end
    return idleTradeUnits;
end

-- ===========================================================================


function GetYieldsForRoute(pOriginCity, pDestinationCity, bReturnDestiationYields)
    local kRouteInfo = {
        kYieldValues = {},
        TooltipText = "",
        HasPathBonus = false,
        MajorityReligion = -1,
        ReligionPressure = -1
    }
    if pOriginCity == nil or pDestinationCity == nil then
        return kRouteInfo;
    end
    local pTradeManager = Game.GetTradeManager();
    -- Default to origin yields
    if bReturnDestiationYields == nil then
        bReturnDestiationYields = false;
    end
    local originOwnerID = pOriginCity:GetOwner();
    local originCityID = pOriginCity:GetID();
    local destOwnerID = pDestinationCity:GetOwner();
    local destCityID = pDestinationCity:GetID();
    -- From route
    local kRouteYields = {};
    if not bReturnDestiationYields then
        kRouteYields = pTradeManager:CalculateOriginYieldsFromPotentialRoute(originOwnerID, originCityID, destOwnerID,
            destCityID);
    else
        kRouteYields = pTradeManager:CalculateDestinationYieldsFromPotentialRoute(originOwnerID, originCityID,
            destOwnerID, destCityID);
    end
    -- From path
    local kPathYields = {};
    if not bReturnDestiationYields then
        kPathYields = pTradeManager:CalculateOriginYieldsFromPath(originOwnerID, originCityID, destOwnerID, destCityID);
    else
        kPathYields = pTradeManager:CalculateDestinationYieldsFromPath(originOwnerID, originCityID, destOwnerID,
            destCityID);
    end
    -- From modifiers
    local kModifierYields = {};
    if not bReturnDestiationYields then
        kModifierYields = pTradeManager:CalculateOriginYieldsFromModifiers(originOwnerID, originCityID, destOwnerID,
            destCityID);
    else
        kModifierYields = pTradeManager:CalculateDestinationYieldsFromModifiers(originOwnerID, originCityID,
            destOwnerID, destCityID);
    end
    -- Overall modifiers / multipliers
    local kYieldMultipliers = {};
    for yieldIndex = 1, #kRouteYields, 1 do
        kYieldMultipliers[yieldIndex] = 1;
        if originOwnerID ~= destOwnerID then
            if not bReturnDestiationYields then
                local pPlayerTrade = Players[originOwnerID]:GetTrade();
                kYieldMultipliers[yieldIndex] = pPlayerTrade:GetInternationalYieldModifier(yieldIndex - 1);
            else
                local pPlayerTrade = Players[destOwnerID]:GetTrade();
                kYieldMultipliers[yieldIndex] = pPlayerTrade:GetInternationalYieldModifier(yieldIndex - 1);
            end
        end
    end

    -- ==================创建TRM==================
    local trmYields = {}

    local tradeRouteID = table.concat({ originOwnerID, originCityID, destOwnerID, destCityID }, '-')
    local m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}


    local trmInstans = {}
    if m_TradeRouteModifierManager[tradeRouteID] then
        for _, trmInstance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
            setmetatable(trmInstance, TradeRouteModifierInstance)
            trmInstance:Calculate()
        end
        trmInstans = m_TradeRouteModifierManager[tradeRouteID]
    else
        m_TradeRouteModifierManager = CreateTradeRouteModifier(originOwnerID, originCityID, destOwnerID, destCityID,
            m_TradeRouteModifierManager)
        trmInstans = m_TradeRouteModifierManager[tradeRouteID] or {}
    end

    GameEvents.SetGameProperty.Call('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)


    for _, trmInstance in pairs(trmInstans) do
        if bReturnDestiationYields then
            if trmInstance.BenefitCity == 2 or trmInstance.BenefitCity == 0 then
                table.insert(trmYields, trmInstance.Yields)
            end
        else
            if trmInstance.BenefitCity == 1 or trmInstance.BenefitCity == 0 then
                table.insert(trmYields, trmInstance.Yields)
            end
        end
    end

    -- ==================创建TRM==================

    -- Add the yields together and return the result
    local era = Game.GetEras():GetCurrentEra() -- add
    for yieldIndex = 1, #kRouteYields, 1 do
        local kYieldInfo = GameInfo.Yields[yieldIndex - 1];
        if kYieldInfo ~= nil then
            local routeValue = kRouteYields[yieldIndex];
            if routeValue > 0 then
                if kRouteInfo.TooltipText ~= "" then
                    kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
                end
                kRouteInfo.TooltipText = kRouteInfo.TooltipText ..
                    Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_DISTRICTS", routeValue,
                        kYieldInfo.IconString, kYieldInfo.Name, pDestinationCity:GetName());
            end
            local pathValue = kPathYields[yieldIndex];
            if pathValue > 0 then
                kRouteInfo.HasPathBonus = true;
                if kRouteInfo.TooltipText ~= "" then
                    kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
                end
                kRouteInfo.TooltipText = kRouteInfo.TooltipText ..
                    Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_TRADING_POSTS", pathValue,
                        kYieldInfo.IconString, kYieldInfo.Name);
            end
            local modifierValue = kModifierYields[yieldIndex];
            if modifierValue > 0 then
                if kRouteInfo.TooltipText ~= "" then
                    kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
                end
                kRouteInfo.TooltipText = kRouteInfo.TooltipText ..
                    Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES", modifierValue,
                        kYieldInfo.IconString, kYieldInfo.Name);
            end
            local totalBeforeMultiplier = routeValue + pathValue + modifierValue;
            local total = totalBeforeMultiplier;

            local valueFromMultiplier = 0
            local multiplier = kYieldMultipliers[yieldIndex];
            if total > 0 and multiplier ~= 1 then
                total = totalBeforeMultiplier * multiplier;
                valueFromMultiplier = total - totalBeforeMultiplier;
            end

            -- ===========================================MODIFIER CONTENT============================================
            for _, trmYield in ipairs(trmYields) do
                local tCity = 1
                if bReturnDestiationYields then
                    tCity = 2
                end
                if trmYield[tCity] then
                    if trmYield[tCity][kYieldInfo.YieldType] then
                        local yields = trmYield[tCity][kYieldInfo.YieldType]
                        total = total + yields.Amount
                        if kRouteInfo.TooltipText ~= "" then
                            kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
                        end
                        kRouteInfo.TooltipText = kRouteInfo.TooltipText .. yields.Description
                        if yields.Multiplier ~= nil then
                            total = total + yields.Multiplier
                            valueFromMultiplier = valueFromMultiplier + yields.Multiplier
                        end
                    end
                end
            end

            if total > 0 and multiplier ~= 1 then
                local multiplierAsPercent = (multiplier * 100) - 100;
                if kRouteInfo.TooltipText ~= "" then
                    kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
                end
                kRouteInfo.TooltipText = kRouteInfo.TooltipText ..
                    Locale.Lookup("LOC_ROUTECHOOSER_YIELD_SOURCE_MULTIPLIERS",
                        valueFromMultiplier, kYieldInfo.IconString, kYieldInfo.Name, multiplierAsPercent);
            end

            -- ===========================================MODIFIER CONTENT===============================================

            -- Put the total into routeYields
            kRouteInfo.kYieldValues[yieldIndex] = total;
        end
    end
    kRouteInfo.MajorityReligion = pOriginCity:GetReligion():GetMajorityReligion();
    if (kRouteInfo.MajorityReligion > 0) then
        local pressureValue, sourceText = GetReligiousPressureForCity(kRouteInfo.MajorityReligion, pOriginCity,
            pDestinationCity, not bReturnDestiationYields);
        if (pressureValue ~= 0) then
            if (kRouteInfo.TooltipText ~= "") then
                kRouteInfo.TooltipText = kRouteInfo.TooltipText .. "[NEWLINE]";
            end
            kRouteInfo.TooltipText = kRouteInfo.TooltipText .. sourceText;
            kRouteInfo.ReligionPressure = pressureValue;
        end
    end
    return kRouteInfo
end

-- ===========================================================================
function GetReligiousPressureForCity(religionIndex, originCity, destinationCity, forOriginCity)
    local pressureValue = 0;
    local pressureIconString = "";
    local cityName = "";
    local tradeManager = Game.GetTradeManager();
    if originCity == nil or destinationCity == nil then
        return 0, "";
    end
    if (forOriginCity) then
        pressureValue = tradeManager:CalculateOriginReligiousPressureFromPotentialRoute(originCity:GetOwner(),
            originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID(), religionIndex);
        pressureIconString = "[ICON_PressureLeft]";
        cityName = destinationCity:GetName();
    else
        pressureValue = tradeManager:CalculateDestinationReligiousPressureFromPotentialRoute(originCity:GetOwner(),
            originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID(), religionIndex);
        pressureIconString = "[ICON_PressureRight]";
        cityName = originCity:GetName();
    end
    local sourceText = Locale.Lookup("LOC_ROUTECHOOSER_RELIGIOUS_PRESSURE_SOURCE_MAJORITY_RELIGION", pressureValue,
        pressureIconString, Game.GetReligion():GetName(religionIndex), cityName);
    return pressureValue, sourceText;
end
