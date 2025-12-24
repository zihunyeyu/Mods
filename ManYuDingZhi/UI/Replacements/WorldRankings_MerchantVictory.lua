-- WorldRankings_MerchantVictory
-- Author: Konomi
-- DateCreated: 11/16/2023 18:30:10
--------------------------------------------------------------

include("WorldRankings_Expansion2");
-- ===========================================================================
-- Constants
-- ===========================================================================
local MERCHANT_PROJECT1 = GameInfo.Projects['PROJECT_MYN_MERCHANT_1']
local MERCHANT_PROJECT2 = GameInfo.Projects['PROJECT_MYN_MERCHANT_2']
local MERCHANT_PROJECT3 = GameInfo.Projects['PROJECT_MYN_MERCHANT_3']
local MERCHANT_PROJECT4 = GameInfo.Projects['PROJECT_MYN_MERCHANT_4']
local FINAL_WAIT_TURN = 5

local m_MerchantIM = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.GenericViewStack);
local m_MerchantTeamIM = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.GenericViewStack);

-- ===========================================================================
-- Cached Functions
-- ===========================================================================
local XP2_AddTab = AddTab;
local BASE_ViewGeneric = ViewGeneric;
local XP2_ViewDiplomatic = ViewDiplomatic;
local BASE_PopulateOverallInstance = PopulateOverallInstance;

-- ===========================================================================
function GetMerchantProgress(pPlayer:table)
	local progress2Total = Game.GetProperty('MYN_MERCHANT_BUILDING_2_COUNT')
	if progress2Total == nil then
		progress2Total = 0
	end
	progress2Total = progress2Total + FINAL_WAIT_TURN
	if pPlayer:GetStats():GetNumProjectsAdvanced(MERCHANT_PROJECT1.Index) ~= 1 then
		return 0, 0, progress2Total
	end
	if pPlayer:GetStats():GetNumProjectsAdvanced(MERCHANT_PROJECT2.Index) ~= 1 then
		return 1, 0, progress2Total
	end
	if pPlayer:GetStats():GetNumProjectsAdvanced(MERCHANT_PROJECT3.Index) ~= 1 then
		return 2, 0, progress2Total
	end
	if pPlayer:GetStats():GetNumProjectsAdvanced(MERCHANT_PROJECT4.Index) ~= 1 then
		return 3, 0, progress2Total
	end
	local property1 = pPlayer:GetProperty('MERCHANT_VIC_FINAL_TURN')
	if property1 == nil then
		return 4, 0, progress2Total
	end
	local progress2 = Game.GetCurrentGameTurn() - property1
	if progress2 < progress2Total then
		return 4, progress2, progress2Total
	end
	return 5, 0, 0
end
-- ===========================================================================

g_victoryData.VICTORY_MYN_MERCHANT = {
	GetText = function(p) 
		local current = 0
		if p:IsAlive() then
			current = GetMerchantProgress(p)
		end
		if current < 5 then
			return Locale.Lookup("LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT", current + 1)
		end
		return Locale.Lookup("LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT_FINISHED")
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			current = GetMerchantProgress(p)
		end
		return current
	end,
	AdditionalSummary = function(p) return ''; end
};
function AddTab(label:string, onClickCallback:ifunction)
	if label == Locale.Lookup('LOC_VICTORY_MYN_MERCHANT_NAME') then
		label = Locale.Lookup('LOC_TOOLTIP_MYN_MERCHANT_CONGRESS_BUTTON')
	end
	return XP2_AddTab(label, onClickCallback)
end
function ViewDiplomatic(victoryType:string)
	m_MerchantIM:ResetInstances()
	m_MerchantTeamIM:ResetInstances()
	XP2_ViewDiplomatic(victoryType)
