-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("TKH_Constant")
include("TKH_Helper")


-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

local m_iBarbarianID = 63; --蛮族的id
local m_iImpBarbCamp =
    GameInfo.Improvements["IMPROVEMENT_BARBARIAN_CAMP"].Index;

local BUILDING_HERO_MONUMENT_TKH_INDEX = -1

local m_WorldLordManager = {}


local DISTRICT_CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index
local PROJECT_UPGRADE_UNIT_PHANTA_RUISHI_INDEX = GameInfo.Projects['PROJECT_UPGRADE_UNIT_PHANTA_RUISHI'].Index
local PROJECT_UPGRADE_UNIT_PHANTA_YOUXIA_INDEX = GameInfo.Projects['PROJECT_UPGRADE_UNIT_PHANTA_YOUXIA'].Index
local FEATURE_MASH_INDEX = GameInfo.Features['FEATURE_MARSH'].Index
local FEATURE_MASH_DAMAGE = 20
local AI_INFERNO_MODE_FLEX_STRENGTH_MAX = 15

local SECONDARY_HERO_FULL_PROMOTED_ARMOR = 100
local s_Heroer = {}
for row in GameInfo.TKH_S_Heroes() do
    table.insert(s_Heroer, 'CLASS_UNIT_HERO_TKH_' .. row.Name)
end

-- ===========================================================================
--	Events
-- ===========================================================================

--- 维修城墙
function RepairCastleProject()
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local cities = player:GetCities()
        for _, city in cities:Members() do
            local buildQ = city:GetBuildQueue()
            if buildQ then
                local cB = buildQ:CurrentlyBuilding()
                if cB == 'PROJECT_REPAIR_CASTLE' then
                    -- buildQ:FinishProgress()
                    local districts = city:GetDistricts()
                    local center = districts:GetDistrict(DISTRICT_CITY_CENTER_INDEX)

                    local districtHitpoints = center:GetMaxDamage(DefenseTypes.DISTRICT_GARRISON);
                    local currentDistrictDamage = center:GetDamage(DefenseTypes.DISTRICT_GARRISON);
                    local wallHitpoints = center:GetMaxDamage(DefenseTypes.DISTRICT_OUTER);
                    local currentWallDamage = center:GetDamage(DefenseTypes.DISTRICT_OUTER);
                    local pYield = city:GetYield(YieldTypes.PRODUCTION)

                    if currentWallDamage == 0 then
                        buildQ:FinishProgress()
                    elseif currentWallDamage > 0 then
                        center:ChangeDamage(DefenseTypes.DISTRICT_OUTER, -(pYield / 2))
                        local treasury = player:GetTreasury()
                        treasury:ChangeGoldBalance(-(pYield * 2))

                        Game.AddWorldViewText(0, Locale.Lookup('LOC_REPAIR_CASTLE_RESULT', pYield, pYield * 2,
                            pYield / 2), city:GetX(), city:GetY())
                    end
                end
            end
        end
    end
end

--- TKH城市项目相关
---@param playerID integer
---@param cityID integer
---@param projectID integer
---@param buildingIndex integer
---@param X integer
---@param Y integer
---@param isCancelled boolean
function OnCityProjectCompleted(playerID, cityID, projectID, buildingIndex, X, Y, isCancelled)
    local player = Players[playerID]
    -- 锐士、游侠项目
    if projectID == PROJECT_UPGRADE_UNIT_PHANTA_YOUXIA_INDEX then
        player:AttachModifierByID('MODIFIER_YOUXIA_PROJECT_GRANT_ABILITY')
    elseif projectID == PROJECT_UPGRADE_UNIT_PHANTA_RUISHI_INDEX then
        player:AttachModifierByID('MODIFIER_RUISHI_PROJECT_GRANT_ABILITY')
    end
    -- 军备库项目
    local projectInfo = GameInfo.Projects[projectID]
    if string.match(projectInfo.ProjectType, 'PROJECT_TKH_EA_') then
        player:AttachModifierByID('MODIFIER_' .. projectInfo.ProjectType)
    end

    if projectInfo.ProjectType == 'PROJECT_TKH_EA_BINGFAERSHISIPIAN' then
        player:SetProperty('PROJECT_TKH_EA_BINGFAERSHISIPIAN', true)
    end
end

