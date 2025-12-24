-- TKH_HeroManager
-- Author: PurpleSoul
-- DateCreated: 3/7/2025 11:13:33 PM
--------------------------------------------------------------
include('TKH_Helper')

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local m_HeroManager = {}

-- ===========================================================================
--	HERO
-- ===========================================================================
HeroUnit = {}
HeroUnit.__index = HeroUnit

function HeroUnit.new(self, pUnit, heroClassIndex)
    local o = {}
    setmetatable(o, HeroUnit)
    if m_HeroManager[heroClassIndex] ~= nil then
        local oUnit = UnitManager.GetUnit(m_HeroManager[heroClassIndex].Owner, m_HeroManager[heroClassIndex].ID)
        if not oUnit then
            o:ReInitialize(pUnit, m_HeroManager[heroClassIndex])
        else
            o = m_HeroManager[heroClassIndex]
        end
    else
        o:Initialize(pUnit, heroClassIndex)
    end

    m_HeroManager[heroClassIndex] = o
end

function HeroUnit.Initialize(self, pUnit)
    self.Owner = pUnit:GetOwner()
    self.ID = pUnit:GetID()
    self.Index = pUnit:GetType()
    self.HeroClassIndex = pUnit:GetHeroClassType()
    local unitInfo = GameInfo.Units[pUnit:GetType()]
    self.UnitType = unitInfo.UnitType
    self.Exp = pUnit:GetExperience():GetExperiencePoints()
end

function HeroUnit.ReInitialize(self, pUnit, oInfo)
    self.Owner = pUnit:GetOwner()
    self.ID = pUnit:GetID()
    self.Index = pUnit:GetType()
    self.HeroClassIndex = pUnit:GetHeroClassType()
    local unitInfo = GameInfo.Units[pUnit:GetType()]
    self.UnitType = unitInfo.UnitType

    pUnit:GetExperience():ChangeExperience(oInfo.Exp)
    self.Exp = pUnit:GetExperience():GetExperiencePoints()
end


-- ===========================================================================
--	HERO Record Exp
-- ===========================================================================
function RecordExp(pUnit)
    local heroClassIndex = pUnit:GetHeroClassType()
    if heroClassIndex == -1 then
        return
    end
    if not m_HeroManager[heroClassIndex] then
        HeroUnit:new(pUnit, heroClassIndex)
    else
        m_HeroManager[heroClassIndex].Exp = pUnit:GetExperience():GetExperiencePoints()
    end
    Game:SetProperty('HeroManager', m_HeroManager)
end

-- ===========================================================================
--	HERO Events
-- ===========================================================================
-- 创建英雄
function OnUnitCreated(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    local heroClassIndex = pUnit:GetHeroClassType()
    local unitInfo = GameInfo.Units[pUnit:GetType()]

    if heroClassIndex == -1 or not IsTkh(unitInfo.UnitType) then
        return
    end

    HeroUnit:new(pUnit, heroClassIndex)
    Game:SetProperty('HeroManager', m_HeroManager)
end

function OnCombat(pCombatResult)
    local combatResult = GetCombatResult(pCombatResult)
    local vsType, attacker, defender, location = combatResult.CombatComponentTypes, combatResult.Attacker,
        combatResult.Dfender, combatResult.Location
    if vsType == CombatVSComponentTypes.UNIT_UNIT then
        local aPlayerID, aUnitID = attacker[2].player, attacker[2].id
        local aUnit = UnitManager.GetUnit(aPlayerID, aUnitID)
        local dPlayerID, dUnitID = defender[2].player, defender[2].id
        local dUnit = UnitManager.GetUnit(dPlayerID, dUnitID)
        RecordExp(aUnit)
        RecordExp(dUnit)
    end
    if vsType == CombatVSComponentTypes.DISTRICT_UNIT or vsType == CombatVSComponentTypes.CITY_UNIT then
        local dPlayerID, dUnitID = defender[2].player, defender[2].id
        local dUnit = UnitManager.GetUnit(dPlayerID, dUnitID)
        RecordExp(dUnit)
    end
    if vsType == CombatVSComponentTypes.UNIT_DISTRICT or vsType == CombatVSComponentTypes.UNIT_CITY then
        local aPlayerID, aUnitID = attacker[2].player, attacker[2].id
        local aUnit = UnitManager.GetUnit(aPlayerID, aUnitID)
        RecordExp(aUnit)
    end

    Game:SetProperty('HeroManager', m_HeroManager)
end

-- ===========================================================================
--	Data
-- ===========================================================================

function Initialize()
    m_HeroManager = Game:GetProperty('HeroManager') or {}
    Events.UnitAddedToMap.Add(OnUnitCreated)
end

Events.LoadGameViewStateDone.Add(Initialize)
