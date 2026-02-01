include('TKH_Constant')
include('TKH_Helper')

local m_CommandRecover = {}

--- m_CommandRecover = m_CommandRecover[pUnit:GetOwner()],
-- { pUnit:GetID(), row.ActionCharges, row.RecoverType, row.CommandType }

local m_AbilityUnits = {}
local m_BuffManager = {}

--- 单位命令行动后，减少行动点数
---@param pUnit table
---@param commandType string
function AfterAction(pUnit, commandType)
    local actionCharges = pUnit:GetProperty('CustomCommandActionCharges') or {}
    local commandCharges = actionCharges[commandType]
    if not commandCharges or commandCharges[1] < 1 then
        return false
    end


    local remainCharges = commandCharges[1] - 1

    -- print('actionCharges = ', actionCharges, remainCharges)


    actionCharges[commandType][1] = remainCharges
    pUnit:SetProperty('CustomCommandActionCharges', actionCharges)

    --- 检测是否为伟人单位，如果为伟人单位，且行动点数为0，则死亡
    local totalActions = 0
    for _, chargeInfo in pairs(actionCharges) do
        totalActions = totalActions + chargeInfo[1]
    end

    if totalActions == 0 and IsCommandUnitGP(pUnit) then
        UnitManager.Kill(pUnit)
    end
end

-- ===========================================================================
-- EVENTS
-- ===========================================================================

