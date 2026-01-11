-- TKH_HeroEffectHandler
-- Author: PurpleSoul
-- DateCreated: 3/8/2025 12:25:07 AM
--------------------------------------------------------------
---

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
-- local MA_CHAO_PROMOTION_ATTACH         = 
local LIU_BEI_PROMOTION_TURN_END       = GameInfo.UnitPromotions["PROMOTION_TK_LIAO_YU_LiuBei"].Index
local LIU_BEI_PROMOTION_TURN_END_RANGE = 3
local DIAN_WEI_PROMOTION_TURN_END      = GameInfo.UnitPromotions["PROMOTION_TK_GU_ZHI_E_LAI_DW"].Index
local SUN_SHANGXIANG_PROMOTION_HEAL    = GameInfo.UnitPromotions["PROMOTION_TK_SUN_SHANGXIANG_1_2"].Index
local ZHOU_TAI_PROMOTION_BU_QU         = GameInfo.UnitPromotions["PROMOTION_TK_BU_QU_ZTai"].Index
local ZHANG_FEI_PROMOTION_WAN_REN_DI   = GameInfo.UnitPromotions["PROMOTION_TK_WAN_REN_DI_ZF"].Index


-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local HeroSummons = {}

-- ===========================================================================
--	EFFECT Events
-- ===========================================================================
-- function OnCombat(pCombatResult)

--     -- print("沙摩柯效果触发检查")

--     local combatResult = GetCombatResult(pCombatResult)

--     local vsType, attacker, defender, location = combatResult.CombatComponentTypes, combatResult.Attacker,
--         combatResult.Dfender, combatResult.Location

--     if vsType == CombatVSComponentTypes.UNIT_UNIT then
--         local aPlayerID, aUnitID = attacker[2].player, attacker[2].id
--         local aUnit = UnitManager.GetUnit(aPlayerID, aUnitID)
--         local dPlayerID, dUnitID = defender[2].player, defender[2].id
--         local dUnit = UnitManager.GetUnit(dPlayerID, dUnitID)
--         local damage = defender[3]

--         if not aUnit or not dUnit then
--             return
--         end

--         local aUnitInfo = GameInfo.Units[aUnit:GetType()]
--         local dUnitInfo = GameInfo.Units[dUnit:GetType()]

--         math.randomseed(GetRandomSeed())

--         if not dUnit:IsDelayedDeath() and not dUnit:IsDead() then

--         else
--             -- 孙尚香：攻击击杀敌方骑兵单位后，恢复20点生命值。
--             if aUnit:GetExperience():HasPromotion(SUN_SHANGXIANG_PROMOTION_HEAL) and
--                 MatchUnitTag(dUnitInfo.UnitType, 'CLASS_TKH_CAVALRY') then
--                 TreatUnit(aUnit, HeroConstants.SUN_SHANGXIANG_HEAL)
--             end
--         end




--     elseif vsType == CombatVSComponentTypes.UNIT_CITY then
--         local aPlayerID, aUnitID = attacker[2].player, attacker[2].id
--         local aUnit = UnitManager.GetUnit(aPlayerID, aUnitID)
--         if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_EQUIPMENT_TIESHIDAN_HeroExclusive') then
--             local adjUnits = GetNeighborUnits(defender[4].x, defender[4].y, 1)
--             if adjUnits ~= nil and #adjUnits > 0 then
--                 for _, adjUnit in ipairs(adjUnits) do
--                     DamageUnit(adjUnit, 10)
--                 end
--             end
--         end
--     elseif vsType == CombatVSComponentTypes.UNIT_DISTRICT then
--         local aPlayerID, aUnitID = attacker[2].player, attacker[2].id
--         local aUnit = UnitManager.GetUnit(aPlayerID, aUnitID)
--         if IsUnitHaveAbility(aUnit, 'ABILITY_TKH_EQUIPMENT_TIESHIDAN_HeroExclusive') then
--             local adjUnits = GetNeighborUnits(defender[4].x, defender[4].y, 1)
--             if adjUnits ~= nil and #adjUnits > 0 then
--                 for _, adjUnit in ipairs(adjUnits) do
--                     DamageUnit(adjUnit, 10)
--                 end
--             end
--         end
--     end
-- end