--- AI增强模式生成单位
function AiCreatUnitInferno()
    local turn = Game.GetCurrentGameTurn()
    if turn % 10 ~= 0 then
        return
    end

    local pAllPlayerIDs = PlayerManager.GetAliveIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil and not player:IsHuman() then
            -- +5马、+5铁
            -- local playerResources = player:GetResources()
            -- playerResources:ChangeResourceAmount(RESOURCE_IRON_INDEX, 5)
            -- playerResources:ChangeResourceAmount(RESOURCE_HORSES_INDEX, 5)

            local cities = player:GetCities()
            if cities == nil then
                return
            end
            local capCity = cities:GetCapitalCity()
            if capCity == nil then
                return
            end

            if turn % 10 == 0 then
                CreatUnitAtXY(pPlyerID, 'UNIT_CROSSBOWMAN', capCity:GetX(), capCity:GetY())
                CreatUnitAtXY(pPlyerID, 'UNIT_KNIGHT', capCity:GetX(), capCity:GetY())

                if turn % 30 == 0 then
                    CreatUnitAtXY(pPlyerID, 'UNIT_CAVALRY', capCity:GetX(), capCity:GetY())
                    CreatUnitAtXY(pPlyerID, 'UNIT_CUIRASSIER', capCity:GetX(), capCity:GetY())
                end
                if turn % 50 == 0 then
                    local UNIT_CAVALRY = CreatUnitAtXY(pPlyerID, 'UNIT_CAVALRY', capCity:GetX(), capCity:GetY())
                    if UNIT_CAVALRY ~= nil then
                        UNIT_CAVALRY:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION);
                    end
                    local UNIT_CUIRASSIER = CreatUnitAtXY(pPlyerID, 'UNIT_CUIRASSIER', capCity:GetX(), capCity:GetY())
                    if UNIT_CUIRASSIER ~= nil then
                        UNIT_CUIRASSIER:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION);
                    end
                end

                -- 每回合增加攻击力
                for _, unit in player:GetUnits():Members() do
                    unit:SetProperty("TKH_AI_INFERNO_MODE_FLEX_STRENGTH",
                        math.min(turn, AI_INFERNO_MODE_FLEX_STRENGTH_MAX))
                end
            end
        end
    end
end

--- 获取大城市PLOT PropertyKey
---@param cityName string
function GetGreatCityProperty(cityName)
    local level = nil
    local proeprty = nil
    local result = DB.Query("SELECT Level, PropertyKey from TKH_GreatCities where Name = ?", cityName)
    if result and #result > 0 then
        level = result[1].Level
        proeprty = result[1].PropertyKey
    end

    return level, proeprty
end

function RemoveGreatCityProperties(pCity)
    if not pCity then
        return
    end
    local plot = Map.GetPlot(pCity:GetX(), pCity:GetY())
    for row in GameInfo.TKH_GreatCities() do
        plot:SetProperty(row.PropertyKey, 0)
    end
end

function PlotHasUnit(playerID, pPlot)
    for loop, unit in ipairs(Units.GetUnitsInPlot(pPlot)) do
        if playerID ~= unit:GetOwner() then
            return unit:GetOwner()
        end
    end
    return -1
end

function InitializeGreatCity()
    -- print('InitializeGreatCity..............')
    local InitializeGreatCityFlag = Game:GetProperty('InitializeGreatCity') or 0
    if InitializeGreatCityFlag == 0 then
        local pAllPlayerIDs = PlayerManager.GetAliveIDs()
        for _, pPlyerID in ipairs(pAllPlayerIDs) do
            local player = Players[pPlyerID]
            if player ~= nil then
                local cities = player:GetCities()
                for _, city in cities:Members() do
                    RegisteGreatCity(pPlyerID, city:GetID())
                end
            end
        end

        Game:SetProperty('InitializeGreatCity', 1)
    else
        Events.TurnEnd.Remove(InitializeGreatCity)
    end
end

