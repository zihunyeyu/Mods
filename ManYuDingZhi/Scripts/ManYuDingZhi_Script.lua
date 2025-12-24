-- ManYuDingZhi_Script
-- Author: admin
-- DateCreated: 11/12/2023 5:19:35 PM
--------------------------------------------------------------
if (not ExposedMembers.ManYuDingZhi) then ExposedMembers.ManYuDingZhi = {}; end

function GetGovernorToEnvoysSpent(playerID)
    local pPlayer = Players[playerID];
	if (pPlayer ~= nil) then
        return pPlayer:GetProperty('GovernorPointsExchanged') or 0;
    end
end
ExposedMembers.ManYuDingZhi.GetGovernorToEnvoysSpent = GetGovernorToEnvoysSpent;

function OnPlayerRequestExchangeEnvoy( playerID:number, params:table)
    local pPlayer = Players[playerID];
	local pPlayerGovernors	:table	 = pPlayer:GetGovernors();
	local governorPointsObtained = pPlayerGovernors:GetGovernorPoints();
	local governorPointsSpent = pPlayerGovernors:GetGovernorPointsSpent() + ExposedMembers.ManYuDingZhi.GetGovernorToEnvoysSpent(playerID);
	local bttPointsLeft = (governorPointsObtained - governorPointsSpent > 0);

	if (pPlayer ~= nil and bttPointsLeft) then
        t = pPlayer:GetProperty('GovernorPointsExchanged') or 0;
	    pPlayer:SetProperty('GovernorPointsExchanged', t+1);

        pPlayer:GetInfluence():ChangeTokensToGive(2);
	end

    -- Refresh UI
    ExposedMembers.ManYuDingZhi.RefreshGVNPanel();
    ExposedMembers.ManYuDingZhi.RefreshGVNDPanel();
end
GameEvents.PlayerRequestExchangeEnvoy.Add(OnPlayerRequestExchangeEnvoy);

function OnGovernorAppointed( playerID:number, governorID:number)
    local governorDefinition:table = GameInfo.Governors[governorID];
    if (governorDefinition ~= nil and governorDefinition.GovernorType == 'GOVERNOR_THE_AMBASSADOR') then
        local pPlayer = Players[playerID];
        local pPlayerGovernors	:table	 = pPlayer:GetGovernors();
		if (pPlayer ~= nil) then
            local pPlayerGovernors	:table	 = pPlayer:GetGovernors();
            if (pPlayerGovernors ~= nil) then
                pPlayer:GetInfluence():ChangeTokensToGive(1);
		        pPlayerGovernors:ChangeGovernorPoints(1);
		    end
		end
    end
    
end
Events.GovernorAppointed.Add( OnGovernorAppointed );


-- AMBASSADOR_L2
function OnGovernorPromoted1( playerID:number, iGovernor:number, iPromotion:number)
    local governorDefinition:table = GameInfo.Governors[iGovernor];
    if (governorDefinition ~= nil and governorDefinition.GovernorType == 'GOVERNOR_THE_AMBASSADOR' ) then
        local governorProDefinition:table = GameInfo.GovernorPromotions[iPromotion];
        if (governorProDefinition ~= nil and governorProDefinition.GovernorPromotionType == 'GOVERNOR_PROMOTION_LOCAL_INFORMANTS' ) then

            local pPlayer = Players[playerID];
		    if (pPlayer ~= nil) then
                pPlayer:AttachModifierByID('SFDH100_AMBASSADOR_L2_SPY_CAPABILITY');
                pPlayer:AttachModifierByID('SFDH100_AMBASSADOR_L2_SPY_UNIT');
		    end
        end
    end
    
end
Events.GovernorPromoted.Add( OnGovernorPromoted1 );


-- AMBASSADOR_R3
function OnGovernorPromoted2( playerID:number, iGovernor:number, iPromotion:number)
    -- print('xxxxxx', playerID, iGovernor, iPromotion)
    local governorDefinition:table = GameInfo.Governors[iGovernor];
    if (governorDefinition ~= nil and governorDefinition.GovernorType == 'GOVERNOR_THE_AMBASSADOR' ) then
        local governorProDefinition:table = GameInfo.GovernorPromotions[iPromotion];
        if (governorProDefinition ~= nil and governorProDefinition.GovernorPromotionType == 'GOVERNOR_PROMOTION_AMBASSADOR_MINJIANJIAOLIU' ) then

            local pPlayer = Players[playerID];
		    if (pPlayer ~= nil) then
                local pCapital = pPlayer:GetCities():GetCapitalCity();
                if (pCapital ~= nil) then
                    -- print('xxxxxx') 没城市怎么办？
                    local pCityBuildQueue = pCapital:GetBuildQueue();
                    pCityBuildQueue:CreateIncompleteBuilding(GameInfo.Buildings['BUILDING_SFDH100_MINJIANJIAOLIU'].Index, 100);
            
                end
		    end
        end
    end
    
