include('TRM_Helper')
include('TRM_Constants')
include('TRM_TradeRouteModifierInstance')

GameEvents                        = ExposedMembers.GameEvents;
-- ============================================
-- PRE DATA READING
-- ============================================

-- ============================================
--	VARIABLES
-- ============================================
local m_TradeRouteModifierManager = {}
local m_TradeRouteModifierUpdater = {}

local m_DataSetIndexes            = {}
-- ============================================
-- FUNCTIONS
-- ============================================


---执行Gameplay环境下的修改器行为
---@param tradeRouteIDs table
---@param operationType number
function ExecuteTradeRouteInstanceOperation(tradeRouteIDs, operationType)
    local kParameters = {}
    kParameters.OnStart = "TradeRouteModifierExecuteOperation"
    kParameters.TradeRouteIDs = tradeRouteIDs
    kParameters.OperationType = operationType

    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}

    for _, tradeRouteID in ipairs(tradeRouteIDs) do
        if m_TradeRouteModifierManager[tradeRouteID] then
            for index, instance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
                setmetatable(instance, TradeRouteModifierInstance)
                instance:Calculate()
                if operationType == TRM_OperationType.APPLY then
                    m_TradeRouteModifierUpdater = instance:SetUpdater(m_TradeRouteModifierUpdater)
                elseif operationType == TRM_OperationType.DESTROY then
                    for _, updateType in ipairs(instance.Updater) do
                        if m_TradeRouteModifierUpdater[updateType] then
                            m_TradeRouteModifierUpdater[updateType][tradeRouteID] = nil
                        end
                    end
                end
            end
        end
    end

    GameEvents.SetGameProperty.Call('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

-- 判断是否为新建贸易路线
function IsNewTradeRouteCreated(originPlayerID, originCityID, targetPlayerID,
                                targetCityID)
    -- Retrieve origin and destination cities
    local originCity = CityManager.GetCity(originPlayerID, originCityID)
    local destinationCity = CityManager.GetCity(targetPlayerID, targetCityID)

    -- Check if both cities exist
    if not originCity or not destinationCity then
        return false
    end

    -- Retrieve trade data for the destination city
    local cityTrade = originCity:GetTrade()
    if not cityTrade then
        return false
    end

    -- Get incoming trade routes
    local outgoingRoutes = cityTrade:GetOutgoingRoutes()
    if not outgoingRoutes or #outgoingRoutes == 0 then
        return false
    end

    -- Check each incoming route for a match
    for _, route in ipairs(outgoingRoutes) do
        if route.OriginCityPlayer == originPlayerID and route.OriginCityID == originCityID and
            route.DestinationCityPlayer == targetPlayerID and route.DestinationCityID == targetCityID then
            print(Locale.Lookup('LOC_NEW_TRADE_ROUTE_CREATED', Locale.Lookup(originCity:GetName()),
                Locale.Lookup(destinationCity:GetName())))
            return true
        end
    end

    -- No matching route found
    return false
end

-- 初始化所有贸易路线修改器
function InitializeTradeRouteModifiers()
    print('m_TradeRouteModifierManager = ', m_TradeRouteModifierManager, #m_TradeRouteModifierManager)

    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local cities = player:GetCities()
        for _, city in cities:Members() do
            local cityTrade = city:GetTrade()
            if cityTrade then
                local outgoingRoutes = cityTrade:GetOutgoingRoutes()
                for _, route in ipairs(outgoingRoutes) do
                    local tradeRouteID = table.concat(
                        { route.OriginCityPlayer, route.OriginCityID, route.DestinationCityPlayer, route
                            .DestinationCityID },
                        '-')
                    m_TradeRouteModifierManager = CreateTradeRouteModifier(route.OriginCityPlayer, route.OriginCityID,
                        route.DestinationCityPlayer, route.DestinationCityID, m_TradeRouteModifierManager)
                end
            end
        end
    end

    for _, instances in pairs(m_TradeRouteModifierManager) do
        for _, instance in pairs(instances) do
            setmetatable(instance, TradeRouteModifierInstance)
            m_TradeRouteModifierUpdater = instance:SetUpdater(m_TradeRouteModifierUpdater)
        end
    end

    GameEvents.SetGameProperty.Call('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)

    local kParameters = {}
    kParameters.OnStart = "ApplyAllTRMs"
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

-- =========================================================================
--	GAMEPLAY UPDATER
-- =========================================================================

---更新修改器
---@param updaterType number
---@param params table|nil
function UpdateTradeRouteModifier(updaterType, params)
    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}

    if not m_TradeRouteModifierUpdater[updaterType] then
        return
    end

    local updatedTradeRoutes = {}
    for tradeRouteID, _ in pairs(m_TradeRouteModifierUpdater[updaterType]) do
        if not m_TradeRouteModifierManager[tradeRouteID] then
            return
        end

        for _, trmInstance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
            setmetatable(trmInstance, TradeRouteModifierInstance)
            if trmInstance.Updater[updaterType] then
                local update = true
                if params and type(params) == 'table' then
                    local p = params.p
                    local c = params.c
                    local op = params.op
                    local oc = params.oc
                    local dp = params.dp
                    local dc = params.dc
                    local info = params.info

                    if p and (trmInstance.OriginPlayerID ~= p and trmInstance.DestinationPlayerID ~= p) then
                        update = false
                    end

                    if c and (trmInstance.OriginCityID ~= c and trmInstance.DestinationCityID ~= c) then
                        update = false
                    end

                    if (op and trmInstance.OriginPlayerID ~= op) or (oc and trmInstance.OriginCityID ~= oc) or (dp and trmInstance.DestinationPlayerID ~= dp) or (dc and trmInstance.DestinationCityID ~= dc) then
                        update = false
                    end


                    if info then
                        if trmInstance.Filters['GameInfo'] and not CheckItemIsMatchFilter(info, trmInstance.Filters['GameInfo']) then
                            update = false
                        end
                    end
                end
                if update then
                    trmInstance:Calculate()
                    updatedTradeRoutes[tradeRouteID] = true
                end
            end
        end
    end

    GameEvents.SetGameProperty.Call('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)
    local updatedTradeRouteIDs = {}
    for routeID, _ in pairs(updatedTradeRoutes) do
        table.insert(updatedTradeRouteIDs, routeID)
    end
    ExecuteTradeRouteInstanceOperation(updatedTradeRouteIDs, TRM_OperationType.UPDATE)
end

function UpdaterRegister()
    Events.CityTileOwnershipChanged.Add(function(playerID, cityID)
        local params = {}
        params.p = playerID
        params.c = cityID
        UpdateTradeRouteModifier(CalculationItemType.RESOURCE, params)
        UpdateTradeRouteModifier(CalculationItemType.TERRAIN, params)
        UpdateTradeRouteModifier(CalculationItemType.FEATURE, params)
        UpdateTradeRouteModifier(CalculationItemType.PLOT, params)
    end)

    Events.DistrictBuildProgressChanged.Add(function(playerID, districtID, cityID, X, Y, districtIndex, era,
                                                     civilizationIndex, percentComplete, appeal, isPillaged)
        if percentComplete == 100 then
            local params = {}
            params.p = playerID
            params.info = GameInfo.Districts[districtIndex]
            UpdateTradeRouteModifier(CalculationItemType.DISTRICT, params)
        end
    end)

    Events.DistrictRemovedFromMap.Add(function(playerID, districtID, cityID, X, Y, districtIndex)
        local params = {}
        params.p = playerID
        params.info = GameInfo.Districts[districtIndex]
        UpdateTradeRouteModifier(CalculationItemType.DISTRICT, params)
    end)

    -- 人口变更
    Events.CityPopulationChanged.Add(function(playerID, cityID, cityPopulation)
        local params = {}
        params.p     = playerID
        params.c     = cityID
        UpdateTradeRouteModifier(CalculationItemType.POPULATION, params)
    end)

    Events.ImprovementAddedToMap.Add(function(X, Y, improvementIndex, playerID)
        local params = {}
        params.p = playerID
        params.info = GameInfo.Improvements[improvementIndex]
        UpdateTradeRouteModifier(CalculationItemType.IMPROVEMENT, params)
    end)
    Events.ImprovementRemovedFromMap.Add(function(X, Y, playerID)
        local params = {}
        params.p = playerID
        UpdateTradeRouteModifier(CalculationItemType.IMPROVEMENT, params)
    end)

    Events.WonderCompleted.Add(function()
        UpdateTradeRouteModifier(CalculationItemType.WONDER)
    end)

    Events.GreatPeoplePointsChanged.Add(function(playerID)
        local params = {}
        params.p = playerID
        UpdateTradeRouteModifier(CalculationItemType.GREAT_PEOPLE_POINT, params)
    end)

    Events.LocalPlayerTurnEnd.Add(function()
    end)

    Events.InfluenceGiven.Add(function(minorId, majorId)
        local params = {}
        params.dp = minorId
        UpdateTradeRouteModifier(CalculationItemType.ENVOY, params)
    end)

    Events.CityWorkerChanged.Add(function(ownerPlayerID, cityID, X, Y)
        local params = {}
        params.p = ownerPlayerID
        params.c = cityID
        UpdateTradeRouteModifier(CalculationItemType.GREAT_WORK, params)
    end)

    Events.GreatWorkMoved.Add(function(fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID,
                                       greatWorkTypeIndex)
        UpdateTradeRouteModifier(CalculationItemType.GREAT_WORK)
    end)

    Events.NotificationAdded.Add(function(playerID, notificationID)
        local pNotification = NotificationManager.Find(playerID, notificationID)

        if pNotification:GetTypeName() == 'NOTIFICATION_TRADING_POST_CREATED' then
            local params = {}
            params.p = playerID
            UpdateTradeRouteModifier(CalculationItemType.TRADING_POST, params)
        elseif pNotification:GetTypeName() == 'NOTIFICATION_DISCOVER_NATURAL_WONDER' then
            local params = {}
            params.p = playerID
            local foundedNWonder = PlayerConfigurations[playerID]:GetValue('FOUNDED_NATURAL_W0NDERS') or 0
            foundedNWonder = foundedNWonder + 1
            PlayerConfigurations[playerID]:SetValue('FOUNDED_NATURAL_W0NDERS', foundedNWonder)
            UpdateTradeRouteModifier(CalculationItemType.FOUNDED_NATURAL_W0NDERS, params)
        end
    end)

    Events.UnitKilledInCombat.Add(function(killedPlayerID, killedUnitID, playerID, unitID)
        local params = {}
        params.p = playerID
        UpdateTradeRouteModifier(CalculationItemType.UNITS_KILLED, params)
    end)

    -- 解锁科技
    Events.ResearchCompleted.Add(function(playerID, technologyIndex)
        local params = {}
        params.p = playerID
        params.info = GameInfo.Technologies[technologyIndex]
        UpdateTradeRouteModifier(CalculationItemType.UNLOCK_TECH, params)
        -- print('Tech Completed: ', playerID, technologyIndex)
    end)

    -- 解锁市政
    Events.CivicCompleted.Add(function(playerID, civicIndex)
        local params = {}
        params.p = playerID
        params.info = GameInfo.Civics[civicIndex]
        UpdateTradeRouteModifier(CalculationItemType.UNLOCK_CIVIC, params)
        -- print('Civic Completed: ', playerID, civicIndex)
    end)

    --  宗教变更
    Events.CityReligionChanged.Add(function(playerID, cityID, eVisibility, otherCityID)
        local params = {}
        params.p = playerID
        params.c = cityID
        UpdateTradeRouteModifier(CalculationItemType.FOLLOWER_OF_RELIGION, params)
    end)

    -- 宗教信徒变更
    Events.CityReligionFollowersChanged.Add(function(playerID, cityID, eVisibility, influencingCItyID)
        local params = {}
        params.p = playerID
        params.c = cityID
        UpdateTradeRouteModifier(CalculationItemType.FOLLOWER_OF_RELIGION, params)
    end)
end

-- ============================================
-- GAME CORE EVENTS
-- ============================================

-- 贸易路线活动变更事件
function OnTradeRouteActivityChanged(playerID, originPlayerID, originCityID, targetPlayerID, targetCityID)
    local isNewRoute = IsNewTradeRouteCreated(originPlayerID, originCityID,
        targetPlayerID, targetCityID)

    local tradeRouteID = table.concat({ originPlayerID, originCityID, targetPlayerID, targetCityID }, '-')
    ExecuteTradeRouteInstanceOperation({ tradeRouteID },
        isNewRoute and TRM_OperationType.APPLY or TRM_OperationType.DESTROY)

    -- print('On OnTradeRouteActivityChanged.....')
end

function InitGameSummarySets()
    for i = 0, GameSummary.GetDataSetCount() - 1, 1 do
        local name = GameSummary.GetDataSetName(i)
        if name then
            m_DataSetIndexes[name] = i
        end
    end

    GameEvents.SetGameProperty.Call('DataSetIndexes', m_DataSetIndexes)
end

function Initialize()
    InitGameSummarySets()

    Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
    UpdaterRegister()

    InitializeTradeRouteModifiers()
end

Events.LoadGameViewStateDone.Add(Initialize)
