-- ===========================================================================
-- INCLUDE
-- ===========================================================================
include("Civ6Common");
-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

-- ===========================================================================
-- VARIABLES
-- ===========================================================================

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- 判断总督是否解锁某项升级
function IsGovernorHasProtionActivate(pGovernor, protionName)
    for promotionSet in GameInfo.GovernorPromotionSets() do
        if promotionSet.GovernorType == GameInfo.Governors[pGovernor:GetType()].GovernorType then
            local kPromotion = GameInfo.GovernorPromotions[promotionSet.GovernorPromotion];
            if (pGovernor:HasPromotion(kPromotion.Hash)) then
                if (kPromotion.Name == protionName) then
                    return true
                end
            end
        end
    end
    return false
end

-- 判断城市是否有总督的能力
function IsCityHasGovernorWithProtion(pCity, protionName)
    if pCity == nil then
        return false
    end
    pAssignedGovernor = pCity:GetAssignedGovernor()
    if pAssignedGovernor == nil then
        return false
    end
    return IsGovernorHasProtionActivate(pAssignedGovernor, protionName)
end

-- 获取城市内建造信息
function GetProductionInfoOfCity(pCity)
    local pBuildQueue = pCity:GetBuildQueue();
    if pBuildQueue == nil then
        return nil;
    end
    local hash     = pCity:GetBuildQueue():GetCurrentProductionTypeHash()
    local progress = 0;
    local cost     = 0;
    local productionName;


    -- Nothing being produced.
    if hash == 0 then
        return nil
    end

    -- Find the information
    local buildingDef = GameInfo.Buildings[hash];
    local districtDef = GameInfo.Districts[hash];
    local unitDef     = GameInfo.Units[hash];
    local projectDef  = GameInfo.Projects[hash];
    local type        = "";

    if (buildingDef ~= nil) then
        productionName = Locale.Lookup(buildingDef.Name);
        progress       = pBuildQueue:GetBuildingProgress(buildingDef.Index);
        cost           = pBuildQueue:GetBuildingCost(buildingDef.Index);
    elseif (districtDef ~= nil) then
        productionName = Locale.Lookup(districtDef.Name);
        progress       = pBuildQueue:GetDistrictProgress(districtDef.Index);
        cost           = pBuildQueue:GetDistrictCost(districtDef.Index);
    elseif (unitDef ~= nil) then
        productionName = Locale.Lookup(unitDef.Name);
        progress       = pBuildQueue:GetUnitProgress(unitDef.Index);
        cost           = pBuildQueue:GetUnitCost(unitDef.Index);
    elseif (projectDef ~= nil) then
        productionName = Locale.Lookup(projectDef.Name);
        progress       = pBuildQueue:GetProjectProgress(projectDef.Index);
        cost           = pBuildQueue:GetProjectCost(projectDef.Index);
    else
        return nil;
    end


    return {
        Name     = productionName,
        Progress = progress,
        Cost     = cost,
    };
end

function UpdateCityPanel(pCity)
    local tParameters                              = {};
    tParameters[CityCommandTypes.PARAM_FLAGS]      = 1;                  -- Set Ignored
    tParameters[CityCommandTypes.PARAM_YIELD_TYPE] = YieldTypes.CULTURE; -- Yield type
    CityManager.RequestCommand(pCity, CityCommandTypes.SET_FOCUS, tParameters);
end


function GetPlayerCurrentGovernment(playerID: number)
    if playerID == -1 then
        return nil
    end

	local kPlayer		:table = Players[playerID];
	local kPlayerCulture:table = kPlayer:GetCulture();

    local governmentRowId :number = kPlayerCulture:GetCurrentGovernment();
	if governmentRowId ~= -1 then
		return GameInfo.Governments[governmentRowId].GovernmentType;
	else
		return nil
	end
end

