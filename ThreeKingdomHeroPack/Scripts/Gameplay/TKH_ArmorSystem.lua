-- TKH_ArmorSystem
-- Author: PurpleSoul
-- DateCreated: 10/13/2025 12:23:22 AM
--------------------------------------------------------------

print('Loading TKH_ArmorSystem.lua')

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include('TKH_Constant')
include('TKH_Helper')

-- ===========================================================================
--	PRE SETTINGS
-- ===========================================================================

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

-- local COLOR_RED			= UI.GetColorValue("COLOR_RED");		-- Obtain colors from colorDB (not const or colorAtlas)
-- local COLOR_YELLOW		= UI.GetColorValue("COLOR_YELLOW");		-- ditto
-- local COLOR_GREEN			= UI.GetColorValue("COLOR_STANDARD_GREEN_LT");		-- "
-- local HEALTH_PERCENT_GOOD = 0.8;	-- This and above means a unit is still in good shape
-- local HEALTH_PERCENT_BAD	= 0.4;	-- Above this the unit is okay but below it, the unit is considered to be in bad shape

local CONSTANT_DAMAGE_DECREASE_RATE = 0.3

local COMBAT_DECREASE_VALUE = 30
local MELEE_COMBAT_DFENDED_DECREASE_RATE = 0.95
local MELEE_COMBAT_ATTACK_DECREASE_RATE = 0.3

local RANGED_COMBAT_DEFEND_MAX_DAMAGE = 40




-- ===========================================================================
--	VARIABLES
-- ===========================================================================

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

function GetUnitArmor(pUnit)
    local armor = pUnit:GetProperty('TKH_Armor') or 0
    local maxArmor = pUnit:GetProperty('TKH_MaxArmor') or 0
    local extraMaxArmor = pUnit:GetProperty('TKH_ExtraMaxArmor') or 0
    return armor, maxArmor, extraMaxArmor
end

--- 计算伤害减免
---@param damage integer 伤害值
---@param armor integer 护甲值
---@return integer 减免后伤害值
---@return integer 剩余护甲值
---@return integer 损失护甲值
function CalculateArmorReduce(damage, armor)
    if armor >= damage then
        return 0, armor - damage, damage
    else
        return damage - armor, 0, armor
    end
end

--- 计算远程伤害减免
---@param oDamage integer 原始伤害值
---@return integer 减免后伤害值
function CalculateRangeDamage(oDamage)
    if oDamage >= 100 then
        return math.floor(oDamage * 0.55)
    elseif oDamage >= 70 then
        return math.floor(oDamage * 0.6)
    elseif oDamage >= 40 then
        return math.floor(oDamage * 0.7)
    elseif oDamage >= 20 then
        return math.floor(oDamage * 0.8)
    else
        return oDamage
    end
end

