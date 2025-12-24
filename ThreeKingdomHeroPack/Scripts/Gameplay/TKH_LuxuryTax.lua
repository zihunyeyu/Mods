-- TKH_GameUpdateScripts
-- Author: PurpleSoul
-- DateCreated: 2/23/2025 1:01:21 AM
--------------------------------------------------------------

include('TKH_Helper')


-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
local UNIT_COST_POPULATION = GameConfiguration.GetValue("UNIT_COST_POPULATION")
local LUXURY_TAX_MODE = GameConfiguration.GetValue("LUXURY_TAX_MODE")
local LUXURY_TAX_MODE_CITY = GameConfiguration.GetValue("LUXURY_TAX_MODE_CITY")
-- 战斗单位消耗人口
local COMBAT_UNIT_POPULATION_COST = 2

-- 生产军事单位时该城市减少1人口
function OnCityProductionCompleted(playerID, cityID, productionType, productionIndex, wasCancelled)
    -- 0: unit
    -- 1: building
    -- 2:district
    if productionType ~= 0 then
        return
    end

    local unitInfo = GameInfo.Units[productionIndex]
    if unitInfo.FormationClass ~= 'FORMATION_CLASS_CIVILIAN' then
        local city = CityManager.GetCity(playerID, cityID)
        local cityPopulation = city:GetPopulation()
        if cityPopulation >= (COMBAT_UNIT_POPULATION_COST + 1) and Players[playerID]:IsHuman() then
            city:ChangePopulation(-COMBAT_UNIT_POPULATION_COST)
        end
    end
end

function OnCityMadePurchase(playerID, cityID, X, Y, eventSubType, purchasableItemIndex)
    -- Purchasetype
    if eventSubType == EventSubTypes.UNIT then
        print('OnCityMadePurchase: ', playerID, cityID, X, Y, eventSubType, purchasableItemIndex)
        local unitInfo = GameInfo.Units[purchasableItemIndex]
        if unitInfo.FormationClass ~= 'FORMATION_CLASS_CIVILIAN' then
            local city = CityManager.GetCity(playerID, cityID)
            local cityPopulation = city:GetPopulation()
            if cityPopulation >= 2 and Players[playerID]:IsHuman() then
                city:ChangePopulation(-1)
            end
        end
    end
end

function RefreshLuxuryTaxDebuff(playerID, isBroken)
    local player = Players[playerID]
    local units = player:GetUnits()
    local cities = player:GetCities()

    if LUXURY_TAX_MODE and units ~= nil then
        for _, unit in units:Members() do
            local unitAbilities = unit:GetAbility()
            if unitAbilities ~= nil then
                local iCurrentCount = unitAbilities:GetAbilityCount("ABILITY_TKH_BROKEN");
                local iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
                if isBroken then
                    unitAbilities:ChangeAbilityCount("ABILITY_TKH_BROKEN", iChange + 1)
                else
                    unitAbilities:ChangeAbilityCount("ABILITY_TKH_BROKEN", iChange)
                end
            end
        end
    end

    if LUXURY_TAX_MODE_CITY and cities ~= nil then
        for _, city in cities:Members() do
            local plot = Map.GetPlot(city:GetX(), city:GetY())
            local property = 0
            if isBroken then
                property = 1
            end
            plot:SetProperty('PROPERTY_LUXURY_TAX_CITY_BROKEN', property)
        end
    end
end

-- CostLuxuryTax
function CostLuxuryTax(playerID, params)
    local player = Players[playerID]
    local treasury = player:GetTreasury()
    local balance = treasury:GetGoldBalance()

    local luxuryTax = 0

    if LUXURY_TAX_MODE then
        luxuryTax = luxuryTax + CalculateLuxuryTaxUnits(playerID)
    end
    if LUXURY_TAX_MODE_CITY then
        luxuryTax = luxuryTax + CalculateLuxuryTaxCities(playerID)
    end

    if balance > luxuryTax then
        treasury:ChangeGoldBalance(-luxuryTax)
        RefreshLuxuryTaxDebuff(playerID, false)
    else
        treasury:ChangeGoldBalance(-luxuryTax)
        RefreshLuxuryTaxDebuff(playerID, true)

        if LUXURY_TAX_MODE then
            local cityID = params.CityID
            local loyaltyNum = params.Loyalty
            local city = CityManager.GetCity(playerID, cityID)
            if city ~= nil then
                if loyaltyNum <= 20 then
                    CityManager.TransferCityToFreeCities(city)
                else
                    city:ChangeLoyalty(-25)
                end
            end
        end
    end
end

function Initialize()
    if UNIT_COST_POPULATION then
        Events.CityProductionCompleted.Add(OnCityProductionCompleted)
    end
    GameEvents.CostLuxuryTax.Add(CostLuxuryTax)

    Events.CityMadePurchase.Add(OnCityMadePurchase)
end

Events.LoadGameViewStateDone.Add(Initialize)
