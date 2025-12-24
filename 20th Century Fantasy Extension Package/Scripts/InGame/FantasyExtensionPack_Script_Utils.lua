ExposedMembers.GameEvents = GameEvents

ExposedMembers.TKKIK = ExposedMembers.TKKIK or {}
ExposedMembers.TKKIK.Utils = ExposedMembers.TKKIK.Utils or {}
ExposedMembers.TKKIKCore = ExposedMembers.TKKIK or {}
ExposedMembers.TKKIKCore.Utils = ExposedMembers.TKKIK.Utils or {}
Utils = ExposedMembers.TKKIK.Utils
CoreUtils = ExposedMembers.TKKIKCore.Utils


-- =========================GameEvents=========================
GameEvents.SetPlotProperty.Add(function(plotID, propertyName, propertyValue)
    local pPlot = Map.GetPlotByIndex(plotID)
    if pPlot ~= nil then
        pPlot:SetProperty(propertyName, propertyValue)
    end
end)

GameEvents.SetGameProperty.Add(function(propertyName, propertyValue)
    Game.SetProperty(propertyName, propertyValue)
end)

GameEvents.SetPlayerProperty.Add(function(playerID, propertyName, propertyValue)
    local player = Players[playerID]
    player:SetProperty(propertyName, propertyValue)
end)

GameEvents.SetUnitProperty.Add(function(playerID, unitID, propertyName, propertyValue)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit ~= nil then
        pUnit:SetProperty(propertyName, propertyValue)
    end
end)

GameEvents.SetCityProperty.Add(function(playerID, cityID, propertyName, propertyValue)
    local pCity = CityManager.GetCity(playerID, cityID)
    if pCity ~= nil then
        pCity:SetProperty(propertyName, propertyValue)
    end
end)

-- =========================TKKIKCore.Utils=========================
ExposedMembers.TKKIKCore.Utils.DeepCopy = function (object)
    -- 已经复制过的table，key为复制源table，value为复制后的table
    -- 为了防止table中的某个属性为自身时出现死循环
    -- 避免本该是同一个table的属性，在复制时变成2个不同的table(内容同，但是地址关系和原来的不一样了)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= 'table' then -- 非table类型都直接返回
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end 
        local new_table = {}
        lookup_table[object] = new_table
        for k,v in pairs(object) do
            new_table[_copy(k)] = _copy(v) 
        end 
        -- 这里直接拿mt来用是因为一般对table操作不会很粗暴的修改mt的相关内容
        return setmetatable(new_table, getmetatable(object))
    end 
    return _copy(object)                 
end

ExposedMembers.TKKIK.Utils.IsInTable =function (tTable: table, element)
    if tTable == nil or table.count(tTable) == 0 then
        return false
    end
    for _, value in ipairs(tTable) do
        if value == element then
            return true
        end
    end
    return false
end
-- =========================TKKIKCore.Utils=========================


-- =========================TKKIK.Utils=========================

ExposedMembers.TKKIK.Utils.IsLeaderInGame = function (leaderType: string)
    if GameInfo.Leaders[leaderType] == nil then
        return false
    end

    for _, playerID in ipairs(Utils.GetMajorIDs()) do
        local pPlayerConfig = PlayerConfigurations[playerID]
        if pPlayerConfig:GetLeaderTypeName() == leaderType then
            return true
        end
    end

    return false
end

ExposedMembers.TKKIK.Utils.GetPlayerIDsByLeaderType = function (leaderType: string)
    if GameInfo.Leaders[leaderType] == nil then
        return nil
    end
    local playerIDs = {}
    for _, playerID in ipairs(Utils.GetMajorIDs()) do
        local pPlayerConfig = PlayerConfigurations[playerID]
        if pPlayerConfig:GetLeaderTypeName() == leaderType then
            table.insert(playerIDs, playerID)
        end
    end

    return playerIDs
end

ExposedMembers.TKKIK.Utils.HasBuilding = function (iPlayerID, iCityID, buildingIndex)
    local pCity = CityManager.GetCity(iPlayerID, iCityID)
    if pCity ~= nil then
        local cBuildings = pCity:GetBuildings()
        if cBuildings:HasBuilding(buildingIndex) then
            return true
        end
    end

    return false
end

ExposedMembers.TKKIK.Utils.GetBuildingPlotIndex = function (iPlayerID, iCityID, buildingIndex)
    local pCity = CityManager.GetCity(iPlayerID, iCityID)
    if Utils.HasBuilding(iPlayerID, iCityID, buildingIndex) then
        local prereqDistrict = GameInfo.Buildings[buildingIndex].PrereqDistrict
        if prereqDistrict ~= nil then
            local districtIndex = GameInfo.Districts[prereqDistrict].Index
            local x, y = pCity:GetDistricts():GetDistrictLocation(districtIndex)
            local bPlot = Map.GetPlot(x, y)
            if bPlot ~= nil then
                return bPlot:GetIndex()
            end
        end
    end

    return -1
end

ExposedMembers.TKKIK.Utils.ChangeGreatPeoplePointsTotal = function (iPlayerID: number, greatPersonClass: string, amout: number)
    local greatePerson = GameInfo.GreatPersonClasses[greatPersonClass]
    if greatePerson ~= nil and Players[iPlayerID] ~= nil then
        Players[iPlayerID]:GetGreatPeoplePoints():ChangePointsTotal(greatePerson.Index, amout)
    end
end
ExposedMembers.TKKIK.Utils.GetMajorIDs = function ()
    local majorIDs = {}
    for _, player in ipairs(Players) do
        if player:IsMajor() then
            table.insert(majorIDs, player:GetID())
        end
    end
    return majorIDs
