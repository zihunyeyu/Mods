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
local MELEE_COMBAT_DFENDED_DECREASE_RATE = 0.7
local MELEE_COMBAT_ATTACK_DECREASE_RATE = 0.5

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

    print('原始伤害：', attack_damage, defend_damage)
    -- -- 吸血效果
    for ability, life_steal_rate in pairs(LIFE_STEAL_ABILITIES) do
        if aUnit and IsUnitHaveAbility(aUnit, ability) then
            TreatUnit(aUnit, math.floor(defend_damage * life_steal_rate))
        end
        if dUnit and IsUnitHaveAbility(dUnit, ability) then
            TreatUnit(dUnit, math.floor(attack_damage * life_steal_rate))
        end
    end

    if aUnit == nil and dUnit == nil then
        return attack_damage, defend_damage
    end

    -- 1. 防御方固定减伤 30%
    defend_damage = math.floor(defend_damage * (1 - CONSTANT_DAMAGE_DECREASE_RATE))
    print('固定减伤后：', defend_damage)

    -- 1.1 单位类型固定减伤
    if info.CombatType == MELEE_COMBAT then
        attack_damage = aORb(attack_damage > COMBAT_DECREASE_VALUE,
            COMBAT_DECREASE_VALUE * MELEE_COMBAT_ATTACK_DECREASE_RATE, COMBAT_DECREASE_VALUE)
        defend_damage = aORb(defend_damage > COMBAT_DECREASE_VALUE,
            COMBAT_DECREASE_VALUE * MELEE_COMBAT_DFENDED_DECREASE_RATE, COMBAT_DECREASE_VALUE)
    elseif info.CombatType == RANGED_COMBAT then
        defend_damage = CalculateRangeDamage(defend_damage)
    end

    -- 2. 技能减伤 加算
    local ability_decrease_damage_percent = 0
    for ability, decrease_value in pairs(DECREASE_DAMAGE_ABILITIES) do
        if IsUnitHaveAbility(dUnit, ability) then
            -- defend_damage = math.floor(defend_damage * (1 - decrease_value))
            ability_decrease_damage_percent = ability_decrease_damage_percent + decrease_value
        end
    end
    defend_damage = math.floor(defend_damage * (1 - math.min(1, ability_decrease_damage_percent)))
    print('技能减伤后：', defend_damage)


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
        print('兵种克制：', defend_damage)


        -- 固定伤害类技能（无判断条件）
        local CONSTANT_DAMAGE_ABILITIES = {
            ABILITY_TKH_EQUIPMENT_SUIT_WUZHUI4 = 10,
        }

        for key, value in pairs(CONSTANT_DAMAGE_ABILITIES) do
            if IsUnitHaveAbility(aUnit, key) then
                defend_damage = defend_damage + value
            end
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
        end
    end

    -- 闪避伤害
    if dUnit then
        local doogeRate = 0
        for ability, dooge_rate in pairs(DODGE_ABILITIES) do
            if IsUnitHaveAbility(dUnit, ability) then
                doogeRate = doogeRate + dooge_rate
            end
        end
        if math.random() <= doogeRate then
            defend_damage = 0
        end
    end

    if IsUnitHaveAbility(aUnit, 'ABILITY_UNIT_HERO_TKH_XU_CHU') then
        attack_damage = 0
    end

    return attack_damage, defend_damage
end

function OnUnitGetArmorOrDamageDecreased(pUnit)
    -- 无火洞主-晋升：战斗后回复5点生命值
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_S_HERO_SKILL_WU_HUO_DONG_ZHU_2') then
        TreatUnit(pUnit, 5)
    end
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
        local adjustStrength = math.min(15, (math.floor(decrease_armor / 50)) * HeroConstants.ZHOU_TAI_YU_XUE_ATTACK)
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

    if string.match(abilityType, 'ABILITY_TKH_EA_ARMOR_') ~= nil then
        ChangeExtraMaxArmor(pUnit, aORb(abilityType == 'ABILITY_TKH_EA_ARMOR_JINZHANGANGBANJIA', 100, 50))
    end

    for atype, value in pairs(ABILITIES_ARMOR) do
        if abilityType == atype then
            ChangeExtraMaxArmor(pUnit, value)
        end
    end