end
-- ===========================================================================
function PopulateOverallInstance(instance:table, victoryType:string, typeText:string)
	if victoryType == 'VICTORY_MYN_MERCHANT' then
		local numIcons = 0;
		
		instance.VictoryLabel:SetText(Locale.ToUpper(Locale.Lookup('LOC_VICTORY_MYN_MERCHANT_NAME')))
		instance.VictoryLabelUnderline:SetSizeX(instance.VictoryLabel:GetSizeX() + 90)
		
		local icon = 'ICON_VICTORY_GENERIC'
		local color = UI.GetColorValue("White")
		instance.VictoryBanner:SetColor(color)
		instance.VictoryLabelGradient:SetColor(color)

		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(icon, 64);
		instance.VictoryIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		instance.VictoryIcon:SetHide(false);

		-- Cache victory data to avoid table access within loops
		local victoryData = g_victoryData[victoryType];

		-- Team tiebreaker score functions
		local averageScores = function(playerData, playerCount, scoreKey)
			-- Add player scores
			local score:number = 0;
			for _, player in pairs(playerData) do
				score = score + player[scoreKey];
			end
			-- Divide by player count
			return score / playerCount;
		end;

		-- Gather team data
		local teamIDs = GetAliveMajorTeamIDs();

		local teamData:table = {};
		for _, teamID in ipairs(teamIDs) do
			local team = Teams[teamID];
			if(team ~= nil) then
				local playerData:table = {};
				local playerCount:number = 0;
				local teamGenericScore = 0;
				local maxProgress = 0
				for i, playerID in ipairs(team) do
					if IsAliveAndMajor(playerID) then
						local pPlayer:table = Players[playerID];

						local firstTiebreaker:table = victoryData.Primary or victoryData;
						local secondTiebreaker:table = victoryData.Secondary or victoryData;
						local primaryScore:number = firstTiebreaker.GetScore(pPlayer);
						local secondaryScore:number = secondTiebreaker.GetScore(pPlayer);					

						local progress, progress2 = GetMerchantProgress(pPlayer)
						if progress > maxProgress then
							maxProgress = progress
						end

						playerData[playerID] = {
							Player = pPlayer,
							GenericScore = progress,
							FirstTiebreakScore = primaryScore,
							SecondTiebreakScore = secondaryScore,
							FirstTiebreakSummary = Locale.Lookup('LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT', progress + 1),
							SecondTiebreakSummary = Locale.Lookup('LOC_WORLD_RANKINGS_MERCHANT_POINTS_TT', progress + 1),							
						};

						playerCount = playerCount + 1;
					end
				end

				table.insert(teamData, {
					TeamID = teamID,
					TeamScore = maxProgress / 5,
					TeamProgress = maxProgress,
					TeamGenericScore = teamGenericScore,
					PlayerData = playerData,
					PlayerCount = playerCount,
					FirstTeamTiebreakScore = averageScores(playerData, playerCount, "FirstTiebreakScore");
					SecondTeamTiebreakScore = averageScores(playerData, playerCount, "SecondTiebreakScore");
				});
			end
		end

		table.sort(teamData, function(a, b)
			if (a.TeamProgress ~= b.TeamProgress) then
				return a.TeamProgress > b.TeamProgress;
			elseif(a.FirstTeamTiebreakScore ~= b.FirstTeamTiebreakScore) then
				return a.FirstTeamTiebreakScore > b.FirstTeamTiebreakScore;
			elseif(a.SecondTeamTiebreakScore ~= b.SecondTeamTiebreakScore) then
				return a.SecondTeamTiebreakScore > b.SecondTeamTiebreakScore;
			elseif(a.TeamGenericScore ~= b.TeamGenericScore) then
				return a.TeamGenericScore > b.TeamGenericScore;
			else
				return a.TeamID < b.TeamID;
			end
		end);

		-- Handle case where this victory type is not completable by any team.
		-- This can happen with Global Thermonuclear War's Proxy War victory if there are no city states to conquer.
		if(#teamData < 1) then
				instance.VictoryPlayer:SetText("");
				instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_VICTORY_DISABLED"));
				instance.TeamRibbon:SetHide(true);
				instance.TopPlayer:SetHide(true);
				instance.CivIcon:SetHide(true);
				instance.CivIconFaded:SetHide(true);
				instance.CivIconBacking:SetHide(true);
				instance.CivIconBackingRing:SetHide(true);
				instance.CivIconBackingFaded:SetHide(true);
				instance.VictoryLabelGradient:SetHide(true); 
				instance.VictoryBanner:SetHide(true); 
				instance.VictoryIcon:SetHide(true); 
			return;
		end

		-- Ensure we have Instance Managers for the player meters
		local playersIM:table = instance['OverallPlayersIM'];
		if(playersIM == nil) then
			playersIM = InstanceManager:new("OverallPlayerInstance", "CivIconBackingFaded", instance.PlayerStack);
			instance['OverallPlayersIM'] = playersIM;
		end
		playersIM:ResetInstances();

		-- Populate top team/player icon
		if teamData[1].PlayerCount > 1 then
			PopulateOverallTeamIconInstance(instance, teamData[1], 38, 53);
		else
			PopulateOverallPlayerIconInstance(instance, victoryType, teamData[1], 48);
		end
		numIcons = numIcons + 1;

		-- Populate other team/player icons
		if #teamData > 1 then
			for i = 2, #teamData, 1 do
				local playerInstance:table = playersIM:GetInstance();
				if teamData[i].PlayerCount > 1 then
					PopulateOverallTeamIconInstance(playerInstance, teamData[i], 28, 44);
				else
					PopulateOverallPlayerIconInstance(playerInstance, victoryType, teamData[i], 36);
				end
				numIcons = numIcons + 1;
			end
		end

		-- Determine if local player is leading
		local isLocalPlayerLeading:boolean = false;
		local leadingTeam:table = teamData[1];
		for playerID, data in pairs(teamData[1].PlayerData) do
			if playerID == g_LocalPlayerID then
				isLocalPlayerLeading = true;
			end
		end

		if isLocalPlayerLeading then
			instance.VictoryPlayer:SetText("");
			if teamData[1].PlayerCount > 1 then
				instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_TEAM_SIMPLE"));
			else
				instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_YOU_SIMPLE"));
			end
		else
			local topName:string = "";
			if teamData[1].PlayerCount > 1 then
				topName = Locale.Lookup("LOC_WORLD_RANKINGS_TEAM", GameConfiguration.GetTeamName(teamData[1].TeamID));
			else
				local topPlayerID:number = Teams[teamData[1].TeamID][1];
				if(g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(topPlayerID))then
					topName = Locale.Lookup(GameInfo.Civilizations[PlayerConfigurations[Teams[teamData[1].TeamID][1]]:GetCivilizationTypeID()].Name);
				else
					topName = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER");
				end
			end
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_OTHER_SIMPLE", topName));

			local isVictoryPlayerSet:boolean = false;
			for teamPosition, team in ipairs(teamData) do
				for playerID, data in pairs(team.PlayerData) do
					if playerID == m_LocalPlayerID then
						local localPlayerPositionText:string = Locale.Lookup("LOC_WORLD_RANKINGS_" .. teamPosition .. "_PLACE");
						local localPlayerDescription:string = "";

						if team.PlayerCount > 1 then
							localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_TEAM_SIMPLE", localPlayerPositionText);
						else
							localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_SIMPLE", localPlayerPositionText);
						end

						instance.VictoryPlayer:SetText(localPlayerDescription);
						isVictoryPlayerSet = true;
					end
				end
			end
			if (not isVictoryPlayerSet) then
				instance.VictoryPlayer:SetText("");		
			end
		end

		instance.ButtonBG:SetSizeY(100 + math.max(instance.PlayerStack:GetSizeY(), 40 * ((numIcons / 9) + 1)));
		-- end
	else
		BASE_PopulateOverallInstance(instance, victoryType, typeText)
	end
end
function PopulateMerchantProgressMeters(instance:table, progress1, progress2, progress2Total)
	for i = 1, progress1 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(false);
		instance["ObjBar_" .. i]:SetPercent(1);
		instance["ObjToggle_ON_" .. i]:SetHide(false);
	end
	if progress1 == 4 and progress2Total ~= 0 then
		instance["ObjBar_5"]:SetPercent(progress2 / progress2Total);
	end
	instance["ObjBG_1"]:LocalizeAndSetToolTip("LOC_MYN_MERCHANT_VIC_1_TOOLTIP");
	instance["ObjBG_2"]:LocalizeAndSetToolTip("LOC_MYN_MERCHANT_VIC_2_TOOLTIP");
	instance["ObjBG_3"]:LocalizeAndSetToolTip("LOC_MYN_MERCHANT_VIC_3_TOOLTIP");
	instance["ObjBG_4"]:LocalizeAndSetToolTip("LOC_MYN_MERCHANT_VIC_4_TOOLTIP");
	instance["ObjBG_5"]:LocalizeAndSetToolTip("LOC_MYN_MERCHANT_VIC_5_TOOLTIP", progress2Total, progress2);
end
function PopulateMerchantInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	local pPlayerStats:table = pPlayer:GetStats();
	local progress1, progress2, progress2Total = GetMerchantProgress(pPlayer)
	
	PopulateMerchantProgressMeters(instance, progress1, progress2, progress2Total)

	return progress1, progress2
end
function PopulateMerchantTeamInstance(instance:table, teamID:number)
	PopulateTeamInstanceShared(instance, teamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ScienceInstance", "ButtonBG", instance.SciencePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	local teamProgressData1, teamProgressData2 = 0, 0;
	local progress2Total = Game.GetProperty('MYN_MERCHANT_BUILDING_2_COUNT')
	if progress2Total == nil then
		progress2Total = 0
	end
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			local pPlayer:table = Players[playerID];
			local progress1, progress2 = PopulateMerchantInstance(instance.PlayerStackIM:GetInstance(), pPlayer);
			if teamProgressData1 < progress1 then
				teamProgressData1 = progress1
			end
			if progress1 == 4 and teamProgressData2 < progress2 then
				teamProgressData2 = progress2
			end
		end
	end

	-- Populate the team progress with the progress of the furthest player
	PopulateMerchantProgressMeters(instance, teamProgressData1, teamProgressData2, progress2Total + FINAL_WAIT_TURN);
end
function ViewGeneric(victoryType:string)
	if victoryType == 'VICTORY_MYN_MERCHANT' then		
		ResetState(function() ViewGeneric(victoryType); end);
		Controls.GenericView:SetHide(false);

		ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);
		PopulateGenericHeader(RealizeGenericStackSize, Locale.Lookup('LOC_VICTORY_MYN_MERCHANT_NAME'), nil, Locale.Lookup('LOC_VICTORY_MYN_MERCHANT_DESCRIPTION'), 'ICON_VICTORY_GENERIC');

		local genericData:table = GatherGenericData();

		m_MerchantIM:ResetInstances();
		m_MerchantTeamIM:ResetInstances();
		g_GenericIM:ResetInstances();
		g_GenericTeamIM:ResetInstances();
		
		for i, teamData in ipairs(genericData) do
			if #teamData.PlayerData > 1 then
				--for a, b in pairs(teamData) do
					--print(a, b)
				--end
				PopulateMerchantTeamInstance(m_MerchantTeamIM:GetInstance(), teamData.TeamID);
			else
				local uiGenericInstance:table = m_MerchantIM:GetInstance();
				local pPlayer = Players[teamData.PlayerData[1].PlayerID];
				PopulateMerchantInstance(uiGenericInstance, pPlayer)
			end
		end		
		
		RealizeGenericStackSize();
	else
		BASE_ViewGeneric(victoryType)
	end

end
-- ===========================================================================
-- Constructor
-- ===========================================================================
function Initialize()
	ToggleExtraTabs(); -- Start with extra tabs opened so DiplomaticVictory tab is visible by default
end
Initialize();
