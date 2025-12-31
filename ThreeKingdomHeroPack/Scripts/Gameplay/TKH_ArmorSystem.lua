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


local MELEE_COMBAT_ATTACK_DECREASE_RATE = 0.5
local MELEE_COMBAT_DFENDE_DECREASE_RATE = 0.7

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
    -- 748940753 近战
    -- 784649805 远程
    math.randomseed(GetRandomSeed())

    if aUnit then
        local aUnitType = GameInfo.Units[aUnit:GetType()].UnitType
        if info.CombatType == 748940753 then
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

        if IsUnitHaveAbility(aUnit, 'ABILITY_UNIT_HERO_TKH_ZHANG_FEI') then
            defend_damage = defend_damage + 25
        end

        -- 武圣骁卫 武圣威压：攻击时有50%概率额外造成30%伤害。
        if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_SPECIAL_UNIT_WU_SHENG_FULL_PROMOTED') then
            math.randomseed(GetRandomSeed())
            if math.random() < FULL_PROMOTED_ABILITY_PARAMETERS.WU_SHENG_PROBABILITY then
                defend_damage = math.floor(defend_damage * (1 + FULL_PROMOTED_ABILITY_PARAMETERS.WU_SHENG_RATE))
            end
        end
    end

    if dUnit then
        local dUnitType = GameInfo.Units[dUnit:GetType()].UnitType
        if info.CombatType == 748940753 then
            if defend_damage > 30 then
                defend_damage = 30 + math.floor((defend_damage - 30) * 0.7)
            end
        elseif info.CombatType == 784649805 then
            defend_damage = CalculateRangeDamage(defend_damage)
        end

        -- 被攻击英雄特效
        -- 赵云：受到攻击时有一定概率闪避伤害
        if dUnitType == 'UNIT_HERO_TKH_ZHAO_YUN' then
            if math.random() <= HeroConstants.ZHAO_YUN_DODGE_RATE then
                defend_damage = 0
            end
            -- 周泰：受到攻击时减少部分伤害
        elseif dUnitType == 'UNIT_HERO_TKH_ZHOU_TAI' then
            defend_damage = defend_damage * HeroConstants.ZHOU_TAI_HEAL_RATE
            Game.AddWorldViewText(0, "自愈：减少了部分伤害", info.PlotX, info.PlotY)
        end

        -- 被攻击装备特效
        -- 飒露紫：受到攻击时有一定概率闪避伤害
        if IsUnitHaveAbility(dUnit, 'ABILITY_TKH_EQUIPMENT_SALUZI') then
            if math.random() <= EquipmentConstants.SALUZI_RATE then
                defend_damage = 0
            end
        end
    end

    return attack_damage, defend_damage
end

function OnUnitArmorChanged(pUnit)
    -- 周泰-浴血奋战：护甲减少攻击力提升
    if pUnit:GetExperience():HasPromotion(ZHOU_TAI_PROMOTION_YU_XUE) then
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

    local armroChangeValue = 0
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

        info.AttackerDamageTakenFromDefender, attack_unit_armor, armroChangeValue = CalculateArmorReduce(attack_damage,
            attack_unit_armor)
        attack_unit:SetProperty('TKH_Armor', attack_unit_armor)
        UnitArmorChangeText(attack_unit, -armroChangeValue)
        OnUnitArmorChanged(attack_unit)

        info.DefenderDamageTaken, defend_unit_armor, armroChangeValue = CalculateArmorReduce(defend_damage,
            defend_unit_armor)
        defend_unit:SetProperty('TKH_Armor', defend_unit_armor)
        UnitArmorChangeText(defend_unit, -armroChangeValue)
        OnUnitArmorChanged(defend_unit)
    elseif info.CombatVersusType == 109217514 then
        -- 防御攻击单位
        local defend_unit = UnitManager.GetUnit(info.DefenderPlayerID, info.DefenderUnitID)
        if not defend_unit then
            return
        end

        local attack_damage, defend_damage = UnitCombatDamageModifier(nil, defend_unit, info)
        local defend_unit_armor = defend_unit:GetProperty('TKH_Armor') or 0
        info.DefenderDamageTaken, defend_unit_armor, armroChangeValue = CalculateArmorReduce(defend_damage,
            defend_unit_armor)
        defend_unit:SetProperty('TKH_Armor', defend_unit_armor)
        UnitArmorChangeText(defend_unit, -armroChangeValue)
        OnUnitArmorChanged(defend_unit)
    elseif info.CombatVersusType == -1024206813 then
        -- 单位攻击防御
        local attack_unit = UnitManager.GetUnit(info.AttackerPlayerID, info.AttackerUnitID)
        if not attack_unit then
            return
        end

        local attack_damage, defend_damage = UnitCombatDamageModifier(attack_unit, nil, info)
        local attack_unit_armor = attack_unit:GetProperty('TKH_Armor') or 0
        info.AttackerDamageTakenFromDefender, attack_unit_armor, armroChangeValue = CalculateArmorReduce(attack_damage,
            attack_unit_armor)
        attack_unit:SetProperty('TKH_Armor', attack_unit_armor)
        UnitArmorChangeText(attack_unit, -armroChangeValue)
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
    end)
end

-- Events.LoadGameViewStateDone.Add(Initialize);

Initialize()
