-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("InstanceManager");
include("SupportFunctions");
include("TabSupport");
include("Civ6Common");
include("PopupDialog");
include("ModalScreen_PlayerYieldsHelper");
include("GameCapabilities");

-- Core
include("ContextBase")

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
-- InGame
GameEvents = ExposedMembers.GameEvents;


local COLOR_GOVT_UNSELECTED			:number = UI.GetColorValueFromHexLiteral(0xffe9dfc7); -- Background for unselected background (or forground text color on non-selected).
local COLOR_GOVT_SELECTED			:number = UI.GetColorValueFromHexLiteral(0xff261407); -- Background for selected background (or forground text color on non-selected).
local DATA_FIELD_TOTAL_SLOTS		:string = "_TOTAL_SLOTS";			-- Total slots for a government item in the "tree-like" view
local DATA_FIELD_GOV_TYPE			:string = "_GOV_TYPE";
local PIC_PERCENT_BRIGHT			:string = "Governments_PercentWhite";
local PIC_PERCENT_DARK				:string = "Governments_PercentBlue";

-- SIZE
local SIZE_MIN_SPEC_X						:number = 1024;
-- TEXT
local TXT_GOV_POPUP_YES						:string = Locale.Lookup("LOC_GOVT_PROMPT_YES");
local TXT_GOV_POPUP_NO						:string = Locale.Lookup("LOC_GOVT_PROMPT_NO");

-- 总督 一国两制 能力名
local pOCTS      = "LOC_GOVERNOR_PROMOTION_TWO_SYSTEMS_NAME";
-- ===========================================================================
-- VARIABLES
-- ===========================================================================

-- 本地玩家ID
local m_ePlayerID 						= -1;

-- 总督所在城市ID
local gCityID							= -1;

local m_kBonuses						= {};
local g_kGovernments 					= {};
local g_kCurrentGovernment 				= nil;
local g_kSecondGovernment 				= nil;
local m_isGovernmentUnlocked 			= false;

local govRepeatClickTimes 				= 0;

-- SIZE
local m_width					:number	= SIZE_MIN_SPEC_X;	-- Screen Width (default / min spec)

-- Instance
local m_levelIM					:table = InstanceManager:new("GovLevelInstance",			"GovLevelInstanceContainer", Controls.OCTSContainerStack);
local m_kGovernmentItemIM		:table = InstanceManager:new("GovernmentItemInstance",		"Top"													);

-- ===========================================================================
-- FUNCTIONS	GameData 
-- ===========================================================================
function GetGovernmentFlatBonusPreview(governmentBonusType:string)
	if (governmentBonusType == nil or governmentBonusType == "") then
		return 0;
	end
	local governmentType:string = nil;
	for row in GameInfo.Governments() do
		if (row.BonusType == governmentBonusType) then
			governmentType = row.GovernmentType;
			break;
		end
	end
	if (governmentType == nil) then
		return 0;
	end
	local flatBonusModifierId:string = nil;
	for row in GameInfo.GovernmentModifiers() do
		if (row.GovernmentType == governmentType) then
			local modifierId:string = row.ModifierId;
			local modifierArgs:table = {};
			for argRow in GameInfo.ModifierArguments() do
				if (argRow.ModifierId == modifierId) then
					table.insert(modifierArgs, argRow);
				end
			end
			local bonusType:string = nil;
			local amount:number = nil;
			for i,modifierArg in ipairs(modifierArgs) do
				if (modifierArg.Name == "BonusType") then
					bonusType = modifierArg.Value;
				elseif (modifierArg.Name == "Amount") then
					amount = tonumber(modifierArg.Value) or modifierArg.Value;
				end
			end
			if (bonusType ~= nil and bonusType == governmentBonusType and amount ~= nil) then
				return amount;
			end
		end
	end
	return 0;
end

function GetGovernmentTextColor(governmentType:string)
	if  governmentType == g_kCurrentGovernment or governmentType == g_kSecondGovernment then
		return COLOR_GOVT_SELECTED;
	else
		return COLOR_GOVT_UNSELECTED;
	end
end

