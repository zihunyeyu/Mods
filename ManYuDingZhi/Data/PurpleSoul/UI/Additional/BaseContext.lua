-- BaseContext
-- Author: purple soul
-- DateCreated: 11/3/2024 12:13:37 PM
--------------------------------------------------------------
-- ===========================================================================
-- INCLUDE
-- ===========================================================================
GameEvents                                              = ExposedMembers.GameEvents
Utils                                                   = ExposedMembers.PurpleSoul.Utils
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
local NETHERLANDS                                       = "CIVILIZATION_NETHERLANDS"
local WILHELMINA                                        = "LEADER_WILHELMINA"
local POUNDMAKER                                        = 'LEADER_POUNDMAKER'
local GENERAL_INDEX                                     = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL']
    .Index
local IMPROVEMENT_PASTURE_INDEX                         = GameInfo.Improvements['IMPROVEMENT_PASTURE'].Index
local IMPROVEMENT_CAMP_INDEX                            = GameInfo.Improvements['IMPROVEMENT_CAMP'].Index
local IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX              = -1
local IMPROVEMENT_OIL_WELL_INDEX                        = -1
local OIL_WELL_TECH_INDEX                               = -1
local OIL_WELL_CIVIC_INDEX                              = -1
local TEST_TECH_INDEX                                   = GameInfo.Technologies['TECH_ASTROLOGY'].Index
local GREATWORK                                         = 'GREATWORK_CORPUS_JURIS_CIVILIS'
-- GREATWORK_CORPUS_JURIS_CIVILIS
-- GREATWORK_SUN_TZU
local GREATWORK_PROPERTY                                = 'PROPERTY_LEADER_THEODORA_GREATWORK_DISTRICT'
-- ===========================================================================
-- VARIABLES
-- ===========================================================================
local GreatWorkKeepCity                                 = {
    PlayerID = -1,
    CityID = -1
}
local GreatWorkRecheck                                  = false
local GreatWorkRecheckTable                             = {}
-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================
-- 获取城市改良的总数
ExposedMembers.PurpleSoul.Utils.GetCityImprovementCount = function(city, improvementType)
    if city == nil then
        return
    end
    local kCityPlots = Map.GetCityPlots():GetPurchasedPlots(city)
    local totalNum = 0
    local improvementIndex = GameInfo.Improvements[improvementType].Index
    if (kCityPlots ~= nil) then
        for _, plotID in pairs(kCityPlots) do
            local kPlot = Map.GetPlotByIndex(plotID);
            if kPlot:GetImprovementType() == improvementIndex then
                totalNum = totalNum + 1
            end
        end
    end
    return totalNum
end
-- ===========================================================================
-- CIVILIZATION_BYZANTIUM 拜占庭替换改良
-- ===========================================================================
function OnResearchCompleted_IMPROVEMENT_OIL_WELL_BYZANTIUM(playerID, technologyIndex)
    -- print(playerID, technologyIndex, Utils.IsCivilizationType(playerID, 'CIVILIZATION_BYZANTIUM'))
    if technologyIndex == OIL_WELL_TECH_INDEX and Utils.IsCivilizationType(playerID, 'CIVILIZATION_BYZANTIUM') then
        local player = Players[playerID]
        local improvements = player:GetImprovements()
        local tImprovementLocations = improvements:GetImprovementPlots();
        for _, plotID in ipairs(tImprovementLocations) do
            local pPlot = Map.GetPlotByIndex(plotID);
            if (pPlot ~= nil) then
                local eImprovement = pPlot:GetImprovementType();
                -- print('eImprovement = ', eImprovement, IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX)
                if (eImprovement == IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX) then
                    Utils.SetImprovementType(plotID, IMPROVEMENT_OIL_WELL_INDEX, playerID)
                end
            end
        end
    end
end

