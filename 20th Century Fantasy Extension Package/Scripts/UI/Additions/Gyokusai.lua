-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("Civ6Common");


-- Core
include("ContextBase")
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================
GameEvents                  = ExposedMembers.GameEvents;
Utils                       = ExposedMembers.TKKIK.Utils;

local YASUKUNI_INDEX        = GameInfo.Buildings['BUILDING_YASUKUNI'].Index
local HOLY_SIZE_INDEX       = GameInfo.Districts['DISTRICT_HOLY_SITE'].Index

local CITY_NAME_HIROSHIMA   = Locale.Lookup('LOC_CITY_NAME_HIROSHIMA')
local CITY_NAME_NAGASAKI    = Locale.Lookup('LOC_CITY_NAME_NAGASAKI')

local UNIT_CLASS            = {
    'CLASS_RECON',
    'CLASS_MELEE',
    'CLASS_RANGED',
    'CLASS_SIEGE',
    'CLASS_HEAVY_CAVALRY',
    'CLASS_LIGHT_CAVALRY',
    'CLASS_ANTI_CAVALRY',
    'CLASS_RANGED_CAVALRY',
    'CLASS_HEAVY_CHARIOT',
    'CLASS_LIGHT_CHARIOT',
    'CLASS_WARRIOR_MONK'
}

local UNIT_CLASS_YIELD      = {
    CLASS_RECON          = 'FOOD',
    CLASS_MELEE          = 'GOLD',
    CLASS_RANGED         = 'CULTURE',
    CLASS_RANGED_CAVALRY = 'CULTURE',
    CLASS_SIEGE          = 'FAITH',
    CLASS_ANTI_CAVALRY   = 'FAITH',
    CLASS_WARRIOR_MONK   = 'FOOD',
    CLASS_HEAVY_CAVALRY  = 'PRODUCTION',
    CLASS_HEAVY_CHARIOT  = 'PRODUCTION',
    CLASS_LIGHT_CAVALRY  = 'SCIENCE',
    CLASS_LIGHT_CHARIOT  = 'SCIENCE'
}

local UNIT_CLASS_YIELD_TEXT = {
    CLASS_RECON          = ' [ICON_Food] 食物',
    CLASS_MELEE          = ' [ICON_Gold] 金币',
    CLASS_RANGED         = ' [ICON_CULTURE] 文化值',
    CLASS_RANGED_CAVALRY = ' [ICON_CULTURE] 文化值',
    CLASS_SIEGE          = ' [ICON_FAITH] 信仰值',
    CLASS_ANTI_CAVALRY   = ' [ICON_FAITH] 信仰值',
    CLASS_WARRIOR_MONK   = ' [ICON_Food] 食物',
    CLASS_HEAVY_CAVALRY  = ' [ICON_PRODUCTION] 生产力',
    CLASS_HEAVY_CHARIOT  = ' [ICON_PRODUCTION] 生产力',
    CLASS_LIGHT_CAVALRY  = ' [ICON_SCIENCE] 科技值',
    CLASS_LIGHT_CHARIOT  = ' [ICON_SCIENCE] 科技值'
}
-- ===========================================================================
-- VARIABLES
-- ===========================================================================
local m_PlayerWMDCount        = {}
local m_PlayerYasukuni        = {}

local WMDInfo               = {
    cPosX = -1,
    cPosY = -1,
    WMDIndex = -1,
    PlayerID = -1,
    UnitID = -1,
}



-- ===========================================================================
-- Functions
-- ===========================================================================

-- 获取最近拥有靖国神社的城市
function GetClosestYasukuniCity(iPlayerID, iX, iY)
    if m_PlayerYasukuni[iPlayerID] == nil or #m_PlayerYasukuni[iPlayerID] == 0 then
        return nil
    elseif #m_PlayerYasukuni[iPlayerID] == 1 then
        return CityManager.GetCity(iPlayerID, m_PlayerYasukuni[iPlayerID][1].CityID)
    else
        local distance = 9999
        local closestIndex = -1
        for index, value in ipairs(m_PlayerYasukuni[iPlayerID]) do
            local _distance = Map.GetPlotDistance(iX, iY, value.X, value.Y)
            if _distance < distance then
                distance = _distance
                closestIndex = index
            end
        end

        return CityManager.GetCity(iPlayerID, m_PlayerYasukuni[iPlayerID][closestIndex].CityID)
    end
end

function GetAllYasukuni()
    local playerIDs = Utils.GetPlayerIDsByLeaderType('LEADER_HIROHITO')
    if playerIDs ~= nil then
        for _, playerID in ipairs(playerIDs) do
            m_PlayerYasukuni[playerID] = {}
            local cities = Players[playerID]:GetCities()
            for _, city in cities:Members() do
                if city:GetBuildings():HasBuilding(YASUKUNI_INDEX) then
                    local districtHolySite = city:GetDistricts():GetDistrict(HOLY_SIZE_INDEX)
                    if districtHolySite ~= nil then
                        table.insert(m_PlayerYasukuni[playerID],
                            { X = districtHolySite:GetX(), Y = districtHolySite:GetY(), CityID = city:GetID() })
                    end
                end
            end
        end
    end
