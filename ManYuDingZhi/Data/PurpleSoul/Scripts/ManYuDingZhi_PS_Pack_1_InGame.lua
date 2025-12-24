-- ManYuDingZhi_PS_Pack_1_InGame
-- Author: purple soul
-- DateCreated: 11/3/2024 12:12:52 PM
--------------------------------------------------------------
-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("ManYuDingZhi_PS_Pack_1_Utils")
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
local NETHERLANDS                = "CIVILIZATION_NETHERLANDS"
local WILHELMINA                 = "LEADER_WILHELMINA"
local DIPLOMACY_DECLARE_WAR_TURN = 10 -- 威廉明娜领袖技能设定回合数
local RESOURCE_TULIPA_INDEX      = GameInfo.Resources["RESOURCE_TULIPA"].Index
local TULIPA_NUM_MAX             = 4  -- 威廉明娜可拥有的郁金香最大数量
local TECH_BUTTRESS_INDEX        = GameInfo.Technologies['TECH_BUTTRESS'].Index
local TECH_SAILING_INDEX         = GameInfo.Technologies['TECH_SAILING'].Index
local BASIL                      = 'LEADER_BASIL'
local BASIL_NUM_MAX              = 0 -- 对局中巴兹尔领袖的数量
-- ===========================================================================
-- VARIABLES
-- ===========================================================================
-- ===========================================================================
-- CIVILIZATION_BYZANTIUM 拜占庭
-- ===========================================================================
-- 拥有宗教后创建单位时赋予能力
function OnReligionFounded(playerID, religionID)
    if PlayerConfigurations[playerID]:GetCivilizationTypeName() ~= 'CIVILIZATION_BYZANTIUM' then
        return
    end

    local player = Players[playerID]
    player:AttachModifierByID('TRAIT_COMBAT_BONUS_BYZANTIUM')
end

-- ===========================================================================
-- LEADER_BASIL
-- ===========================================================================
-- 初始化
function InitializeWarWithBasil()
    BASIL_NUM_MAX = 0
    local pIDs = PlayerManager.GetAliveMajorIDs()
    for _, playerID in ipairs(pIDs) do
        local player = Players[playerID]
        local playerConfig = PlayerConfigurations[playerID]
        if player ~= nil and playerConfig ~= nil and playerConfig:GetLeaderTypeName() == BASIL then
            BASIL_NUM_MAX = BASIL_NUM_MAX + 1
        end
    end
    local localPlayer = Players[Game.GetLocalPlayer()]
    local flag = Game:GetProperty("BasilAttachModifierFlag")
    if flag == nil then
        for _, playerID in ipairs(PlayerManager.GetAliveIDs()) do
            local player = Players[playerID]
            for i = 1, BASIL_NUM_MAX do
                local modifier = 'MODIFIER_DECREASE_FOOD_IN_WAR_WITH_LEADER_BASIL_' .. (i * 2)
                -- local modifierIndex = GameInfo.Modifiers[modifier].Index
                player:AttachModifierByID(modifier)
            end
            SetBasilFoodModifier(playerID)
        end
        Game:SetProperty('BasilAttachModifierFlag', 1)
        -- print('BasilAttachModifierFlag', Game:GetProperty("BasilAttachModifierFlag"))
    end
end

-- 据玩家当前对战中的巴兹尔二世领袖数量
function GetWarWithBasilNum(iPlayerID)
    local aliveMajorIDs = PlayerManager.GetAliveMajorIDs()
    local warWithBasil = 0
    for _, playerID in ipairs(aliveMajorIDs) do
        local player = Players[playerID]
        local pDiplomacy = player:GetDiplomacy()
        if playerID ~= iPlayerID then
            if pDiplomacy:IsAtWarWith(iPlayerID) then
                local playerConfig = PlayerConfigurations[playerID]
                if playerConfig ~= nil and playerConfig:GetLeaderTypeName() == BASIL then
                    warWithBasil = warWithBasil + 1
                end
            end
        end
    end
    return warWithBasil
end

-- 根据玩家当前对战中的巴兹尔二世领袖数量，开关对应MODIFIER
function SetBasilFoodModifier(playerID)
    local bNum = GetWarWithBasilNum(playerID)
    local player = Players[playerID]
    if player ~= nil then
        local cities = player:GetCities()
        if cities ~= nil then
            for _, city in cities:Members() do
                local plot = city:GetPlot()
                if plot ~= nil then
                    for i = 1, BASIL_NUM_MAX do
                        if bNum == i then
                            plot:SetProperty('PROPERTY_DECREASE_FOOD_' .. i, 1)
                        else
                            plot:SetProperty('PROPERTY_DECREASE_FOOD_' .. i, nil)
                        end
                    end
                end
            end
        end
    end
end

