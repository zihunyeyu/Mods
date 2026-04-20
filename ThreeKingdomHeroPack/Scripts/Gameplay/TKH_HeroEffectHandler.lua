-- TKH_HeroEffectHandler
-- Author: PurpleSoul
-- DateCreated: 3/8/2025 12:25:07 AM
--------------------------------------------------------------
---

print("加载英雄效果处理器 TKH_HeroEffectHandler.lua")

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



-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local HeroSummons = {}

-- ===========================================================================
--	EFFECT Events
-- ===========================================================================


function OnTurnEnd()
    local m_HeroManager = Game:GetProperty('HeroManager') or {}
    for _, hero in pairs(m_HeroManager) do
        local pUnit = UnitManager.GetUnit(hero.Owner, hero.ID)
        if pUnit then
            -- 装备效果
            -- 1. 烈焰战锤(祝融专属)、火焱铠甲、烈焱神驹：1个单元格以内的敌方单位回合结束时受到20点伤害。
            local damage_bounes = aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_HuoYan'), 1, 0) +
                aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanZhanChui'), 1, 0) +
                aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanShenJu'), 1, 0) +
                aORb(IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanZhanChui_HeroExclusive'), 1, 0)

            if damage_bounes > 0 then
                -- 相邻格位上的敌军单位受到伤害
                local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()
                local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), 1)

                for _, adjUnit in ipairs(adjUnits) do
                    if (adjUnit ~= nil and diplomacy:IsAtWarWith(adjUnit:GetOwner())) then
                        DamageUnit(adjUnit, 20 * damage_bounes)
                    end
                end
            end

            -- 兀突骨技能冷却判断
            local unitType = GetUnitType(pUnit)
            if unitType == 'UNIT_HERO_TKH_WU_TUGU' then
                -- _singleUseAbilityCooldown = 10
                if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_HERO_UNIT_KILL_POINT_UPGRADE_UNIQUE_WU_TUGU') then
                    pUnit:SetProperty(hero.Owner .. hero.ID .. 'UNITCOMMAND_DEAL_DAMAGE_AOE', true)
                else
                    pUnit:SetProperty(hero.Owner .. hero.ID .. 'UNITCOMMAND_DEAL_DAMAGE_AOE',
                        Game.GetCurrentGameTurn() % 2 == 0)
                end
            end
        end
    end
end

--- 击杀单位后效果
---@param killedPlayerID number
---@param killedUnitID number
---@param playerID number
---@param unitID number
function OnUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local unitInfo = GameInfo.Units[pUnit:GetType()]
    math.randomseed(GetRandomSeed())

    local unitTypeManager = Game:GetProperty('TKH_unitTypeManager') or {}
    if unitTypeManager[killedPlayerID] and unitTypeManager[killedPlayerID][killedUnitID] then
        local killUnitType = unitTypeManager[killedPlayerID][killedUnitID]
        if MatchUnitTag(killUnitType, 'CLASS_TKH_CAVALRY') and IsUnitHasPromotion(pUnit, 'PROMOTION_TK_SUN_SHANGXIANG_1_2') then
            TreatUnit(pUnit, 20)
        end
    end

    -- 张飞：万人敌，击杀单位后恢复30点生命值。
    if IsUnitHasPromotion(pUnit, 'PROMOTION_TK_ZHANG_FEI_1_5') then
        TreatUnit(pUnit, 30)
    end
    -- 河北之虎，击杀单位后恢复20点生命值。
    if IsUnitHasPromotion(pUnit, 'PROMOTION_TK_YAN_LIANG_1_5') then
        TreatUnit(pUnit, 20)
    end

    -- 夏侯惇：击杀单位后恢复30点生命值。
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_S_HERO_SKILL_XIA_HOU_DUN_2') then
        TreatUnit(pUnit, 30)
    end

    -- 关羽：若击杀敌方单位，则恢复所有 [ICON_Movement] 移动力并能再次攻击。
    if unitInfo.UnitType == 'UNIT_HERO_TKH_GUAN_YU' then
        UnitManager.RestoreMovement(pUnit, true)
        UnitManager.RestoreUnitAttacks(pUnit, true)
    elseif unitInfo.UnitType == 'UNIT_HERO_TKH_YAN_YUN_GUARD' then
        -- 给特种兵“燕云卫”+一个技能（要不然太弱了，粘贴的时候漏掉了）每击杀一个单位，回复80点生命或者护甲值。
        TreatUnit(pUnit, HeroConstants.YAN_YUN_GUARD_KILL_HEAL)
    end

    -- 武圣刀谱：攻击时+6 [ICON_Strength] 战斗力，每杀死1个单位，回复10点血量或者护甲值
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_WuShengDaoPu') then
        TreatUnit(pUnit, 10)
    end

    -- ABILITY_TKH_EQUIPMENT_JinZhanBei_HeroExclusive 金盏杯 专属效果：每击杀一个单位，额外再+100金币。）
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_JinZhanBei_HeroExclusive') then
        local treasury = Players[pUnit:GetOwner()]:GetTreasury()
        treasury:ChangeGoldBalance(100)
    end

    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_SUIT_SHANGJIN3') then
        if math.random() < 0.2 then
            local cUnit = UnitManager.InitUnit(pUnit:GetOwner(), "UNIT_SETTLER", pUnit:GetX(), pUnit:GetY())
            if cUnit ~= nil then
                UnitManager.ChangeMovesRemaining(cUnit, -cUnit:GetMovesRemaining())
            end
        end
    end

    -- 亮浩刀：击杀单位时有40%几率将其捕获为建造者（90%）或开拓者（10%）。
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LiangHaoDao') then
        if math.random() < EquipmentConstants.LIANG_HAO_DAO_RATE then
            local cUnit;
            if math.random() < EquipmentConstants.LIANG_HAO_DAO_RATE_SETTLER then
                cUnit = UnitManager.InitUnit(pUnit:GetOwner(), "UNIT_SETTLER", pUnit:GetX(), pUnit:GetY())
            else
                cUnit = UnitManager.InitUnit(pUnit:GetOwner(), "UNIT_BUILDER", pUnit:GetX(), pUnit:GetY())
            end

            if cUnit ~= nil then
                UnitManager.ChangeMovesRemaining(cUnit, -cUnit:GetMovesRemaining())
            end
        end
    end

    -- 捕获副将
    local m_sHeroManager = Game:GetProperty('sHeroManager') or {}
    -- killedPlayerID, killedUnitID
    if m_sHeroManager[killedPlayerID] and m_sHeroManager[killedPlayerID][killedUnitID] then
        local s_UnitType = m_sHeroManager[killedPlayerID][killedUnitID]
        CreatUnitAtXY(playerID, s_UnitType, pUnit:GetX(), pUnit:GetY())
        m_sHeroManager[killedPlayerID][killedUnitID] = nil
        Game:SetProperty('sHeroManager', m_sHeroManager)
    end
