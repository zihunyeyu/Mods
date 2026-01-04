-- TKH_UnitCommandDefs
-- Author: PurpleSoul
-- DateCreated: 2/13/2025 6:23:19 PM
--------------------------------------------------------------
include("TKH_Helper")
include("TKH_Constant")

-- ===========================================================================
--	Variables
-- ===========================================================================
m_TKH_UnitCommands = {};

-- ===========================================================================
--	BASE CHECK
-- ===========================================================================

function CheckCommandActions(pUnit, commandType)
    local actionCharges = pUnit:GetProperty('CustomCommandActionCharges') or {}
    local commandCharges = actionCharges[commandType]
    if not commandCharges or commandCharges[1] < 1 then
        return false
    else
        return true
    end
end

-- ===========================================================================
--	UNITCOMMAND_HEAL_UNIT
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT = {};
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT.EventName = nil
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_HEAL_UNIT') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_HEAL_UNIT.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_HEAL_UNIT') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end

    if (pUnit:GetMovesRemaining() == 0) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_MOVEMENT'
    end

    local isExist = IsExistHurtUnitInRangeX(pUnit, 2);
    if (isExist == false) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_TARGET';
    end

    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_EX_ACTION
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION = {};
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION.EventName = nil
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_EX_ACTION') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_EX_ACTION.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_EX_ACTION') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    if (pUnit:GetMovesRemaining() == 0) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_MOVEMENT'
    end
    local isExist = IsExistAttackedOrMovedUnitInRangeX(pUnit, 2);
    if (isExist == false) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_TARGET';
    end
    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_BURN_VOLCAND
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND = {};
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND.EventName = 'CommandBurnMountain'
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_BURN_VOLCAND') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BURN_VOLCAND.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_BURN_VOLCAND') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    if (pUnit:GetMovesRemaining() == 0) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_MOVEMENT'
    end
    -- local isExist = IsExistAttackedOrMovedUnitInRangeX(pUnit, 2);
    -- if (isExist == false) then
    --     return 'LOC_ACTION_DISABLE_TOOLTIP_NO_TARGET';
    -- end
    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_DEAL_DAMAGE
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE = {};
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE.EventName = nil
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE.CanUse = function(pUnit)
    if pUnit == nil then
        return false
    end
    local m_EquipmentManager = Game:GetProperty('EquipmentManager') or {}
    local e_wuzhang = m_EquipmentManager['EQUIPMENT_WuZhang']
    if e_wuzhang and e_wuzhang.HeroClassIndex ~= -1 and e_wuzhang.HeroClassIndex == pUnit:GetHeroClassType() then
        return true
    end
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_DEAL_DAMAGE') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE.IsDisabled = function(pUnit)
    local leftTurn = Game:GetProperty("WuZhangCoolTurns")

    if leftTurn > 0 then
        return Locale.Lookup('LOC_ACTION_DISABLE_TOOLTIP_LEFT_TURN', leftTurn);
    end

    local isExist = IsEnemyInRangeX(pUnit, 2);
    if (isExist == false) then
        return 'LOC_ACTION_DISABLE_TOOLTIP_NO_TARGET';
    end

    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_DEAL_DAMAGE_AOE
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE = {};
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE.EventName = 'CommandDealDamageAoe'
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE.CanUse = function(pUnit)
    if pUnit == nil then
        return false
    end
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_DEAL_DAMAGE_AOE') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_DEAL_DAMAGE_AOE.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_DEAL_DAMAGE_AOE') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end

    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_BUILD_ROUTE
-- ===========================================================================