function OnCivicCompleted_IMPROVEMENT_OIL_WELL_BYZANTIUM(playerID, civicIndex, isCancelled)
    if civicIndex == OIL_WELL_CIVIC_INDEX and Utils.IsCivilizationType(playerID, 'CIVILIZATION_BYZANTIUM') then
        local player = Players[playerID]
        local improvements = player:GetImprovements()
        local tImprovementLocations = improvements:GetImprovementPlots();
        for _, plotID in ipairs(tImprovementLocations) do
            local pPlot = Map.GetPlotByIndex(plotID);
            if (pPlot ~= nil) then
                local eImprovement = pPlot:GetImprovementType();
                if (eImprovement == IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX) then
                    Utils.SetImprovementType(pPlot:GetIndex(), IMPROVEMENT_OIL_WELL_INDEX, playerID)
                end
            end
        end
    end
end

function OnImprovementAddedToMap_IMPROVEMENT_OIL_WELL_BYZANTIUM(x, y, improvementIndex, playerID)
    local player = Players[playerID]
    if improvementIndex == IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX then
        local pPlot = Map.GetPlot(x, y)
        if OIL_WELL_TECH_INDEX ~= -1 then
            local techs = player:GetTechs()
            if techs and techs:HasTech(OIL_WELL_TECH_INDEX) then
                Utils.SetImprovementType(pPlot:GetIndex(), IMPROVEMENT_OIL_WELL_INDEX, playerID)
            end
        elseif OIL_WELL_CIVIC_INDEX ~= -1 then
            local cultures = player:GetCulture()
            if cultures and cultures:HasCivic(OIL_WELL_CIVIC_INDEX) then
                Utils.SetImprovementType(pPlot:GetIndex(), IMPROVEMENT_OIL_WELL_INDEX, playerID)
            end
        end
    end
end

-- ===========================================================================
-- CIVILIZATION_BYZANTIUM 狄奥多拉：查士丁尼法典    LEADER_THEODORA
-- ===========================================================================
function SetTheodoraModifier(playerID, cityID, flag)
    local city = CityManager.GetCity(player, cityID)
    local kCityPlots = Map.GetCityPlots():GetPurchasedPlots(city)
    if (kCityPlots ~= nil) then
        for _, plotID in pairs(kCityPlots) do
            if flag then
                GameEvents.SetPlotProperty.Call(plotID, GREATWORK_PROPERTY, 1)
            else
                GameEvents.SetPlotProperty.Call(plotID, GREATWORK_PROPERTY, nil)
            end
        end
    end
end

function InitializeGreatPeople()
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local playerConfig = PlayerConfigurations[playerID]
        if playerConfig:GetLeaderTypeName() == 'LEADER_THEODORA' then
            if player:GetProperty('GREATPEOPLE_CORPUS_JURIS_CIVILIS_CREATED') == nil then
                local startEra = GameInfo.Eras[GameConfiguration.GetStartEra()].ChronologyIndex
                if startEra >= 2 then
                    Utils.AddGreatMerchant(playerID, 'GREAT_PERSON_INDIVIDUAL_JUSTINIAN_THE_GREAT', 'ERA_ANCIENT',
                        'GREAT_PERSON_CLASS_EXTRA_GENERAL')
                    GameEvents.SetPlayerProperty.Call(playerID, 'GREATPEOPLE_CORPUS_JURIS_CIVILIS_CREATED', 1)
                end
            end
        end
    end
end

function InitializeGreatWork()
    local playerIDs = PlayerManager.GetAliveMajorIDs()
    -- 检查MODIFIER 是否已赋给所有玩家
    local modifierAttached = Game.GetProperty('GREATWORK_CORPUS_JURIS_CIVILIS_MODIFIER_ATTACHED')
    if modifierAttached == nil then
        for _, playerID in ipairs(playerIDs) do
            Utils.AttachModifierByIDForPlayer(playerID, 'MODIFIER_THEODORA_CITIES_COMMERCIAL_HUB_AND_HARBOR')
            print(playerID, 'has attached modifier....')
        end
        GameEvents.SetGameProperty.Call('GREATWORK_CORPUS_JURIS_CIVILIS_MODIFIER_ATTACHED', true)
    end
    -- 检查查士丁尼法典是否已创建
    local created = false
    for _, playerID in ipairs(playerIDs) do
        local player = Players[playerID]
        local cities = player:GetCities()
        if cities then
            for i, city in cities:Members() do
                local cityID = city:GetID()
                local cityGreatWorks = player:GetCulture():GetGreatWorksInCity(cityID);
                if cityGreatWorks ~= nil and #cityGreatWorks > 0 then
                    for _, entry in ipairs(cityGreatWorks) do
                        local greatWorksDesc = GameInfo.GreatWorks[entry.GreatWorksType];
                        if greatWorksDesc.GreatWorkType == GREATWORK then
                            GreatWorkKeepCity.PlayerID = playerID
                            GreatWorkKeepCity.CityID = cityID
                            created = true
                        end
                    end
                end
                SetTheodoraModifier(playerID, cityID, false)
            end
        end
    end
    print('greatwork has been created?....', created)
    if created then
        SetTheodoraModifier(playerID, cityID, true)
        Events.GreatWorkCreated.Remove(OnGreatWorkCreated_LEADER_THEODORA)
        Events.TurnEnd.Remove(OnTurnEnd_LEADER_THEODORA)
        GameEvents.SetGameProperty.Call('GreatWorkHasCreated', true)
    else
        GameEvents.SetGameProperty.Call('GreatWorkHasCreated', false)
    end
