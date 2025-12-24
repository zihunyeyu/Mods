-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("InstanceManager")
include("Civ6Common")
include("SupportFunctions")
include("TabSupport")
include("UnitSupport");
include("CivilizationIcon")
include("HeroesSupport")
include("PopupDialog")

include('TKH_Constant')
include('TKH_Helper')

-- ===========================================================================
--	DEBUG
-- ===========================================================================
print('Load EquipmentPanel.lua')

local EQUIPMENT_DEBUG_MODE = GameConfiguration.GetValue("EQUIPMENT_DEBUG_MODE")
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
local m_IsXP1Active = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9")
local m_IsXP2Active = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68")

-- ===========================================================================
--	VARIABLES
-- ===========================================================================

local LateInitialize_TKH


local m_EquipmentManager = {}
local m_HeroEquipmentManager = {}
local m_EquipmentSuitManager = {}

local m_EquipmentAllocator = {}
local m_HeroRewardManager = {}
local m_EquipmentRewardManager = {}


-- UI
local m_panelParams = {

}
local function _getSelectedHeroUnitType()
    return m_panelParams['SelectedHero']
end

local left_total_kp

HeroEquipmentsCon = {}
HeroEquipmentsCon.EQUIPMENT_WEAPON = {
    Button = Controls.TakeOffButton_WEAPON,
    EquipmentPortrait = Controls.EquipmentPortrait_WEAPON
}
HeroEquipmentsCon.EQUIPMENT_ARMOR = {
    Button = Controls.TakeOffButton_ARMOR,
    EquipmentPortrait = Controls.EquipmentPortrait_ARMOR
}
HeroEquipmentsCon.EQUIPMENT_MOUNT = {
    Button = Controls.TakeOffButton_MOUNT,
    EquipmentPortrait = Controls.EquipmentPortrait_MOUNT
}
HeroEquipmentsCon.EQUIPMENT_ARTIFACT = {
    Button = Controls.TakeOffButton_ARTIFACT,
    EquipmentPortrait = Controls.EquipmentPortrait_ARTIFACT
}

local m_tabs
local m_shopTabs
local m_selectedTabName = 'Weapon'
local m_selectedPanelName = 'Library'
local m_refresh = false

local m_handbookTabs
local m_kGlobalPieSlices = {}
local m_kHandbookEquipments = {}
local m_kShopkquipments = {}

local m_EquipmentInstanceList = {}
local ms_HeroInstanceList = {}

-- InstanceManager
local ms_HeroIM = InstanceManager:new("HeroInstance", "Top", Controls.HeroScrollPanelStack)

local ms_EquipmentIM = InstanceManager:new("LibraryEquipmentInstance", "LibraryContent")

local ms_ShopEquipmentIM = InstanceManager:new("ShopEquipmentInstance", "ShopContent", Controls.ShopStack)
local ms_HandbookEquipmentIM = InstanceManager:new("HandbookEquipmentInstance", "HandbookContent", Controls
    .HandbookStack)
local m_kSliceIM = InstanceManager:new("PieChartSliceInstance", "Slice")
local m_kCivEquipmentIM = InstanceManager:new("CivEquipmentInstance", "Top", Controls.GlobalCityStack)

local m_pHeroPanelIM = InstanceManager:new("HeroPanelInstance", "Content", Controls.HeroStack);
local m_pStatIM = InstanceManager:new("StatInstance", "Top");
local m_pAbilityIM = InstanceManager:new("AbilityInstance", "Top");
local m_pExtrsAbilityIM = InstanceManager:new("ExtraAbilityInstance", "Top");
local m_pCommandIM = InstanceManager:new("CommandInstance", "Top");
local m_pEquipmentIM = InstanceManager:new("HeroEquipmentInstance", "Top");
local m_pUpgradeIM = InstanceManager:new("HeroUpgradeInstance", "Top");




local m_filterList
local m_filterSelected = 1
local m_filterSelectedName = "LOC_ROUTECHOOSER_FILTER_ALL"

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

--- 获取装备描述
--- @param e string 装备类型
--- @return string 装备描述
function GetEquiomentDescription(e)
    local equipment = GameInfo.Equipments[e]
    if not equipment then
        return ''
    end
    local equipmentName = Locale.Lookup(equipment.Name)
    local equipmentDescription = string.gsub(Locale.Lookup(equipment.Description), equipmentName .. '：', '')
    local armorValue = equipment.Parameter1
    if armorValue and armorValue ~= 0 then
        equipmentDescription = equipmentDescription .. '[NEWLINE]护甲值：' .. armorValue
    end

    return equipmentDescription
end

-- ===========================================================================
-- FUNCTIONS    GameEvents
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS    GameData
-- ===========================================================================

function ChangePlayerBalance(value, reason)
    local params = {}
    params.OnStart = "ChangePlayerBalance"
    params.Value = value
    params.Reason = reason
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, params)
end

function ChangeEquipmentData(e, data)
    local params = {}
    params.OnStart = 'ChangeEquipmentData'
    params.Equipment = e
    params.Data = data
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, params)
    RefreshAllPane()
end

function ChangeHeroKillPoint(heroUnitType, key, value)
    local params = {}
    params.OnStart = 'ChangeHeroKillPoint'
    params.HeroUnitType = heroUnitType
    params.UpgradeType = key
    params.ChangeValue = value
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, params)
end

-- ===========================================================================
-- FUNCTIONS UI↔️Gameplay
-- ===========================================================================

--- 改变英雄单位装备状态
---@param e string
---@param hIndex number
function ChangeEquipmentHero(e, hIndex)
    local playerID = Game.GetLocalPlayer()
    local equipment = m_EquipmentManager[e]
    if not equipment or equipment.Owner ~= playerID then
        return
    end
    local params = {}
    params.OnStart = 'ChangeEquipmentHero'
    params.HeroClass = hIndex
    params.Equipment = e
    UI.RequestPlayerOperation(playerID, PlayerOperations.EXECUTE_SCRIPT, params)
end

-- ===========================================================================
-- FUNCTIONS    UI    PlayerActions Button Popup Windows
-- ===========================================================================

-- 确认装备到英雄身上
function ConfirmPutOnEquipment(e, hIndex)
    local popup = PopupDialogInGame:new("ConfirmPutOnEquipment")
    local equipment = m_EquipmentManager[e]
    popup:AddText(Locale.Lookup("LOC_CONFIRM_PUT_ON_EQUIPMENT", Locale.Lookup(equipment.Name),
        Locale.Lookup('LOC_' .. GameInfo.HeroClasses[hIndex].UnitType .. '_NAME')))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES,
        function()
            ChangeEquipmentHero(e, hIndex)
        end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO,
        function()
        end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

--- 确认卸下英雄身上的装备
---@param e string
function ConfirmTakeOffEquipment(e)
    local popup = PopupDialogInGame:new("ConfirmTakeOffEquipment")
    local equipment = m_EquipmentManager[e]

    popup:AddText(Locale.Lookup("LOC_CONFIRM_TAKE_OFF_EQUIPMENT", TAKE_OFF_COST, Locale.Lookup(equipment.Name)))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES,
        function()
            ChangePlayerBalance(-TAKE_OFF_COST, CHANGE_PLAYER_BALANCE_REASON.TAKE_OFF_EQUIPMENT)
            ChangeEquipmentHero(e, -1)
        end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO,
        function()
        end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