--- 注册大城市效果
---@param playerID number
---@param cityID number
function RegisteGreatCity(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)

    -- print('RegisteGreatCity = ', RegisteGreatCity, playerID, cityID, Locale.Lookup(city:GetName()))

    if city then
        RemoveGreatCityProperties(city)
        local cityName = Locale.Lookup(city:GetName())

        -- 注册大城市建造武僧
        -- if cityName == '阖闾' or cityName == '会稽' then
        --     city:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_TKH_BIG_CITY_BUY_MONK'].Index)
        -- else
        --     city:GetBuildQueue():RemoveBuilding(GameInfo.Buildings['BUILDING_TKH_BIG_CITY_BUY_MONK'].Index)
        -- end

        local cityLevel, pKey = GetGreatCityProperty(cityName)

        if cityLevel ~= nil and pKey ~= nil then
            local plot = Map.GetPlot(city:GetX(), city:GetY())
            plot:SetProperty(pKey, 1)
            if not Players[playerID]:IsHuman() then
                local RegisteGreatCityUnits = Game:GetProperty('RegisteGreatCityUnits') or {}
                local WorldUnitRecorder = Game:GetProperty('WorldUnitRecorder') or {}
                RegisteGreatCityUnits[cityName] = RegisteGreatCityUnits[cityName] or 0
                if RegisteGreatCityUnits[cityName] == 0 then
                    local cUnit = UnitManager.InitUnit(playerID, 'UNIT_CUIRASSIER', city:GetX(), city:GetY())
                    if cUnit then
                        if cityLevel == 1 then
                            cUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
                        elseif cityLevel == 2 then
                            cUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION)
                        end
                        cUnit:ChangeMovesRemaining(-cUnit:GetMovesRemaining())
                        table.insert(WorldUnitRecorder, { cUnit:GetOwner(), cUnit:GetID() })
                    end
                    local tNeighborPlots = Map.GetAdjacentPlots(city:GetX(), city:GetY())
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        local dUnit = UnitManager.InitUnit(playerID, 'UNIT_KNIGHT', pNeighborPlot:GetX(),
                            pNeighborPlot:GetY())
                        if dUnit then
                            if cityLevel == 1 then
                                dUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
                            elseif cityLevel == 2 then
                                dUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION)
                            end
                            dUnit:ChangeMovesRemaining(-dUnit:GetMovesRemaining())
                            table.insert(WorldUnitRecorder, { dUnit:GetOwner(), dUnit:GetID() })
                        end
                    end
                end
                RegisteGreatCityUnits[cityName] = 1
                Game:SetProperty('RegisteGreatCityUnits', RegisteGreatCityUnits)
                Game:SetProperty('WorldUnitRecorder', WorldUnitRecorder)
            end
        end
    end
end

