function PhantaPhantaGuanYuKillUnits(killedPlayerID, killedUnitID, playerID, unitID)

	local pPlayer = Players[playerID]
	local pPlayerUnits = pPlayer:GetUnits()
	local pUnit = pPlayerUnits:FindID(unitID)
	local iPhantaGuanYu = GameInfo.Units["UNIT_HERO_PHANTA_GUAN_YU"].Index;

	if pUnit:GetType() == iPhantaGuanYu then
		UnitManager.RestoreMovement(pUnit, true);
		UnitManager.RestoreUnitAttacks(pUnit, true);
	end
end

-- Events.UnitKilledInCombat.Add(PhantaPhantaGuanYuKillUnits)