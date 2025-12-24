
-- ===========================================================================
function GetMilitaryStrengthWithoutTreasury(playerID)
	return Players[playerID]:GetStats():GetMilitaryStrengthWithoutTreasury()
end
-- ===========================================================================
function GetCurrentGovernment(playerID)
	return Players[playerID]:GetCulture():GetCurrentGovernment()
end
-- ===========================================================================
function CityCanProduce(playerID, cityID, buildingID)
	return CityManager.GetCity(playerID, cityID):GetBuildQueue():CanProduce(buildingID, true)
end
-- ===========================================================================
--function CanGetProphet(playerID)
	--local pTimeline = Game.GetGreatPeople():GetTimeline()
	--for i, entry in ipairs(pTimeline) do
		--if GameInfo.GreatPersonClasses[entry.Class].GreatPersonClassType == 'GREAT_PERSON_CLASS_PROPHET' then
			--local earnConditions = Game.GetGreatPeople():GetEarnConditionsText(playerID, entry.Individual)
			--if earnConditions ~= nil and earnConditions ~= "" then
				--return false
			--else
				--return true
			--end
		--end
	--end
	--return false
--end
-- ===========================================================================
function Initialize()
	if ExposedMembers.MYN == nil then
		ExposedMembers.MYN = {}
	end
	if ExposedMembers.ManYuDingZhi == nil then
		ExposedMembers.ManYuDingZhi = {}
	end

	ExposedMembers.MYN.GetMilitaryStrengthWithoutTreasury = GetMilitaryStrengthWithoutTreasury
	ExposedMembers.MYN.GetCurrentGovernment = GetCurrentGovernment
	ExposedMembers.ManYuDingZhi.CityCanProduce = CityCanProduce
	--ExposedMembers.MYN.CanGetProphet = CanGetProphet

end
Initialize();
