-- ManYuDingZhi_PS_Pack_1_InGame
-- Author: purple soul
-- DateCreated: 11/3/2024 12:12:52 PM
--------------------------------------------------------------
ExposedMembers.GameEvents = GameEvents
ExposedMembers.PurpleSoul = ExposedMembers.PurpleSoul or {}
ExposedMembers.PurpleSoul.Utils = ExposedMembers.PurpleSoul.Utils or {}
Utils = ExposedMembers.PurpleSoul.Utils
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
-- =========================TKKIK.Utils=========================
ExposedMembers.PurpleSoul.Utils.AddGreatMerchant = function (playerID, greatPersonName, eraTypeName, greatPersonClass)
	local individual = GameInfo.GreatPersonIndividuals[greatPersonName].Hash;		--人名的Hash
	local class = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_MERCHANT"].Hash;	--大商人的Hash
	local era = GameInfo.Eras[eraTypeName].Hash;		--时代的Hash
	local cost = 0;		--出场费
	Game.GetGreatPeople():GrantPerson(individual, class, era, cost, playerID, false);
end
ExposedMembers.PurpleSoul.Utils.IsInTable =function (tTable: table, element)
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
ExposedMembers.PurpleSoul.Utils.GetMajorIDs = function()
    local majorIDs = {}
    for _, player in ipairs(Players) do
        if player:IsMajor() then
            table.insert(majorIDs, player:GetID())
        end
    end
    return majorIDs
end
ExposedMembers.PurpleSoul.Utils.IsLeaderInGame = function(leaderType)
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
ExposedMembers.PurpleSoul.Utils.IsCivilizationInGame = function(civilizationType)
    if GameInfo.Civilizations[civilizationType] == nil then
        return false
    end
    for _, playerID in ipairs(Utils.GetMajorIDs()) do
        local pPlayerConfig = PlayerConfigurations[playerID]
        if pPlayerConfig:GetCivilizationTypeName() == civilizationType then
            return true
        end
    end
    return false
end
ExposedMembers.PurpleSoul.Utils.AttachModifierByIDForPlayer = function(playerID, modifierID)
    local player = Players[playerID]
    if player == nil then
        return
    end
    player:AttachModifierByID(modifierID)
end
ExposedMembers.PurpleSoul.Utils.ChangeGreatPeoplePointsTotal = function(playerID, gpIndex, change)
    local player = Players[playerID]
    if player ~= nil and GameInfo.GreatPersonClasses[gpIndex] ~= nil then
        player:GetGreatPeoplePoints():ChangePointsTotal(gpIndex, change)
    end
end
ExposedMembers.PurpleSoul.Utils.IsLaderType = function(playerID, leaderType)
    local player = Players[playerID]
    local playerConfig = PlayerConfigurations[playerID]
    if player ~= nil and
        player:IsMajor() and
        player:IsAlive() and
        playerConfig:GetLeaderTypeName() == leaderType then
        return true
    end
    return false
end
ExposedMembers.PurpleSoul.Utils.IsCivilizationType = function(playerID, civilizationType)
    local player = Players[playerID]
    local playerConfig = PlayerConfigurations[playerID]
    if player ~= nil and
        player:IsMajor() and
        player:IsAlive() and
        playerConfig:GetCivilizationTypeName() == civilizationType then
        return true
    end
    return false
end
ExposedMembers.PurpleSoul.Utils.SetImprovementType = function(plotIndx, improvementIndex, playerID)
    local plot = Map.GetPlotByIndex(plotIndx)
    if plot then
        ImprovementBuilder.SetImprovementType(plot, improvementIndex, playerID)
    end
    return false
end
-- ExposedMembers.PurpleSoul.Utils.GetImprovementCountInCityByIndex = function(playerID, cityID, improvementIndex)
--     local pCity = CityManager.GetCity(playerID, cityID)
--     if pCity == nil or GameInfo.Improvements[improvementIndex] == nil then
--         return 0
--     end
--     local impCount = 0
--     local pCityPlots = pCity:GetOwnedPlots();
--     for k, kPlot in ipairs(pCityPlots) do
--         if kPlot:GetImprovementType() == improvementIndex then
--             impCount = impCount + 1
--         end
--     end
--     return impCount
-- end
-- ExposedMembers.PurpleSoul.Utils.GetImprovementCountInCityByType = function(playerID, cityID, improvementType)
--     local pCity = CityManager.GetCity(playerID, cityID)
--     if pCity == nil or GameInfo.Improvements[improvementType] == nil then
--         return 0
--     end
--     local improvementIndex = GameInfo.Improvements[improvementType].Index
--     local impCount = 0
--     local pCityPlots = pCity:GetOwnedPlots();
--     for k, kPlot in ipairs(pCityPlots) do
--         if kPlot:GetImprovementType() == improvementIndex then
--             impCount = impCount + 1
--         end
--     end
--     return impCount
-- end