m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.EventName = 'CommandBuildRoute'
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.CanUse = function(pUnit)
    local player = Players[pUnit:GetOwner()]
    if not player:GetCulture():HasCivic(CIVIC_FEUDALISM_INDEX) then
        return false
    end
    if pUnit == nil then
        return false
    end
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_BUILD_ROUTE') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.IsDisabled = function(pUnit)
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local routeType = plot:GetRouteType()

    -- 道路等级大于等于LV2，则无法继续提升
    if routeType >= CommandBuildRouteConstants.ROUTE_LEVEL_2 then
        return 'LOC_CAN_BUILD_ROUTE'
    end

    local player = Players[pUnit:GetOwner()]
    local playerResources = player:GetResources();
    local ironAmount = playerResources:GetResourceAmount(RESOURCE_IRON_INDEX)
    local balance = player:GetTreasury():GetGoldBalance()

    -- 道路等级大于等于LV1，提升为LV2
    if routeType >= CommandBuildRouteConstants.ROUTE_LEVEL_1 then
        if ironAmount < CommandBuildRouteConstants.ROUTE_LEVEL_2_IRON_AMOUNT then
            return 'LOC_IRON_NOT_ENOUGH'
        end

        if balance < CommandBuildRouteConstants.ROUTE_LEVEL_2_GOLD_AMOUNT then
            return 'LOC_GOLD_NOT_ENOUGH'
        end
    end

    if ironAmount < CommandBuildRouteConstants.ROUTE_LEVEL_1_IRON_AMOUNT then
        return 'LOC_IRON_NOT_ENOUGH'
    end

    if balance < CommandBuildRouteConstants.ROUTE_LEVEL_1_GOLD_AMOUNT then
        return 'LOC_GOLD_NOT_ENOUGH'
    end

    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_ROUTE.ResetDescription = function(pUnit)
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local routeType = plot:GetRouteType()
    if routeType < CommandBuildRouteConstants.ROUTE_LEVEL_1 then
        return Locale.Lookup('LOC_UNITCOMMAND_BUILD_ROUTE_HELP_1')
    elseif routeType < CommandBuildRouteConstants.ROUTE_LEVEL_2 then
        return Locale.Lookup('LOC_UNITCOMMAND_BUILD_ROUTE_HELP_2')
    else
        return Locale.Lookup('LOC_UNITCOMMAND_BUILD_ROUTE_HELP')
    end
end

-- ===========================================================================
--	UNITCOMMAND_CREATE_RESOURCE
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE = {};
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.EventName = 'CommandCreateRandomResource'
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_CREATE_RESOURCE') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_CREATE_RESOURCE') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end

    local improvementType = Map.GetPlot(pUnit:GetX(), pUnit:GetY()):GetImprovementType()
    if improvementType ~= -1 then
        return 'LOC_PLOT_HAS_IMPROVEMENT'
    end
    local districtType = Map.GetPlot(pUnit:GetX(), pUnit:GetY()):GetDistrictType()
    if districtType ~= -1 then
        return 'LOC_PLOT_HAS_DISTRICT'
    end
    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_RESOURCE.ResetDescription = function(pUnit)
    return GetCommandString(GetUnitType(pUnit), 'UNITCOMMAND_CREATE_RESOURCE')
end
-- ===========================================================================
--	UNITCOMMAND_BUILD_IMPROVEMENT
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT.EventName = 'CommandBuildImprovement'
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_BUILD_IMPROVEMENT') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_IMPROVEMENT.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_BUILD_IMPROVEMENT') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    local improvementType = Map.GetPlot(pUnit:GetX(), pUnit:GetY()):GetImprovementType()
    if improvementType ~= -1 then
        return 'LOC_PLOT_HAS_IMPROVEMENT'
    end
    local districtType = Map.GetPlot(pUnit:GetX(), pUnit:GetY()):GetDistrictType()
    if districtType ~= -1 then
        return 'LOC_PLOT_HAS_DISTRICT'
    end
    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_CHANGE_PLOT
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT = {};
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.EventName = 'CommandChangePlot'
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_CHANGE_PLOT') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_CHANGE_PLOT') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_CHANGE_PLOT.ResetDescription = function(pUnit)
    return GetCommandString(GetUnitType(pUnit), 'UNITCOMMAND_CHANGE_PLOT')
end

-- ===========================================================================
--	UNITCOMMAND_CREATE_UNIT
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT = {};
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.EventName = 'CommandCreateUnit'
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_CREATE_UNIT') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_CREATE_UNIT') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local units = Units.GetUnitsInPlot(plot)
    if #units > 1 then
        return 'LOC_PLOT_HAS_ANOTHER_UNIT'
    end
    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_CREATE_UNIT.ResetDescription = function(pUnit)
    return GetCommandString(GetUnitType(pUnit), 'UNITCOMMAND_CREATE_UNIT')
end

