local OldLouvre = GameInfo.Buildings["BUILDING_PHANTA_LOUVRE"].Index;
local NewLouvre = GameInfo.Buildings["BUILDING_PHANTA_LOUVRE_MUSEUM"].Index;
local LouvreProject = GameInfo.Projects["PROJECT_PHANTA_GRANDE_LOUVRE"].Index
function PhantaLouvreReconstruction(playerID, cityID, orderType, itemType)
    if GameInfo.Projects[itemType] and GameInfo.Projects[itemType].Index ~= LouvreProject then return end
    local pPlayer = Players[playerID]
    local pCities = pPlayer:GetCities()
    local pCity = pCities:FindID(cityID)
    if (not pCity) then return end
    local pCityBuildings = pCity:GetBuildings();
    for row in GameInfo.Buildings() do
        if pCity:GetBuildings():HasBuilding(OldLouvre) then
            local iPlot = pCity:GetBuildings():GetBuildingLocation(OldLouvre)
            pCityBuildings:RemoveBuilding(OldLouvre)
            pCity:GetBuildQueue():CreateIncompleteBuilding(NewLouvre, iPlot, 100)
        end
    end
end

Events.CityProductionCompleted.Add(PhantaLouvreReconstruction)

local iImprovementLouvreSecondTheater = GameInfo.Improvements['IMPROVEMENT_PHANTA_LOUVRE_SECOND_THEATER'].Index;
local iDistrictLouvreSecondTheater    = GameInfo.Districts["DISTRICT_THEATER"].Index
function PhantaCreateDistrictLouvreSecondTheater(PlotX, PlotY, ImprovementID, PlayerID, ResourceID, Unknown1, Unknown2)
    if ImprovementID == iImprovementLouvreSecondTheater then
        local iPlot = Map.GetPlot(PlotX, PlotY)
        local pCity = Cities.GetPlotPurchaseCity(iPlot)
        ImprovementBuilder.SetImprovementType(iPlot, -1, 0)
        pCity:GetBuildQueue():CreateDistrict(iDistrictLouvreSecondTheater, iPlot)
    end
end

Events.ImprovementAddedToMap.Add(PhantaCreateDistrictLouvreSecondTheater);

local iImprovementLouvreSecondEncampment = GameInfo.Improvements['IMPROVEMENT_PHANTA_LOUVRE_SECOND_ENCAMPMENT'].Index;
local iDistrictLouvreSecondEncampment    = GameInfo.Districts["DISTRICT_ENCAMPMENT"].Index
function PhantaCreateDistrictLouvreSecondEncampment(PlotX, PlotY, ImprovementID, PlayerID, ResourceID, Unknown1, Unknown2)
    if ImprovementID == iImprovementLouvreSecondEncampment then
        local iPlot = Map.GetPlot(PlotX, PlotY)
        local pCity = Cities.GetPlotPurchaseCity(iPlot)
        ImprovementBuilder.SetImprovementType(iPlot, -1, 0)
        pCity:GetBuildQueue():CreateDistrict(iDistrictLouvreSecondEncampment, iPlot)
    end
end

Events.ImprovementAddedToMap.Add(PhantaCreateDistrictLouvreSecondEncampment);
