include('TRM_Helper')
include('TRM_Constants')

function GetCalculationRange(calculationType)
    local range = CalculationRangeType.NULL
    for k, v in pairs(CalculationRangeType) do
        if string.find(calculationType, k) then
            range = v
        end
    end

    return range
end

--- 获取计算目标城市
---@param calculationTypeString string
function GetCalculationCityIndex(calculationTypeString)
    local cityIndex = -1
    if string.find(calculationTypeString, 'ORIGINATION') then
        cityIndex = 1
    elseif string.find(calculationTypeString, 'DESTINATION') then
        cityIndex = 2
    elseif string.find(calculationTypeString, 'ORIGIN_DESTI_NATION') then
        cityIndex = 0
    end

    return cityIndex
end

--- 获取计算倍数类型
---@param calculationTypeString any
function GetCalculationMutilpierType(calculationTypeString)
    local mutilpierType = CalculationMultiplierType.DEFAULT
    for k, v in pairs(CalculationMultiplierType) do
        if string.find(calculationTypeString, k) then
            mutilpierType = v
        end
    end

    return mutilpierType
end

--- 获取计算目标并排序
---@param calculationType any
function GetCalculationItemTypes(calculationType)
    local items = {}
    for k, v in pairs(CalculationItemType) do
        if string.find(calculationType, k) then
            table.insert(items, v)
        end
    end
    if table.count(items) >= 2 then
        table.sort(items, function(a, b)
            return a < b
        end)
    end
    return items
end

--- 检测计算类型是否有效
function CheckValidCalculationType(originPlayerID, originCityID, destinationPlayerID, destinationCityID,
                                   tradeRouteModifierInfo, owner)
    local isCreate = true
    local result = {}
    local arguments = GetTradeRouteModifierArguments(tradeRouteModifierInfo.TradeRouteModifier)
    local calculationType = arguments['CalculationType'] or 'DEFAULT'

    local function printErrorMsg(msg)
        print(string.format(msg, calculationType))
        isCreate = false
    end
    local ERROR_Range          = 'Error: %s 加成计算限定范围错误, Range'
    local ERROR_MultiplierType = 'Error: %s 加成计算方式错误, MultiplierType'
    local ERROR_Item           = 'Error: %s 加成计算限定对象错误, ItemTypes'
    local ERROR_YieldOrAmount  = 'Error: %s 未设置加成类型或数值, YieldType or Amount'
    local ERROR_Req            = 'Error: %s 未设置加成需求, Requirements'

    if not (arguments['YieldType'] and arguments['Amount']) then
        printErrorMsg(ERROR_YieldOrAmount)
    end

    local baseYields = GetBaseYields(arguments)
    if table.count(baseYields) == 0 then
        return nil
    end

    local filters = {}
    local reqs = {}

    if arguments then
        if arguments['Filter'] then
            filters = GetTradeRouteModifierFilters(arguments['Filter'])
        end
        if arguments['Requirements'] then
            reqs = GetTradeRouteModifierReqss(arguments['Requirements'])
        end
    end

    local check = true
    if reqs['Preload'] then
        for key, value in pairs(reqs['Preload']) do
            if key == 'CityIsNotOriginalOwner' then
                if value[1] == 'ANY' then
                    check = CityManager.GetCity(originPlayerID, originCityID):GetOriginalOwner() ~= owner or
                        CityManager.GetCity(destinationPlayerID, destinationCityID):GetOriginalOwner() ~= owner
                elseif value[1] == 'ALL' then
                    check = CityManager.GetCity(originPlayerID, originCityID):GetOriginalOwner() ~= owner and
                        CityManager.GetCity(destinationPlayerID, destinationCityID):GetOriginalOwner() ~= owner
                elseif value[1] == 'ORIGINATION' then
                    check = CityManager.GetCity(originPlayerID, originCityID):GetOriginalOwner() ~= owner
                elseif value[1] == 'DESTINATION' then
                    check = CityManager.GetCity(destinationPlayerID, destinationCityID) ~= owner
                else
                    printErrorMsg(ERROR_Req)
                end
            elseif key == 'DestinationPlayerType' then
                if value[1] == 'Minor' then
                    check = Players[destinationPlayerID]:IsMinor()
                elseif value[1] == 'Major' then
                    check = Players[destinationPlayerID]:IsMajor()
                elseif value[1] == 'AI' then
                    check = not Players[destinationPlayerID]:IsHuman()
                elseif value[1] == 'Human' then
                    check = Players[destinationPlayerID]:IsHuman()
                else
                    printErrorMsg(ERROR_Req)
                end
            end
        end
    end

    if not check then
        return nil
    end

    if calculationType == 'DEFAULT' then
        result.multiplierType = CalculationMultiplierType.DEFAULT
        result.baseYields = baseYields
        result.arguments = arguments
        result.filters = filters
        result.reqs = reqs

        return result
    end

    local rangeType = GetCalculationRange(calculationType)
    local cityIndex = GetCalculationCityIndex(calculationType)
    local multiplierType = GetCalculationMutilpierType(calculationType)
    local itemTypes = GetCalculationItemTypes(calculationType)

    if #itemTypes == 0 then
        printErrorMsg(ERROR_Item)
    end

    -- ===========RANGE TYPE===========
    if rangeType == CalculationRangeType.NULL then
        printErrorMsg(ERROR_Range)
    end

    if rangeType == CalculationRangeType.STATE and (cityIndex ~= 2 or Players[destinationPlayerID]:IsMajor()) then
        -- printErrorMsg(ERROR_Range)
        isCreate = false
    end

    if rangeType < CalculationRangeType.NEED_PLAYER_ID and cityIndex == -1 and multiplierType ~=
        CalculationMultiplierType.COMPARE then
        printErrorMsg(ERROR_Range)
    end

    if rangeType ~= CalculationRangeType.PLAYER and itemTypes[1] == CalculationItemType.TRIBUTARY then
        printErrorMsg(ERROR_Range)
    end

    -- ===========MUTIPLIER TYPE===========
    if multiplierType == CalculationMultiplierType.TIME then
        if not arguments['Filter'] then
            printErrorMsg(ERROR_MultiplierType)
        end
    elseif multiplierType == CalculationMultiplierType.COMPARE then
        if cityIndex ~= -1 or not arguments['Filter'] then
            printErrorMsg(ERROR_MultiplierType)
        end
    end

    -- ===========ITEM TYPE===========

    for _, itemType in ipairs(itemTypes) do
        if itemType > CalculationItemType.MATCH_PLOT_COUNT then
            if #itemTypes > 1 then
                printErrorMsg(ERROR_Item)
                return nil
            end
        end
    end

    result.arguments = arguments
    result.calculationType = calculationType
    result.rangeType = rangeType
    result.cityIndex = cityIndex
    result.multiplierType = multiplierType
    result.itemTypes = itemTypes
    result.baseYields = baseYields
    result.filters = filters
    result.reqs = reqs

    return isCreate and result or nil