-- ===========================================================================
--	UNITCOMMAND_ENDOW_ABILITY
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY = {};
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.EventName = 'CommandEndowAbility'
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_ENDOW_ABILITY') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_ENDOW_ABILITY') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    local rUnits = GetPlotUnitsWithoutSelf(pUnit)
    if #rUnits ~= 1 then
        return 'LOC_VALID_UNIT_TAG'
    end

    local aUnit = rUnits[1]
    local unitInfo = GameInfo.Units[aUnit:GetType()]
    local unitType = unitInfo.UnitType

    if AbilityBannedUnitType[unitType] then
        return 'LOC_VALID_UNIT_TAG'
    end

    if unitInfo.FormationClass == 'FORMATION_CLASS_CIVILIAN' then
        return 'LOC_VALID_UNIT_TAG'
    end

    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType
    local arguments = {}
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        'UNITCOMMAND_ENDOW_ABILITY');
    if results then
        for _, row in ipairs(results) do
            arguments[row.Name] = row.Value
        end
    end

    -- 检测能力是否超出、是否已拥有相同能力
    local unitAbility = aUnit:GetAbility():GetAbilities()
    local tkh_ab_count = 0

    if (unitAbility ~= nil) then
        for _, ability in ipairs(unitAbility) do
            local abilityName = GameInfo.UnitAbilities[ability].UnitAbilityType
            if abilityName ~= nil then
                if abilityName == arguments.ABILITY then
                    return 'LOC_UNIT_ALREADY_HAVE_ABILITY'
                end
                if string.match(abilityName, 'ABILITY_TKH_GREATPEOPLE_') ~= nil then
                    tkh_ab_count = tkh_ab_count + 1
                end
            end
        end
        if tkh_ab_count >= 3 then
            return 'LOC_TOO_MUCH_ABILITIES'
        end
    end

    -- 检测能力合法单位类型（0：普通+英雄，1：普通，2：英雄）
    local untiHeroSuitable = arguments.UnitHero or 1
    local heroClass = aUnit:GetHeroClassType()
    if untiHeroSuitable == 1 and heroClass ~= -1 then
        return 'LOC_VALID_HERO_UNIT'
    end
    if untiHeroSuitable == 2 and heroClass == -1 then
        return 'LOC_VALID_NOT_HERO_UNIT'
    end

    -- 赋予单位不匹配时
    if arguments.Tags ~= nil then
        local tags = SplitString(arguments.Tags, ',')
        local isTargetUnit = false
        for _, tag in ipairs(tags) do
            local res =
                DB.Query("SELECT [Type], Tag from TypeTags where [Type] = ? and Tag = ?", unitInfo.UnitType, tag)
            if res and #res > 0 then
                isTargetUnit = true
            end
        end
        if not isTargetUnit then
            return 'LOC_VALID_UNIT_TAG'
        end
    end
    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_ENDOW_ABILITY.ResetDescription = function(pUnit)
    local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
    local gpType = GameInfo.GreatPersonIndividuals[greatPersonIndividualID].GreatPersonIndividualType
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ? and Name = ?",
        gpType, 'UNITCOMMAND_ENDOW_ABILITY', 'ABILITY');
    local ability = GameInfo.UnitAbilities[results[1].Value]
    if ability == nil then
        return nil
    end
    return Locale.Lookup('LOC_ENDOW_UNIT_ABILITY', Locale.Lookup(ability.Name), Locale.Lookup(ability.Description))
end

-- ===========================================================================
--	UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.EventName = 'CommandBuildDistrictEncampment'
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end
    local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    if pPlot ~= nil then
        local plotDistrict = pPlot:GetDistrictType()
        if plotDistrict ~= nil and plotDistrict ~= -1 then
            return 'LOC_TKH_PLOT_IS_DISTRICT'
        else
            local pCity = Cities.GetPlotPurchaseCity(pPlot)
            if pCity ~= nil then
                if pCity:GetOwner() ~= pUnit:GetOwner() then
                    return 'LOC_PLOT_IS_NOT_CITY'
                else
                    local ENCAMPMENT_INDEX = GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index
                    local pCityDistricts = pCity:GetDistricts()
                    local hasEncampment = pCityDistricts ~= nil and pCityDistricts:HasDistrict(ENCAMPMENT_INDEX)
                    if not hasEncampment then
                        return 'LOC_NO_DISTRICT_ENCAMPMENT_BUILT'
                    else
                        local encampment = pCityDistricts:GetDistrict(ENCAMPMENT_INDEX)
                        local compeleted = encampment and encampment:IsComplete()
                        if not compeleted then
                            return 'LOC_NO_DISTRICT_ENCAMPMENT_BUILT'
                        else
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
                                return 'LOC_MAX_DISTRICT_ENCAMPMENT_COUNT'
                            end

                            return nil
                        end
                    end
                end
            else
                return 'LOC_PLOT_IS_NOT_CITY'
            end
        end
    end

    return nil;