end

function OnGreatWorkCreated_LEADER_THEODORA(playerID, unitID, cityPlotX, cityPlotY, buildingID, greatWorkID)
    if greatWorkID ~= 0 then
        return
    end
    local city = CityManager.GetCityAt(cityPlotX, cityPlotY)
    if city ~= nil then
        GreatWorkRecheckTable[playerID] = GreatWorkRecheckTable[playerID] or {}
        local cityID = city:GetID()
        if not Utils.IsInTable(GreatWorkRecheckTable[playerID], cityID) then
            table.insert(GreatWorkRecheckTable[playerID], cityID)
        end
    end
    print('greatwork has been created in ', cityPlotX, cityPlotY, 'belongs to ', playerID)
    GameEvents.SetGameProperty.Call('GreatWorkHasCreated', false)
end

function OnGreatWorkMoved_LEADER_THEODORA(fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID,
                                          greatWorkTypeIndex)
    if greatWorkTypeIndex ~= 0 then
        return
    end
    local player = Players[toCityPlayerID]
    local cityGreatWorks = player:GetCulture():GetGreatWorksInCity(toCityID);
    if cityGreatWorks ~= nil and #cityGreatWorks > 0 then
        for _, entry in ipairs(cityGreatWorks) do
            local greatWorksDesc = GameInfo.GreatWorks[entry.GreatWorksType];
            if greatWorksDesc.GreatWorkType == GREATWORK then
                GreatWorkKeepCity.PlayerID = toCityPlayerID
                GreatWorkKeepCity.CityID = toCityID
                print(GreatWorkKeepCity.PlayerID, GreatWorkKeepCity.CityID, Locale.Lookup(greatWorksDesc.Name))
                SetTheodoraModifier(toCityPlayerID, toCityID, true)
                SetTheodoraModifier(fromCityPlayerID, fromCityID, false)
                return
            end
        end
    end
end

function OnTurnEnd_LEADER_THEODORA_A()
    if Game.GetProperty('GreatWorkHasCreated') then
        SetTheodoraModifier(GreatWorkKeepCity.PlayerID, GreatWorkKeepCity.CityID, true)
    end
end

function OnTurnEnd_LEADER_THEODORA()
    if not Game.GetProperty('GreatWorkHasCreated') then
        for playerID, cityIDs in pairs(GreatWorkRecheckTable) do
            local player = Players[playerID]
            if player and player:IsMajor() and player:IsAlive() then
                for _, cityID in ipairs(cityIDs) do
                    local cityGreatWorks = player:GetCulture():GetGreatWorksInCity(cityID);
                    if cityGreatWorks ~= nil and #cityGreatWorks > 0 then
                        for _, entry in ipairs(cityGreatWorks) do
                            local greatWorksDesc = GameInfo.GreatWorks[entry.GreatWorksType];
                            -- print(Locale.Lookup(greatWorksDesc.Name))
                            if greatWorksDesc.GreatWorkType == GREATWORK then
                                Events.GreatWorkCreated.Remove(OnGreatWorkCreated_LEADER_THEODORA)
                                Events.TurnEnd.Remove(OnTurnEnd_LEADER_THEODORA)
                                SetTheodoraModifier(playerID, cityID, true)
                                GameEvents.SetGameProperty.Call('GreatWorkHasCreated', true)
                                return
                            end
                        end
                    end
                end
            end
        end
        GreatWorkRecheckTable = {}
    end
