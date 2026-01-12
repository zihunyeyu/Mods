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

local COMBAT_DECREASE_VALUE = 30
local MELEE_COMBAT_DFENDE_DECREASE_RATE = 0.7
local MELEE_COMBAT_ATTACK_DECREASE_RATE = 0.5

local RANGED_COMBAT_DEFEND_MAX_DAMAGE = 40
-- ===========================================================================
--	VARIABLES
-- ===========================================================================

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

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
    local attack_damage = info.AttackerDamageTakenFromDefender
    local defend_damage = info.DefenderDamageTaken

    math.randomseed(GetRandomSeed())

    if not aUnit or not dUnit then
        return attack_damage, defend_damage
    end

    local aUnitType = GameInfo.Units[aUnit:GetType()].UnitType
    local dUnitType = GameInfo.Units[dUnit:GetType()].UnitType

    -- 8.兵种克制能力
    if MatchUnitTag(aUnitType, 'CLASS_ANTI_CAVALRY') and MatchUnitTag(dUnitType, { 'CLASS_HEAVY_CAVALRY', 'CLASS_HEAVY_CHARIOT', 'CLASS_LIGHT_CAVALRY', 'CLASS_LIGHT_CHARIOT' }) then
        defend_damage = defend_damage + 20
    end
    if MatchUnitTag(aUnitType, 'CLASS_MELEE') and MatchUnitTag(dUnitType, 'CLASS_ANTI_CAVALRY') then
        defend_damage = defend_damage + 20
    end
    if MatchUnitTag(aUnitType, { 'CLASS_HEAVY_CAVALRY', 'CLASS_HEAVY_CHARIOT', 'CLASS_LIGHT_CAVALRY', 'CLASS_LIGHT_CHARIOT' }) and MatchUnitTag(dUnitType, 'CLASS_MELEE') then
        defend_damage = defend_damage + 20
    end

    if aUnit then
        if info.CombatType == MELEE_COMBAT then
            if attack_damage > 30 then
                attack_damage = 30 + math.floor((attack_damage - 30) * 0.5)
            end
        end

        -- 七星刀：攻击时有50%几率再造成一次同等伤害
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_EQUIPMENT_QiXingDao') then
            if math.random() < EquipmentConstants.QI_XING_DAO_RATE then
                defend_damage = defend_damage * 2
            end
        end

        -- 单位满级晋升增加伤害
        if aUnit:GetProperty('EXTRA_DAMAGE_BOUNS') then
            local damage_bouns = aUnit:GetProperty('EXTRA_DAMAGE_BOUNS') or {}
            for _, value in ipairs(damage_bouns) do
                if value[1] and value[2] then
                    math.randomseed(GetRandomSeed())
                    local percent = value[1]
                    local bouns = value[2]
                    if percent <= math.random(100) then
                        defend_damage = defend_damage * bouns
                    end
                end
            end
        end

        -- 增加伤害
        for ability, increase_value in pairs(INCREASE_DAMAGE_ABILITIES) do
            if IsUnitHaveAbility(aUnit, ability) then
                if increase_value >= 1 then
                    defend_damage = defend_damage + increase_value
                else
                    -- 百分比增加伤害
                    defend_damage = math.floor(defend_damage * (1 + increase_value))
                end
            end
        end

        -- 增加伤害 条件
        -- 张郃
        if IsUnitHaveAbility(aUnit, 'ABILITY_TK_S_HERO_SKILL_ZHANG_HE_3') and MatchUnitTag(dUnitType, 'CLASS_RANGED') then
            defend_damage = defend_damage + 40
        end
        -- 魏延
        if IsUnitHaveAbility(aUnit, 'ABILITY_TK_S_HERO_SKILL_WEI_YAN_2') and MatchUnitTag(dUnitType, 'CLASS_MELEE') then
            defend_damage = defend_damage + 40
        end

        -- 卑弥呼
        if IsUnitHaveAbility(aUnit, 'ABILITY_TK_S_HERO_SKILL_BEI_MI_HU_2') and MatchUnitTag(dUnitType, 'CLASS_TKH_CAVALRY') then
            defend_damage = defend_damage + 40
        end
    end

    if dUnit then
        if info.CombatType == MELEE_COMBAT then
            if defend_damage > COMBAT_DECREASE_VALUE then
                defend_damage = COMBAT_DECREASE_VALUE +
                    math.floor((defend_damage - COMBAT_DECREASE_VALUE) * MELEE_COMBAT_DFENDE_DECREASE_RATE)
            else
                defend_damage = math.floor(defend_damage * MELEE_COMBAT_DFENDE_DECREASE_RATE)
            end
        elseif info.CombatType == RANGED_COMBAT then
            defend_damage = CalculateRangeDamage(defend_damage)
        end

        -- 闪避伤害
        for ability, dooge_rate in pairs(DODGE_ABILITIES) do
            if IsUnitHaveAbility(dUnit, ability) and math.random() <= dooge_rate then
                defend_damage = 0
            end
        end

        -- 减少伤害
        for ability, decrease_value in pairs(DECREASE_DAMAGE_ABILITIES) do
            if IsUnitHaveAbility(dUnit, ability) then
                if decrease_value >= 1 then
                    defend_damage = math.max(0, defend_damage - decrease_value)
                else
                    -- 百分比减少伤害
                    defend_damage = math.floor(defend_damage * (1 - decrease_value))
                end
            end
        end
    end

    return attack_damage, defend_damage