end

function OnUnitAbilityLost(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local abilityType = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType

    for atype, value in pairs(ABILITIES_ARMOR) do
        if abilityType == atype then
            ChangeExtraMaxArmor(pUnit, -value)
        end
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

        if defend_damage > 0 then
            OnUnitGetArmorOrDamageDecreased(defend_unit)
        end



        -- =====================HERO EFFECT=====================
        math.randomseed(GetRandomSeed())

        -- 马超：西凉铁骑、浑天锤，攻击后敌方失去所有移动力
        if attack_unit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_MA_CHAO_1_5"].Index) then
            AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_PARAMETER',
                defend_unit:GetMovesRemaining())

            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end
        if IsUnitHaveAbility(attack_unit, { 'ABILITY_TKH_EQUIPMENT_FeiJiangZhanGong' }) and math.random(100) < 20 then
            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end

        if IsUnitHaveAbility(attack_unit, { 'ABILITY_UNIT_HERO_TKH_XIAHOU_YUAN' }) and math.random(100) < 20 then
            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end

        if IsUnitHaveAbility(attack_unit, { 'ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_XIAHOU_YUAN' }) and math.random(100) < 40 then
            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end
        -- 单位控制技能 命中要害
        if GameInfo.TKH_UnitTypeControlCrit[aUnitType] then
            local basePercent = aORb(GameInfo.TKH_UnitTypeControlCrit[aUnitType] ~= nil,
                GameInfo.TKH_UnitTypeControlCrit[aUnitType].Percent, 0)
            local percent = basePercent + (attack_unit:GetProperty('EXTRA_CRIT_PERCENT') or 0)

            -- 技能增加几率
            for ability, value in pairs(ABILITIES_CRIT_PERCENT) do
                if IsUnitHaveAbility(attack_unit, ability) then
                    percent = percent + value
                end
            end

            -- 免疫命中要害 = 几率变0
            if IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_WuWangBaoYu') or
                IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_HanHuangBaoYu') or
                IsUnitHaveAbility(defend_unit, 'ABILITY_TKH_EQUIPMENT_WeiWangBaoYu') then
                percent = 0
                AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_NON_CRIT')
            end
            local lostMoves = math.max(0, defend_unit:GetMovesRemaining() - 1)
            math.randomseed(GetRandomSeed())

            if percent > 0 then
                AddWorldViewText(defend_unit:GetX(), defend_unit:GetY(), 'LOC_TKH_LOST_MOVEMENT_CRIT')
                if math.random(100) < percent then
                    UnitManager.ChangeMovesRemaining(defend_unit, -lostMoves)
                end
            end
        end

        -- 蛮族
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
    elseif info.CombatVersusType == 109217514 then
        -- 防御区域攻击单位
        local defend_unit = UnitManager.GetUnit(info.DefenderPlayerID, info.DefenderUnitID)
        if not defend_unit then
            return
        end

        local _, defend_damage = UnitCombatDamageModifier(nil, defend_unit, info)
        local defend_unit_armor = defend_unit:GetProperty('TKH_Armor') or 0
        info.DefenderDamageTaken, defend_unit_armor, armorChangeValue = CalculateArmorReduce(defend_damage,
            defend_unit_armor)
        defend_unit:SetProperty('TKH_Armor', defend_unit_armor)
        UnitArmorChangeText(defend_unit, -armorChangeValue)
        OnUnitArmorChanged(defend_unit)

        if defend_damage > 0 then
            OnUnitGetArmorOrDamageDecreased(defend_unit)
        end
    elseif info.CombatVersusType == -1024206813 then
        -- 单位攻击防御区域
        local attack_unit = UnitManager.GetUnit(info.AttackerPlayerID, info.AttackerUnitID)
        if not attack_unit then
            return
        end

        local attack_damage, _ = UnitCombatDamageModifier(attack_unit, nil, info)
        local attack_unit_armor = attack_unit:GetProperty('TKH_Armor') or 0
        info.AttackerDamageTakenFromDefender, attack_unit_armor, armorChangeValue = CalculateArmorReduce(attack_damage,
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
