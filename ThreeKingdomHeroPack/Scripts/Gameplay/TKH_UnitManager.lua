-- TKH_UnitManager
-- Author: PurpleSoul
-- DateCreated: 7/5/2025 11:19:46 AM
--------------------------------------------------------------

-- ===========================================================================
--	VARIABLES
-- ===========================================================================

local m_replaceUnits = {}

local m_UnitUpgradeManager = {}
local removedUnitTable = {}

local pAllPlayerIDs = {}
local time = 0
-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

function RegisterUpgradeUnit(pUnit)
    local upgradeType
    if pUnit == nil then
        return upgradeType
    end
    local unitType = GameInfo.Units[pUnit:GetType()].UnitType
    local unitUpgrades = GameInfo.UnitUpgrades[unitType]
    if unitUpgrades ~= nil then
        upgradeType = unitUpgrades.UpgradeUnit
        m_UnitUpgradeManager[pUnit:GetOwner()] = m_UnitUpgradeManager[pUnit:GetOwner()] or {}
        m_UnitUpgradeManager[pUnit:GetOwner()][pUnit:GetID()] = m_UnitUpgradeManager[pUnit:GetOwner()][pUnit:GetID()] or
            {}

        local abilities = {}
        local unitAbility = pUnit:GetAbility():GetAbilities()
        if (unitAbility ~= nil) then
            for _, ability in ipairs(unitAbility) do
                abilities[GameInfo.UnitAbilities[ability.Ability].UnitAbilityType] = ability.Count
            end
        end

        local owner = Players[pUnit:GetOwner()]
        owner:SetProperty('TKH_UPGRADE_' .. pUnit:GetID(), {
            X = pUnit:GetX(),
            Y = pUnit:GetY(),
            Properties = pUnit:GetProperties(),
            UpgradeType = upgradeType,
            Abilities = abilities,
        })
    end
end

function UpdateUpgradeUnit(pUnit, flag)
    if pUnit == nil then
        return
    end

    local owner = Players[pUnit:GetOwner()]
    local uniRecorder = owner:GetProperty('TKH_UPGRADE_' .. pUnit:GetID())
    if uniRecorder == nil then
        RegisterUpgradeUnit(pUnit)
    else
        if flag == 'Move' then
            uniRecorder.X = pUnit:GetX()
            uniRecorder.Y = pUnit:GetY()
        elseif flag == 'Properties' then
            uniRecorder.Properties = pUnit:GetProperties()
        elseif flag == 'Ability' then
            local abilities = {}
            local unitAbility = pUnit:GetAbility():GetAbilities()
            if (unitAbility ~= nil) then
                for _, ability in ipairs(unitAbility) do
                    abilities[GameInfo.UnitAbilities[ability.Ability].UnitAbilityType] = ability.Count
                end
            end
            uniRecorder.Abilities = abilities
        end

        owner:SetProperty('TKH_UPGRADE_' .. pUnit:GetID(), uniRecorder)
    end
end

-- ===========================================================================
--	Events Register
-- ===========================================================================

function OnUnitAddedToMap(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    RegisterUpgradeUnit(pUnit)
end

-- ===========================================================================
--	Events Process
-- ===========================================================================

function OnUnitRemovedFromMap(playerID, unitID)
    table.insert(removedUnitTable, { playerID, unitID })
end

function OnUnitUpgraded(playerID, unitID)
    local u_Unit = UnitManager.GetUnit(playerID, unitID)
    local u_UnitType = GameInfo.Units[u_Unit:GetType()].UnitType

    for _, rUnitInfo in ipairs(removedUnitTable) do
        local rPlayerID, rUnitID = rUnitInfo[1], rUnitInfo[2]
        local owner = Players[rPlayerID]
        if owner and owner:GetProperty('TKH_UPGRADE_' .. rUnitInfo[2]) then
            local rUnitRecorder = owner:GetProperty('TKH_UPGRADE_' .. rUnitInfo[2])
            local x, y, uType, properties, abilities = rUnitRecorder.X, rUnitRecorder.Y, rUnitRecorder.UpgradeType,
                rUnitRecorder.Properties, rUnitRecorder.Abilities

            if x == u_Unit:GetX() and y == u_Unit:GetY() then
                local uTypeMatch = false
                if u_UnitType == uType then
                    uTypeMatch = true
                else
                    if m_replaceUnits[uType] then
                        for _, rType in ipairs(m_replaceUnits[uType]) do
                            if rType == u_UnitType then
                                uTypeMatch = true
                            end
                        end
                    end
                end


                if uTypeMatch then
                    for key, value in pairs(properties) do
                        u_Unit:SetProperty(key, value)
                    end

                    local u_UnitAbility = u_Unit:GetAbility()
                    for ability, count in pairs(abilities) do
                        local u_count = u_UnitAbility:GetAbilityCount(ability)

                        if u_count and u_count > 0 then
                            if u_count < count then
                                local iChange = (u_count ~= 0) and -u_count or 0
                                u_UnitAbility:ChangeAbilityCount(ability, iChange + count)
                            end
                        else
                            u_UnitAbility:ChangeAbilityCount(ability, count)
                        end
                    end

                    if UnitManager.GetUnit(rPlayerID, rUnitID) == nil then
                        owner:SetProperty('TKH_UPGRADE_' .. rUnitInfo[2], nil)
                    end
                end
            end
        end
    end
end

function InitializeReplaceUnits()
    for row in GameInfo.UnitReplaces() do
        m_replaceUnits[row.ReplacesUnitType] = m_replaceUnits[row.ReplacesUnitType] or {}
        table.insert(m_replaceUnits[row.ReplacesUnitType], row.CivUniqueUnitType)
    end
end

function InitializeUnits()
    time = time - 1
    if time % 60 == 0 then
        -- local playerID = pAllPlayerIDs[time / 60 + 1]
        local pPlayer = Players[iPlaerID]
        if pPlayer then
            for _, pUnit in pPlayer:GetUnits():Members() do
                RegisterUpgradeUnit(pUnit)
            end
        end
    end

    if time == 0 then
        Events.GameCoreEventPublishComplete.Remove(InitializeUnits)
    end
end

function Initialize()
    InitializeReplaceUnits()
    Events.UnitAddedToMap.Add(OnUnitAddedToMap)
    Events.UnitPropertyChanged.Add(function(playerID, unitID)
        UpdateUpgradeUnit(UnitManager.GetUnit(playerID, unitID), 'Properties')
    end)
    Events.UnitMoveComplete.Add(function(playerID, unitID)
        UpdateUpgradeUnit(UnitManager.GetUnit(playerID, unitID), 'Move')
    end)
    Events.UnitAbilityGained.Add(function(playerID, unitID)
        UpdateUpgradeUnit(UnitManager.GetUnit(playerID, unitID), 'Ability')
    end)
    Events.UnitAbilityLost.Add(function(playerID, unitID)
        UpdateUpgradeUnit(UnitManager.GetUnit(playerID, unitID), 'Ability')
    end)

    Events.UnitRemovedFromMap.Add(OnUnitRemovedFromMap)
    Events.UnitUpgraded.Add(OnUnitUpgraded)
    Events.TurnBegin.Add(function()
        removedUnitTable = {}
        pAllPlayerIDs = PlayerManager.GetAliveIDs()
        time = table.count(pAllPlayerIDs) * 60
        Events.GameCoreEventPublishComplete.Add(InitializeUnits)
    end)
end

-- Initialize()
Events.LoadGameViewStateDone.Add(Initialize)