end

function OnUnitGetArmorOrDamageDecreased(pUnit)
    -- 无火洞主动2：战斗后回复5点生命值
    if IsUnitHaveAbility(pUnit, 'ABILITY_TK_S_HERO_SKILL_WU_HUO_DONG_ZHU_2') then
        TreatUnit(pUnit, 5)
    end
end

function OnUnitArmorChanged(pUnit)
    -- HUA_XIONG_BAO_ZOU：护甲减少时，提升攻击力
    if IsUnitHaveAbility(pUnit, 'ABILITY_TK_S_HERO_SKILL_HUA_XIONG_2') then
        local armor = pUnit:GetProperty('TKH_Armor') or 0
        local maxArmor = pUnit:GetProperty('TKH_MaxArmor') or 0
        local extraMaxArmor = pUnit:GetProperty('TKH_ExtraMaxArmor') or 0
        local decrease_armor = maxArmor + extraMaxArmor - armor
        if decrease_armor >= 10 then
            pUnit:SetProperty('HUA_XIONG_BAO_ZOU', 10)
        else
            pUnit:SetProperty('HUA_XIONG_BAO_ZOU', 0)
        end
    end

    -- 周泰-浴血奋战：护甲减少攻击力提升
    if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_ZHOU_TAI_3_5"].Index) then
        local dUnitDamage = pUnit:GetDamage()
        if dUnitDamage > 0 then
            local armor = pUnit:GetProperty('TKH_Armor') or 0
            local maxArmor = pUnit:GetProperty('TKH_MaxArmor') or 0
            local extraMaxArmor = pUnit:GetProperty('TKH_ExtraMaxArmor') or 0
            local adjustStrength = (math.floor((maxArmor + extraMaxArmor - armor) / 50)) *
                HeroConstants.ZHOU_TAI_YU_XUE_ATTACK
            adjustStrength = math.min(15, adjustStrength)
            pUnit:SetProperty('COMBAT_STRENGTH_BY_LOST_HEALTH', adjustStrength)
        end
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
        local changeValue = abilityType == 'ABILITY_TKH_EA_ARMOR_JINZHANGANGBANJIA' and 100 or 50
        ChangeExtraMaxArmor(pUnit, changeValue)
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

