-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("InstanceManager");
include("Civ6Common");
include("SupportFunctions");
include("CivilizationIcon")

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
GameEvents = ExposedMembers.GameEvents;
Utils = ExposedMembers.TKKIK.Utils;

local m_IsXP1Active = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9")
local m_IsXP2Active = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68")

local OFFSET_BASE_X = 10;
local OFFSET_BASE_Y = 25;

local SIZE_ITEM_ICON = 32;

local MAX_BACKGROUND_IMAGE_WIDTH = Controls.CivTraitScroller:GetSizeX();

local SIZE_CIV_TRAIT_INFO_DIVIDER_WIDTH = 50;

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local m_ePlayerID = -1

local MajorPlayerUniqueItems = {}

-- InstanceManager
local ms_civTraitsInfoIM = InstanceManager:new("CivTraitsInfoInstance", "CivTraitsInfoContainer",
    Controls.CivTraitScroller);
local ms_uniqueIconIM = InstanceManager:new("CivTraitIconInfoInstance", "Top");
local ms_uniqueTextIM = InstanceManager:new("CivTraitTextInfoInstance", "Top");
local ms_gainTraitHeaderTextIM = InstanceManager:new("GainTraitsHeaderInstance", "Top");

-- ===========================================================================
-- FUNCTIONS    GameEvents
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS    GameData
-- ===========================================================================

-- 掠夺被击败玩家的特质 ?
function PillageTraitsFromPlayer(capturerPlayerID, defeatedPlayerID)
    local turn = Game.GetCurrentGameTurn()
    local strDate = Calendar.MakeYearStr(turn);

    -- 掠夺该玩家的特质
    for _, pPlayerID in ipairs(MajorPlayerWarInfos[defeatedPlayerID].PillagePlayers) do
        table.insert(MajorPlayerWarInfos[capturerPlayerID].PillagePlayers, pPlayerID)
    end

    table.insert(MajorPlayerWarInfos[capturerPlayerID].PillagePlayers, defeatedPlayerID)

    -- initiatingPlayerInfos
    MajorPlayerWarInfos[defeatedPlayerID] = {
        ID = defeatedPlayerID,
        Status = WAR_STATUS.DEFEATED,
        -- WarWithList     = {},
        ConqueredCities = {},
        DefeatedDate = strDate,
        DefeatedTurn = turn,
        Destroyer = capturerPlayerID,
        PillagePlayers = {}
    }

    local items = {}
    for _, pillagedPlayerID in ipairs(MajorPlayerWarInfos[capturerPlayerID].PillagePlayers) do
        items[pillagedPlayerID] = MajorPlayerUniqueItems[pillagedPlayerID]
    end

    local kParameters = {}
    kParameters.OnStart = "SetUniqueItemActive"
    kParameters.UniqueItems = items
    UI.RequestPlayerOperation(capturerPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters)

    SaveData()
end

-- 获取文明领袖唯一特质 ?
function GetUniqueData(iPlayerID)
    local playerConfig = PlayerConfigurations[iPlayerID];
    local civType = playerConfig:GetCivilizationTypeName();
    local leaderType = playerConfig:GetLeaderTypeName();

    local uniqueAbilities, uniqueUnits, leaderUniqueBuildings = GetLeaderUniqueTraits(leaderType, true);
    local CivUniqueAbilities, CivUniqueUnits, CivUniqueBuildings = GetCivilizationUniqueTraits(civType, true);

    -- Merge tables
    for i, v in ipairs(CivUniqueAbilities) do
        table.insert(uniqueAbilities, v)
    end
    for i, v in ipairs(CivUniqueUnits) do
        table.insert(uniqueUnits, v)
    end
    for i, v in ipairs(CivUniqueBuildings) do
        table.insert(leaderUniqueBuildings, v)
    end

    local uniqueBuildings = {}
    local uniqueDistricts = {}
    local uniqueImprovements = {}

    for _, ub in ipairs(leaderUniqueBuildings) do
        for district in GameInfo.Districts() do
            if district.DistrictType == ub.Type then
                table.insert(uniqueDistricts, ub)
                break
            end
        end
        for improvement in GameInfo.Improvements() do
            if improvement.ImprovementType == ub.Type then
                table.insert(uniqueImprovements, ub)
                break
            end
        end
        for building in GameInfo.Buildings() do
            if building.BuildingType == ub.Type then
                table.insert(uniqueBuildings, ub)
                break
            end
        end
    end

    return uniqueAbilities, uniqueUnits, uniqueBuildings, uniqueDistricts, uniqueImprovements
end