function CanGetGreatPerson(playerID)
    local pGreatPeople = Game.GetGreatPeople();
    if pGreatPeople == nil then
        return
    end
    local recruitCost = 0
    local canRecruit = false
    local pTimeline = pGreatPeople:GetTimeline();
    for i, entry in ipairs(pTimeline) do
        local individualInfo = GameInfo.GreatPersonIndividuals[entry.Individual]
        if individualInfo.GreatPersonClassType == 'GREAT_PERSON_CLASS_GENERAL' then
            recruitCost = entry.Cost
            canRecruit  = pGreatPeople:CanRecruitPerson(displayPlayerID, entry.Individual);
            break
        end
    end
    return recruitCost, canRecruit
end

function OnGreatPeoplePointsChanged(playerID)
    local player = Players[playerID]
    if player == nil then
        return
    end
    local playerConfig = PlayerConfigurations[playerID]
    if playerConfig:GetLeaderTypeName() ~= BASIL then
        return
    end
    local gpPoints = player:GetGreatPeoplePoints()
    if gpPoints == nil then
        return
    end
    local newTotal = gpPoints:GetPointsTotal(GENERAL_INDEX)
    local oldTotal = player:GetProperty("PROPERTY_GENERAL_TOTAL_POINT")
    local cost = 0
    if oldTotal == nil then
        cost = math.floor(newTotal / 2)
    else
        if newTotal < oldTotal then
            player:SetProperty("PROPERTY_GENERAL_TOTAL_POINT", gpPoints:GetPointsTotal(GENERAL_INDEX))
            return
        end
        cost = math.floor((newTotal - oldTotal) / 2)
    end
    -- 需要判断是否能够招募伟人，如果符合招募要求，则跳过减免，并在此次初始化
    local recruitCost, canRecruit = CanGetGreatPerson(playerID)
    if canRecruit and ((newTotal - cost) < recruitCost) then
        player:SetProperty("PROPERTY_GENERAL_TOTAL_POINT", gpPoints:GetPointsTotal(GENERAL_INDEX))
        return
    end
    gpPoints:ChangePointsTotal(GENERAL_INDEX, -cost)
    player:SetProperty("PROPERTY_GENERAL_TOTAL_POINT", gpPoints:GetPointsTotal(GENERAL_INDEX))
    player:GetTreasury():ChangeGoldBalance(cost * 20)
end

function OnDiplomacyDeclareWarBasil(p1, p2)
    SetBasilFoodModifier(p1)
    SetBasilFoodModifier(p2)
end

function OnDiplomacyMakePeaceBasil(p1, p2)
    SetBasilFoodModifier(p1)
    SetBasilFoodModifier(p2)
end

-- ===========================================================================
-- LEADER_WILHELMINA
-- ===========================================================================
-- function InitializeTradeWithWILHELMINA()
--     local WILHELMINA_NUM = 0
--     local pIDs = PlayerManager.GetAliveMajorIDs()
--     for _, playerID in ipairs(pIDs) do
--         local player = Players[playerID]
--         local playerConfig = PlayerConfigurations[playerID]
--         if player ~= nil and playerConfig ~= nil and playerConfig:GetLeaderTypeName() == WILHELMINA then
--             WILHELMINA_NUM = WILHELMINA_NUM + 1
--         end
--     end
-- end
-- 计算威廉明娜被宣战后经过的回合数
function DiplomacyDeclareWarTurnCount(playerID, params)
    local declareWarPlayerID = params.DeclareWarPlayerID
    local player = Players[declareWarPlayerID]
    if player == nil or not player:IsAlive() then
        return
    end
    player:SetProperty("DiplomacyDeclareWarTurn", 0)
    OnPlayerTurnStarted(declareWarPlayerID)
end

-- 刷新玩家从郁金香获得的信仰
function RefreshPlayerTulipaCount()
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        OnPlayerResourceChanged(playerID, RESOURCE_TULIPA_INDEX)
    end
end

function OnPlayerResourceChanged(ownerPlayerID, resourceTypeID)
    if resourceTypeID == RESOURCE_TULIPA_INDEX then
        local player = Players[ownerPlayerID]
        if player == nil then
            return
        end
        local resources = player:GetResources()
        if resources ~= nil and
            resources:HasResource(RESOURCE_TULIPA_INDEX) and
            PlayerConfigurations[ownerPlayerID]:GetCivilizationTypeName() == NETHERLANDS then
            local tulipaNum = resources:GetResourceAmount(RESOURCE_TULIPA_INDEX)
            -- print("tulipaNum = ", tulipaNum)
            local cCity = player:GetCities():GetCapitalCity()
            local cPlot = cCity:GetPlot()
            if cPlot ~= nil then
                for i = 1, TULIPA_NUM_MAX do
                    cPlot:SetProperty("PROPERTY_TULIPA_" .. i, nil)
                end
                cPlot:SetProperty("PROPERTY_TULIPA_" .. tulipaNum, 1)
            end
        end
    end
end