function PopulateStaticData()
	g_kGovernments = {};
	for row in GameInfo.Governments() do
		local slotMilitary		:number = 0;
		local slotEconomic		:number = 0;
		local slotDiplomatic	:number = 0;
		local slotWildcard		:number = 0;
        local totalSlots        :number = 0;

		for entry in GameInfo.Government_SlotCounts() do
			if row.GovernmentType == entry.GovernmentType then
				local slotType = entry.GovernmentSlotType;
				for i = 1, entry.NumSlots, 1 do
					if		slotType == "SLOT_MILITARY" then									slotMilitary	= slotMilitary + 1;
					elseif	slotType == "SLOT_ECONOMIC"	then									slotEconomic	= slotEconomic + 1;
					elseif	slotType == "SL_DIPLOMATIC" then									slotDiplomatic	= slotDiplomatic + 1;
					elseif	slotType == "SLOT_WILDCARD" or slotType=="SLOT_GREAT_PERSON" then	slotWildcard	= slotWildcard + 1;
					end
                    totalSlots = totalSlots + 1;
				end
			end
		end

		g_kGovernments[row.GovernmentType] = {
			BonusAccumulatedText	= row.AccumulatedBonusShortDesc,
			BonusAccumulatedTooltip	= row.AccumulatedBonusDesc,
			BonusFlatAmountPreview	= GetGovernmentFlatBonusPreview(row.BonusType),
			BonusInherentText		= row.InherentBonusDesc,
			BonusType				= row.BonusType,
			Hash					= GameInfo.Types[row.GovernmentType].Hash,
			Index					= row.Index,
			Name					= row.Name,
			NumMilitary			= slotMilitary,
			NumSlotEconomic			= slotEconomic,
			NumSlotDiplomatic		= slotDiplomatic,
			NumSlotWildcard			= slotWildcard,
            NumTotalSlots           = totalSlots,
			GovType 				= row.GovernmentType
		}
	end
 
    m_kBonuses = {};
	for governmentType, government in pairs(g_kGovernments) do
		if government.BonusFlatAmountPreview >= 0 then
			m_kBonuses[governmentType] = {	BonusPercent			= government.BonusFlatAmountPreview
			}
		end	
	end
end

function InitializeData()
	local player = Players[m_ePlayerID]
	local savedGovType = player:GetProperty("SECOND_GOVERNMENT");
	g_kCurrentGovernment = GetPlayerCurrentGovernment(m_ePlayerID)

	if savedGovType == nil then
		return
	end

	for _,city in player:GetCities():Members() do
		if IsCityHasGovernorWithProtion(city, pOCTS) then
			gCityID = city:GetID()
			g_kSecondGovernment = savedGovType
			ToggleSecondGovEffect(1)
			break
		end
	end
end
-- ===========================================================================
--	UI Create
-- ===========================================================================
function Resize()
	m_width, _	= UIManager:GetScreenSizeVal();				-- Cache screen dimensions
	Controls.OCTSContainer:SetSizeX(m_width);
end