end

-- ===========================================================================
-- LEADER_WILHELMINA    威廉明娜
-- ===========================================================================
-- 荷兰被宣战的10回合以内你的城市加5防御力，加5远程攻击力。
function OnDiplomacyDeclareWar(firstPlayerID, secondPlayerID)
    local dPlayers = Players[secondPlayerID]
    if dPlayers == nil or not dPlayers:IsMajor() then
        return
    end
    local dPlayerConfig = PlayerConfigurations[secondPlayerID]
    if dPlayerConfig == nil then
        return
    end
    -- Check if the declared war is against Wilhelmina
    if dPlayerConfig:GetLeaderTypeName() == 'LEADER_WILHELMINA' then
        local kParameters = {}
        kParameters.DeclareWarPlayerID = secondPlayerID
        kParameters.OnStart = "DiplomacyDeclareWarTurnCount"
        UI.RequestPlayerOperation(firstPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)
    end
end

-- 荷兰为商路目的地城市加成
function AttachTradeModifiers_Wilhelmina(routeNumMax, newRouteNum, resetMax, playerID, cityID)
    local player = Players[playerID]
    local city = CityManager.GetCity(playerID, cityID)
    if player == nil or city == nil then
        return
    end
    if resetMax then
        GameEvents.SetCityProperty.Call(playerID, cityID, 'ROUTE_NUM_MAX', newRouteNum)
        for i = routeNumMax + 1, newRouteNum do
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_SCIENCE_HAS_TRADE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_' .. i)
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_CULTURE_HAS_TRADE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_' .. i)
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_GOLD_HAS_TRADE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_' .. i)
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_SCIENCE_HAS_TRADE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_' .. i * 2)
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_CULTURE_HAS_TRADE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_' .. i * 2)
            Utils.AttachModifierByIDForPlayer(playerID,
                'MODIFIER_INCREASE_GOLD_HAS_TRADE_WITHWILHELMINA_AFTER_ERA_CLASSICAL_' .. i * 2)
            print(i, 'MODIFIER_INCREASE_SCIENCE_HAS_TRADE_WITHWILHELMINA_BEFORE_ERA_MEDIEVAL_' .. i)
        end
    end
    local plot = Map.GetPlot(city:GetX(), city:GetY())
    local plotIndex = plot:GetIndex()
    local maxRoute = math.max(routeNumMax, newRouteNum)
    for i = 1, maxRoute do
        if i ~= newRouteNum then
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_' .. i, nil)
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_' .. (i * 2), nil)
        else
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_' .. i, 1)
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_' .. (i * 2), 1)
        end
    end
end

function GetnewRouteNum(city)
    if city == nil then
        return
    end
    local cPlayer = Players[city:GetOwner()]
    local RouteNumMax = city:GetProperty("ROUTE_NUM_MAX")
    local cityTrade = city:GetTrade()
    if cityTrade == nil then
        return
    end
    local incomRoutes = cityTrade:GetIncomingRoutes()
    local newRouteNum = 0
    if incomRoutes == nil then
        return
    end
    if #incomRoutes == 0 then
        if RouteNumMax ~= nil then
            local plot = Map.GetPlot(city:GetX(), city:GetY())
            local plotIndex = plot:GetIndex()
            for i = 1, RouteNumMax do
                GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_BEFORE_ERA_MEDIEVAL_' .. i, nil)
                GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_INCREASE_AFTER_ERA_CLASSICAL_' .. (i * 2), nil)
            end
            return
        end
    end
    for _, route in ipairs(incomRoutes) do
        -- BaseContext: TraderUnitID	262144
        -- BaseContext: DestinationCityPlayer	1
        -- BaseContext: DestinationYields	table: 00000001C78B2570
        -- BaseContext: OriginCityPlayer	0
        -- BaseContext: TraderUnitPlayer	0
        -- BaseContext: DestinationCityID	65536
        -- BaseContext: OriginCityID	65536
        -- BaseContext: OriginYields	table: 00000001C78B2D40
        if route.DestinationCityPlayer ~= route.OriginCityPlayer and
            PlayerConfigurations[route.OriginCityPlayer]:GetLeaderTypeName() == WILHELMINA then
            newRouteNum = newRouteNum + 1
            local dCityName = Locale.Lookup(CityManager.GetCity(route.DestinationCityPlayer, route.DestinationCityID)
                :GetName())
            local oCityName = Locale.Lookup(CityManager.GetCity(route.OriginCityPlayer, route.OriginCityID):GetName())
            print(oCityName .. ' -> ' .. dCityName, newRouteNum)
        end
    end
    -- 如果之前未设置城市贸易路线数量，则将设置为0
    -- 如果新计算的贸易路线数量 > 最大值，则重新设置最大值
    local resetMax = false
    if RouteNumMax == nil then
        RouteNumMax = 0
        resetMax = true
    elseif RouteNumMax < newRouteNum then
        resetMax = true
    end
    AttachTradeModifiers_Wilhelmina(RouteNumMax, newRouteNum, resetMax,
        city:GetOwner(), city:GetID())