function OnPlayerTurnStarted(playerID)
    local pPlayer = Players[playerID]
    if not (pPlayer:IsMajor() and pPlayer:IsAlive()) then
        return
    end
    local playerConfig = PlayerConfigurations[playerID]
    if playerConfig:GetLeaderTypeName() == WILHELMINA then
        local diplomacyDeclareWarTurn = pPlayer:GetProperty("DiplomacyDeclareWarTurn")
        if diplomacyDeclareWarTurn == nil then
            return
        end
        if diplomacyDeclareWarTurn ~= -1 then
            if diplomacyDeclareWarTurn < DIPLOMACY_DECLARE_WAR_TURN then
                diplomacyDeclareWarTurn = diplomacyDeclareWarTurn + 1
            else
                diplomacyDeclareWarTurn = -1
            end
        end
        pPlayer:SetProperty("DiplomacyDeclareWarTurn", diplomacyDeclareWarTurn)
        for _, city in pPlayer:GetCities():Members() do
            local cityPlot = city:GetPlot()
            if cityPlot ~= nil then
                cityPlot:SetProperty("PROPERTY_DIPLOMACY_DECLARE_WAR_MODIFIER",
                    diplomacyDeclareWarTurn ~= -1 and 1 or nil)
            end
        end
        print(playerID, pPlayer:GetProperty("DiplomacyDeclareWarTurn"))
    end
end

function OnTradeRouteAddedToMap(playerID, x, y)
    -- print('OnTradeRouteAddedToMap', playerID, x, y)
end

function OnTradeRouteRemovedFromMap(playerID, x, y)
    -- print('OnTradeRouteRemovedFromMap', playerID, x, y)
end

-- ===========================================================================
-- LEADER_HARDRADA
-- ===========================================================================
-- 单位死亡时基于信仰值
function OnUnitDamageChangedGainFaith(playerID, unitID, lostHealth, prevLostHealth)
    local playerConfig = PlayerConfigurations[playerID]
    -- local pUnit = UnitManager.GetUnit(playerID, unitID)
    if playerConfig == nil or playerConfig:GetLeaderTypeName() ~= "LEADER_HARDRADA" then
        return
    end
    if lostHealth == 100 then
        local religion = Players[playerID]:GetReligion()
        if religion ~= nil then
            religion:ChangeFaithBalance(9)
            -- Game.AddWorldViewText(0, Locale.Lookup("LOC_VALHALLA_UNIT_SACRIFICED", GameInfo.Units[pUnit:GetType()].Name, 9), pUnit:GetX(), pUnit:GetY())
        end
    end
end

-- 创建英雄单位时赋予能力
function OnUnitAddedToMapHero(playerID, unitID)
    local player = Players[playerID]
    if not player:IsMajor() then
        return
    end
    local unit = UnitManager.GetUnit(playerID, unitID)
    if unit == nil or not unit:IsHero() then
        return
    end
    local pUnitAbility = unit:GetAbility();
    if pUnitAbility == nil then
        return
    end
    local iCurrentCount = pUnitAbility:GetAbilityCount("ABILITY_EARLY_OCEAN_NAVIGATION_HERO");
    local iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
    if PlayerConfigurations[playerID]:GetLeaderTypeName() == 'LEADER_HARDRADA' then
        iChange = iChange + 1
    end
    pUnitAbility:ChangeAbilityCount("ABILITY_EARLY_OCEAN_NAVIGATION_HERO", iChange);
end

-- ===========================================================================
-- INITALIZE
-- ===========================================================================
function Initialize()
    -- GameEvents.AttachTradeModifiers.Add(AttachTradeModifiers)
    -- Events.TradeRouteAddedToMap.Add(OnTradeRouteAddedToMap)
    -- Events.TradeRouteRemovedFromMap.Add(OnTradeRouteRemovedFromMap)
    if ExposedMembers.PurpleSoul.Utils.IsCivilizationInGame('CIVILIZATION_BYZANTIUM') then
        -- Events.UnitAddedToMap.Add(OnUnitAddedToMapAfterFoundedReligion)
        Events.ReligionFounded.Add(OnReligionFounded)
    end
    if ExposedMembers.PurpleSoul.Utils.IsLeaderInGame('LEADER_BASIL') then
        InitializeWarWithBasil()
        Events.GreatPeoplePointsChanged.Add(OnGreatPeoplePointsChanged)
        Events.DiplomacyDeclareWar.Add(OnDiplomacyDeclareWarBasil)
        Events.DiplomacyMakePeace.Add(OnDiplomacyMakePeaceBasil)
    end
    if ExposedMembers.PurpleSoul.Utils.IsLeaderInGame('LEADER_HARDRADA') then
        Events.UnitDamageChanged.Add(OnUnitDamageChangedGainFaith)
        Events.UnitAddedToMap.Add(OnUnitAddedToMapHero)
    end
    if ExposedMembers.PurpleSoul.Utils.IsLeaderInGame(WILHELMINA) then
        RefreshPlayerTulipaCount()
        Events.PlayerResourceChanged.Add(OnPlayerResourceChanged)
        GameEvents.PlayerTurnStarted.Add(OnPlayerTurnStarted)
        GameEvents.DiplomacyDeclareWarTurnCount.Add(DiplomacyDeclareWarTurnCount)
    end
end

Events.LoadGameViewStateDone.Add(Initialize);