--- 确认锁定装备
---@param e string
---@param eTypeIndex number
function ConfirmLockEquipment(e, eTypeIndex)
    local popup = PopupDialogInGame:new("ConfirmLockEquipment")
    local equipment = m_EquipmentManager[e]
    if _getSelectedHeroUnitType() == nil then
        return
    end

    popup:AddText(Locale.Lookup("LOC_CONFIRM_LOCK_EQUIPMENT", Locale.Lookup(equipment.Name),
        Locale.Lookup('LOC_' .. _getSelectedHeroUnitType() .. '_NAME')))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES,
        function()
            equipment.Locked = not equipment.Locked
            Controls['LockStatus' .. eTypeIndex]:SetIcon(equipment.Locked and 'ICON_EQUIPMENT_LOCK' or
                'ICON_EQUIPMENT_UNLOCK')
            ChangeEquipmentData(e, equipment)
        end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO,
        function()
        end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

--- 仓库中点击装备时
---@param e string
function ClickEquipment(e)
    if _getSelectedHeroUnitType() == nil then
        return
    end

    local equipment = m_EquipmentManager[e]
    local eHeroClassIndex = equipment.HeroClassIndex
    local heroEquipments = m_HeroEquipmentManager[_getSelectedHeroUnitType()]

    -- 装备没有拥有者时
    if heroEquipments and eHeroClassIndex == -1 and heroEquipments[equipment.EquipmentType] == nil then
        ConfirmPutOnEquipment(e, heroEquipments.HeroClass)
    end
end

--- 售出装备弹窗
---@param e string
function SellEquipment(e)
    local popup = PopupDialogInGame:new("SellEquipment")
    local equipment = m_EquipmentManager[e]
    popup:AddText(Locale.Lookup("LOC_CONFIRM_SELL_EQUIPMENT", Locale.Lookup(equipment.Name), EQUIPMENT_SOLD_PRICE))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES, function()
        equipment.Owner = -1
        equipment.HeroClassIndex = -1
        equipment.oTurn = 0
        equipment.hTurn = 0
        equipment.RewardType = -1
        equipment.GetTurn = -1
        equipment.Locked = false
        equipment.Sold = true

        ChangePlayerBalance(EQUIPMENT_SOLD_PRICE, CHANGE_PLAYER_BALANCE_REASON.SELL_EQUIPMENT)
        ChangeEquipmentData(e, equipment)
    end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO, function()
    end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

--- 购买装备弹窗
---@param e string
function BuyEquipment(e)
    local equipment = m_EquipmentManager[e]
    local popup = PopupDialogInGame:new("BuyEquipment")
    popup:AddText(Locale.Lookup("LOC_CONFIRM_BUY_EQUIPMENT", equipment.Price, Locale.Lookup(equipment.Name)))
    popup:AddConfirmButton(TXT_CONFIRM_POPUP_YES, function()
        equipment.Owner = Game.GetLocalPlayer()
        equipment.Sold = false
        ChangePlayerBalance(-equipment.Price, CHANGE_PLAYER_BALANCE_REASON.BUY_EQUIPMENT)
        ChangeEquipmentData(e, equipment)
    end)
    popup:AddCancelButton(TXT_CONFIRM_POPUP_NO, function()
    end)
    popup:Open()
    UI.PlaySound("UI_Policies_Click_Government")
end

-- ===========================================================================
-- FUNCTIONS	UI
-- ===========================================================================

function LookAtUnit(pUnit)
    Close()
    UI.LookAtPlotScreenPosition(pUnit:GetX(), pUnit:GetY(), 0.5, 0.5)
    UI.SelectUnit(pUnit)
end

function OpenCivilopediaForHero(sHeroUnitType)
    Close()
    LuaEvents.OpenCivilopedia(sHeroUnitType)
end