function PopulateData()
    for _, playerID in ipairs(Utils.GetMajorIDs()) do
        -- get unique items

        local uniqueAbilities, uniqueUnits, uniqueBuildings, uniqueDistricts, uniqueImprovements = GetUniqueData(
            playerID)

        MajorPlayerUniqueItems[playerID] = {
            Abilities = uniqueAbilities,
            Units = uniqueUnits,
            Buildings = uniqueBuildings,
            Districts = uniqueDistricts,
            Improvements = uniqueImprovements
        }
    end
end

-- ===========================================================================
-- FUNCTIONS	UI
-- ===========================================================================

function PopulateItem(rootControl, items)
    for _, item in ipairs(items.Abilities) do
        if item.Name and item.Name ~= "NONE" then
            local instance = ms_uniqueTextIM:GetInstance(rootControl.FeaturesStack);
            instance.Header:SetText(Locale.ToUpper(Locale.Lookup(item.Name)));
            instance.Description:SetText(Locale.Lookup(item.Description));
        end
    end

    for _, item in ipairs(items.Units) do
        local instance = ms_uniqueIconIM:GetInstance(rootControl.FeaturesStack);
        instance.Icon:SetIcon("ICON_" .. item.Type);
        instance.TextStack:SetOffsetX(SIZE_ITEM_ICON + 4);
        instance.Header:SetText(Locale.ToUpper(Locale.Lookup(item.Name)));
        instance.Description:SetText(Locale.Lookup(item.Description));
    end

    -- for _, item in ipairs(items.Districts) do
    --     local instance = ms_uniqueIconIM:GetInstance(rootControl.FeaturesStack);
    --     instance.Icon:SetSizeVal(38, 38);
    --     instance.Icon:SetIcon("ICON_" .. item.Type);
    --     instance.TextStack:SetOffsetX(SIZE_ITEM_ICON + 4);
    --     instance.Header:SetText(Locale.ToUpper(Locale.Lookup(item.Name)));
    --     instance.Description:SetText(Locale.Lookup(item.Description));
    -- end

    for _, item in ipairs(items.Buildings) do
        local instance = ms_uniqueIconIM:GetInstance(rootControl.FeaturesStack);
        instance.Icon:SetSizeVal(38, 38);
        instance.Icon:SetIcon("ICON_" .. item.Type);
        instance.TextStack:SetOffsetX(SIZE_ITEM_ICON + 4);
        instance.Header:SetText(Locale.ToUpper(Locale.Lookup(item.Name)));
        instance.Description:SetText(Locale.Lookup(item.Description));
    end

    for _, item in ipairs(items.Improvements) do
        local instance = ms_uniqueIconIM:GetInstance(rootControl.FeaturesStack);
        instance.Icon:SetSizeVal(38, 38);
        instance.Icon:SetIcon("ICON_" .. item.Type);
        instance.TextStack:SetOffsetX(SIZE_ITEM_ICON + 4);
        instance.Header:SetText(Locale.ToUpper(Locale.Lookup(item.Name)));
        instance.Description:SetText(Locale.Lookup(item.Description));
    end
end

function PopulateLeaderPanelHeader(rootControl, iPlayerID)
    if (Players[iPlayerID] ~= nil) then
        local pPlayerDiplomacy = Players[m_ePlayerID]:GetDiplomacy()

        local playerConfig = PlayerConfigurations[iPlayerID] -- :GetCivilizationShortDescription()
        if (playerConfig ~= nil) then
            if pPlayerDiplomacy:HasMet(iPlayerID) or m_ePlayerID == iPlayerID then
                -- Set the civ icon
                local civIconController = CivilizationIcon:AttachInstance(rootControl.CivIcon);
                civIconController:UpdateIconFromPlayerID(iPlayerID);
                -- Set the leader name
                local leaderDesc = playerConfig:GetLeaderName();
                rootControl.PlayerNameText:LocalizeAndSetText(Locale.ToUpper(Locale.Lookup(leaderDesc)));
                rootControl.CivNameText:LocalizeAndSetText(Locale.ToUpper(Locale.Lookup(
                    playerConfig:GetCivilizationDescription())));
            end

            -- if pPlayerDiplomacy:HasMet(iPlayerID) or m_ePlayerID == iPlayerID then
            --     rootControl.RecruitedImage:SetIcon(iconName, 55)
            --     rootControl.RecruitedImage:SetHide(false)
            --     rootControl.YouIndicator:SetHide(true)
            -- else
            --     rootControl.RecruitedImage:SetIcon("ICON_CIVILIZATION_UNKNOWN", 55)
            --     rootControl.RecruitedImage:SetHide(false)
            --     rootControl.YouIndicator:SetHide(true)
            -- end
        end
    end
