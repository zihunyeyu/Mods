include("CitySupport");
include("Civ6Common");
include("SupportFunctions");

include('TRM_Helper')
include('TTK_ToolkitsCore')

include('TRM_Constants')
include('TRM_TradeRouteModifierInstance')


GameEvents = ExposedMembers.GameEvents
-- ============================================
-- PRE DATA READING
-- ============================================

-- For anyone interested in what order the Turn events are called, it goes like this:

-- OnGameTurnStarted (turn#)
-- TurnBegin

-- -- Human player --
-- LocalPlayerTurnBegin
-- PlayerTurnStarted (playerID=0)
-- PlayerTurnStartComplete (playerID=0)
-- PlayerTurnActivated (playerID,=0, blsFirstTime=true)
-- LocalPlayerTurnEnd
-- PlayerTurnDeactivated (playerID=0)

-- -- computer player 1 --
-- PlayerTurnStarted (playerID=1)
-- PlayerTurnStartComplete(playerID=1)
-- PlayerTurnActivated(playerID=1,blsFirstTime=true)
-- PlayerTurnDeactivated(playerID=1)

-- -- [other computer players like above...] --

-- -- free cities --
-- PlayerTurnStarted (playerID=62)
-- PlayerTurnStartComplete (playerID=62)
-- PlayerTurnActivated (playerID=62,blsFirstTime=true)
-- PlayerTurnDeactivated(playerID=62)

-- -- barbarians --
-- PlayerTurnStarted(playerID=63)
-- PlayerTurnStartComplete(playerID=63)
-- PlayerTurnActivated(playerID=63, blsFirstTime=true)
-- PlayerTurnDeactivated(playerID=63)


-- TurnEnd

-- ============================================
--	VARIABLES
-- ============================================
local m_TradeRouteModifierManager = {}
local m_TradeRouteModifierUpdater = {}

local m_DataSetIndexes            = {}



-- ============================================
-- FUNCTIONS
-- ============================================

function GetPlayerEraData(playerID)
    local gameEras = Game.GetEras()

    local data = {
        EraType = 1,
        EraScore = gameEras:GetPlayerCurrentScore(playerID)
    }

    if gameEras:HasHeroicGoldenAge(playerID) then
        data.EraType = GAME_ERA.HeroicGoldenAge
    elseif gameEras:HasGoldenAge(playerID) then
        data.EraType = GAME_ERA.GoldenAge
    elseif gameEras:HasDarkAge(playerID) then
        data.EraType = GAME_ERA.DarkAge
    else
        data.EraType = GAME_ERA.Normal
    end

    return data
end

function GetCityResourceData(pCity)
    -- Loop through all the plots for a given city tallying the resource amount.
    local kResources = {}
    local cityPlots  = Map.GetCityPlots():GetPurchasedPlots(pCity)
    for _, plotID in ipairs(cityPlots) do
        local plot          = Map.GetPlotByIndex(plotID)
        local plotX         = plot:GetX()
        local plotY         = plot:GetY()
        local eResourceType = plot:GetResourceType()

        -- TODO: Account for trade/diplomacy resources.
        if eResourceType ~= -1 and Players[pCity:GetOwner()]:GetResources():IsResourceExtractableAt(plot) then
            if kResources[eResourceType] == nil then
                kResources[eResourceType] = 1
            else
                kResources[eResourceType] = kResources[eResourceType] + 1
            end
        end
    end
    return kResources
end

function AddMiscResourceData(pResourceData, kResourceTable)
    -- Resources not yet accounted for come from other gameplay bonuses
    if pResourceData then
        for row in GameInfo.Resources() do
            local internalResourceAmount = pResourceData:GetResourceAmount(row.Index);
            if (internalResourceAmount > 0) then
                if (kResourceTable[row.Index] ~= nil) then
                    if (internalResourceAmount > kResourceTable[row.Index].Total) then
                        AddResourceData(kResourceTable, row.Index,
                            internalResourceAmount - kResourceTable[row.Index].Total);
                    end
                else
                    AddResourceData(kResourceTable, row.Index, internalResourceAmount);
                end
            end
        end
    end
    return kResourceTable;
end

--	kResources	(in) the table to add resources to.
function AddResourceData(kResources, eResourceType, InAmount)
    local kResource = GameInfo.Resources[eResourceType]

    --Artifacts need to be excluded because while TECHNICALLY a resource, they do nothing to contribute in a way that is relevant to any other resource
    --or screen. So... exclusion.
    if kResource.ResourceClassType == "RESOURCECLASS_ARTIFACT" then
        return
    end

    if kResources[eResourceType] == nil then
        kResources[eResourceType] = {
            Icon        = "[ICON_" .. kResource.ResourceType .. "]",
            IsStrategic = kResource.ResourceClassType == "RESOURCECLASS_STRATEGIC",
            IsLuxury    = GameInfo.Resources[eResourceType].ResourceClassType == "RESOURCECLASS_LUXURY",
            IsBonus     = GameInfo.Resources[eResourceType].ResourceClassType == "RESOURCECLASS_BONUS",
            Total       = 0
        }
    end

    kResources[eResourceType].Total = kResources[eResourceType].Total + InAmount
end

function GetPlayerResourcesData(playerID)
    if playerID == nil or not Players[tonumber(playerID)] then
        playerID = Game.GetLocalPlayer()
    end

    local kResources = {}

    if playerID == PlayerTypes.NONE then
        UI.DataError("Unable to get valid playerID for report screen.")
        return
    end

    local player = Players[playerID]

    if not player:IsMajor() then
        return kResources
    end

    local pResources = player:GetResources()
    local pCities    = player:GetCities()

    -- cities
    for _, pCity in pCities:Members() do
        for eResourceType, amount in pairs(GetCityResourceData(pCity)) do
            AddResourceData(kResources, eResourceType, amount)
        end
    end


    local kDealData = {}
    local kPlayers  = PlayerManager.GetAliveMajors()

    for _, pOtherPlayer in ipairs(kPlayers) do
        local otherID = pOtherPlayer:GetID()
        local currentGameTurn = Game.GetCurrentGameTurn()
        if otherID ~= playerID then
            local pPlayerConfig = PlayerConfigurations[otherID]
            local pDeals        = DealManager.GetPlayerDeals(playerID, otherID)

            if pDeals ~= nil then
                for _, pDeal in ipairs(pDeals) do
                    -- Add outgoing resource deals
                    local pOutgoingDeal = pDeal:FindItemsByType(DealItemTypes.RESOURCES, DealItemSubTypes.NONE, playerID)
                    if pOutgoingDeal ~= nil then
                        for _, pDealItem in ipairs(pOutgoingDeal) do
                            local duration       = pDealItem:GetDuration()
                            local remainingTurns = duration - (currentGameTurn - pDealItem:GetEnactedTurn())
                            if duration ~= 0 then
                                local amount       = pDealItem:GetAmount()
                                local resourceType = pDealItem:GetValueType()
                                table.insert(kDealData, {
                                    Type         = DealItemTypes.RESOURCES,
                                    ResourceType = resourceType,
                                    Amount       = amount,
                                    Duration     = remainingTurns,
                                    IsOutgoing   = true,
                                    PlayerID     = otherID,
                                    Name         = Locale.Lookup(pPlayerConfig:GetCivilizationDescription())
                                })
                                AddResourceData(kResources, resourceType, -1 * amount)
                            end
                        end
                    end

                    -- Add incoming resource deals
                    local pIncomingDeal = pDeal:FindItemsByType(DealItemTypes.RESOURCES, DealItemSubTypes.NONE, otherID)
                    if pIncomingDeal ~= nil then
                        for _, pDealItem in ipairs(pIncomingDeal) do
                            local duration = pDealItem:GetDuration()
                            if duration ~= 0 then
                                local amount         = pDealItem:GetAmount()
                                local resourceType   = pDealItem:GetValueType()
                                local remainingTurns = duration - (currentGameTurn - pDealItem:GetEnactedTurn())
                                table.insert(kDealData, {
                                    Type         = DealItemTypes.RESOURCES,
                                    ResourceType = resourceType,
                                    Amount       = amount,
                                    Duration     = remainingTurns,
                                    IsOutgoing   = false,
                                    PlayerID     = otherID,
                                    Name         = Locale.Lookup(pPlayerConfig:GetCivilizationDescription())
                                })


                                AddResourceData(kResources, resourceType, amount)
                            end
                        end
                    end
                end
            end
        end
    end

    -- Add resources provided by city states
    for _, pMinorPlayer in ipairs(PlayerManager.GetAliveMinors()) do
        local pMinorPlayerInfluence = pMinorPlayer:GetInfluence()
        if pMinorPlayerInfluence ~= nil then
            local suzerainID = pMinorPlayerInfluence:GetSuzerain()
            if suzerainID == playerID then
                for row in GameInfo.Resources() do
                    local resourceAmount = pMinorPlayer:GetResources():GetExportedResourceAmount(row.Index)
                    if resourceAmount > 0 then
                        AddResourceData(kResources, row.Index, resourceAmount)
                    end
                end
            end
        end
    end

    kResources = AddMiscResourceData(pResources, kResources)

    local resource_string = serialize(kResources)
    GameEvents.SetGameProperty.Call('TRM_PLAYER_RESOURCES_' .. playerID, resource_string)
    -- print('OnGetPlayerResourcesData, set test_data = ', resource_string)

    -- for key, value in pairs(kResources) do
    --     print('---------------' .. key)
    --     for k, v in pairs(value) do
    --         print('\t', k, v)
    --     end
    -- end

    return resource_string
end

---执行Gameplay环境下的修改器行为
---@param tradeRouteIDs table
---@param operationType number
function ExecuteTradeRouteInstanceOperation(tradeRouteModifierManager, tradeRouteIDs, operationType)
    local kParameters = {}
    kParameters.OnStart = "TradeRouteModifierExecuteOperation"
    kParameters.TradeRouteIDs = tradeRouteIDs
    kParameters.OperationType = operationType

    for _, tradeRouteID in ipairs(tradeRouteIDs) do
        -- print('ExecuteTradeRouteInstanceOperation, tradeRouteID = ', tradeRouteID,
        --     tradeRouteModifierManager[tradeRouteID])

        if tradeRouteModifierManager[tradeRouteID] then
            for _, instance in pairs(tradeRouteModifierManager[tradeRouteID]) do
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
        else
            print('ERROR ExecuteTradeRouteInstanceOperation, tradeRouteID = ', tradeRouteID, ' not found')
        end
    end

    GameEvents.SetGameProperty.Call('TradeRouteModifierInstanceManager', tradeRouteModifierManager)
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
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local cities = player:GetCities()
        for _, city in cities:Members() do
            local cityTrade = city:GetTrade()
            if cityTrade then
                local outgoingRoutes = cityTrade:GetOutgoingRoutes()
                for _, route in ipairs(outgoingRoutes) do
                    -- local tradeRouteID = table.concat(
                    --     { route.OriginCityPlayer, route.OriginCityID, route.DestinationCityPlayer, route
                    --         .DestinationCityID },
                    --     '-')
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

    -- for key, value in pairs(m_TradeRouteModifierManager) do
    --     print(key, value)
    -- end


    print('m_TradeRouteModifierManager = ', m_TradeRouteModifierManager, table.count(m_TradeRouteModifierManager))
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
                    -- trmInstance.Params = params
                    trmInstance:Calculate()
                    updatedTradeRoutes[tradeRouteID] = true
                end
            end
        end
    end

    local updatedTradeRouteIDs = {}
    for routeID, _ in pairs(updatedTradeRoutes) do
        table.insert(updatedTradeRouteIDs, routeID)
    end
    ExecuteTradeRouteInstanceOperation(m_TradeRouteModifierManager, updatedTradeRouteIDs, TRM_OperationType.UPDATE)
end

function UpdaterRegister()
    -- 城市单元格拥有者变更，包含城市单元格切换
    Events.CityTileOwnershipChanged.Add(function(playerID, cityID)
        -- print('CityTileOwnershipChanged: ', playerID, cityID)

        local params = {}
        params.p = playerID
        params.c = cityID
        -- UpdateTradeRouteModifier(CalculationItemType.RESOURCE, params)
        -- UpdateTradeRouteModifier(CalculationItemType.TERRAIN, params)
        -- UpdateTradeRouteModifier(CalculationItemType.FEATURE, params)
        for _, value in pairs(CalculationItemType) do
            if value <= CalculationItemType.MATCH_PLOT_COUNT then
                UpdateTradeRouteModifier(value, params)
            end
        end
    end)

    -- Deal 交易相关
    -- Events.DiplomacyDealEnacted.Add(function()
    --     -- print('On DiplomacyDealEnacted')
    --     GetPlayerResourcesData()
    --     UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT)
    -- end)

    -- Events.DiplomacyDealExpired.Add(function()
    --     -- print('On DiplomacyDealExpired')
    --     GetPlayerResourcesData()
    --     UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT)
    -- end)

    -- Events.DiplomacyIncomingDeal.Add(function(fromPlayerID, toPlayerID, actionType)
    --     -- print('On DiplomacyIncomingDeal: ', fromPlayerID, toPlayerID, actionType)
    --     GetPlayerResourcesData()
    --     UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT)
    -- end)


    Events.PlayerResourceChanged.Add(function(ownerPlayerID, resourceTypeID)
        local params = {}
        params.p = ownerPlayerID
        params.PlayerResources = GetPlayerResourcesData(ownerPlayerID)
        -- print('params.PlayerResources = ', params.PlayerResources)
        UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT, params)

        -- print('On PlayerResourceChanged, ', ownerPlayerID, resourceTypeID)
    end)

    -- ===============District 区域===============
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

    -- ===============Population 人口===============
    Events.CityPopulationChanged.Add(function(playerID, cityID, cityPopulation)
        local params = {}
        params.p     = playerID
        params.c     = cityID
        UpdateTradeRouteModifier(CalculationItemType.POPULATION, params)
    end)

    -- ===============Improvement 改良===============
    Events.ImprovementAddedToMap.Add(function(X, Y, improvementIndex, playerID)
        local params = {}
        params.p = playerID
        params.info = GameInfo.Improvements[improvementIndex]
        UpdateTradeRouteModifier(CalculationItemType.IMPROVEMENT, params)

        local params_1 = {}
        params_1.p = playerID
        -- UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT, params_1)
    end)
    Events.ImprovementRemovedFromMap.Add(function(X, Y, playerID)
        local params = {}
        params.p = playerID
        UpdateTradeRouteModifier(CalculationItemType.IMPROVEMENT, params)
        local params_1 = {}
        params_1.p = playerID
        -- UpdateTradeRouteModifier(CalculationItemType.TOTAL_RESOURCE_AMOUNT, params_1)
    end)

    -- ===============Wonder 奇观===============
    Events.WonderCompleted.Add(function()
        UpdateTradeRouteModifier(CalculationItemType.WONDER)
    end)

    -- ===============GreatPeoplePoint 伟人点数===============
    Events.GreatPeoplePointsChanged.Add(function(playerID)
        local params = {}
        params.p = playerID
        UpdateTradeRouteModifier(CalculationItemType.GREAT_PEOPLE_POINT, params)
    end)


    Events.LocalPlayerTurnEnd.Add(function()
    end)

    -- ===============Influence 影响力、使者===============
    Events.InfluenceGiven.Add(function(minorId, majorId)
        local params = {}
        params.dp = minorId
        UpdateTradeRouteModifier(CalculationItemType.ENVOY, params)
    end)

    -- 单元格工作人口变更
    Events.CityWorkerChanged.Add(function(ownerPlayerID, cityID, X, Y)
        local params = {}
        params.p = ownerPlayerID
        params.c = cityID
        -- UpdateTradeRouteModifier(CalculationItemType.GREAT_WORK, params)
        for _, value in pairs(CalculationItemType) do
            if value <= CalculationItemType.MATCH_PLOT_COUNT then
                UpdateTradeRouteModifier(value, params)
            end
        end
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


    -- 时代变更
    Events.GameEraChanged.Add(function(previousEraIndex, newEraIndex)
        UpdateTradeRouteModifier(CalculationItemType.GAME_ERA_CHANGE, nil)
    end)
end

-- ============================================
-- GAME CORE EVENTS
-- ============================================

-- 贸易路线活动变更事件
function OnTradeRouteActivityChanged(playerID, originPlayerID, originCityID, targetPlayerID, targetCityID)
    OnTradeRouteCapacityChanged(playerID)

    local isNewRoute = IsNewTradeRouteCreated(originPlayerID, originCityID,
        targetPlayerID, targetCityID)

    local tradeRouteID = table.concat({ originPlayerID, originCityID, targetPlayerID, targetCityID }, '-')


    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}

    ExecuteTradeRouteInstanceOperation(m_TradeRouteModifierManager, { tradeRouteID },
        aORb(isNewRoute, TRM_OperationType.APPLY, TRM_OperationType.DESTROY))

    -- print('On OnTradeRouteActivityChanged.....')
end

function OnTradeRouteCapacityChanged(playerID)
    local player = Players[playerID]
    local playerConfig = PlayerConfigurations[playerID]
    if not player or not playerConfig then
        return
    end

    local playerTrade    = player:GetTrade()
    local routesActive   = playerTrade:GetNumOutgoingRoutes()
    local routesCapacity = playerTrade:GetOutgoingRouteCapacity()

    playerConfig:SetValue('TRADE_ROUTES_ACTIVE', routesActive)
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
    ExposedMembers.TRM = ExposedMembers.TRM or {}
    ExposedMembers.TRM.GetPlayerResourcesData = GetPlayerResourcesData
    ExposedMembers.TRM.GetPlayerEraData = GetPlayerEraData


    InitGameSummarySets()

    Events.TurnBegin.Add(GetPlayerResourcesData)

    Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
    Events.TradeRouteCapacityChanged.Add(OnTradeRouteCapacityChanged)

    UpdaterRegister()

    InitializeTradeRouteModifiers()
end

Events.LoadGameViewStateDone.Add(Initialize)