end
Events.GovernorPromoted.Add( OnGovernorPromoted2 );

-- ===========================================================================
function OnCityProjectCompleted_SpySatellite(playerId, cityID, projectID, buildingIndex, iX, iY, bCancelled)
	local projectInfo = GameInfo.Projects[projectID]
	if projectInfo and projectInfo.ProjectType == 'PROJECT_MYN_LAUNCH_SPY_SATELLITE' then
		for _, playerID in ipairs(PlayerManager.GetAliveIDs()) do
			if playerID ~= playerId then
				local pPlayer = Players[playerID]
				local pCities = pPlayer:GetCities()
				if pCities then
					for _, pCity in pCities:Members() do
						if pCity then
							local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
							PlayersVisibility[playerId]:ChangeVisibilityCount(pPlot:GetIndex(), 1)
						end
					end
				end
			end
		end
	end
end
Events.CityProjectCompleted.Add(OnCityProjectCompleted_SpySatellite)
-- ===========================================================================
--local m_DummyLeylineIndex = GameInfo.Improvements['IMPROVEMENT_MYN_LEY_LINE'] and GameInfo.Improvements['IMPROVEMENT_MYN_LEY_LINE'].Index or -1
--local m_DummyLeylineSeaIndex = GameInfo.Improvements['IMPROVEMENT_MYN_LEY_LINE_SEA'] and GameInfo.Improvements['IMPROVEMENT_MYN_LEY_LINE_SEA'].Index or -1
--local m_LeylineIndex = GameInfo.Resources['RESOURCE_LEY_LINE'] and GameInfo.Resources['RESOURCE_LEY_LINE'].Index or -1
--
--function OnImprovementAddedToMap(iX, iY, eImprovement, playerID)
	--local pPlot = Map.GetPlot(iX, iY)
	--if pPlot then
		--if m_DummyLeylineIndex == eImprovement or m_DummyLeylineSeaIndex == eImprovement then
			--ImprovementBuilder.SetImprovementType(pPlot, -1)
			--ResourceBuilder.SetResourceType(pPlot, m_LeylineIndex, 1)
		--end
	--end
--end
--Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap)

-- ===========================================================================
--local m_BuildingDummyFusionBoostIndex = GameInfo.Buildings['BUILDING_MYN_DUMMY_NUCLEAR_FUSION_BOOST'] and GameInfo.Buildings['BUILDING_MYN_DUMMY_NUCLEAR_FUSION_BOOST'].Index or -1
local m_FusionTechIndex = GameInfo.Technologies['TECH_NUCLEAR_FUSION'] and GameInfo.Technologies['TECH_NUCLEAR_FUSION'].Index or -1
local m_WMDIndex = GameInfo.WMDs['WMD_NUCLEAR_DEVICE'] and GameInfo.WMDs['WMD_NUCLEAR_DEVICE'].Index or -1
function OnWMDDetonated(x :number, y :number, iPlayerID :number, eWMD :number)
	local pPlayer = Players[iPlayerID]
	if m_WMDIndex == eWMD and pPlayer then
		if not pPlayer:GetTechs():HasBoostBeenTriggered(m_FusionTechIndex) then
			pPlayer:GetTechs():TriggerBoost(m_FusionTechIndex)
		end
	end
end
Events.WMDDetonated.Add( OnWMDDetonated )

-- ===========================================================================
local m_DummyForestIndex = GameInfo.Improvements['IMPROVEMENT_MYN_FOREST'] and GameInfo.Improvements['IMPROVEMENT_MYN_FOREST'].Index or -1
local m_DummyJungleIndex = GameInfo.Improvements['IMPROVEMENT_MYN_JUNGLE'] and GameInfo.Improvements['IMPROVEMENT_MYN_JUNGLE'].Index or -1

function OnImprovementAddedToMap_PlantForest(x :number, y :number, eImprovement :number, playerID :number)
	local pPlot = Map.GetPlot(x, y)
	if m_DummyForestIndex == eImprovement then
		ImprovementBuilder.SetImprovementType(pPlot, -1)
		TerrainBuilder.SetFeatureType(pPlot, GameInfo.Features['FEATURE_FOREST'].Index)
	elseif m_DummyJungleIndex == eImprovement then
		ImprovementBuilder.SetImprovementType(pPlot, -1)
		TerrainBuilder.SetFeatureType(pPlot, GameInfo.Features['FEATURE_JUNGLE'].Index)
	end