--- 战斗伤害修改器
---@param aUnit table 攻击单位
---@param dUnit table 防守单位
---@param info table 战斗信息
function UnitCombatDamageModifier(aUnit, dUnit, info)
    -- 原始伤害
    local attack_damage = info.AttackerDamageTakenFromDefender
    local defend_damage = info.DefenderDamageTaken
    local aUnitType = aORb(aUnit ~= nil, GameInfo.Units[aUnit:GetType()].UnitType, false)
    local dUnitType = aORb(dUnit ~= nil, GameInfo.Units[dUnit:GetType()].UnitType, false)
    -- print('原始伤害' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)

    -- -- 吸血效果
    local attack_life_steal_percent = GetUnitAbilitiesParameterSum(aUnit, LIFE_STEAL_ABILITIES, 0)
    if attack_life_steal_percent > 0 then
        TreatUnit(aUnit, math.floor(defend_damage * attack_life_steal_percent))
    end

    local defend_life_steal_percent = GetUnitAbilitiesParameterSum(dUnit, LIFE_STEAL_ABILITIES, 0)
    if defend_life_steal_percent > 0 then
        TreatUnit(dUnit, math.floor(attack_damage * defend_life_steal_percent))
    end


    if aUnit == nil and dUnit == nil then
        return attack_damage, defend_damage
    end

    -- 1. 防御方固定减伤 30%
    defend_damage = math.floor(defend_damage * (1 - CONSTANT_DAMAGE_DECREASE_RATE))
    -- print('固定减伤' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)

    -- 1.1 单位类型固定减伤
    if info.CombatType == MELEE_COMBAT then
        attack_damage = aORb(attack_damage > COMBAT_DECREASE_VALUE,
            COMBAT_DECREASE_VALUE + (attack_damage - COMBAT_DECREASE_VALUE) * MELEE_COMBAT_ATTACK_DECREASE_RATE,
            attack_damage)

        defend_damage = aORb(defend_damage > COMBAT_DECREASE_VALUE,
            COMBAT_DECREASE_VALUE + (defend_damage - COMBAT_DECREASE_VALUE) * MELEE_COMBAT_DFENDED_DECREASE_RATE,
            defend_damage)

        -- print('近战减伤' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)
    elseif info.CombatType == RANGED_COMBAT then
        defend_damage = CalculateRangeDamage(defend_damage)
        -- print('远程减伤' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)
    end

    -- 2. 技能减伤 加算
    defend_damage = math.floor(defend_damage *
        (1 - math.min(1, GetUnitAbilitiesParameterSum(dUnit, DECREASE_DAMAGE_ABILITIES, 0))))
    -- print('技能减伤' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)

    math.randomseed(GetRandomSeed())

    if aUnit then
        -- 3. 攻击方伤害暴击
        -- 3.1 七星刀：攻击时有50%几率再造成一次同等伤害
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_EQUIPMENT_QiXingDao') then
            if math.random() < EquipmentConstants.QI_XING_DAO_RATE then
                defend_damage = math.floor(defend_damage * 2)
            end
        end

        -- 3.2 单位满级晋升增加伤害
        if aUnit:GetProperty('EXTRA_DAMAGE_BOUNS') then
            local damage_bouns = aUnit:GetProperty('EXTRA_DAMAGE_BOUNS') or {}
            for _, value in ipairs(damage_bouns) do
                if value[1] and value[2] then
                    math.randomseed(GetRandomSeed())
                    local percent = value[1]
                    local bouns = value[2]
                    if math.random(100) <= percent then
                        defend_damage = math.floor(defend_damage * bouns)
                    end
                end
            end
        end

        -- 3.3 技能ABILITY增加伤害
        for ability, value_info in pairs(INCREASE_DAMAGE_ABILITIES) do
            if IsUnitHaveAbility(aUnit, ability) then
                local percent = value_info[1]
                local bouns = value_info[2]
                math.randomseed(GetRandomSeed())
                if math.random() <= percent then
                    defend_damage = math.floor(defend_damage * bouns)
                end
            end
        end

        -- 3.4 晋升项目
        if IsUnitHasPromotion(aUnit, 'PROMOTION_TK_GUAN_YIN_PING_1_4') then
            math.randomseed(GetRandomSeed())
            if math.random(100) <= 70 then
                print(defend_damage, defend_damage * 1.5)
                defend_damage = math.floor(defend_damage * 1.5)
            end
        end
    end

    -- 破甲伤害
    if aUnitType and dUnitType then
        -- 兵种克制能力
        -- 抗骑兵单位（这个单位也包括“特种兵的抗骑兵”、“英雄的抗骑兵”）攻击轻重骑兵单位在正常伤害结算完成后再额外+20点破甲伤害。
        if MatchUnitTag(aUnitType, 'CLASS_ANTI_CAVALRY') and MatchUnitTag(dUnitType, { 'CLASS_HEAVY_CAVALRY', 'CLASS_HEAVY_CHARIOT', 'CLASS_LIGHT_CAVALRY', 'CLASS_LIGHT_CHARIOT' }) then
            defend_damage = defend_damage + 20
        end
        -- 近战单位攻击抗骑兵单位在正常伤害结算完成后再+20点破甲伤害
        if MatchUnitTag(aUnitType, 'CLASS_MELEE') and MatchUnitTag(dUnitType, 'CLASS_ANTI_CAVALRY') then
            defend_damage = defend_damage + 20
        end
        -- 骑兵单位攻击近战单位在正常伤害结算完成后再+20点破甲伤害
        if MatchUnitTag(aUnitType, { 'CLASS_HEAVY_CAVALRY', 'CLASS_HEAVY_CHARIOT', 'CLASS_LIGHT_CAVALRY', 'CLASS_LIGHT_CHARIOT' }) and MatchUnitTag(dUnitType, 'CLASS_MELEE') then
            defend_damage = defend_damage + 20
        end
        -- 远程单位攻击抗骑兵单位和轻重骑兵单位在正常伤害结算完成后再+5点破甲伤害
        if MatchUnitTag(aUnitType, 'CLASS_RANGED') and MatchUnitTag(dUnitType, { 'CLASS_HEAVY_CAVALRY', 'CLASS_HEAVY_CHARIOT', 'CLASS_LIGHT_CAVALRY', 'CLASS_LIGHT_CHARIOT', 'CLASS_ANTI_CAVALRY' }) then
            defend_damage = defend_damage + 5
        end
        -- print('兵种克制' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)


        -- 固定伤害类技能（无判断条件）
        local CONSTANT_DAMAGE_ABILITIES = {
            ABILITY_TKH_EQUIPMENT_SUIT_WUZHUI4 = 10,
            ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_XU_CHU = 15,
            ABILITY_TKH_EQUIPMENT_SUIT_POJIA4 = 20,
        }
        defend_damage = defend_damage + GetUnitAbilitiesParameterSum(aUnit, CONSTANT_DAMAGE_ABILITIES, 0)

        -- 张飞穿戴4件装备增加伤害
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_EQUIPMENT_SUIT_WUZHUI4') and dUnitType == 'UNIT_HERO_TKH_ZHANG_FEI' then
            defend_damage = defend_damage + 35 - CONSTANT_DAMAGE_ABILITIES.ABILITY_TKH_EQUIPMENT_SUIT_WUZHUI4
        end

        -- 副将张郃的技能“偷袭”攻击远程单位额外+40点破甲伤害
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_S_HERO_SKILL_ZHANG_HE_3') and MatchUnitTag(dUnitType, 'CLASS_RANGED') then
            defend_damage = defend_damage + 40
        end
        -- -- 魏延
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_S_HERO_SKILL_WEI_YAN_2') and MatchUnitTag(dUnitType, 'CLASS_MELEE') then
            defend_damage = defend_damage + 40
        end
        -- 卑弥呼
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_S_HERO_SKILL_BEI_MI_HU_2') and MatchUnitTag(dUnitType, 'CLASS_TKH_CAVALRY') then
            defend_damage = defend_damage + 40
        end

        -- 对护甲或血量不满的单位额外造成破甲伤害
        local damage = dUnit:GetDamage()
        local armor, maxArmor, extraMaxArmor = GetUnitArmor(dUnit)
        local decrease_armor = maxArmor + extraMaxArmor - armor
        if damage > 0 or decrease_armor > 0 then
            -- 张飞的技能“弱点打击”
            if IsUnitHaveAbility(aUnit, 'ABILITY_UNIT_HERO_TKH_ZHANG_FEI') then
                defend_damage = defend_damage + 25
            end
            -- 腐蚀箭：2个单元格内的白毦兵和远程单位攻击护甲或血量不满的单位额外+5点破甲伤害
            if IsUnitHaveAbility(aUnit, 'ABILITY_MOD_ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_DUJIAN') then
                defend_damage = defend_damage + 5
            end

            if IsUnitHasPromotion(aUnit, 'PROMOTION_ROUT') then
                defend_damage = defend_damage + 5
            end
        else
            -- 压制：与满护甲单位战斗时额外造成20点[COLOR_Civ6DarkRed]破甲伤害[ENDCOLOR]
            if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_S_HERO_SKILL_HUA_XIONG_3') then
                defend_damage = defend_damage + 50
            end
            -- 孙尚香晋升项目
            if IsUnitHaveAbility(aUnit, 'ABILITY_MODIFIER_PROMOTION_TK_SUN_SHANGXIANG_1_5') then
                defend_damage = defend_damage + 50
            end
        end
    end

    -- 闪避伤害
    if dUnit then
        local doogeRate = GetUnitAbilitiesParameterSum(dUnit, DODGE_ABILITIES, 0)
        -- 赵统晋升项
        if IsUnitHasPromotion(dUnit, 'PROMOTION_TK_ZHAO_TONG_1_4') then
            doogeRate = doogeRate + 40
        end

        -- 特殊闪避加成
        doogeRate = doogeRate + (dUnit:GetProperty('EXTRA_DOOGE') or 0)
        -- print('EXTRA_DOOGE = ', dUnit:GetProperty('EXTRA_DOOGE') or 0)
        math.randomseed(GetRandomSeed())
        -- print(GetUnitType(dUnit), doogeRate, random, math.random(100), math.random())
        local random = math.random(100)
        if random <= doogeRate then
            defend_damage = 0
            AddWorldViewText(dUnit:GetX(), dUnit:GetY(), 'LOC_TKH_DOOGE_TRIGGERED', doogeRate, random)
        end
    end

    if IsUnitHaveAbility(aUnit, 'ABILITY_UNIT_HERO_TKH_XU_CHU') then
        attack_damage = 0
    end

    -- print('最终伤害' .. '进攻 = ' .. attack_damage .. ' 防御 = ' .. defend_damage)

    return attack_damage, defend_damage