--- 单位晋升
---@param playerID number
---@param unitID number
function OnUnitPromotionChanged(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType
    -- 老兵久经沙场,升级时增加属性
    local property = pUnit:GetProperty('COMBAT_STRENGTH_BY_PER_PROMOTION') or 0
    local specialUnitPromotedProperty = pUnit:GetProperty('SPECIAL_UNIT_COMBAT_DEFEND_STRENGTH_BY_PER_PROMOTION') or 0
    pUnit:SetProperty('COMBAT_STRENGTH_BY_PER_PROMOTION', math.min(property + 5, 30))
    pUnit:SetProperty('SPECIAL_UNIT_COMBAT_DEFEND_STRENGTH_BY_PER_PROMOTION', specialUnitPromotedProperty + 3)

    -- ===========FULL PROMOTED REWARD=============
    if pUnit:IsHero() then
        return
    end
    local exp = pUnit:GetExperience()
    local promotionClass = GameInfo.Units[pUnit:GetType()].PromotionClass
    local fullPromoted = true
    local promotionTimes = 0
    for row in GameInfo.UnitPromotions() do
        if row.PromotionClass == promotionClass then
            if not exp:HasPromotion(row.Index) then
                fullPromoted = false
            else
                promotionTimes = promotionTimes + 1
            end
        end
    end

    for _, tag in ipairs(NOT_FULL_PROMOTED_CLASS) do
        if MatchUnitTag(pUnitType, tag) and promotionTimes == NOT_FULL_PROMOTED_CLASS_TIMES then
            fullPromoted = true
            break
        end
    end

    if fullPromoted and not pUnit:GetProperty('IS_FULL_PROMOTED') then
        -- EXTRA ARMOR
        for _, ability in ipairs(FULL_PROMOTED_REWARD_ABILITIES) do
            AddAbilityForUnit(playerID, unitID, ability, true)
        end

        if MatchUnitTag(pUnitType, s_Heroer) then
            ChangeExtraMaxArmor(pUnit, SECONDARY_HERO_FULL_PROMOTED_ARMOR)
        end

        for tag, rewards in pairs(FULL_PROMOTED_REWARD) do
            if MatchUnitTag(pUnitType, tag) then
                for k, v in pairs(rewards) do
                    -- 额外护甲
                    if k == 'EXTRA_ARMOR' then
                        ChangeExtraMaxArmor(pUnit, v)
                        -- 额外恢复
                    elseif k == 'EXTRA_HEAL_TURNEND' then
                        local currentHeal = pUnit:GetProperty('EXTRA_HEAL_TURNEND') or 0
                        pUnit:SetProperty('EXTRA_HEAL_TURNEND', currentHeal + v)
                        -- 额外攻击几率
                    elseif k == 'EXTRA_CRIT_PERCENT' then
                        -- TKH_HeroEffectHandler.lua
                        -- function OnCombat(pCombatResult)
                        local currentPercent = pUnit:GetProperty('EXTRA_CRIT_PERCENT') or 0
                        pUnit:SetProperty('EXTRA_CRIT_PERCENT', currentPercent + v)
                        -- 额外伤害加成
                    elseif k == 'EXTRA_DAMAGE_BOUNS' then
                        local currentExtraDamage = pUnit:GetProperty('EXTRA_DAMAGE_BOUNS') or {}
                        table.insert(currentExtraDamage, v)
                        pUnit:SetProperty('EXTRA_DAMAGE_BOUNS', currentExtraDamage)
                    end
                end
                break
            end
        end

        pUnit:SetProperty('IS_FULL_PROMOTED', true)
    end
end

--- 老兵久经沙场,击杀时增加属性
---@param killedPlayerID number
---@param killedUnitID number
---@param playerID number
---@param unitID number
function OnUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local TOTAL_KILL = pUnit:GetProperty('TOTAL_KILL') or 0
    TOTAL_KILL = TOTAL_KILL + 1
    pUnit:SetProperty('TOTAL_KILL', TOTAL_KILL)
    pUnit:SetProperty('MELEES_UTNI_COMBAT_STRENGTH_BY_PER_KILL',
        math.min(MELEES_UTNI_COMBAT_STRENGTH_BY_PER_KILL_MAX, TOTAL_KILL))
    pUnit:SetProperty('SPECIAL_UNIT_COMBAT_STRENGTH_BY_PER_KILL',
        math.min(SPECIAL_UNIT_COMBAT_STRENGTH_BY_PER_KILL_MAX, TOTAL_KILL))
    pUnit:SetProperty('SECONDARY_HERO_COMBAT_STRENGTH_PER_KILL',
        math.min(SECONDARY_HERO_COMBAT_STRENGTH_PER_KILL_MAX, TOTAL_KILL))
end

function OnDeleteCityButtonClicked(playerID, params)
    local cityID = params.CityID
    local pCity = CityManager.GetCity(playerID, cityID)
    if pCity then
        Cities.DestroyCity(pCity)
        Players[playerID]:GetTreasury():ChangeGoldBalance(DELETE_CITY_EXCHANGE)
    end
end

function OnGreatPeoplePointsChanged(playerID)
    local player = Players[playerID]
    if player:IsHuman() then
        return
    end

    local playerGpp = player:GetGreatPeoplePoints()

    for row in GameInfo.GreatPersonClasses() do
        local gp = playerGpp:GetPointsTotal(row.Index)
        if (gp > 0) then
            playerGpp:ChangePointsTotal(row.Index, -gp)
        end
    end
end

function SetPropertyByAdjacentUnits(pUnit, key, bouns, tags, flag)
    local num = 0
    local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), 1)
    for _, adjUnit in ipairs(adjUnits) do
        if (adjUnit ~= nil) then
            local unitType = GameInfo.Units[adjUnit:GetType()].UnitType
            if MatchUnitTag(unitType, tags) then
                num = num + 1
                if flag then
                    SetPropertyByAdjacentUnits(adjUnit, key, bouns, tags)
                end
            end
        end
    end

    pUnit:SetProperty(key, num * bouns)
end

function SetPropertyByAdjacentUnitsUI(playerID, params)
    -- local index = params.Index
    local unitID = params.tUnitID
    local pUnit = UnitManager.GetUnit(playerID, unitID)

    if not pUnit then
        return
    end

    for _, value in ipairs(ADJACENT_UNIT) do
        if IsUnitHaveAbility(pUnit, value.ABILITY) then
            SetPropertyByAdjacentUnits(pUnit, value.KEY, value.BOUNS, value.TAGS)
        end
    end
end

