-- GovernorPanel_ManYuDingZhi
-- Author: admin
-- DateCreated: 11/12/2023 5:33:41 PM
--------------------------------------------------------------
-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_PanelBuilded	: boolean = false;
local Control_GovernorTitleStack; 

-- ===========================================================================
function OnGovernorPointsExchangeButtonClicked()
	local kParameters:table = {};
	local playerID = Game.GetLocalPlayer();
	kParameters.OnStart = "PlayerRequestExchangeEnvoy";
	UI.RequestPlayerOperation(playerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);

end


-- ===========================================================================
function GetTitle()		--Get Control

	local Control_GovernorPanelContainer = ContextPtr:LookUpControl("/InGame/Screens/GovernorPanel/GovernorPanelContainer");

	for i1, v1 in pairs(Control_GovernorPanelContainer:GetChildren()) do
		-- print(i1, v1)
		for i2, v2 in pairs(v1:GetChildren()) do
			-- print(i2, v2)
			for i3, v3 in pairs(v2:GetChildren()) do
				-- print(i3, v3:GetID())
				if v3:GetID() == 'GovernorTitlesAvailable' then
					-- print(i3, v3:GetID(), v3:GetParent():GetParent());
					Control_GovernorTitleStack = v3:GetParent():GetParent()
				end
			end
		end
	end

	-- print(Control_GovernorPanelContainer)
	
end

-- ===========================================================================
function BuildControlForPanel()
	if m_PanelBuilded then return; end

	GetTitle();
	Controls.GovernorPointsExchangeButton:ChangeParent(Control_GovernorTitleStack);
	m_PanelBuilded = true;
	LuaEvents.GovernorPanel_Open.Remove( BuildControlForPanel );
	LuaEvents.GovernorPanel_Toggle.Remove( BuildControlForPanel );

end

-- ===========================================================================
function Refresh()
    local pPlayer = Players[Game.GetLocalPlayer()];
	if (pPlayer == nil) then
		return;
	end

	local playerGovernors = pPlayer:GetGovernors();

    local governorPointsObtained = playerGovernors:GetGovernorPoints();
	local governorPointsSpent = playerGovernors:GetGovernorPointsSpent() + ExposedMembers.ManYuDingZhi.GetGovernorToEnvoysSpent(Game.GetLocalPlayer());

	Controls.GovernorPointsExchangeButton:SetDisabled( governorPointsObtained - governorPointsSpent > 0 );
end

-- ===========================================================================
function Subscribe()
	LuaEvents.GovernorPanel_Open.Add( BuildControlForPanel );
	LuaEvents.GovernorPanel_Toggle.Add( BuildControlForPanel );
    LuaEvents.GameDebug_Return.Add( Refresh );
    LuaEvents.GovernorPointsChanged.Add( Refresh );
end

-- ===========================================================================
function Unsubscribe()
	LuaEvents.GovernorPanel_Open.Remove( BuildControlForPanel );
	LuaEvents.GovernorPanel_Toggle.Remove( BuildControlForPanel );
    LuaEvents.GameDebug_Return.Remove( Refresh );
    LuaEvents.GovernorPointsChanged.Remove( Refresh );
end

-- ===========================================================================
function OnShutdown()
	Unsubscribe();
end

-- ===========================================================================
function CallbacksInit()
	Controls.GovernorPointsExchangeButton:RegisterCallback( Mouse.eLClick, OnGovernorPointsExchangeButtonClicked );
end

-- ===========================================================================
function LateInitialize()
	Subscribe();
end

-- ===========================================================================
function OnInit(isReload:boolean)
	CallbacksInit()
	LateInitialize();
end

-- ===========================================================================
function Initialize()
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetInputHandler( OnInputHandler, true );
	ContextPtr:SetShutdown( OnShutdown );

end
-- Initialize()


-- Merchant Base
function OnCommercialHubBuilt(playerID, cityID, iConstrutionType, itemID, bCancelled)
	-- print('OnCommercialHubBuilt', playerID, cityID, iConstrutionType, itemID, bCancelled)
	if (iConstrutionType == 2 
		and (GameInfo.Districts[itemID].DistrictType == "DISTRICT_COMMERCIAL_HUB"
			or GameInfo.DistrictReplaces[GameInfo.Districts[itemID].DistrictType].ReplacesDistrictType == "DISTRICT_COMMERCIAL_HUB")
		and Game.GetLocalPlayer() == playerID) then

			local eGovernor = GameInfo.Governors["GOVERNOR_THE_MERCHANT"].Index;

			local kParameters:table = {};
			kParameters[PlayerOperations.PARAM_GOVERNOR_TYPE] = eGovernor;
	
			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.APPOINT_GOVERNOR, kParameters);

	end

	-- local pCity:table = CityManager.GetCity(playerID, cityID);

	-- if (pCity ~= nil and pCity:GetDistricts():HasDistrict(GameInfo.Districts["DISTRICT_COMMERCIAL_HUB"].Index)) then
	-- 	pDistrict:IsComplete();
	-- end
	-- pDistrict:IsComplete();


end
Events.CityProductionCompleted.Add( OnCommercialHubBuilt );

-- Merchant Base
function OnUnitCommandStarted(playerID, unitID, hCommand, iData1, a, b)
	-- print('OnUnitCommandStarted', playerID, unitID, hCommand, iData1, a, b)
	if Game.GetLocalPlayer() ~= playerID then return; end
	if hCommand == DB.MakeHash('UNITCOMMAND_COMPLETE_DISTRICT') then
		local pUnit = UnitManager.GetUnit(playerID, unitID)
		if pUnit then
			local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
			if pPlot then
				local districtType = pPlot:GetDistrictType()
				if districtType then 
					if GameInfo.Districts[districtType].DistrictType == "DISTRICT_COMMERCIAL_HUB"
						or GameInfo.DistrictReplaces[GameInfo.Districts[districtType].DistrictType].ReplacesDistrictType == "DISTRICT_COMMERCIAL_HUB" then

						local eGovernor = GameInfo.Governors["GOVERNOR_THE_MERCHANT"].Index;

						local kParameters:table = {};
						kParameters[PlayerOperations.PARAM_GOVERNOR_TYPE] = eGovernor;
						
						UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.APPOINT_GOVERNOR, kParameters);

					end
				end
			end
		end
	end
end
Events.UnitCommandStarted.Add(OnUnitCommandStarted)