-- 重置已选择英雄栏
function PopulateSelectedHero()
    if _getSelectedHeroUnitType() ~= nil and m_HeroEquipmentManager[_getSelectedHeroUnitType()] ~= nil then
        Controls.HeroEquipmentCon:SetHide(false)
        local heroEquipment = m_HeroEquipmentManager[_getSelectedHeroUnitType()]
        m_pHeroPanelIM:ResetInstances()
        local kHeroInstance = m_pHeroPanelIM:GetInstance();
        m_pStatIM:ResetInstances()
        m_pAbilityIM:ResetInstances()
        m_pExtrsAbilityIM:ResetInstances()
        m_pCommandIM:ResetInstances()
        m_pEquipmentIM:ResetInstances()
        m_pUpgradeIM:ResetInstances()


        local kHeroDef = GameInfo.HeroClasses[heroEquipment.HeroClassType]
        local hUnit = UnitManager.GetUnit(heroEquipment.Owner, heroEquipment.UnitID)
        local kStats = GetHeroUnitStats(kHeroDef.Index);
        if kStats.Lifespan ~= nil then
            local pLifespanInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pLifespanInst.StatIcon:SetIcon("ICON_LIFESPAN");
            pLifespanInst.ValueText:SetText(kStats.Lifespan);
            if kStats.Lifespan == 0 then
                pLifespanInst.ValueText:SetText('~');
            end
            pLifespanInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_LIFESPAN"));
        end

        if kStats.BaseMoves ~= nil and kStats.BaseMoves > 0 then
            local pCombatInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pCombatInst.StatIcon:SetIcon("ICON_MOVES");
            pCombatInst.ValueText:SetText(kStats.BaseMoves);
            pCombatInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_MOVEMENT"));
        end

        if kStats.Combat ~= nil and kStats.Combat > 0 then
            local pCombatInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pCombatInst.StatIcon:SetIcon("ICON_STRENGTH");
            pCombatInst.ValueText:SetText(kStats.Combat);
            pCombatInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_STRENGTH"));
        end

        if kStats.RangedCombat ~= nil and kStats.RangedCombat > 0 then
            local pRangedCombatInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pRangedCombatInst.StatIcon:SetIcon("ICON_RANGED_STRENGTH");
            pRangedCombatInst.ValueText:SetText(kStats.RangedCombat);
            pRangedCombatInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_RANGED_STRENGTH"));
        end

        if kStats.Range ~= nil and kStats.Range > 0 then
            local pRangedCombatInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pRangedCombatInst.StatIcon:SetIcon("ICON_RANGE");
            pRangedCombatInst.ValueText:SetText(kStats.Range);
            pRangedCombatInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_ATTACK_RANGE"));
        end

        if kStats.Charges ~= nil and kStats.Charges > 0 then
            local pChargesInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
            pChargesInst.StatIcon:SetIcon("ICON_STATS_SPREADCHARGES");
            pChargesInst.ValueText:SetText(kStats.Charges);
            pChargesInst.NameText:SetText(Locale.Lookup("LOC_HUD_UNIT_PANEL_CHARGES"));
        end

        -- -- Abilities
        local kAbilities = GetHeroClassUnitAbilities(kHeroDef.Index);
        for _, kAbility in pairs(kAbilities) do
            local pAbilityInst = m_pAbilityIM:GetInstance(kHeroInstance.EffectStack);
            pAbilityInst.AbilityName:SetText(Locale.ToUpper(kAbility.Name));
            pAbilityInst.AbilityText:SetText(Locale.Lookup(kAbility.Description));
        end

        local unitAbility = hUnit:GetAbility():GetAbilities()
        if (unitAbility ~= nil) then
            for i, ability in ipairs(unitAbility) do
                local sDesc = GetUnitAbilityDescription(ability);
                if (sDesc ~= nil and sDesc ~= "") then
                    local abilityText = "[ICON_Bullet] " .. Locale.Lookup(sDesc)
                    local pAbilityInst = m_pExtrsAbilityIM:GetInstance(kHeroInstance.ExtraEffectStack);
                    pAbilityInst.AbilityText:SetString(abilityText)
                end
            end
        end

        -- -- Commands
        local kCommands = GetHeroClassUnitCommands(kHeroDef.Index);
        for _, kCommand in pairs(kCommands) do
            local pCommandInst = m_pCommandIM:GetInstance(kHeroInstance.EffectStack);
            pCommandInst.CommandName:SetText(Locale.ToUpper(kCommand.Name));
            pCommandInst.CommandText:SetText(Locale.Lookup(kCommand.Description));
            pCommandInst.CommandIcon:SetIcon(kCommand.Icon);
        end

        local suitAmount = {}
        local eInstans = {}
        for row in GameInfo.EquipmentTypes() do
            local pEquipmentInst = m_pEquipmentIM:GetInstance(kHeroInstance.HeroEquipmentStack)
            eInstans[row.EquipmentType] = pEquipmentInst
            pEquipmentInst.EquipmentTypeIcon:SetIcon('ICON_' .. row.EquipmentType)

            local e
            local equipment
            e = heroEquipment[row.EquipmentType]
            if e and m_EquipmentManager[e] then
                equipment = m_EquipmentManager[e]
                pEquipmentInst.EquipmentName:SetString(Locale.Lookup(equipment.Name))
                pEquipmentInst.EquipmentButton:SetDisabled(false)

                pEquipmentInst.EquipmentButton:RegisterCallback(Mouse.eMouseEnter, function()
                    pEquipmentInst.EquipmentBox:SetColorByName('CityStateDisabledCS')
                end)
                pEquipmentInst.EquipmentButton:RegisterCallback(Mouse.eMouseExit, function()
                    pEquipmentInst.EquipmentBox:SetColor(UI.GetColorValue(169, 169, 169, 0))
                end)
                pEquipmentInst.EquipmentButton:RegisterCallback(Mouse.eLClick, function()
                    if Players[Game.GetLocalPlayer()]:GetTreasury():GetGoldBalance() >= TAKE_OFF_COST then
                        ConfirmTakeOffEquipment(e)
                    end
                end)
                if equipment.EquipmentType == 'EQUIPMENT_ARMOR' then
                    pEquipmentInst.EquipmentName:SetColorByName('ResFoodLabelCS')
                elseif equipment.EquipmentType == 'EQUIPMENT_MOUNT' then
                    pEquipmentInst.EquipmentName:SetColorByName('ResTourismLabelCS')
                elseif equipment.EquipmentType == 'EQUIPMENT_ARTIFACT' then
                    pEquipmentInst.EquipmentName:SetColorByName('ResFaithLabelCS')
                else
                    pEquipmentInst.EquipmentName:SetColorByName('ResScienceLabelCS')
                end
            else
                pEquipmentInst.EquipmentName:SetString('-')
                pEquipmentInst.EquipmentName:SetColorByName('TradeOverviewTextCS')
                pEquipmentInst.EquipmentButton:SetDisabled(true)
            end
        end

        -- 升级模块
        left_total_kp = hUnit:GetProperty("TKH_HERO_KILL_POINT") or 0
        kHeroInstance.HeroTotalKPLabel:SetString(Locale.Lookup("LOC_HERO_LEFT_TOTAL_KILL_POINT", left_total_kp))

        for row in GameInfo.TKH_HeroKillPointSkill() do
            local upgradeInfo = heroEquipment.PT[row.Name]
            if upgradeInfo then
                local pUpgradeInst = m_pUpgradeIM:GetInstance(kHeroInstance.HeroUpgradeStack)
                -- 显示数值
                local uvalue = math.floor(upgradeInfo.Value / row.Rate) * row.Base
                local str = Locale.Lookup(row.Description,
                    string.format("%d / %d", uvalue, row.Max * row.Base))
                if row.Rate > 1 and uvalue < row.Max then
                    local costedKP = upgradeInfo.Value % row.Rate
                    str = str .. string.format("( %d/%d)", costedKP, row.Rate)
                end
                pUpgradeInst.UpgradeDescription:SetString(str)
                if uvalue >= row.Max * row.Base then
                    pUpgradeInst.AddValueButton:SetDisabled(true)
                    pUpgradeInst.AddValueButton:SetToolTipString(Locale.Lookup("LOC_HERO_UPGRADE_MAX_TOOLTIP"))
                else
                    pUpgradeInst.AddValueButton:SetDisabled(false)
                    pUpgradeInst.AddValueButton:SetToolTipString(Locale.Lookup("LOC_ADD_VALUE_FOR_THIS_UPGRADE"))
                end
                pUpgradeInst.AddValueButton:RegisterCallback(Mouse.eLClick, function()
                    local function _changeUpgradeValue(_value, test)
                        uvalue = math.floor((upgradeInfo.Value + _value) / row.Rate) * row.Base
                        str = Locale.Lookup(row.Description,
                            string.format("%d / %d", uvalue, row.Max * row.Base))
                        if row.Rate > 1 then
                            local costedKP = upgradeInfo.Value % row.Rate
                            str = str .. string.format("( %d/%d)", costedKP + _value, row.Rate)
                        end
                        pUpgradeInst.UpgradeDescription:SetString(str)
                        ChangeHeroKillPoint(_getSelectedHeroUnitType(), row.Name, _value)
                        if not test then
                            left_total_kp = left_total_kp - _value
                        end
                        kHeroInstance.HeroTotalKPLabel:SetString(Locale.Lookup("LOC_HERO_LEFT_TOTAL_KILL_POINT",
                            left_total_kp))
                    end

                    if left_total_kp > 0 then
                        _changeUpgradeValue(1)
                    end

                    if EQUIPMENT_DEBUG_MODE then
                        _changeUpgradeValue(5, true)
                    end

                    -- PopulateSelectedHero()
                end)
            end
        end
    else
        m_pHeroPanelIM:ResetInstances()
        m_pStatIM:ResetInstances()
        m_pAbilityIM:ResetInstances()
        m_pExtrsAbilityIM:ResetInstances()
        m_pCommandIM:ResetInstances()
        m_pEquipmentIM:ResetInstances()
        m_pUpgradeIM:ResetInstances()
        Controls.HeroEquipmentCon:SetHide(true)
    end
end

function PopulateHero(hUnitType)
    local heroEquipments = m_HeroEquipmentManager[hUnitType]
    if not heroEquipments then
        return
    end

    local instance = ms_HeroIM:GetInstance()
    instance.Portrait:SetIcon(ICON .. heroEquipments.HeroClassType .. PORTRAIT)
    instance.Name:SetString(Locale.Lookup('LOC_' .. hUnitType .. '_NAME'))
    if hUnitType ~= m_panelParams['SelectedHero'] then
        instance.Name:SetColorByName('TopBarLabelCS')
    else
        instance.Name:SetColorByName('TutorialCS')
    end
    instance.HeroChangeButton:RegisterCallback(Mouse.eLClick, function()
        m_panelParams['SelectedHero'] = hUnitType
        instance.Name:SetColorByName('TutorialCS')
        for uType, _instance in pairs(ms_HeroInstanceList) do
            if uType ~= hUnitType then
                _instance.Name:SetColorByName('TopBarLabelCS')
            end
        end
        PopulateSelectedHero()
    end)
    return instance
end