function RealizeGovernmentInstance(governmentType:string, inst:table)
    local government:table = g_kGovernments[governmentType];
    inst.Top:RegisterCallback(Mouse.eRClick, function() LuaEvents.OpenCivilopedia(governmentType); end);
    inst.Selected:RegisterCallback(Mouse.eRClick, function() LuaEvents.OpenCivilopedia(governmentType); end);	
	inst.GovernmentExtra:SetHide(true)

    local COLOR_WHITE = UI.GetColorValue("COLOR_WHITE");
    inst.Top:SetColor(COLOR_WHITE);
    inst.ImageFrame:SetColor(COLOR_WHITE);
    inst.ArtLeft:SetColor(COLOR_WHITE);
    inst.ArtRight:SetColor(COLOR_WHITE);
    inst.Top:RegisterCallback(Mouse.eLClick, function() OnSecondGovClicked( government ) end );
    inst.UnlockedIcon:SetHide( true );
    inst.Disabled:SetHide( true );
    inst.GovernmentImage:SetHide( false );

	inst.GovernmentName:SetText( Locale.ToUpper(government.Name));
	inst.GovernmentImage:SetTexture(GameInfo.Governments[government.Index].GovernmentType);
	local textColor:number = GetGovernmentTextColor(governmentType);
	local bonusName:string = GameInfo.Governments[government.Index].BonusType or "NO_GOVERNMENTBONUS";

	if governmentType == g_kCurrentGovernment then
		-- Selected government
		inst.Selected:SetHide( false );
		inst.GovernmentExtra:SetHide(false)
		inst.GovernmentExtra:SetText( "[ICON_Government]"..Locale.ToRomanNumeral(1));
        inst.Selected:RegisterCallback(Mouse.eLClick, function() OnSelectedGovernmentRepeatClicked( government ) end );
		inst.PercentImage:SetTexture( PIC_PERCENT_BRIGHT );
		inst.GovernmentBonusBacking:SetColorByName( "GovBonusSelected" );
		inst.GovPercentBonusArea:SetColorByName( "GovBonusSelected" );
	
	elseif governmentType == g_kSecondGovernment then
		-- 已选择的第二政体
		inst.GovernmentName:SetText( Locale.ToUpper("LOC_SECOND_GOV_TAG")..Locale.ToUpper(government.Name));
		inst.GovernmentExtra:SetHide(false)
		inst.GovernmentExtra:SetText( "[ICON_Government]"..Locale.ToRomanNumeral(2) );
		inst.Selected:SetHide( false );
		inst.PercentImage:SetTexture( PIC_PERCENT_BRIGHT );
		inst.GovernmentBonusBacking:SetColorByName( "GovBonusSelected" );
		inst.GovPercentBonusArea:SetColorByName( "GovBonusSelected" );
	else
		-- Non-selected government			
		inst.Selected:SetHide( true );
		inst.PercentImage:SetTexture( PIC_PERCENT_DARK );
		inst.GovernmentBonusBacking:SetColorByName( "GovBonusDark" );
		inst.GovPercentBonusArea:SetColorByName( "GovBonusDark" );
	end

	inst.GovernmentName:SetColor( textColor );

	if m_kBonuses[governmentType] ~= nil then
		inst.GovPercentBonusArea:SetHide( false );
		inst.BonusPercent:SetText( m_kBonuses[governmentType].BonusPercent );
		inst.BonusText:SetText(	Locale.ToUpper(government.BonusAccumulatedText) );
		inst.GovernmentBonus:SetText( Locale.ToUpper(government.BonusInherentText) );

		inst.BonusPercent:SetColor( textColor );
		inst.BonusText:SetColor( textColor );
		inst.GovernmentBonus:SetColor( textColor );
		inst.GovPercentBonusArea:SetToolTipString( Locale.Lookup(government.BonusAccumulatedTooltip) );
	else
		if government.BonusAccumulatedText ~= nil and government.BonusAccumulatedText ~= "" then
			inst.GovPercentBonusArea:SetHide( false );
			inst.GovernmentBonus:SetText(	Locale.ToUpper(government.BonusAccumulatedText) );
			inst.BonusPercent:SetText("0");
			inst.BonusText:SetText( "" );
			inst.BonusPercent:SetColor( textColor );
			inst.BonusText:SetColor( textColor );
			inst.GovernmentBonus:SetColor( textColor );
			inst.GovPercentBonusArea:SetToolTipString( Locale.Lookup(government.BonusAccumulatedTooltip) );
		else
			inst.GovPercentBonusArea:SetHide( true );
		end
	end

    -- inst.GovPercentBonusArea:SetHide( true );
	--If we don't have legacy enabled, allow for multiple lines of passives that look like
	--passives, not accumulations
	if not HasCapability("CAPABILITY_GOVERNMENTS_LEGACY_BONUSES") then
		inst.PercentImage:SetHide(true);
		inst.QuillImage:SetHide(true);
		inst.BonusText:SetWrapWidth(265);
		inst.BonusText:SetOffsetX(-5);
	end
		
	-- If bonus exists for current one.	
	if bonusName ~= "NO_GOVERNMENTBONUS" then
		inst.BonusStack:SetHide( false );
	else
		inst.BonusStack:SetHide( true );
	end
		
	inst.GovernmentContentStack:CalculateSize();
	
	inst.Top:SetSizeY(inst.GovernmentContentStack:GetSizeY() + 12);

	return government.NumTotalSlots;
end

