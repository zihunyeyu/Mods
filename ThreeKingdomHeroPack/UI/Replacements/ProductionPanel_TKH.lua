-- ProductionPanel_TKH
-- Author: PurpleSoul
-- DateCreated: 3/3/2025 7:54:56 PM
--------------------------------------------------------------
---OFFICIAL
include("ProductionPanel");
include("ProductionPanel_Babylon_Heroes");
---MOD
include("TKH_Constant")
include("TKH_Helper")

TKH_GetData = GetData


local UNIT_LIMIT_MODE = GameConfiguration.GetValue("UNIT_LIMIT_MODE")
local AI_UNIT_LIMIT_AMOUNT = GameConfiguration.GetValue("AI_UNIT_AMOUNT_LIMIT")

function GetData()
    local playerID = Game.GetLocalPlayer();
    local pPlayer  = Players[playerID];
    if (pPlayer == nil) then
        Close();
        return nil;
    end

    -- local new_data = {
    -- 	City				= pSelectedCity,
    -- 	Population			= pSelectedCity:GetPopulation(),
    -- 	Owner				= pSelectedCity:GetOwner(),
    -- 	Damage				= pPlayer:GetDistricts():FindID( pSelectedCity:GetDistrictID() ):GetDamage(),
    -- 	TurnsUntilGrowth	= cityGrowth:GetTurnsUntilGrowth(),
    -- 	CurrentTurnsLeft	= buildQueue:GetTurnsLeft(),
    -- 	FoodSurplus			= cityGrowth:GetFoodSurplus(),
    -- 	CulturePerTurn		= cityCulture:GetCultureYield(),
    -- 	TurnsUntilExpansion = cityCulture:GetTurnsUntilExpansion(),
    -- 	DistrictItems		= {},
    -- 	BuildingItems		= {},
    -- 	UnitItems			= {},
    -- 	ProjectItems		= {},
    -- 	BuildingPurchases	= {},
    -- 	UnitPurchases		= {},
    -- 	DistrictPurchases	= {},
    -- };


    local new_data = TKH_GetData()
    local pCity = new_data.City
    -- =====================MODIFIER=====================
    local districtItems = new_data.DistrictItems
    if districtItems ~= nil then
        for _, pItem in ipairs(districtItems) do
            if pItem.Type == 'DISTRICT_ENCAMPMENT' then
                local ENCAMPMENT_INDEX = GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index
                local pCityDistricts = pCity:GetDistricts()
                local hasEncampment = pCityDistricts ~= nil and pCityDistricts:HasDistrict(ENCAMPMENT_INDEX)
                if hasEncampment then
                    local encampment = pCityDistricts:GetDistrict(ENCAMPMENT_INDEX)
                    local compeleted = encampment and encampment:IsComplete()
                    if compeleted then
                        local cityName = Locale.Lookup(pCity:GetName())
                        local maxCount = GREAT_CITIES_ENCAMPMENT_COUNT[cityName] or 1
                        local count = 0
                        for _, pDistrict in pCityDistricts:Members() do
                            local pDistrictDef = GameInfo.Districts[pDistrict:GetType()];
                            if (pDistrictDef ~= nil) then
                                if pDistrictDef.Index == ENCAMPMENT_INDEX then
                                    count = count + 1
                                end
                            end
                        end
                        if count >= maxCount then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_MAX_DISTRICT_ENCAMPMENT_COUNT') .. "[ENDCOLOR]";
                        end
                    end
                end
            end
        end
    end

    -- 单位建造限制
    if pPlayer:IsHuman() and UNIT_LIMIT_MODE then
        local total_cities_num, total_units_num = GetPlayerCitiesAndNotCivilianUnitsNum(playerID)
        local allow_count_max = CAPITAL_MAX_UNIT_NUM + (total_cities_num - 1) * PER_CITY_MAX_UNIT_NUM
        local unitItems = new_data.UnitItems
        local newUnitItems = {}
        if unitItems ~= nil then
            for _, unitItem in ipairs(unitItems) do
                if not unitItem.Civilian and total_units_num >= allow_count_max then
                    unitItem.Disabled = true
                    unitItem.ToolTip = unitItem.ToolTip ..
                        "[NEWLINE][NEWLINE][COLOR:Red]" ..
                        Locale.Lookup('LOC_NOT_ALLOW_MORE_UNIT', total_units_num, allow_count_max) .. "[ENDCOLOR]";
                end
                table.insert(newUnitItems, unitItem)
            end
        end

        new_data.UnitItems = newUnitItems
    end

    -- AI单位建造限制
    if not pPlayer:IsHuman() and AI_UNIT_LIMIT_AMOUNT and AI_UNIT_LIMIT_AMOUNT > 0 then
        local total_cities_num, total_units_num = GetPlayerCitiesAndNotCivilianUnitsNum(playerID)
        local limit_count = total_cities_num * AI_UNIT_LIMIT_AMOUNT
        local unitItems = new_data.UnitItems
        local newUnitItems = {}
        if unitItems ~= nil then
            for _, unitItem in ipairs(unitItems) do
                if not unitItem.Civilian and total_units_num >= limit_count then
                -- if not unitItem.Civilian and total_units_num >= 0 then
                    unitItem.Disabled = true
                    -- unitItem.ToolTip = unitItem.ToolTip ..
                    --     "[NEWLINE][NEWLINE][COLOR:Red]" ..
                    --     Locale.Lookup('LOC_AI_NOT_ALLOW_MORE_UNIT', total_units_num, limit_count) .. "[ENDCOLOR]";
                end
                table.insert(newUnitItems, unitItem)
            end
        end

        new_data.UnitItems = newUnitItems
    end

    -- table.insert(new_data.ProjectItems, {
    --     Type				= row.ProjectType,
    --     Name				= row.Name,
    --     ToolTip				= sToolTip,
    --     Hash				= row.Hash,
    --     Kind				= row.Kind,
    --     TurnsLeft			= buildQueue:GetTurnsLeft( row.ProjectType ),
    --     Disabled			= isDisabled,
    --     Cost				= iProductionCost,
    --     Progress			= iProductionProgress,
    --     IsCurrentProduction = row.Hash == m_CurrentProductionHash,
    --     IsRepeatable		= row.MaxPlayerInstances ~= 1 and true or false,
    -- });

    -- 锻造铺项目
    if pPlayer:IsHuman() then
        local treasury = pPlayer:GetTreasury()
        local goldBalance = treasury:GetGoldBalance()
        local resources = pPlayer:GetResources()
        local horseAmount = resources:GetResourceAmount(RESOURCE_HORSES_INDEX)
        local ironAmount = resources:GetResourceAmount(RESOURCE_IRON_INDEX)

        local newProjectItems = {}
        local projectItems = new_data.ProjectItems

        local m_EquipmentAllocator = Game:GetProperty("EquipmentAllocator")

        if projectItems ~= nil then
            for _, pItem in ipairs(projectItems) do
                if pItem.Type == PROJECT_CREATE_EQUIPMENT_MOUNT then
                    local isProjectStarted = pCity:GetProperty(PROJECT_CREATE_EQUIPMENT_MOUNT)
                    if not isProjectStarted then
                        if goldBalance < CREATE_EQUIPMENT_GOLD_AMOUNT then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_ALLOW_PROJECT', ' [ICON_Gold] 金币') .. "[ENDCOLOR]";
                        end
                        if horseAmount < CREATE_EQUIPMENT_HORSES_AMOUNT then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_ALLOW_PROJECT', ' [ICON_RESOURCE_HORSES] 马资源') .. "[ENDCOLOR]";
                        end

                        if GetRemainEquipmentAmount(m_EquipmentAllocator, 'EQUIPMENT_MOUNT') == 0 then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_REMAIN_EQUIPMENT') .. "[ENDCOLOR]";
                        end
                    end
                elseif pItem.Type == PROJECT_CREATE_EQUIPMENT_WEAPON then
                    local isProjectStarted = pCity:GetProperty(PROJECT_CREATE_EQUIPMENT_WEAPON)
                    if not isProjectStarted then
                        if goldBalance < CREATE_EQUIPMENT_GOLD_AMOUNT then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_ALLOW_PROJECT', ' [ICON_Gold] 金币') .. "[ENDCOLOR]";
                        end
                        if ironAmount < CREATE_EQUIPMENT_IRON_AMOUNT then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_ALLOW_PROJECT', ' [ICON_RESOURCE_IRON] 铁资源') .. "[ENDCOLOR]";
                        end
                        local remainAmount =
                            GetRemainEquipmentAmount(m_EquipmentAllocator, 'EQUIPMENT_WEAPON') +
                            GetRemainEquipmentAmount(m_EquipmentAllocator, 'EQUIPMENT_ARMOR') +
                            GetRemainEquipmentAmount(m_EquipmentAllocator, 'EQUIPMENT_ARTIFACT')
                        if remainAmount == 0 then
                            pItem.Disabled = true
                            pItem.ToolTip = pItem.ToolTip ..
                                "[NEWLINE][NEWLINE][COLOR:Red]" ..
                                Locale.Lookup('LOC_NOT_REMAIN_EQUIPMENT') .. "[ENDCOLOR]";
                        end
                    end
                end
                table.insert(newProjectItems, pItem)
            end
        end
        new_data.ProjectItems = newProjectItems
    end

    -- =====================MODIFIER=====================

    return new_data
end