--- 刷新装备Instance
---@param e string
function RefreshEquipmentInstance(e)
    local instance = m_EquipmentInstanceList[e]

    if instance ~= nil then
        local equipment = m_EquipmentManager[e]
        local eName = Locale.Lookup(equipment.Name)
        instance.EquipmentName:SetString(eName)
        instance.EquipmentName:SetToolTipType('EquipmentTooltip')
        instance.EquipmentName:SetToolTipCallback(function()
            OnEquipmentTooltip(e)
        end)
        if equipment.Suit and m_EquipmentSuitManager[equipment.Suit] then
            instance.EquipmentName:SetOffsetY(-10)
            instance.EquipmentSuitName:SetHide(false)
            local suit = m_EquipmentSuitManager[equipment.Suit]
            -- print('suit = ', suit)
            local suitName = Locale.Lookup(suit.Name) .. ' 套装'
            instance.EquipmentSuitName:SetString(suitName)
            instance.EquipmentSuitName:SetToolTipCallback(function()
                OnSuitTooltip(suit)
            end)
        else
            instance.EquipmentSuitName:SetHide(true)
            instance.EquipmentName:SetOffsetY(0)
        end
        if equipment.EquipmentType == 'EQUIPMENT_ARMOR' then
            instance.EquipmentName:SetColorByName('ResFoodLabelCS')
        elseif equipment.EquipmentType == 'EQUIPMENT_MOUNT' then
            instance.EquipmentName:SetColorByName('ResTourismLabelCS')
        elseif equipment.EquipmentType == 'EQUIPMENT_ARTIFACT' then
            instance.EquipmentName:SetColorByName('ResFaithLabelCS')
        else
            instance.EquipmentName:SetColorByName('ResScienceLabelCS')
        end
        instance.EquipmentIcon:SetIcon('ICON_' .. equipment.EquipmentType)

        local heroClassIndex = equipment.HeroClassIndex
        local heroClass = GameInfo.HeroClasses[heroClassIndex]
        if heroClass and m_HeroEquipmentManager[heroClass.UnitType] then
            instance.HeroCon:SetHide(false)
            instance.ActionCon:SetHide(true)
            local heroEquipments = m_HeroEquipmentManager[heroClass.UnitType]
            instance.HeroName:SetString(Locale.Lookup('LOC_' .. heroClass.UnitType .. '_NAME'))
            instance.ActionChangeToEquipmentOwnerButton:RegisterCallback(Mouse.eLClick, function()
                m_panelParams['SelectedHero'] = heroClass.UnitType
                TabSelectLibrary()
            end)
        else
            instance.HeroCon:SetHide(true)
            instance.ActionCon:SetHide(false)
            instance.ActionSellButton:SetToolTipString(Locale.Lookup('LOC_TKH_EQUIPMENT_SELL_PRICE_TOOLTIP',
                EQUIPMENT_SOLD_PRICE))
            instance.ActionSellButton:RegisterCallback(Mouse.eLClick, function()
                SellEquipment(e)
            end)
            instance.ActionEquipentButton:RegisterCallback(Mouse.eLClick, function()
                ClickEquipment(e)
            end)
        end
    end
end

-- ===================================================================
--	FUNCTIONS UI
-- ===================================================================

function Open(selectedTabName)
    m_panelParams['SelectedHero'] = PlayerConfigurations[Game.GetLocalPlayer()]:GetValue('SelectedHero')
    m_kSliceIM:ResetInstances() -- Instance manager that generates pie chart slices.
    m_shopTabs.SelectTab(Controls.ShopPaneButtonWeapon)
    m_handbookTabs.SelectTab(Controls.ButtonWeapon)
    if selectedTabName == "Library" or selectedTabName == nil then
        m_tabs.SelectTab(Controls.ButtonLibrary)
    end
    if selectedTabName == "Shop" then
        m_tabs.SelectTab(Controls.ButtonShop)
    end
    if selectedTabName == "Handbook" then
        m_tabs.SelectTab(Controls.ButtonHandbook)
    end
    if selectedTabName == "Progress" then
        m_tabs.SelectTab(Controls.ButtonProgress)
    end
    CloseOtherPanels()
    UI.PlaySound("UI_Screen_Open")
    local kParameters = {}
    kParameters.RenderAtCurrentParent = true
    kParameters.InputAtCurrentParent = true
    kParameters.AlwaysVisibleInQueue = true
    UIManager:QueuePopup(ContextPtr, PopupPriority.Low, kParameters)
end

function RealizeTabs(selectedTabName)
    Controls.SelectedLibrary:SetHide(selectedTabName ~= "Library")
    Controls.ButtonLibrary:SetSelected(selectedTabName == "Library")
    Controls.LibraryPane:SetHide(selectedTabName ~= "Library")

    Controls.SelectedShop:SetHide(selectedTabName ~= "Shop")
    Controls.ButtonShop:SetSelected(selectedTabName == "Shop")
    Controls.ShopPane:SetHide(selectedTabName ~= "Shop")

    Controls.SelectedHandbook:SetHide(selectedTabName ~= "Handbook")
    Controls.ButtonHandbook:SetSelected(selectedTabName == "Handbook")
    Controls.HandbookPane:SetHide(selectedTabName ~= "Handbook")

    Controls.SelectedProgress:SetHide(selectedTabName ~= "Progress")
    Controls.ButtonProgress:SetSelected(selectedTabName == "Progress")
    Controls.ProgressPane:SetHide(selectedTabName ~= "Progress")
end

function RefreshAllPane()
    m_refresh = true

    if m_selectedPanelName == "Library" or m_selectedPanelName == nil then
        TabSelectLibrary()
    end
    if m_selectedPanelName == "Shop" then
        TabSelectShop()
    end
    if m_selectedPanelName == "Handbook" then
        TabSelectHandbook()
    end
    if m_selectedPanelName == "Progress" then
        TabSelectedProgress()
    end
end

-- ===================================================================
--	FUNCTIONS UI LIBRARY
-- ===================================================================

function OnFilterSelected(index, filterIndex)
    m_filterSelected = filterIndex
    m_filterSelectedName = m_filterList[m_filterSelected].FilterText
    Controls.FilterButton:SetText(m_filterSelectedName)
    RefreshEquipmentLibraryStack()
end

function GetFilterIndex(filterName)
    for index, filter in ipairs(m_filterList) do
        if filter.FilterText == filterName then
            return index
        end
    end
end

function AddFilter(filterName, filterFunction)
    -- Make sure we don't add duplicate filters
    if not GetFilterIndex(filterName) then
        table.insert(m_filterList, {
            FilterText = filterName,
            FilterFunction = filterFunction
        })
    end
end

function AddFilterEntry(filterIndex)
    local filterEntry = {}
    Controls.EquipmentFilterPulldown:BuildEntry("FilterEntry", filterEntry)
    filterEntry.Button:SetText(m_filterList[filterIndex].FilterText)
    filterEntry.Button:SetVoids(i, filterIndex)
end

function RefreshFilters()
    Controls.EquipmentFilterPulldown:ClearEntries()
    m_filterList = {}
    AddFilter(Locale.Lookup("LOC_ROUTECHOOSER_FILTER_ALL"), nil)
    for equipmentType in GameInfo.EquipmentTypes() do
        AddFilter(Locale.Lookup(equipmentType.Name), nil)
    end
    for index, filter in ipairs(m_filterList) do
        AddFilterEntry(index)
    end
    m_filterSelected = GetFilterIndex(m_filterSelectedName) or 1
    m_filterSelectedName = m_filterList[m_filterSelected].FilterText
    Controls.FilterButton:SetText(m_filterSelectedName)
    Controls.EquipmentFilterPulldown:CalculateInternals()
end