--- 伟人单位创建时，设置行动点数
---@param playerID number
---@param unitID number
---@param greatPersonClassID number
---@param greatPersonIndividualID number
function OnUnitGreatPersonCreated(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local gpType = GameInfo.GreatPersonIndividuals[greatPersonIndividualID].GreatPersonIndividualType

    local actionCharges = {}

    for row in GameInfo.TKH_UnitTypeUnitCommands() do
        if gpType == row.UnitType then
            actionCharges[row.CommandType] = { row.ActionCharges, row.ActionCharges }
            if row.Recover then
                m_CommandRecover[pUnit:GetOwner()] = m_CommandRecover[pUnit:GetOwner()] or {}
                table.insert(m_CommandRecover[pUnit:GetOwner()],
                    { pUnit:GetID(), row.ActionCharges, row.RecoverType, row.CommandType })
            end
        end
    end

    pUnit:SetProperty('CustomCommandActionCharges', actionCharges)
    Game:SetProperty('CommandRecover', m_CommandRecover)
end

--- 单位创建时，注册能力
---@param playerID number
---@param unitID number
function OnUnitAddedToMap(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil then
        return
    end

    local unitType = GameInfo.Units[pUnit:GetType()].UnitType
    local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
    local gInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
    if not gInfo then
        local actionCharges = {}
        for row in GameInfo.TKH_UnitTypeUnitCommands() do
            if unitType == row.UnitType then
                actionCharges[row.CommandType] = { row.ActionCharges, row.ActionCharges }
                if row.Recover then
                    m_CommandRecover[pUnit:GetOwner()] = m_CommandRecover[pUnit:GetOwner()] or {}
                    table.insert(m_CommandRecover[pUnit:GetOwner()],
                        { pUnit:GetID(), row.ActionCharges, row.RecoverType, row.CommandType })
                end
            end
        end
        pUnit:SetProperty('CustomCommandActionCharges', actionCharges)
        Game:SetProperty('CommandRecover', m_CommandRecover)
    end
end

function OnTurnEnd()
    local dealDamageLeftTurn = Game:GetProperty("WuZhangCoolTurns")
    if dealDamageLeftTurn > 0 then
        dealDamageLeftTurn = dealDamageLeftTurn - 1
        Game:SetProperty("WuZhangCoolTurns", dealDamageLeftTurn)
    end

    -- GREAT PERSON EFFECT EVENTS
    if m_AbilityUnits == nil then
        return
    end

    for _, unitInfo in pairs(m_AbilityUnits) do
        local unit = UnitManager.GetUnit(unitInfo.PlayerID, unitInfo.UnitID)
        if unit ~= nil then
            if IsUnitHaveAbility(unit, 'ABILITY_TKH_GREATPEOPLE_HUA_TUO') then
                TreatUnit(unit, 30)
            end
        end
    end

    for unitType, buffInfo in pairs(m_BuffManager) do
        local pUnit = UnitManager.GetUnit(buffInfo.PlayerID, buffInfo.UnitID)
        if pUnit then
            local coolTurn = buffInfo.CoolTurn - 1
            if coolTurn == 0 then
                m_BuffManager[unitType] = nil
                pUnit:SetProperty('TKH_KILL_POINT_FINAL_SKILL_COOL_TURN', 0)
            end
            if coolTurn == buffInfo.LastedTurn then
                RemoveAbilityFromUnit(buffInfo.PlayerID, buffInfo.UnitID, buffInfo.Ability, true)
            end
            m_BuffManager[unitType].coolTurn = coolTurn
        else
            m_BuffManager[unitType] = nil
        end
    end

    Game:SetProperty('TKH_BuffManager', m_BuffManager)
end

--- 恢复单位命令行动点
---@param pUnit table
---@param commandType string
---@param commandBaseCharge number
---@param recoverTimes number
function RecoverUnitCommandAction(pUnit, commandType, recoverTimes, commandBaseCharge)
    local actionChargeManager = pUnit:GetProperty('CustomCommandActionCharges') or {}
    local extraAction = pUnit:GetProperty('ExtraActions') or {}
    local extra_action_info = extraAction[commandType]

    if actionChargeManager[commandType] then
        if recoverTimes == -1 then
            if extra_action_info then
                actionChargeManager[commandType][1] = tonumber(commandBaseCharge) + extra_action_info[2]
            else
                actionChargeManager[commandType][1] = tonumber(commandBaseCharge)
            end
        else
            actionChargeManager[commandType][1] = math.max(0, actionChargeManager[commandType][1] + recoverTimes)

            print('RecoverUnitCommandAction', commandType, recoverTimes, commandBaseCharge,
                actionChargeManager[commandType][1])
        end
    end

    pUnit:SetProperty('CustomCommandActionCharges', actionChargeManager)
end

--- 时代更替时恢复单位行动点
--- @param previousEraIndex integer
--- @param newEraIndex integer
function OnGameEraChanged(previousEraIndex, newEraIndex)
    for playerID, unitInfos in pairs(m_CommandRecover) do
        for i = #unitInfos, 1, -1 do
            local pUnit = UnitManager.GetUnit(playerID, unitInfos[i][1])
            if not pUnit then
                table.remove(unitInfos, i)
            else
                local recoverType = unitInfos[i][3]
                local commandBaseCharge = unitInfos[i][2]
                local commandType = unitInfos[i][4]

                if recoverType == CommandRecoverType.PER_ERA then
                    RecoverUnitCommandAction(pUnit, commandType, -1, commandBaseCharge)
                end
            end
        end
    end

    Game:SetProperty('CommandRecover', m_CommandRecover)
end

function OnTurnEnd_CommandRecovery()
    for playerID, unitInfos in pairs(m_CommandRecover) do
        for i = #unitInfos, 1, -1 do
            local pUnit = UnitManager.GetUnit(playerID, unitInfos[i][1])
            if not pUnit then
                table.remove(unitInfos, i)
            else
                local recoverType = unitInfos[i][3]
                local commandBaseCharge = unitInfos[i][2]
                local commandType = unitInfos[i][4]
                local propertyKey = playerID .. unitInfos[i][1] .. commandType
                if recoverType == CommandRecoverType.PROPERTY and pUnit:GetProperty(propertyKey) then
                    RecoverUnitCommandAction(pUnit, commandType, -1, commandBaseCharge)
                end
            end
        end
    end

    Game:SetProperty('CommandRecover', m_CommandRecover)
end

--- 回合开始时恢复单位行动点
function OnTurnBegin()
    for playerID, unitInfos in pairs(m_CommandRecover) do
        for i = #unitInfos, 1, -1 do
            local pUnit = UnitManager.GetUnit(playerID, unitInfos[i][1])
            if not pUnit then
                table.remove(unitInfos, i)
            else
                local recoverType = unitInfos[i][3]
                local commandBaseCharge = unitInfos[i][2]
                local commandType = unitInfos[i][4]

                if recoverType == CommandRecoverType.PER_TURN then
                    RecoverUnitCommandAction(pUnit, commandType, -1, commandBaseCharge)
                end
            end
        end
    end

    Game:SetProperty('CommandRecover', m_CommandRecover)
end

-- UNITCOMMAND_EX_ACTION
-- EXTRA ACTIONS FROM [CAOSHIHUWEI_CAO_CAO,YIMUTONGBAO_SUN_QUAN,NAN_MAN_RU_QIN_DUO_SI]


local ex_action_extra_ability = {
    ABILITY_MODIFIER_ABILITY_RELATIONSHIP_CAOSHIHUWEI_CAO_CAO = { 'UNITCOMMAND_EX_ACTION', EXTRA_ACTION_TYPE.MAX, 1 },
    ABILITY_MODIFIER_ABILITY_RELATIONSHIP_YIMUTONGBAO_SUN_QUAN = { 'UNITCOMMAND_EX_ACTION', EXTRA_ACTION_TYPE.MAX, 1 },
    ABILITY_MODIFIER_ABILITY_RELATIONSHIP_NAN_MAN_RU_QIN_DUO_SI = { 'UNITCOMMAND_EX_ACTION', EXTRA_ACTION_TYPE.MAX, 1 },
    ABILITY_MODIFIER_ABILITY_RELATIONSHIP_HEIBEITINGZHU_YUAN_SHAO = { 'UNITCOMMAND_EX_ACTION', EXTRA_ACTION_TYPE.MAX, 1 },
    ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_LV_LINGQI = { 'UNITCOMMAND_CREATE_UNIT', EXTRA_ACTION_TYPE.TEMP, 4 },
}

function OnUnitAbilityGained(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    -- 羁绊效果增加使用次数
    local ability = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType

    if ex_action_extra_ability[ability] == nil then
        return
    end
    local extra_action_info = ex_action_extra_ability[ability]

    local extraActions = pUnit:GetProperty('ExtraActions') or {}
    local commandType = extra_action_info[1]
    local extra_action_type = extra_action_info[2]
    local extra_action = extra_action_info[3]

    extraActions[commandType] = { extra_action_type, extra_action }
    pUnit:SetProperty('ExtraActions', extraActions)


    if extra_action_type == EXTRA_ACTION_TYPE.TEMP then
        RecoverUnitCommandAction(pUnit, commandType, extra_action, nil)
    end
end

function OnUnitAbilityLost(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local ability = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType
    if ex_action_extra_ability[ability] == nil then
        return
    end
    local extraActions = pUnit:GetProperty('ExtraActions') or {}
    extraActions[commandType] = nil
    pUnit:SetProperty('ExtraActions', extraActions)
end

-- ===========================================================================
-- COMMAND ACTIONS
-- ===========================================================================

function CommandChangePlot(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end
    local unitType = GetUnitType(pUnit)
    local changeType, changeItemIndex, changeItemName = GetCommandPlotChangeInfo(unitType, parameters.CommandType)

    if changeType and changeItemIndex ~= -1 then
        local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
        if changeType == 'TerrainType' then
            TerrainBuilder.SetTerrainType(plot, changeItemIndex)
            UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
            AfterAction(pUnit, parameters.CommandType)
        elseif changeType == 'FeatureType' then
            TerrainBuilder.SetFeatureType(plot, changeItemIndex)
            UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
            AfterAction(pUnit, parameters.CommandType)
        end
    end
end

function CommandChangeSelectedPlot(playerID, params)
    local plot = Map.GetPlot(params.iX, params.iY)
    local commandType = params.CommandType
    local unitID = params.UnitID
    local commandUnit = UnitManager.GetUnit(playerID, unitID)
    if plot == nil or commandUnit == nil then
        return
    end
    local movement = commandUnit:GetMovesRemaining()

    local changeType, changeItemIndex, changeItemName = GetCommandPlotChangeInfo(GetUnitType(commandUnit), commandType)
    if changeType and changeItemIndex ~= -1 then
        if changeType == 'TerrainType' then
            TerrainBuilder.SetTerrainType(plot, changeItemIndex)
            AfterAction(commandUnit, params.CommandType)
            UnitManager.ChangeMovesRemaining(commandUnit, -movement)
            UnitManager.ChangeMovesRemaining(commandUnit, movement)
        elseif changeType == 'FeatureType' then
            TerrainBuilder.SetFeatureType(plot, changeItemIndex)
            AfterAction(commandUnit, params.CommandType)
            UnitManager.ChangeMovesRemaining(commandUnit, -movement)
            UnitManager.ChangeMovesRemaining(commandUnit, movement)
        end
    end
end

-- 创建资源
function CommandCreateRandomResource(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end
    local resourceIndexes = GetCommandResourceIndex(GetUnitType(pUnit))
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    if table.count(resourceIndexes) > 0 then
        WorldBuilder.MapManager():SetResourceType(plot, GetRandomTableElement(resourceIndexes))
        UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
        AfterAction(pUnit, parameters.CommandType)
    else
        local resources = GetValidResources(plot:GetIndex())
        if resources ~= nil and #resources >= 1 then
            WorldBuilder.MapManager():SetResourceType(plot, GetRandomTableElement(resources))
            UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
            AfterAction(pUnit, parameters.CommandType)
        end
    end
end

-- 创建改良
function CommandBuildImprovement(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end

    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType

    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        parameters.CommandType)
    local improvementTypeIndex = -1
    -- local changeType = -1

    if results then
        for _, row in ipairs(results) do
            if row.Name == 'ImprovementType' then
                local improvement = GameInfo.Improvements[row.Value]
                if improvement then
                    improvementTypeIndex = improvement.Index
                end
            end
        end
    end

    if improvementTypeIndex ~= -1 then
        ImprovementBuilder.SetImprovementType(plot, improvementTypeIndex, eOwner)
        UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
        AfterAction(pUnit, parameters.CommandType)
    end
end

-- 创建单位
function CommandCreateUnit(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end
    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType

    local isGP = IsCommandUnitGP(pUnit)

    if isGP then
        local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
        local gInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
        pUnitType = gInfo.GreatPersonIndividualType
    end

    local sUnitType
    local count = 1
    local form

    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        parameters.CommandType)

    if results then
        for _, row in ipairs(results) do
            if row.Name == 'UnitType' then
                sUnitType = row.Value
            elseif row.Name == 'Count' then
                count = row.Value
            elseif row.Name == 'Form' then
                form = row.Value
            end
        end
    end

    if sUnitType ~= nil then
        for _ = 1, count do
            local cUnit = UnitManager.InitUnit(eOwner, sUnitType, pUnit:GetX(), pUnit:GetY())
            if cUnit ~= nil then
                if form == '1' then
                    cUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION)
                elseif form == '2' then
                    cUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
                end
                if isGP then
                    UnitManager.ChangeMovesRemaining(pUnit, -pUnit:GetMovesRemaining())
                else
                    UnitManager.ChangeMovesRemaining(pUnit, -1)
                end
                AfterAction(pUnit, parameters.CommandType)
            end
        end
    end
end

-- 赋予能力
function CommandEndowAbility(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end

    local targetUnit = GetPlotUnitsWithoutSelf(pUnit)[1]

    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType
    local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
    local gInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
    if gInfo then
        pUnitType = GameInfo.GreatPersonIndividuals[greatPersonIndividualID].GreatPersonIndividualType
    end

    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ? and Name = ?",
        pUnitType, 'UNITCOMMAND_ENDOW_ABILITY', 'ABILITY')

    if results then
        local tUnitAbility = targetUnit:GetAbility()
        tUnitAbility:ChangeAbilityCount(results[1].Value, 1)
        if m_AbilityUnits == nil then
            m_AbilityUnits = {}
        end
        table.insert(m_AbilityUnits, {
            PlayerID = targetUnit:GetOwner(),
            UnitID = targetUnit:GetID()
        })
        Game:SetProperty("TKH_AbilitiyUnits", m_AbilityUnits)
        AfterAction(pUnit, 'UNITCOMMAND_ENDOW_ABILITY')
    end
end

-- 治疗单位
function CommandHealUnit(eOwner, iUnitID, parameters)
    local success, pPlayer, pUnit, targetPlot = BaseCheck(eOwner, iUnitID, parameters)
    if not success or not pUnit then
        return false
    end

    for _, plotUnit in ipairs(Units.GetUnitsInPlot(targetPlot)) do
        if plotUnit and plotUnit:GetOwner() == pUnit:GetOwner() and IsUnitHurt(plotUnit) then
            TreatUnit(plotUnit, 30)
            AfterAction(pUnit, 'UNITCOMMAND_HEAL_UNIT')
            return true
        end
    end
    return false
end

-- 恢复移动力
function CommandRestoreExMove(eOwner, iUnitID, parameters)
    local success, pPlayer, pUnit, targetPlot = BaseCheck(eOwner, iUnitID, parameters)
    if not success or not pUnit then
        return false
    end

    local unit = UnitManager.GetUnit(eOwner, parameters['TargetUnitID'])
    if unit ~= nil then
        UnitManager.RestoreMovementToFormation(unit)
        UnitManager.RestoreUnitAttacks(unit)
        UnitManager.ChangeMovesRemaining(unit, 5)
        UnitManager.ChangeMovesRemaining(unit, -5)
        AfterAction(pUnit, 'UNITCOMMAND_EX_ACTION')
        return true
    end
    return false
end

-- 造成伤害
function CommandDealDamage(eOwner, iUnitID, parameters)
    local success, pPlayer, pUnit, targetPlot = BaseCheck(eOwner, iUnitID, parameters)
    if not success or not pUnit then
        return false
    end

    local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()
    for _, plotUnit in ipairs(Units.GetUnitsInPlot(targetPlot)) do
        if plotUnit ~= nil and diplomacy:IsAtWarWith(plotUnit:GetOwner()) then
            DamageUnit(plotUnit, EquipmentConstants.WU_ZHANG_DAMAGE)
            Game:SetProperty("WuZhangCoolTurns", 5)
            return true
        end
    end
end

function CommandDealDamageAoe(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return false
    end
    local unitType = GameInfo.Units[pUnit:GetType()].UnitType

    local x, y = pUnit:GetX(), pUnit:GetY()
    local range = 1
    local damage = nil
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?",
        unitType, 'UNITCOMMAND_DEAL_DAMAGE_AOE')

    local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()

    for _, result in ipairs(results) do
        if result.Name == 'Range' then
            range = tonumber(result.Value)
        elseif result.Name == 'Damage' then
            damage = tonumber(result.Value)
        end
    end

    if IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_PROMOTION_TK_WU_TUGU_1_4') then
        damage = 80
    end

    if not damage then
        print('ERROR: [COLOR:Red]此技能未设置伤害值[ENDCOLOR]')
        Game.AddWorldViewText(0, 'ERROR: [COLOR:Red]此技能未设置伤害值[ENDCOLOR]', x, y)
        return
    end


    local adjUnits = GetNeighborUnits(x, y, range)


    for _, adjUnit in ipairs(adjUnits) do
        if adjUnit and diplomacy:IsAtWarWith(adjUnit:GetOwner()) then
            DamageUnit(adjUnit, damage)
            if IsUnitHasPromotion(adjUnit, 'PROMOTION_TK_WU_TUGU_3_5') then
                local lostMoves = math.max(0, adjUnit:GetMovesRemaining() - 1)
                UnitManager.ChangeMovesRemaining(adjUnit, -lostMoves)
                Game.AddWorldViewText(0, '旋风斩：此单位损失了[COLOR:Red]' .. lostMoves .. '[ENDCOLOR]移动力', adjUnit:GetX(),
                    adjUnit:GetY())
            end
        end
    end

    AfterAction(pUnit, parameters.CommandType)
end

-- 火山爆发
function CommandBurnMountain(eOwner, iUnitID, parameters)
    -- local targetPlot = Map.GetPlot(parameters[UnitCommandTypes.PARAM_X], parameters[UnitCommandTypes.PARAM_Y])
    -- if targetPlot:IsMountain() then
    --     TerrainBuilder.SetFeatureType(targetPlot, GameInfo.Features['FEATURE_VOLCANO'].Index)
    --     local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    --     if pUnit then
    --         local unitPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    --         ApplyEvent(unitPlot:GetIndex(), GameInfo.RandomEvents['RANDOM_EVENT_DUST_STORM_HABOOB'].Index)
    --     end
    --     -- ApplyEvent(targetPlot:GetIndex(), GameInfo.RandomEvents['RANDOM_EVENT_VOLCANO_MEGACOLOSSAL'].Index)
    -- end

    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit then
        local unitPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
        -- ApplyEvent(unitPlot:GetIndex(), GameInfo.RandomEvents['RANDOM_EVENT_FLOOD_1000_YEAR'].Index)
    end
end

-- 造路
function CommandBuildRoute(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end

    local player = Players[pUnit:GetOwner()]
    local playerResources = player:GetResources()
    local ironAmount = playerResources:GetResourceAmount(CommandBuildRouteConstants.RESOURCE_IRON_INDEX)
    local balance = player:GetTreasury():GetGoldBalance()
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local routeType = plot:GetRouteType()

    if routeType < CommandBuildRouteConstants.ROUTE_LEVEL_1 then
        RouteBuilder.SetRouteType(plot, CommandBuildRouteConstants.ROUTE_LEVEL_1)
        playerResources:ChangeResourceAmount(CommandBuildRouteConstants.RESOURCE_IRON_INDEX,
            -CommandBuildRouteConstants.ROUTE_LEVEL_1_IRON_AMOUNT)
        player:GetTreasury():ChangeGoldBalance(-CommandBuildRouteConstants.ROUTE_LEVEL_1_GOLD_AMOUNT)
        pUnit:ChangeActionCharges(1)
        pUnit:ChangeMovesRemaining(-pUnit:GetMovesRemaining())
    elseif routeType < CommandBuildRouteConstants.ROUTE_LEVEL_2 then
        RouteBuilder.SetRouteType(plot, CommandBuildRouteConstants.ROUTE_LEVEL_2)
        playerResources:ChangeResourceAmount(CommandBuildRouteConstants.RESOURCE_IRON_INDEX,
            -CommandBuildRouteConstants.ROUTE_LEVEL_2_IRON_AMOUNT)
        player:GetTreasury():ChangeGoldBalance(-CommandBuildRouteConstants.ROUTE_LEVEL_2_GOLD_AMOUNT)
        pUnit:ChangeActionCharges(1)
        pUnit:ChangeMovesRemaining(-pUnit:GetMovesRemaining())
    end
end

-- 建造军营
function CommandBuildDistrictEncampment(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return
    end

    local x, y = pUnit:GetX(), pUnit:GetY()
    local pPlot = Map.GetPlot(x, y)
    local pCity = Cities.GetPlotPurchaseCity(pPlot)
    if pCity then
        WorldBuilder.CityManager():CreateDistrict(pCity, GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index, 100, pPlot);
    end
end

function CommandSelfExplosion(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return false
    end
    local x, y = pUnit:GetX(), pUnit:GetY()
    -- local pPlot = Map.GetPlot(x, y)
    local adjUnits = GetNeighborUnits(x, y, 1)
    for _, adjUnit in ipairs(adjUnits) do
        if adjUnit:GetOwner() ~= pUnit:GetOwner() or adjUnit:GetID() ~= pUnit:GetID() then
            -- return true
            Game.AddWorldViewText(0,
                Locale.Lookup("LOC_WORLD_DISTRICT_GARRISON_DAMAGE_INCREASE_FLOATER", -ExplosionDamage), adjUnit:GetX(),
                adjUnit:GetY())
            DamageUnit(adjUnit, ExplosionDamage)
        end
    end

    AfterAction(pUnit, 'UNITCOMMAND_SELF_EXPLOSION')
    return true
end

function CommandAddBuff(eOwner, iUnitID, parameters)
    local pUnit = UnitManager.GetUnit(eOwner, iUnitID)
    if pUnit == nil then
        return false
    end
    local unitType = GameInfo.Units[pUnit:GetType()].UnitType
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?",
        unitType, 'UNITCOMMAND_ADD_BUFF')
    local ability
    local lastedTurn
    for _, result in ipairs(results) do
        if result.Name == 'LASTED_TURN' then
            lastedTurn = tonumber(result.Value)
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

    pUnit:SetProperty('TKH_KILL_POINT_FINAL_SKILL_COOL_TURN', 1)
    AddAbilityForUnit(eOwner, iUnitID, abilityInfo.UnitAbilityType, true)

    local buffInfo = {
        PlayerID = eOwner,
        UnitID = iUnitID,
        Ability = abilityInfo.UnitAbilityType,
        CoolTurn = lastedTurn * 2,
        LastedTurn = lastedTurn
    }

    m_BuffManager[unitType] = buffInfo
    Game:SetProperty('TKH_BuffManager', m_BuffManager)
end

-- 移动到指定地点
function CommandTeleport(eOwner, iUnitID, parameters)
    local success, pPlayer, pUnit, targetPlot = BaseCheck(eOwner, iUnitID, parameters)
    if not success or not pUnit then
        return false
    end
    local move = pUnit:GetMovesRemaining()
    UnitManager.PlaceUnit(pUnit, parameters[UnitCommandTypes.PARAM_X], parameters[UnitCommandTypes.PARAM_Y])
    UnitManager.ChangeMovesRemaining(pUnit, move)
    AfterAction(pUnit, 'UNITCOMMAND_TKH_TELEPORT')
    return true
end

function Initialize()
    if Game:GetProperty("WuZhangCoolTurns") == nil then
        Game:SetProperty("WuZhangCoolTurns", 0)
    end
    m_CommandRecover = Game:GetProperty("CommandRecover") or {}
    m_AbilityUnits = Game:GetProperty("TKH_AbilitiyUnits") or {}
    m_BuffManager = Game:GetProperty('TKH_BuffManager') or {}
    Events.UnitGreatPersonCreated.Add(OnUnitGreatPersonCreated)
    Events.UnitAddedToMap.Add(OnUnitAddedToMap)
    Events.TurnEnd.Add(OnTurnEnd)
    Events.TurnEnd.Add(OnTurnEnd_CommandRecovery)
    Events.GameEraChanged.Add(OnGameEraChanged)
    Events.TurnBegin.Add(OnTurnBegin)

    -- 羁绊效果：曹氏护卫、一母同胞
    Events.UnitAbilityGained.Add(OnUnitAbilityGained)
    Events.UnitAbilityLost.Add(OnUnitAbilityLost)


    GameEvents.CommandHealUnit.Add(CommandHealUnit)
    GameEvents.CommandRestoreExMove.Add(CommandRestoreExMove)
    GameEvents.CommandDealDamage.Add(CommandDealDamage)
    GameEvents.CommandBuildRoute.Add(CommandBuildRoute)
    GameEvents.CommandCreateRandomResource.Add(CommandCreateRandomResource)
    GameEvents.CommandCreateUnit.Add(CommandCreateUnit)
    GameEvents.CommandEndowAbility.Add(CommandEndowAbility)
    GameEvents.CommandChangePlot.Add(CommandChangePlot)
    GameEvents.CommandChangeSelectedPlot.Add(CommandChangeSelectedPlot)
    GameEvents.CommandBurnMountain.Add(CommandBurnMountain)
    GameEvents.CommandBuildImprovement.Add(CommandBuildImprovement)
    GameEvents.CommandBuildDistrictEncampment.Add(CommandBuildDistrictEncampment)
    GameEvents.CommandSelfExplosion.Add(CommandSelfExplosion)
    GameEvents.CommandAddBuff.Add(CommandAddBuff)
    GameEvents.CommandDealDamageAoe.Add(CommandDealDamageAoe)
    GameEvents.CommandTeleport.Add(CommandTeleport)
end

Events.LoadGameViewStateDone.Add(Initialize)
