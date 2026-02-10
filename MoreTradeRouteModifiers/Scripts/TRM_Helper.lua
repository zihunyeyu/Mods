include('TRM_Constants')
include('TTK_ToolkitsCore')
-- include('TTK_ToolkitsCore')


-- ==========================
-- GAME FUNCTIONS MATCH ITEMS
-- ==========================


---获取匹配单元格
---@param plots table
---@return table
function GetMatchPlots(plots)
    local matachPlots = {}

    for _, plotIndex in ipairs(plots) do
        local record = {}
        record[CalculationItemType.PLOT] = plotIndex
        table.insert(matachPlots, record)
    end
    return matachPlots
end

---获取玩家的匹配单元格
---@param plots table
---@param playerID number
---@return table
function GetPlayerMatchPlots(plots, playerID)
    local matachPlots = {}

    for _, plotIndex in ipairs(plots) do
        local plot = Map.GetPlotByIndex(plotIndex)
        if plot:GetOwner() == playerID then
            local record = {}
            record[CalculationItemType.PLOT] = plotIndex
            table.insert(matachPlots, record)
        end
    end
    return matachPlots
end

--- 获取匹配的单元格
---@param filters table @过滤器
---@param matchType number @匹配类型
---@param preMatchPlots table @预匹配单元格
---@param playerID number @玩家ID
function GetItemMatchPlots(filters, matchType, preMatchPlots, playerID)
    local nextMatchPlots = {}
    if matchType and matchType < CalculationItemType.MATCH_PLOT_COUNT then
        local player = Players[playerID]
        local resource = player:GetResources()
        local matchItemIndex = -1
        local isMatch = true
        for _, preMatchPlot in ipairs(preMatchPlots) do
            local plotIndex = preMatchPlot[CalculationItemType.PLOT]
            local plot = Map.GetPlotByIndex(plotIndex)
            local territory = Territories.GetTerritoryAt(plotIndex)
            -- 资源
            if matchType == CalculationItemType.RESOURCE then
                matchItemIndex = plot:GetResourceType() or -1
                local resourceInfo = GameInfo.Resources[matchItemIndex]
                if resourceInfo and resource:IsResourceVisible(matchItemIndex) then
                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(resourceInfo, filters['GameInfo'])
                    end
                    if filters['Custom'] then
                        for key, values in pairs(filters['Custom']) do
                            if key == 'IsImproved' then
                                -- 改良并无改良设施
                                if tonumber(values[1]) == 1 and plot:GetImprovementType() == -1 then
                                    isMatch = false
                                end
                                -- 未改良并有改良设施
                                if tonumber(values[1]) == 0 and plot:GetImprovementType() ~= -1 then
                                    isMatch = false
                                end
                            end
                        end
                    end
                else
                    isMatch = false
                end
                -- 改良
            elseif matchType == CalculationItemType.IMPROVEMENT then
                matchItemIndex = plot:GetImprovementType() or -1
                local improvementInfo = GameInfo.Improvements[matchItemIndex]
                if improvementInfo then
                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(improvementInfo, filters['GameInfo'])
                    end
                end
                -- 奇观
            elseif matchType == CalculationItemType.WONDER then
                if plot:GetWonderType() ~= -1 or plot:IsNaturalWonder() then
                    if filters['Custom'] then
                        for key, values in pairs(filters['Custom']) do
                            if key == 'WonderBuiltType' then
                                if values[1] == 'MANMADE' then
                                    if plot:IsNaturalWonder() then
                                        isMatch = false
                                    end
                                elseif values[1] == 'NATURAL' then
                                    if not plot:IsNaturalWonder() then
                                        isMatch = false
                                    end
                                end
                            elseif key == 'Incomplete' then
                                if plot:IsWonderComplete() then
                                    isMatch = false
                                end
                            end
                        end
                    end
                    local wonderInfo = nil
                    if plot:IsNaturalWonder() then
                        wonderInfo = GameInfo.Features[plot:GetFeatureType()]
                    else
                        wonderInfo = GameInfo.Buildings[plot:GetWonderType()]
                    end
                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(wonderInfo, filters['GameInfo'])
                    end

                    if isMatch then
                        matchItemIndex = wonderInfo.Index
                    end
                end
                -- 地形
            elseif matchType == CalculationItemType.TERRAIN then
                matchItemIndex = plot:GetTerrainType() or -1
                local terrainInfo = GameInfo.Terrains[matchItemIndex]
                if terrainInfo then
                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(terrainInfo, filters['GameInfo'])
                    end
                end
                -- 地貌
            elseif matchType == CalculationItemType.FEATURE then
                matchItemIndex = plot:GetFeatureType() or -1
                local featureInfo = GameInfo.Terrains[matchItemIndex]
                if featureInfo then
                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(featureInfo, filters['GameInfo'])
                    end
                end
                -- 区域
            elseif matchType == CalculationItemType.DISTRICT then
                matchItemIndex = plot:GetDistrictType() or -1
                local districtInfo = GameInfo.Districts[matchItemIndex]
                local district = player:GetDistricts():FindID(plot:GetDistrictID())

                if districtInfo and district then
                    if filters['Custom'] then
                        local isComplete = filters['Custom']['IsComplete'][1]
                        if isComplete then
                            if tonumber(isComplete) == 1 and not district:IsComplete() then
                                isMatch = false
                            elseif tonumber(isComplete) == 0 and district:IsComplete() then
                                isMatch = false
                            end
                        end
                    else
                        if not district:IsComplete() then
                            isMatch = false
                        end
                    end

                    if filters['GameInfo'] then
                        isMatch = CheckItemIsMatchFilter(districtInfo, filters['GameInfo'])
                    end
                end
                -- 建筑
            elseif matchType == CalculationItemType.BUILDING then
                local pCity = Cities.GetPlotPurchaseCity(plot)
                if pCity then
                    local buildingTypes = GetBuildingTypes(pCity:GetBuildings(), plotIndex)
                    for _, buildingType in ipairs(buildingTypes) do
                        local buildingInfo = GameInfo.Buildings[buildingType]
                        if buildingInfo then
                            if filters['GameInfo'] then
                                isMatch = CheckItemIsMatchFilter(buildingInfo, filters['GameInfo'])
                            end
                            if isMatch then
                                local record = {}
                                for key, value in pairs(preMatchPlot) do
                                    record[key] = value
                                end
                                record[matchType] = buildingInfo.Index
                                table.insert(nextMatchPlots, record)
                            end
                        end
                    end
                    isMatch = false
                end
                -- 巨作（建筑）
            elseif matchType == CalculationItemType.GREAT_WORK then
                local plotGreatWorks = GetGreatWorksInPlot(plotIndex)
                for buildingIndex, greatWorks in pairs(plotGreatWorks) do
                    if preMatchPlot[CalculationItemType.BUILDING] then
                        if buildingIndex == preMatchPlot[CalculationItemType.BUILDING] then
                            for _, greatWorkInfo in ipairs(greatWorks) do
                                if filters['GameInfo'] then
                                    isMatch = CheckItemIsMatchFilter(greatWorkInfo, filters['GameInfo'])
                                end
                                if isMatch then
                                    local record = {}
                                    for key, value in pairs(preMatchPlot) do
                                        record[key] = value
                                    end
                                    record[CalculationItemType.GREAT_WORK] = greatWorkInfo.Index
                                    table.insert(nextMatchPlots, record)
                                end
                            end
                        end
                    else
                        for _, greatWorkInfo in ipairs(greatWorks) do
                            if filters['GameInfo'] then
                                isMatch = CheckItemIsMatchFilter(greatWorkInfo, filters['GameInfo'])
                            end
                            if isMatch then
                                local record = {}
                                for key, value in pairs(preMatchPlot) do
                                    record[key] = value
                                end
                                record[CalculationItemType.GREAT_WORK] = greatWorkInfo.Index
                                table.insert(nextMatchPlots, record)
                            end
                        end
                    end
                end
            elseif matchType == CalculationItemType.MOUNTAIN then
                if plot:IsMountain() then
                    isMatch = true
                    local record = {}
                    for key, value in pairs(preMatchPlot) do
                        record[key] = value
                    end
                    record[CalculationItemType.MOUNTAIN] = true
                    table.insert(nextMatchPlots, record)
                end
            elseif matchType == CalculationItemType.WATER then
                if plot:IsWater() then
                    isMatch = true
                    local record = {}
                    for key, value in pairs(preMatchPlot) do
                        record[key] = value
                    end
                    record[CalculationItemType.WATER] = true
                    table.insert(nextMatchPlots, record)
                end
            elseif matchType == CalculationItemType.SEA then
                -- print(territory, territory:IsSea(), IsPlotSea(plot))
                if IsPlotSea(plot) then
                    isMatch = true
                    local record = {}
                    for key, value in pairs(preMatchPlot) do
                        record[key] = value
                    end
                    record[CalculationItemType.SEA] = true
                    table.insert(nextMatchPlots, record)
                end

                -- GetTerritoryAt
            else
                return preMatchPlots
            end

            if matchItemIndex ~= -1 and isMatch then
                preMatchPlot[matchType] = matchItemIndex
                table.insert(nextMatchPlots, preMatchPlot)
            end
        end
    end

    -- if matchType == CalculationItemType.IMPROVEMENT then
    --     print('#nextMatchPlots = ', table.count(nextMatchPlots))
    -- end

    return nextMatchPlots