end

ExposedMembers.TKKIK.Utils.GetCivAndLeaderName = function (iPlayerID)
    local playerConfig = PlayerConfigurations[iPlayerID];
    return Locale.Lookup(playerConfig:GetCivilizationDescription()), Locale.Lookup(playerConfig:GetLeaderName())
end

ExposedMembers.TKKIK.Utils.PlayerAttachModifierByID =function (iPlayerID: number, modifierID: string)
    local iPlayer = Players[iPlayerID]
    if iPlayer == nil or not (iPlayer:IsMajor() and iPlayer:IsAlive()) then
        return false
    end
    if modifierID ~= nil then
        iPlayer:AttachModifierByID(modifierID)   
    end
end

ExposedMembers.TKKIK.Utils.CreateDistrict = function (iPlayerID, iCityID, districtType, progress, plotIndex)
    local pCity = CityManager.GetCity(iPlayerID, iCityID)
    if pCity == nil then
        return
    end

    local pPlot = Map.GetPlotByIndex(plotIndex)
    if pPlot == nil then
        return 
    end

    local pDistrict = CityManager.GetDistrictAt(pPlot);
    if (pDistrict ~= nil) then
        WorldBuilder.CityManager():RemoveDistrict(pDistrict);
    end

    WorldBuilder.CityManager():CreateDistrict(pCity, districtType, progress, pPlot);
end

ExposedMembers.TKKIK.Utils.CreateUnit = function (iPlayerID, unitType, iX, iY)
    local unit = UnitManager.InitUnit(iPlayerID, unitType, iX, iY)
    if unit ~= nil then
        return unit:GetID()
    end
    return nil
end

ExposedMembers.TKKIK.Utils.KillUnit = function (iPlayerID, iUnitID)
    local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
    if pUnit ~= nil then
        UnitManager.Kill(pUnit)
    end
end

ExposedMembers.TKKIK.Utils.GetAbilityCount = function (iPlayerID, iUnitID, abilityName)
    local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
    if pUnit == nil then
        return
    end
    return pUnit:GetAbility():GetAbilityCount(abilityName);
end

ExposedMembers.TKKIK.Utils.SetCityName = function (iPlayerID, iCityID, newName)
    local city = CityManager.GetCity(iPlayerID, iCityID)
    if city ~= nil then
        city:SetName(newName)
    end
end

ExposedMembers.TKKIK.Utils.ChangePlotVisibility = function (iPlayerID, iPlotIndex)
    local pPlayerVisibility = PlayersVisibility[iPlayerID];
    if(pPlayerVisibility ~= nil) then
        -- 设为1表示完全可见，设0则是已探索但有迷雾
        pPlayerVisibility:ChangeVisibilityCount(iPlotIndex, 1);
    end
end

ExposedMembers.TKKIK.Utils.GetRandomNumber = function (iRange)
    return Game.GetRandNum(iRange) + 1
end

ExposedMembers.TKKIK.Utils.GetNearCitiesInRange = function (playerID, cityID, iRange)
    local player = Players[playerID]
    local cCity = CityManager.GetCity(playerID, cityID)
    if player == nil or cCity == nil then
        return
    end

    local cX, cY = cCity:GetX(), cCity:GetY()

    local cities = player:GetCities()
    local rangeCities = {}
    for _, city in cities:Members() do
        local iX, iY = city:GetX(), city:GetY()
        if Map.GetPlotDistance(cX, cY, iX, iY) <= iRange then
            table.insert(rangeCities, city:GetID())
        end
    end

    return rangeCities
end

ExposedMembers.TKKIK.Utils.GetNearCitiesInRangeByPos = function (playerID, cX, cY, iRange)
    local player = Players[playerID]
    if player == nil then
        return
    end

    local cities = player:GetCities()
    local rangeCities = {}
    for _, city in cities:Members() do
        local iX, iY = city:GetX(), city:GetY()
        if Map.GetPlotDistance(cX, cY, iX, iY) <= iRange then
            table.insert(rangeCities, city:GetID())
        end
    end

    return rangeCities
end

-- =========================TKKIK.Utils=========================

-- 获取pPlayerID攻占tPlayerID的城市ID
function GetConqueredCities(capturerID, ownerID)
    local conqueredCities = {}

    local capturerPlayer = Players[capturerID]
    if capturerPlayer ~= nil and capturerPlayer:IsAlive() then
        local pCities = capturerPlayer:GetCities();
        for _, city in pCities:Members() do
            local originalOwnerID = city:GetOriginalOwner();
            local pOriginalOwner = Players[originalOwnerID];
            if (originalOwnerID == ownerID and pOriginalOwner:IsMajor()) then
                table.insert(conqueredCities, city:GetID())
            end
        end
    end
    return conqueredCities
end

-- 获取玩家所有丢失的城市
function GetPlayerCitiyNum(pPlayerID)
    local pPlayer = Players[pPlayerID]
    if pPlayer == nil or (not pPlayer:IsAlive()) or (not pPlayer:IsMajor()) then
        return -1, -1
    end

    local hasCitiesNum = pPlayer:GetCities():GetCount()

    local lostCitiesNum = 0
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if playerID ~= pPlayerID then
            local conqueredCities = GetConqueredCities(playerID, pPlayerID)
            if conqueredCities ~= nil then
                lostCitiesNum = lostCitiesNum + #conqueredCities[pPlayerID]
            end
        end
    end

    return hasCitiesNum, lostCitiesNum
end


