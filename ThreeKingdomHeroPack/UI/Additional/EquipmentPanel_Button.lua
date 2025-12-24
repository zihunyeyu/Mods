local m_LaunchButtonInstance = {};

function ToggleCivTraitsPopup()
    LuaEvents.EquipmentsButton_TogglePopup()
end

function AttachLaunchButton()
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("EquipmentsItem", m_LaunchButtonInstance, buttonStack);
    m_LaunchButtonInstance.EquipmentsButton:RegisterCallback(Mouse.eLClick, ToggleCivTraitsPopup);
    ContextPtr:BuildInstanceForControl("EquipmentsPinInstance", {}, buttonStack);

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

Events.LoadGameViewStateDone.Add(Initialize);