function RelizeExtraGovernmentPage()
    local pPlayer		:table = Players[m_ePlayerID];
    if pPlayer == nil then
        return
    end

	local kPlayerCulture:table = pPlayer:GetCulture();

    local grid:table = {};

	for governmentType,government in pairs(g_kGovernments) do
        while true do
            if (not kPlayerCulture:IsGovernmentUnlocked(government.Hash)) then      -- 检查是否为已解锁的政体，未解锁则跳过
                break
            end
            local inst:table = {};
            local government:table = g_kGovernments[governmentType];
            inst[DATA_FIELD_TOTAL_SLOTS] = government.NumTotalSlots;
            inst[DATA_FIELD_GOV_TYPE] = governmentType;
			-- 通过政体政策卡数量分组
            if grid[ inst[DATA_FIELD_TOTAL_SLOTS] ] == nil then
                grid[ inst[DATA_FIELD_TOTAL_SLOTS] ] = { };
            end
            table.insert(grid[ inst[DATA_FIELD_TOTAL_SLOTS] ], inst)
            break
        end
	end

    m_levelIM:ResetInstances()
    m_kGovernmentItemIM:ResetInstances()
    -- Layout based on grid
	local maxWidth = Controls.OCTSContainer:GetSizeX();
	if maxWidth >1200 then
		Controls.OCTSContainer:SetSizeX(1200)
	end


	local govLevel:number = 0;
	for _,column in orderedPairs(grid) do		
		local num				:number = table.count(column);
        local levelInstance = m_levelIM:GetInstance()
        levelInstance.GovLevelInstanceTitle:SetText(Locale.ToRomanNumeral(govLevel))

		for y=1,num,1 do
			local governmentType = column[y][DATA_FIELD_GOV_TYPE];
			local inst:table = m_kGovernmentItemIM:GetInstance(levelInstance.GovItemInstanceStack);
			RealizeGovernmentInstance(governmentType, inst)
			
			levelInstance.GovItemInstanceStack:CalculateSize()
		end

        govLevel = govLevel + 1
	end

    Controls.OCTSContainerStack:CalculateSize()
	Controls.OCTSScrollPanel:CalculateSize()
end

function DisplayExtraGovButton(playerId, cityId)
    local pCity = CityManager.GetCity(playerId, cityId)
    local pAssignedGovernor = pCity:GetAssignedGovernor();
    local isTargetCity = (pAssignedGovernor ~= nil and IsCityHasGovernorWithProtion(pCity, pOCTS))
	Controls.ExtraGovButton:SetHide(not isTargetCity)
	if isTargetCity then		
		gCityID = cityId		-- 总督所在cityID
	end
end

-- ===================================================================
--	Open and Close
-- ===========================================================================
function OpenExtraGovScreen()
	RelizeExtraGovernmentPage()

	if not UIManager:IsInPopupQueue(ContextPtr) then
		-- Queue the screen as a popup, but we want it to render at a desired location in the hierarchy, not on top of everything.
		local kParameters = {};
		kParameters.RenderAtCurrentParent = true;
		kParameters.InputAtCurrentParent = true;
		kParameters.AlwaysVisibleInQueue = true;
		UIManager:QueuePopup(ContextPtr, PopupPriority.Low, kParameters);
		UI.PlaySound("UI_Screen_Open");
	end
end

function OnOpenExtraGovScreen()
	g_kCurrentGovernment = GetPlayerCurrentGovernment(m_ePlayerID)
    OpenExtraGovScreen()
end

function Close()
    if ContextPtr:IsHidden() then
        return
    else
        UI.PlaySound("UI_Screen_Close");
    end
    UIManager:DequeuePopup(ContextPtr);
end
-- ===========================================================================
--	UI Event
-- ===========================================================================

-- 开关适用的政体效果
-- nil 	= toggle off, 
-- 1 	= toggle on
function ToggleSecondGovEffect(tFlag)
	local gCity = CityManager.GetCity(m_ePlayerID, gCityID)
	if gCity == nil then
		return
	end
    local gCityPlotID = Map.GetPlot(gCity:GetX(), gCity:GetY()):GetIndex()

	if g_kSecondGovernment ~= nil then
		GameEvents.SetPlotProperty.Call(gCityPlotID, "SECOND_GOV_PROPERTY_"..g_kSecondGovernment, tFlag)
	end
	UpdateCityPanel(gCity)