end

function OnGameEraChanged(previousEraIndex, newEraIndex)
    for playerID, unitIDs in pairs(HeroSummons) do
        for i = #unitIDs, 1, -1 do
            local unit = UnitManager.GetUnit(playerID, unitIDs[i])
            if not unit then
                table.remove(unitIDs, i)
            else
                unit:SetProperty('COMBAT_STRENGTH_BY_ERA', UnitEraStrength[Game.GetEras():GetCurrentEra() + 1])
            end
        end
    end
    Game:SetProperty('HeroSummons', HeroSummons)
end

function OnUnitAddedToMap(playerID, unitID)
    local unit = UnitManager.GetUnit(playerID, unitID)
    if not unit then
        return
    end
    local unitInfo = GameInfo.Units[unit:GetType()]
    if MatchUnitTag(unitInfo.UnitType, 'CLASS_TKH_SP_UNIT') then
        unit:SetProperty('COMBAT_STRENGTH_BY_ERA', UnitEraStrength[Game.GetEras():GetCurrentEra() + 1])
        if not HeroSummons[playerID] then
            HeroSummons[playerID] = {}
        end
        table.insert(HeroSummons[playerID], unitID)
    end
    Game:SetProperty('HeroSummons', HeroSummons)
end

function OnUnitAbilityGained(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local unitAbilityType = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType
    local heal_value = pUnit:GetProperty('TKH_TUEN_END_HEAL_VALUE') or 0
    pUnit:SetProperty('TKH_TUEN_END_HEAL_VALUE', heal_value + (TURN_END_HEAL[unitAbilityType] or 0))

    for ability, unitType in pairs(S_HERO_SUMMON) do
        local ability_info = GameInfo.UnitAbilities[ability]
        if ability_info and unitAbilityIndex == ability_info.Index then
            CreatUnitAtXY(playerID, unitType, pUnit:GetX(), pUnit:GetY())
        end
    end
end

function OnUnitAbilityLost(playerID, unitID, unitAbilityIndex)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    local unitAbilityType = GameInfo.UnitAbilities[unitAbilityIndex].UnitAbilityType
    local heal_value = pUnit:GetProperty('TKH_TUEN_END_HEAL_VALUE') or 0
    pUnit:SetProperty('TKH_TUEN_END_HEAL_VALUE', math.max(0, heal_value - (TURN_END_HEAL[unitAbilityType] or 0)))
end

function Initialize()
    Events.UnitKilledInCombat.Add(OnUnitKilledInCombat)
    Events.TurnEnd.Add(OnTurnEnd)

    -- 回合结束时恢复生命值或护甲值
    Events.UnitAbilityGained.Add(OnUnitAbilityGained)
    Events.UnitAbilityLost.Add(OnUnitAbilityLost)

    -- 特种兵随时代调整攻击力
    HeroSummons = Game:GetProperty('HeroSummons') or {}
    Events.UnitAddedToMap.Add(OnUnitAddedToMap)
    Events.GameEraChanged.Add(OnGameEraChanged)
end

Events.LoadGameViewStateDone.Add(Initialize);
