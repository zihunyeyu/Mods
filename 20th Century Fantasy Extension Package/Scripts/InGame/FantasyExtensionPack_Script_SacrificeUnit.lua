-- ===========================================================================
-- INCLUDE
-- ===========================================================================

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

-- ===========================================================================
-- VARIABLES
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================
-- 牺牲：玉碎
function UnitGyokusai(pUnit)
    if pUnit ~= nil then
        local SacrificeText = Locale.Lookup("LOC_KAMIKAZE_SACRIFICE")
        local pUnitX = pUnit:GetX()
        local pUnitY = pUnit:GetY()
        local tNeighborPlots = Map.GetAdjacentPlots(pUnitX, pUnitY);
        for _, pNeighborPlot in ipairs(tNeighborPlots) do
            for _, pNeighborUnit in ipairs(Units.GetUnitsInPlot(pNeighborPlot)) do
                if (pNeighborUnit ~= nil) then
                    local uOwner = pNeighborUnit:GetOwner()
                    if Players[pUnit:GetOwner()]:GetDiplomacy():IsAtWarWith(pNeighborUnit:GetOwner()) then
                        pNeighborUnit:ChangeDamage(pNeighborUnit:GetMaxDamage() - pNeighborUnit:GetDamage())
                        UnitManager.Kill(pNeighborUnit)
                    end
                end
            end
        end

        pUnit:ChangeDamage(pUnit:GetMaxDamage() - pUnit:GetDamage())
        Game.AddWorldViewText(0, SacrificeText, pUnitX, pUnitY)
        UnitManager.Kill(pUnit)

    end
end

-- 牺牲单位
function SacrificeUnit(pPlayerID, params)
    local pUnit = UnitManager.GetUnit(pPlayerID, params.tUnitID)
    if pUnit == nil then
        return
    end
    local sFlag = params.Flag
    if sFlag == "Gyokusai" then
        UnitGyokusai(pUnit)
    end
end

function Initialize()
    GameEvents.SacrificeUnit.Add(SacrificeUnit)
end

Events.LoadGameViewStateDone.Add(Initialize);