--- 刷新玩家装备库
function RefreshEquipmentLibraryStack()
    ms_EquipmentIM:ResetInstances()
    local ownedEquipments = {}
    local playerID = Game.GetLocalPlayer()
    for e, equipment in pairs(m_EquipmentManager) do
        if equipment.Owner == playerID then
            if equipment ~= nil then
                if m_filterSelected == 1 or equipment.EquipmentType == GameInfo.EquipmentTypes[m_filterSelected - 2].EquipmentType then
                    ownedEquipments[equipment.HeroClassIndex] = ownedEquipments[equipment.HeroClassIndex] or {}
                    table.insert(ownedEquipments[equipment.HeroClassIndex], e)
                end
            end
        end
    end

    local sort = {}
    for key, _ in pairs(ownedEquipments) do
        table.insert(sort, key)
    end

    table.sort(sort, function(a, b)
        return a > b
    end)
    for _, key in ipairs(sort) do
        for _, e in ipairs(ownedEquipments[key]) do
            m_EquipmentInstanceList[e] = ms_EquipmentIM:GetInstance(Controls.LibraryStack)
            RefreshEquipmentInstance(e)
        end
    end
end

function TabSelectLibrary()
    if not m_refresh then
        PopulateData()
        m_refresh = false
    end
    m_selectedPanelName = 'Library'
    RealizeTabs("Library")
    ms_HeroIM:ResetInstances()
    ms_HeroInstanceList = {}
    local playerID = Game.GetLocalPlayer()
    if m_HeroEquipmentManager then
        for hUnitType, heroEquipment in pairs(m_HeroEquipmentManager) do
            if heroEquipment and heroEquipment.Owner == playerID then
                local hUnit = UnitManager.GetUnit(heroEquipment.Owner, heroEquipment.UnitID)
                if hUnit and not (hUnit:IsDead() or hUnit:IsDelayedDeath()) then
                    ms_HeroInstanceList[hUnitType] = PopulateHero(hUnitType)
                else
                    if hUnitType == _getSelectedHeroUnitType() then
                        m_panelParams['SelectedHero'] = nil
                    end
                end
            end
        end
    end

    RefreshEquipmentLibraryStack()
    PopulateSelectedHero()
end

-- ===================================================================
--	FUNCTIONS UI SHOP
-- ===================================================================

function RefreshShopPane(selectedTabName)
    -- m_selectedTabName = selectedTabName
    ms_ShopEquipmentIM:ResetInstances()
    m_selectedTabName = string.gsub(selectedTabName, 'Shop', '')
    local equipmentType = 'EQUIPMENT_' .. string.upper(m_selectedTabName)


    local es = {}
    for e, equipment in pairs(m_EquipmentManager) do
        if equipment.Sold and equipment.EquipmentType == equipmentType then
            table.insert(es, e)
        end
    end

    table.sort(es, function(a, b)
        return GameInfo.Equipments[a].Index < GameInfo.Equipments[b].Index
    end)

    for _, e in ipairs(es) do
        local equipment = m_EquipmentManager[e]
        m_kShopkquipments[e] = ms_ShopEquipmentIM:GetInstance()
        m_kShopkquipments[e].EquipmentPortrait:SetIcon(equipment.Icon)
        local equipmentName = Locale.Lookup(equipment.Name)

        local equipmentDescription = GetEquiomentDescription(e)

        m_kShopkquipments[e].EquipmentName:SetString(equipmentName)
        m_kShopkquipments[e].EquipmentDescription:SetString(equipmentDescription)
        if equipment.Suit and m_EquipmentSuitManager[equipment.Suit] then
            local suit = m_EquipmentSuitManager[equipment.Suit]
            m_kShopkquipments[e].EquipmentSuitName:SetHide(false)
            local suitName = Locale.Lookup(suit.Name) .. ' 套装'
            m_kShopkquipments[e].EquipmentSuitName:SetString(suitName)
            m_kShopkquipments[e].EquipmentSuitName:SetToolTipCallback(function()
                OnSuitTooltip(suit)
            end)
        else
            m_kShopkquipments[e].EquipmentSuitName:SetHide(true)
        end
        m_kShopkquipments[e].EquipmentPrice:SetString('售价： [ICON_Gold] ' .. equipment.Price)
        m_kShopkquipments[e].BuyButton:RegisterCallback(Mouse.eLClick, function()
            BuyEquipment(e)
        end)
        m_kShopkquipments[e].BuyButton:SetDisabled(false)
        local player = Players[Game.GetLocalPlayer()]
        if player and player:GetTreasury() then
            m_kShopkquipments[e].BuyButton:SetDisabled(player:GetTreasury():GetGoldBalance() <
                equipment.Price)
        end
    end
end

function RealizeShopTabs(selectedTabName)
    Controls.ShopPaneSelectedWeapon:SetHide(selectedTabName ~= "ShopWeapon")
    Controls.ShopPaneButtonWeapon:SetSelected(selectedTabName == "ShopWeapon")

    Controls.ShopPaneSelectedArmor:SetHide(selectedTabName ~= "ShopArmor")
    Controls.ShopPaneButtonArmor:SetSelected(selectedTabName == "ShopArmor")

    Controls.ShopPaneSelectedMount:SetHide(selectedTabName ~= "ShopMount")
    Controls.ShopPaneButtonMount:SetSelected(selectedTabName == "ShopMount")

    Controls.ShopPaneSelectedArtifact:SetHide(selectedTabName ~= "ShopArtifact")
    Controls.ShopPaneButtonArtifact:SetSelected(selectedTabName == "ShopArtifact")
end

function TabSelectShop()
    if not m_refresh then
        PopulateData()
        m_refresh = false
    end
    m_selectedPanelName = 'Shop'
    RealizeTabs("Shop")
    RefreshShopPane("ShopWeapon")
end

function TabSelecShopPaneWeapon()
    RealizeShopTabs("ShopWeapon")
    RefreshShopPane("ShopWeapon")
end

function TabSelecShopPaneArmor()
    RealizeShopTabs("ShopArmor")
    RefreshShopPane("ShopArmor")
end

function TabSelecShopPaneMount()
    RealizeShopTabs("ShopMount")
    RefreshShopPane("ShopMount")
end

function TabSelecShopPaneArtifact()
    RealizeShopTabs("ShopArtifact")
    RefreshShopPane("ShopArtifact")
end

-- ===================================================================
--	FUNCTIONS UI HANDBOOK
-- ===================================================================

function OnSuitTooltip(suit)
    local tipControlTable = {}
    TTManager:GetTypeControlTable("EquipmentSuitTooltip", tipControlTable)
    local suitEquipmentLabels = {}
    suitEquipmentLabels.EQUIPMENT_WEAPON = tipControlTable.EquipmentSuitWeapon
    tipControlTable.EquipmentSuitWeapon:SetHide(true)
    suitEquipmentLabels.EQUIPMENT_ARMOR = tipControlTable.EquipmentSuitArmor
    tipControlTable.EquipmentSuitArmor:SetHide(true)
    suitEquipmentLabels.EQUIPMENT_MOUNT = tipControlTable.EquipmentSuitMount
    tipControlTable.EquipmentSuitMount:SetHide(true)
    suitEquipmentLabels.EQUIPMENT_ARTIFACT = tipControlTable.EquipmentSuitArtifact
    tipControlTable.EquipmentSuitArtifact:SetHide(true)
    local suitName = Locale.Lookup(suit.Name) .. ' 套装'
    tipControlTable.EquipmentSuitName:SetString(suitName)

    local suitEquipments = {}

    local playerID = Game.GetLocalPlayer()

    for _, e in ipairs(suit.Equipments) do
        local suitEquipment = m_EquipmentManager[e]
        if suitEquipment then
            local suitEquipmentName = Locale.Lookup(suitEquipment.Name)
            if not suitEquipments[suitEquipment.EquipmentType] then
                suitEquipments[suitEquipment.EquipmentType] = ''
            end
            if suitEquipments[suitEquipment.EquipmentType] ~= '' then
                suitEquipments[suitEquipment.EquipmentType] = suitEquipments[suitEquipment.EquipmentType] .. ', '
            end
            if suitEquipment.Owner == playerID then
                suitEquipments[suitEquipment.EquipmentType] =
                    suitEquipments[suitEquipment.EquipmentType] .. '[COLOR:120,255,30]' .. suitEquipmentName ..
                    '[ENDCOLOR]'
            else
                suitEquipments[suitEquipment.EquipmentType] =
                    suitEquipments[suitEquipment.EquipmentType] .. '[COLOR:129,129,129]' .. suitEquipmentName ..
                    '[ENDCOLOR]'
            end
        end
    end

    for key, value in pairs(suitEquipments) do
        suitEquipmentLabels[key]:SetHide(false)
        suitEquipmentLabels[key]:SetString(value)
    end

    for index, suitAbility in ipairs(suit.Abilities) do
        local abilityInfo = suitAbility.Info
        tipControlTable['EquipmentSuitEffectStack' .. index]:SetHide(false)
        tipControlTable['EffectEAmount' .. index]:SetString(Locale.Lookup('LOC_EQUIPMENT_SUIT_NEED_AMOUNT',
            suitAbility.Amount))
        tipControlTable['EffectDescription' .. index]:SetString(Locale.Lookup(abilityInfo.Description or ''))
        if index == #suit.Abilities then
            tipControlTable['split' .. index]:SetHide(true)
        end
    end