end

-- ================================================
-- TradeRouteModifierInstance
-- ================================================

TradeRouteModifierInstance = {}
TradeRouteModifierInstance.__index = TradeRouteModifierInstance

---新建贸易修改器实例
---@param originPlayerID number @起始玩家ID
---@param originCityID number @起始城市ID
---@param destinationPlayerID number @终点玩家ID
---@param destinationCityID number @终点城市ID
---@param tradeRouteModifierInfo table @从数据库读取的修改器参数
---@param multipliers table @贸易玩家的国际贸易路线额外倍数加成
---@param tradeRoutePath table @贸易路线
---@param owner number @Modifier拥有者
---@param index number @同一贸易路线的实例序号
---@return table|nil @返回实例
function TradeRouteModifierInstance.new(self, originPlayerID, originCityID, destinationPlayerID, destinationCityID,
                                        tradeRouteModifierInfo, multipliers, tradeRoutePath, owner, index)
    local res = CheckValidCalculationType(originPlayerID, originCityID, destinationPlayerID, destinationCityID,
        tradeRouteModifierInfo, owner)

    if not res then
        return nil
    end

    local o = {}
    setmetatable(o, self)

    o:Initialize(originPlayerID, originCityID, destinationPlayerID, destinationCityID, tradeRouteModifierInfo,
        multipliers, tradeRoutePath, owner, index, res)

    return o
end

function TradeRouteModifierInstance.Initialize(self, originPlayerID, originCityID, destinationPlayerID,
                                               destinationCityID, tradeRouteModifierInfo, multipliers, tradeRoutePath,
                                               owner, index, calPack)
    self.OriginPlayerID = originPlayerID
    self.OriginCityID = originCityID
    self.DestinationPlayerID = destinationPlayerID
    self.DestinationCityID = destinationCityID
    self.TradeRouteDirection = tradeRouteModifierInfo.TradeRouteDirection
    self.BenefitCity = tradeRouteModifierInfo.BenefitCity
    self.TradeRouteModifier = tradeRouteModifierInfo.TradeRouteModifier
    self.Owner = owner
    self.Index = index
    self.InternationalMultipliers = multipliers
    self.TradeRoutePath = tradeRoutePath
    self.TradeRouteID = table.concat({ originPlayerID, originCityID, destinationPlayerID, destinationCityID }, '-')

    self.MutilpierType = calPack.multiplierType
    self.BaseYields = calPack.baseYields

    self.Yields = {}
    self.BenefitCities = {}
    self:InitializeBenefitCities()
    self.ModifierArguments = calPack.arguments

    self.Filters = calPack.filters
    self.Reqs = calPack.reqs

    self.CityPlots = { GetCityPlots(originPlayerID, originCityID), GetCityPlots(destinationPlayerID, destinationCityID) }
    self.CalculationType = calPack.calculationType
    self.Range = calPack.rangeType
    self.CityIndex = calPack.cityIndex
    self.Items = calPack.itemTypes

    self.ExtraInfo = {}
    self.Updater = {}

    -- if self.MutilpierType ~= CalculationMultiplierType.DEFAULT then
    --     self.CityPlots = { GetCityPlots(originPlayerID, originCityID), GetCityPlots(destinationPlayerID, destinationCityID) }
    --     self.CalculationType = calPack.calculationType
    --     self.Range = calPack.rangeType
    --     self.CityIndex = calPack.cityIndex
    --     self.Items = calPack.itemTypes

    --     self.ExtraInfo = {}
    --     self.Updater = {}
    -- end
    self:Calculate()

    -- print(self.TradeRouteModifier, ' - has created.')
end

-- 初始化受益城市
function TradeRouteModifierInstance.InitializeBenefitCities(self)
    self.BenefitCities = {}

    if self.BenefitCity == 0 then
        self.BenefitCities[1] = {}
        self.BenefitCities[2] = {}
    else
        self.BenefitCities[self.BenefitCity] = {}
    end
end

---获取贸易城市
---@param cityIndex number @1: 起始|2:终点
---@return table @指定城市
function TradeRouteModifierInstance.GetCity(self, cityIndex)
    if cityIndex == 1 then
        return CityManager.GetCity(self.OriginPlayerID, self.OriginCityID)
    else
        return CityManager.GetCity(self.DestinationPlayerID, self.DestinationCityID)
    end
