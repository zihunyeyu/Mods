-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("TKH_Constant")
include("TKH_Helper")


-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

local BUILDING_HERO_MONUMENT_TKH_INDEX = -1
local DISTRICT_CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index
local PROJECT_UPGRADE_UNIT_PHANTA_RUISHI_INDEX = GameInfo.Projects['PROJECT_UPGRADE_UNIT_PHANTA_RUISHI'].Index
local PROJECT_UPGRADE_UNIT_PHANTA_YOUXIA_INDEX = GameInfo.Projects['PROJECT_UPGRADE_UNIT_PHANTA_YOUXIA'].Index
local FEATURE_MASH_INDEX = GameInfo.Features['FEATURE_MARSH'].Index
local AI_INFERNO_MODE_FLEX_STRENGTH_MAX = 15

local SECONDARY_HERO_FULL_PROMOTED_ARMOR = 100
local s_Heroer = {}
for row in GameInfo.TKH_S_Heroes() do
    table.insert(s_Heroer, 'CLASS_UNIT_HERO_TKH_' .. row.Name)
end

local INFERNO_MODE = GameConfiguration.GetValue("TKH_AI_ENHANCE_MODE") and
    GameConfiguration.GetValue("TKH_AI_ENHANCE_MODE") ~= 0

-- ===========================================================================
--	Events
-- ===========================================================================

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

--- 移除大城市属性
---@param pCity City
function RemoveGreatCityProperties(pCity)
    if not pCity then
        return
    end
    local plot = Map.GetPlot(pCity:GetX(), pCity:GetY())
    for row in GameInfo.TKH_GreatCities() do
        plot:SetProperty(row.PropertyKey, 0)
    end
end

--- 召唤副将
---@param playerID integer
---@param cityID integer
function SummonSHero(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)
    local player = Players[playerID]
    if city then
        local cityName = Locale.Lookup(city:GetName())
        local s_heroes = S_HERO_SUMMON_CITY[cityName]
        if s_heroes then
            if type(s_heroes) == 'string' then
                local summoned = Game:GetProperty('SUMMONED_' .. s_heroes)
                if not summoned then
                    local cUnit = UnitManager.InitUnit(playerID, s_heroes, city:GetX(), city:GetY())
                    if cUnit and not player:IsHuman() then
                        cUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
                    end

                    Game:SetProperty('SUMMONED_' .. s_heroes, true)
                end
            elseif type(s_heroes) == 'table' then
                for _, sType in ipairs(s_heroes) do
                    local summoned = Game:GetProperty('SUMMONED_' .. sType)
                    if not summoned then
                        local cUnit = UnitManager.InitUnit(playerID, sType, city:GetX(), city:GetY())
                        if cUnit and not player:IsHuman() then
                            cUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
                        end

                        Game:SetProperty('SUMMONED_' .. sType, true)
                    end
                end
            end
        end
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
                        local currentHeal = pUnit:GetProperty('TKH_TUEN_END_HEAL_VALUE') or 0
                        pUnit:SetProperty('TKH_TUEN_END_HEAL_VALUE', currentHeal + v)
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
                    elseif K == 'EXTRA_DOOGE' then
                        pUnit:SetProperty('EXTRA_DOOGE', v)
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

--- 删除城市
---@param playerID integer
---@param params table|nil
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

--- 为相邻单位设置property
---@param pUnit Unit
---@param key string
---@param bouns integer
---@param tags string|table
---@param flag any
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
    local turn = Game.GetCurrentGameTurn()

    local pAllPlayerIDs = PlayerManager.GetAliveIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil then
            local diplomacy = player:GetDiplomacy()
            local units = player:GetUnits()


            for _, pUnit in units:Members() do
                local unitType = GetUnitType(pUnit)
                local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())

                -- =============HERO EFFECT=============
                -- 装备效果
                -- 1. 烈焰战锤(祝融专属)、火焱铠甲、烈焱神驹：1个单元格以内的敌方单位回合结束时受到20点伤害。
                local damage_bounes = aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_HuoYan'), 1, 0) +
                    aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanZhanChui'), 1, 0) +
                    aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanShenJu'), 1, 0) +
                    aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanZhanChui_HeroExclusive'), 1, 0)

                if damage_bounes > 0 then
                    -- 相邻格位上的敌军单位受到伤害
                    local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), 1)

                    for _, adjUnit in ipairs(adjUnits) do
                        if (adjUnit ~= nil and diplomacy:IsAtWarWith(adjUnit:GetOwner())) then
                            DamageUnit(adjUnit, 20 * damage_bounes)
                        end
                    end
                end

                -- 兀突骨技能冷却判断
                if unitType == 'UNIT_HERO_TKH_WU_TUGU' then
                    -- _singleUseAbilityCooldown = 10
                    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_WU_TUGU') then
                        pUnit:SetProperty(pPlyerID .. pUnit:GetID() .. 'UNITCOMMAND_DEAL_DAMAGE_AOE', true)
                    else
                        pUnit:SetProperty(pPlyerID .. pUnit:GetID() .. 'UNITCOMMAND_DEAL_DAMAGE_AOE', turn % 2 == 0)
                    end
                end
                -- =============HERO EFFECT=============



                -- 回合结束生命回复效果
                local healPoint = pUnit:GetProperty(GameInfo.TKH_HeroKillPointSkill['HEAL'].PropertyKey) or 0

                if player:IsHuman() then
                    -- 单位位于沼泽

                    if pPlot and pPlot:GetFeatureType() == FEATURE_MASH_INDEX then
                        if IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_TKH_EQUIPMENT_SUIT_DADI4') then
                            healPoint = healPoint + 20
                        end
                        if IsUnitHaveAbility(pUnit, 'ABILITY_UNITS_GAIN_DEBUFF_IN_MASH') then
                            if not IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_PROMOTION_TK_DUO_SI_3_5') then
                                healPoint = healPoint - 20
                            end
                        end
                    end
                else
                    -- 炼狱模式下，电脑单位每回合增加攻击力
                    if INFERNO_MODE then
                        pUnit:SetProperty("TKH_AI_INFERNO_MODE_FLEX_STRENGTH",
                            math.min(turn, AI_INFERNO_MODE_FLEX_STRENGTH_MAX))
                    end
                end
                -- 单位位于兵营
                if pPlot and pPlot:GetOwner() == pUnit:GetOwner() and GameInfo.Districts['DISTRICT_ENCAMPMENT'] and pPlot:GetDistrictType() == GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index then
                    -- 兵法二十四篇
                    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EA_ARMOR_BINGFAERSHISIPIAN') then
                        pUnit:GetExperience():ChangeExperience(6)
                    else
                        pUnit:GetExperience():ChangeExperience(3)
                    end
                    if pUnit:GetMaxMoves() <= pUnit:GetMovesRemaining() then
                        healPoint = healPoint + 10
                    end
                end


                -- 回合结束时恢复生命值或护甲值
                -- 1. 技能点
                -- 2. 各种技能效果
                -- 3. 满移动力恢复
                if pUnit:GetMaxMoves() <= pUnit:GetMovesRemaining() then
                    healPoint = healPoint + 15
                end

                healPoint = healPoint + (pUnit:GetProperty('TKH_TUEN_END_HEAL_VALUE') or 0)

                for promotion, value in pairs(TURN_END_HEAL_PROMOTION) do
                    if IsUnitHasPromotion(pUnit, promotion) then
                        healPoint = healPoint + value
                    end
                end

                -- print('healPoint = ', healPoint)

                if healPoint >= 0 then
                    TreatUnit(pUnit, healPoint)
                else
                    DamageUnit(pUnit, healPoint)
                end
            end
        end
    end
