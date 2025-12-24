include('TRM_Constants')

-- ==========================
-- COMMON FUNCTIONS
-- ==========================

TableHelper = {}
TableHelper.__add = function(self, otherTable)
    if not type(otherTable) == 'table' then
        return self
    end

    for _, value in pairs(otherTable) do
        if value then
            table.insert(self, value)
        end
    end

    return self
end

--- 多重逻辑判断
---@param logicT table @逻辑列表
---@param _or boolean @是否或逻辑
---@return boolean @返回逻辑结果
function MutiLogic(logicT, _or)
    local res
    for _, value in ipairs(logicT) do
        if res == nil then
            res = value
        else
            if _or then
                res = res or value
            else
                res = res and value
            end
        end
    end

    return res
end

function GetPreciseDecimalRound(nNum, n)
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local format = "%." .. n .. "f"
    return string.format(format, nNum)
end

---保留小数
---@param nNum number @输入数值
---@param n number @保留的小数位数
---@return number
function GetPreciseDecimalFloor(nNum, n)
    if type(nNum) ~= "number" then
        return nNum
    end
    n = n or 0
    n = math.floor(n)
    if n < 0 then
        n = 0
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end

function RemoveByLengthEfficient(tbl, conditionFunc)
    local newTable = {}
    for _, item in ipairs(tbl) do
        if not conditionFunc(item) then
            table.insert(newTable, item)
        end
    end
    return newTable
end

--- 检测table是否包含元素
---@param pTable table
---@param element any
function Contains(pTable, element)
    for _, v in pairs(pTable) do
        if v == element then
            return true
        end
    end
    return false
end

--- table去重
---@param pTable table
function Unique(pTable)
    local temp = {}
    for key, val in pairs(pTable) do
        temp[val] = true
    end
    local result = {}
    for key, val in pairs(temp) do
        table.insert(result, key)
    end
    return result
end

---获取table长度
---@param pTable table|any
---@return number
function GetTableLength(pTable)
    if not type(pTable) == 'table' then
        return 0
    end

    local length = 0
    for _, value in pairs(pTable) do
        if value then
            length = length + 1
        end
    end

    return length
end

function RemoveByValue(array, value, removeadll)
    local i, max = 1, #array
    while i <= max do
        if array[i] == value then
            --    通过索引操作表的删除元素
            table.remove(array, i)
            --    标记删除次数
            i = i - 1
            --    控制while循环操作
            max = max - 1
            --    判断是否删除所有相同的value值
            if not removeadll then
                break
            end
        end
        i = i + 1
    end
end