end
-- m_TKH_UnitCommands.UNITCOMMAND_BUILD_DISTRICT_ENCAMPMENT.ResetDescription = function(pUnit)
--     return GetCommandString(GetUnitType(pUnit), 'UNITCOMMAND_CHANGE_PLOT')
-- end

-- ===========================================================================
--	UNITCOMMAND_SELF_EXPLOSION
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION = {};
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION.EventName = 'CommandSelfExplosion'
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION.IsVisible = function(pUnit)
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION.CanUse = function(pUnit)
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_SELF_EXPLOSION') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_SELF_EXPLOSION.IsDisabled = function(pUnit)
    if not CheckCommandActions(pUnit, 'UNITCOMMAND_SELF_EXPLOSION') then
        return 'LOC_NO_ENOUGH_ACTION_CHARGES'
    end

    return nil;
end

-- ===========================================================================
--	UNITCOMMAND_ADD_BUFF
-- ===========================================================================
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF = {};
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.EventName = 'CommandAddBuff'
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.Properties = {};
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.IsVisible = function(pUnit)
    if pUnit:GetProperty("TKH_KILL_POINT_FINAL_SKILL_COOL_TURN") then
        return true
    end
    return BaseVisibleCheck(pUnit) and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.CanUse = function(pUnit)
    if pUnit:GetProperty("TKH_KILL_POINT_FINAL_SKILL_COOL_TURN") then
        return true
    end
    return IsUnitHasCommand(pUnit, 'UNITCOMMAND_ADD_BUFF') and pUnit:GetMovesRemaining() > 0
end
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.IsDisabled = function(pUnit)
    local coolTurn = pUnit:GetProperty("TKH_KILL_POINT_FINAL_SKILL_COOL_TURN")
    if coolTurn and coolTurn > 0 then
        return Locale.Lookup('LOC_ACTION_DISABLE_TOOLTIP_COOLING');
    end
    return nil;
end
m_TKH_UnitCommands.UNITCOMMAND_ADD_BUFF.ResetDescription = function(pUnit)
    local unitType = GameInfo.Units[pUnit:GetType()].UnitType
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?",
        unitType, 'UNITCOMMAND_ADD_BUFF')
    local ability
    local lastedTurn
    for _, result in ipairs(results) do
        if result.Name == 'LASTED_TURN' then
            lastedTurn = result.Value
        elseif result.Name == 'ABILITY' then
            ability = result.Value
        end
    end
    if ability == nil then
        return nil
    end
    local abilityInfo = GameInfo.UnitAbilities[ability]
    if abilityInfo == nil then
        return nil
    end

    local coolString = ''
    -- local coolTurn = pUnit:GetProperty("TKH_KILL_POINT_FINAL_SKILL_COOL_TURN")
    -- if coolTurn and coolTurn > 0 then
    --     coolString = coolString .. '(' .. Locale.Lookup('LOC_ACTION_DISABLE_TOOLTIP_LEFT_TURN', coolTurn) .. ')'
    -- end

    return Locale.Lookup('LOC_UNITCOMMAND_ADD_BUFF_HELP_EXTRA',
        string.gsub(Locale.Lookup(abilityInfo.Description), '。', ''),
        Locale.Lookup(lastedTurn), coolString)
end


for row in GameInfo.TKH_UnitCommands() do
    m_TKH_UnitCommands[row.CommandType].Icon = row.Icon
    m_TKH_UnitCommands[row.CommandType].ActionName = row.Description
    m_TKH_UnitCommands[row.CommandType].ActionDescription = row.Help
    m_TKH_UnitCommands[row.CommandType].VisibleInUI = row.VisibleInUI
    m_TKH_UnitCommands[row.CommandType].InterfaceMode = row.InterfaceMode
end
