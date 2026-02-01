-- UnitFlagManager_TKH
-- Author: PurpleSoul
-- DateCreated: 3/5/2025 8:01:42 PM
--------------------------------------------------------------
print('Load file UnitFlagManager_TKH_BMode.lua')


-- ===========================================================================
--	INCLUDES
-- ===========================================================================
include("UnitFlagManager");
include("UnitFlagManager_BarbarianClansMode"); -- 蛮族氏族模式


-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

local COLOR_RED           = UI.GetColorValue("COLOR_RED");               -- Obtain colors from colorDB (not const or colorAtlas)
local COLOR_YELLOW        = UI.GetColorValue("COLOR_YELLOW");            -- ditto
local COLOR_GREEN         = UI.GetColorValue("COLOR_STANDARD_GREEN_LT"); -- "
local COLOR_WHITE         = UI.GetColorValue("COLOR_WHITE")
local HEALTH_PERCENT_GOOD = 0.8;                                         -- This and above means a unit is still in good shape
local HEALTH_PERCENT_BAD  = 0.4;                                         -- Above this the unit is okay but below it, the unit is considered to be in bad shape


-- ===========================================================================
--	REDRIVE
-- ===========================================================================
local TKH_BMode_UpdateHealth           = UnitFlag.UpdateHealth
local TKH_BMode_UpdateName             = UnitFlag.UpdateName
local TKH_BMode_OnUnitSelectionChanged = OnUnitSelectionChanged
local TKH_BMode_Subscribe              = Subscribe
local TKH_BMode_Unsubscribe            = Unsubscribe

------------------------------------------------------------------
-- Update the health bar.
function UnitFlag.UpdateHealth(self)
	local pUnit = self:GetUnit();
	if pUnit == nil then
		return;
	end

	-- 护甲条
	local armorPercent = 0
	local maxArmor = (pUnit:GetProperty('TKH_MaxArmor') or 0) + (pUnit:GetProperty('TKH_ExtraMaxArmor') or 0)
	local currentArmor = pUnit:GetProperty('TKH_Armor') or 0
	if maxArmor > 0 then
		armorPercent = math.max(math.min((currentArmor / maxArmor), 1), 0)
	end

	if armorPercent == 0 then
		-- 血条
		local healthPercent = 0;
		local maxDamage = pUnit:GetMaxDamage();
		if (maxDamage > 0) then
			healthPercent = math.max(math.min((maxDamage - pUnit:GetDamage()) / maxDamage, 1), 0);
		end
		-- going to damaged state
		if (healthPercent < 1) then
			-- show the bar and the button anim
			self.m_Instance.HealthBarBG:SetHide(false);
			self.m_Instance.HealthBar:SetHide(false);
			self.m_Instance.HealthBarButton:SetHide(false);

			-- hide the normal bg and button
			self.m_Instance.FlagBase:SetHide(true);
			self.m_Instance.NormalButton:SetHide(true);

			if (healthPercent >= HEALTH_PERCENT_GOOD) then
				self.m_Instance.HealthBar:SetColor(COLOR_GREEN);
			elseif (healthPercent >= HEALTH_PERCENT_BAD) then
				self.m_Instance.HealthBar:SetColor(COLOR_YELLOW);
			else
				self.m_Instance.HealthBar:SetColor(COLOR_RED);
			end

			--------------------------------------------------------------------
			-- going to full health
		else
			self.m_Instance.HealthBar:SetColor(COLOR_GREEN);

			-- hide the bar and the button anim
			self.m_Instance.HealthBarBG:SetHide(true);
			self.m_Instance.HealthBarButton:SetHide(true);

			-- show the normal bg and button
			self.m_Instance.NormalButton:SetHide(false);
			self.m_Instance.FlagBase:SetHide(false);
		end

		self.m_Instance.HealthBar:SetPercent(healthPercent);
	else
		if armorPercent <= 1 then
			self.m_Instance.HealthBarBG:SetHide(false);
			self.m_Instance.HealthBar:SetHide(false);
			self.m_Instance.HealthBarButton:SetHide(false);

			self.m_Instance.FlagBase:SetHide(true);
			self.m_Instance.NormalButton:SetHide(true);
			self.m_Instance.HealthBar:SetColor(COLOR_WHITE);
		else
			-- hide the bar and the button anim
			self.m_Instance.HealthBarBG:SetHide(true);
			self.m_Instance.HealthBarButton:SetHide(true);
			-- show the normal bg and button
			self.m_Instance.NormalButton:SetHide(false);
			self.m_Instance.FlagBase:SetHide(false);
		end

		self.m_Instance.HealthBar:SetPercent(armorPercent);
	end