end

function OnTradeRouteActivityChanged_Wilhelmina(playerID, originPlayerID, originCityID, targetPlayerID, targetCityID)
    -- print('OnTradeRouteActivityChanged_Wilhelmina', playerID, originPlayerID, originCityID, targetPlayerID, targetCityID)
    local oPlayer = Players[originPlayerID]
    local tPlayer = Players[targetPlayerID]
    if oPlayer == nil or tPlayer == nil or PlayerConfigurations[originPlayerID]:GetLeaderTypeName() ~= WILHELMINA then
        return
    end
    local tCity = CityManager.GetCity(targetPlayerID, targetCityID)
    if tCity ~= nil then
        GetnewRouteNum(tCity)
    end
end

function InitializeTradeWithWilhelmina()
    -- local flag = Game:GetProperty("BasilAttachModifierFlag")
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local cities = player:GetCities()
        if cities ~= nil then
            for i, city in cities:Members() do
                GetnewRouteNum(city)
            end
        end
    end
end

-- ===========================================================================
-- LEADER_POUNDMAKER    庞德梅克
-- ===========================================================================
function AttachTradeModifiers_Poundmaker(oldTotal, newTotal, reset, cPlayerID, cityID, improvementType)
    -- print('OnAttachTradeModifiers_Wilhelmina', RouteNumMax, newRouteNum, resetMax, cPlayerID, cityID)
    local cPlayer = Players[cPlayerID]
    local city    = CityManager.GetCity(cPlayerID, cityID)
    if cPlayer == nil or city == nil then
        return
    end
    if reset then
        local totalMax = city:GetProperty(improvementType .. '_TOTAL_NUM_MAX')
        if totalMax == nil then
            totalMax = 0
        end
        for i = totalMax + 1, newTotal do
            Utils.AttachModifierByIDForPlayer(cPlayerID,
                'TRAIT_LEADER_ALLIANCE_AND_TRADE_' .. improvementType .. i)
            print(i, 'TRAIT_LEADER_ALLIANCE_AND_TRADE_' .. improvementType .. i)
        end
        GameEvents.SetCityProperty.Call(cPlayerID, cityID, improvementType .. '_TOTAL_NUM_MAX', newTotal)
    end
    local plot = Map.GetPlot(city:GetX(), city:GetY())
    local plotIndex = plot:GetIndex()
    local counter
    if oldTotal >= newTotal then
        counter = oldTotal
    else
        counter = newTotal
    end
    for i = 1, counter do
        if i ~= newTotal then
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_TOTAL_NUM_' .. improvementType .. i, nil)
        else
            GameEvents.SetPlotProperty.Call(plotIndex, 'PROPERTY_TOTAL_NUM_' .. improvementType .. i, 1)
        end
    end
    GameEvents.SetCityProperty.Call(cPlayerID, cityID, improvementType .. '_TOTAL_NUM', newTotal)
end