function OnUnitMoveComplete(playerID, unitID, X, Y)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local plot = Map.GetPlot(X, Y)
    if not pUnit or not plot then
        return
    end

    for _, value in ipairs(ADJACENT_UNIT) do
        if IsUnitHaveAbility(pUnit, value.ABILITY) then
            SetPropertyByAdjacentUnits(pUnit, value.KEY, value.BOUNS, value.TAGS, true)
        end
    end
end

function OnTurnEndUnitEffectHandler()
    local pAllPlayerIDs = PlayerManager.GetAliveIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil then
            local units = player:GetUnits()
            for _, unit in units:Members() do
                if unit then
                    -- 沼泽伤害
                    if player:IsHuman() then
                        local plot = Map.GetPlot(unit:GetX(), unit:GetY())
                        if plot and plot:GetFeatureType() == FEATURE_MASH_INDEX then
                            if IsUnitHaveAbility(unit, 'ABILITY_MODIFIER_ABILITY_TKH_EQUIPMENT_SUIT_DADI4') then
                                TreatUnit(unit, 20)
                            elseif IsUnitHaveAbility(unit, 'ABILITY_UNITS_GAIN_DEBUFF_IN_MASH') then
                                DamageUnit(unit, FEATURE_MASH_DAMAGE)
                            end
                        end
                    end

                    -- 兵营增加单位经验
                    local pPlot = Map.GetPlot(unit:GetX(), unit:GetY())
                    if pPlot:GetOwner() == unit:GetOwner() and pPlot:GetDistrictType() == GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index then
                        -- 兵法二十四篇
                        if player:GetProperty('PROJECT_TKH_EA_BINGFAERSHISIPIAN') then
                            unit:GetExperience():ChangeExperience(6)
                        else
                            unit:GetExperience():ChangeExperience(3)
                        end
                        if unit:GetMovesRemaining() >= unit:GetMaxMoves() then
                            TreatUnit(unit, 10)
                        end
                    end

                    -- 满移动力恢复
                    if unit:GetMaxMoves() <= unit:GetMovesRemaining() then
                        TreatUnit(unit, 15)
                    end

                    -- 回合结束时恢复生命值或护甲值
                    -- 1. 技能点
                    local healPoint = unit:GetProperty(GameInfo.TKH_HeroKillPointSkill['HEAL'].PropertyKey) or 0
                    -- 2. 各种技能效果
                    healPoint = healPoint + (unit:GetProperty('TKH_TUEN_END_HEAL_VALUE') or 0)
                    if healPoint > 0 then
                        TreatUnit(unit, healPoint)
                    end
                end
            end
        end
    end
end

function CityProductionResource()
    local pAllPlayerIDs = PlayerManager.GetAliveIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil then
            local cities = player:GetCities()
            for _, city in cities:Members() do
                local cityName = Locale.Lookup(city:GetName())
                if GREAT_CITIES_RESOURCE[cityName] then
                    local cityResource = GREAT_CITIES_RESOURCE[cityName]
                    local resourceIndex = cityResource[1]
                    local reosuce = GameInfo.Resources[resourceIndex]
                    local resourceNum = cityResource[2]
                    player:GetResources():ChangeResourceAmount(resourceIndex, resourceNum)
                    Game.AddWorldViewText(0,
                        Locale.Lookup('LOC_GREAT_CITY_GAIN_RESOURCE', resourceNum, reosuce.ResourceType,
                            Locale.Lookup(reosuce.Name)),
                        city:GetX(), city:GetY())
                end
            end
        end
    end
end

function OnEquipmentUpdated(playerID, params)
    local eStatus = params.EquipmentStatus
    local player = Players[playerID]
    if eStatus == EQUIPMENT_STATUS.SOLD then
        player:GetTreasury():ChangeGoldBalance(EQUIPMENT_SOLD_PRICE)
    elseif eStatus == EQUIPMENT_STATUS.BUY then
        player:GetTreasury():ChangeGoldBalance(-EQUIPMENT_BUY_PRICE)
    elseif eStatus == EQUIPMENT_STATUS.TAKE_OFF then
        player:GetTreasury():ChangeGoldBalance(-TAKE_OFF_COST)
    end
end

function ChangeHeroSuitAbilities(playerID, params)
    local abilities = params.Abilities
    local unitID = params.UnitID
    local unit = UnitManager.GetUnit(playerID, unitID)
    local recorder = {}
    if unit then
        for ability, isGain in pairs(abilities) do
            if isGain then
                AddAbilityForUnit(playerID, unitID, ability, true)
                table.insert(recorder, ability)
            else
                RemoveAbilityFromUnit(playerID, unitID, ability, true)
            end
        end
    end

    unit:SetProperty('SuitAbilitiesRecorder', recorder)
