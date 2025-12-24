local m_LaunchButtonInstance = {};

function ToggleCivTraitsPopup()
    LuaEvents.CivicTraitsButton_TogglePopup()
end

function AttachLaunchButton()
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("CivicTraitsItem", m_LaunchButtonInstance, buttonStack);
    m_LaunchButtonInstance.CivicTraitsButton:RegisterCallback(Mouse.eLClick, ToggleCivTraitsPopup);
    ContextPtr:BuildInstanceForControl("CivicTraitsPinInstance", {}, buttonStack);

    -- Resize.
    buttonStack:CalculateSize();

    local backing = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBacking");
    backing:SetSizeX(buttonStack:GetSizeX() + 116);

    local backingTile = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBackingTile");
    backingTile:SetSizeX(buttonStack:GetSizeX() - 20);

    LuaEvents.LaunchBar_Resize(buttonStack:GetSizeX());
end

function Initialize()
    AttachLaunchButton();
end

-- Events.LoadGameViewStateDone.Add(Initialize);