end

--- 获取匹配单元格数量
---@param filters table @过滤器
---@param preMatchItems table @预匹配单元格
---@param itemType number @匹配类型
---@param playerID number @玩家ID
function GetItemMatchPlotsCount(filters, preMatchItems, itemType, playerID)
    local matchItems = {}
    for _, preItem in ipairs(preMatchItems) do
        local plotID = preItem[CalculationItemType.PLOT]
        local plot = Map.GetPlotByIndex(plotID)
        -- 贸易站
        if itemType == CalculationItemType.TRADING_POST then
            local city = Cities.GetPlotPurchaseCity(preItem[CalculationItemType.PLOT])
            if city then
                local trade = city:GetTrade()
                if trade then
                    if trade:HasActiveTradingPost(playerID) then
                        matchItems[city:GetOwner() .. city:GetID()] = true
                    end
                end
            end
            -- 大陆
        elseif itemType == CalculationItemType.CONTINENT then
            local continentType = plot:GetContinentType()
            if continentType then
                if GameInfo.Continents[continentType] then
                    matchItems[continentType] = true
                end
            end
            -- 河流
        elseif itemType == CalculationItemType.RIVER then
            local riverNames = RiverManager.GetRiverName(plot)
            if plot:IsRiver() and riverNames then
                matchItems[riverNames] = true
            end
            -- 贸易城市
        elseif itemType == CalculationItemType.TRADE_C1TIES then
            local city = Cities.GetPlotPurchaseCity(preItem[CalculationItemType.PLOT])
            if city then
                matchItems[city:GetOwner() .. city:GetID()] = true
            end
            -- 贸易文明
        elseif itemType == CalculationItemType.TRADE_CIVILIZATIONS then
            local city = Cities.GetPlotPurchaseCity(preItem[CalculationItemType.PLOT])
            if city and city:GetOwner() ~= playerID then
                matchItems[city:GetOwner()] = true
            end
        end
    end
    return table.count(matchItems)
