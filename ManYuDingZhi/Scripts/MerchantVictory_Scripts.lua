-- MerchantVictory_Scripts
-- Author: Konomi
-- DateCreated: 11/17/2023 21:32:17
--------------------------------------------------------------
local PROJECT_PLAYER_FINISH_TURNS = 'PROJECT_PLAYER_FINISH_TURNS'
local PROJECT_PLAYER_CAPITAL_PLOT_INDEX = 'PROJECT_PLAYER_CAPITAL_PLOT_INDEX'
--local PROJECT_PLAYER_LAST_FREE_TURN = 'PROJECT_PLAYER_LAST_FREE_TURN'
--local PROJECT_PLOT_DEBUFF_TAG = 'PROJECT_PLOT_DEBUFF_TAG'
local GAME_SPEED = GameConfiguration.GetGameSpeedType()
local GAME_SPEED_MULTIPLIER = GameInfo.GameSpeeds[GAME_SPEED] and GameInfo.GameSpeeds[GAME_SPEED].CostMultiplier / 100 or 1
local COOLDOWN_GOLD_PER_TURN = 30
local COOLDOWN_FREE_CITY = math.floor(10 * GAME_SPEED_MULTIPLIER)
local FINAL_WAIT_TURN = 5

local m_ProjectMerchant1Index = GameInfo.Projects['PROJECT_MYN_MERCHANT_1'] and GameInfo.Projects['PROJECT_MYN_MERCHANT_1'].Index or -1
local m_ProjectMerchant2Index = GameInfo.Projects['PROJECT_MYN_MERCHANT_2'] and GameInfo.Projects['PROJECT_MYN_MERCHANT_2'].Index or -1
local m_ProjectMerchant3Index = GameInfo.Projects['PROJECT_MYN_MERCHANT_3'] and GameInfo.Projects['PROJECT_MYN_MERCHANT_3'].Index or -1
local m_ProjectMerchant4Index = GameInfo.Projects['PROJECT_MYN_MERCHANT_4'] and GameInfo.Projects['PROJECT_MYN_MERCHANT_4'].Index or -1

local m_BuildingPalaceInfo = GameInfo.Buildings['BUILDING_PALACE']
local m_BuildingMerchantIndex = GameInfo.Buildings['BUILDING_MYN_MERCHANT'] and GameInfo.Buildings['BUILDING_MYN_MERCHANT'].Index or -1

local m_BuildingDummyDislikeIndex = GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_DISLIKE'] and GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_DISLIKE'].Index or -1
local m_BuildingDummyTradeRouteIndex = GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_TRADEROUTE'] and GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_TRADEROUTE'].Index or -1
local m_BuildingDummyUnlockProjectIndex = GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_UNLOCK_PROJECT'] and GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_UNLOCK_PROJECT'].Index or -1
local m_BuildingDummyVictoryIndex = GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_VICTORY'] and GameInfo.Buildings['BUILDING_MYN_MERCHANT_DUMMY_VICTORY'].Index or -1

local m_DistrictGovInfo = GameInfo.Districts['DISTRICT_GOVERNMENT']
local m_DistrictDiplomaticInfo = GameInfo.Districts['DISTRICT_DIPLOMATIC_QUARTER']
-- ===========================================================================
function OnBuildingConstructed(playerID, cityID, buildingID, plotID, bOriginalConstruction)
	if buildingID == m_BuildingMerchantIndex then
		local city = CityManager.GetCity(playerID, cityID)
		if city then
			-- 处于四级政体禁止商业胜利项目
			if ExposedMembers.MYN and ExposedMembers.MYN.GetCurrentGovernment then
				local governmentInfo = GameInfo.Governments[ExposedMembers.MYN.GetCurrentGovernment(playerID)]
				if governmentInfo == nil or governmentInfo.Tier ~= 'Tier4' then
					city:GetBuildQueue():CreateBuilding(m_BuildingDummyUnlockProjectIndex)
				end
			end
		end
	end