end

function OnUnitArmorChanged(pUnit)
    local armor, maxArmor, extraMaxArmor = GetUnitArmor(pUnit)
    local decrease_armor = maxArmor + extraMaxArmor - armor


    -- 华雄-暴走：护甲减少时，提升攻击力
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_S_HERO_SKILL_HUA_XIONG_2') then
        pUnit:SetProperty('HUA_XIONG_BAO_ZOU', aORb(decrease_armor >= 200, 10, 0))
    end

    -- 周泰-浴血奋战：护甲减少攻击力提升
    if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_ZHOU_TAI_3_5"].Index) then
        local adjustStrength = math.min(15, (math.floor(decrease_armor / 50)) * 3)
        pUnit:SetProperty('COMBAT_STRENGTH_BY_LOST_HEALTH', adjustStrength)
    end
end

-- ===========================================================================
--	EFFECT Events
-- ===========================================================================

--- 单位创建时，注册护甲值
---@param playerID number
---@param unitID number
function RegisterArmor(playerID, unitID)
    local pPlayer = Players[playerID]
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil then
        return
    end

    if pUnit:GetProperty('TKH_Armor') ~= nil then
        return
    end

    local unitType = GameInfo.Units[pUnit:GetType()].UnitType


    local unitTypeManager = Game:GetProperty('TKH_unitTypeManager') or {}
    unitTypeManager[playerID] = unitTypeManager[playerID] or {}
    unitTypeManager[playerID][unitID] = unitType
    Game:SetProperty('TKH_unitTypeManager', unitTypeManager)

    if GameInfo.TKH_UnitTypeArmor[unitType] then
        local baseArmor = GameInfo.TKH_UnitTypeArmor[unitType].BaseArmor

        -- AI增强模式，AI玩家改变骑兵护甲
        if (GameConfiguration.GetValue("AI_INFERNO_MODE") or GameConfiguration.GetValue("AI_ENHANCE_MODE")) and not pPlayer:IsHuman() then
            if unitType == 'UNIT_CAVALRY' or unitType == 'UNIT_CUIRASSIER' then
                baseArmor = 400
            end
        end

        pUnit:SetProperty('TKH_Armor', baseArmor)
        pUnit:SetProperty('TKH_MaxArmor', baseArmor)
        pUnit:SetProperty('TKH_ExtraMaxArmor', 0)
    end

    local unitAbility = pUnit:GetAbility():GetAbilities()
    if (unitAbility ~= nil) then
        for i, ability in ipairs(unitAbility) do
            local abilityType = GameInfo.UnitAbilities[ability.Ability].UnitAbilityType
            if string.match(abilityType, 'ABILITY_TKH_EA_ARMOR_') ~= nil then
                local changeValue = abilityType == 'ABILITY_TKH_EA_ARMOR_JINZHANGANGBANJIA' and 100 or 50
                ChangeExtraMaxArmor(pUnit, changeValue)
            end
        end
    end