end

------------------------------------------------------------------
-- Update the unit name / tooltip
function UnitFlag.UpdateName(self)
	local pUnit = self:GetUnit();
	if pUnit ~= nil then
		local unitName = pUnit:GetName();
		local pPlayerCfg = PlayerConfigurations[self.m_Player:GetID()];
		local nameString;
		if (GameConfiguration.IsAnyMultiplayer() and pPlayerCfg:IsHuman()) then
			nameString = Locale.Lookup(pPlayerCfg:GetCivilizationShortDescription()) ..
				" (" .. Locale.Lookup(pPlayerCfg:GetPlayerName()) .. ") - " .. Locale.Lookup(unitName);
		else
			nameString = Locale.Lookup(pPlayerCfg:GetCivilizationShortDescription()) ..
				" - " .. Locale.Lookup(unitName);
		end

		local pUnitDef = GameInfo.Units[pUnit:GetUnitType()];
		if pUnitDef then
			local unitTypeName = pUnitDef.Name;
			if unitName ~= unitTypeName then
				nameString = nameString .. " " .. Locale.Lookup("LOC_UNIT_UNIT_TYPE_NAME_SUFFIX", unitTypeName);
			end
		end

		-- display military formation indicator(s)
		local militaryFormation = pUnit:GetMilitaryFormation();
		if self.m_Style == FLAGSTYLE_NAVAL then
			if (militaryFormation == MilitaryFormationTypes.CORPS_FORMATION) then
				nameString = nameString .. TXT_UNITFLAG_FLEET_SUFFIX;
			elseif (militaryFormation == MilitaryFormationTypes.ARMY_FORMATION) then
				nameString = nameString .. TXT_UNITFLAG_ARMADA_SUFFIX;
			end
		else
			if (militaryFormation == MilitaryFormationTypes.CORPS_FORMATION) then
				nameString = nameString .. TXT_UNITFLAG_CORPS_SUFFIX;
			elseif (militaryFormation == MilitaryFormationTypes.ARMY_FORMATION) then
				nameString = nameString .. TXT_UNITFLAG_ARMY_SUFFIX;
			end
		end

		-- DEBUG TEXT FOR SHOWING UNIT ACTIVITY TYPE
		--[[
		local activityType = UnitManager.GetActivityType(pUnit);
		if (activityType == ActivityTypes.ACTIVITY_SENTRY) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_ON_SENTRY;
		elseif (activityType == ActivityTypes.ACTIVITY_INTERCEPT) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_ON_INTERCEPT;
		elseif (activityType == ActivityTypes.ACTIVITY_AWAKE) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_AWAKE;
		elseif (activityType == ActivityTypes.ACTIVITY_HOLD) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_HOLD;
		elseif (activityType == ActivityTypes.ACTIVITY_SLEEP) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_SLEEP;
		elseif (activityType == ActivityTypes.ACTIVITY_HEAL) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_HEALING;
		elseif (activityType == ActivityTypes.NO_ACTIVITY) then
			nameString = nameString .. TXT_UNITFLAG_ACTIVITY_NO_ACTIVITY;
		end
		]] --

		-- display archaeology info
		local idArchaeologyHomeCity = pUnit:GetArchaeologyHomeCity();
		if (idArchaeologyHomeCity ~= 0) then
			local pCity = self.m_Player:GetCities():FindID(idArchaeologyHomeCity);
			if (pCity ~= nil) then
				nameString = nameString ..
					"[NEWLINE]" .. Locale.Lookup("LOC_UNITFLAG_ARCHAEOLOGY_HOME_CITY", pCity:GetName());
				local iGreatWorkIndex = pUnit:GetGreatWorkIndex();
				if (iGreatWorkIndex >= 0) then
					local eGWType = Game.GetGreatWorkType(iGreatWorkIndex);
					local eGWPlayer = Game.GetGreatWorkPlayer(iGreatWorkIndex);
					nameString = nameString ..
						"[NEWLINE]" ..
						Locale.Lookup("LOC_UNITFLAG_ARCHAEOLOGY_ARTIFACT", GameInfo.GreatWorks[eGWType].Name,
							PlayerConfigurations[eGWPlayer]:GetPlayerName());
				end
			end
		end

		-- display religion info
		if (pUnit:GetReligiousStrength() > 0) then
			local eReligion = pUnit:GetReligionType();
			if (eReligion > 0) then
				nameString = nameString .. " (" .. Game.GetReligion():GetName(eReligion) .. ")";
			end
		end

		-- display levy status
		local iLevyTurnsRemaining = GetLevyTurnsRemaining(pUnit);
		if (iLevyTurnsRemaining >= 0 and PlayerConfigurations[pUnit:GetOriginalOwner()] ~= nil) then
			nameString = nameString ..
				"[NEWLI]" ..
				Locale.Lookup("LOC_UNITFLAG_LEVY_ACTIVE", PlayerConfigurations[pUnit:GetOriginalOwner()]:GetPlayerName(),
					iLevyTurnsRemaining);
		end

		-- ========================MODIFIER=====================
		local m_HeroEquipmentManager = Game:GetProperty('HeroEquipmentManager') or {}
		local m_EquipmentManager = Game:GetProperty('EquipmentManager') or {}
		local unitType = GameInfo.Units[pUnit:GetUnitType()].UnitType
		if unitType ~= nil and m_HeroEquipmentManager[unitType] then
			local heroEquipments = m_HeroEquipmentManager[unitType]
			for row in GameInfo.TKH_EquipmentTypes() do
				local e = heroEquipments[row.EquipmentType]
				if e and m_EquipmentManager[e] then
					nameString = nameString .. '[NEWLINE]- ' .. Locale.Lookup(m_EquipmentManager[e].Description)
				end
			end
		end

		-- 护甲值
		local armor = pUnit:GetProperty('TKH_Armor')
		local maxArmor = pUnit:GetProperty('TKH_MaxArmor')
		local extraMaxArmor = pUnit:GetProperty('TKH_ExtraMaxArmor') or 0
		if armor and maxArmor then
			nameString = nameString ..
				'[NEWLINE]- ' .. Locale.Lookup('LOC_TKH_UNIT_ARMOR', armor, maxArmor, extraMaxArmor)
		end

		-- 命中要害 概率

		local basePercent = 0
		if GameInfo.TKH_UnitTypeControlCrit[unitType] ~= nil then
			basePercent = GameInfo.TKH_UnitTypeControlCrit[unitType].Percent or 0
		end
		local percent = basePercent + (pUnit:GetProperty('EXTRA_CRIT_PERCENT') or 0)

		local unitAbilities = pUnit:GetAbility():GetAbilities()
		for _, ability in ipairs(unitAbilities) do
			local abilityType = GameInfo.UnitAbilities[ability].UnitAbilityType
			if abilityType ~= nil then
				local ability_percent = ABILITIES_CRIT_PERCENT[abilityType] or 0
				percent = percent + ability_percent
			end
		end
		if percent > 0 then
			nameString = nameString ..
				'[NEWLINE]- ' .. Locale.Lookup('LOC_TKH_UNIT_CRIT_PERCENT', math.min(100, percent))
		end
		-- ========================MODIFIER=====================

		self.m_Instance.UnitIcon:SetToolTipString(Locale.Lookup(nameString));
	end
end

function OnUnitSelectionChanged(playerID, unitID, hexI, hexJ, hexK, bSelected, bEditable)
	local flagInstance = GetUnitFlag(playerID, unitID);
	if (flagInstance ~= nil) then
		flagInstance:UpdateSelected(bSelected);
		flagInstance:UpdateName();
		flagInstance:UpdateHealth();
	end

	if (bSelected) then
		UpdateIconStack(hexI, hexJ);
	end
end

function OnUnitPropertyChanged(playerID, unitID)
	local flagInstance = GetUnitFlag(playerID, unitID);
	if (flagInstance ~= nil) then
		flagInstance:UpdateSelected(bSelected);
		flagInstance:UpdateName();
		flagInstance:UpdateHealth();
	end
end

function Subscribe()
	TKH_BMode_Subscribe()
	Events.UnitPropertyChanged.Add(OnUnitPropertyChanged)
end

function Unsubscribe()
	TKH_BMode_Unsubscribe()
	Events.UnitPropertyChanged.Remove(OnUnitPropertyChanged)
end