end

-- 获取当前仍存活玩家核弹数量
function Getm_PlayerWMDCount()
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local player = Players[playerID]
        local playerWMDs = player:GetWMDs();
        m_PlayerWMDCount[playerID] = {}
        for entry in GameInfo.WMDs() do
            m_PlayerWMDCount[playerID][entry.Index] = playerWMDs:GetWeaponCount(entry.Index)
        end
    end
end

function GetTargetCity(tPlayerID, tTimes)
    local cities = Players[tPlayerID]:GetCities()
    for _, tCity in cities:Members() do
        if tTimes == 1 then
            if tCity:GetName() == CITY_NAME_HIROSHIMA then
                return tCity
            end
        elseif tTimes == 2 then
            if tCity:GetName() == CITY_NAME_NAGASAKI then
                return tCity
            end
        end
    end

    local rNum = Utils.GetRandomNumber(cities:GetCount())
    for index, tCity in cities:Members() do
        if index == rNum then
            if tTimes == 1 then
                Utils.SetCityName(tCity:GetOwner(), tCity:GetID(), CITY_NAME_HIROSHIMA)
            elseif tTimes == 2 then
                Utils.SetCityName(tCity:GetOwner(), tCity:GetID(), CITY_NAME_NAGASAKI)
            end
            return tCity
        end
    end
end

function SetWMDActionInfo(iPlayerID, WMDIndex, tPlayerID, times)
    local tCity = GetTargetCity(tPlayerID, times)
    local tCityPlot = Map.GetPlot(tCity:GetX(), tCity:GetY())
    local plots = Map.GetNeighborPlots(tCity:GetX(), tCity:GetY(), 5)

    for i = #plots, 1, -1 do
        local adjPlot = plots[i]
        if adjPlot ~= nil then
            local x, y = adjPlot:GetX(), adjPlot:GetY()
            local cUnitID = Utils.CreateUnit(iPlayerID, 'UNIT_BOMBER', x, y)
            if cUnitID ~= nil then
                -- 修改格位可见性
                Utils.ChangePlotVisibility(iPlayerID, tCityPlot:GetIndex())
                WMDInfo.PlayerID = iPlayerID
                WMDInfo.UnitID = cUnitID
                WMDInfo.WMDIndex = WMDIndex
                WMDInfo.cPosX = tCity:GetX()
                WMDInfo.cPosY = tCity:GetY()
                return true
            end
        end
    end
end

-- ===========================================================================
-- UI Events
-- ===========================================================================
function OnUnitDamageChanged(playerID, unitID, lostHealth, prevLostHealth)
    local playerConfig = PlayerConfigurations[playerID]
    if playerConfig == nil or playerConfig:GetLeaderTypeName() ~= "LEADER_HIROHITO" then
        return
    end

    if m_PlayerYasukuni[playerID] == nil or #m_PlayerYasukuni[playerID] == 0 then
        return
    end

    if lostHealth == 100 then
        local pUnit = UnitManager.GetUnit(playerID, unitID)
        local unitType = GameInfo.Units[pUnit:GetUnitType()].UnitType
        local cCity = GetClosestYasukuniCity(playerID, pUnit:GetX(), pUnit:GetY())
        if cCity ~= nil then
            -- print("最近的城市为 " .. cCity:GetName())
            for item in GameInfo.TypeTags() do
                if item.Type == unitType then
                    if Utils.IsInTable(UNIT_CLASS, item.Tag) then
                        -- print('YIELD = ', UNIT_CLASS_YIELD[item.Tag])
                        local plot = Map.GetPlot(cCity:GetX(), cCity:GetY())
                        GameEvents.SetPlotProperty.Call(plot:GetIndex(),
                            "PROPERTY_YASUKUNI_ADD_YIELD_" .. UNIT_CLASS_YIELD[item.Tag], 1)
                        -- UI.LookAtPlotScreenPosition( cCity:GetX(), cCity:GetY(), 0.42, 0.5 )

                        NotificationManager.SendNotification(playerID, GameInfo.Notifications['NOTIFICATION_YASUKUNI'].Hash,
                            Locale.Lookup('LOC_NOTIFICATION_YASUKUNI'),
                            Locale.Lookup('LOC_NOTIFICATION_YASUKUNI_DESCRIPTION',
                                Locale.Lookup(GameInfo.Units[pUnit:GetUnitType()].Name),
                                Locale.Lookup(cCity:GetName()),
                                UNIT_CLASS_YIELD_TEXT[item.Tag]), cCity:GetX(), cCity:GetY());
                        -- Game.AddWorldViewText(0, , pUnitX, pUnitY)
                        UpdateCityPanel(cCity)
                    end
                end
            end
        end
    end