end

-- =======================================
-- YIELD
-- =======================================

---项目类别文本
---@param itemTypes table
---@param filters table
---@return string @itemDescription
function GetItemTypeString(itemTypes, filters)
    local sortKey = 0
    local itemTypesString = ''
    for _, calculationItemType in ipairs(itemTypes) do
        local itemDes = ''
        -- ===============类别图标===============
        itemDes = DescriptionIcon[calculationItemType] .. itemDes

        -- ===============类别名称===============
        itemDes = itemDes .. Locale.Lookup(CalculationItemName[calculationItemType])
        -- ===============自定义字符串===============
        if calculationItemType == CalculationItemType.RESOURCE then
            if filters['Custom'] and filters['Custom']['IsImproved'] then
                local isImproved = tonumber(filters['Custom']['IsImproved']) == 1
                if isImproved then
                    itemDes = itemDes .. '[COLOR_MEDIUM_GREEN]' .. Locale.Lookup('LOC_HUD_REPORTS_WORKED_TILES') ..
                        '[ENDCOLOR]'
                else
                    itemDes = itemDes .. '[COLOR_Civ6DarkRed]' .. Locale.Lookup('LOC_WORLDBUILDER_NO_IMPROVEMENT') ..
                        '[ENDCOLOR]'
                end
            end
        elseif calculationItemType == CalculationItemType.WONDER then
            if filters['Custom'] and filters['Custom']['WonderBuiltType'] then
                local wonderBuiltType = filters['Custom']['WonderBuiltType'][1]
                if wonderBuiltType == 'MANMADE' then
                    itemDes = '人造' .. itemDes
                elseif wonderBuiltType == 'NATURAL' then
                    itemDes = '自然' .. itemDes
                elseif wonderBuiltType == 'Incomplete' then
                    itemDes = '未完成' .. itemDes
                end
            end
        end
        -- ===============多类别排序===============
        if calculationItemType > sortKey then
            sortKey = calculationItemType
            itemTypesString = itemDes .. itemTypesString
        else
            itemTypesString = itemTypesString .. itemDes
        end
    end

    return itemTypesString
end

---收益来源文本
---@return string @sourceDescription
function TradeRouteModifierInstance.GetYieldDescriptionSource(self)
    local startDescription = ''

    if self.MutilpierType == CalculationMultiplierType.COMPARE then
        local compareStr = ''
        if self.Filters['CompareLimitByAmount'] then
            for key, _ in pairs(self.Filters['CompareLimitByAmount']) do
                if string.find(key, 'MORE') then
                    compareStr = '多于'
                elseif string.find(key, 'EQUAL') then
                    compareStr = '等于'
                else
                    compareStr = '小于'
                end
            end
        end

        if self.Range == CalculationRangeType.CITY then
            startDescription = string.format('<%s>[COLOR_Civ6DarkRed]%s[ENDCOLOR]<%s>',
                Locale.Lookup(self:GetCity(1):GetName()), compareStr, Locale.Lookup(self:GetCity(2):GetName()))
        elseif self.Range == CalculationRangeType.CITIES or self.Range == CalculationRangeType.PLAYER then
            local leaderName1 = Locale.ToUpper(Locale.Lookup(PlayerConfigurations[self.OriginPlayerID]:GetLeaderName()))
            local leaderName2 = Locale.ToUpper(Locale.Lookup(
                PlayerConfigurations[self.DestinationPlayerID]:GetLeaderName()))
            startDescription = string.format('<%s>[COLOR_Civ6DarkRed]%s[ENDCOLOR]<%s>', leaderName1, compareStr,
                leaderName2)
        end
        return startDescription
    end

    -- ================来源/范围================
    if self.Range == CalculationRangeType.CITY then
        if self.CityIndex ~= 0 then
            local city = self:GetCity(self.CityIndex)
            local cityName = Locale.Lookup(city:GetName())
            startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. cityName .. '[ENDCOLOR]'
        else
            local city1 = self:GetCity(1)
            local city2 = self:GetCity(2)
            local cityName1 = Locale.Lookup(city1:GetName())
            local cityName2 = Locale.Lookup(city2:GetName())
            startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. cityName1 .. '/' .. cityName2 ..
                '[ENDCOLOR]'
        end
    elseif self.Range == CalculationRangeType.CITIES or self.Range == CalculationRangeType.PLAYER then
        if self.CityIndex ~= 0 then
            local leaderName = Locale.ToUpper(Locale.Lookup(PlayerConfigurations[self.OriginPlayerID]:GetLeaderName()))
            startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. leaderName .. '[ENDCOLOR]'
        else
            if self.OriginPlayerID ~= self.DestinationPlayerID then
                local leaderName1 = Locale.ToUpper(Locale.Lookup(
                    PlayerConfigurations[self.OriginPlayerID]:GetLeaderName()))
                local leaderName2 = Locale.ToUpper(Locale.Lookup(
                    PlayerConfigurations[self.DestinationPlayerID]:GetLeaderName()))
                startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. leaderName1 .. ' / ' .. leaderName2 ..
                    '[ENDCOLOR]'
            else
                local leaderName = Locale.ToUpper(Locale.Lookup(
                    PlayerConfigurations[self:GetCity(self.CityIndex):GetOwner()]:GetLeaderName()))
                startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. leaderName .. '[ENDCOLOR]'
            end
        end
    elseif self.Range == CalculationRangeType.TRADE_ROUTE_PATH then
        startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. Locale.Lookup('LOC_TOP_PANEL_TRADE_ROUTES') ..
            '[ENDCOLOR]'
    end

    -- ================特殊来源/范围================
    if self.Items[1] == CalculationItemType.ENVOY then
        local city = self:GetCity(2)
        local cityName = Locale.Lookup(city:GetName())
        startDescription = startDescription .. '[COLOR_Civ6DarkRed]' .. cityName .. '[ENDCOLOR]'
    end

    return startDescription