end

function OnSecondGovClicked(government: table)
	local popup = PopupDialogInGame:new( "ConfirmGovtChange" );
	popup:AddText(Locale.Lookup("LOC_SECOND_GOV_CONFIRM_TIPS", Locale.ToUpper(government.Name)));
    popup:AddConfirmButton(TXT_GOV_POPUP_YES,
		function ()
			-- 关闭上一次适用的政体效果
			if g_kSecondGovernment ~= nil then
				ToggleSecondGovEffect(nil)
			end
			g_kSecondGovernment = government.GovType
			ToggleSecondGovEffect(1)
			RelizeExtraGovernmentPage()
			-- 重复选择已有的政体
			govRepeatClickTimes = 0
		end
	);
    popup:AddCancelButton(TXT_GOV_POPUP_NO, function ()
		-- Nothing happened..
	end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government");
end

function OnSelectedGovernmentRepeatClicked(government: table)
	if govRepeatClickTimes==-1 then
		return false
	end
	if govRepeatClickTimes < 10 then
		govRepeatClickTimes  = govRepeatClickTimes + 1
	else
		govRepeatClickTimes = -1
	end
end

-- ===========================================================================
--	Input
--	UI Event Handler
-- ===========================================================================
function OnInputHandler( pInputStruct:table )
	if ( pInputStruct:GetMessageType() == KeyEvents.KeyUp ) then
		local key:number = pInputStruct:GetKey();
		if ( key == Keys.VK_ESCAPE ) then
			Close();
			return true;
		end
	end
	return false;
end

function OnShutdown()
	if m_ePlayerID ~= -1 then
		GameEvents.SetPlayerProperty.Call(m_ePlayerID, "SECOND_GOVERNMENT", g_kSecondGovernment)
	end

	-- Remove Events
	Events.CivicCompleted.Remove( OnCivicCompleted );
	Events.GovernmentChanged.Remove( OnGovernmentChanged );
	Events.CitySelectionChanged.Remove( DisplayExtraGovButton )
end

-- ===========================================================================
--	Game Engine Event
-- ===========================================================================
function OnCivicCompleted(player:number, civic:number, isCanceled:boolean)

	-- print("player: "..player.." civic: "..civic)

	local ePlayer:number = Game.GetLocalPlayer();
	if ePlayer == -1 or player ~= ePlayer then
		return;
	end

	if(not m_isGovernmentUnlocked) then
		local playerCulture:table = Players[ePlayer]:GetCulture();
		if (playerCulture:GetNumPoliciesUnlocked() > 0) then
			m_isGovernmentUnlocked = true;
		end
	end
end

function OnGovernmentChanged( playerID:number )
	if playerID == m_ePlayerID and m_ePlayerID ~= -1 then
		g_kCurrentGovernment = GetPlayerCurrentGovernment(m_ePlayerID)
		if ContextPtr:IsVisible() then -- Player is seeing things, we need to update immediately
            RelizeExtraGovernmentPage()
		end
		if g_kCurrentGovernment == nil and ContextPtr:IsVisible() then
			Close();
		end

	end
end

function Initialize()

	-- UI
	ContextPtr:SetInputHandler( OnInputHandler, true );
	ContextPtr:SetShutdown( OnShutdown );
    Controls.ScreenCloseButton:RegisterCallback(Mouse.eLClick, Close);
	
	local pathCityPanel = '/InGame/CityPanel/ActionStack'
    local ctrlCityPanel = ContextPtr:LookUpControl(pathCityPanel)
    if ctrlCityPanel~=nil then
        Controls.ExtraGovButton:ChangeParent(ctrlCityPanel)
        Controls.ExtraGovButton:RegisterCallback(Mouse.eLClick, OnOpenExtraGovScreen)
    end

	-- Data
	m_ePlayerID = Game.GetLocalPlayer();
	PopulateStaticData();
	InitializeData()

    -- Events
	Events.CivicCompleted.Add( OnCivicCompleted );
	Events.GovernmentChanged.Add( OnGovernmentChanged );
    Events.CitySelectionChanged.Add( DisplayExtraGovButton )

end

Events.LoadGameViewStateDone.Add( Initialize );