end

--- 限制匹配数量 采用比较方式
---@param oAmount integer
---@param dAmount integer
---@param filters table
---@param mutilpierType integer
---@param calculationType integer
---@return integer
function LimitMutilpierCompare(oAmount, dAmount, trmInstance)
    local mutilpier = 0
    local filters, mutilpierType, calculationType = trmInstance.Filters, trmInstance.MutilpierType,
        trmInstance.CalculationType
    if filters['CompareLimitByAmount'] then
        for key, value in pairs(filters['CompareLimitByAmount']) do
            if key == 'EACH_X_MORE' and oAmount > dAmount then
                mutilpier = math.floor((oAmount - dAmount) / tonumber(value[1])) * tonumber(value[2])
            end
            if key == 'EACH_MORE' and oAmount > dAmount then
                mutilpier = (oAmount - dAmount) * tonumber(value[1])
            end
            if key == 'MORE' and oAmount > dAmount then
                mutilpier = tonumber(value[1])
            end
            if key == 'EACH_X_LESS' and oAmount > dAmount then
                mutilpier = math.floor((dAmount - oAmount) / tonumber(value[1])) * tonumber(value[2])
            end
            if key == 'EACH_LESS' and oAmount < dAmount then
                mutilpier = (dAmount - oAmount) * tonumber(value[1])
            end
            if key == 'LESS' and oAmount < dAmount then
                mutilpier = tonumber(value[1])
            end
        end
    end
    return mutilpier > 0 and mutilpier or 0
end

---限制匹配数量
---@param filters table @根据LIMIT条件限制
---@param mutilpierType number
---@return number
function LimitMutilpier(amount, trmInstance)
    local mutilpier = amount

    local filters, mutilpierType, calculationType = trmInstance.Filters, trmInstance.MutilpierType,
        trmInstance.CalculationType

    -- print(filters, mutilpierType, calculationType, filters['TIME_LIMIT'])

    if filters['MutilpierLimitByAmount'] then
        for key, value in pairs(filters['MutilpierLimitByAmount']) do
            if key == 'AT_LEAST' and amount < tonumber(value[1]) then
                mutilpier = 0
            end
            if key == 'AT_MOST' and amount > tonumber(value[1]) then
                mutilpier = 0
            end
            if key == 'EQUAL' and amount ~= tonumber(value[1]) then
                mutilpier = 0
            end
        end
    end

    if mutilpierType == CalculationMultiplierType.EXIST then
        mutilpier = aORb(amount >= 1, 1, 0)
    end

    if mutilpierType == CalculationMultiplierType.TIME then
        mutilpier = 1
        if filters['TIME_LIMIT'] then
            for key, value in pairs(filters['TIME_LIMIT']) do
                -- 至少
                if key == 'AT_LEAST' and amount >= tonumber(value[1]) then
                    mutilpier = tonumber(value[2])
                end
                -- 至多
                if key == 'AT_MOST' and amount <= tonumber(value[1]) then
                    mutilpier = tonumber(value[2])
                end
                -- 相等
                if key == 'EQUAL' and amount ~= tonumber(value[1]) then
                    mutilpier = tonumber(value[2])
                end
                -- 每份
                if key == 'EACH_X' then
                    mutilpier = math.floor(amount / tonumber(value[1])) * tonumber(value[2])
                end

                if string.match(key, 'ERA_AGE') then
                    local playerID = trmInstance.OriginPlayerID
                    if string.match(key, 'DESTINATION_PLAYER') then
                        playerID = trmInstance.DestinationPlayerID
                    end
                    --  ExposedMembers.TRM.GetPlayerEraData
                    if table.count(value) < 4 then
                        print("ERROR: 错误FILTER %s", filters.FilterType)
                        return amount * 0
                    else
                        -- local m_TradeRouteModifierUpdater =
                        -- m_TradeRouteModifierUpdater[item][self.TradeRouteID] = true

                        -- setmetatable(trmInstance, TradeRouteModifierInstance)
                        -- trmInstance:SetUpdater
                        local eraData = ExposedMembers.TRM.GetPlayerEraData(playerID)
                        return amount *
                        tonumber(value[aORb(eraData ~= nil and eraData.EraType ~= nil, eraData.EraType, 1)])
                    end
                end
            end
        end
    end

    -- CalculationMultiplierType.EACH
    -- 不对mutilpier处理 直接return amount


    return mutilpier
