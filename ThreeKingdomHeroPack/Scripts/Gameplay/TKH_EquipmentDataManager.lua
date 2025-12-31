-- TKH_EquipmentDataManager
-- Author: PurpleSoul
-- DateCreated: 6/25/2025 5:04:13 PM
--------------------------------------------------------------


-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include('TKH_Constant')
include('TKH_Helper')

-- ===========================================================================
--	DEBUG
-- ===========================================================================



-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
local IMPROVEMENT_BARBARIAN_CAMP_INDEX = GameInfo.Improvements['IMPROVEMENT_BARBARIAN_CAMP'].Index
local SHOP_SHUFFL_TURN = 15

-- ===========================================================================
--	VARIABLES
-- ===========================================================================

local soldEquipmentNums = 10
local m_EquipmentManager = {}
local m_HeroEquipmentManager = {}
local m_EquipmentAllocator = {}
local m_HeroRewardManager = {}
local m_EquipmentSuitManager = {}
local m_EquipmentRewardManager = {}
local m_barbarianManager = {}
-- ===========================================================================
--	VARIABLES   OBJECT_TABLE
-- ===========================================================================

Equipment = {}
Equipment.__index = Equipment

function Equipment.__tostring(self)
    return string.format('%s, %s, %s, %s', self.Index, self.Equipment, self.Owner, self.HeroClassIndex)
end