end

--- 变化单位能力
---@param playerID any
---@param params any
function ChangeunitAbilities(playerID, params)
    local unitID = params.UnitID
    local status = params.Status
    local abilities = params.Abilities
    local unit = UnitManager.GetUnit(playerID, unitID)
    if unit then
        for _, ability in pairs(abilities) do
            if status == EQUIPMENT_STATUS.PUT_ON then
                AddAbilityForUnit(playerID, unitID, ability, true)
            elseif status == EQUIPMENT_STATUS.TAKE_OFF then
                RemoveAbilityFromUnit(playerID, unitID, ability, true)
            end
        end
    end
end

--- 变化玩家余额，最多减至0
---@param playerID number
---@param params table
function ChangePlayerBalance(playerID, params)
    local player = Players[playerID]
    local value = params.Value
    local reason = params.Reason
    if player then
        local treasury = player:GetTreasury()
        if treasury:GetGoldBalance() + value <= 0 then
            treasury:ChangeGoldBalance(-treasury:GetGoldBalance())
        else
            treasury:ChangeGoldBalance(value)
        end
    end
end

--- 变化玩家资源数量，最多减至0
---@param playerID number
---@param params table
function ChangePlayerResource(playerID, params)
    local player = Players[playerID]
    local value = params.Value
    local resourceTypeIndex = params.ResourceTypeIndex
    local reason = params.Reason
    if player then
        local resource = player:GetResources()
        if resource:GetResourceAmount(resourceTypeIndex) + value <= 0 then
            resource:ChangeResourceAmount(resourceTypeIndex, -resource:GetResourceAmount(resourceTypeIndex))
        else
            resource:ChangeResourceAmount(resourceTypeIndex, value)
        end
    end
end

function SetGameplayObjectProperty(playerID, params)
    local key = params.key
    local value = params.Value
    local otype = params.OType
    local oid = params.OID

    local _obj

    if otype == TKH_ObjectType.Player then
        _obj = Players[oid]
    elseif otype == TKH_ObjectType.City then
        _obj = CityManager.GetCity(playerID, oid)
    elseif otype == TKH_ObjectType.Unit then
        _obj = UnitManager.GetUnit(playerID, oid)
    elseif otype == TKH_ObjectType.Plot then
        _obj = Map.GetPlotByIndex(oid)
    elseif otype == TKH_ObjectType.Game then
        -- _obj = Game
        Game:SetProperty(key, value)
    end

    if _obj then
        _obj:SetProperty(key, value)
    end

    Players[playerID]:SetProperty('IsPropertyIsChanged', true)
end

