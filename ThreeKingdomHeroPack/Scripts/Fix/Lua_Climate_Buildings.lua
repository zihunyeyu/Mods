-- EffectLua01
-- Author: Bottlep
-- DateCreated: 2/9/2021 11:36:08 PM
--------------------------------------------------------------


local m_NEA_TropicClass = GameInfo.TerrainClasses["TERRAIN_CLASS_TROPIC"].Index

local m_NEA_GrassClass = GameInfo.TerrainClasses["TERRAIN_CLASS_GRASS"].Index

local m_NEA_PlainsClass = GameInfo.TerrainClasses["TERRAIN_CLASS_PLAINS"].Index

local m_NEA_TundraClass = GameInfo.TerrainClasses["TERRAIN_CLASS_TUNDRA"].Index

local m_NEA_AridClass = GameInfo.TerrainClasses["TERRAIN_CLASS_ARID"].Index

local m_NEA_DesertClass = GameInfo.TerrainClasses["TERRAIN_CLASS_DESERT"].Index

local m_NEA_PlateauClass = GameInfo.TerrainClasses["TERRAIN_CLASS_PLATEAU"].Index

local m_NEA_SnowClass = GameInfo.TerrainClasses["TERRAIN_CLASS_SNOW"].Index

local m_NEA_MARINEClass = GameInfo.TerrainClasses["TERRAIN_CLASS_MARINE"].Index

local m_NEA_MEDITERRANEANClass = GameInfo.TerrainClasses["TERRAIN_CLASS_MEDITERRANEAN"].Index

local m_NEA_HUMIDCONTINENTIALClass = GameInfo.TerrainClasses["TERRAIN_CLASS_HUMIDCONTINENTIAL"].Index


function CityClimateBulding(iPlayerID, iCityID, PlotX, PlotY)
	local pPlot = Map.GetPlot(PlotX, PlotY)
	local pCity = CityManager.GetCityAt(PlotX, PlotY)

	local iTerClasIndex = pPlot:GetTerrainClassType()


	if (iTerClasIndex == m_NEA_TropicClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_TROPIC_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_GrassClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_WARM_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_PlainsClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_TEMPERATE_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_TundraClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_COLD_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_AridClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_ARID_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_DesertClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_DESERT_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_PlateauClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_PLATEAU_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_SnowClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_SNOW_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_MARINEClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_MARINE_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_MEDITERRANEANClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_MEDITERRANEAN_CITYBUILDING'].Index);
	elseif (iTerClasIndex == m_NEA_HUMIDCONTINENTIALClass) then
		pCity:GetBuildQueue():CreateBuilding(GameInfo.Buildings['BUILDING_NEA_HUMIDCONTINENTIAL_CITYBUILDING'].Index);
	end
end

function Initialize()
	Events.CityAddedToMap.Add(CityClimateBulding)
end

Events.LoadGameViewStateDone.Add(Initialize);






function UnitClimateManpower(iPlayerID, iUnitID)
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)


	local pUnitAbility = pUnit:GetAbility();


	pUnitAbility:ChangeAbilityCount("ABILITY_NEA_CLIMATE_MANPOWER", 1);
end