end

function RelizeMainPanel()
    ms_uniqueIconIM:ResetInstances();
    ms_uniqueTextIM:ResetInstances();
    ms_gainTraitHeaderTextIM:ResetInstances()

    local offsetX = OFFSET_BASE_X

    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local tInfoInstance = ms_civTraitsInfoIM:GetInstance()

        PopulateLeaderPanelHeader(tInfoInstance, playerID)
        PopulateItem(tInfoInstance, MajorPlayerUniqueItems[playerID])

        tInfoInstance.CivTraitsInfoContainer:SetOffsetVal(offsetX, OFFSET_BASE_Y)
        offsetX = offsetX + tInfoInstance.CivTraitsInfoContainer:GetSizeX() + SIZE_CIV_TRAIT_INFO_DIVIDER_WIDTH
    end

    Controls.CivTraitBackground:SetSizeX(math.max(MAX_BACKGROUND_IMAGE_WIDTH,
        offsetX - SIZE_CIV_TRAIT_INFO_DIVIDER_WIDTH + 10));
    Controls.CivTraitScroller:CalculateSize();
end

-- ===================================================================
--	FUNCTIONS	UI  Open and Close
-- ===========================================================================
function OnInit(isReload)
    LateInitialize()
end

function LateInitialize()
    ms_civTraitsInfoIM:ResetInstances()
    Controls.ScreenCloseButton:RegisterCallback(Mouse.eLClick, Close)

end

function CloseOtherPanels()
    LuaEvents.LaunchBar_CloseTechTree()
    LuaEvents.LaunchBar_CloseCivicsTree()
    LuaEvents.LaunchBar_CloseGovernmentPanel()
    LuaEvents.LaunchBar_CloseReligionPanel()
    LuaEvents.LaunchBar_CloseGreatPeoplePopup()
    LuaEvents.LaunchBar_CloseGreatWorksOverview()
    if m_IsXP1Active then
        LuaEvents.GovernorPanel_Close()
        LuaEvents.HistoricMoments_Close()
    end
    if m_IsXP2Active then
        LuaEvents.Launchbar_Expansion2_ClimateScreen_Close()
    end
end

function OpenMainPanel()
    RelizeMainPanel()
    CloseOtherPanels()

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

function Close()
    if ContextPtr:IsHidden() then
        return
    else
        UI.PlaySound("UI_Screen_Close");
    end
    UIManager:DequeuePopup(ContextPtr);
end

-- ===================================================================
--	FUNCTIONS	UI  InputEvent Handler
-- ===================================================================

function OnInputHandler(pInputStruct)
    if (pInputStruct:GetMessageType() == KeyEvents.KeyUp) then
        local key = pInputStruct:GetKey()
        if (key == Keys.VK_ESCAPE) then
            Close()
            return true
        end
    end
    return false
end

function OnShutdown()
    LuaEvents.CivicTraitsButton_TogglePopup.Remove(OnTogglePanel);
end

-- ===========================================================================
--	FUNCTIONS	UI  EVENTS
-- ===========================================================================

function OnTogglePanel()
    if ContextPtr:IsHidden() then
        OpenMainPanel()
    else
        Close()
    end
end

-- ===========================================================================
--	FUNCTIONS	POPUP  EVENTS
-- ===========================================================================

function OnBuildingAddedToMap(X, Y, buildingID, playerID, cityID, percentComplete, isPillaged)
    print('OnBuildingAddedToMap', X, Y, buildingID, playerID, cityID, percentComplete, isPillaged)
    local buildingInfo = GameInfo.Buildings[buildingID]
    local buildingType = buildingInfo.BuildingType
    if string.match(buildingType, 'BUILDING_SWITCH_') then
        local switchDistrict = string.gsub(buildingType, 'BUILDING_SWITCH_', '')
        local districtIndex = GameInfo.Districts[switchDistrict].Index
        Utils.CreateDistrict(playerID, cityID, districtIndex, 100, Map.GetPlot(X, Y):GetIndex())
        print('ReplaceDistrict = ', switchDistrict)

    end
end

-- ===========================================================================
function Initialize()

    ContextPtr:SetInitHandler(OnInit)
    ContextPtr:SetInputHandler(OnInputHandler, true)
    ContextPtr:SetShutdown(OnShutdown)

    m_ePlayerID = Game.GetLocalPlayer();
    PopulateData()
    LuaEvents.CivicTraitsButton_TogglePopup.Add(OnTogglePanel);

end

Initialize()
