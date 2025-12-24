-- Copyright 2020, Firaxis Games

include("InstanceManager");
include("HeroesSupport");
include("CivilizationIcon");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

local m_sPortraitPrefix = "ICON_";
local m_sPortraitSuffix = "_PORTRAIT";

-- ===========================================================================
--	MEMBERS
-- ===========================================================================

local m_pHeroPanelIM    = InstanceManager:new("HeroPanelInstance", "Content", Controls.HeroStack);
local m_pAbilityIM      = InstanceManager:new("AbilityInstance", "Top");
local m_pCommandIM      = InstanceManager:new("CommandInstance", "Top");
local m_pStatIM         = InstanceManager:new("StatInstance", "Top");

local m_newestHeroType  = "";

-- ===========================================================================
function RefreshHeroes()
    ClearHeroes();
    local pGameHeroes = Game.GetHeroesManager();
    local allPlayerIDs = PlayerManager.GetWasEverAliveMajorIDs()
    for row in GameInfo.HeroClasses() do
        -- if row.Index % 3 == 0 then
        --     AddHero(row);
        -- end
        if pGameHeroes:IsHeroDiscovered(Game.GetLocalPlayer(), row.Index) then
            AddHero(row);
        end
    end
end

-- ===========================================================================
function AddHero(kHeroDef)
    local kHeroInstance = m_pHeroPanelIM:GetInstance();

    local sHeroName = "";
    if kHeroDef.HeroClassType == m_newestHeroType then
        sHeroName = "[ICON_New] ";
    end
    sHeroName = sHeroName .. Locale.ToUpper(kHeroDef.Name);
    kHeroInstance.IndividualName:SetText(sHeroName);

    local sIconName = m_sPortraitPrefix .. kHeroDef.HeroClassType .. m_sPortraitSuffix;
    kHeroInstance.Portrait:SetIcon(sIconName);

    -- Stats
    local kStats = GetHeroUnitStats(kHeroDef.Index);

    if kStats.Lifespan ~= nil then
        local pLifespanInst = m_pStatIM:GetInstance(kHeroInstance.EffectStack);
        pLifespanInst.StatIcon:SetIcon("ICON_LIFESPAN");
        pLifespanInst.ValueText:SetText(kStats.Lifespan);
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

    -- Abilities
    local kAbilities = GetHeroClassUnitAbilities(kHeroDef.Index);
    for _, kAbility in pairs(kAbilities) do
        local pAbilityInst = m_pAbilityIM:GetInstance(kHeroInstance.EffectStack);

        pAbilityInst.AbilityName:SetText(Locale.ToUpper(kAbility.Name));
        pAbilityInst.AbilityText:SetText(Locale.Lookup(kAbility.Description));
    end

    -- Commands
    local kCommands = GetHeroClassUnitCommands(kHeroDef.Index);
    for _, kCommand in pairs(kCommands) do
        local pCommandInst = m_pCommandIM:GetInstance(kHeroInstance.EffectStack);

        pCommandInst.CommandName:SetText(Locale.ToUpper(kCommand.Name));
        pCommandInst.CommandText:SetText(Locale.Lookup(kCommand.Description));
        pCommandInst.CommandIcon:SetIcon(kCommand.Icon);
    end

    -- Setup Civilopedia button
    if GameCapabilities.HasCapability("CAPABILITY_DISPLAY_TOP_PANEL_CIVPEDIA") then
        kHeroInstance.CivilopediaButton:RegisterCallback(Mouse.eLClick,
            function() OpenCivilopediaForHero(kHeroDef.UnitType); end);
        kHeroInstance.CivilopediaButton:SetHide(false);
    else
        kHeroInstance.CivilopediaButton:SetHide(true);
    end

    -- Hero Status
    local pGameHeroes = Game.GetHeroesManager();
    local claimedByPlayer = pGameHeroes:GetHeroClaimPlayer(kHeroDef.Index);
    if claimedByPlayer ~= -1 then
        kHeroInstance.HeroStatus:SetText(Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_RECRUITED_STATE"));

        local kCivIconController = CivilizationIcon:AttachInstance(kHeroInstance.ClaimedByCivIcon);
        kCivIconController:UpdateIconFromPlayerID(claimedByPlayer);
        kCivIconController:SetLeaderTooltip(claimedByPlayer);
        kHeroInstance.ClaimedByCivIcon.CivIconBacking:SetHide(false);

        -- Determine if the hero is still alive
        local bIsAlive = false;
        local pHeroUnit = nil;
        local pPlayer = Players[claimedByPlayer];
        if pPlayer ~= nil then
            local pPlayerUnits = pPlayer:GetUnits();
            for i, pUnit in pPlayerUnits:Members() do
                if GameInfo.Units[pUnit:GetType()].UnitType == kHeroDef.UnitType then
                    bIsAlive = true;
                    pHeroUnit = pUnit;
                end
            end
        end

        kHeroInstance.DeceasedText:SetHide(bIsAlive);

        local bHideLookAtButton = true;
        local bHideRecallButton = true;
        if claimedByPlayer == Game.GetLocalPlayer() then
            -- Show Look at Hero/City button if claimed by the active player
            if pHeroUnit ~= nil then
                kHeroInstance.LookAtButton:SetToolTipString(Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_LOOK_AT_HERO_TT"));
                kHeroInstance.LookAtButton:RegisterCallback(Mouse.eLClick, function() LookAtUnit(pHeroUnit); end);
                bHideLookAtButton = false;
            else
                local cityID = pGameHeroes:GetHeroOriginCityID(kHeroDef.Index);
                local pPlayerCities = Players[claimedByPlayer]:GetCities();
                local pHeroCity = pPlayerCities:FindID(cityID.id);
                if pHeroCity then
                    kHeroInstance.LookAtButton:SetToolTipString(Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_LOOK_AT_CITY_TT"))
                    kHeroInstance.LookAtButton:RegisterCallback(Mouse.eLClick, function() LookAtCity(pHeroCity); end);
                    bHideLookAtButton = false;

                    -- Show the Recall button if the hero isn't alive and can be recalled by the claimed player
                    if not bIsAlive then
                        bHideRecallButton = not UpdateRecallButton(kHeroInstance, kHeroDef.Index, kHeroDef.UnitType,
                            pHeroCity);
                    end
                end
            end
        end
        kHeroInstance.LookAtButton:SetHide(bHideLookAtButton);
        kHeroInstance.FaithRecallButton:SetHide(bHideRecallButton);
    else
        kHeroInstance.HeroStatus:SetText(Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_DISCOVERED_STATE"));
        kHeroInstance.ClaimedByCivIcon.CivIconBacking:SetHide(true);
        kHeroInstance.DeceasedText:SetHide(true);
        kHeroInstance.LookAtButton:SetHide(true);
        kHeroInstance.FaithRecallButton:SetHide(true);
    end
end

-- ===========================================================================
function OpenCivilopediaForHero(sHeroUnitType)
    LuaEvents.GreatPeopleHeroPanel_Close();
    LuaEvents.OpenCivilopedia(sHeroUnitType);
end

-- ===========================================================================
function LookAtUnit(pUnit)
    LuaEvents.GreatPeopleHeroPanel_Close();
    UI.LookAtPlotScreenPosition(pUnit:GetX(), pUnit:GetY(), 0.5, 0.5);
    UI.SelectUnit(pUnit);
end

-- ===========================================================================
function LookAtCity(pCity)
    LuaEvents.GreatPeopleHeroPanel_Close();
    UI.LookAtPlotScreenPosition(pCity:GetX(), pCity:GetY(), 0.5, 0.5);
    UI.SelectCity(pCity);
end

-- ===========================================================================
function UpdateRecallButton(kHeroInstance, eHeroClass, sUnitType, pCity)
    local kHeroUnitDef = GameInfo.Units[sUnitType];
    local kYieldDef = GameInfo.Yields["YIELD_FAITH"];

    local tParameters = {};
    tParameters[CityCommandTypes.PARAM_UNIT_TYPE] = kHeroUnitDef.Hash;
    tParameters[CityCommandTypes.PARAM_YIELD_TYPE] = kYieldDef.Index;
    if CityManager.CanStartCommand(pCity, CityCommandTypes.PURCHASE, true, tParameters, false) then
        local isCanStart, results = CityManager.CanStartCommand(pCity, CityCommandTypes.PURCHASE, false, tParameters,
            true);

        local pCityGold = pCity:GetGold();
        local faithCost = pCityGold:GetPurchaseCost(kYieldDef.Index, kHeroUnitDef.Hash,
            MilitaryFormationTypes.STANDARD_MILITARY_FORMATION);
        kHeroInstance.FaithRecallButton:SetText(faithCost .. "[ICON_Faith]");

        local sToolTip = Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_FAITH_RECALL_TT", faithCost);

        if isCanStart then
            kHeroInstance.FaithRecallButton:RegisterCallback(Mouse.eLClick, function() RecallHero(eHeroClass); end);
            kHeroInstance.FaithRecallButton:SetDisabled(false);
        else
            -- Add failure reasons to the tooltip
            if results ~= nil and results[CityCommandResults.FAILURE_REASONS] ~= nil then
                local kFailureReasons = results[CityCommandResults.FAILURE_REASONS];
                if kFailureReasons ~= nil and table.count(kFailureReasons) > 0 then
                    for i, v in ipairs(kFailureReasons) do
                        sToolTip = sToolTip .. "[NEWLINE][NEWLINE][COLOR:Red]" .. Locale.Lookup(v) .. "[ENDCOLOR]";
                    end
                end
            end

            -- Affordability check
            local pPlayerReligion = Players[pCity:GetOwner()]:GetReligion();
            if pPlayerReligion ~= nil and not pPlayerReligion:CanAfford(pCity:GetID(), kHeroUnitDef.Hash) then
                sToolTip = sToolTip ..
                    "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_GREAT_PEOPLE_HEROES_INSUFFICIENT_FAITH_TT");
            end

            kHeroInstance.FaithRecallButton:SetDisabled(true);
        end

        kHeroInstance.FaithRecallButton:SetToolTipString(sToolTip);

        return true;
    end

    return false;
end

-- ===========================================================================
function RecallHero(eHeroClass)
    local kHeroDef = GameInfo.HeroClasses[eHeroClass];
    local kHeroUnitDef = GameInfo.Units[kHeroDef.UnitType];

    local pGameHeroes = Game.GetHeroesManager();
    local claimedByPlayer = pGameHeroes:GetHeroClaimPlayer(kHeroDef.Index);
    local pPlayerCities = Players[claimedByPlayer]:GetCities();
    local kCityID = pGameHeroes:GetHeroOriginCityID(kHeroDef.Index);
    local pHeroCity = pPlayerCities:FindID(kCityID.id);

    -- Close the panel and look at the city the hero will be spawned in
    LuaEvents.GreatPeopleHeroPanel_Close();
    UI.LookAtPlotScreenPosition(pHeroCity:GetX(), pHeroCity:GetY(), 0.5, 0.5);

    -- Purchase the hero
    local tParameters = {};
    tParameters[CityCommandTypes.PARAM_UNIT_TYPE] = kHeroUnitDef.Hash;
    tParameters[CityCommandTypes.PARAM_MILITARY_FORMATION_TYPE] = MilitaryFormationTypes.STANDARD_MILITARY_FORMATION;
    tParameters[CityCommandTypes.PARAM_YIELD_TYPE] = GameInfo.Yields["YIELD_FAITH"].Index;
    UI.PlaySound("Purchase_With_Faith");
    CityManager.RequestCommand(pHeroCity, CityCommandTypes.PURCHASE, tParameters);
end

-- ===========================================================================
function ClearHeroes()
    if m_pStatIM ~= nil then
        m_pStatIM:ResetInstances();
    end
    if m_pAbilityIM ~= nil then
        m_pAbilityIM:ResetInstances();
    end
    if m_pCommandIM ~= nil then
        m_pCommandIM:ResetInstances();
    end
    if m_pHeroPanelIM ~= nil then
        m_pHeroPanelIM:ResetInstances();
    end
end

-- ===========================================================================
function OnHeroStackSizeChanged()
    LuaEvents.GreatPeopleHeroPanel_SizeChanged(Controls.HeroStack:GetSizeX());
end

-- ===========================================================================
function OnHeroesPopup_ShowNewHero(kHeroDef)
    m_newestHeroType = kHeroDef.HeroClassType;
    LuaEvents.GreatPeopleHeroPanel_Show();
end

-- ===========================================================================
function Initialize()
    -- Set this context to autosize
    ContextPtr:SetAutoSize(true);

    LuaEvents.GreatPeoplePopup_RefreshHeroes.Add(RefreshHeroes);
    LuaEvents.GreatPeoplePopup_ClearHeroes.Add(ClearHeroes);
    LuaEvents.HeroesPopup_ShowNewHero.Add(OnHeroesPopup_ShowNewHero);

    Controls.HeroStack:RegisterSizeChanged(OnHeroStackSizeChanged);
end

Initialize();


print('Load TKH GreatPeopleHeroPanel.lua')