end

function OnUnitSelectionChanged(playerID, unitID, plotX, plotY, plotZ, bSelected, bEditable)
    if bSelected then
        local pUnit = UnitManager.GetUnit(playerID, unitID)
        local gunbuAbilitCount = Utils.GetAbilityCount(playerID, unitID, "ABILITY_GUNBU")
        local isCurrentUnit = pUnit:GetMovementMovesRemaining() > 0 and gunbuAbilitCount ~= nil and gunbuAbilitCount > 0
        Controls.GyokusaiButton:SetHide(not isCurrentUnit)
    end
end

-- 玉碎按钮功能
function OnGyokusaiButtonClicked()
    local pUnit = UI.GetHeadSelectedUnit()
    if (pUnit ~= nil) then
        local kParameters   = {};
        kParameters.OnStart = "SacrificeUnit"
        kParameters.Flag    = "Gyokusai"
        kParameters.tUnitID = pUnit:GetID()

        UI.RequestPlayerOperation(pUnit:GetOwner(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
        UI.PlaySound("banzaiEffect")
    end
end

function OnWMDCountChanged(playerID, WMDIndex)
    local player = Players[playerID]
    local playerWMDs = player:GetWMDs();
    local hasWMDCount = playerWMDs:GetWeaponCount(WMDIndex)

    if hasWMDCount > 0 and hasWMDCount > m_PlayerWMDCount[playerID][WMDIndex] then
        for _, tPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
            if PlayerConfigurations[tPlayerID]:GetLeaderTypeName() == "LEADER_HIROHITO" then
                local tPlayer = Players[tPlayerID]
                local WMD_TIMES = tPlayer:GetProperty("WMD_ATTACKED_TIMES")

                if WMD_TIMES == nil then
                    GameEvents.SetPlayerProperty.Call(tPlayerID, "WMD_ATTACKED_TIMES", 1)
                    SetWMDActionInfo(playerID, WMDIndex, tPlayerID, 1)
                elseif WMD_TIMES == 1 then
                    GameEvents.SetPlayerProperty.Call(tPlayerID, "WMD_ATTACKED_TIMES", 2)
                    SetWMDActionInfo(playerID, WMDIndex, tPlayerID, 2)
                elseif WMD_TIMES == 2 then
                    GameEvents.SetPlayerProperty.Call(tPlayerID, "WMD_ATTACKED_TIMES", nil)
                end
            end
        end
    else
        m_PlayerWMDCount[playerID][WMDIndex] = hasWMDCount
    end
end

function OnUnitBomoberAddedToMap(playerID, unitID)
    if playerID == WMDInfo.PlayerID and unitID == WMDInfo.UnitID then
        local pUnit = UnitManager.GetUnit(playerID, unitID)
        if pUnit == nil then
            return
        end
        local tParameters = {};
        tParameters[UnitOperationTypes.PARAM_X] = WMDInfo.cPosX;
        tParameters[UnitOperationTypes.PARAM_Y] = WMDInfo.cPosY;
        tParameters[UnitOperationTypes.PARAM_WMD_TYPE] = WMDInfo.WMDIndex;

        local bCan = UnitManager.CanStartOperation(pUnit, UnitOperationTypes.WMD_STRIKE, nil, tParameters)
        if (bCan) then
            UnitManager.RequestOperation(pUnit, UnitOperationTypes.WMD_STRIKE, tParameters);
        end
    end
end

function OnYasukuniConstructed(playerID, cityID, buildingID, plotID, isOriginalConstruction)
    if buildingID ~= YASUKUNI_INDEX then
        return
    end

    m_PlayerYasukuni[playerID] = m_PlayerYasukuni[playerID] or {}
    local plot = Map.GetPlotByIndex(plotID)
    table.insert(m_PlayerYasukuni[playerID], { X = plot:GetX(), Y = plot:GetY(), CityID = cityID })
end

function Initialize()
    local path = '/InGame/UnitPanel/StandardActionsStack'
    local ctrl = ContextPtr:LookUpControl(path)
    if ctrl ~= nil then
        Controls.GyokusaiButton:ChangeParent(ctrl)
    end
    Controls.GyokusaiButton:RegisterCallback(Mouse.eLClick, OnGyokusaiButtonClicked)
    Controls.GyokusaiButton:SetToolTipString(Locale.Lookup("LOC_ACTION_PANEL_GYOUKUSAI_TOOLTIP"))



    if Utils.IsLeaderInGame("LEADER_HIROHITO") then
        GetAllYasukuni()
        Getm_PlayerWMDCount()
        Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
        Events.WMDCountChanged.Add(OnWMDCountChanged)
        Events.UnitAddedToMap.Add(OnUnitBomoberAddedToMap)
        Events.UnitDamageChanged.Add(OnUnitDamageChanged)
        GameEvents.BuildingConstructed.Add(OnYasukuniConstructed)
    end
end

Events.LoadGameViewStateDone.Add(Initialize);