--- 更改战斗信息
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

        if not attack_unit or not defend_unit then
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

        -- 吸血效果
        -- 增加伤害
        for ability, life_steal_rate in pairs(LIFE_STEAL_ABILITIES) do
            if IsUnitHaveAbility(attack_unit, ability) then
                TreatUnit(attack_unit, math.floor(defend_damage * life_steal_rate))
            end
            if IsUnitHaveAbility(defend_unit, ability) then
                TreatUnit(defend_unit, math.floor(attack_damage * life_steal_rate))
            end
        end

        if defend_damage > 0 then
            OnUnitGetArmorOrDamageDecreased(defend_unit)
        end



        -- =====================HERO EFFECT=====================


        -- 马超：西凉铁骑、浑天锤，攻击后敌方失去所有移动力
        if IsUnitHaveAbility(attack_unit, 'ABILITY_TKH_EQUIPMENT_HunTianChui') or attack_unit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_MA_CHAO_1_5"].Index) then
            UnitManager.ChangeMovesRemaining(defend_unit, -defend_unit:GetMovesRemaining())
        end

        -- 单位控制技能
        if GameInfo.TKH_UnitTypeControlCrit[aUnitType] then
            local basePercent = GameInfo.TKH_UnitTypeControlCrit[aUnitType].Percent
            local extraPercent = attack_unit:GetProperty('EXTRA_CRIT_PERCENT') or 0
            local lostMoves = math.max(0, defend_unit:GetMovesRemaining() - 1)
            math.randomseed(GetRandomSeed())
            if (basePercent + extraPercent) <= math.random(100) then
                UnitManager.ChangeMovesRemaining(defend_unit, -lostMoves)
            end
        end

        -- 蛮族
        local diplomacy = Players[attack_unit:GetOwner()]:GetDiplomacy()
        local adjUnits = GetNeighborUnits(defend_unit:GetX(), defend_unit:GetY(), 1)


        if adjUnits ~= nil and #adjUnits > 0 then
            -- 木鹿大王：攻击时可对目标单位两侧单元格上的敌方单位造成同等伤害。
            if aUnitInfo.UnitType == 'UNIT_HERO_TKH_MU_LU' then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, defend_damage)
                    end
                end
            end

            -- 铁石弹专属
            if IsUnitHaveAbility(attack_unit, 'ABILITY_TKH_EQUIPMENT_TIESHIDAN_HeroExclusive') then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, 10)
                    end
                end
            end

            -- 祝融夫人：攻击时对与攻击目标相邻且不与祝融夫人相邻的单位造成30点溅射伤害。
            if IsUnitHaveAbility(attack_unit, 'ABILITY_UNIT_HERO_TKH_ZHU_RONG') then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID())
                        and Map.GetPlotDistance(adjUnit:GetX(), adjUnit:GetY(), attack_unit:GetX(), attack_unit:GetY()) ~= 1 then
                        DamageUnit(adjUnit, HeroConstants.ZHU_RONG_DAMAGE)
                    end
                end
            end


            -- 沙摩柯：攻击时对目标一个单元个内的所有敌方单位造成10点伤害
            if IsUnitHaveAbility(attack_unit, 'ABILITY_UNIT_HERO_TKH_SHA_MOKE') then
                for _, adjUnit in ipairs(adjUnits) do
                    if diplomacy:IsAtWarWith(adjUnit:GetOwner()) and (adjUnit:GetID() ~= defend_unit:GetID()) then
                        DamageUnit(adjUnit, HeroConstants.SHA_MOKE_DAMAGE)
                    end
                end
            end
        end

        -- =====================HERO EFFECT=====================
    elseif info.CombatVersusType == 109217514 then
        -- 防御攻击单位
        local defend_unit = UnitManager.GetUnit(info.DefenderPlayerID, info.DefenderUnitID)
        if not defend_unit then
            return
        end

        local attack_damage, defend_damage = UnitCombatDamageModifier(nil, defend_unit, info)
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
        -- 单位攻击防御
        local attack_unit = UnitManager.GetUnit(info.AttackerPlayerID, info.AttackerUnitID)
        if not attack_unit then
            return
        end

        local attack_damage, defend_damage = UnitCombatDamageModifier(attack_unit, nil, info)
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