end

-- 设置收益文本
---@param locText string @文本Tag
---@param ... string | number @额外参数
function TradeRouteModifierInstance.SetDescription(self, locText, ...)
    -- local leaderName = GetShortLeaderName(self.Owner)
    for cityKey, _ in pairs(self.BenefitCities) do
        for yieldType, yieldInfo in pairs(self.Yields[cityKey]) do
            yieldInfo.Description = Locale.Lookup(locText, yieldInfo.Amount, GameInfo.Yields[yieldType].IconString,
                -- Locale.Lookup(GameInfo.Yields[yieldType].Name), ...) .. string.format('<%s>', leaderName)
                Locale.Lookup(GameInfo.Yields[yieldType].Name), ...)
        end
    end
end

--- 添加额外倍数加成
---@param finalBaseYieldMultiplier number @基础加成倍数
function TradeRouteModifierInstance.AddExtraMultiplier(self, finalBaseYieldMultiplier)
    if self.Filters and self.Filters['ExtraMutilpier'] then
        -- 1. 宗主加成
        if self.Filters['ExtraMutilpier']['Suzerain'] then
            -- 宗主加成倍数
            local tempMutilpier = tonumber(self.Filters['ExtraMutilpier']['Suzerain'][1])
            -- 判断是否为宗主，获取加成倍数
            local suzerainMutilpier, isSuzerain = GetExtraMutilpierFromSuzerain(self.OriginPlayerID,
                self.DestinationPlayerID, tempMutilpier)
            finalBaseYieldMultiplier = finalBaseYieldMultiplier * suzerainMutilpier
            self.ExtraInfo.IsSuzerain = isSuzerain

            -- print(tempMutilpier, self.Filters['ExtraMutilpier']['Suzerain'], self.TradeRouteModifier,
            --     ' - SuzerainMutilpier:', suzerainMutilpier, ' - IsSuzerain:', isSuzerain)
        end
    end


    return finalBaseYieldMultiplier
end

-- 计算最终收益
---@param yieldMultiplier number @加成倍数
function TradeRouteModifierInstance.GetFinalYields(self, yieldMultiplier)
    yieldMultiplier = self:AddExtraMultiplier(yieldMultiplier)

    for cityKey, _ in pairs(self.BenefitCities) do
        local finalYields = {}
        local internationalMultiplier = nil
        if self.OriginPlayerID ~= self.DestinationPlayerID then
            internationalMultiplier = self.InternationalMultipliers[cityKey]
        end
        for yield, baseAmount in pairs(self.BaseYields) do
            local multiplierAmount = yieldMultiplier * baseAmount
            if multiplierAmount ~= 0 then
                finalYields[yield] = {
                    Amount = multiplierAmount
                }
                if internationalMultiplier and internationalMultiplier[yield] ~= 1 then
                    finalYields[yield].Multiplier = tonumber(
                        string.format('%0.1f', multiplierAmount * (internationalMultiplier[yield] - 1)))
                end
            else
                finalYields[yield] = nil
            end
        end
        self.Yields[cityKey] = finalYields
    end
end

-- 默认加成
function TradeRouteModifierInstance.CalculateDefault(self)
    self:GetFinalYields(1)
    self:SetDescription('LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES')
end

-- =======================================
-- MATCH PLOTS
-- =======================================

