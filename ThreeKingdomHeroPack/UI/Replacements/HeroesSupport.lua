--
--	Project: Star Wars Heroes Support Corrections
--
--	DRN
--

include("UnitSupport");

-- ===========================================================================
--	Stats
-- ===========================================================================
function GetHeroUnitStats(eHeroClass)

	-- print('GetHeroUnitStats = ', GetHeroUnitStats)

	if eHeroClass == -1 then
		return {};
	end

	local pHeroInfo = GameInfo.HeroClasses[eHeroClass];
	if (pHeroInfo == nil) then
		return {};
	end

	local pUnitInfo = GameInfo.Units[pHeroInfo.UnitType];
	if (pUnitInfo == nil) then
		UI.DataError("HeroesSupport could not find UnitType info for HeroClass: '" .. tostring(eHeroClass));
		return {};
	end

	local eCurrentEra = Support_GetCurrentEra();
	local pEraInfo = GameInfo.Eras[eCurrentEra];
	if (pEraInfo == nil) then
		UI.DataError("HeroesSupport could not find current Era info: '" .. tostring(eCurrentEra));
		return {};
	end

	-- Base stats
	local tStats = {};
	tStats.Combat = pUnitInfo.Combat;
	tStats.RangedCombat = pUnitInfo.RangedCombat;
	tStats.Range = pUnitInfo.Range;
	tStats.BaseMoves = pUnitInfo.BaseMoves;
	tStats.Lifespan = UnitManager.GetUnitTypeBaseLifespan(pUnitInfo.Index);

	-- Progressive stats: select these by era
	local tProgressionResults = DB.Query("SELECT * FROM HeroClassProgressions WHERE HeroClassType = '" ..
		pHeroInfo.HeroClassType .. "' and EraType = '" .. pEraInfo.EraType .. "' LIMIT 1");
	if (tProgressionResults ~= nil and #tProgressionResults > 0) then
		tStats.Combat = tProgressionResults[1].CombatStrength;
		tStats.RangedCombat = tProgressionResults[1].RangedCombatStrength;
	end

	local pGameHeroes = Game.GetHeroesManager();
	if pGameHeroes then
		tStats.Charges = pGameHeroes:GetHeroClassBaseCharges(eHeroClass);
	end

	return tStats;
end

-- ===========================================================================
--	Abilities and Commands
-- ===========================================================================
function FormatHeroClassAbilitiesAndCommands(eHeroClass)
	local pAbilities = GetHeroClassUnitAbilities(eHeroClass);
	local pCommands = GetHeroClassUnitCommands(eHeroClass);

	if (#pAbilities == 0 and #pCommands == 0) then
		return "";
	end

	local sResultString = "";

	for i, row in ipairs(pAbilities) do
		local sRowString = Locale.Lookup(row.Name) .. ": " .. Locale.Lookup(row.Description);
		if (sResultString ~= "") then
			sRowString = "[NEWLINE]" .. sRowString
		end;
		sResultString = sResultString .. sRowString;
	end

	for i, row in ipairs(pCommands) do
		local sRowString = Locale.Lookup(row.Name) .. ": " .. Locale.Lookup(row.Description);
		if (sResultString ~= "") then
			sRowString = "[NEWLINE]" .. sRowString
		end;
		sResultString = sResultString .. sRowString;
	end

	return sResultString;
end

-- ===========================================================================
function GetHeroClassUnitAbilities(eHeroClass)
	if eHeroClass == -1 then
		return {};
	end
	local pHeroInfo = GameInfo.HeroClasses[eHeroClass];
	if (pHeroInfo == nil) then
		return {};
	end

	local pHeroClassAbilities = GameInfo.HeroClassAbilities[pHeroInfo.HeroClassType];
	if (pHeroClassAbilities == nil or pHeroClassAbilities.UnitAbilityTypes == nil) then
		return {};
	end
	local pResultAbilities = {};
	local abilityTypes = string.gmatch(pHeroClassAbilities.UnitAbilityTypes, '([^,]+)')
	if (abilityTypes ~= nil) then
		for abilityType in abilityTypes do
			local pAbility = GameInfo.UnitAbilities[abilityType];
			if (pAbility ~= nil) then
				local pAbilityData = {};
				pAbilityData.Icon = ""; -- TODO
				pAbilityData.Name = pAbility.Name;

				local sDesc = GetUnitAbilityDescription(pAbility.Index);
				if (sDesc ~= nil and sDesc ~= "") then
					pAbilityData.Description = sDesc;
				end

				table.insert(pResultAbilities, pAbilityData);
			end
		end
	end

	return pResultAbilities;
end

-- ===========================================================================
function GetHeroClassUnitCommands(eHeroClass)
	if eHeroClass == -1 then
		return {};
	end
	local pHeroInfo = GameInfo.HeroClasses[eHeroClass];
	if (pHeroInfo == nil) then
		return {};
	end

	local pResultCommands = {};
	for row in GameInfo.HeroClassUnitCommands() do
		if (row.HeroClassType == pHeroInfo.HeroClassType) then
			local pUnitCommand = GameInfo.UnitCommands[row.CommandType];
			if (pUnitCommand ~= nil) then
				local pCommandData = {};
				pCommandData.Icon = pUnitCommand.Icon;
				pCommandData.Name = pUnitCommand.Description;
				pCommandData.Description = UnitManager.GetCommandHelpText(pUnitCommand.Hash, Game.GetLocalPlayer());
				table.insert(pResultCommands, pCommandData);
			end
		end
	end

	return pResultCommands;
end

-- ===========================================================================
--	Helpers
-- ===========================================================================
function Support_GetCurrentEra()
	-- Era system changed between BASE and XP1
	-- XP1+...
	if (Game.GetEras ~= nil) then
		return Game.GetEras():GetCurrentEra();
	end

	-- BASE
	local pPlayer = Players[Game.GetLocalPlayer()];
	if (pPlayer ~= nil) then
		return pPlayer:GetEra();
	end

	-- FAILSAFE
	return EraTypes.ERA_ANCIENT;
end
