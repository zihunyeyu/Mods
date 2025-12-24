-- Copyright 2017-2018, Firaxis Games
-- This file is being included into the base NotificationPanel file using the wildcard include setup in NotificationPanel.lua
-- Refer to the bottom of NotificationPanel.lua to see how that's happening
-- DO NOT include any NotificationPanel files here or it will cause problems
-- include("NotificationPanel")
local TKH_RegisterHandlers = RegisterHandlers;
local TKH_OnDefaultAddNotification = OnDefaultAddNotification;

-- ===========================================================================
function OnDefaultAddNotification(pNotification)
    TKH_OnDefaultAddNotification(pNotification);

    local notificationID = pNotification:GetID();
    local playerID = Game.GetLocalPlayer();
    local notificationEntry = GetNotificationEntry(playerID, notificationID);
    local turnNumber = Game.GetCurrentGameTurn()

    if (notificationEntry.m_Instance ~= nil) then
        if (notificationEntry.m_TypeName == "NOTIFICATION_EQUIPMENT_CREATED") then
            notificationEntry.m_Instance.Icon:SetIcon("ICON_NOTIFICATION_EQUIPMENT_CREATED");
        end
    end
end

function OnNOTIFICATION_EQUIPMENT_CREATEDActivate(notificationEntry)
    if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
        LuaEvents.EquipmentsButton_TogglePopup()
    end
end

-- ===========================================================================
-- BASE FUNCTION REPLACEMENTS
-- ===========================================================================
function RegisterHandlers()
    TKH_RegisterHandlers();
    local m_Notification = DB.MakeHash("NOTIFICATION_EQUIPMENT_CREATED")
    g_notificationHandlers[m_Notification] = MakeDefaultHandlers(); -- DEBUG
    g_notificationHandlers[m_Notification].Activate = OnNOTIFICATION_EQUIPMENT_CREATEDActivate;
    g_notificationHandlers[m_Notification].AddSound = "ALERT_POSITIVE"

end