---获取匹配所有项目的单元格
---@return table @匹配的单元格数组
function TradeRouteModifierInstance.GetMatchItemsPlot(self, cityIndex)
    local nextMatchItems = {}
    if cityIndex == -1 then
        if self.Range == CalculationRangeType.TRADE_ROUTE_PATH then
            nextMatchItems = GetMatchPlots(self.TradeRoutePath[1])
            for _, cItem in ipairs(self.Items) do
                nextMatchItems = GetItemMatchPlots(self.Filters, cItem, nextMatchItems, self.OriginPlayerID)
            end
        end
    elseif cityIndex == 0 then
        if self.Range == CalculationRangeType.CITY then
            for i = 1, 2 do
                local playerID = i == 1 and self.OriginPlayerID or self.DestinationPlayerID
                local tempNextMatchItems = GetMatchPlots(self.CityPlots[i])

                if self.Filters['Custom'] then
                    for key, values in pairs(self.Filters['Custom']) do
                        -- 距离市中心单元格范围
                        if key == 'CityCenterDistanceRange' then
                            local x, y = -1, -1
                            if values[1] == 'ORIGINATION' then
                                x = self:GetCity(1):GetX()
                                y = self:GetCity(1):GetY()
                            elseif values[1] == 'DESTINATION' then
                                x = self:GetCity(2):GetX()
                                y = self:GetCity(2):GetY()
                            end
                            if x ~= -1 and y ~= -1 then
                                local tempPlots = {}
                                for _, matchItem in ipairs(tempNextMatchItems) do
                                    local plotIndex = matchItem[CalculationItemType.PLOT]
                                    local plot = Map.GetPlotByIndex(plotIndex)
                                    if plot then
                                        local distance = GetPlotDistance(plot:GetX(), plot:GetY(), x, y)
                                        if distance >= tonumber(values[2]) and distance <= tonumber(values[3]) then
                                            table.insert(tempPlots, matchItem)
                                        end
                                    end
                                end
                                tempNextMatchItems = tempPlots
                            end
                        end
                    end
                end

                for _, cItem in ipairs(self.Items) do
                    tempNextMatchItems = GetItemMatchPlots(self.Filters, cItem, nextMatchItems, playerID)
                end

                setmetatable(nextMatchItems, TableHelper)
                nextMatchItems = nextMatchItems + tempNextMatchItems
            end
        elseif self.Range == CalculationRangeType.CITIES or self.Range == CalculationRangeType.PLAYER then
            local playerCount = self.OriginPlayerID == self.DestinationPlayerID and 1 or 2
            for i = 1, playerCount do
                local playerID = i == 1 and self.OriginPlayerID or self.DestinationPlayerID
                local tempNextMatchItems = {}

                for _, pCity in Players[playerID]:GetCities():Members() do
                    local tNextMatchItems = GetMatchPlots(GetCityPlots(playerID, pCity:GetID()))

                    for _, cItem in ipairs(self.Items) do
                        tempNextMatchItems = GetItemMatchPlots(self.Filters, cItem, tempNextMatchItems, playerID)
                    end
                    setmetatable(tempNextMatchItems, TableHelper)
                    tempNextMatchItems = tempNextMatchItems + tNextMatchItems
                end
                setmetatable(nextMatchItems, TableHelper)
                nextMatchItems = nextMatchItems + tempNextMatchItems
            end
        elseif self.Range == CalculationRangeType.TRADE_ROUTE_PATH then
            for i = 1, 2 do
                local playerID = i == 1 and self.OriginPlayerID or self.DestinationPlayerID
                local tempNextMatchItems = GetPlayerMatchPlots(self.TradeRoutePath[1], playerID)

                for _, cItem in ipairs(self.Items) do
                    tempNextMatchItems = GetItemMatchPlots(self.Filters, cItem, tempNextMatchItems, playerID)
                end

                setmetatable(nextMatchItems, TableHelper)
                nextMatchItems = nextMatchItems + tempNextMatchItems
            end
        end
    else
        local playerID = cityIndex == 1 and self.OriginPlayerID or self.DestinationPlayerID
        if self.Range == CalculationRangeType.CITY then
            nextMatchItems = GetMatchPlots(self.CityPlots[cityIndex])
            for _, cItem in ipairs(self.Items) do
                nextMatchItems = GetItemMatchPlots(self.Filters, cItem, nextMatchItems, playerID)
            end
        elseif self.Range == CalculationRangeType.CITIES or self.Range == CalculationRangeType.PLAYER then
            for _, pCity in Players[playerID]:GetCities():Members() do
                local tempNextMatchItems = GetMatchPlots(GetCityPlots(playerID, pCity:GetID()))
                for _, cItem in ipairs(self.Items) do
                    tempNextMatchItems = GetItemMatchPlots(self.Filters, cItem, tempNextMatchItems, playerID)
                end
                setmetatable(nextMatchItems, TableHelper)
                nextMatchItems = nextMatchItems + tempNextMatchItems
            end
        elseif self.Range == CalculationRangeType.TRADE_ROUTE_PATH then
            nextMatchItems = GetPlayerMatchPlots(self.TradeRoutePath[1], playerID)
            for _, cItem in ipairs(self.Items) do
                nextMatchItems = GetItemMatchPlots(self.Filters, cItem, nextMatchItems, playerID)
            end
        end
    end
    return nextMatchItems
end

---获取收益文本:通过匹配单元格
---@return string
function TradeRouteModifierInstance.GetYieldDescriptionByMatchPlots(self, amount)
    local itemDescription = ''

    if self.MutilpierType == CalculationMultiplierType.EXIST then
        itemDescription = itemDescription .. string.format('存在的' .. GetItemTypeString(self.Items, self.Filters))
    else
        itemDescription = itemDescription ..
            string.format('的%s*%d', GetItemTypeString(self.Items, self.Filters), amount)
    end

    return itemDescription
end

-- =======================================
-- MATCH ITEM AMOUNT
-- =======================================

