-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("Civ6Common");

-- Core
include("ContextBase")
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
GameEvents = ExposedMembers.GameEvents;
Utils      = ExposedMembers.TKKIK.Utils;

-- 总督 经济特区 能力名
local pSPE = "LOC_GOVERNOR_PROMOTION_SPECIAL_ECONOMIC_ZONE_NAME";
-- ===========================================================================
-- VARIABLES
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- ===========================================================================
-- UI Create
-- ===========================================================================

function DisplaySGFPbutton()

    local pCity = UI.GetHeadSelectedCity()
    if pCity == nil then
        return
    end
    local pAssignedGovernor = pCity:GetAssignedGovernor();
    local isTargetCity = (pAssignedGovernor ~= nil and IsCityHasGovernorWithProtion(pCity, pSPE) and
        Players[pCity:GetOwner()]:GetProperty("sgfpCanUse")) -- 设置一回合一次，回合刷新时恢复
    Controls.SpendGoldFinishProgressButton:SetHide(not isTargetCity)
end

-- ===========================================================================
-- UI Events
-- ===========================================================================

-- 金币换取生产力按钮功能
function OnSpendGoldFinishProgressButtonClicked()
    local pCity = UI.GetHeadSelectedCity();
    if (pCity ~= nil) then
        local bInfo = GetProductionInfoOfCity(pCity)
        if (bInfo == nil) then
            UI.AddWorldViewText(EventSubTypes.DAMAGE, Locale.Lookup("LOC_HUD_CITY_NOTHING_PRODUCED"), pCity:GetX(),
                pCity:GetY(), 0);
            return
        else
            local kParameters = {}
            kParameters.OnStart = "SpendGoldFinishProgressDXP"
            kParameters.iCityID = pCity:GetID()
            kParameters.bInfo = bInfo
            UI.RequestPlayerOperation(pCity:GetOwner(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
        end
    end

    DisplaySGFPbutton()
end

function OnShutdown()
    Events.CitySelectionChanged.Remove(DisplaySGFPbutton)
end

-- ===========================================================================
function Initialize()
    ContextPtr:SetShutdown(OnShutdown);

    local path_g2p = '/InGame/CityPanel/ActionStack'
    local ctrl_g2p = ContextPtr:LookUpControl(path_g2p)
    if ctrl_g2p ~= nil then
        -- 金币换取生产力按钮
        Controls.SpendGoldFinishProgressButton:ChangeParent(ctrl_g2p)
        Controls.SpendGoldFinishProgressButton:RegisterCallback(Mouse.eLClick, OnSpendGoldFinishProgressButtonClicked)
        Controls.SpendGoldFinishProgressButton:SetToolTipString(Locale.Lookup("LOC_ACTION_PANEL_SGFP_TOOLTIP"))
    end

    Events.CitySelectionChanged.Add(DisplaySGFPbutton)
end

Events.LoadGameViewStateDone.Add(Initialize);