function CreateHuangJingJun()
    local plots = GameConfiguration.GetValue('CreateUnitVlaidPlots')
    if plots then
        local length = HUANG_JING_ARMY.COUNT
        if #plots <= HUANG_JING_ARMY.COUNT then
            length = #plots
        end

        m_WorldLordManager = Game:GetProperty('m_WorldLordManager') or m_WorldLordManager


        math.randomseed(GetRandomSeed())
        for i = 1, length do
            local index = table.remove(plots, math.random(1, #plots))
            local plot = Map.GetPlotByIndex(index)
            if plot then
                local x, y = plot:GetX(), plot:GetY()
                local bossUnit = UnitManager.InitUnit(m_iBarbarianID, 'UNIT_CAVALRY', x, y)
                bossUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION);
                local bossUnitPlot = Map.GetPlot(bossUnit:GetX(), bossUnit:GetY())
                ImprovementBuilder.SetImprovementType(bossUnitPlot, m_iImpBarbCamp,
                    m_iBarbarianID)

                m_WorldLordManager['Units'] = m_WorldLordManager['Units'] or {}
                m_WorldLordManager['Rewards'] = m_WorldLordManager['Rewards'] or {}

                table.insert(m_WorldLordManager['Rewards'], bossUnitPlot:GetIndex())
                table.insert(m_WorldLordManager['Units'], bossUnit:GetID())

                local tNeighborPlots = Map.GetAdjacentPlots(bossUnit:GetX(), bossUnit:GetY());
                local counter = 6
                while counter ~= 0 do
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        local normalUnitTypes = { 'UNIT_CROSSBOWMAN', 'UNIT_MAN_AT_ARMS', 'UNIT_KNIGHT', 'UNIT_PIKEMAN' }
                        local normalUnit = UnitManager.InitUnit(m_iBarbarianID,
                            normalUnitTypes[math.random(1, #normalUnitTypes)], pNeighborPlot:GetX(),
                            pNeighborPlot:GetY())
                        if normalUnit then
                            counter = counter - 1
                            normalUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION);
                            table.insert(m_WorldLordManager['Units'], normalUnit:GetID())
                        end
                    end
                end
            end
        end

        Game:SetProperty('m_WorldLordManager', m_WorldLordManager)
        Game:SetProperty('IsHUANGJINGCreated', true)
        Events.TurnBegin.Remove(CreateHuangJingJun)
    end
end

function GameEventsCreateUnit(playerID, params)
    local pPlayerID = params.PlayerID
    local unitType = params.UnintType
    local x = params.X
    local y = params.Y
    local cUnit = UnitManager.InitUnit(pPlayerID, unitType, x, y)
end

--
function ReBuiltHeroMonument(playerID, cityID, X, Y)
    local player = Players[playerID]
    if player:IsHuman() then
        local pCity = CityManager.GetCity(playerID, cityID)
        if pCity then
            local buildings = pCity:GetBuildings()
            if buildings and buildings:HasBuilding(BUILDING_HERO_MONUMENT_TKH_INDEX) then
                buildings:RemoveBuilding(BUILDING_HERO_MONUMENT_TKH_INDEX)
            end
            -- buildings:CreateBuilding(BUILDING_HERO_MONUMENT_TKH_INDEX)
            local bStatus, sStatus = WorldBuilder.CityManager():CreateBuilding(pCity, BUILDING_HERO_MONUMENT_TKH_INDEX,
                100, Map.GetPlot(pCity:GetX(), pCity:GetY()));
        end
    end
end

function Initialize()
    m_WorldLordManager = Game:GetProperty('m_WorldLordManager') or m_WorldLordManager

    Events.TurnBegin.Add(InitializeGreatCity)
    Events.TurnBegin.Add(RepairCastleProject)
    Events.TurnBegin.Add(CityProductionResource)


    Events.TurnEnd.Add(OnTurnEndUnitEffectHandler)

    Events.CityProjectCompleted.Add(OnCityProjectCompleted)

    -- Great Cities(大城市功能)
    Events.CityAddedToMap.Add(RegisteGreatCity)
    Events.CityNameChanged.Add(RegisteGreatCity)

    Events.UnitPromoted.Add(OnUnitPromotionChanged)
    Events.UnitKilledInCombat.Add(OnUnitKilledInCombat)
    Events.UnitMoveComplete.Add(OnUnitMoveComplete)

    -- Custom GameEvents
    GameEvents.SetPropertyByAdjacentUnitsUI.Add(SetPropertyByAdjacentUnitsUI)
    GameEvents.OnDeleteCityButtonClicked.Add(OnDeleteCityButtonClicked)
    GameEvents.ChangePlayerResource.Add(ChangePlayerResource)
    GameEvents.ChangePlayerBalance.Add(ChangePlayerBalance)
    GameEvents.ChangeunitAbilities.Add(ChangeunitAbilities)
    GameEvents.ChangeHeroSuitAbilities.Add(ChangeHeroSuitAbilities)
    GameEvents.SetGameplayObjectProperty.Add(SetGameplayObjectProperty)


    if GameConfiguration.GetValue("TKH_AI_ENHANCE_MODE") and GameConfiguration.GetValue("TKH_AI_ENHANCE_MODE") ~= 0 then
        Events.TurnBegin.Add(AiCreatUnitInferno)
    end

    -- 每回合扣除AI伟人点数
    if GameConfiguration.GetValue("AI_BAN_GPP_MODE") then
        Events.GreatPeoplePointsChanged.Add(OnGreatPeoplePointsChanged)
    end

    -- 只有真人玩家可以召唤英雄 Monument
    if GameConfiguration.GetValue("ONLY_HUMAN_SUMMON_HERO_MODE") then
        BUILDING_HERO_MONUMENT_TKH_INDEX = GameInfo.Buildings['BUILDING_HERO_MONUMENT_TKH'].Index
        Events.CityAddedToMap.Add(ReBuiltHeroMonument)
    end
end

Events.LoadGameViewStateDone.Add(Initialize);