---获取匹配项目的数量
---@return integer
function TradeRouteModifierInstance.GetItemYieldMultiplier(self, cityIndex)
    local yieldMultiplier = 0
    local cItem = self.Items[1]
    local tradePathPlots = GetMatchPlots(self.TradeRoutePath[1])

    local function GetCityYieldMutilpier(_city, _cItem)
        if _cItem == CalculationItemType.POPULATION then
            yieldMultiplier = yieldMultiplier + _city:GetPopulation()
        elseif _cItem == CalculationItemType.AMENITY then
            yieldMultiplier = yieldMultiplier + _city:GetGrowth():GetAmenities()
        elseif _cItem == CalculationItemType.FOLLOWER_OF_RELIGION then
            yieldMultiplier = yieldMultiplier + GetCityReligionFollowers(_city, self.Filters)
        end
    end

    local function GetYieldMutilpier(pID)
        if self.Range == CalculationRangeType.CITY then
            GetCityYieldMutilpier(self:GetCity(cityIndex), cItem)
        elseif self.Range == CalculationRangeType.CITIES then
            local player = Players[pID]
            local cities = player:GetCities()
            for _, pCity in cities:Members() do
                GetCityYieldMutilpier(pCity, cItem)
            end
        elseif self.Range == CalculationRangeType.PLAYER then
            local pPlayer = Players[pID]
            if cItem == CalculationItemType.POPULATION then
                for _, pCity in pPlayer:GetCities():Members() do
                    yieldMultiplier = yieldMultiplier + pCity:GetPopulation()
                end
            elseif cItem == CalculationItemType.GREAT_PEOPLE_POINT then
                local pointAmount, classPoint = GetPlayerGreatPeoplePoints(pID, self.Filters)
                self.ExtraInfo.GreatPersonPoints = classPoint
                yieldMultiplier = yieldMultiplier + pointAmount
            elseif cItem == CalculationItemType.TRIBUTARY then
                local res = GetPlayerTributaryAmount(pID, self.Filters)
                if res then
                    local amount, tInfos = unpack(res)
                    self.ExtraInfo.TributaryInfos = tInfos
                    yieldMultiplier = yieldMultiplier + amount
                end
            elseif cItem == CalculationItemType.RELATIONSHIP then
                yieldMultiplier = yieldMultiplier +
                    GetPlayerRelationshipAmount(self.OriginPlayerID, self.DestinationPlayerID)
            elseif cItem == CalculationItemType.UNLOCK_TECH then
                yieldMultiplier = yieldMultiplier + GetPlayerUnlockTechCount(pID)
            elseif cItem == CalculationItemType.UNLOCK_CIVIC then
                yieldMultiplier = yieldMultiplier + GetPlayerUnlockCivicCount(pID)
            end
        elseif self.Range == CalculationRangeType.TRADE_ROUTE_PATH then
            if cItem > CalculationItemType.MATCH_PLOT_COUNT and cItem < CalculationItemType.SPEC1AL_DATA then
                yieldMultiplier = yieldMultiplier + GetItemMatchPlotsCount(self.Filters, tradePathPlots, cItem, pID)
            end
        else
            if cItem == CalculationItemType.ENVOY then
                local tAmount = GetStateTokensReceived(self.OriginPlayerID, self.DestinationPlayerID, self.Filters)
                yieldMultiplier = yieldMultiplier + tAmount
                self.ExtraInfo.TokenAmount = tAmount
            end
        end
    end

    if cityIndex ~= 0 then
        local playerID = cityIndex == 1 and self.OriginPlayerID or self.DestinationPlayerID
        GetYieldMutilpier(playerID)
    else
        for i = 1, 2 do
            local playerID = i == 1 and self.OriginPlayerID or self.DestinationPlayerID
            GetYieldMutilpier(playerID)
        end
    end

    return yieldMultiplier
end

---获取收益文本:通过项目数量
---@param amount integer @项目数量
function TradeRouteModifierInstance.GetYieldDescriptionByItems(self, amount)
    local calculationItemType = self.Items[1]
    local itemDescription = ''
    if self.MutilpierType == CalculationMultiplierType.EXIST then
        itemDescription = '存在的'
    else
        itemDescription = '的'
    end

    local itemIcon = DescriptionIcon[calculationItemType]
    local itemName = Locale.Lookup(CalculationItemName[calculationItemType])

    if self.MutilpierType == CalculationMultiplierType.COMPARE then
        return itemIcon .. itemName .. '*' .. amount
    end

    -- ===============自定义字符串===============
    if calculationItemType == CalculationItemType.ENVOY then
        if self.ExtraInfo and self.ExtraInfo.TokenAmount then
            itemDescription = itemDescription .. itemIcon .. itemName .. '*' .. self.ExtraInfo.TokenAmount
        else
            itemDescription = itemDescription .. itemIcon .. itemName .. '*' .. amount
        end
    elseif calculationItemType == CalculationItemType.TRIBUTARY then
        if self.Filters['GameInfo'] and self.Filters['GameInfo']['CityStateCategory'] then
            for cityStateCategory, _amount in pairs(self.ExtraInfo.TributaryInfos) do
                if itemDescription ~= '的' then
                    itemDescription = '、' .. itemDescription
                end
                itemDescription = itemDescription .. itemIcon .. '下属' ..
                    Locale.Lookup(string.format('LOC_MINOR_CIV_%s_TRAIT_NAME', cityStateCategory)) ..
                    '*' .. _amount
            end
        else
            itemDescription = itemDescription .. itemIcon .. itemName .. '*' .. amount
        end
    elseif calculationItemType == CalculationItemType.GREAT_PEOPLE_POINT then
        if self.Filters['GameInfo'] and self.Filters['GameInfo']['GreatPersonClassType'] then
            for classType, _amount in pairs(self.ExtraInfo.GreatPersonPoints) do
                if itemDescription ~= '的' then
                    itemDescription = '、' .. itemDescription
                end
                itemDescription = itemDescription .. GameInfo.GreatPersonClasses[classType].IconString ..
                    Locale.Lookup(string.format('LOC_%s_NAME', classType)) .. '点数' .. '*' ..
                    _amount
            end
        else
            itemDescription = itemDescription .. itemIcon .. itemName .. '*' .. amount
        end
    else
        itemDescription = itemDescription .. itemIcon .. itemName .. '*' .. amount
    end

    if self.ExtraInfo.IsSuzerain then
        itemDescription = itemDescription .. '[COLOR_MEDIUM_GREEN]<宗主>[ENDCOLOR]'
    end

    return itemDescription
end

-- =======================================
-- MATCH PLAYER COUNTER
-- =======================================

function TradeRouteModifierInstance.GetCounterYieldMultiplier(self, cityIndex)
    local yieldMultiplier = 0
    local counterItem = self.Items[1]
    local function GetCounterYieldMutilpier(pID)
        if counterItem == CalculationItemType.UNITS_KILLED then
            yieldMultiplier = yieldMultiplier + GetPlayerGameSummary(pID, 'REPLAYDATASET_TOTALUNITSDESTROYED')
        elseif counterItem == CalculationItemType.FOUNDED_NATURAL_W0NDERS then
            local foundedNWonder = PlayerConfigurations[pID]:GetValue('FOUNDED_NATURAL_W0NDERS') or 0
            yieldMultiplier = yieldMultiplier + foundedNWonder
        elseif counterItem == CalculationItemType.TRADE_ROUTE then

        end
    end

    if cityIndex ~= 0 then
        local playerID = cityIndex == 1 and self.OriginPlayerID or self.DestinationPlayerID
        GetCounterYieldMutilpier(playerID)
    else
        for i = 1, 2 do
            local playerID = i == 1 and self.OriginPlayerID or self.DestinationPlayerID
            GetCounterYieldMutilpier(playerID)
        end
    end

    return yieldMultiplier