end
Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap_PlantForest)
-- ===========================================================================
-- 兵马俑：每退役一位古典时期的大将军，你的陆地军事单位便加1战斗力
GameEvents.OnGreatPersonActivated.Add(function (UnitOwner, UnitId, GreatPersonType, GreatPersonClass)
	--print('OnGreatPersonActivated', UnitOwner, UnitId, GreatPersonType, GreatPersonClass)
	local pPlayer = Players[UnitOwner]
	local individualInfo = GameInfo.GreatPersonIndividuals[GreatPersonType]
	if pPlayer and pPlayer:GetProperty('MYN_TERRACOTTA_PROPERTY') ~= nil and pPlayer:GetProperty('MYN_TERRACOTTA_PROPERTY') > 0 and individualInfo and individualInfo.EraType == 'ERA_CLASSICAL' and individualInfo.GreatPersonClassType == 'GREAT_PERSON_CLASS_GENERAL' then
		local pUnit = pPlayer:GetUnits():FindID(UnitId)
		if pUnit == nil or pUnit:GetGreatPerson():GetActionCharges() == 0 then
			pPlayer:AttachModifierByID('TERRACOTTA_MYN_COMBAT_STRENGTH_ATTACH')
		end
	end
end)

-- 图拉真的人物技能 建立，获得（联机相互送城也能获得）或攻占城市时赠送已解锁的所有市中心建筑
Events.CityAddedToMap.Add(function (playerID, cityID, iX, iY)
	if Players[playerID] and Players[playerID]:GetProperty('MYN_CIV_ROME') then
		local pCity = CityManager.GetCity(playerID, cityID)
		if pCity then
			local buildQueue = pCity:GetBuildQueue()
			for row in GameInfo.Buildings() do
				if row.PrereqDistrict == 'DISTRICT_CITY_CENTER' and not row.InternalOnly and ExposedMembers.ManYuDingZhi.CityCanProduce(playerID, cityID, row.Index) then
					buildQueue:CreateBuilding(row.Index)
				end
			end
		end
	end
end)

-- 波兰发教后获得遗物 其它文明创立宗教后，罗伯特获得一个大预言家。
Events.ReligionFounded.Add(function (playerID, religionID)
	local pPlayer = Players[playerID]
	if pPlayer then
		if pPlayer:GetProperty('MYN_LEADER_JADWIGA') then
			pPlayer:AttachModifierByID('TRAIT_LITHUANIANUNION_MYN_GRANT_RELIC')
		end
		for _, playerIndex in ipairs(PlayerManager.GetAliveIDs()) do
			local pPlayer2 = Players[playerIndex]
			if pPlayer2 and pPlayer2:GetProperty('MYN_LEADER_ROBERT_THE_BRUCE') then
				if playerIndex ~= playerID and pPlayer2:GetProperty('MYN_LEADER_ROBERT_THE_BRUCE_GOT_PROPHET') == nil then
					--if ExposedMembers.MYN and ExposedMembers.MYN.CanGetProphet and ExposedMembers.MYN.CanGetProphet(playerIndex) then
						local individualInfo = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_MARTIN_LUTHER']
						local class = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_PROPHET"].Hash
						local era = GameInfo.Eras[individualInfo.EraType].Hash
						Game.GetGreatPeople():GrantPerson(individualInfo.Hash, class, era, 0, playerIndex, false);
						pPlayer2:SetProperty('MYN_LEADER_ROBERT_THE_BRUCE_GOT_PROPHET', 1)
					--end
				end
			end
		end
	end
end)

Events.UnitGreatPersonCreated.Add(function (playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	local pPlayer = Players[playerID]
	local greatPersonClassInfo = GameInfo.GreatPersonClasses[greatPersonClassID]
	if pPlayer and pPlayer:GetProperty('MYN_LEADER_ROBERT_THE_BRUCE') and greatPersonClassInfo and greatPersonClassInfo.GreatPersonClassType == 'GREAT_PERSON_CLASS_PROPHET' then
		pPlayer:SetProperty('MYN_LEADER_ROBERT_THE_BRUCE_GOT_PROPHET', 1)
	end
end)

local m_DummyCanalIndex = GameInfo.Improvements['IMPROVEMENT_CANAL'] and GameInfo.Improvements['IMPROVEMENT_CANAL'].Index or -1

function OnImprovementAddedToMap_BuildCanal(x :number, y :number, eImprovement :number, playerID :number)
	local pPlot = Map.GetPlot(x, y)
	if m_DummyCanalIndex == eImprovement then
		ImprovementBuilder.SetImprovementType(pPlot, -1);
		local pCity = Cities.GetPlotPurchaseCity(pPlot);
		if pCity ~= nil then
		    local pBuildQueue = pCity:GetBuildQueue();
		    pBuildQueue:CreateIncompleteDistrict(GameInfo.Districts['DISTRICT_CANAL'].Index, pPlot:GetIndex(), 100);
		end
	end
end
Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap_BuildCanal)


function RefreshSiegeProp(playerID, cityID, bIsBesieged)
	local pCity = CityManager.GetCity(playerID, cityID);
	local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
	--print(plotID)
	if bIsBesieged then
		pPlot:SetProperty('PROP_UNDER_SIEGE', 1);
	else
		pPlot:SetProperty('PROP_UNDER_SIEGE', 0);
	end
	print(bIsBesieged)

end
Events.CitySiegeStatusChanged.Add(RefreshSiegeProp)