---分割字符串
---@param str string @目标字符串
---@param reps string @分隔符
---@return table
function SplitString(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

---提取字符串数字（整数及小数）
---@param input string
---@return number
function ExtractNumbers(input)
    local numbers = {}             -- 用于存储提取的数字
    local pattern = "%-?%d+%.?%d*" -- 匹配整数和小数的正则表达式

    -- 遍历字符串中的所有匹配项
    for number in string.gmatch(input, pattern) do
        -- 将提取的字符串转换为数字并插入表中
        table.insert(numbers, tonumber(number))
    end

    if next(numbers) then
        return numbers[1]
    else
        return 0
    end
end

-- ==========================
-- GAME FUNCTIONS
-- ==========================

function GetReligionFounders()
    local religions = Game.GetReligion():GetReligions();

    -- CustomName	LOC_RELIGION_CATHOLICISM
    -- Religion	2
    -- Beliefs	table: 0000000105486DA0
    -- Founder	0
    local res = {}
    for _, religion in ipairs(religions) do
        res[religion.Religion .. '_'] = religion.Founder
    end

    return res
end

--- 获取城市贸易路线数量
---@param pCity any
---@param filters any
function GetCityTradeRouteCount(pCity, filters)
    if not pCity then
        return {}
    end

    local playerID = pCity:GetOwner()
    local cityID = pCity:GetID()

    local m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}
    local tradeRoutes = {}

    -- local tradeRouteID = table.concat({ originPlayerID, originCityID, targetPlayerID, targetCityID }, '-')
    for trmID, _ in pairs(m_TradeRouteModifierManager) do
        local tradeInfo = SplitString(trmID, '-')
        local originPlayerID = tonumber(tradeInfo[1])
        local originCityID = tonumber(tradeInfo[2])
        local targetPlayerID = tonumber(tradeInfo[3])
        local targetCityID = tonumber(tradeInfo[4])

        -- print('Trade Route Info:', originPlayerID, originCityID, targetPlayerID, targetCityID, playerID, cityID)

        if (originPlayerID == playerID and originCityID == cityID) or
            (targetPlayerID == playerID and targetCityID == cityID) then
            local isMatch = true
            if filters and filters['Custom'] then
                for key, values in pairs(filters['Custom']) do
                    if key == 'TradeType' then
                        if values[1] == 'ORIGINATION_INTERNATIONAL' then
                            isMatch = (originPlayerID == playerID and originCityID == cityID) and
                            originPlayerID ~= targetPlayerID
                        elseif values[1] == 'ORIGINATION_DOMESTIC' then
                            isMatch = (originPlayerID == playerID and originCityID == cityID) and
                            originPlayerID == targetPlayerID
                        elseif values[1] == 'DESTINATION_INTERNATIONAL' then
                            isMatch = (targetPlayerID == playerID and targetCityID == cityID) and
                            originPlayerID ~= targetPlayerID
                        elseif values[1] == 'DESTINATION_DOMESTIC' then
                            isMatch = (targetPlayerID == playerID and targetCityID == cityID) and
                            originPlayerID == targetPlayerID
                        end
                    end
                end
            end
            if isMatch then
                -- tradeRouteCount = tradeRouteCount + 1
                table.insert(tradeRoutes, trmID)
            end
        end
    end

    return tradeRoutes
end

--- 获取城市宗教信徒
---@param pCity table
---@param filters table
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

--- 获取玩家游戏参数
---@param playerID number @玩家ID
---@param key string @参数Key
function GetPlayerGameSummary(playerID, key)
    local cTurn = Game.GetCurrentGameTurn()

    for i = 0, GameSummary.GetDataSetCount() - 1, 1 do
        local name = GameSummary.GetDataSetName(i);
        if name == key then
            local gdata = GameSummary.CoalesceDataSet(i, cTurn, cTurn)
            if gdata then
                return gdata[playerID][1]
            else
                return 0
            end
        end
    end

    return 0
end

--- 获取玩家解锁科技数量
---@param playerID number @玩家ID
function GetPlayerUnlockTechCount(playerID)
    local player = Players[playerID]
    local techNums = 0
    for row in GameInfo.Technologies() do
        if player:GetTechs():HasTech(row.Index) then
            techNums = techNums + 1
        end
    end
    return techNums
end

function GetPlayerUnlockCivicCount(playerID)
    local player = Players[playerID]
    local civicNums = 0
    for row in GameInfo.Civics() do
        if player:GetCulture():HasCivic(row.Index) then
            civicNums = civicNums + 1
        end
    end
    return civicNums
end

---获取城邦GameInfo
---@param civType string
---@return table
function GetCityStateData(civType)
    -- Refresh the cache if needed
    local stateInfo = {}
    local query = "SELECT * from CityStates where CivilizationType = ?";
    local kResults = DB.ConfigurationQuery(query, civType);
    if (kResults) then
        for i, t in ipairs(kResults) do
            for key, value in pairs(t) do
                stateInfo[key] = value
            end
        end
    end
    return stateInfo
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

function CheckMinorPlayerInTrade(gPlayerID, rPlayerID)
    if Players[gPlayerID]:IsMajor() and not Players[rPlayerID]:IsMajor() then
        return Players[rPlayerID]
    elseif Players[rPlayerID]:IsMajor() and not Players[gPlayerID]:IsMajor() then
        return Players[gPlayerID]
    end
    return nil
end