end

function OnUnitAbilityGained(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local abilityType = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType

    -- print('OnUnitAbilityGained: abilityType = ', abilityType, playerID, unitID)

    if string.match(abilityType, 'ABILITY_TKH_EA_ARMOR_') ~= nil then
        ChangeExtraMaxArmor(pUnit, aORb(abilityType == 'ABILITY_TKH_EA_ARMOR_JINZHANGANGBANJIA', 100, 50))
    end

    local armorValue = ABILITIES_ARMOR[abilityType]
    if armorValue then
        ChangeExtraMaxArmor(pUnit, armorValue)
    end

    -- for atype, value in pairs(ABILITIES_ARMOR) do
    --     if abilityType == atype then
    --     end
    -- end
end

function OnUnitAbilityLost(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local abilityType = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType

    local armorValue = ABILITIES_ARMOR[abilityType]
    if armorValue then
        ChangeExtraMaxArmor(pUnit, -armorValue)
    end
end

--- 单位晋升
---@param playerID number
---@param unitID number
function OnUnitPromoted(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local unitInfo = GameInfo.Units[pUnit:GetType()]
    local pUnitType = unitInfo.UnitType
    local promotionClass = unitInfo.PromotionClass
    local promotedIndexes = pUnit:GetProperty('TKH_UNIT_PROMOTED_INDEXES') or {}
    local exp = pUnit:GetExperience()
    for row in GameInfo.UnitPromotions() do
        if row.PromotionClass == promotionClass then
            if exp:HasPromotion(row.Index) then
                -- promotedIndexes
                if not promotedIndexes[row.UnitPromotionType] and PROMOTED_EXTRA_ARMOR[row.UnitPromotionType] then
                    ChangeExtraMaxArmor(pUnit, PROMOTED_EXTRA_ARMOR[row.UnitPromotionType])
                end
                promotedIndexes[row.UnitPromotionType] = true
            end
        end
    end
    pUnit:SetProperty('TKH_UNIT_PROMOTED_INDEXES', promotedIndexes)
    TreatArmor(pUnit, math.max(50 - pUnit:GetDamage(), 0))
end

function OnOnPillaged(iUnitPlayerID, iUnitID, eImprovement, eBuilding, eDistrict, iPlotIndex)
    local pUnit = UnitManager.GetUnit(iUnitPlayerID, iUnitID)
    local improvementInfo = GameInfo.Improvements[eImprovement]
    local buildingInfo = GameInfo.Buildings[eBuilding]
    local districtInfo = GameInfo.Districts[eDistrict]
    local PLUNDER_HEAL = nil
    if improvementInfo and improvementInfo.PlunderType == 'PLUNDER_HEAL' then
        PLUNDER_HEAL = improvementInfo.PlunderAmount
    end
    if districtInfo and districtInfo.PlunderType == 'PLUNDER_HEAL' then
        PLUNDER_HEAL = districtInfo.PlunderAmount
    end

    -- print(improvementInfo, PLUNDER_HEAL, PLUNDER_HEAL-pUnit:GetDamage(), math.max(PLUNDER_HEAL-pUnit:GetDamage(), 0))
    if PLUNDER_HEAL then
        TreatArmor(pUnit, math.max(PLUNDER_HEAL - pUnit:GetDamage(), 0))
    end
end

--- 更改战斗伤害结果
---@param info table
function ModifierCombatResult(info)
    if info.UseAvergeDamage then
        return
    end

    local armorChangeValue = 0

    if info.CombatVersusType == DB.MakeHash('COMBAT_UNIT_VS_UNIT') then
        local attack_unit = UnitManager.GetUnit(info.AttackerPlayerID, info.AttackerUnitID)
        local aUnitType = GameInfo.Units[attack_unit:GetType()].UnitType
        local defend_unit = UnitManager.GetUnit(info.DefenderPlayerID, info.DefenderUnitID)
        local dUnitType = GameInfo.Units[defend_unit:GetType()].UnitType

        if (not attack_unit) or (not defend_unit) then
            return
        end

        local attack_damage, defend_damage = UnitCombatDamageModifier(attack_unit, defend_unit, info)
        local attack_unit_armor = attack_unit:GetProperty('TKH_Armor') or 0
        local defend_unit_armor = defend_unit:GetProperty('TKH_Armor') or 0


        info.AttackerDamageTakenFromDefender, attack_unit_armor, armorChangeValue = CalculateArmorReduce(attack_damage,
            attack_unit_armor)
        attack_unit:SetProperty('TKH_Armor', attack_unit_armor)
        UnitArmorChangeText(attack_unit, -armorChangeValue)
        OnUnitArmorChanged(attack_unit)

        info.DefenderDamageTaken, defend_unit_armor, armorChangeValue = CalculateArmorReduce(defend_damage,
            defend_unit_armor)
        defend_unit:SetProperty('TKH_Armor', defend_unit_armor)
        UnitArmorChangeText(defend_unit, -armorChangeValue)
        OnUnitArmorChanged(defend_unit)

        -- 单位收到伤害后效果处理
        if attack_damage > 0 then
            OnUnitGetArmorOrDamageDecreased(attack_unit)
        end
        if defend_damage > 0 then
            OnUnitGetArmorOrDamageDecreased(defend_unit)
        end

        -- =====================HERO EFFECT=====================
        math.randomseed(GetRandomSeed())

        -- 马超：西凉铁骑、浑天锤，攻击后敌方失去所有移动力
        if attack_unit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_MA_CHAO_1_5"].Index) then
            AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_PARAMETER',
                defend_unit:GetMovesRemaining(), '西凉铁骑')

            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end
        if IsUnitHaveAbility(attack_unit, { 'ABILITY_TKH_EQUIPMENT_FeiJiangZhanGong' }) and math.random(100) < 20 then
            AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_PARAMETER',
                defend_unit:GetMovesRemaining(), '飞将战弓')
            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end


        if IsUnitHaveAbility(attack_unit, { 'ABILITY_UNIT_HERO_TKH_XIAHOU_YUAN' }) then
            local percent = 20
            if IsUnitHaveAbility(attack_unit, { 'ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_XIAHOU_YUAN' }) then
                percent = percent + 20
            end
            if math.random(100) < percent then
                AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_PARAMETER',
                    defend_unit:GetMovesRemaining(), '束缚箭')
                UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
            end
        end

        -- =====================单位控制技能 命中要害=====================
        local basePercent = 0
        if GameInfo.TKH_UnitTypeControlCrit[aUnitType] ~= nil then
            basePercent = GameInfo.TKH_UnitTypeControlCrit[aUnitType].Percent or 0
        end
        local percent = basePercent + (attack_unit:GetProperty('EXTRA_CRIT_PERCENT') or 0)
        -- 技能增加几率
        percent = GetUnitAbilitiesParameterSum(attack_unit, ABILITIES_CRIT_PERCENT, percent)

        -- 免疫命中要害 = 几率变0
        if IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_WuWangBaoYu') or
            IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_HanHuangBaoYu') or
            IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_WeiWangBaoYu') then
            percent = 0
            AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_NON_CRIT')
        end
        local lostMoves = math.max(0, defend_unit:GetMovesRemaining() - 1)
        math.randomseed(GetRandomSeed())
        if percent > 0 and math.random(100) < percent then
            UnitManager.ChangeMovesRemaining(defend_unit, -lostMoves)
            AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_CRIT')
        end

        -- =====================南蛮单位效果=====================
        local diplomacy = Players[attack_unit:GetOwner()]:GetDiplomacy()
        local adjUnits = GetNeighborUnits(defend_unit:GetX(), defend_unit:GetY(), 1)


        if adjUnits ~= nil and #adjUnits > 0 then
            -- 木鹿大王：攻击时可对目标单位两侧单元格上的敌方单位造成同等伤害。
            if aUnitType == 'UNIT_HERO_TKH_MU_LU' then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, defend_damage)
                    end
                end
            end

            -- 祝融夫人：攻击时对与攻击目标相邻且不与祝融夫人相邻的单位造成30点溅射伤害。
            if aUnitType == 'UNIT_HERO_TKH_ZHU_RONG' then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID())
                        and Map.GetPlotDistance(adjUnit:GetX(), adjUnit:GetY(), attack_unit:GetX(), attack_unit:GetY()) ~= 1 then
                        DamageUnit(adjUnit, HeroConstants.ZHU_RONG_DAMAGE)
                    end
                end
            end

            -- 沙摩柯：攻击时对目标一个单元个内的所有敌方单位造成10点伤害
            if aUnitType == 'UNIT_HERO_TKH_SHA_MOKE' then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, HeroConstants.SHA_MOKE_DAMAGE)
                    end
                end
            end

            -- 铁石弹专属
            if IsUnitHaveAbility(attack_unit, 'ABILITY_TKH_EQUIPMENT_TieShiDan_HeroExclusive') then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, 10)
                    end
                end
            end
        end

        -- =====================HERO EFFECT=====================
    elseif info.CombatVersusType == DB.MakeHash('COMBAT_DISTRICT_VS_UNIT') then
        -- 防御区域攻击单位
        local defend_unit = UnitManager.GetUnit(info.DefenderPlayerID, info.DefenderUnitID)
        if not defend_unit then
            return
        end

        local defend_unit_armor = defend_unit:GetProperty('TKH_Armor') or 0

        if info.DefenderDamageTaken > 0 then
            OnUnitGetArmorOrDamageDecreased(defend_unit)
        end

        info.DefenderDamageTaken, defend_unit_armor, armorChangeValue = CalculateArmorReduce(info.DefenderDamageTaken,
            defend_unit_armor)
        defend_unit:SetProperty('TKH_Armor', defend_unit_armor)
        UnitArmorChangeText(defend_unit, -armorChangeValue)
        OnUnitArmorChanged(defend_unit)
    elseif info.CombatVersusType == DB.MakeHash('COMBAT_UNIT_VS_DISTRICT') then
        -- 单位攻击防御区域
        local attack_unit = UnitManager.GetUnit(info.AttackerPlayerID, info.AttackerUnitID)
        if not attack_unit then
            return
        end

        local attack_unit_armor = attack_unit:GetProperty('TKH_Armor') or 0

        if info.AttackerDamageTakenFromDefender > 0 then
            OnUnitGetArmorOrDamageDecreased(attack_unit)
        end

        info.AttackerDamageTakenFromDefender, attack_unit_armor, armorChangeValue = CalculateArmorReduce(
            info.AttackerDamageTakenFromDefender,
            attack_unit_armor)
        attack_unit:SetProperty('TKH_Armor', attack_unit_armor)
        UnitArmorChangeText(attack_unit, -armorChangeValue)
        OnUnitArmorChanged(attack_unit)
    end

    -- 经验值修改
    info.AttackerExperienceEarned = math.max(info.AttackerExperienceEarned, 4)

    return info
end

function Initialize()
    Events.UnitAddedToMap.Add(RegisterArmor)
    Events.UnitAbilityGained.Add(OnUnitAbilityGained)
    Events.UnitAbilityLost.Add(OnUnitAbilityLost)

    Events.UnitPromoted.Add(OnUnitPromoted)

    GameEvents.ALPostGenerateCombatResult.Add(ModifierCombatResult)
    GameEvents.OnPillage.Add(OnOnPillaged)

    Events.UnitDamageChanged.Add(function(playerID, unitID, newDamage, prevDamage)
        local unit = UnitManager.GetUnit(playerID, unitID)
        print('UnitDamageChanged: ', playerID, unitID, newDamage, prevDamage, UnitManager.GetOperationTypeName(unit))
        if newDamage > prevDamage then
            OnUnitGetArmorOrDamageDecreased(unit)
        end
    end)
end

-- Events.LoadGameViewStateDone.Add(Initialize);

Initialize()