function Equipment.new(self, eData)
    local o = {}
    setmetatable(o, self)
    o:Initialize(eData)
    if not o.MustReward then
        m_EquipmentAllocator[#m_EquipmentAllocator + 1] = eData.Equipment
    end

    m_EquipmentManager[o.Equipment] = o
end

function Equipment.Initialize(self, eData)
    self.Index = eData.ID
    self.Equipment = eData.Equipment
    self.EquipmentType = eData.EquipmentType
    self.Name = eData.Name
    self.Description = eData.Description
    self.EquipmentAbility = eData.EquipmentAbility
    self.ExclusiveHero = eData.ExclusiveHero
    self.Icon = eData.Icon
    self.Suit = eData.Suit
    self.MustReward = eData.MustReward == 1
    self.Price = eData.Price
    self.Level = eData.Level
    self.Owner = -1
    self.HeroClassIndex = -1
    self.oTurn = 0
    self.hTurn = 0
    self.RewardType = -1
    self.GetTurn = -1
    self.Locked = false
    self.Sold = false
end

function Equipment.ChangeOwner(self, playerID)
    self.Owner = playerID
    self.oTurn = 0
    self.hTurn = 0
    self.RewardType = -1
    self.GetTurn = -1
    self.Locked = false
    self.Sold = false
    self:ChangeHero(-1)
    Save()
end

function Equipment.ChangeHero(self, heroIndex)
    local oldHeroClass = GameInfo.HeroClasses[self.HeroClassIndex]
    if oldHeroClass then
        local hUnitType = oldHeroClass.UnitType
        local old_he = m_HeroEquipmentManager[hUnitType]
        if old_he then
            setmetatable(old_he, HeroEquipment)
            if old_he[self.EquipmentType] == self.Equipment then
                old_he:TakeOff(self.Equipment)
            end
        end
    end

    if heroIndex ~= -1 and GameInfo.HeroClasses[heroIndex] ~= nil then
        local new_he = m_HeroEquipmentManager[GameInfo.HeroClasses[heroIndex].UnitType]
        if new_he ~= nil then
            setmetatable(new_he, HeroEquipment)
            new_he:PutOn(self.Equipment)
        end
    end

    self.HeroClassIndex = heroIndex
    Save()
end

function Equipment.Sell(self)
    self.Owner = -1
    self.HeroClassIndex = -1
    self.oTurn = 0
    self.hTurn = 0
    self.RewardType = -1
    self.GetTurn = -1
    self.Locked = false
    self.Sold = true
end

function InitializeUpgradePT(unitType)
    local pt = {}

    for row in GameInfo.TKH_HeroKillPointSkill() do
        -- print(row.Index, row.Name, row.Heroes)
        local suitableSkill = false
        if row.Heroes then
            local heroes = SplitString(row.Heroes, ',')
            if IsInTable(heroes, unitType) then
                suitableSkill = true
            end
        else
            suitableSkill = true
        end

        if suitableSkill then
            local upgradeData = {
                UpgradeType = row.Name,
                UpgradeKey = row.PropertyKey,
                Value = 0,
            }
            pt[row.Name] = upgradeData
        end
    end

    return pt
end

HeroEquipment = {}
HeroEquipment.__index = HeroEquipment

function HeroEquipment.new(self, unitID, heroClassIndex, playerID)
    local o = {}
    setmetatable(o, self)
    o:Initialize(unitID, heroClassIndex, playerID)
    local unitType = GameInfo.HeroClasses[heroClassIndex].UnitType
    m_HeroEquipmentManager[unitType] = o
end

function HeroEquipment.Initialize(self, unitID, heroClassIndex, playerID)
    self.HeroClass = heroClassIndex
    self.HeroIndex = GameInfo.HeroClasses[heroClassIndex].Index
    self.HeroClassType = GameInfo.HeroClasses[heroClassIndex].HeroClassType
    self.UnitType = GameInfo.HeroClasses[heroClassIndex].UnitType
    self.UnitID = unitID
    self.Owner = playerID
    self.PT = InitializeUpgradePT(self.UnitType)
end

function HeroEquipment.ReCreate(self)
    for row in GameInfo.EquipmentTypes() do
        local e = self[row.EquipmentType]
        if e ~= nil and m_EquipmentManager[e] ~= nil then
            local equipment = m_EquipmentManager[e]
            setmetatable(equipment, Equipment)
            equipment:ChangeHero(self.HeroClass)
        end
    end

    Save()
end

function HeroEquipment.Destroye(self)
    for row in GameInfo.EquipmentTypes() do
        local e = self[row.EquipmentType]
        if e and m_EquipmentManager[e] then
            local equipment = m_EquipmentManager[e]
            setmetatable(equipment, Equipment)
            equipment:ChangeHero(-1)
        end
    end
    Save()
end

function HeroEquipment.PutOn(self, e)
    local equipment = m_EquipmentManager[e]
    if equipment == nil then
        return
    end
    ChangeHeroEquipmentAbility(e, self.HeroClass, EQUIPMENT_STATUS.PUT_ON)
    self[equipment.EquipmentType] = e
    Save()
end

function HeroEquipment.TakeOff(self, e)
    local equipment = m_EquipmentManager[e]
    if equipment == nil then
        return
    end
    self[equipment.EquipmentType] = nil
    ChangeHeroEquipmentAbility(e, self.HeroClass, EQUIPMENT_STATUS.TAKE_OFF)
    Save()
end

EquipmentSuit = {}
EquipmentSuit.__index = EquipmentSuit

function EquipmentSuit.new(self, suitData)
    local o = {}
    setmetatable(o, self)
    o:Initialize(suitData)
end

function EquipmentSuit.Initialize(self, suitData)
    self.Name = suitData.Name
    self.Description = suitData.Description
    self.Equipments = {}
    self.Abilities = {}

    local abilityAmount = SplitString(suitData.SuitEquipmentAmount, ',')

    for index, amount in ipairs(abilityAmount) do
        local abilityInfo = GameInfo.UnitAbilities['ABILITY_TKH_' .. suitData.Suit .. amount]
        if not abilityInfo then
            return
        end
        local suitAbility = {}
        suitAbility.Info = abilityInfo
        suitAbility.Amount = tonumber(abilityAmount[index])
        table.insert(self.Abilities, suitAbility)
    end

    if #self.Abilities > 1 then
        table.sort(self.Abilities, function(a, b)
            return a.Amount < b.Amount
        end)
    end

    m_EquipmentSuitManager[suitData.Suit] = self
end

-- ===========================================================================
-- FUNCTIONS    GAME EVENTS
-- ===========================================================================

--- 英雄单位生成时注册英雄装备
---@param playerID number
---@param unitID number
function OnHeroCreated(playerID, unitID)
    local unit = UnitManager.GetUnit(playerID, unitID)
    local heroClassIndex = unit:GetHeroClassType()
    if not unit or not heroClassIndex or heroClassIndex == -1 then
        return
    end

    local unitInfo = GameInfo.Units[unit:GetType()]
    local unitType = unitInfo.UnitType
    if IsTkh(unitType) and unitInfo.FormationClass ~= 'FORMATION_CLASS_CIVILIAN' then
        local heroEquipments = m_HeroEquipmentManager[unitType]
        if heroEquipments then
            local o_hero = UnitManager.GetUnit(heroEquipments.Owner, heroEquipments.UnitID)
            if o_hero == nil then
                heroEquipments.UnitID = unitID
                heroEquipments.Owner = unit:GetOwner()
                setmetatable(heroEquipments, HeroEquipment)
                heroEquipments:ReCreate()
                -- 重新设置英雄技能
                local pt = heroEquipments.PT
                for upgradeType, _ in pairs(pt) do
                    local upgradeData = pt[upgradeType]
                    local value = upgradeData.Value
                    upgradeData.Value = value
                    local upgradeInfo = GameInfo.TKH_HeroKillPointSkill[upgradeType]
                    local upgradeActualValue = math.floor(value / upgradeInfo.Rate) * upgradeInfo.Base
                    unit:SetProperty(upgradeInfo.PropertyKey, upgradeActualValue)
                    ChangeHeroUnitKPSkill(unit, upgradeInfo) -- 添加技能
                end
            end
        else
            HeroEquipment:new(unitID, heroClassIndex, playerID)
        end
    end
    Save()
end

-- 英雄单位消失
function OnHeroRemoved(playerID, unitID)
    for _, heroEquipments in pairs(m_HeroEquipmentManager) do
        if heroEquipments.Owner == playerID and heroEquipments.UnitID == unitID then
            setmetatable(heroEquipments, HeroEquipment)
            heroEquipments:Destroye()
            heroEquipments.UnitID = -1
            Save()
            return
        end
    end
end

--- 玩家战败时，胜利方获得失败方所有装备
---@param loser number
---@param winner number
---@param eventID number
function OnPlayerDefeat(loser, winner, eventID)
    local winnerPlayer = Players[winner]
    local IsHuman = false
    if winnerPlayer:IsHuman() then
        IsHuman = true
    end
    for e, equipment in pairs(m_EquipmentManager) do
        if equipment.Owner == loser then
            setmetatable(equipment, Equipment)
            if IsHuman then
                equipment:ChangeOwner(winner)
            else
                equipment:ChangeOwner(-1)
            end
        end
    end
    Save()
end

--- 战斗击杀英雄单位，随机获取其一件装备
---@param pCombatResult table
function OnCombat(pCombatResult)
    local attacker = pCombatResult[CombatResultParameters.ATTACKER];
    local attInfo = attacker[CombatResultParameters.ID]
    local aUnit = UnitManager.GetUnit(attInfo.player, attInfo.id)

    -- 防御者信息
    local defender = pCombatResult[CombatResultParameters.DEFENDER]
    local defInfo = defender[CombatResultParameters.ID]
    local dUnit = UnitManager.GetUnit(defInfo.player, defInfo.id)

    -- local location = pCombatResult[CombatResultParameters.LOCATION];
    -- local damage = defender[CombatResultParameters.DAMAGE_TO]

    if aUnit == nil or dUnit == nil then
        return
    end
    if dUnit:IsDelayedDeath() or dUnit:IsDead() then
        local eHeroIndex = dUnit:GetHeroClassType();
        if (eHeroIndex == -1) then
            return
        end
        local aPlayer = Players[aUnit:GetOwner()]
        if aPlayer:IsAI() then
            return
        end
        local unitType = GameInfo.HeroClasses[eHeroIndex].UnitType
        local heroEquipments = m_HeroEquipmentManager[unitType]
        if not heroEquipments then
            return
        end
        local gainEquipments = {}
        for row in GameInfo.EquipmentTypes() do
            local e = heroEquipments[row.EquipmentType]
            if e and m_EquipmentManager[e] and not m_EquipmentManager[e].Locked then
                table.insert(gainEquipments, heroEquipments[row.EquipmentType])
            end
        end
        if #gainEquipments >= 1 then
            math.randomseed(GetRandomSeed())
            local equipment = m_EquipmentManager[gainEquipments[math.random(1, #gainEquipments)]]
            setmetatable(equipment, Equipment)
            equipment:ChangeOwner(aUnit:GetOwner())
        end
    end

    Save()
end

--- 铁匠铺生成装备
---@param playerID number
---@param cityID number
---@param projectID number
---@param buildingIndex number
---@param X number
---@param Y number
---@param isCancelled boolean
function OnCityProjectCompleted(playerID, cityID, projectID, buildingIndex, X, Y, isCancelled)
    local pCity = CityManager.GetCity(Players[playerID], cityID)
    local projectKey
    local e

    if projectID == PROJECT_CREATE_EQUIPMENT_MOUNT_INDEX then
        projectKey = PROJECT_CREATE_EQUIPMENT_MOUNT
    elseif projectID == PROJECT_CREATE_EQUIPMENT_WEAPON_INDEX then
        projectKey = PROJECT_CREATE_EQUIPMENT_WEAPON
    end

    if projectKey then
        e = pCity:GetProperty(projectKey)
        if e and m_EquipmentManager[e] then
            local rewardEquipment = m_EquipmentManager[e]
            -- 需检测该装备是否被其他玩家拥有，如在锻造结束前已被其他玩家获取，则重新获得新随机装备
            if rewardEquipment.Owner == -1 then
                AllocateEquipmentToPlayerForReward(playerID, EQUIPMENT_REWARD_TYPES.PROJECT_CREATED, e)
                SendEquipmentCreatedNotification(playerID, e, EQUIPMENT_REWARD_TYPES.PROJECT_CREATED, X, Y)
            else
                local rewardEquipmentType = rewardEquipment.EquipmentType
                local reRandomReward = RandomEquipmentByTypes(rewardEquipmentType)
                if reRandomReward then
                    AllocateEquipmentToPlayerForReward(playerID, EQUIPMENT_REWARD_TYPES.PROJECT_CREATED, reRandomReward)
                    SendEquipmentCreatedNotification(playerID, reRandomReward, EQUIPMENT_REWARD_TYPES.PROJECT_CREATED, X,
                        Y)
                end
            end
        end
        pCity:SetProperty(projectKey, nil)
    end

    Save()
end

--- 开始铁匠铺项目
---@param playerID number
---@param cityID number
---@param productionID number
---@param objectID number
---@param wasCancelled boolean
function OnCityProductionChanged(playerID, cityID, productionID, objectID, wasCancelled)
    local pCity = CityManager.GetCity(Players[playerID], cityID)
    local player = Players[playerID]
    if productionID == 3 then
        if objectID == PROJECT_CREATE_EQUIPMENT_MOUNT_INDEX then
            if not pCity:GetProperty(PROJECT_CREATE_EQUIPMENT_MOUNT) then
                local e = RandomEquipmentByTypes({ 'EQUIPMENT_MOUNT' })
                if e and m_EquipmentManager[e] then
                    pCity:SetProperty(PROJECT_CREATE_EQUIPMENT_MOUNT, e)
                end
            end

            player:GetResources():ChangeResourceAmount(RESOURCE_HORSES_INDEX, -CREATE_EQUIPMENT_HORSES_AMOUNT)
            player:GetTreasury():ChangeGoldBalance(-CREATE_EQUIPMENT_GOLD_AMOUNT)
        elseif objectID == PROJECT_CREATE_EQUIPMENT_WEAPON_INDEX then
            if not pCity:GetProperty(PROJECT_CREATE_EQUIPMENT_WEAPON) then
                local e = RandomEquipmentByTypes(
                    { 'EQUIPMENT_ARMOR', 'EQUIPMENT_WEAPON', 'EQUIPMENT_ARTIFACT' })
                if e and m_EquipmentManager[e] then
                    pCity:SetProperty(PROJECT_CREATE_EQUIPMENT_WEAPON, e)
                end
            end
            player:GetResources():ChangeResourceAmount(RESOURCE_IRON_INDEX, -CREATE_EQUIPMENT_IRON_AMOUNT)
            player:GetTreasury():ChangeGoldBalance(-CREATE_EQUIPMENT_GOLD_AMOUNT)
        end
    end

    Save()
end

--- 保存玩家奖励
---@param playerID number
---@param rewardType number
---@param counter number
---@param recorder table
function SavePlayerReward(playerID, rewardType, counter, recorder)
    local _playerID = 'TKH_' .. tostring(playerID)
    m_EquipmentRewardManager[_playerID] = m_EquipmentRewardManager[_playerID] or {}
    m_EquipmentRewardManager[_playerID][rewardType] = m_EquipmentRewardManager[_playerID][rewardType] or {}
    m_EquipmentRewardManager[_playerID][rewardType].Counter = counter
    m_EquipmentRewardManager[_playerID][rewardType].Recorder = recorder

    Game:SetProperty('EquipmentRewardManager', m_EquipmentRewardManager)
end

--- 检测并发送奖励
---@param playerID number
---@param rewardType number
---@param x number
---@param y number
function SendPlayerReward(playerID, rewardType, x, y)
    local counter, recorder = GetPlayerReward(playerID, rewardType)
    local canSend = false
    local needNumm = GetEquipmentRewardNeedsNum(rewardType, #recorder)

    if (rewardType == EQUIPMENT_REWARD_TYPES.DESTORY_BARBARIAN_CAMP or
            rewardType == EQUIPMENT_REWARD_TYPES.GOODYHUT_REWARD or
            rewardType == EQUIPMENT_REWARD_TYPES.TOTAL_KILL) then
        counter = counter + 1
        if counter == needNumm then
            canSend = true
        end
    elseif rewardType == EQUIPMENT_REWARD_TYPES.TOTAL_CITIES then
        counter = Players[playerID]:GetCities():GetCount()
        if counter >= needNumm then
            canSend = true
        end
    elseif rewardType == EQUIPMENT_REWARD_TYPES.WORLD_LORD then
        canSend = true
    elseif rewardType == EQUIPMENT_REWARD_TYPES.CONQUERED_ORIGINAL_CAPITAL then
        counter = counter + 1
        if counter >= needNumm then
            canSend = true
        end
    end

    if canSend then
        if rewardType == EQUIPMENT_REWARD_TYPES.WORLD_LORD then
            print('WORLD LORD REWARD.!!!!')
        else
            if m_EquipmentAllocator ~= nil and #m_EquipmentAllocator > 0 then
                math.randomseed(GetRandomSeed())
                while table.count(m_EquipmentAllocator) > 0 do
                    local e = table.remove(m_EquipmentAllocator, math.random(#m_EquipmentAllocator))
                    if e and m_EquipmentManager[e] then
                        local equipment = m_EquipmentManager[e]
                        if equipment.Owner == -1 then
                            table.insert(recorder, e)
                            AllocateEquipmentToPlayerForReward(playerID, rewardType, e)
                            SendEquipmentCreatedNotification(playerID, e, rewardType, x, y)
                            break
                        end
                    end
                end
            end
        end
    end
    SavePlayerReward(playerID, rewardType, counter, recorder)
    Save()
end

function OnBarbarinCampAddedToMap(X, Y, improvementIndex, playerID)
    if improvementIndex == IMPROVEMENT_BARBARIAN_CAMP_INDEX then
        m_barbarianManager = Game:GetProperty('m_barbarianManager') or m_barbarianManager
        m_barbarianManager[X] = m_barbarianManager[X] or {}
        m_barbarianManager[X][Y] = true
        Game:SetProperty('m_barbarianManager', m_barbarianManager)
    end
end

--- 每占领 BarbarinCampRewardNum 个蛮族营地获得1个装备奖励
---@param posX number
---@param posY number
---@param owningPlayerID number
function OnBarbarinCampRemovedFromMap(posX, posY, owningPlayerID)
    m_barbarianManager = Game:GetProperty('m_barbarianManager') or m_barbarianManager
    if m_barbarianManager[posX] and m_barbarianManager[posX][posY] then
        -- print('OnBarbarinCampRemovedFromMap = ', m_barbarianManager[posX][posY])
        local plot = Map.GetPlot(posX, posY)
        if plot:IsUnit() then
            for _, pUnit in ipairs(Units.GetUnitsInPlot(plot)) do
                if (pUnit ~= nil) then
                    local unitOwner = pUnit:GetOwner()
                    local player = Players[unitOwner]
                    if player:IsMajor() then
                        SendPlayerReward(unitOwner, EQUIPMENT_REWARD_TYPES.DESTORY_BARBARIAN_CAMP, posX, posY)
                    end

                    m_barbarianManager[posX][posY] = nil
                    Game:SetProperty('m_barbarianManager', m_barbarianManager)
                end
            end
        end
    end
end

--- 每占领 GoodyhutRewardNum 个村庄获得1个装备奖励
---@param ePlayer number
---@param unitID number
---@param eRewardType number
---@param eRewardSubType number
function OnGoodyHutReward(ePlayer, unitID, eRewardType, eRewardSubType)
    local player = Players[ePlayer]
    if player == nil or not player:IsMajor() then
        return
    end
    local unit = UnitManager.GetUnit(ePlayer, unitID)
    if unit then
        SendPlayerReward(ePlayer, EQUIPMENT_REWARD_TYPES.GOODYHUT_REWARD, unit:GetX(), unit:GetY())
    end
end

--- 统计玩家城市数量
---@param playerID number
---@param cityID number
---@param cityX number
---@param cityY number
function OnCityAddedToMap(playerID, cityID, cityX, cityY)
    local player = Players[playerID]
    local city = CityManager.GetCity(playerID, cityID)
    if player == nil or not player:IsMajor() then
        return
    end

    SendPlayerReward(playerID, EQUIPMENT_REWARD_TYPES.TOTAL_CITIES, cityX, cityY)
end

--- 玩家累计击杀单位数量
function OnUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    local player = Players[playerID]
    if player == nil or not player:IsMajor() then
        return
    end
    local unit = UnitManager.GetUnit(playerID, unitID)
    if unit then
        SendPlayerReward(playerID, EQUIPMENT_REWARD_TYPES.TOTAL_KILL, unit:GetX(), unit:GetY())

        -- Hero kill
        local unitInfo = GameInfo.Units[unit:GetType()]
        local unitType = unitInfo.UnitType
        if unit:GetHeroClassType() ~= -1 then
            if m_HeroRewardManager[unitType] then
                for _, info in pairs(m_HeroRewardManager[unitType]) do

                    local rewardReq = info['RewardNeed']
                    info['Prograss'] = info['Prograss'] + 1
                    if info['Prograss'] == rewardReq then
                        local equipment = m_EquipmentManager[info['Equipment']]
                        if equipment and equipment.Owner == -1 then
                            local e_index = IndexOf(m_EquipmentAllocator, info['Equipment'])
                            if e_index then
                                table.remove(m_EquipmentAllocator, e_index)
                                AllocateEquipmentToPlayerForReward(playerID, EQUIPMENT_REWARD_TYPES.HERO_TOTAL_KILL, info['Equipment'])
                                SendEquipmentCreatedNotification(playerID, info['Equipment'], EQUIPMENT_REWARD_TYPES.HERO_TOTAL_KILL,
                                    unit:GetX(),
                                    unit:GetY())
                            end
                        end
                    end
                end

                Game:SetProperty('HeroRewardManager', m_HeroRewardManager)
            end
            local total_kill = unit:GetProperty("TKH_HERO_KILL_POINT") or 0
            unit:SetProperty("TKH_HERO_KILL_POINT", total_kill + HeroConstants.SKILL_POINT_PER_KILL)
        end
    end
end

--- 占领首都
---@param playerID number
---@param notificationID number
function OnNotificationAdded(playerID, notificationID)
    local pNotification = NotificationManager.Find(playerID, notificationID)

    if pNotification and pNotification:GetTypeName() == 'NOTIFICATION_CAPITAL_CAPTURED' then
        SendPlayerReward(playerID, EQUIPMENT_REWARD_TYPES.CONQUERED_ORIGINAL_CAPITAL, -1, -1)
    end
end

-- ===========================================================================
-- FUNCTIONS    GAME DATA
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS    GAME DATA INITIALIZE
-- ===========================================================================

function InitializeEquipmentData()
    m_EquipmentManager = {}
    m_EquipmentSuitManager = {}
    m_EquipmentAllocator = {}
    m_HeroEquipmentManager = {}
    m_HeroRewardManager = {}

    m_EquipmentRewardManager = {}

    --- 初始化套装管理器
    for row in GameInfo.EquipmentSuits() do
        EquipmentSuit:new(row)
    end

    for row in GameInfo.Equipments() do
        Equipment:new(row)
        if row.Suit and m_EquipmentSuitManager[row.Suit] then
            table.insert(m_EquipmentSuitManager[row.Suit].Equipments, row.Equipment)
        end

        if row.ExclusiveHero and row.RewardParam1 then
            m_HeroRewardManager['UNIT_HERO_TKH_' .. row.ExclusiveHero] = m_HeroRewardManager
                ['UNIT_HERO_TKH_' .. row.ExclusiveHero] or {}
            table.insert(m_HeroRewardManager['UNIT_HERO_TKH_' .. row.ExclusiveHero],
                {
                    Equipment = row.Equipment,
                    RewardNeed = tonumber(row.RewardParam1),
                    Prograss = 0,
                    RewardType = 'TOTAL_KILL'
                })
        end
    end

    local pAllPlayerIDs = PlayerManager.GetAliveMajorIDs()
    for _, pPlyerID in ipairs(pAllPlayerIDs) do
        local player = Players[pPlyerID]
        if player ~= nil then
            local units = player:GetUnits()
            for _, unit in units:Members() do
                if unit and unit:GetHeroClassType() ~= -1 then
                    HeroEquipment:new(unit:GetID(), unit:GetHeroClassType(), pPlyerID)
                end
            end
        end
    end

    GiftEquipments()
    SetSoldEquipments(false)
    Game:SetProperty('TKH_EquipmentData_Initialized', true)
    Save()
end

-- ===========================================================================
-- FUNCTIONS    GAME DATA PROCESS
-- ===========================================================================

function GetSoldEquipmentNum()
    local sumSold = 0
    for _, equipment in pairs(m_EquipmentManager) do
        if equipment.Sold then
            sumSold = sumSold + 1
        end
    end

    soldEquipmentNums = sumSold

    return sumSold
end

function SetSoldEquipments(isInitialized)
    local sumSold = 0
    for e, equipment in pairs(m_EquipmentManager) do
        if equipment.Sold then
            if equipment.MustReward then
                equipment.MustReward = false
            end
            sumSold = sumSold + 1
            equipment.Sold = false
            table.insert(m_EquipmentAllocator, e)
        end
    end

    soldEquipmentNums = aORb(isInitialized, sumSold, 10)

    math.randomseed(GetRandomSeed())
    for _ = 1, soldEquipmentNums do
        local e = GetRandomEquipment()
        if e and m_EquipmentManager[e] then
            m_EquipmentManager[e].Sold = true
        else
            break
        end
    end

    Save()
end

--- 商店装备洗牌
function ShufflShopEquipments()
    -- m_EquipmentAllocator = {e1, e2, ...}
    -- m_EquipmentAllocator -> e -> player -> Shop  -> Player
    --                                              -> m_EquipmentAllocator -> e -> player -> Shop  -> Player

    local turn = Game.GetCurrentGameTurn()
    if not turn % SHOP_SHUFFL_TURN == 0 then
        return
    else
        SetSoldEquipments(true)
    end

    Save()
end

--- 改变英雄单位装备套装状态
---@param pUnit table
---@param heroEquipments table
function ChangeSuitAbilitySatus(pUnit, heroEquipments)
    local suitAmount = {}
    local recorder = pUnit:GetProperty('SuitAbilitiesRecorder') or {}
    local abilities = {}
    for ability, _ in pairs(recorder) do
        abilities[ability] = false
    end

    for row in GameInfo.EquipmentTypes() do
        local e = heroEquipments[row.EquipmentType]
        if e and m_EquipmentManager[e] then
            local equipment = m_EquipmentManager[e]
            if equipment.Suit then
                local suit = m_EquipmentSuitManager[equipment.Suit]
                local suitName = Locale.Lookup(suit.Name) .. ' 套装'
                if not suitAmount[suitName] then
                    suitAmount[suitName] = 1
                else
                    suitAmount[suitName] = suitAmount[suitName] + 1
                end
                for _, ability in ipairs(suit.Abilities) do
                    if suitAmount[suitName] == tonumber(ability.Amount) then
                        local abilityType = ability.Info.UnitAbilityType
                        abilities[abilityType] = true
                    end
                end
            end
        end
    end

    for ability, isGain in pairs(abilities) do
        if isGain then
            AddAbilityForUnit(pUnit:GetOwner(), pUnit:GetID(), ability, true)
            table.insert(recorder, ability)
        else
            RemoveAbilityFromUnit(pUnit:GetOwner(), pUnit:GetID(), ability, true)
        end
    end

    pUnit:SetProperty('SuitAbilitiesRecorder', recorder)
end

--- 改变英雄单位装备套装状态 Gameplay
function ChangeHeroEquipmentAbility(e, heroClassIndex, status)
    local heroClass = GameInfo.HeroClasses[heroClassIndex]
    if not heroClass or not m_EquipmentManager[e] or not m_HeroEquipmentManager[heroClass.UnitType] then
        return
    end
    local unitType = heroClass.UnitType
    local equipment = m_EquipmentManager[e]
    local equipmentInfo = GameInfo.Equipments[e]
    local heroEquipments = m_HeroEquipmentManager[unitType]
    local unitID = heroEquipments.UnitID
    local playerID = heroEquipments.Owner
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end

    local abilities = {}
    table.insert(abilities, equipment.EquipmentAbility)
    if equipment.ExclusiveHero and 'UNIT_HERO_TKH_' .. equipment.ExclusiveHero == unitType then
        table.insert(abilities, equipment.EquipmentAbility .. '_ExclusiveHero')
    end

    -- ============================护甲逻辑============================
    local changeValue = equipmentInfo.Parameter1 or 0
    if status == EQUIPMENT_STATUS.TAKE_OFF then
        changeValue = -1 * changeValue
    end

    ChangeExtraMaxArmor(pUnit, changeValue)

    -- ============================Abilities逻辑============================
    for _, ability in pairs(abilities) do
        if status == EQUIPMENT_STATUS.PUT_ON then
            AddAbilityForUnit(playerID, unitID, ability, true)
        elseif status == EQUIPMENT_STATUS.TAKE_OFF then
            RemoveAbilityFromUnit(playerID, unitID, ability, true)
        end
    end

    ChangeSuitAbilitySatus(pUnit, heroEquipments)
    Save()
end

--- 改变装备所属英雄
---@param playerID number
---@param params table
function ChangeEquipmentHero(playerID, params)
    local e = params.Equipment
    local hIndex = params.HeroClass
    local equipment = m_EquipmentManager[e]
    setmetatable(equipment, Equipment)
    equipment:ChangeHero(hIndex)
    Save()
end

--- 改变装备数据
---@param playerID any
---@param params any
function ChangeEquipmentData(playerID, params)
    local e = params.Equipment
    local eData = params.Data
    if e and m_EquipmentManager[e] then
        m_EquipmentManager[e] = eData
    end
    Save()
end

-- =====================================
-- FUNCTIONS GAME DATA HERO UNIT KILL POINT
-- =====================================

function ChangeHeroUnitKPSkill(pUnit, upgradeInfo)
    if not pUnit then
        return
    end
    local kpSkillKey = upgradeInfo.PropertyKey
    local uniqueAbility = upgradeInfo.UniqueAbility
    local value = pUnit:GetProperty(kpSkillKey) or 0

    if value > 0 then
        if kpSkillKey == "HERO_POINT_UPGRADE_EXTRA_MOVEMENT" then
            if value == 1 then
                AddAbilityForUnit(pUnit:GetOwner(), pUnit:GetID(), "ABILITY_HERO_UNIT_KILL_POINT_UPGRADE_EXTRA_MOVEMENT1",
                    true)
            elseif value == 2 then
                AddAbilityForUnit(pUnit:GetOwner(), pUnit:GetID(), "ABILITY_HERO_UNIT_KILL_POINT_UPGRADE_EXTRA_MOVEMENT1",
                    true)
                AddAbilityForUnit(pUnit:GetOwner(), pUnit:GetID(), "ABILITY_HERO_UNIT_KILL_POINT_UPGRADE_EXTRA_MOVEMENT2",
                    true)
            end
        elseif IsInTable({ 'LONGWEIJIANGJUN', 'CAOSHIQINWEI', 'XIANGYU', 'XIANZHENYONGSHI', 'JIXINGJUN' }, upgradeInfo.Name) then
            pUnit:SetProperty('TKH_KILL_POINT_FINAL_SKILL_COOL_TURN', 0)
        else
            if uniqueAbility and upgradeInfo.Ability and GameInfo.UnitAbilities[upgradeInfo.Ability] then
                AddAbilityForUnit(pUnit:GetOwner(), pUnit:GetID(), upgradeInfo.Ability, true)
            end
        end
    end
end

--- 改变英雄单位技能点数据
---@param params any
function ChangeHeroKillPoint(_, params)
    local upgradeType = params.UpgradeType
    local changeValue = params.ChangeValue
    local unitType = params.HeroUnitType
    local heroEquipment = m_HeroEquipmentManager[unitType]

    if not heroEquipment then
        return
    end
    local unit = UnitManager.GetUnit(heroEquipment.Owner, heroEquipment.UnitID)
    if not unit then
        return
    end

    local pt = heroEquipment.PT
    if not pt[upgradeType] then
        return
    end
    local upgradeData = pt[upgradeType]
    local value = upgradeData.Value + changeValue
    upgradeData.Value = value
    local upgradeInfo = GameInfo.TKH_HeroKillPointSkill[upgradeType]
    local upgradeActualValue = math.floor(value / upgradeInfo.Rate) * upgradeInfo.Base
    unit:SetProperty(upgradeInfo.PropertyKey, upgradeActualValue)
    ChangeHeroUnitKPSkill(unit, upgradeInfo)                       -- 添加技能
    local killPoint = unit:GetProperty("TKH_HERO_KILL_POINT") or 0 -- 改变单位剩余技能点
    killPoint = killPoint - changeValue
    if killPoint < 0 then
        killPoint = 0
    end
    unit:SetProperty("TKH_HERO_KILL_POINT", killPoint)
    Save()
end

-- =====================================
-- FUNCTIONS GAME DATA PROCESS ALLOCATOR
-- =====================================

--- 发送装备奖励通知
---@param playerID number
---@param e string
---@param eRewardType number
---@param iX number
---@param iY number
function SendEquipmentCreatedNotification(playerID, e, eRewardType, iX, iY)
    if not m_EquipmentManager[e] then
        return
    end
    NotificationManager.SendNotification(playerID, DB.MakeHash("NOTIFICATION_EQUIPMENT_CREATED"),
        Locale.Lookup('LOC_NOTIFICATION_EQUIPMENT_CREATED_MESSAGE'),
        Locale.Lookup('LOC_NOTIFICATION_EQUIPMENT_CREATED_SUMMARY', Locale.Lookup('LOC_REWARD_TYPE_' .. eRewardType),
            Locale.Lookup(m_EquipmentManager[e].Name)), iX, iY)
end

--- 获取随机装备，并将其从装备分配器移除
--- @return string | nil
function GetRandomEquipment()
    local e
    if m_EquipmentAllocator ~= nil and #m_EquipmentAllocator > 0 then
        e = table.remove(m_EquipmentAllocator, math.random(1, #m_EquipmentAllocator))
    end
    return e
end

-- 根据装备类别获取随机装备，并将其从装备分配器移除
function RandomEquipmentByTypes(equipmentTypes)
    local res_e
    if m_EquipmentAllocator ~= nil and #m_EquipmentAllocator > 0 then
        local equipments = {}
        for _, e in ipairs(m_EquipmentAllocator) do
            if m_EquipmentManager[e] ~= nil and IsInTable(equipmentTypes, m_EquipmentManager[e].EquipmentType) then
                equipments[#equipments + 1] = e
            end
        end
        if #equipments > 0 then
            math.randomseed(GetRandomSeed())
            res_e = table.remove(m_EquipmentAllocator,
                IndexOf(m_EquipmentAllocator, equipments[math.random(1, #equipments)]))
        end
    end

    return res_e
end

-- 为玩家分配指定装备
function AllocateEquipmentToPlayer(playerID, e)
    if e and m_EquipmentManager[e] ~= nil then
        local equipment = m_EquipmentManager[e]
        setmetatable(equipment, Equipment)
        if not Players[playerID]:IsHuman() then
            equipment:Sell()

            local player = Players[playerID]
            local value = EQUIPMENT_SOLD_PRICE
            if player then
                local treasury = player:GetTreasury()
                if treasury:GetGoldBalance() + value <= 0 then
                    treasury:ChangeGoldBalance(-treasury:GetGoldBalance())
                else
                    treasury:ChangeGoldBalance(value)
                end
            end
        else
            m_EquipmentManager[e]:ChangeOwner(playerID)
        end
    end
end

--- 根据奖励为玩家分配装备
---@param playerID number
---@param eRewardType number
---@param e string|nil
function AllocateEquipmentToPlayerForReward(playerID, eRewardType, e)
    if Players[playerID] == nil or not Players[playerID]:IsMajor() then
        return nil
    end
    if e == nil then
        e = GetRandomEquipment()
    end
    if e then
        AllocateEquipmentToPlayer(playerID, e)
        local turn = Game.GetCurrentGameTurn()
        local equipment = m_EquipmentManager[e]
        if equipment then
            setmetatable(equipment, Equipment)
            equipment.RewardType = eRewardType
            equipment.GetTurn = turn
        end
    end

    return e
end

function GiftEquipments()
    local giftNum = GameConfiguration.GetValue("GIFT_EQUIPMENT_COUNT")
    if giftNum > 0 then
        math.randomseed(GetRandomSeed())
        for _ = 1, giftNum do
            for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
                local player = Players[playerID]
                if player:IsHuman() then
                    local e = GetRandomEquipment()
                    if e and m_EquipmentManager[e] then
                        AllocateEquipmentToPlayer(playerID, e)
                    end
                end
            end
        end
    end
end

-- ===========================================================================
-- FUNCTIONS    GAME DATA SAVE/READ
-- ===========================================================================

function Save()
    Game:SetProperty('EquipmentManager', m_EquipmentManager)
    Game:SetProperty('HeroEquipmentManager', m_HeroEquipmentManager)
    Game:SetProperty('EquipmentAllocator', m_EquipmentAllocator)
    Game:SetProperty('HeroRewardManager', m_HeroRewardManager)
    Game:SetProperty('EquipmentSuitManager', m_EquipmentSuitManager)
    Game:SetProperty('EquipmentRewardManager', m_EquipmentRewardManager)
end

local repeatTimes = 0

function KeepRead()
    repeatTimes = repeatTimes + 1
    local data_Str = GameConfiguration.GetValue('EquipmentData')
    local version = GameConfiguration.GetValue('TKH_SaveVersion')

    if data_Str == nil then
        if repeatTimes == 10 * 60 then
            Events.GameCoreEventPublishComplete.Remove(KeepRead)
            InitializeEquipmentData()
        else
            return
        end
    else
        Events.GameCoreEventPublishComplete.Remove(KeepRead)
        m_EquipmentManager,
        m_HeroEquipmentManager,
        m_EquipmentSuitManager,
        m_EquipmentAllocator,
        m_HeroRewardManager,
        m_EquipmentRewardManager = unpack(deserialize(data_Str))
        Save()

        for e, equipment in pairs(m_EquipmentManager) do
            if equipment.Owner ~= -1 then
                print(e, equipment.Owner, Locale.Lookup(equipment.Name))
            end
        end
    end
end

-- ===========================================================================
--	FUNCTIONS   TEST
-- ===========================================================================

--- 随机分配装备给所有玩家
function AllocateEquipmentToEveryone()
    for i = #m_EquipmentAllocator, 1, -1 do
        for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
            local e = GetRandomEquipment()
            AllocateEquipmentToPlayer(playerID, e)
        end
    end
end

--- 随机分配所有装备给本地玩家
function AllocateEquipmentToLocalPlayer()
    local localPlayerID = Game.GetLocalPlayer()
    for _ = #m_EquipmentAllocator, 1, -1 do
        local e = GetRandomEquipment()
        AllocateEquipmentToPlayer(localPlayerID, e)
    end
end

function LaterInitialize()
    local isInitialized = Game:GetProperty('TKH_EquipmentData_Initialized') or false
    if not isInitialized then
        InitializeEquipmentData()
    else
        Events.GameCoreEventPublishComplete.Add(KeepRead)
    end
end

function ReadEquipmentData(playerID, params)
    local data = params.Data
    if playerID == Game.GetLocalPlayer() then
        m_EquipmentManager,
        m_HeroEquipmentManager,
        m_EquipmentSuitManager,
        m_EquipmentAllocator,
        m_HeroRewardManager,
        m_EquipmentRewardManager = unpack(data)

        Save()
    end
end

function Initialize()
    Events.UnitAddedToMap.Add(OnHeroCreated)
    Events.UnitRemovedFromMap.Add(OnHeroRemoved)
    Events.PlayerDefeat.Add(OnPlayerDefeat)
    Events.Combat.Add(OnCombat)
    Events.CityProjectCompleted.Add(OnCityProjectCompleted)
    Events.CityProductionChanged.Add(OnCityProductionChanged)

    Events.ImprovementAddedToMap.Add(OnBarbarinCampAddedToMap)
    Events.ImprovementRemovedFromMap.Add(OnBarbarinCampRemovedFromMap)
    Events.GoodyHutReward.Add(OnGoodyHutReward)
    Events.CityAddedToMap.Add(OnCityAddedToMap)
    Events.UnitKilledInCombat.Add(OnUnitKilledInCombat)
    Events.NotificationAdded.Add(OnNotificationAdded)

    Events.TurnBegin.Add(ShufflShopEquipments)
    Events.TurnEnd.Add(Save)

    GameEvents.ChangeEquipmentData.Add(ChangeEquipmentData)
    GameEvents.ChangeEquipmentHero.Add(ChangeEquipmentHero)
    GameEvents.ChangeHeroKillPoint.Add(ChangeHeroKillPoint)
end

Initialize()
Events.LoadGameViewStateDone.Add(LaterInitialize)