function AAUnitClimateManpower(iPlayerID, iUnitID, eAbilityType)
	-- print("ClimateManpower Launch")

	--local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
	local iTerClasIndex = pPlot:GetTerrainClassType()
	local pUnitAbility = pUnit:GetAbility();
	--  and GameInfo.UnitAbilities["ABILITY_NEA_TROPIC_MANPOWER"].Index == nil and GameInfo.UnitAbilities["ABILITY_NEA_WARM_MANPOWER"].Index == nil and GameInfo.UnitAbilities["ABILITY_NEA_TEMPERATE_MANPOWER"].Index == nil and GameInfo.UnitAbilities["ABILITY_NEA_COLD_MANPOWER"].Index == nil and GameInfo.UnitAbilities["ABILITY_NEA_ARID_MANPOWER"].Index == nil and GameInfo.UnitAbilities["ABILITY_NEA_DESERT_MANPOWER"].Index == nil  and GameInfo.UnitAbilities["ABILITY_NEA_PLATEAU_MANPOWER"].Index == nil
	--pUnit:ChangeDamage(3);
	--  and pUnitAbility["ABILITY_NEA_TROPIC_MANPOWER"].Index == nil and pUnitAbility["ABILITY_NEA_WARM_MANPOWER"].Index == nil and pUnitAbility["ABILITY_NEA_TEMPERATE_MANPOWER"].Index == nil and pUnitAbility["ABILITY_NEA_COLD_MANPOWER"].Index == nil and pUnitAbility["ABILITY_NEA_ARID_MANPOWER"].Index == nil and pUnitAbility["ABILITY_NEA_DESERT_MANPOWER"].Index == nil  and pUnitAbility["ABILITY_NEA_PLATEAU_MANPOWER"].Index == nil
	-- GameInfo.UnitAbilities["ABILITY_NEA_CLIMATE_MANPOWER"].Index == eAbilityType and
	if pUnitAbility:GetAbilityCount("ABILITY_NEA_TROPIC_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_WARM_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_TEMPERATE_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_COLD_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_ARID_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_DESERT_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_PLATEAU_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_MARINE_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_MEDITERRANEAN_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_MANPOWER") ~= 1 and pUnitAbility:GetAbilityCount("ABILITY_NEA_SNOW_MANPOWER") ~= 1 then
		if (iTerClasIndex == m_NEA_TropicClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_MANPOWER", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_PENALTY_1", 1);



			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_SNOW_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_SNOW_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_SNOW_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_PENALTY_1", 1);
		elseif (iTerClasIndex == m_NEA_GrassClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_MANPOWER", 1);



			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_BONUS_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_BONUS_1", 1);
		elseif (iTerClasIndex == m_NEA_PlainsClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_MANPOWER", 1);



			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_BONUS_1", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_BONUS_1", 1);
		elseif (iTerClasIndex == m_NEA_TundraClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_MANPOWER", 1);



			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_BONUS_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_PENALTY_1", 1);
		elseif (iTerClasIndex == m_NEA_AridClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_MANPOWER", 1);




			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_PENALTY_1", 1);
		elseif (iTerClasIndex == m_NEA_DesertClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_MANPOWER", 1);





			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_2", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_PENALTY_1", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_BONUS_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_3", 1);

			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			--pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_PENALTY_1", 1);
		elseif (iTerClasIndex == m_NEA_SnowClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_MANPOWER", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_3", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_PENALTY_1", 1);
		elseif (iTerClasIndex == m_NEA_MARINEClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_MANPOWER", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_WARM_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);


			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MARINE_ACCLIMATIZATION_BONUS_1", 1);
		elseif (iTerClasIndex == m_NEA_MEDITERRANEANClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_MANPOWER", 1);



			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_BONUS_1", 1);
		elseif (iTerClasIndex == m_NEA_HUMIDCONTINENTIALClass) then
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_MANPOWER", 1);



			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TEMPERATE_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_COLD_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_ARID_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_DESERT_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_2", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_PLATEAU_ACCLIMATIZATION_PENALTY_3", 1);

			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_HUMIDCONTINENTIAL_ACCLIMATIZATION_BONUS_1", 1);
			pUnitAbility:ChangeAbilityCount("ABILITY_NEA_MEDITERRANEAN_ACCLIMATIZATION_BONUS_1", 1);
		end
	end
end

--GameEvents.UnitCreated.Add(UnitClimateManpower);
Events.UnitAddedToMap.Add(UnitClimateManpower);




Events.UnitAbilityGained.Add(AAUnitClimateManpower)



function NEAOnUnitAddedToMap(playerID, unitID, unitX, unitY)
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	local pPlot = Map.GetPlot(unitX, unitY)
	local iTerClasIndex = pPlot:GetTerrainClassType()
	local pUnitAbility = pUnit:GetAbility();

	pUnit:ChangeDamage(3);
	if (iTerClasIndex == m_NEA_TropicClass) then
		pUnitAbility:ChangeAbilityCount("ABILITY_NEA_TROPIC_MANPOWER", 1);
	end
end
