-- ===========================================================================
-- INCLUDE
-- ===========================================================================


-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
Utils                                      = ExposedMembers.TKKIK.Utils;

local GOVERNOR_JIANGZEMIN_INDEX            = GameInfo.Governors['GOVERNOR_JIANGZEMIN'].Index
local GOVERNOR_JIANGZEMIN_MEC_CITIES_RANGE = 6
local GOVERNOR_JIANGZEMIN_MEC_CITIES_NUM   = 6
-- ===========================================================================
-- VARIABLES
-- ===========================================================================
local RCMA_INDEX                           = GameInfo.Buildings['BUILDING_RCMA'].Index
local RIKEN_INDEX                          = GameInfo.Buildings['BUILDING_RIKEN'].Index

local ERAS                                 = {}
for row in GameInfo.Eras() do
    ERAS[row.EraType] = row.ChronologyIndex
end

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================
function SetUniqueItemActive(pPlayerID, params)
    -- uniqueItems = {
    --     [playerID] = {Abilities, Units, .....}
    -- }
    local pPlayer = Players[pPlayerID]

    local function SetUniqueItemModifierAndProperty(iCity, itemType)
        iCity:AttachModifierByID("UNIQUE_" .. itemType)
        local iCityPlot = iCity:GetPlot()
        iCityPlot:SetProperty("UNIQUE_PROPERTY_" .. itemType, 1)
    end

    local capitalCity = pPlayer:GetCities():GetCapitalCity()

    local gainedDistricts = {}

    for _, itemsByType in pairs(params.UniqueItems) do
        local abilities    = itemsByType.Abilities
        local units        = itemsByType.Units
        local districts    = itemsByType.Districts
        local buildings    = itemsByType.Buildings
        local improvements = itemsByType.Improvements

        for _, districtInfo in ipairs(districts) do
            local district = GameInfo.Districts[districtInfo.Type]
            if district ~= nil then
                table.insert(gainedDistricts, district.DistrictType)
            end
        end

        for _, trait in ipairs(abilities) do
            local traitType = trait.TraitType
            local q = DB.Query("SELECT ModifierID FROM CCTraitsModifiers WHERE TraitType= ? ;", traitType)
            if q ~= nil and #q > 0 then
                for _, sql in ipairs(q) do
                    SetUniqueItemModifierAndProperty(capitalCity, sql.ModifierId)
                end
            end
        end

        for _, unit in ipairs(units) do
            SetUniqueItemModifierAndProperty(capitalCity, GameInfo.Units[unit.Type].UnitType)
        end

        for _, building in ipairs(buildings) do
            SetUniqueItemModifierAndProperty(capitalCity, GameInfo.Buildings[building.Type].BuildingType)
        end

        for _, improvement in ipairs(improvements) do
            SetUniqueItemModifierAndProperty(capitalCity, GameInfo.Improvements[improvement.Type].ImprovementType)
        end
    end

    pPlayer:SetProperty("GainedDistricts", gainedDistricts)
end

-- 金币购买生产力功能实现函数
function SpendGoldFinishProgressDXP(playerID, params)
    local pPlayer = Players[playerID]
    local pCity = CityManager.GetCity(playerID, params.iCityID)
    local pBuildQueue = pCity:GetBuildQueue()
    if pBuildQueue == nil then
        return nil;
    end

    local bInfo = params.bInfo
    if bInfo == nil then
        return
    end

    local extraGold = pPlayer:GetTreasury():GetGoldBalance() - bInfo.Cost * 3

    if (extraGold > 0) then
        pPlayer:GetTreasury():ChangeGoldBalance(-bInfo.Cost * 3)
        pBuildQueue:FinishProgress()
        pPlayer:SetProperty("sgfpCanUse", false)
    else
        local i, f = math.modf(-extraGold);
        if f > 0 then
            i = i + 1
        end
        Game.AddWorldViewText(0, Locale.Lookup("LOC_SGFP_NOT_ENOUGH_GOLD", bInfo.Name, i), pCity:GetX(), pCity:GetY())
    end
end

-- ===========================================================================
-- FUNCTIONS    GameEvents
-- ===========================================================================