end

---匹配对象GameInfo是否匹配过滤器GameInfo
---@param itemInfo table @Item GameInfo
---@param filterInfo table @Filter GameInfo
---@return boolean
function CheckItemIsMatchFilter(itemInfo, filterInfo)
    local isMatch = true
    for key, values in pairs(filterInfo) do
        if itemInfo[key] ~= nil then
            local temp = false
            for _, value in ipairs(values) do
                if tostring(itemInfo[key]) == value then
                    temp = true
                end
            end
            isMatch = temp
        end
    end
    return isMatch
end

---获取城市所有的贸易路线修改器指定加成
---@param pCity table
---@param yieldType string
---@return table
function GetCityTradeRouteModifierYield(pCity, yieldType)
    local cityTradeRouteModifierYields = pCity:GetProperty('CityYields') or {}
    local trmTotalYield = {}
    if cityTradeRouteModifierYields and next(cityTradeRouteModifierYields) then
        for _, modifierYields in pairs(cityTradeRouteModifierYields) do
            for _, cityYields in pairs(modifierYields) do
                for cityKey, yields in pairs(cityYields) do
                    if not trmTotalYield[cityKey] then
                        trmTotalYield[cityKey] = {}
                    end
                    for yield, amounts in pairs(yields) do
                        if yield == yieldType then
                            local baseAmount = amounts[1]
                            local mutilpierAmount = amounts[2]
                            if not trmTotalYield[cityKey][yield] then
                                trmTotalYield[cityKey] = {}
                                trmTotalYield[cityKey].BaseAmount = baseAmount
                                trmTotalYield[cityKey].MutilpierAmount = mutilpierAmount
                            else
                                trmTotalYield[cityKey].BaseAmount = trmTotalYield[cityKey].BaseAmount + baseAmount
                                trmTotalYield[cityKey].MutilpierAmount =
                                    trmTotalYield[cityKey].MutilpierAmount + mutilpierAmount
                            end
                        end
                    end
                end
            end
        end
    end
    return trmTotalYield
end

--- 获取城市所有的贸易路线修改器加成
---@param pCity table
function GetCityTradeRouteModifierYields(pCity, typeKey)
    if not typeKey then
        typeKey = 'CityYields'
    end
    local cityTradeRouteModifierYields = pCity:GetProperty(typeKey) or {}
    local trmTotalYields = {}
    if cityTradeRouteModifierYields and next(cityTradeRouteModifierYields) then
        for _, modifierYields in pairs(cityTradeRouteModifierYields) do
            for _, cityYields in pairs(modifierYields) do
                for cityKey, yields in pairs(cityYields) do
                    if not trmTotalYields[cityKey] then
                        trmTotalYields[cityKey] = {}
                    end
                    for yield, amounts in pairs(yields) do
                        local baseAmount = amounts[1]
                        local mutilpierAmount = amounts[2]
                        if not trmTotalYields[cityKey][yield] then
                            trmTotalYields[cityKey][yield] = {}
                            trmTotalYields[cityKey][yield].BaseAmount = baseAmount
                            trmTotalYields[cityKey][yield].MutilpierAmount = mutilpierAmount
                        else
                            trmTotalYields[cityKey][yield].BaseAmount =
                                trmTotalYields[cityKey][yield].BaseAmount + baseAmount
                            trmTotalYields[cityKey][yield].MutilpierAmount =
                                trmTotalYields[cityKey][yield].MutilpierAmount + mutilpierAmount
                        end
                    end
                end
            end
        end
    end
    return trmTotalYields