end

function OnEquipmentTooltip(e)
    local tipControlTable = {}
    TTManager:GetTypeControlTable("EquipmentTooltip", tipControlTable)

    local equipment = m_EquipmentManager[e]
    local eName = Locale.Lookup(equipment.Name)
    tipControlTable.Icon:SetIcon('ICON_' .. e)
    tipControlTable.Name:SetString(eName)
    tipControlTable.Descritpion:SetString(string.gsub(Locale.Lookup(equipment.Description), eName .. '：', ''))
end

function RefreshHandbookPane(selectedTabName)
    local playerID = Game.GetLocalPlayer()
    m_selectedTabName = selectedTabName
    ms_HandbookEquipmentIM:ResetInstances()
    local equipmentType = 'EQUIPMENT_' .. string.upper(selectedTabName)
    local localPlayer = Players[Game.GetLocalPlayer()]
    local pPlayerDiplomacy = localPlayer:GetDiplomacy()

    local es = {}
    for e, _ in pairs(m_EquipmentManager) do
        table.insert(es, e)
    end

    table.sort(es, function(a, b)
        return GameInfo.Equipments[a].Index < GameInfo.Equipments[b].Index
    end)



    for _, e in ipairs(es) do
        local equipment = m_EquipmentManager[e]
        if equipment.EquipmentType == equipmentType then
            m_kHandbookEquipments[e] = ms_HandbookEquipmentIM:GetInstance()
            m_kHandbookEquipments[e].EquipmentPortrait:SetIcon(equipment.Icon)
            local equipmentName = Locale.Lookup(equipment.Name)
            local equipmentDescription = GetEquiomentDescription(e)

            m_kHandbookEquipments[e].EquipmentName:SetString(equipmentName)
            m_kHandbookEquipments[e].EquipmentDescription:SetString(equipmentDescription)

            if equipment.Suit and m_EquipmentSuitManager[equipment.Suit] then
                local suit = m_EquipmentSuitManager[equipment.Suit]
                m_kHandbookEquipments[e].EquipmentSuitName:SetHide(false)
                local suitName = Locale.Lookup(suit.Name) .. ' 套装'
                m_kHandbookEquipments[e].EquipmentSuitName:SetString(suitName)
                m_kHandbookEquipments[e].EquipmentSuitName:SetToolTipCallback(function()
                    OnSuitTooltip(suit)
                end)
            else
                m_kHandbookEquipments[e].EquipmentSuitName:SetHide(true)
            end

            if EQUIPMENT_DEBUG_MODE then
                m_kHandbookEquipments[e].TestButton:SetHide(false)
                m_kHandbookEquipments[e].TestButton:RegisterCallback(Mouse.eLClick,
                    function()
                        equipment.Owner = playerID
                        equipment.HeroClassIndex = -1
                        equipment.oTurn = 0
                        equipment.hTurn = 0
                        equipment.RewardType = -1
                        equipment.GetTurn = -1
                        equipment.Locked = false
                        equipment.Sold = false
                        ChangeEquipmentData(e, equipment)
                    end
                )
            end

            local owner = equipment.Owner
            if owner ~= -1 then
                m_kHandbookEquipments[e].EquipmentOwnerCon:SetHide(false)
                DifferentiateCiv(owner, m_kHandbookEquipments[e].CivIcon, m_kHandbookEquipments[e].CivIcon,
                    m_kHandbookEquipments[e].CivIndicator, nil, nil, playerID)
                m_kHandbookEquipments[e].RecruitedImage:SetHide(true)
                m_kHandbookEquipments[e].YouIndicator:SetHide(true)
                local playerConfig = PlayerConfigurations[owner] -- :GetCivilizationShortDescription()
                if (playerConfig ~= nil) then
                    local iconName = "ICON_" .. playerConfig:GetLeaderTypeName()
                    m_kHandbookEquipments[e].Content2:SetHide(playerID ~= owner)
                    if pPlayerDiplomacy:HasMet(owner) or playerID == owner then
                        m_kHandbookEquipments[e].RecruitedImage:SetIcon(iconName, 55)
                        m_kHandbookEquipments[e].RecruitedImage:SetHide(false)
                        m_kHandbookEquipments[e].YouIndicator:SetHide(true)
                    else
                        m_kHandbookEquipments[e].RecruitedImage:SetIcon("ICON_CIVILIZATION_UNKNOWN", 55)
                        m_kHandbookEquipments[e].RecruitedImage:SetHide(false)
                        m_kHandbookEquipments[e].YouIndicator:SetHide(true)
                    end
                end
            else
                m_kHandbookEquipments[e].EquipmentOwnerCon:SetHide(true)
                m_kHandbookEquipments[e].Content2:SetHide(true)
            end
        end
    end
end

function RealizeHandbookTabs(selectedTabName)
    Controls.SelectedWeapon:SetHide(selectedTabName ~= "Weapon")
    Controls.ButtonWeapon:SetSelected(selectedTabName == "Weapon")

    Controls.SelectedArmor:SetHide(selectedTabName ~= "Armor")
    Controls.ButtonArmor:SetSelected(selectedTabName == "Armor")

    Controls.SelectedMount:SetHide(selectedTabName ~= "Mount")
    Controls.ButtonMount:SetSelected(selectedTabName == "Mount")

    Controls.SelectedArtifact:SetHide(selectedTabName ~= "Artifact")
    Controls.ButtonArtifact:SetSelected(selectedTabName == "Artifact")
end

function TabSelectHandbook()
    if not m_refresh then
        PopulateData()
        m_refresh = false
    end
    m_selectedPanelName = 'Handbook'
    RealizeTabs("Handbook")
    RefreshHandbookPane("Weapon")
end

function TabSelectHandbookWeapon()
    RealizeHandbookTabs("Weapon")
    RefreshHandbookPane("Weapon")
end

function TabSelectHandbookArmor()
    RealizeHandbookTabs("Armor")
    RefreshHandbookPane("Armor")
end

function TabSelectHandbookMount()
    RealizeHandbookTabs("Mount")
    RefreshHandbookPane("Mount")
end

function TabSelectHandbookArtifact()
    RealizeHandbookTabs("Artifact")
    RefreshHandbookPane("Artifact")
end

-- ===================================================================
--	FUNCTIONS UI PROGRESS
-- ===================================================================