end

function TradeRouteModifierInstance.GetYieldDescriptionByCounter(self, itemAmount)
    local counterItem = self.Items[1]
    local itemDescription = '的'
    local itemIcon = DescriptionIcon[counterItem]
    local itemName = Locale.Lookup(CalculationItemName[counterItem])
    return itemDescription .. itemIcon .. itemName .. '*' .. itemAmount
end

-- =======================================
-- UI，Calculate Yields|Add Updter
-- =======================================

function TradeRouteModifierInstance.CalculateCompare(self)
    local yieldMultiplier = 0
    local itemDescription = ''
    self.CityPlots = { GetCityPlots(self.OriginPlayerID, self.OriginCityID),
        GetCityPlots(self.DestinationPlayerID, self.DestinationCityID) }

    if self.Items[1] < CalculationItemType.MATCH_PLOT_COUNT then
        local o_MatchPlots = self:GetMatchItemsPlot(1)
        local d_MatchPlots = self:GetMatchItemsPlot(2)
        yieldMultiplier = LimitMutilpierCompare(#o_MatchPlots, #d_MatchPlots, self.Filters, self.MutilpierType,
            self.CalculationType)
        itemDescription = self:GetYieldDescriptionByMatchPlots(math.abs(#o_MatchPlots - #d_MatchPlots))
    elseif self.Items[1] > CalculationItemType.COUNTERS then
        local oAmount = self:GetCounterYieldMultiplier(1)
        local dAmount = self:GetCounterYieldMultiplier(2)
        yieldMultiplier =
            LimitMutilpierCompare(oAmount, dAmount, self.Filters, self.MutilpierType, self.CalculationType)
        itemDescription = self:GetYieldDescriptionByCounter(math.abs(oAmount - dAmount))
    else
        local oAmount = self:GetItemYieldMultiplier(1)
        local dAmount = self:GetItemYieldMultiplier(2)
        yieldMultiplier =
            LimitMutilpierCompare(oAmount, dAmount, self.Filters, self.MutilpierType, self.CalculationType)
        itemDescription = self:GetYieldDescriptionByItems(math.abs(oAmount - dAmount))
    end

    self:GetFinalYields(yieldMultiplier)

    if yieldMultiplier > 0 then
        if IsChinese then
            local sourceDescription = self:GetYieldDescriptionSource()
            self:SetDescription('LOC_CALCULATION_DESCRIPTION', sourceDescription .. itemDescription)
        else
            self:SetDescription('LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES')
        end
    end
end

function TradeRouteModifierInstance.CheckReqs(self)
    local check = true
    if self.Reqs['Onload'] then
        local _or = false
        for key, value in pairs(self.Reqs['Onload']) do
            _or = value[1] == 'OR' -- 逻辑关系
            local checkRes = {}

            if key == 'DestinationCityRelationship' then
                if self.OriginPlayerID == self.DestinationPlayerID then
                    return false
                end
                local op, dp = Players[self.OriginPlayerID], Players[self.DestinationPlayerID]
                local diplomacy = op:GetDiplomacy()
                if not diplomacy then
                    return false
                end

                for _, relationship in ipairs(value) do
                    if relationship == 'Ally' then
                        local allianceType = diplomacy:GetAllianceType(self.DestinationPlayerID)
                        table.insert(checkRes, allianceType ~= -1)
                    elseif relationship == 'Suzerain' then
                        if not dp:IsMinor() then
                            table.insert(checkRes, false)
                        else
                            local minorPlayerInfluence = dp:GetInfluence()
                            table.insert(checkRes, minorPlayerInfluence:GetSuzerain() == self.OriginPlayerID)
                        end
                    end
                end
                check = MutiLogic(checkRes, _or)
                -- elseif key == 'CityReligionFollowersType' then
                --     local city = self:GetCity(self.CityIndex)
                --     if not city then
                --         return false
                --     end
                --     local religion = city:GetReligion()
                --     local cityReligion = religion:GetMajorityReligion()
                --     for _, rType in ipairs(value) do
                --         table.insert(checkRes, cityReligion == GameInfo.Religions[rType].Index)
                --     end
                --     check = tempCheck
            end
        end
    end

    return check
end

-- 计算总加值
function TradeRouteModifierInstance.Calculate(self)
    if not self:CheckReqs() then
        return
    end

    if self.MutilpierType == CalculationMultiplierType.DEFAULT then
        self:CalculateDefault()
    elseif self.MutilpierType == CalculationMultiplierType.COMPARE then
        self:CalculateCompare()
    else
        local yieldMultiplier = 1
        local itemDescription = ''
        self.CityPlots = { GetCityPlots(self.OriginPlayerID, self.OriginCityID),
            GetCityPlots(self.DestinationPlayerID, self.DestinationCityID) }

        if self.Items[1] < CalculationItemType.MATCH_PLOT_COUNT then
            local matchPlots = self:GetMatchItemsPlot(self.CityIndex)
            yieldMultiplier = LimitMutilpier(#matchPlots, self.Filters, self.MutilpierType, self.CalculationType)
            if self.ModifierArguments['ItemDes'] and Locale.HasTextKey(self.ModifierArguments['ItemDes']) then
                itemDescription = Locale.Lookup(self.ModifierArguments['ItemDes'], #matchPlots)
            else
                itemDescription = self:GetYieldDescriptionByMatchPlots(#matchPlots)
            end
        elseif self.Items[1] > CalculationItemType.COUNTERS then
            local itemAmount = self:GetCounterYieldMultiplier(self.CityIndex)
            yieldMultiplier = LimitMutilpier(itemAmount, self.Filters, self.MutilpierType, self.CalculationType)
            if self.ModifierArguments['ItemDes'] and Locale.HasTextKey(self.ModifierArguments['ItemDes']) then
                itemDescription = Locale.Lookup(self.ModifierArguments['ItemDes'], itemAmount)
            else
                itemDescription = self:GetYieldDescriptionByCounter(itemAmount)
            end
        else
            local itemAmount = self:GetItemYieldMultiplier(self.CityIndex)
            yieldMultiplier = LimitMutilpier(itemAmount, self.Filters, self.MutilpierType, self.CalculationType)
            if self.ModifierArguments['ItemDes'] and Locale.HasTextKey(self.ModifierArguments['ItemDes']) then
                itemDescription = Locale.Lookup(self.ModifierArguments['ItemDes'], itemAmount)
            else
                itemDescription = self:GetYieldDescriptionByItems(itemAmount)
            end
        end

        self:GetFinalYields(yieldMultiplier)

        if yieldMultiplier > 0 then
            if IsChinese then
                local sourceDescription = self:GetYieldDescriptionSource()
                self:SetDescription('LOC_CALCULATION_DESCRIPTION', sourceDescription .. itemDescription)
            else
                self:SetDescription('LOC_ROUTECHOOSER_YIELD_SOURCE_BONUSES')
            end
        end
    end
end

-- 设置更新
function TradeRouteModifierInstance.SetUpdater(self, m_TradeRouteModifierUpdater)
    self.Updater = {}
    if self.MutilpierType ~= CalculationMultiplierType.DEFAULT then
        for _, item in ipairs(self.Items) do
            self.Updater[item] = true
        end
        if self.Filters['Custom'] then
            if self.Updater[CalculationItemType.RESOURCE] and self.Filters['Custom']['IsImproved'] then
                self.Updater[CalculationItemType.IMPROVEMENT] = true
            end
        end

        for item, _ in pairs(self.Updater) do
            if not m_TradeRouteModifierUpdater[item] then
                m_TradeRouteModifierUpdater[item] = {}
            end
            m_TradeRouteModifierUpdater[item][self.TradeRouteID] = true
        end
    end

    return m_TradeRouteModifierUpdater
end

-- =======================================
-- Gameplay，Attach|Detach Modifiers
-- =======================================

-- 应用修改器
function TradeRouteModifierInstance.Apply(self)
    self:InitializeBenefitCities()
    for cityKey, _ in pairs(self.BenefitCities) do
        local bCity = self:GetCity(cityKey)

        if bCity and self.Yields[cityKey] then
            local modifierID = self.TradeRouteModifier .. self.Index

            local cityYields = bCity:GetProperty('CityYields') or {}
            local cityYieldsDecimal = bCity:GetProperty('CityYieldsDecimal') or {}

            if not cityYields[self.TradeRouteID] then
                cityYields[self.TradeRouteID] = {}
            end
            cityYields[self.TradeRouteID][modifierID] = {}
            cityYields[self.TradeRouteID][modifierID][cityKey] = {}

            if not cityYieldsDecimal[self.TradeRouteID] then
                cityYieldsDecimal[self.TradeRouteID] = {}
            end
            cityYieldsDecimal[self.TradeRouteID][modifierID] = {}
            cityYieldsDecimal[self.TradeRouteID][modifierID][cityKey] = {}

            for yieldType, yieldInfo in pairs(self.Yields[cityKey]) do
                local totalAmount = yieldInfo.Amount + (yieldInfo.Multiplier or 0)
                local amountInteger, amountDecimal = math.modf(totalAmount)
                cityYields[self.TradeRouteID][modifierID][cityKey][yieldType] = { yieldInfo.Amount,
                    yieldInfo.Multiplier or 0 }
                cityYieldsDecimal[self.TradeRouteID][modifierID][cityKey][yieldType] = { amountDecimal, 0 }

                while amountInteger > 0 do
                    local amount = math.min(amountInteger, MODIFIER_MAX)
                    local modifier = MODIFIER_OUT_GOING:format(yieldType, amount)
                    if cityKey == 2 then
                        modifier = MODIFIER_IN_COMING:format(yieldType, amount)
                    end
                    bCity:AttachModifierByID(modifier)
                    table.insert(self.BenefitCities[cityKey], modifier)
                    amountInteger = amountInteger - amount
                end
            end
            bCity:SetProperty('CityYields', cityYields)
            bCity:SetProperty('CityYieldsDecimal', cityYieldsDecimal)
        end
    end
end

-- 移除修改器
function TradeRouteModifierInstance.Remove(self)
    for cityKey, modifierStrings in pairs(self.BenefitCities) do
        local bCity = self:GetCity(cityKey)
        if bCity ~= nil then
            for _, modifierString in ipairs(modifierStrings) do
                bCity:DetachModifierByID(modifierString)
            end

            local cityYields = bCity:GetProperty('CityYields') or {}
            local modifierID = self.TradeRouteModifier .. self.Index
            for traderouteID, value in pairs(cityYields) do
                if traderouteID == self.TradeRouteID then
                    cityYields[traderouteID][modifierID] = nil
                end
            end
            bCity:SetProperty('CityYields', cityYields)
        end
    end
end