end

--- 根据贸易路线ID获取城市所有的贸易路线修改器加成
---@param pCity table
---@param tradeRouteID string @贸易路线ID
function GetCityTradeRouteModifierYieldByTradeRouteID(pCity, tradeRouteID, yieldType)
    local cityTradeRouteModifierYields = pCity:GetProperty('CityYields') or {}
    local trmTotalYield = {}
    if cityTradeRouteModifierYields and next(cityTradeRouteModifierYields) then
        for trID, modifierYields in pairs(cityTradeRouteModifierYields) do
            if trID == tradeRouteID then
                for _, cityYields in pairs(modifierYields) do
                    for cityKey, yields in pairs(cityYields) do
                        if not trmTotalYield[cityKey] then
                            trmTotalYield[cityKey] = {}
                        end
                        for yield, amounts in pairs(yields) do
                            if yield == yieldType then
                                local baseAmount = amounts[1]
                                local mutilpierAmount = amounts[2]
                                if not trmTotalYield[cityKey] then
                                    trmTotalYield[cityKey] = {}
                                    trmTotalYield[cityKey].BaseAmount = baseAmount
                                    trmTotalYield[cityKey].MutilpierAmount = mutilpierAmount
                                else
                                    trmTotalYield[cityKey].BaseAmount = trmTotalYield[cityKey].BaseAmount + baseAmount
                                    trmTotalYield[cityKey].MutilpierAmount =
                                        trmTotalYield[cityKey].MutilpierAmount + mutilpierAmount
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return trmTotalYield
end

--- 根据贸易路线ID获取城市所有的贸易路线修改器加成
---@param pCity table
---@param tradeRouteID string @贸易路线ID
function GetCityTradeRouteModifierYieldsByTradeRouteID(pCity, tradeRouteID, typeKey)
    if not typeKey then
        typeKey = 'CityYields'
    end
    local cityTradeRouteModifierYields = pCity:GetProperty('CityYields') or {}
    local trmTotalYields = {}
    if cityTradeRouteModifierYields and next(cityTradeRouteModifierYields) then
        for trID, modifierYields in pairs(cityTradeRouteModifierYields) do
            if trID == tradeRouteID then
                for _, cityYields in pairs(modifierYields) do
                    for cityKey, yields in pairs(cityYields) do
                        if not trmTotalYields[cityKey] then
                            trmTotalYields[cityKey] = {}
                        end
                        for yield, amounts in pairs(yields) do
                            local baseAmount = amounts[1]
                            local mutilpierAmount = amounts[2]
                            if not trmTotalYields[cityKey][yield] then
                                trmTotalYields[cityKey][yield] = {}
                                trmTotalYields[cityKey][yield].BaseAmount = baseAmount
                                trmTotalYields[cityKey][yield].MutilpierAmount = mutilpierAmount
                            else
                                trmTotalYields[cityKey][yield].BaseAmount =
                                    trmTotalYields[cityKey][yield].BaseAmount + baseAmount
                                trmTotalYields[cityKey][yield].MutilpierAmount =
                                    trmTotalYields[cityKey][yield].MutilpierAmount + mutilpierAmount
                            end
                        end
                    end
                end
            end
        end
    end
    return trmTotalYields
end

---获取贸易修改器参数
---@param trmID string @贸易修改器ID
---@return table @贸易修改器参数
function GetTradeRouteModifierArguments(trmID)
    local results = DB.Query("SELECT Name, Value from TRM_TradeRouteModifierArguments where TradeRouteModifier = ?",
        trmID)

    local arguments = {}
    if results then
        for _, row in ipairs(results) do
            arguments[row.Name] = row.Value
        end
    end
    return arguments
end

---获取贸易修改器目标要求
function GetTradeRouteModifierReqs(fString)
    local reqs = {}
    local filterList = SplitString(fString, ',')
    for _, filter in ipairs(filterList) do
        local results = DB.Query(
            "SELECT RequirementType, Name, Value, Inverse from TRM_TradeRouteModifierRequirements where Requirement = ?",
            filter)

        if results then
            for _, row in ipairs(results) do
                if not reqs[row.RequirementType] then
                    reqs[row.RequirementType] = {}
                end
                local values = SplitString(row.Value, ',')
                reqs[row.RequirementType][row.Name] = values
                -- print(row.Name, row.Value)
                reqs[row.RequirementType].Inverse = row.Inverse
                -- print('row.Inverse = ', reqs[row.RequirementType].Inverse, row.Inverse)
            end
        end
    end

    return reqs
end

