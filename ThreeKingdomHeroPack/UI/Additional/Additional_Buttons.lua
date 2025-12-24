-- Additional_Buttons
-- Author: PurpleSoul
-- DateCreated: 5/11/2025 2:20:21 PM
--------------------------------------------------------------
include("PopupDialog")
include('TKH_Constant')


--- 刷新城市Delete按钮，需求 城墙城市满生命值&&非英雄出生城市
function DeleteCity_Refresh()
    local selectedCity = UI.GetHeadSelectedCity()
    if not selectedCity then
        return
    end

    local districts = selectedCity:GetDistricts()
    local center = districts:GetDistrict(DISTRICT_CITY_CENTER_INDEX)
    local currentWallDamage = center:GetDamage(DefenseTypes.DISTRICT_OUTER)
    local currentDistrictDamage = center:GetDamage(DefenseTypes.DISTRICT_GARRISON)
    local isFullHealth = (currentWallDamage == 0 and currentDistrictDamage == 0)
    -- local isOriginalOwner = (selectedCity:GetOriginalOwner() == selectedCity:GetOwner())
    local isHeroCreatedCity = false

    local pGameHeroes = Game.GetHeroesManager()
    local m_HeroManager = Game:GetProperty('HeroManager') or {}
    for heroClassIndex, hero in pairs(m_HeroManager) do
        local hCity = pGameHeroes:GetHeroOriginCityID(heroClassIndex)
        if hero.Owner == selectedCity:GetOwner() then
            if hCity.id == selectedCity:GetID() then
                isHeroCreatedCity = true
                break
            end
        end
    end
    Controls.DeleteCityGrid:SetHide(not isFullHealth or isHeroCreatedCity or selectedCity:IsCapital())
end

function DeleteCity_OnButtonClicked()
    local selectedCity = UI.GetHeadSelectedCity()
    if not selectedCity then
        return
    end
    local popup = PopupDialogInGame:new("ConfirmDeleteCity")
    popup:AddText(Locale.Lookup("LOC_CONFIRM_DELETE_CITY_EXCHANGE_GOLD", Locale.Lookup(selectedCity:GetName()),
        DELETE_CITY_EXCHANGE))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES, function()
        local kParameters = {}
        kParameters.OnStart = "OnDeleteCityButtonClicked"
        kParameters.CityID = selectedCity:GetID()
        UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
    end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO, function()
        -- Nothing happened..
    end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

-- ===========================================================================
function Initialize()
    if GameConfiguration.GetValue("LUXURY_TAX_MODE_CITY") then
        local pContext = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
        if pContext ~= nil then
            Controls.DeleteCityGrid:ChangeParent(pContext)
            Controls.DeleteCityButton:RegisterCallback(Mouse.eLClick, DeleteCity_OnButtonClicked)
        end
        Controls.DeleteCityButton:SetToolTipString(Locale.Lookup('LOC_DELETE_CITY_FOR_GOLD_TOOLTIP', DELETE_CITY_EXCHANGE))


        Events.CitySelectionChanged.Add(function(playerID, unitID, hexI, hexJ, hexK, isSelected, IsEditable)
            if playerID == Game.GetLocalPlayer() then
                DeleteCity_Refresh()
            end
        end)
    end
end

Events.LoadGameViewStateDone.Add(Initialize)
