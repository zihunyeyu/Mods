-- ===========================================================================
--	HUD Top of Screen Area
--	XP2 Override
-- ===========================================================================
include("TopPanel_Expansion2");

-- MOD
include("TopPanelExtension.lua")

include('TKH_Helper')

-- ===========================================================================
-- Super functions
-- ===========================================================================
XP2_RefreshYields = RefreshYields;
XP2_LateInitialize = LateInitialize;


-- ===========================================================================
--	Favor in the top bar should not ship as is.
--	TODO: Remove this implementation
-- ===========================================================================

local count = true
local LUXURY_TAX_MODE = GameConfiguration.GetValue("LUXURY_TAX_MODE")
local LUXURY_TAX_MODE_CITY = GameConfiguration.GetValue("LUXURY_TAX_MODE_CITY")


-- <Instance Name="YieldButton_SingleLabel">
-- <Container ID="Top" Size="auto,auto">
--   <GridButton	ID="YieldBacking" Size="auto,24" AutoSizePadding="1,0" Style="YieldBacking" Color="24,156,216,255">
--     <Stack		ID="YieldButtonStack" Anchor="L,C" Offset="0,2"	StackGrowth="Right">
--       <Label	ID="YieldIconString" Anchor="L,B" Offset="0,4"/>
--       <Label	ID="YieldPerTurn" Anchor="C,T" Style="FontNormal18" ColorSet="ResScienceLabelCS" FontStyle="Stroke" String="0"/>
--     </Stack>
--   </GridButton>
-- </Container>
-- </Instance>

function RefreshBattleUnits()
    m_BattleUnitsYieldButton = m_BattleUnitsYieldButton or m_YieldButtonSingleManager:GetInstance()

    local total_cities_num, total_units_num = GetPlayerCitiesAndNotCivilianUnitsNum(Game.GetLocalPlayer())
    local allow_max_unit_num = CAPITAL_MAX_UNIT_NUM + (total_cities_num - 1) * PER_CITY_MAX_UNIT_NUM
    local luxury_max = allow_max_unit_num
    if luxury_max >= LUXURY_UNIT_NUM_MAX then
        luxury_max = LUXURY_UNIT_NUM_MAX
    end


    local unitString = string.format('%d/%d/%d', total_units_num, allow_max_unit_num, luxury_max)
    if total_units_num >= allow_max_unit_num or total_units_num >= luxury_max then
        unitString = '[COLOR:Red]' .. unitString .. '[ENDCOLOR]'
    end
    local tooltipString = Locale.Lookup('LOC_LUXURY_TOOLTIP', total_units_num, allow_max_unit_num, luxury_max)


    m_BattleUnitsYieldButton.YieldIconString:SetText("[ICON_Unit]")
    m_BattleUnitsYieldButton.YieldPerTurn:SetText(unitString)
    m_BattleUnitsYieldButton.YieldPerTurn:SetColorByName("StatNormalCS")
    m_BattleUnitsYieldButton.YieldBacking:SetToolTipString(tooltipString)
    m_BattleUnitsYieldButton.YieldBacking:SetColorByName("ChatMessage_Whisper")
    m_BattleUnitsYieldButton.YieldButtonStack:CalculateSize()
end

function RefreshYields()
    XP2_RefreshYields();

    if not LUXURY_TAX_MODE or not LUXURY_TAX_MODE_CITY then
        return
    end

    local ePlayer     = Game.GetLocalPlayer();
    local localPlayer = nil;
    if ePlayer ~= -1 then
        localPlayer = Players[ePlayer];
        if localPlayer == nil then
            return;
        end
    else
        return;
    end

    local children = Controls.YieldStack:GetChildren();
    for _, child in ipairs(children) do
        if count then
            Controls.YieldStack:DestroyChild(children[4])
            count = false
        end
    end

    ---- GOLD ----
    if GameCapabilities.HasCapability("CAPABILITY_GOLD") and GameCapabilities.HasCapability("CAPABILITY_DISPLAY_TOP_PANEL_YIELDS") then
        m_GoldYieldButton    = m_GoldYieldButton or m_YieldButtonDoubleManager:GetInstance();
        local playerTreasury = localPlayer:GetTreasury();
        local goldYield      = playerTreasury:GetGoldYield() - playerTreasury:GetTotalMaintenance();
        local goldBalance    = math.floor(playerTreasury:GetGoldBalance());

        -- 每 [ICON_Turn] 回合金币[NEWLINE][NEWLINE]收入：+0 [ICON_WLINE][NEWLINE]花费：-0 [ICON_Gold]
        local tooltipString  = GetGoldTooltip()

        if LUXURY_TAX_MODE then
            local luxuryTax = CalculateLuxuryTaxUnits(Game.GetLocalPlayer())
            goldYield       = goldYield - luxuryTax
            tooltipString   = tooltipString .. string.format('[NEWLINE]奢侈税：-%d [ICON_Gold]', luxuryTax)
        end

        if LUXURY_TAX_MODE_CITY then
            local luxuryTax = CalculateLuxuryTaxCities(Game.GetLocalPlayer())
            goldYield       = goldYield - luxuryTax
            tooltipString   = tooltipString .. string.format('[NEWLINE]城市奢侈税：-%d [ICON_Gold]', luxuryTax)
        end

        m_GoldYieldButton.YieldBalance:SetText(Locale.ToNumber(goldBalance, "#,###.#"));
        m_GoldYieldButton.YieldBalance:SetColorByName("ResGoldLabCS");
        m_GoldYieldButton.YieldPerTurn:SetText(FormatValuePerTurn(goldYield));
        m_GoldYieldButton.YieldIconString:SetText("[ICON_GoldLarge]");
        m_GoldYieldButton.YieldPerTurn:SetColorByName("ResGoldLabelCS");
        m_GoldYieldButton.YieldBacking:SetToolTipString(tooltipString);
        m_GoldYieldButton.YieldBacking:SetColorByName("ResGoldLabelCS");
        m_GoldYieldButton.YieldButtonStack:CalculateSize();
    end

    --- Unit ----
    RefreshBattleUnits()

    Controls.YieldStack:CalculateSize();
    Controls.StaticInfoStack:CalculateSize();
    Controls.InfoStack:CalculateSize();

    Controls.YieldStack:RegisterSizeChanged(RefreshResources);
    Controls.StaticInfoStack:RegisterSizeChanged(RefreshResources);
end

function CostLuxuryTaxTurnBegin()
    local player         = Players[Game.GetLocalPlayer()]

    local minLoyaltyCity = -1
    local loyaltyNum     = 101
    for _, city in player:GetCities():Members() do
        local pCulturalIdentity = city:GetCulturalIdentity();
        local currentLoyalty = pCulturalIdentity:GetLoyalty();
        if currentLoyalty <= loyaltyNum then
            loyaltyNum = currentLoyalty
            minLoyaltyCity = city:GetID()
        end
    end

    local kParameters   = {}
    kParameters.OnStart = "CostLuxuryTax"
    kParameters.CityID  = minLoyaltyCity
    kParameters.Loyalty = loyaltyNum

    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end

-- ===========================================================================
function LateInitialize()
    XP2_LateInitialize();

    if LUXURY_TAX_MODE then
        Events.UnitAddedToMap.Add(RefreshYields)
        Events.UnitRemovedFromMap.Add(RefreshYields)
    end

    if LUXURY_TAX_MODE_CITY then
        Events.CityAddedToMap.Add(RefreshYields)
        Events.CityRemovedFromMap.Add(RefreshYields)
    end

    Events.LocalPlayerTurnBegin.Add(CostLuxuryTaxTurnBegin)
end