-- 黄埔军校，创建非平民单位时加大将军点数
function OnCityProductionCompletedRMCA(playerID, cityID, orderType, unitType, canceled, typeModifier)
    if PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SUNZHONGSHAN" and orderType == 0 then
        return
    end

    local pCity = CityManager.GetCity(playerID, cityID)
    if pCity ~= nil and Utils.HasBuilding(playerID, cityID, RCMA_INDEX) then
        local cUnitInfo = GameInfo.Units[unitType]
        if cUnitInfo.FormationClass ~= "FORMATION_CLASS_CIVILIAN" then
            Utils.ChangeGreatPeoplePointsTotal(playerID, "GREAT_PERSON_CLASS_GENERAL", 5)
        end
    end
end

-- 黄埔军校，创建单位时添加TAG
function OnUnitAbilityGainedRMCA(iPlayerID, iUnitID, eAbilityType)
    if not Players[iPlayerID]:IsMajor() then
        return
    end

    local gUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
    if gUnit == nil then
        return
    end
    local abilityType = GameInfo.UnitAbilities[eAbilityType].UnitAbilityType
    local gUnitAbility = gUnit:GetAbility();

    if abilityType == "ABILITY_RCMA" then
        local iCurrentCount = gUnitAbility:GetAbilityCount("ABILITY_RCMA");
        local iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
        gUnitAbility:ChangeAbilityCount("ABILITY_RCMA", iChange);
        local rNum = Utils.GetRandomNumber(10)
        if rNum <= 5 then
            iCurrentCount = gUnitAbility:GetAbilityCount("ABILITY_RCMA_INCREASED_MOVEMENT");
            iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
            gUnitAbility:ChangeAbilityCount("ABILITY_RCMA_INCREASED_MOVEMENT", iChange + 1);
        else
            iCurrentCount = gUnitAbility:GetAbilityCount("ABILITY_RCMA_INCREASED_STRENGTH");
            iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
            gUnitAbility:ChangeAbilityCount("ABILITY_RCMA_INCREASED_STRENGTH", iChange + 1);
        end
    elseif abilityType == "ABILITY_GUNBU" then
        return
    end
end

-- ====================================