---获取宗主国加成倍数
---@param gPlayerID any
---@param rPlayerID any
---@param tempMutilpier any
---@return number, boolean @倍数，是否为宗主国
function GetExtraMutilpierFromSuzerain(gPlayerID, rPlayerID, tempMutilpier)
    local rPlayer = CheckMinorPlayerInTrade(gPlayerID, rPlayerID)
    if not rPlayer then
        return 0, false
    end
    local mutilpier = 0
    local rPlayerInfluence = rPlayer:GetInfluence()
    local isSuzerain = rPlayerInfluence:GetSuzerain() == gPlayerID
    if tempMutilpier and tonumber(tempMutilpier) then
        tempMutilpier = tonumber(tempMutilpier)
        if tempMutilpier == 0 then
            mutilpier = isSuzerain and 0 or 1
        elseif tempMutilpier == 1 then
            mutilpier = not isSuzerain and 0 or 1
        else
            mutilpier = isSuzerain and tempMutilpier or 1
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
    local rPlayer = CheckMinorPlayerInTrade(gPlayerID, rPlayerID)
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

function GetPlayerRelationshipAmount(playerID, tPlayerID)
    local ms_SelectedPlayer = Players[tPlayerID]
    local selectedPlayerDiplomaticAI = ms_SelectedPlayer:GetDiplomaticAI()
    local toolTips = selectedPlayerDiplomaticAI:GetDiplomaticModifiers(playerID)
    local totalScore = 0

    if (toolTips) then
        table.sort(toolTips, function(a, b)
            return a.Score > b.Score;
        end)
        for i, tip in ipairs(toolTips) do
            local score = tip.Score

            if (score ~= 0) then
                totalScore = totalScore + score
            end
        end
    end

    return math.abs(totalScore)
end

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
            else
                return preMatchPlots
            end

            if matchItemIndex ~= -1 and isMatch then
                preMatchPlot[matchType] = matchItemIndex
                table.insert(nextMatchPlots, preMatchPlot)
            end
        end
    end

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
function LimitMutilpierCompare(oAmount, dAmount, filters, mutilpierType, calculationType)
    local mutilpier = 0
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
function LimitMutilpier(amount, filters, mutilpierType, calculationType)
    local mutilpier = amount

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
        mutilpier = amount >= 1 and 1 or 0
    end

    if mutilpierType == CalculationMultiplierType.TIME then
        mutilpier = 1
        if filters['TimeLimitByAmount'] then
            for key, value in pairs(filters['TimeLimitByAmount']) do
                -- 至少
                if key == 'AT_LEAST' and amount > tonumber(value[1]) then
                    mutilpier = tonumber(value[2])
                end
                -- 至多
                if key == 'AT_MOST' and amount < tonumber(value[1]) then
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

-- 获取玩家所有城市的单元格
function GetPlayerAllCityPlots(playerID)
    local cPlots = {}
    setmetatable(cPlots, TableHelper)
    local player = Players[playerID]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local cityPlots = GetCityPlots(playerID, city:GetID())
        cPlots = cPlots + cityPlots
    end
    return cPlots
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

function GetBuildingTypes(buildings, plotID)
    local buildingTypes = {}
    if buildings and buildings.GetBuildingsAtLocation then
        buildingTypes = buildings:GetBuildingsAtLocation(plotID)
    end
    return buildingTypes
end

--- 判断单元格是否有指定建筑
---@param buildingType any
---@param plotIndex any
function IsBuildingInPlot(buildingType, plotIndex)
    local plot = Map.GetPlotByIndex(plotIndex)
    if not plot then
        return false
    end

    local pCity = Cities.GetPlotPurchaseCity(plot)
    if not pCity then
        return false
    end

    local cityBuildings = pCity:GetBuildings();
    if (cityBuildings) then
        local buildingTypes = cityBuildings:GetBuildingsAtLocation(plotIndex);
        for _, type in ipairs(buildingTypes) do
            local building = GameInfo.Buildings[type];
            if building.BuildingType == buildingType then
                return true
            end
        end
    end
    return false
end