end

function CityTurnBeginEffectHandler()
    local isGreatCityInitialized = Game:GetProperty('InitializeGreatCity') or 0
    local turn = Game.GetCurrentGameTurn()

    local pAllPlayerIDs = PlayerManager.GetAliveIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil then
            local cities = player:GetCities()
            local capCity = cities:GetCapitalCity()

            -- 大城市效果 GreatCity
            for _, city in cities:Members() do
                if isGreatCityInitialized == 0 then
                    RegisteGreatCity(pPlyerID, city:GetID())
                    SummonSHero(pPlyerID, city:GetID())
                else
                    Game:SetProperty('InitializeGreatCity', 1)
                end

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


                -- 维修城墙
                local buildQ = city:GetBuildQueue()
                if buildQ then
                    local cB = buildQ:CurrentlyBuilding()
                    if cB == 'PROJECT_REPAIR_CASTLE' then
                        -- buildQ:FinishProgress()
                        local districts = city:GetDistricts()
                        local center = districts:GetDistrict(DISTRICT_CITY_CENTER_INDEX)

                        -- local districtHitpoints = center:GetMaxDamage(DefenseTypes.DISTRICT_GARRISON);
                        -- local currentDistrictDamage = center:GetDamage(DefenseTypes.DISTRICT_GARRISON);
                        -- local wallHitpoints = center:GetMaxDamage(DefenseTypes.DISTRICT_OUTER);
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

            -- INFERNO_MODE 每10回合创建单位
            if INFERNO_MODE and not player:IsHuman() and turn % 10 == 0 then
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
                end
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

--- 为真人玩家创建英雄纪念碑
---@param playerID any
---@param cityID any
---@param X any
---@param Y any
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
            WorldBuilder.CityManager():CreateBuilding(pCity, BUILDING_HERO_MONUMENT_TKH_INDEX,
                100, Map.GetPlot(pCity:GetX(), pCity:GetY()));
        end
    end
end

function UnitSetProperty(playerID, params)
    -- for key, value in pairs(params) do
    --     print('UnitSetProperty ', key, value)
    -- end
    local pUnit = UnitManager.GetUnit(playerID, params.UnitID)
    if pUnit then
        pUnit:SetProperty(params.Key, params.Value)
    end
end

function Initialize()
    Events.TurnBegin.Add(CityTurnBeginEffectHandler)
    Events.TurnEnd.Add(OnTurnEndUnitEffectHandler)

    Events.CityProjectCompleted.Add(OnCityProjectCompleted)

    -- Great Cities(大城市功能)
    Events.CityAddedToMap.Add(RegisteGreatCity)
    Events.CityNameChanged.Add(RegisteGreatCity)

    Events.CityAddedToMap.Add(SummonSHero)
    Events.CityNameChanged.Add(SummonSHero)


    Events.UnitPromoted.Add(OnUnitPromotionChanged)
    Events.UnitKilledInCombat.Add(OnUnitKilledInCombat)
    Events.UnitMoveComplete.Add(OnUnitMoveComplete)

    -- Custom GameEvents
    GameEvents.SetPropertyByAdjacentUnitsUI.Add(SetPropertyByAdjacentUnitsUI)
    GameEvents.OnDeleteCityButtonClicked.Add(OnDeleteCityButtonClicked)
    GameEvents.ChangePlayerBalance.Add(ChangePlayerBalance)

    GameEvents.UnitSetProperty.Add(UnitSetProperty)

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