function SetGovernorModifier(gPlayerID, gCityID)
    local cityIDs = Utils.GetNearCitiesInRange(gPlayerID, gCityID, GOVERNOR_JIANGZEMIN_MEC_CITIES_RANGE)
    if cityIDs ~= nil then
        for _, city in Players[gPlayerID]:GetCities():Members() do
            local plot = city:GetPlot()
            local cityID = city:GetID()
            if Utils.IsInTable(cityIDs, cityID) then
                plot:SetProperty('PROPERTY_CITIER_NUMBER_MOORE_THEN5', #cityIDs)
                plot:SetProperty('PROPERTY_OFFER_GCITY_YIELDS2', #cityIDs)
            else
                plot:SetProperty('PROPERTY_CITIER_NUMBER_MOORE_THEN5', nil)
                plot:SetProperty('PROPERTY_OFFER_GCITY_YIELDS2', nil)
            end
        end
    end
end

function OnGovernorAssignedDXP(cityPlayerID, cityID, governorPlayerID, governorID)
    if governorID ~= GOVERNOR_JIANGZEMIN_INDEX then
        return
    end
    Players[cityPlayerID]:SetProperty('PROPERTY_JZM_ASSIGNED_CITY_ID', cityID)
    SetGovernorModifier(cityPlayerID, cityID)
end

function OnCityAddedToMapDXP(playerID, cityID, X, Y)
    local player = Players[playerID]
    local gCityID = player:GetProperty('PROPERTY_JZM_ASSIGNED_CITY_ID')
    if gCityID ~= nil then
        local gCity = CityManager.GetCity(playerID, gCityID)
        if gCity == nil then
            return
        end

        if Map.GetPlotDistance(gCity:GetX(), gCity:GetY(), X, Y) <= GOVERNOR_JIANGZEMIN_MEC_CITIES_RANGE then
            SetGovernorModifier(playerID, gCityID)
        end
    end
end

function OnCityRemovedFromMapDXP(playerID, cityID)
    -- 仅需判断移除城市为非总督所在城市即可
    -- 总督所在城市被移除后，modifier会一并消失
    local player = Players[playerID]
    local gCityID = player:GetProperty('PROPERTY_JZM_ASSIGNED_CITY_ID')
    if gCityID ~= nil and cityID ~= gCityID then
        SetGovernorModifier(playerID, gCityID)
    end
end

function OnCityConqueredDXP(newPlayerID, oldPlayerID, newCityID, cityX, cityY)
    local player = Players[oldPlayerID]
    local gCityID = player:GetProperty('PROPERTY_JZM_ASSIGNED_CITY_ID')
    local gCity = CityManager.GetCity(oldPlayerID, gCityID)
    if gCity ~= nil then
        SetGovernorModifier(oldPlayerID, gCityID)
    end
end

function OnCityProductionCompletedRIKEN(playerID, cityID, orderType, buildType, canceled, typeModifier)
    -- orderType 0: unit 1: building 2: district
    -- print('OnCityProductionCompletedRIKEN: ', playerID, cityID, orderType, buildType, canceled, typeModifier)
    if orderType ~= 1 or buildType ~= RIKEN_INDEX then
        return
    end

    local player = Players[playerID]

    local techs = player:GetTechs()
    local maxTechEra = -1
    local unlockTech = {}
    for row in GameInfo.Technologies() do
        if techs:HasTech(row.Index) then
            if maxTechEra <= ERAS[row.EraType] then
                maxTechEra = ERAS[row.EraType]
            end
        else
            table.insert(unlockTech, row.Index)
        end
    end

    local boostTriggered = {}
    local notBoostTriggered = {}

    for _, techIndex in ipairs(unlockTech) do
        local tech = GameInfo.Technologies[techIndex]
        if ERAS[tech.EraType] <= maxTechEra then
            -- table.insert(unlockAboveTech, tech)
            if not techs:HasBoostBeenTriggered(techIndex) then
                table.insert(notBoostTriggered, techIndex)
            else
                table.insert(boostTriggered, techIndex)
            end
        end
    end

    if boostTriggered ~= nil and notBoostTriggered ~= nil then
        if #notBoostTriggered > 0 then
            local randomIndex = notBoostTriggered[Utils.GetRandomNumber(#notBoostTriggered)]
            techs:TriggerBoost(randomIndex, 1)
        else
            if #boostTriggered > 0 then
                local randomIndex = boostTriggered[Utils.GetRandomNumber(#boostTriggered)]
                techs:SetResearchProgress(randomIndex, techs:GetResearchCost(randomIndex))
            end
        end
    end
end

-- ====================================

function OnLocalPlayerTurnBeginDXP()
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local pPlayer = Players[playerID]
        pPlayer:SetProperty("sgfpCanUse", true)
    end
end

function Initialize()
    if Utils.IsLeaderInGame("LEADER_SUNZHONGSHAN") then
        print('LEADER_SUNZHONGSHAN in game')
        Events.UnitAbilityGained.Add(OnUnitAbilityGainedRMCA)
        Events.CityProductionCompleted.Add(OnCityProductionCompletedRMCA)
    end
    if Utils.IsLeaderInGame("LEADER_DENGXIAOPING") then
        Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBeginDXP)
        GameEvents.SpendGoldFinishProgressDXP.Add(SpendGoldFinishProgressDXP)

        Events.GovernorAssigned.Add(OnGovernorAssignedDXP)
        Events.CityAddedToMap.Add(OnCityAddedToMapDXP)

        Events.CityRemovedFromMap.Add(OnCityRemovedFromMapDXP)
        GameEvents.CityConquered.Add(OnCityConqueredDXP)
    end

    if Utils.IsLeaderInGame('LEADER_HIROHITO') then
        print('LEADER_HIROHITO in game')
        Events.CityProductionCompleted.Add(OnCityProductionCompletedRIKEN)
    end
    GameEvents.SetUniqueItemActive.Add(SetUniqueItemActive)
end

Events.LoadGameViewStateDone.Add(Initialize);