end
-- ===========================================================================
function OnCityProjectCompleted(playerID, cityID, projectID, buildingIndex, iX, iY, bCancelled)
	if m_ProjectMerchant1Index == projectID or m_ProjectMerchant2Index == projectID or m_ProjectMerchant3Index == projectID or m_ProjectMerchant4Index == projectID then
		local pPlayer = Players[playerID]
		local pCity = pPlayer:GetCities():GetCapitalCity()
		if pCity then
			local property = pPlayer:GetProperty(PROJECT_PLAYER_FINISH_TURNS)
			if property == nil then
				property = {}
			end
			if m_ProjectMerchant1Index == projectID then
				property[1] = Game.GetCurrentGameTurn() + COOLDOWN_GOLD_PER_TURN
				pCity:GetBuildQueue():CreateBuilding(m_BuildingDummyDislikeIndex)
			elseif m_ProjectMerchant2Index == projectID then
				property[2] = Game.GetCurrentGameTurn() + COOLDOWN_GOLD_PER_TURN
				for _, id in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if id ~= playerID and Players[id]:GetTrade():CountOutgoingRoutes() < 10 then
						local playerCities = Players[id]:GetCities()
						if playerCities and playerCities:GetCapitalCity() then
							playerCities:GetCapitalCity():GetBuildQueue():CreateBuilding(m_BuildingDummyTradeRouteIndex)
						end
					end
				end	
			elseif m_ProjectMerchant3Index == projectID then
				property[3] = Game.GetCurrentGameTurn() + COOLDOWN_GOLD_PER_TURN
				if ExposedMembers.MYN and ExposedMembers.MYN.GetMilitaryStrengthWithoutTreasury and ExposedMembers.MYN.GetMilitaryStrengthWithoutTreasury(playerID) < 2000 then
					 for _, city in pPlayer:GetCities():Members() do
						 if city then
							 CityManager.TransferCityToFreeCities(city)
						 end
					 end		
				end
				local pool = {}
				for _, id in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if Players[id]:GetTeam() ~= Players[playerID]:GetTeam() and not Players[id]:GetDiplomacy():IsAtWarWith(playerID) then
						table.insert(pool, id)
					end
				end
				local rand = Game.GetRandNum(#pool, 'Merchant: Pick a player') + 1
				Players[pool[rand]]:GetDiplomacy():DeclareWarOn(playerID, WarTypes.FORMAL_WAR, true)
			elseif m_ProjectMerchant4Index == projectID then
				property[4] = Game.GetCurrentGameTurn() + COOLDOWN_GOLD_PER_TURN
				for _, id in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if Players[id]:GetTeam() ~= Players[playerID]:GetTeam() and not Players[id]:GetDiplomacy():IsAtWarWith(playerID) then
						Players[id]:GetDiplomacy():DeclareWarOn(playerID, WarTypes.FORMAL_WAR, true)
					end
				end
				pPlayer:SetProperty('MERCHANT_VIC_FINAL_TURN', Game.GetCurrentGameTurn())
			end
			pPlayer:SetProperty(PROJECT_PLAYER_FINISH_TURNS, property)

			local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
			pPlayer:SetProperty(PROJECT_PLAYER_CAPITAL_PLOT_INDEX, pPlot:GetIndex())
		end
	end
end
-- ===========================================================================
function OnTurnBegin(iTurn:number)
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pPlayer = Players[playerID]
		local pCity = pPlayer:GetCities():GetCapitalCity()
		local property = pPlayer:GetProperty(PROJECT_PLAYER_FINISH_TURNS)
		local pPlayerCities = pPlayer:GetCities()

		local playerTreasury:table	= pPlayer:GetTreasury()
		local goldYield		:number = playerTreasury:GetGoldYield() - playerTreasury:GetTotalMaintenance()
		local goldBalance	:number = math.floor(playerTreasury:GetGoldBalance());

		local pPlot
		if pCity then
			pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
		end
		if pCity and property and pPlot then
			for i, turn in ipairs(property) do
				if iTurn <= turn then
					pPlot:SetProperty('PROJECT_PLOT_DEBUFF_TAG_' .. i, 1)
				else
					pPlot:SetProperty('PROJECT_PLOT_DEBUFF_TAG_' .. i, 0)
					if i == 2 then
						pCity:GetBuildings():RemoveBuilding(m_BuildingDummyTradeRouteIndex)
					end
				end 
			end
		end

		if pPlayer:GetProperty('MYN_MERCHANT_1_SOMEONE_COMPLETED') ~= nil and pPlayer:GetProperty('MYN_MERCHANT_1_SOMEONE_COMPLETED') > 0 and pPlayerCities then
			for _, city in pPlayerCities:Members() do
				if city then
					local plot = Map.GetPlot(city:GetX(), city:GetY())
					if goldYield < 500 then
						plot:SetProperty('PROJECT_PLOT_DEBUFF_TAG_1_OTHERS', 1)
					else
						plot:SetProperty('PROJECT_PLOT_DEBUFF_TAG_1_OTHERS', 0)
					end
				end
			end				
		end

		if pPlayer:GetProperty('MERCHANT_VIC_FINAL_TURN') ~= nil then
			local prop = pPlayer:GetProperty('MERCHANT_VIC_FINAL_TURN')
			local prop2 = Game.GetProperty('MYN_MERCHANT_BUILDING_2_COUNT')
			if prop2 == nil then
				prop2 = 0
			end
			if pPlayer:GetProperty('MYN_MERCHANT_BUILDING_1') ~= 1 then  -- 美联储受损，则第5阶段进度停止
				pPlayer:SetProperty('MERCHANT_VIC_FINAL_TURN', prop + 1)
			else
				if Game.GetCurrentGameTurn() >= prop + prop2 + FINAL_WAIT_TURN and pPlayer:GetProperty('MYN_MERCHANT_VICTORY_WINNED') == nil then
					pCity:GetBuildQueue():CreateBuilding(m_BuildingDummyVictoryIndex)
				end
			end
		end
		
		if goldBalance == 0 and goldYield < 0 and pPlayerCities then 
			--local property = pPlayer:GetProperty(PROJECT_PLAYER_LAST_FREE_TURN)
			--if property == nil or property + COOLDOWN_FREE_CITY <= iTurn then
			--local maxId, maxCity = -1, nil
			for _, city in pPlayerCities:Members() do
				local flag = false
				if m_BuildingPalaceInfo and city:GetBuildings():HasBuilding(m_BuildingPalaceInfo.Index) then
					flag = true
				elseif m_DistrictGovInfo and city:GetDistricts():HasDistrict(m_DistrictGovInfo.Index, true, true) then
					flag = true
				elseif m_DistrictDiplomaticInfo and city:GetDistricts():HasDistrict(m_DistrictDiplomaticInfo.Index, true, true) then
					flag = true
				end
				if not flag then
					CityManager.TransferCityToFreeCities(city)
				end
			end
				--if maxCity then
					--CityManager.TransferCityToFreeCities(maxCity)
					--pPlayer:SetProperty(PROJECT_PLAYER_LAST_FREE_TURN, iTurn)
				--end
			--end
		end
	end
end
-- ===========================================================================
function OnCapitalCityChanged(playerID:number, cityID:number)
	local pCity = CityManager.GetCity(playerID, cityID)
	if pCity then
		local pPlayer = Players[playerID]
		local plotIndex = pPlayer:GetProperty(PROJECT_PLAYER_CAPITAL_PLOT_INDEX)
		local pPlot = Map.GetPlotByIndex(plotIndex)
		local pPlot2 = Map.GetPlot(pCity:GetX(), pCity:GetY())
		if pPlot and pPlot2 then
			for i=1, 4 do
				local property = pPlot:GetProperty('PROJECT_PLOT_DEBUFF_TAG_' .. i)
				pPlot:SetProperty('PROJECT_PLOT_DEBUFF_TAG_' .. i, nil)
				pPlot2:SetProperty('PROJECT_PLOT_DEBUFF_TAG_' .. i, property)
			end			
			pPlayer:SetProperty(PROJECT_PLAYER_CAPITAL_PLOT_INDEX, pPlot2:GetIndex())
		end
	end
end
-- ===========================================================================
-- 处于四级政体禁止商业胜利项目
function OnGovernmentChanged(playerID:number, governmentID:number)
	print('OnGovernmentChanged', playerID, governmentID)
	local governmentInfo = GameInfo.Governments[governmentID]
	local pPlayer = Players[playerID]
	if governmentInfo and governmentInfo.Tier == 'Tier4' and pPlayer and pPlayer:GetCities() then
		for _, city in pPlayer:GetCities():Members() do
			if city and city:GetBuildings():HasBuilding(m_BuildingMerchantIndex) then
				city:GetBuildings():RemoveBuilding(m_BuildingDummyUnlockProjectIndex)
				return
			end
		end
	else
		for _, city in pPlayer:GetCities():Members() do
			if city and city:GetBuildings():HasBuilding(m_BuildingMerchantIndex) then
				city:GetBuildQueue():CreateBuilding(m_BuildingDummyUnlockProjectIndex)
				return
			end
		end
	end
end
-- ===========================================================================
function Initialize()
	Events.CityProjectCompleted.Add(OnCityProjectCompleted)
	Events.TurnBegin.Add(OnTurnBegin)
	Events.CapitalCityChanged.Add(OnCapitalCityChanged)
	Events.GovernmentChanged.Add(OnGovernmentChanged)

	GameEvents.BuildingConstructed.Add(OnBuildingConstructed)
end
-- ===========================================================================
Initialize();