---获取贸易修改器目标过滤器
---@param fString string @过滤器ID
---@return table @修改器
function GetTradeRouteModifierFilters(fString)
    local filters = {}
    local filterList = SplitString(fString, ',')
    for _, filter in ipairs(filterList) do
        local results = DB.Query("SELECT FilterType, Name, Value from TRM_TradeRouteModifierFilters where Filter = ?",
            filter)

        if results then
            for _, row in ipairs(results) do
                if not filters[row.FilterType] then
                    filters[row.FilterType] = {}
                end

                local values = SplitString(row.Value, ',')
                filters[row.FilterType][row.Name] = values
            end
        end
    end

    filters.FilterType = fString
    return filters
end

---获取基础加成
---@param arguments table @贸易修改器参数
---@return table @基础加成 [ ['YIELD_GOLD'] = 1, ... ]
function GetBaseYields(arguments)
    local yieldBaseAmounts = {}

    local yieldTypes = SplitString(arguments['YieldType'], ',')
    local amounts = SplitString(arguments['Amount'], ',')

    if (#yieldTypes ~= #amounts) and not #amounts == 1 then
        print("ERROR: 错误加成类型 %s, 或数量 %s", arguments['YieldType'], arguments['Amount'])
        return {}
    end

    if yieldTypes[1] == 'YIELD_ALL' or yieldTypes[1] == 'YIELD_ADJUST' then
        for row in GameInfo.Yields() do
            yieldBaseAmounts[row.YieldType] = tonumber(amounts[1])
        end
        return yieldBaseAmounts
    end

    for index, yield in ipairs(yieldTypes) do
        if not GameInfo.Yields[yield] then
            print("ERROR: 错误加成类型 %s", yield)
            return {}
        end
        if #amounts == 1 then
            yieldBaseAmounts[yield] = tonumber(amounts[1])
        else
            yieldBaseAmounts[yield] = tonumber(amounts[index])
        end
    end

    return yieldBaseAmounts
end

---获取玩家匹配贸易方向的贸易修改器
---@param playerID number @玩家ID
---@param direction number @贸易方向，0：双向|1：输出|2：输入
---@return table @[trmID, ...]
function GetTradeRouteModifiers(playerID, direction)
    local playerTTRMs = Game:GetProperty('PlayerTTRMs') or {}

    local tradeRouteModifiers = {}
    if playerTTRMs[playerID] ~= nil then
        for _, trm in ipairs(playerTTRMs[playerID]) do
            local trmInfo = GameInfo.TRM_TradeRouteModifier[trm]
            if trmInfo then
                if direction == -1 then
                    table.insert(tradeRouteModifiers, trmInfo)
                else
                    if (trmInfo.TradeRouteDirection == direction or trmInfo.TradeRouteDirection == 0) then
                        table.insert(tradeRouteModifiers, trmInfo)
                    end
                end
            end
        end
    end
    return tradeRouteModifiers
end

---获取玩家国际贸易路线额外加成
---@param playerID number @玩家ID
---@return table
function GetPlayerInternationalYieldMultipliers(playerID)
    local kYieldMultipliers = {}

    local player = Players[playerID]
    if not player then
        return kYieldMultipliers
    end
    local trade = player:GetTrade()

    if not player then
        return kYieldMultipliers
    end

    for row in GameInfo.Yields() do
        kYieldMultipliers[row.YieldType] = trade:GetInternationalYieldModifier(row.Index)
    end

    return kYieldMultipliers
end

---获取玩家绑定的所有的贸易修改器
---@param playerID number @玩家ID
---@return table
function GetPlayerTraitTradeRouteModifiers(playerID)
    local playerConfig = PlayerConfigurations[playerID]
    local civType = playerConfig:GetCivilizationTypeName()
    local leaderType = playerConfig:GetLeaderTypeName()

    local playerTraitTradeRouteModifiers = {}

    -- ==========================LEADER=======================
    function AddInheritedLeaders(leaders, leader)
        local inherit = leader.InheritFrom
        if (inherit ~= nil) then
            local parent = GameInfo.Leaders[inherit]
            if (parent) then
                table.insert(leaders, parent)
                AddInheritedLeaders(leaders, parent)
            end
        end
    end

    local base_leader = GameInfo.Leaders[leaderType]
    if base_leader ~= nil then
        local leaders = {}
        table.insert(leaders, base_leader)
        AddInheritedLeaders(leaders, base_leader)

        local has_leader = {}
        for i, leader in ipairs(leaders) do
            has_leader[leader.LeaderType] = true
        end
        for row in GameInfo.LeaderTraits() do
            if (has_leader[row.LeaderType] == true) then
                local trait = GameInfo.Traits[row.TraitType]
                if trait then
                    for ttrm in GameInfo.TRM_TraitTradeRouteModifier() do
                        if ttrm.TraitType == row.TraitType then
                            table.insert(playerTraitTradeRouteModifiers, ttrm.TradeRouteModifier)
                        end
                    end
                end
            end
        end
    end
    -- ==========================CIVILIZATION=======================
    for row in GameInfo.CivilizationTraits() do
        if (row.CivilizationType == civType) then
            for ttrm in GameInfo.TRM_TraitTradeRouteModifier() do
                if ttrm.TraitType == row.TraitType then
                    table.insert(playerTraitTradeRouteModifiers, ttrm.TradeRouteModifier)
                end
            end
        end
    end

    return playerTraitTradeRouteModifiers
end

---创建贸易修改器
---@param originOwnerID number
---@param originCityID number
---@param destOwnerID number
---@param destCityID number
---@param m_TradeRouteModifierManager table @Origin TradeRouteModifierManager
---@return table @Final TradeRouteModifierManager
function CreateTradeRouteModifier(originOwnerID, originCityID, destOwnerID, destCityID, m_TradeRouteModifierManager)
    local m_PlayerTradeRouteModifiers = Game:GetProperty('PlayerTradeRouteModifiers') or {}
    local tradeRouteID = table.concat({ originOwnerID, originCityID, destOwnerID, destCityID }, '-')
    local multipliers = { GetPlayerInternationalYieldMultipliers(originOwnerID),
        GetPlayerInternationalYieldMultipliers(destOwnerID) }
    local tradeRouthPath = { Game.GetTradeManager():GetTradeRoutePath(originOwnerID, originCityID, destOwnerID,
        destCityID) }

    local index = 0
    local playerNum = aORb(originOwnerID == destOwnerID, 1, 2)
    for i = 1, playerNum do
        local owner = originOwnerID
        if i == 2 then
            owner = destOwnerID
        end

        if m_PlayerTradeRouteModifiers[owner] then
            local trmInfos = m_PlayerTradeRouteModifiers[owner]

            if trmInfos then
                for _, trmInfo in ipairs(trmInfos) do
                    local rightDirection = trmInfo.TradeRouteDirection == i or trmInfo.TradeRouteDirection == 0
                    local rightSource = trmInfo.TradeRouteType == 0 or
                        (trmInfo.TradeRouteType == 1 and originOwnerID == destOwnerID) or
                        (trmInfo.TradeRouteType == 2 and originOwnerID ~= destOwnerID)

                    if (rightDirection and rightSource) then
                        local m_Instance = TradeRouteModifierInstance:new(originOwnerID, originCityID, destOwnerID,
                            destCityID, trmInfo, multipliers, tradeRouthPath, owner, index)

                        if m_Instance then
                            if not m_TradeRouteModifierManager[tradeRouteID] then
                                m_TradeRouteModifierManager[tradeRouteID] = {}
                            end
                            m_TradeRouteModifierManager[tradeRouteID][index] = m_Instance
                            index = index + 1
                        end
                    end
                end
            end
        end
    end
    return m_TradeRouteModifierManager
end

---获取玩家下属城邦数量
---@param majorPlayerID number
---@param filters table|nil
---@return table
function GetPlayerTributaryAmount(majorPlayerID, filters)
    local tAmount = 0

    local Tributarys = {}

    for _, playerID in ipairs(PlayerManager.GetAliveMinorIDs()) do
        local minorPlayer = Players[playerID]
        local minorPlayerInfluence = minorPlayer:GetInfluence()
        local isMatch = true
        if minorPlayerInfluence:GetSuzerain() ~= majorPlayerID then
            isMatch = false
        end

        local minorInfo = GetCityStateData(PlayerConfigurations[playerID]:GetCivilizationTypeName())
        if filters then
            if filters['GameInfo'] then
                isMatch = CheckItemIsMatchFilter(minorInfo, filters['GameInfo'])
            end
        end
        if isMatch and minorInfo.CityStateCategory then
            tAmount = tAmount + 1
            if not Tributarys[minorInfo.CityStateCategory] then
                Tributarys[minorInfo.CityStateCategory] = 0
            end
            Tributarys[minorInfo.CityStateCategory] = Tributarys[minorInfo.CityStateCategory] + 1
        end
    end

    return { tAmount, Tributarys }
end

--- 获取玩家资源数量
---@param playerID number
---@param filters table
---@param params table|nil
function GetPlayerResourceAmount(playerID, filters, params)
    local amount = 0
    local playerResources

    -- print('params = ', params)
    -- if params and params.PlayerResources then
    --     -- print('GetPlayerResourceAmount params.PlayerResources = ', params.PlayerResources)
    --     playerResources = deserialize(params.PlayerResources or '') or {}
    -- else
    --     playerResources = deserialize(Game:GetProperty('TRM_PLAYER_RESOURCES_' .. playerID) or '') or {}
    -- end
    playerResources = deserialize(ExposedMembers.TRM.GetPlayerResourcesData(playerID) or '')


    -- TRM_UIScript: 30	Icon	[ICON_RESOURCE_TOBACCO]
    -- TRM_UIScript: 30	IsLuxury	true
    -- TRM_UIScript: 30	IsBonus	false
    -- TRM_UIScript: 30	IsStrategic	false
    -- TRM_UIScript: 30	Total	2

    if filters and filters['GameInfo'] then
        for key, values in pairs(filters['GameInfo']) do
            for _, value in ipairs(values) do
                -- amount = amount + (playerResources[resourceType] or 0)
                for resourceType, p_resourceInfo in pairs(playerResources) do
                    local resourceInfo = GameInfo.Resources[resourceType]
                    if resourceInfo[key] and resourceInfo[key] == value then
                        amount = amount + p_resourceInfo.Total
                    end
                end
            end
        end
    end

    -- print('amount = ', amount, params)
    return amount
end

--- 获取宗教信徒数量
---@param pCity any
---@param filters any
function GetCityReligionFollowers(pCity, filters)
    if not pCity then
        return 0
    end

    local pReligions               = pCity:GetReligion():GetReligionsInCity();
    local eDominantReligion        = pCity:GetReligion():GetMajorityReligion();

    local followersAll             = 0
    local domainReligionFollowers  = 0
    local founderReligionFollowers = 0

    local religionFounders         = GetReligionFounders()
    for _, religionData in pairs(pReligions) do
        -- Religion	2
        -- Followers	3
        -- Pressure	500
        local religionType = (religionData.Religion > 0) and GameInfo.Religions[religionData.Religion].ReligionType or
            "RELIGION_PANTHEON";

        if religionData.Religion == eDominantReligion and eDominantReligion > -1 then
            domainReligionFollowers = religionData.Followers;
        end

        if religionFounders[religionData.Religion .. '_'] and religionFounders[religionData.Religion .. '_'] == pCity:GetOwner() then
            founderReligionFollowers = religionData.Followers;
        end

        if religionType ~= "RELIGION_PANTHEON" then
            followersAll = followersAll + religionData.Followers;
        end
    end

    if filters and filters['Custom'] then
        local followerType = filters['Custom']['CityReligionFollowersType'][1]
        if followerType == 'FOUNDER' then
            return founderReligionFollowers
        elseif followerType == 'DOMINANT' then
            return domainReligionFollowers
        end
    end

    return followersAll
end

---获取宗主国加成倍数
---@param gPlayerID any
---@param rPlayerID any
---@param tempMutilpier any
---@return number, boolean @倍数，是否为宗主国
function GetExtraMutilpierFromSuzerain(gPlayerID, rPlayerID, tempMutilpier)
    local rPlayer = GetMinorPlayerInTrade(gPlayerID, rPlayerID)
    if not rPlayer then
        return 0, false
    end
    local mutilpier = 0
    local rPlayerInfluence = rPlayer:GetInfluence()
    local isSuzerain = rPlayerInfluence:GetSuzerain() == gPlayerID
    if tempMutilpier and tonumber(tempMutilpier) then
        tempMutilpier = tonumber(tempMutilpier)
        if tempMutilpier == 0 then
            mutilpier = aORb(isSuzerain, 0, 1)
        elseif tempMutilpier == 1 then
            mutilpier = aORb(isSuzerain, 1, 0)
        else
            mutilpier = aORb(isSuzerain, tempMutilpier, 1)
        end
    end

    return mutilpier, isSuzerain
end

---获取使者数量
---@param gPlayerID number @主文明
---@param rPlayerID number @城邦
---@param filters table|nil @过滤器
---@return number|nil
function GetStateTokensReceived(gPlayerID, rPlayerID, filters)
    local rPlayer = GetMinorPlayerInTrade(gPlayerID, rPlayerID)
    if not rPlayer then
        return 0
    end
    local tAmount = 0
    local rPlayerInfluence = rPlayer:GetInfluence()
    if rPlayerInfluence then
        tAmount = rPlayerInfluence:GetTokensReceived(gPlayerID)
    end
    if filters and filters['GameInfo'] then
        local minorInfo = GetCityStateData(PlayerConfigurations[rPlayerID]:GetCivilizationTypeName())
        if not CheckItemIsMatchFilter(minorInfo, filters['GameInfo']) then
            tAmount = 0
        end
    end

    return tAmount
end

---获取玩家伟人点数
---@param playerID number
---@param filters table
function GetPlayerGreatPeoplePoints(playerID, filters)
    local player = Players[playerID]
    local greatPeoplePoints = player:GetGreatPeoplePoints()
    local pAmount = 0
    local classPoint = {}
    for row in GameInfo.GreatPersonClasses() do
        local isMatch = true
        if filters['GameInfo'] then
            isMatch = CheckItemIsMatchFilter(row, filters['GameInfo'])
        end
        if isMatch then
            local point = greatPeoplePoints:GetPointsTotal(row.Index)
            classPoint[row.GreatPersonClassType] = point
            pAmount = pAmount + point
        end
    end

    return pAmount, classPoint
end
