-- Lua225
-- Author: hnoyy
-- DateCreated: 12/7/2023 1:32:12 AM
--------------------------------------------------------------

function InitializeNewGame()



			--local pCity = Cities.GetCityInPlot(16,55);
			--local ppBuilding_2 = GameInfo.Buildings['BUILDING_OXFORD_UNIVERSITY'];
			Cities.GetCityInPlot(41,37):GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_HULAO_GATE'].Index,3594);
			


			--pCity:SetName(Locale.Lookup('123'))
			--pCity:GetBuildQueue():CreateBuilding(ppBuilding_2.Index,6347);

end


LuaEvents.NewGameInitialized.Add(InitializeNewGame);