--- 获取城市内的所有巨作
---@param pCity table @城市
---@return table {buildingIndex: {greatWorkIndex, ...}, ...}
function GetGreatWorksInCity(pCity)
    local result = {};
    if pCity then
        local pCityBldgs = pCity:GetBuildings();
        for buildingInfo in GameInfo.Buildings() do
            local buildingIndex = buildingInfo.Index;
            if (pCityBldgs:HasBuilding(buildingIndex)) then
                local numSlots = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
                if (numSlots ~= nil and numSlots > 0) then
                    local greatWorksInBuilding = {};

                    -- populate great works
                    for index = 0, numSlots - 1 do
                        local greatWorkIndex = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
                        if greatWorkIndex ~= -1 then
                            table.insert(greatWorksInBuilding, greatWorkIndex);
                        end
                    end

                    -- create association between building type and great works
                    if table.count(greatWorksInBuilding) > 0 then
                        result[buildingIndex] = greatWorksInBuilding;
                    end
                end
            end
        end
    end
    return result;
end

--- 获取单元格内的所有巨作
---@param plotID any
---@return table {buildingType: {greatWorkInfo, ...}, ...}
function GetGreatWorksInPlot(plotID)
    local result = {}
    local plot = Map.GetPlotByIndex(plotID)
    if not plot then
        return result
    end

    local pCity = Cities.GetPlotPurchaseCity(plot)
    if not pCity then
        return result
    end

    if pCity then
        local pCityBldgs = pCity:GetBuildings();
        local plotBuildings = pCityBldgs:GetBuildingsAtLocation(plotID)
        for _, buildingType in ipairs(plotBuildings) do
            local buildingInfo = GameInfo.Buildings[buildingType]
            if buildingInfo then
                local buildingIndex = buildingInfo.Index;
                local numSlots = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
                if (numSlots ~= nil and numSlots > 0) then
                    local greatWorksInBuilding = {};

                    -- populate great works
                    for index = 0, numSlots - 1 do
                        local greatWorkIndex = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
                        if greatWorkIndex ~= -1 then
                            local greatWorkType = pCityBldgs:GetGreatWorkTypeFromIndex(greatWorkIndex);
                            table.insert(greatWorksInBuilding, GameInfo.GreatWorks[greatWorkType]);
                        end
                    end

                    -- create association between building type and great works
                    if table.count(greatWorksInBuilding) > 0 then
                        result[buildingType] = greatWorksInBuilding;
                    end
                end
            end
        end
    end

    return result
end

---获取城市单元格
---@param playerID number
---@param cityID number
---@return table @[plotIndex, ...]
function GetCityPlots(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)
    if city then
        return Map.GetCityPlots():GetPurchasedPlots(city)
    else
        return {}
    end
end

---获取领袖名（短）
---@param playerID number
---@param length number|nil
---@return string
function GetShortLeaderName(playerID, length)
    local shortLen = length ~= nil and length or 10
    local leaderName = Locale.Lookup(PlayerConfigurations[playerID]:GetLeaderName())
    if #leaderName > shortLen then
        leaderName = string.sub(leaderName, 1, shortLen - 1) .. '...'
    end

    return leaderName
end

---获取加成名称
---@param yieldType string @加成类型
---@return string
function GetYieldName(yieldType)
    return string.gsub(yieldType, YIELD_PREFIX, "")
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
function GetTradeRouteModifierReqss(fString)
    local reqs = {}
    local filterList = SplitString(fString, ',')
    for _, filter in ipairs(filterList) do
        local results = DB.Query(
            "SELECT RequirementType, Name, Value from TRM_TradeRouteModifierRequirements where Requirement = ?", filter)

        if results then
            for _, row in ipairs(results) do
                if not reqs[row.RequirementType] then
                    reqs[row.RequirementType] = {}
                end
                local values = SplitString(row.Value, ',')
                reqs[row.RequirementType][row.Name] = values
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
    for i = 1, 2 do
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

--- 为玩家解锁科技
---@param playerID integer
---@param techName string
function UnlockTech(playerID, techName)
    local playerTechs = Players[playerID]:GetTechs();
    local tech = GameInfo.Technologies[techName];
    if (tech ~= nil) then
        playerTechs:SetTech(tech.Index, true)
    end
end

--- 为玩家解锁市政
---@param playerID integer
---@param civicName string
function UnlockCivc(playerID, civicName)
    local playerCulture = Players[playerID]:GetCulture();
    local civic = GameInfo.Civics[civicName];
    if (civic ~= nil) then
        playerCulture:SetCivic(civic.Index, true);
    end
end