function OnUnitDamageChanged(playerID, unitID, newDamage, oldDamage)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if not pUnit then
        return
    end
    if not pUnit:IsDelayedDeath() and not pUnit:IsDead() then
        -- 周泰不屈
        if pUnit:GetExperience():HasPromotion(ZHOU_TAI_PROMOTION_BU_QU) then
            TreatUnit(pUnit, HeroConstants.ZHOU_TAI_BUQU)
        end
    end
end

--- 回合结束时单位恢复生命值
function OnTurnEnd()
    local m_HeroManager = Game:GetProperty('HeroManager') or {}
    for _, hero in pairs(m_HeroManager) do
        local pUnit = UnitManager.GetUnit(hero.Owner, hero.ID)
        if pUnit then
            -- 技能点效果
            local healPoint = pUnit:GetProperty(GameInfo.TKH_HeroKillPointSkill['HEAL'].PropertyKey)
            if healPoint then
                TreatUnit(pUnit, healPoint)
            end

            -- 根据装备
            -- 龙鳞甲
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LongLinjia') then
                TreatUnit(pUnit, 15)
            end
            -- 麒麟甲
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_QiLinJia') then
                TreatUnit(pUnit, 25)
            end
            -- 麒麟驹
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_QiLinJu') then
                TreatUnit(pUnit, 15)
            end
            -- 太平要术
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_TaiPingYaoShu') then
                TreatUnit(pUnit, 20)
            end
            -- 彩团
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_CAITUAN') then
                TreatUnit(pUnit, 10)
            end
            -- 方天画戟额外效果
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_FangTianHuaJi_HeroExclusive') then
                TreatUnit(pUnit, 10)
            end
            -- 青龙偃月刀额外效果
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_QingLongYanYueDao_HeroExclusive') then
                TreatUnit(pUnit, 10)
            end
            -- 霹雳斧额外效果
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_PILIFU_HeroExclusive') then
                TreatUnit(pUnit, 10)
            end
            -- 贯石斧额外效果
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_GUANSHIFU_HeroExclusive') then
                TreatUnit(pUnit, 10)
            end

            -- 土垚铠甲：防御时+8 [ICON_Strength] 战斗力，在每回合结束时（甚至是在移动或攻击后），恢复10点生命值。
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_TUYAO') then
                TreatUnit(pUnit, 10)
            end

            -- 火焱铠甲：防御时+8 [ICON_Strength] 战斗力，1个单元格以内的敌方单位回合结束时受到20点伤害。
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_HUOYAN') then
                -- 相邻格位上的敌军单位受到伤害
                local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()
                local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), 1)

                for _, adjUnit in ipairs(adjUnits) do
                    if (adjUnit ~= nil and diplomacy:IsAtWarWith(adjUnit:GetOwner())) then
                        DamageUnit(adjUnit, EquipmentConstants.LIE_YAN_ZHAN_CHUI_DAMAGE)
                    end
                end
            end

            -- 烈焰战锤
            if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_EQUIPMENT_LieYanZhanChui') then
                local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()
                local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), 1)

                for _, adjUnit in ipairs(adjUnits) do
                    if (adjUnit ~= nil and diplomacy:IsAtWarWith(adjUnit:GetOwner())) then
                        DamageUnit(adjUnit, EquipmentConstants.LIE_YAN_ZHAN_CHUI_DAMAGE)
                    end
                end
            end

            if hero.UnitType == 'UNIT_HERO_TKH_LIU_BEI' then
                -- 刘备：升级项回复周围单元格生命值
                if pUnit:GetExperience():HasPromotion(LIU_BEI_PROMOTION_TURN_END) then
                    local ajdunits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), LIU_BEI_PROMOTION_TURN_END_RANGE)
                    if ajdunits ~= nil and #ajdunits > 0 then
                        for _, adjUnit in ipairs(ajdunits) do
                            if adjUnit:GetOwner() == pUnit:GetOwner() and IsUnitHurt(adjUnit) then
                                TreatUnit(adjUnit, 20)
                            end
                        end
                    end
                end
            elseif hero.UnitType == 'UNIT_HERO_TKH_DIAN_WEI' then
                -- 典韦：回合结束时恢复20生命值
                if pUnit:GetExperience():HasPromotion(DIAN_WEI_PROMOTION_TURN_END) then
                    TreatUnit(pUnit, 20)
                end
            end

            if IsUnitHaveAbility(pUnit, 'ABILITY_HERO_UNIT_KILL_POINT_UPGRADE_XIANGYU') then
                TreatUnit(pUnit, HeroConstants.MULU_XIANGYU)
            end
            if IsUnitHaveAbility(pUnit, 'ABILITY_HERO_UNIT_KILL_POINT_UPGRADE_LONGWEIJIANGJUN') then
                TreatUnit(pUnit, HeroConstants.ZHAOYUN_LONGWEI)
            end

            --- 回合结束时处理羁绊效果
            if IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_YIMUTONGBAO_SUN_CE') or
                IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_YIMUTONGBAO_SUN_QUAN') then
                TreatUnit(pUnit, IMUTONGBAO_HEAL)
            end
            if IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_NANMANRUQIN_MU_LU') then
                TreatUnit(pUnit, NANMANRUQIN_HEAL)
            end
            if IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_GUAN_YU') or
                IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_ZHANG_FEI') or
                IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_ZHAO_YUN') or
                IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_MA_CHAO') or
                IsUnitHaveAbility(pUnit, 'ABILITY_MODIFIER_ABILITY_RELATIONSHIP_WUHUSHANGJIANG_HUANG_ZHONG') then
                TreatUnit(pUnit, WUHUSHANGJIANG_HEAL)
            end
        end
    end

    -- 重置关羽技能次数
    -- 关羽：若击杀敌方单位，则恢复所有 [ICON_Movement] 移动力并能再次攻击。
    -- Game:SetProperty('TKH_UNIT_HERO_TKH_GUAN_YU_RESTORE_TIMES', 0)
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

    
    -- 张飞：万人敌，击杀单位后恢复30点生命值。
    if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_WAN_REN_DI_ZF"].Index) then
        TreatUnit(pUnit, 30)
    end
    -- 河北之虎，击杀单位后恢复20点生命值。
    if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_TK_HE_BEI_ZHI_HU_YL"].Index) then
        TreatUnit(pUnit, 20)
    end

    -- 夏侯惇：击杀单位后恢复30点生命值。
    if IsUnitHaveAbility(pUnit, 'ABILITY_TK_S_HERO_SKILL_XIA_HOU_DUN_2') then
        TreatUnit(pUnit, 30)
    end

    -- 关羽：若击杀敌方单位，则恢复所有 [ICON_Movement] 移动力并能再次攻击。
    if unitInfo.UnitType == 'UNIT_HERO_TKH_GUAN_YU' then
        UnitManager.RestoreMovement(pUnit, true)
        UnitManager.RestoreUnitAttacks(pUnit, true)

        -- 限定触发次数
        -- local restoreTimes = Game:GetProperty('TKH_UNIT_HERO_TKH_GUAN_YU_RESTORE_TIMES') or 0
        -- if restoreTimes < HeroConstants.GUAN_YU_RESTORE_MAX_TIMES then
        --     UnitManager.RestoreMovement(pUnit, true)
        --     UnitManager.RestoreUnitAttacks(pUnit, true)
        --     Game:SetProperty('TKH_UNIT_HERO_TKH_GUAN_YU_RESTORE_TIMES', restoreTimes + 1)
        -- end
    elseif unitInfo.UnitType == 'UNIT_HERO_TKH_YAN_YUN_GUARD' then
        -- 给特种兵“燕云卫”+一个技能（要不然太弱了，粘贴的时候漏掉了）每击杀一个单位，回复80点生命或者护甲值。
        TreatUnit(pUnit, YAN_YUN_GUARD_KILL_HEAL)
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

function Initialize()
    -- Events.Combat.Add(OnCombat)
    Events.UnitKilledInCombat.Add(OnUnitKilledInCombat)
    Events.TurnEnd.Add(OnTurnEnd)
    Events.UnitDamageChanged.Add(OnUnitDamageChanged)

    -- 特种兵随时代调整攻击力
    HeroSummons = Game:GetProperty('HeroSummons') or {}
    Events.UnitAddedToMap.Add(OnUnitAddedToMap)
    Events.GameEraChanged.Add(OnGameEraChanged)
end

Events.LoadGameViewStateDone.Add(Initialize);