function BuildPieChart(uiHolder, sliceIM, kSliceAmounts, kColors)
    -- Protect the flock, bad arguements raise errors and return empty tables:
    if uiHolder == nil then
        UI.DataError("Cannot build pie chart due to nil uiHolder passed in.")
        return {}
    end
    if sliceIM == nil then
        UI.DataError("Cannot build pie chart due to a nil instance manager for generating slices passed in.")
        return {}
    end
    if kSliceAmounts == nil then
        UI.DataError("Cannot build pie chart due to a nil table of slice amounts passed in.")
        return {}
    end

    -- Determine total amount from slices and check bounds (create non-1 multiplier if necessary.)
    local total = 0
    local multiplier = 1
    for i, v in ipairs(kSliceAmounts) do
        total = total + v
    end
    if total > 1.0 then
        multiplier = 1.0 / total
        UI.DataError("Total of pie chart slices " .. tostring(total) .. " exceeds 1.0 (100%).  Applying multiplier " ..
            tostring(multiplier))
    elseif total < 0 then
        UI.DataError("Total of slices " .. tostring(total) .. " is less than 0!  Something is fishy with your data.")
        total = 0
    end

    -- If colors were not passed in, generate a table.
    if kColors == nil or table.count(kColors) == 0 then
        kColors = { UI.GetColorValueFromHexLiteral(0xff000099), UI.GetColorValueFromHexLiteral(0xff008888),
            UI.GetColorValueFromHexLiteral(0xff009900), UI.GetColorValueFromHexLiteral(0xff888800),
            UI.GetColorValueFromHexLiteral(0xff990000), UI.GetColorValueFromHexLiteral(0xff880088) }
    end
    local maxColors = #kColors

    -- Loop through generating pie slices.
    local kUISlices = {}
    local remaining = total

    for i, v in ipairs(kSliceAmounts) do
        local uiInstance = sliceIM:GetInstance(uiHolder)
        table.insert(kUISlices, uiInstance)

        uiInstance["Slice"]:SetColor(kColors[((i - 1) % maxColors) + 1]) -- MOD
        uiInstance["Slice"]:SetPercent(remaining)

        remaining = remaining - v
    end

    return kUISlices
end

