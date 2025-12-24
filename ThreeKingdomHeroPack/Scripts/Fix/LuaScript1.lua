-- LuaScript1
-- Author: hnoyy
-- DateCreated: 11/8/2023 9:21:53 PM
--------------------------------------------------------------

function NEA_Capture_Unit_Mao(currentUnitOwner, unit, owningPlayer, capturingPlayer)
	local pPlayer = Players[capturingPlayer];

	if pPlayer:GetProperty('PROPERTY_NEA_PERSON_MAO_ZEDONG') == 1 then
	end
end

function NeaQingtian(IPplayerID, IPcityID, IPprojectID, IPbuildingIndex, IPiX, IPiY, IPbCancelled)
	if (IPprojectID == GameInfo.Projects['PROJECT_NEA_QINGTIAN'].Index) then
		local pcity = CityManager.GetCity(IPplayerID, IPcityID);
		local pPlayer = Players[IPplayerID];
		pcity:ChangePopulation(-1);
		local QingtianNum = math.random(1, 6);

		local pcityPop = pcity:GetPopulation();

		if QingtianNum == 1 then
			pPlayer:GetTreasury():ChangeGoldBalance(-500);
			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end

		if QingtianNum == 2 then
			pcity:AttachModifierByID('MODIF_NEA_HAN_FUJU_QINGTIAN_AMENITY');
			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end

		if QingtianNum == 3 then
			local pcityiX = pcity:GetX();
			local pcityiY = pcity:GetY();




			pPlayer:GetTreasury():ChangeGoldBalance(pcityPop * 100);
			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end

		if QingtianNum == 4 then
			local pcityiX = pcity:GetX();
			local pcityiY = pcity:GetY();
			UnitManager.InitUnitValidAdjacentHex(IPplayerID, "UNIT_NEA_ZHUANGDING", pcityiX, pcityiY, 2);

			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end

		if QingtianNum == 5 then
			local pcityiX = pcity:GetX();
			local pcityiY = pcity:GetY();

			pcity:AttachModifierByID('MODIF_NEA_HAN_FUJU_QINGTIAN_CULTURE_YIELD');
			pcity:AttachModifierByID('MODIF_NEA_HAN_FUJU_QINGTIAN_SCIENCE_YIELD');


			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end


		if QingtianNum == 6 then
			local pcityiX = pcity:GetX();
			local pcityiY = pcity:GetY();


			pPlayer:GetCulture():ChangeCurrentCulturalProgress(pcityPop * 50);
			pPlayer:GetTechs():ChangeCurrentResearchProgress(pcityPop * 50);

			Network.BroadcastPlayerInfo();
			Network.BroadcastGameConfig();
		end
	end
end

Events.CityProjectCompleted.Add(NeaQingtian);




function NeaZidibing(IPplayerID, IPcityID, IPiConstructionType, IPunitID, IPbCancelled)
	local pPlayer = Players[IPplayerID];
	pPlayer:AttachModifierByID('MODIF_NEA_UNIT_ZIDIBING_PROPERTY');
end

function NeaZidibing2(IPplayerID, IPunitID)
	local pPlayer = Players[IPplayerID];
	local pUnit = UnitManager.GetUnit(IPplayerID, IPunitID);

	local Minxin = pPlayer:GetProperty('PROPERTY_NEA_PLAYER_ZIDIBING');
	local pCurrentTurn = Game.GetCurrentGameTurn();

	if Minxin ~= nil then
		if Minxin < 0 then
			pPlayer:GetTreasury():ChangeGoldBalance(0.5 * Minxin * pCurrentTurn);
			pPlayer:GetReligion():ChangeFaithBalance(0.5 * Minxin * pCurrentTurn)
			pUnit:ChangeDamage(-5 * Minxin);
		else
			pPlayer:GetCulture():ChangeCurrentCulturalProgress(0.2 * Minxin * pCurrentTurn);
			pPlayer:GetTechs():ChangeCurrentResearchProgress(0.2 * Minxin * pCurrentTurn);
		end
	end
end

function NeaZidibing3(IPplayerID, IPdistrictID, IPcityID, IPiX, IPiY, IPdistrictType, IPpercentComplete)
	local pPlayer = Players[IPplayerID];

	local pCity = CityManager.GetCity(IPplayerID, IPcityID);

	local pHappy = pCity:GetGrowth():GetHappiness();
	local Minxin = pPlayer:GetProperty('PROPERTY_NEA_PLAYER_ZIDIBING')
	if Minxin ~= nil then
		if pHappy >= 4 and Minxin < 10 then
			pPlayer:SetProperty("PROPERTY_NEA_PLAYER_ZIDIBING", Minxin + 1);
		elseif pHappy < 4 and Minxin > -10 then
			pPlayer:SetProperty("PROPERTY_NEA_PLAYER_ZIDIBING", Minxin - 1);
		end
	end
	Network.BroadcastPlayerInfo();
	Network.BroadcastGameConfig();
end

Events.UnitAddedToMap.Add(NeaZidibing2);
Events.DistrictAddedToMap.Add(NeaZidibing3);
