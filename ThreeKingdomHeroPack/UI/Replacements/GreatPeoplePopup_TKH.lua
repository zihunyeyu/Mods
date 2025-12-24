-- -- include('GreatPeoplePopup')
-- -- include('GreatPeoplePopup_Expansion1')
-- -- include('GreatPeoplePopup_Expansion2')
-- -- include('GreatPeoplePopup_Babylon_Heroes')
include('TKH_Helper')


TKH_PopulateData = PopulateData


-- =======================================================================================
--	Populate a data table with timeline information.
--		data	An allocated table to receive the timeline.
--		isPast	If the data should be from the past (instead of the current)
-- =======================================================================================
function PopulateData(data, isPast)
	if data == nil then
		error("GreatPeoplePopup received an empty data in to PopulateData");
		return;
	end

	local displayPlayerID = GetDisplayPlayerID();
	if (displayPlayerID == -1) then
		return;
	end

	local pGreatPeople = Game.GetGreatPeople();
	if pGreatPeople == nil then
		UI.DataError("GreatPeoplePopup received NIL great people object.");
		return;
	end

	local pTimeline = nil;
	if isPast then
		pTimeline = pGreatPeople:GetPastTimeline();
	else
		pTimeline = pGreatPeople:GetTimeline();
	end


	for i, entry in ipairs(pTimeline) do
		-- don't add unclaimed great people to the previously recruited tab
		if not isPast or entry.Claimant then
			local claimantName = nil;
			if (entry.Claimant ~= nil) then
				claimantName = Locale.Lookup(PlayerConfigurations[entry.Claimant]:GetCivilizationShortDescription());
			end

			local canRecruit             = false;
			local canReject              = false;
			local canPatronizeWithFaith  = false;
			local canPatronizeWithGold   = false;
			local actionCharges          = 0;
			local patronizeWithGoldCost  = nil;
			local patronizeWithFaithCost = nil;
			local recruitCost            = entry.Cost;
			local rejectCost             = nil;
			local earnConditions         = nil;
			if (entry.Individual ~= nil) then
				if (Players[displayPlayerID] ~= nil) then
					canRecruit = pGreatPeople:CanRecruitPerson(displayPlayerID, entry.Individual);
					if (not isPast) then
						canReject = pGreatPeople:CanRejectPerson(displayPlayerID, entry.Individual);
						if (canReject) then
							rejectCost = pGreatPeople:GetRejectCost(displayPlayerID, entry.Individual);
						end
					end
					canPatronizeWithGold = pGreatPeople:CanPatronizePerson(displayPlayerID, entry.Individual,
						YieldTypes.GOLD);
					patronizeWithGoldCost = pGreatPeople:GetPatronizeCost(displayPlayerID, entry.Individual,
						YieldTypes.GOLD);
					canPatronizeWithFaith = pGreatPeople:CanPatronizePerson(displayPlayerID, entry.Individual,
						YieldTypes.FAITH);
					patronizeWithFaithCost = pGreatPeople:GetPatronizeCost(displayPlayerID, entry.Individual,
						YieldTypes.FAITH);
					earnConditions = pGreatPeople:GetEarnConditionsText(displayPlayerID, entry.Individual);
				end
				local individualInfo = GameInfo.GreatPersonIndividuals[entry.Individual];
				actionCharges = individualInfo.ActionCharges;
			end

			local personName = "";
			if GameInfo.GreatPersonIndividuals[entry.Individual] ~= nil then
				personName = Locale.Lookup(GameInfo.GreatPersonIndividuals[entry.Individual].Name);
			end

			local kPerson = {
				IndividualID           = entry.Individual,
				ClassID                = entry.Class,
				EraID                  = entry.Era,
				ClaimantID             = entry.Claimant,
				ActionCharges          = actionCharges,
				ActionNameText         = entry.ActionNameText,
				ActionUsageText        = entry.ActionUsageText,
				ActionEffectText       = entry.ActionEffectText,
				BiographyTextTable     = GetBiographyTextTable(entry.Individual),
				CanPatronizeWithFaith  = canPatronizeWithFaith,
				CanPatronizeWithGold   = canPatronizeWithGold,
				CanReject              = canReject,
				ClaimantName           = claimantName,
				CanRecruit             = canRecruit,
				EarnConditions         = earnConditions,
				Name                   = personName,
				PassiveNameText        = entry.PassiveNameText,
				PassiveEffectText      = entry.PassiveEffectText,
				PatronizeWithFaithCost = patronizeWithFaithCost,
				PatronizeWithGoldCost  = patronizeWithGoldCost,
				RecruitCost            = recruitCost,
				RejectCost             = rejectCost,
				TurnGranted            = entry.TurnGranted
			};

			-- print(personName, entry.Class, entry.Era)
			-- =======================MODIFIER======================

			local personInfo = GameInfo.GreatPersonIndividuals[entry.Individual]
			if personInfo ~= nil then
				local gpType = personInfo.GreatPersonIndividualType
				local commandSQL = DB.Query(
					"SELECT CommandType, ActionCharges from UnitTypeUnitCommands_TKH where UnitType = ?", gpType)

				if commandSQL and #commandSQL > 0 then
					local command = commandSQL[1].CommandType
					kPerson.ActionCharges = commandSQL[1].ActionCharges
					kPerson.ActionNameText = Locale.Lookup('LOC_GREATPERSON_ACTION_NAME_DEFAULT')

					if command == 'UNITCOMMAND_CREATE_RESOURCE' then
						kPerson.ActionNameText = Locale.Lookup('LOC_UNITCOMMAND_CREATE_RESOURCE_DESCRIPTION')
					end

					kPerson.ActionEffectText = GetCommandString(gpType, command)
				end
			end
			-- =======================MODIFIER======================

			table.insert(data.Timeline, kPerson);
		end
	end


	for classInfo in GameInfo.GreatPersonClasses() do
		local classID = classInfo.Index;
		local pointsTable = {};
		local players = Game.GetPlayers { Major = true, Alive = true };
		for i, player in ipairs(players) do
			local playerName = "";
			local isPlayer = false;
			if (player:GetID() == displayPlayerID) then
				playerName = playerName ..
					Locale.Lookup(PlayerConfigurations[player:GetID()]:GetCivilizationShortDescription());
				isPlayer = true;
			elseif (Game.GetLocalObserver() == PlayerTypes.OBSERVER or Players[displayPlayerID]:GetDiplomacy():HasMet(player:GetID())) then
				playerName = playerName ..
					Locale.Lookup(PlayerConfigurations[player:GetID()]:GetCivilizationShortDescription());
			else
				playerName = playerName .. Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER");
			end
			local playerPoints = {
				IsPlayer           = isPlayer,
				MaxPlayerInstances = classInfo.MaxPlayerInstances,
				NumInstancesEarned = pGreatPeople:CountPeopleReceivedByPlayer(classID, player:GetID()),
				PlayerName         = playerName,
				PointsTotal        = player:GetGreatPeoplePoints():GetPointsTotal(classID),
				PointsPerTurn      = player:GetGreatPeoplePoints():GetPointsPerTurn(classID),
				PlayerID           = player:GetID()
			};
			table.insert(pointsTable, playerPoints);
		end
		table.sort(pointsTable, function(a, b)
			if (a.IsPlayer and not b.IsPlayer) then
				return true;
			elseif (not a.IsPlayer and b.IsPlayer) then
				return false;
			end
			return a.PointsTotal > b.PointsTotal;
		end);
		data.PointsByClass[classID] = pointsTable;
	end
end