function RefreshRewardText()
    local playerID = Game.GetLocalPlayer()
    local pLocalPlayer = Players[playerID]

    local totalcities_counter, totalcities_recorder = GetPlayerReward(playerID, EQUIPMENT_REWARD_TYPES.TOTAL_CITIES)
    totalcities_counter = pLocalPlayer:GetCities():GetCount()
    Controls.TOTAL_CITIES_BAR:SetString(Locale.Lookup('LOC_TOTAL_CITIES_BAR', totalcities_counter,
        GetEquipmentRewardNeedsNum(EQUIPMENT_REWARD_TYPES.TOTAL_CITIES, #totalcities_recorder)))

    local DESTORY_BARBARIAN_CAMP_BAR_counter, DESTORY_BARBARIAN_CAMP_BAR_recorder = GetPlayerReward(playerID,
        EQUIPMENT_REWARD_TYPES.DESTORY_BARBARIAN_CAMP)
    Controls.DESTORY_BARBARIAN_CAMP_BAR:SetString(Locale.Lookup('LOC_DESTORY_BARBARIAN_CAMP_BAR',
        DESTORY_BARBARIAN_CAMP_BAR_counter,
        GetEquipmentRewardNeedsNum(EQUIPMENT_REWARD_TYPES.DESTORY_BARBARIAN_CAMP, #DESTORY_BARBARIAN_CAMP_BAR_recorder)))

    local GOODYHUT_REWARD_counter, GOODYHUT_REWARD_recorder = GetPlayerReward(playerID,
        EQUIPMENT_REWARD_TYPES.GOODYHUT_REWARD)
    Controls.GOODYHUT_REWARD_BAR:SetString(Locale.Lookup('LOC_GOODYHUT_REWARD_BAR', GOODYHUT_REWARD_counter,
        GetEquipmentRewardNeedsNum(EQUIPMENT_REWARD_TYPES.GOODYHUT_REWARD, #GOODYHUT_REWARD_recorder)))

    local totalKill_counter, totalKill_recorder = GetPlayerReward(playerID,
        EQUIPMENT_REWARD_TYPES.TOTAL_KILL)
    Controls.TOTAL_KILL_BAR:SetString(Locale.Lookup('LOC_TOTAL_KILL_BAR', totalKill_counter,
        GetEquipmentRewardNeedsNum(EQUIPMENT_REWARD_TYPES.TOTAL_KILL, #totalKill_recorder)))

    local conquered_counter, conquered_recorder = GetPlayerReward(playerID,
        EQUIPMENT_REWARD_TYPES.CONQUERED_ORIGINAL_CAPITAL)
    Controls.CONQUERED_ORIGINAL_CAPITAL_BAR:SetString(Locale.Lookup('LOC_CONQUERED_ORIGINAL_CAPITAL_BAR',
        conquered_counter,
        GetEquipmentRewardNeedsNum(EQUIPMENT_REWARD_TYPES.CONQUERED_ORIGINAL_CAPITAL, #conquered_recorder)))
end

function RefreshGlobalEquipments()
    m_kCivEquipmentIM:ResetInstances()
    for _, uiSliceInstance in ipairs(m_kGlobalPieSlices) do
        m_kSliceIM:ReleaseInstance(uiSliceInstance)
    end
    local _localplayerID = Game.GetLocalPlayer()
    local pLocalPlayer = Players[_localplayerID]

    local pPlayers = PlayerManager.GetAliveMajors()
    local pLocalPlayerDiplomacy = pLocalPlayer:GetDiplomacy()
    local total = table.count(m_EquipmentManager)
    local kPlayerEquipmentAmouts = {} -- hold raw CO2 usage amounts by each resource	

    local allocatedEquipmentAmount = 0
    local playersEquipmentAmount = {}
    for _, equipment in pairs(m_EquipmentManager) do
        if equipment.Owner ~= -1 then
            if not playersEquipmentAmount[equipment.Owner] then
                playersEquipmentAmount[equipment.Owner] = 1
            else
                playersEquipmentAmount[equipment.Owner] = playersEquipmentAmount[equipment.Owner] + 1
            end
            allocatedEquipmentAmount = allocatedEquipmentAmount + 1
        end
    end

    Controls.PlayerEquipmentAmouts:SetString(Locale.Lookup('LOC_PLAYER_EQUIPMENT_AMOUNT', allocatedEquipmentAmount,
        total))

    local kColors = {}
    for _, pPlayer in ipairs(pPlayers) do
        local pPlayerID = pPlayer:GetID()
        local pPlayerConfig = PlayerConfigurations[pPlayerID]
        local civType = pPlayerConfig:GetCivilizationTypeName()
        local civName = Locale.Lookup(pPlayerConfig:GetCivilizationDescription())
        local backColor, frontColor = UI.GetPlayerColors(pPlayerID)

        -- unmet players get a dark blue pie wedge and no clues about who the civ is
        if not pLocalPlayerDiplomacy:HasMet(pPlayerID) and pPlayerID ~= _localplayerID then
            civType = ""
            civName = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER")
            -- backColor = UI.GetColorValue("COLOR_STANDARD_BLUE_DK")
            backColor = UI.GetColorValue(0, 0, 0, 1)
        end

        if (_localplayerID == pPlayerID) then
            civName = Locale.Lookup("LOC_CLIMATE_YOU", civName) -- Add "(You)" for your civ.
        end

        local uiCiv = m_kCivEquipmentIM:GetInstance()
        local civIconController = CivilizationIcon:AttachInstance(uiCiv.CivIcon)
        civIconController:UpdateIconFromPlayerID(pPlayerID)
        civIconController:SetLeaderTooltip(pPlayerID)
        local equipmentAmount = playersEquipmentAmount[pPlayerID] or 0
        uiCiv.Amount:SetText(equipmentAmount)
        uiCiv.Amount:SetToolTipString(string.gsub(string.format('%0.1f%%', (equipmentAmount / total) * 100), '%.0', ''))

        if equipmentAmount > 0 then
            table.insert(kPlayerEquipmentAmouts, equipmentAmount) -- Add value
            table.insert(kColors, backColor)                      -- Add color based on player's color
        end
    end

    local kSliceAmounts = {} -- hold the % each resource is contributing to CO2
    for i, amount in ipairs(kPlayerEquipmentAmouts) do
        table.insert(kSliceAmounts, amount / total)
    end

    m_kGlobalPieSlices = BuildPieChart(Controls.GlobalContributionsPie, m_kSliceIM, kSliceAmounts, kColors)
end

function TabSelectedProgress()
    if not m_refresh then
        PopulateData()
        m_refresh = false
    end
    m_selectedPanelName = 'Progress'
    RealizeTabs("Progress")
    RefreshGlobalEquipments()
    RefreshRewardText()
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

function Close()
    PlayerConfigurations[Game.GetLocalPlayer()]:SetValue('SelectedHero', m_panelParams['SelectedHero'])
    if ContextPtr:IsHidden() then
        return
    else
        UI.PlaySound("UI_Screen_Close")
    end
    UIManager:DequeuePopup(ContextPtr)
end

-- ===================================================================
--	FUNCTIONS	UI
-- ===================================================================

function OnInit(isReload)
    LateInitialize()
end

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
    LuaEvents.EquipmentsButton_TogglePopup.Remove(OnTogglePanel)
    LuaEvents.Equipments_Refresh.Remove(RefreshAllPane)
    EventRemover()
end

-- ===========================================================================
--	FUNCTIONS	UI  EVENTS
-- ===========================================================================


function PopulateData()
    m_EquipmentManager = Game:GetProperty('EquipmentManager') or m_EquipmentManager
    m_HeroEquipmentManager = Game:GetProperty('HeroEquipmentManager') or m_HeroEquipmentManager
    m_EquipmentSuitManager = Game:GetProperty('EquipmentSuitManager') or m_EquipmentSuitManager
    m_EquipmentAllocator = Game:GetProperty('EquipmentAllocator') or m_EquipmentAllocator
    m_HeroRewardManager = Game:GetProperty('HeroRewardManager') or m_HeroRewardManager
    m_EquipmentRewardManager = Game:GetProperty('EquipmentRewardManager') or m_EquipmentRewardManager
    SaveData()
    -- if Game:GetProperty("TKH_EquipmentData_Initialized") then
    --     RefreshAllPane()
    -- end

    RefreshAllPane()
end

function ReadData()
    -- PopulateData()
    local dataStr = GameConfiguration.GetValue('EquipmentData')
    if dataStr then
        local data = deserialize(dataStr)
        if data then
            m_EquipmentManager,
            m_HeroEquipmentManager,
            m_EquipmentSuitManager,
            m_EquipmentAllocator,
            m_HeroRewardManager,
            m_EquipmentRewardManager = unpack(data)
        end
    end
end

function SaveData()
    m_EquipmentManager = Game:GetProperty('EquipmentManager')
    m_HeroEquipmentManager = Game:GetProperty('HeroEquipmentManager')
    m_EquipmentSuitManager = Game:GetProperty('EquipmentSuitManager')
    m_EquipmentAllocator = Game:GetProperty('EquipmentAllocator')
    m_HeroRewardManager = Game:GetProperty('HeroRewardManager')
    m_EquipmentRewardManager = Game:GetProperty('EquipmentRewardManager')

    local data = {
        m_EquipmentManager,
        m_HeroEquipmentManager,
        m_EquipmentSuitManager,
        m_EquipmentAllocator,
        m_HeroRewardManager,
        m_EquipmentRewardManager
    }

    local serializedModSyncUpdateDataStr = serialize(data)
    GameConfiguration.SetValue('EquipmentData', serializedModSyncUpdateDataStr)
    local playerConfig = PlayerConfigurations[Game.GetLocalPlayer()]
    playerConfig:SetValue('EquipmentData', serializedModSyncUpdateDataStr)
    if GameConfiguration.IsNetworkMultiplayer() then
        Network.BroadcastPlayerInfo()
        Network.BroadcastGameConfig()
    end
end

function OnTogglePanel()
    if ContextPtr:IsHidden() then
        Open(m_selectedPanelName)
    else
        Close()
    end
end

function LateInitialize()
    m_tabs = CreateTabs(Controls.TabContainer, 42, 34, UI.GetColorValueFromHexLiteral(0xFF331D05))
    m_tabs.AddTab(Controls.ButtonLibrary, TabSelectLibrary)
    m_tabs.AddTab(Controls.ButtonShop, TabSelectShop)
    m_tabs.AddTab(Controls.ButtonHandbook, TabSelectHandbook)
    m_tabs.AddTab(Controls.ButtonProgress, TabSelectedProgress)
    m_tabs.CenterAlignTabs(-10)

    m_shopTabs = CreateTabs(Controls.ShopPaneTabContainer, 42, 34, UI.GetColorValueFromHexLiteral(0xFF331D05))
    m_shopTabs.AddTab(Controls.ShopPaneButtonWeapon, TabSelecShopPaneWeapon)
    m_shopTabs.AddTab(Controls.ShopPaneButtonArmor, TabSelecShopPaneArmor)
    m_shopTabs.AddTab(Controls.ShopPaneButtonMount, TabSelecShopPaneMount)
    m_shopTabs.AddTab(Controls.ShopPaneButtonArtifact, TabSelecShopPaneArtifact)
    m_shopTabs.CenterAlignTabs(-10)

    m_handbookTabs = CreateTabs(Controls.HandbookTabContainer, 42, 34, UI.GetColorValueFromHexLiteral(0xFF331D05))
    m_handbookTabs.AddTab(Controls.ButtonWeapon, TabSelectHandbookWeapon)
    m_handbookTabs.AddTab(Controls.ButtonArmor, TabSelectHandbookArmor)
    m_handbookTabs.AddTab(Controls.ButtonMount, TabSelectHandbookMount)
    m_handbookTabs.AddTab(Controls.ButtonArtifact, TabSelectHandbookArtifact)
    m_handbookTabs.CenterAlignTabs(-10)

    RefreshFilters()
    Controls.EquipmentFilterPulldown:RegisterSelectionCallback(OnFilterSelected)
    Controls.ScreenCloseButton:RegisterCallback(Mouse.eLClick, Close)
    LuaEvents.EquipmentsButton_TogglePopup.Add(OnTogglePanel)
    LuaEvents.Equipments_Refresh.Add(RefreshAllPane)

    ms_ShopEquipmentIM:ResetInstances()
    ms_HandbookEquipmentIM:ResetInstances()
end

function EventRegister()
    Events.GamePropertyChanged.Add(PopulateData)
    Events.SaveComplete.Add(SaveData)
    Events.TurnEnd.Add(SaveData)
end

function EventRemover()
    Events.GamePropertyChanged.Remove(PopulateData)
end

--*********************************

local function OnLoadGameViewStateDone_TKH()
    LateInitialize_TKH();
end

LateInitialize_TKH = function()
    EventRegister()
end


function Initialize()
    -- UI
    ContextPtr:SetInitHandler(OnInit)
    ContextPtr:SetInputHandler(OnInputHandler, true)
    ContextPtr:SetShutdown(OnShutdown)

    Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone_TKH);
end

Initialize()