function GetTradeOriginalCityImprovement(city, improvementType)
    if city == nil then
        return
    end
    local cPlayer = Players[city:GetOwner()]
    local oldTotal = city:GetProperty(improvementType .. '_TOTAL_NUM')
    local totalMax = city:GetProperty(improvementType .. '_TOTAL_NUM_MAX')
    local cityTrade = city:GetTrade()
    if cityTrade == nil then
        return
    end
    local incomRoutes = cityTrade:GetIncomingRoutes()
    if incomRoutes == nil then
        return
    end
    -- print(city:GetOwner(), #incomRoutes, improvementType)
    local plot = Map.GetPlot(city:GetX(), city:GetY())
    local plotIndex = plot:GetIndex()
    if #incomRoutes == 0 then
        if oldTotal ~= nil then
            for i = 1, oldTotal do
                GameEvents.SetPlotProperty.Call(plotIndex, 'REQS_PLOT_PROPERTY_IMPROVEMENT_PASTURE_NUM' .. i, nil)
            end
        end
        return
    end
    local newTotal = 0
    for _, route in ipairs(incomRoutes) do
        if PlayerConfigurations[route.OriginCityPlayer]:GetLeaderTypeName() == POUNDMAKER then
            local oCity = CityManager.GetCity(route.OriginCityPlayer, route.OriginCityID)
            local cTotalNum = ExposedMembers.PurpleSoul.Utils.GetCityImprovementCount(oCity, improvementType)
            newTotal = newTotal + cTotalNum
        end
    end
    local resetTotal = false
    if oldTotal == nil then
        oldTotal = 0
    end
    if totalMax == nil or totalMax < newTotal then
        resetTotal = true
    end
    print(oldTotal, newTotal, totalMax)
    AttachTradeModifiers_Poundmaker(oldTotal, newTotal, resetTotal, city:GetOwner(), city:GetID(), improvementType)
end

function OnTradeRouteActivityChanged_Poundmaker(playerID, originPlayerID, originCityID, targetPlayerID, targetCityID)
    local oPlayer = Players[originPlayerID]
    local tPlayer = Players[targetPlayerID]
    if oPlayer == nil or tPlayer == nil or PlayerConfigurations[originPlayerID]:GetLeaderTypeName() ~= POUNDMAKER then
        return
    end
    local tCity = CityManager.GetCity(targetPlayerID, targetCityID)
    if tCity ~= nil then
        GetTradeOriginalCityImprovement(tCity, 'IMPROVEMENT_PASTURE')
        GetTradeOriginalCityImprovement(tCity, 'IMPROVEMENT_CAMP')
    end
end

function RefreshPoundmakerImprovements()
    -- Loop through all major players
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        if player ~= nil then
            local cities = player:GetCities()
            if cities ~= nil then
                -- Loop through each city of the player
                for _, city in cities:Members() do
                    -- Apply improvements
                    GetTradeOriginalCityImprovement(city, 'IMPROVEMENT_PASTURE')
                    GetTradeOriginalCityImprovement(city, 'IMPROVEMENT_CAMP')
                end
            end
        end
    end
end

function OnImprovementAddedToMap_Poundmaker(x, y, improvementIndex, playerID)
    -- Function triggered when an improvement is added to the map
    -- Check if the improvement belongs to Poundmaker
    local playerConfig = PlayerConfigurations[playerID]
    if playerConfig:GetLeaderTypeName() == 'LEADER_POUNDMAKER' then
        -- Check if the improvement is a Camp or Pasture
        if improvementIndex == IMPROVEMENT_CAMP_INDEX or improvementIndex == IMPROVEMENT_PASTURE_INDEX then
            -- Refresh Poundmaker improvements
            RefreshPoundmakerImprovements()
        end
    end
end

function OnImprovementRemovedFromMap_Poundmaker(x, y, playerID)
    -- Function triggered when an improvement is removed from the map
    local playerConfig = PlayerConfigurations[playerID]
    -- Check if the player is Poundmaker
    if playerConfig:GetLeaderTypeName() == 'LEADER_POUNDMAKER' then
        -- Refresh Poundmaker improvements
        RefreshPoundmakerImprovements()
    end
    -- Uncomment the line below for debugging purposes
    -- print(x, y, playerID)
end

function InitializeTradeWithPoundmaker()
    -- local flag = Game:GetProperty("BasilAttachModifierFlag")
    -- for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
    --     local player = Players[playerID]
    --     local cities = player:GetCities()
    --     if cities ~= nil then
    --         for i, city in cities:Members() do
    --             -- GetnewRouteNum(city)
    --         end
    --     end
    -- end
    RefreshPoundmakerImprovements()
end

-- ===========================================================================
-- TEST FUNCTIONS
-- ===========================================================================

function OnUnitSelectionChanged(playerID, unitID, plotX, plotY, plotZ, bSelected, bEditable)
    if bSelected then
        local pUnit = UI.GetHeadSelectedUnit();
        if pUnit == nil then
            return
        end
        -- local pUnit = UnitManager.GetUnit(playerID, unitID)
        local abilities = pUnit:GetAbility():GetAbilities()
        for i, ability in ipairs(abilities) do
            local pAbilityDef = GameInfo.UnitAbilities[ability]
            print('abilityID = ', ability)
            if pAbilityDef ~= nil then
                print(pAbilityDef.UnitAbilityType)
            end
        end
    end
end

function Initialize()
    if Utils.IsLeaderInGame('LEADER_THEODORA') then
        Events.GreatWorkCreated.Add(OnGreatWorkCreated_LEADER_THEODORA)
        Events.GreatWorkMoved.Add(OnGreatWorkMoved_LEADER_THEODORA)
        Events.TurnEnd.Add(OnTurnEnd_LEADER_THEODORA)
        Events.TurnEnd.Add(OnTurnEnd_LEADER_THEODORA_A)
        InitializeGreatWork()
        InitializeGreatPeople()
    end
    if Utils.IsCivilizationInGame('CIVILIZATION_BYZANTIUM') then
        local oil_well = GameInfo.Improvements['IMPROVEMENT_OIL_WELL']
        local oil_well_byzantium = GameInfo.Improvements['IMPROVEMENT_OIL_WELL_BYZANTIUM']
        if oil_well and oil_well_byzantium then
            IMPROVEMENT_OIL_WELL_BYZANTIUM_INDEX = oil_well_byzantium.Index
            IMPROVEMENT_OIL_WELL_INDEX = oil_well.Index
            local oil_well_tech = oil_well.PrereqTech
            local oil_well_civic = oil_well.PrereqCivic
            if oil_well_tech then
                local OIL_WELL_UNLOCK_TECH = GameInfo.Technologies[oil_well_tech]
                if OIL_WELL_UNLOCK_TECH then
                    OIL_WELL_TECH_INDEX = OIL_WELL_UNLOCK_TECH.Index
                    -- print('OIL_WELL_UNLOCK_TECH = ', OIL_WELL_UNLOCK_TECH.Name)
                    Events.ResearchCompleted.Add(OnResearchCompleted_IMPROVEMENT_OIL_WELL_BYZANTIUM)
                end
            elseif oil_well_civic then
                local OIL_WELL_UNLOCK_CIVIC = GameInfo.Civics[oil_well_civic]
                if OIL_WELL_UNLOCK_CIVIC then
                    OIL_WELL_CIVIC_INDEX = OIL_WELL_UNLOCK_CIVIC.Index
                    Events.CivicCompleted.Add(OnCivicCompleted_IMPROVEMENT_OIL_WELL_BYZANTIUM)
                end
            end
        end
        Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap_IMPROVEMENT_OIL_WELL_BYZANTIUM)
    end
    -- Check if Wilhelmina is in the game
    if Utils.IsLeaderInGame('LEADER_WILHELMINA') then
        InitializeTradeWithWilhelmina()
        Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged_Wilhelmina)
        Events.DiplomacyDeclareWar.Add(OnDiplomacyDeclareWar)
    end
    -- Check if Poundmaker is in the game
    if Utils.IsLeaderInGame('LEADER_POUNDMAKER') then
        Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap_Poundmaker)
        Events.ImprovementRemovedFromMap.Add(OnImprovementRemovedFromMap_Poundmaker)
        Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged_Poundmaker)
    end

    -- Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
end

Events.LoadGameViewStateDone.Add(Initialize);
