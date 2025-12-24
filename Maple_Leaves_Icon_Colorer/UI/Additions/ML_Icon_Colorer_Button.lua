-- ML_Icon_Colorer_Button
-- Author: yiboy
-- DateCreated: 9/15/2024 12:20:53 PM
--------------------------------------------------------------
--=======================================================================================
-- CONSTANTS
--=======================================================================================

--=======================================================================================


local m_LaunchButtonInstance_IC = {};
-- ===========================================================================
function TogglePopup_IconColorer()
	print("toggle 1")
	LuaEvents.ML_IconColorer_Button_TogglePopup()
	print("toggle 2")
end
-- ===========================================================================
function AttachLaunchButton_IconColorer()
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("ML_IconColorer_Item", m_LaunchButtonInstance_IC, buttonStack);
    m_LaunchButtonInstance_IC.ML_IconColorer_Button:RegisterCallback(Mouse.eLClick, TogglePopup_IconColorer);
    --m_LaunchButtonInstance_IC.ML_IconColorer_Icon:SetTexture(IconManager:FindIconAtlas("ICON_NOTIFICATION_WONDER_COMPLETED", 40));
	--m_LaunchButtonInstance_IC.ML_IconColorer_Icon:SetTexture("DetailedWonderReminder.dds");
    ContextPtr:BuildInstanceForControl("ML_IconColorer_PinInstance", {}, buttonStack);

    -- Resize.
    buttonStack:CalculateSize();

    local backing = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBacking");
    backing:SetSizeX(buttonStack:GetSizeX() + 116);

    local backingTile = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBackingTile");
    backingTile:SetSizeX(buttonStack:GetSizeX() - 20);

    LuaEvents.LaunchBar_Resize(buttonStack:GetSizeX());

	--…Ë÷√Õº±Í
	m_LaunchButtonInstance_IC.ML_IconColorer_Icon:SetIcon("ICON_" .. "CIVILIZATION_EGYPT");
end
-- ===========================================================================
function OnLoadGameViewStateDone_IconColorer()
	AttachLaunchButton_IconColorer();

end
-- ===========================================================================
function Initialize_IconColorer()
    Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone_IconColorer);
end

Initialize_IconColorer();
-- ===========================================================================
print("Maple_Leaves Icon Colorer UI Button Initialized!")