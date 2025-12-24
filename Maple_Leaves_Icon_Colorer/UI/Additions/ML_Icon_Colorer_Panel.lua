-- ML_Icon_Colorer_Panel
-- Author: yiboy
-- DateCreated: 9/15/2024 12:19:57 PM
--------------------------------------------------------------

--include("GameCapabilities");
include("InstanceManager");
include("SupportFunctions");	--Round
--include("TabSupport");
--include("PopupDialog");
include("ModalScreen_PlayerYieldsHelper");	-- Resizing and top panel vis.
--include("CivilizationIcon");

include("ML_Icon_Colorer_Support");
include("ML_Icon_Colorer_DefaultColors");
-- ===========================================================================
--GameEvents = ExposedMembers.GameEvents;


local COLOR_ML_MUSIC_UNREVEAL_BLACK						= UI.GetColorValueFromHexLiteral(0xFF000000);
local COLOR_ML_MUSIC_UNREVEAL_WHITE						= UI.GetColorValueFromHexLiteral(0xFFFFFFFF);

local debug_mode				=	false;

local wtime						=	os.time()

local m_SpeedMul 				= 	GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier / 100;
local m_IsXP1Active:boolean 	=	Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9");
local m_IsXP2Active:boolean 	= 	Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68");
-- ===========================================================================
local panelIsOpen = false


-- local currentCivType = "CIVILIZATION_EGYPT"
-- local currentCityName = "LOC_CITY_NAME_RA_KEDET"
-- local currentUnitType = "UNIT_BUILDER"
-- local currentLeaderType = "LEADER_CLEOPATRA"

local playerConfig = PlayerConfigurations[Game.GetLocalPlayer()]

local currentCivType = playerConfig:GetCivilizationTypeName()
local currentCityName = "LOC_CITY_NAME_RA_KEDET"
local currentUnitType = "UNIT_BUILDER"
local currentLeaderType = playerConfig:GetLeaderTypeName()


--主要和次要颜色
--<PrimaryColor>COLOR_STANDARD_AQUA_DK</PrimaryColor>
--<SecondaryColor>COLOR_STANDARD_YELLOW_LT</SecondaryColor>

local primary_R = 1
local primary_G = 79
local primary_B = 81
local primary_A = 255

local secondary_R = 234
local secondary_G = 225
local secondary_B = 157
local secondary_A = 255

--非标准颜色的数量
local m_not_standard_color_num = 0

--这其实代表从0开始的256步
local m_rgba_max_step = 255

--0代表默认，1,2,3则代表不同的alt
local current_color_scheme = 0
local current_color_scheme_max_step = 3


--选中的色块
local m_selected_color_type = "COLOR_BLACK"
local m_selected_color_R = 0
local m_selected_color_G = 0
local m_selected_color_B = 0
local m_selected_color_A = 255

--不同配色方案下的主要和次要颜色
--注意，table的下标从1开始
local color_scheme_colors = {
	{
		Primary_ColorType = "COLOR_STANDARD_AQUA_DK",
		Primary_IsStandardColor = true,
		Primary_R = 1,
		Primary_G = 79,
		Primary_B = 81,
		Primary_A = 255,
		Secondary_ColorType = "COLOR_STANDARD_YELLOW_LT",
		Secondary_IsStandardColor = true,
		Secondary_R = 234,
		Secondary_G = 225,
		Secondary_B = 157,
		Secondary_A = 255,
	},
	{
		Primary_ColorType = "COLOR_STANDARD_ORANGE_MD",
		Primary_IsStandardColor = true,
		Primary_R = 255,
		Primary_G = 129,
		Primary_B = 18,
		Primary_A = 255,
		Secondary_ColorType = "COLOR_STANDARD_BLUE_MD",
		Secondary_IsStandardColor = true,
		Secondary_R = 0,
		Secondary_G = 79,
		Secondary_B = 206,
		Secondary_A = 255,
	},
	{
		Primary_ColorType = "COLOR_STANDARD_RED_MD",
		Primary_IsStandardColor = true,
		Primary_R = 202,
		Primary_G = 20,
		Primary_B = 21,
		Primary_A = 255,
		Secondary_ColorType = "COLOR_STANDARD_WHITE_LT",
		Secondary_IsStandardColor = true,
		Secondary_R = 249,
		Secondary_G = 249,
		Secondary_B = 249,
		Secondary_A = 255,
	},
	{
		Primary_ColorType = "COLOR_STANDARD_PURPLE_MD",
		Primary_IsStandardColor = true,
		Primary_R = 109,
		Primary_G = 0,
		Primary_B = 205,
		Primary_A = 255,
		Secondary_ColorType = "COLOR_STANDARD_YELLOW_MD",
		Secondary_IsStandardColor = true,
		Secondary_R = 247,
		Secondary_G = 216,
		Secondary_B = 1,
		Secondary_A = 255,
	},

}
-- <Colors>
-- 	<Row>
-- 		<Type>COLOR_CIVILIZATION_REPUBLIC_OF_CHINA_PRIMARY_BLUE</Type>
-- 		<Color>1,0,171,255</Color>
-- 	</Row>
-- 	<Row>
-- 		<Type>COLOR_CIVILIZATION_REPUBLIC_OF_CHINA_PRIMARY_YELLOW</Type>
-- 		<Color>255,170,0,255</Color>
-- 	</Row>
-- </Colors>

-- <PlayerColors>
-- 	<Row>
-- 		<Type>LEADER_SULEIMAN_ALT</Type>
-- 		<Usage>Unique</Usage>
-- 		<PrimaryColor>COLOR_STANDARD_GREEN_DK</PrimaryColor>
-- 		<SecondaryColor>COLOR_STANDARD_RED_LT</SecondaryColor>
-- 		<Alt1PrimaryColor>COLOR_STANDARD_RED_MD</Alt1PrimaryColor>
-- 		<Alt1SecondaryColor>COLOR_STANDARD_WHITE_LT</Alt1SecondaryColor>
-- 		<Alt2PrimaryColor>COLOR_STANDARD_GREEN_DK</Alt2PrimaryColor>
-- 		<Alt2SecondaryColor>COLOR_STANDARD_WHITE_LT</Alt2SecondaryColor>
-- 		<Alt3PrimaryColor>COLOR_STANDARD_WHITE_LT</Alt3PrimaryColor>
-- 		<Alt3SecondaryColor>COLOR_STANDARD_GREEN_DK</Alt3SecondaryColor>
-- 	</Row>
-- </PlayerColors>

local code_xml_list_colors = {
	'<Colors><Row>',
	'</Row></Colors>'
}

local code_xml_list_playerColors = {
	'<PlayerColors><Row>',
	'</Row></PlayerColors>'
}

local CODE_LANGUAGE = 0 -- 0 SQL, 1 XML

local code_list_part_0 = {
	"--======================================================================",
	"--	COLORS",
	"--======================================================================",
}

local code_list_part_1 = {
	"--	Colors",
	"-------------------------------------",
	"INSERT OR REPLACE INTO Colors",
	"	(Type,		Color)",
	"VALUES",
}

local code_color_line_1 = "	(\"%s\",	\"%d,%d,%d,%d\")"

local code_list_part_2 = {
	"-------------------------------------",
	"--	PlayerColors",
	"-------------------------------------",
	"INSERT OR REPLACE INTO PlayerColors",
	"	(",
	"		Type,",
	"		Usage,",
	"		PrimaryColor,",
	"		SecondaryColor,",
	"		Alt1PrimaryColor,",
	"		Alt1SecondaryColor,",
	"		Alt2PrimaryColor,",
	"		Alt2SecondaryColor,",
	"		Alt3PrimaryColor,",
	"		Alt3SecondaryColor",
	"	)",
	"VALUES",
	"	(",
}

local m_clipboard_codes = ""

-- ===========================================================================

local m_TopPanelHeight		:number			= 0;		-- Used to push vignette below top panel

local m_ColorBlock_IM:table 					= 	InstanceManager:new("ML_IconColorer_Color_Instance",	"ML_IconColorer_Color_Ins_Container",	Controls.ML_IconColorer_Default_Color_Stack);


local m_uiSelected_ColorBlock_Instance:table = nil;

--本地化语言
local m_ui_currentLanguage	= Locale.GetCurrentLanguage().Type;

local m_LocalPlayer							= 	Game.GetLocalPlayer();

-- ===========================================================================
function Realize_IconColorer()
	--print("001")

	Populate_CivilizationIcon()
	Populate_CivIcon_PullDown()
	Populate_UnitIcon()
	Populate_UnitIcon_PullDown()

	Initilize_Color_Slider()
	Populate_Color_Slider()

	Populate_Color_Swap()
	--print("002")

	Populate_Default_Color()

	Populate_Default_Color_Blocks()
	--print("003")

	Populate_Leader_Edit()

	Populate_Color_Scheme()

	Populate_Codes()

	--print("004")

	print("end Realize_IconColorer")

	
end

-- ===========================================================================
function Populate_CivilizationIcon()
	local civItem = GameInfo.Civilizations[currentCivType]
	if civItem == nil then
		print("Error, civilization nil")
	end

	-- Name data
	for row in GameInfo.CityNames() do
		if row.CivilizationType ==  currentCivType then
			currentCityName = row.CityName
			break
		end
	end
	Controls.CityName:SetText(Locale.ToUpper( Locale.Lookup(currentCityName)));

	-- Color
	local m_primaryColor = UI.GetColorValue(primary_R/255, primary_G/255, primary_B/255, primary_A/255)
	local m_secondaryColor = UI.GetColorValue(secondary_R/255, secondary_G/255, secondary_B/255, secondary_A/255)

	local darkerBackColor = UI.DarkenLightenColor(m_primaryColor,-85,100);
	local brighterBackColor = UI.DarkenLightenColor(m_primaryColor,90,255);

	-- Banner and icon colors
	Controls.Banner:SetColor(m_primaryColor);
	Controls.BannerLighter:SetColor(brighterBackColor);
	Controls.BannerDarker:SetColor(darkerBackColor);
	Controls.CircleBacking:SetColor(m_primaryColor);
	Controls.CircleLighter:SetColor(brighterBackColor);
	Controls.CircleDarker:SetColor(darkerBackColor);
	Controls.CityName:SetColor(m_secondaryColor);
	Controls.CivIcon:SetColor(m_secondaryColor);

	Controls.CivIcon:SetIcon("ICON_" .. currentCivType);

end

-- ===========================================================================
function Populate_UnitIcon()
	
	local m_primaryColor = UI.GetColorValue(primary_R/255, primary_G/255, primary_B/255, primary_A/255)
	local m_secondaryColor = UI.GetColorValue(secondary_R/255, secondary_G/255, secondary_B/255, secondary_A/255)

	Controls.FlagBase:SetColor( m_primaryColor );
	Controls.UnitIcon:SetColor( m_secondaryColor );
	Controls.FlagMouseOut:SetColor( m_secondaryColor );
	Controls.FlagMouseOver:SetColor( m_secondaryColor );

	Controls.UnitIcon:SetIcon("ICON_" .. currentUnitType);
end

-- ===========================================================================
function Populate_CivIcon_PullDown()

	local uiButton:object = Controls.ML_IconColorer_CivIcon_PullDown:GetButton();
	local civItem = GameInfo.Civilizations[currentCivType]
	local civName = Locale.Lookup("LOC_ML_ICON_COLORER_PULLDOWN_ERROR")
	if civItem ~= nil then
		civName = Locale.Lookup(civItem.Name)
	end
	uiButton:SetText(civName);

	Controls.ML_IconColorer_CivIcon_PullDown:ClearEntries();

	for row in GameInfo.Civilizations() do
		local civType = row.CivilizationType
		local pEntryInst:object = {};
		Controls.ML_IconColorer_CivIcon_PullDown:BuildEntry( "InstanceOne", pEntryInst );
		pEntryInst.Button:SetText(Locale.Lookup(row.Name));
		pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
			function() 
				Controls.ML_IconColorer_CivIcon_PullDown:GetButton():SetText(Locale.Lookup(row.Name));
				On_SwitchCivilization(civType);
			end 
		);

	end

	Controls.ML_IconColorer_CivIcon_PullDown:CalculateInternals();
end

function On_SwitchCivilization(civType)
	currentCivType = civType
	Populate_CivilizationIcon()
end

-- ===========================================================================
function Populate_UnitIcon_PullDown()
	local uiButton:object = Controls.ML_IconColorer_UnitIcon_PullDown:GetButton();
	local unitItem = GameInfo.Units[currentUnitType]
	local unitName = Locale.Lookup("LOC_ML_ICON_COLORER_PULLDOWN_ERROR")
	if unitItem ~= nil then
		unitName = Locale.Lookup(unitItem.Name)
	end
	uiButton:SetText(unitName);

	Controls.ML_IconColorer_UnitIcon_PullDown:ClearEntries();

	for row in GameInfo.Units() do
		local unitType = row.UnitType
		local pEntryInst:object = {};
		Controls.ML_IconColorer_UnitIcon_PullDown:BuildEntry( "InstanceOne", pEntryInst );
		pEntryInst.Button:SetText(Locale.Lookup(row.Name));
		pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
			function() 
				Controls.ML_IconColorer_UnitIcon_PullDown:GetButton():SetText(Locale.Lookup(row.Name));
				On_SwitchUnit(unitType);
			end 
		);

	end

	Controls.ML_IconColorer_UnitIcon_PullDown:CalculateInternals();

end

function On_SwitchUnit(unitType)
	currentUnitType = unitType
	Populate_UnitIcon()
end

-- ===========================================================================
function Populate_Color_Slider()
    Controls.ML_IconColorer_Primary_R_Slider:SetStep(primary_R)
	Controls.ML_IconColorer_Primary_R_Value:SetText(tostring(primary_R))
	Controls.ML_IconColorer_Primary_G_Slider:SetStep(primary_G)
	Controls.ML_IconColorer_Primary_G_Value:SetText(tostring(primary_G))
	Controls.ML_IconColorer_Primary_B_Slider:SetStep(primary_B)
	Controls.ML_IconColorer_Primary_B_Value:SetText(tostring(primary_B))
	Controls.ML_IconColorer_Primary_A_Slider:SetStep(primary_A)
	Controls.ML_IconColorer_Primary_A_Value:SetText(tostring(primary_A))

	Controls.ML_IconColorer_Secondary_R_Slider:SetStep(secondary_R)
	Controls.ML_IconColorer_Secondary_R_Value:SetText(tostring(secondary_R))
	Controls.ML_IconColorer_Secondary_G_Slider:SetStep(secondary_G)
	Controls.ML_IconColorer_Secondary_G_Value:SetText(tostring(secondary_G))
	Controls.ML_IconColorer_Secondary_B_Slider:SetStep(secondary_B)
	Controls.ML_IconColorer_Secondary_B_Value:SetText(tostring(secondary_B))
	Controls.ML_IconColorer_Secondary_A_Slider:SetStep(secondary_A)
	Controls.ML_IconColorer_Secondary_A_Value:SetText(tostring(secondary_A))
end

function Initilize_Color_Slider()
	Controls.ML_IconColorer_Primary_R_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Primary_R_Slider:SetHide(false)
    Controls.ML_IconColorer_Primary_R_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Primary_R_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(0) end)

	Controls.ML_IconColorer_Primary_G_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Primary_G_Slider:SetHide(false)
    Controls.ML_IconColorer_Primary_G_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Primary_G_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(0) end)

	Controls.ML_IconColorer_Primary_B_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Primary_B_Slider:SetHide(false)
    Controls.ML_IconColorer_Primary_B_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Primary_B_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(0) end)

	Controls.ML_IconColorer_Primary_A_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Primary_A_Slider:SetHide(false)
    Controls.ML_IconColorer_Primary_A_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Primary_A_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(0) end)


	Controls.ML_IconColorer_Secondary_R_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Secondary_R_Slider:SetHide(false)
    Controls.ML_IconColorer_Secondary_R_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Secondary_R_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(1) end)

	Controls.ML_IconColorer_Secondary_G_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Secondary_G_Slider:SetHide(false)
    Controls.ML_IconColorer_Secondary_G_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Secondary_G_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(1) end)

	Controls.ML_IconColorer_Secondary_B_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Secondary_B_Slider:SetHide(false)
    Controls.ML_IconColorer_Secondary_B_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Secondary_B_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(1) end)

	Controls.ML_IconColorer_Secondary_A_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Secondary_A_Slider:SetHide(false)
    Controls.ML_IconColorer_Secondary_A_Slider:SetNumSteps(m_rgba_max_step)
	Controls.ML_IconColorer_Secondary_A_Slider:RegisterSliderCallback(function() On_UpdateColorSlider(1) end)
end
------------ 用户拖动滑块 ------------
function On_UpdateColorSlider(mode)
    primary_R = Controls.ML_IconColorer_Primary_R_Slider:GetStep() 
	primary_G = Controls.ML_IconColorer_Primary_G_Slider:GetStep() 
	primary_B = Controls.ML_IconColorer_Primary_B_Slider:GetStep() 
	primary_A = Controls.ML_IconColorer_Primary_A_Slider:GetStep() 

	secondary_R = Controls.ML_IconColorer_Secondary_R_Slider:GetStep() 
	secondary_G = Controls.ML_IconColorer_Secondary_G_Slider:GetStep() 
	secondary_B = Controls.ML_IconColorer_Secondary_B_Slider:GetStep() 
	secondary_A = Controls.ML_IconColorer_Secondary_A_Slider:GetStep()
	
	if mode == 0 then
		local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE")); 
	elseif mode == 1 then
		local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE"));
	end

	On_UpdateColors()

	Populate_CivilizationIcon()
	Populate_UnitIcon()
end

-- ===========================================================================

function Populate_Color_Swap()
	Controls.ML_IconColorer_Exchange_Color_Button:RegisterCallback(Mouse.eLClick,
		function()
			On_Swap_Color_Button_Clicked()
		end
	)

end

function On_Swap_Color_Button_Clicked()
	primary_R_old = Controls.ML_IconColorer_Primary_R_Slider:GetStep() 
	primary_G_old = Controls.ML_IconColorer_Primary_G_Slider:GetStep() 
	primary_B_old = Controls.ML_IconColorer_Primary_B_Slider:GetStep() 
	primary_A_old = Controls.ML_IconColorer_Primary_A_Slider:GetStep() 

	secondary_R_old = Controls.ML_IconColorer_Secondary_R_Slider:GetStep() 
	secondary_G_old = Controls.ML_IconColorer_Secondary_G_Slider:GetStep() 
	secondary_B_old = Controls.ML_IconColorer_Secondary_B_Slider:GetStep() 
	secondary_A_old = Controls.ML_IconColorer_Secondary_A_Slider:GetStep()

	secondary_R = primary_R_old
	secondary_G = primary_G_old
	secondary_B = primary_B_old
	secondary_A = primary_A_old

	primary_R = secondary_R_old
	primary_G = secondary_G_old
	primary_B = secondary_B_old
	primary_A = secondary_A_old

	On_UpdateColors()

	Populate_CivilizationIcon()
	Populate_UnitIcon()
end
-- ===========================================================================
function Populate_Default_Color()

	local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
	uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE"));
	--uiButton:SetText(Locale.Lookup("LOC_COLOR_STANDARD_AQUA_DK_NAME"));
	Controls.ML_IconColorer_Default_Primary_PullDown:ClearEntries();
	--print("666")
	--print(firaxis_default_colors)
	--print(firaxis_default_colors==nil)
	for key, value in pairs(firaxis_default_colors) do
		--print("key=\t", key)
		--print("value=\t", value)
		local colorType = value.ColorType
		local pEntryInst:object = {};
		Controls.ML_IconColorer_Default_Primary_PullDown:BuildEntry( "InstanceOne", pEntryInst );
		pEntryInst.Button:SetText(Locale.Lookup(value.Name));
		pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
			function() 
				Controls.ML_IconColorer_Default_Primary_PullDown:GetButton():SetText(Locale.Lookup(value.Name));
				On_ApplyPrimaryColor(colorType);
			end 
		);
	end
	Controls.ML_IconColorer_Default_Primary_PullDown:CalculateInternals();

	local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
	uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE"));
	--uiButton:SetText(Locale.Lookup("LOC_COLOR_STANDARD_YELLOW_LT_NAME"));
	Controls.ML_IconColorer_Default_Secondary_PullDown:ClearEntries();
	for key, value in pairs(firaxis_default_colors) do
		local colorType = value.ColorType
		local pEntryInst:object = {};
		Controls.ML_IconColorer_Default_Secondary_PullDown:BuildEntry( "InstanceOne", pEntryInst );
		pEntryInst.Button:SetText(Locale.Lookup(value.Name));
		pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
			function() 
				Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton():SetText(Locale.Lookup(value.Name));
				On_ApplySecondaryColor(colorType);
			end 
		);
	end
	Controls.ML_IconColorer_Default_Secondary_PullDown:CalculateInternals();

	Update_DefaultColorPulldown_NotScheme()

end

function On_ApplyPrimaryColor(colorType)
	for key, value in ipairs(firaxis_default_colors) do
		if value.ColorType == colorType then
			primary_R = value.R
			primary_G = value.G
			primary_B = value.B
			primary_A = value.A
			break
		end
	end
	On_UpdateColors()
	Populate_CivilizationIcon()
	Populate_UnitIcon()

end

function On_ApplySecondaryColor(colorType)
	for key, value in ipairs(firaxis_default_colors) do
		if value.ColorType == colorType then
			secondary_R = value.R
			secondary_G = value.G
			secondary_B = value.B
			secondary_A = value.A
			break
		end
	end
	On_UpdateColors()
	Populate_CivilizationIcon()
	Populate_UnitIcon()

end

function On_UpdateColors()
	--更新当前配色方案下的颜色
	Update_ColorScheme_Colors()

	--更新颜色滑块
	Populate_Color_Slider()

	--更新代码
	Populate_Codes()
end

-- ===========================================================================

function Populate_Default_Color_Blocks()
	m_ColorBlock_IM:DestroyInstances()
	m_uiSelected_ColorBlock_Instance = nil

	for key, value in pairs(firaxis_default_colors) do
		AddColorBlockInst(value)
	end


	Controls.ML_IconColorer_UseAsPrimary_Button:RegisterCallback(Mouse.eLClick,
		function()
			On_UseAsPrimary_Button_Clicked()
		end
	)
	Controls.ML_IconColorer_UseAsSecondary_Button:RegisterCallback(Mouse.eLClick,
		function()
			On_UseAsSecondary_Button_Clicked()
		end
	)

end


function AddColorBlockInst(color_data)
	local new = m_ColorBlock_IM:GetInstance()

	local m_Color = UI.GetColorValue(color_data.R/255, color_data.G/255, color_data.B/255, color_data.A/255)
	--local m_opposite_Color = UI.GetColorValue((255-color_data.R)/255, (255-color_data.G)/255, (255-color_data.B)/255, color_data.A/255)

	new.Color_HightlightIcon:SetColor(m_Color)
	--new.Color_Name:SetColor(m_opposite_Color)

	--只有在中文的时候才显示文字
	--if (m_ui_currentLanguage == "zh_Hans_CN" or m_ui_currentLanguage == "zh_Hant_HK") then
		--new.Color_Name:SetText(Locale.Lookup(color_data.Name))
--
		--
--
		--local m_black_Color = UI.GetColorValue(0/255, 0/255, 0/255, 255/255)
		--local m_white_Color = UI.GetColorValue(249/255, 249/255, 249/255, 255/255)
--
		--if string.find(color_data.ColorType, "_LT") ~= nil then
			--new.Color_Name:SetColor(m_black_Color)
		--else
			--new.Color_Name:SetColor(m_white_Color)
		--end
	--end

	--改为提示信息
	local color_name = Locale.Lookup(color_data.Name)
	local color_value = "[NEWLINE]("..tostring(color_data.R)..","..tostring(color_data.G)..","..tostring(color_data.B)..","..tostring(color_data.A)..")"
	local tooltip = color_name..color_value
	new.Color_Select:SetToolTipString( tooltip );

	--设置色块边框
	if m_selected_color_type == color_data.ColorType then
		m_uiSelected_ColorBlock_Instance = new
		new.Color_Select_BG:SetHide(false);
	end


	new.Color_Select:RegisterCallback(Mouse.eLClick, 
		function() 
			On_ColorBlockSelected(new, color_data)
		end
	)

end

function On_ColorBlockSelected(inst, color_data)

	-- Ignore select if this belief is already selected
	if m_uiSelected_ColorBlock_Instance == inst then
		return;
	end

	-- Unselect the previous selection
	if m_uiSelected_ColorBlock_Instance ~= nil then
		m_uiSelected_ColorBlock_Instance.Color_Select:SetSelected(false);
		m_uiSelected_ColorBlock_Instance.Color_Select_BG:SetHide(true);
		--m_uiSelected_ColorBlock_Instance.PlayerList_DefaultBG:SetAlpha(1)
	end

	-- Select new music instance
	m_uiSelected_ColorBlock_Instance = inst;
	m_uiSelected_ColorBlock_Instance.Color_Select:SetSelected(true);
	m_uiSelected_ColorBlock_Instance.Color_Select_BG:SetHide(false);

	m_selected_color_type = color_data.ColorType
	m_selected_color_R = color_data.R
	m_selected_color_G = color_data.G
	m_selected_color_B = color_data.B
	m_selected_color_A = color_data.A

	--m_uiSelected_ColorBlock_Instance.PlayerList_DefaultBG:SetAlpha(3)

end

function On_UseAsPrimary_Button_Clicked()
	primary_R = m_selected_color_R
	primary_G = m_selected_color_G
	primary_B = m_selected_color_B
	primary_A = m_selected_color_A

	On_UpdateColors()

	Populate_CivilizationIcon()
	Populate_UnitIcon()
	
end

function On_UseAsSecondary_Button_Clicked()
	secondary_R = m_selected_color_R
	secondary_G = m_selected_color_G
	secondary_B = m_selected_color_B
	secondary_A = m_selected_color_A

	On_UpdateColors()

	Populate_CivilizationIcon()
	Populate_UnitIcon()
	
end

-- ===========================================================================
function Populate_Leader_Edit()
	
	Controls.ML_IconColorer_LeaderName_EditBox:SetText(currentLeaderType)

	Controls.ML_IconColorer_LeaderName_EditBox:RegisterStringChangedCallback( On_LeaderName_EditBox_TextChanged );
	Controls.ML_IconColorer_LeaderName_Button:SetDisabled(true)
	Controls.ML_IconColorer_LeaderName_Button:RegisterCallback(Mouse.eLClick,
		function()
			On_LeaderName_Button_Clicked()
		end
	)
	
end

function On_LeaderName_EditBox_TextChanged()
	local editBoxString : string = Controls.ML_IconColorer_LeaderName_EditBox:GetText();
	if editBoxString == nil or editBoxString == "" then
		Controls.ML_IconColorer_LeaderName_Button:SetDisabled(true)
		return 
	end
	Controls.ML_IconColorer_LeaderName_Button:SetDisabled(false)
end

function On_LeaderName_Button_Clicked()
	--print("On_Tab_2_MusicSearch_Button_Clicked()")
	local editBoxString : string = Controls.ML_IconColorer_LeaderName_EditBox:GetText()
	
	currentLeaderType = editBoxString
	
	Controls.ML_IconColorer_LeaderName_Button:SetDisabled(true)

	--更新配色中所有的变量名
	Update_ColorScheme_Colors()

	--更新代码
	Populate_Codes()
end

-- ===========================================================================

function Populate_Color_Scheme()
	--初始化滑块
	Controls.ML_IconColorer_Color_Scheme_Slider:RegisterSliderCallback(function()
        On_Update_Color_Scheme_Slider()
    end)
	Controls.ML_IconColorer_Color_Scheme_Slider:SetEnabled(true)
    Controls.ML_IconColorer_Color_Scheme_Slider:SetHide(false)
    Controls.ML_IconColorer_Color_Scheme_Slider:SetNumSteps(current_color_scheme_max_step)
    Controls.ML_IconColorer_Color_Scheme_Slider:SetStep(current_color_scheme)


end

------------ 用户拖动滑块 ------------
function On_Update_Color_Scheme_Slider()
    local stepNum = Controls.ML_IconColorer_Color_Scheme_Slider:GetStep() 
	current_color_scheme = stepNum

	local modeText;

	if current_color_scheme == 0 then
		modeText = Locale.Lookup("LOC_ML_ICON_COLORER_COLOR_SCHEME_BASE")
	elseif current_color_scheme == 1 then
		modeText = Locale.Lookup("LOC_ML_ICON_COLORER_COLOR_SCHEME_ALT_1")
	elseif current_color_scheme == 2 then
		modeText = Locale.Lookup("LOC_ML_ICON_COLORER_COLOR_SCHEME_ALT_2")
	elseif current_color_scheme == 3 then
		modeText = Locale.Lookup("LOC_ML_ICON_COLORER_COLOR_SCHEME_ALT_3")
	end	

    Controls.ML_IconColorer_Color_Scheme_Detail_Label:SetText( modeText );


	--切换配色方案时，需要同步修改颜色滑块
	local scheme_data = color_scheme_colors[current_color_scheme+1]
	primary_R = scheme_data.Primary_R
	primary_G = scheme_data.Primary_G
	primary_B = scheme_data.Primary_B
	primary_A = scheme_data.Primary_A
	secondary_R = scheme_data.Secondary_R
	secondary_G = scheme_data.Secondary_G
	secondary_B = scheme_data.Secondary_B
	secondary_A = scheme_data.Secondary_A

	--如果是标准色，则注明
	Update_DefaultColorPulldown(scheme_data)

	--更新颜色滑块
	Populate_Color_Slider()

	Populate_CivilizationIcon()
	Populate_UnitIcon()

end

--更新默认颜色pulldown
function Update_DefaultColorPulldown(scheme_data)
	local primary_standard, secondary_standard, primary_standard_type, secondary_standard_type = IsStandardColors(scheme_data)

	if primary_standard then
		local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_"..primary_standard_type.."_NAME")); 
	else
		local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE")); 
	end

	if secondary_standard then
		local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_"..secondary_standard_type.."_NAME"));
	else
		local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE"));
	end
	
end

function Update_DefaultColorPulldown_NotScheme()
	local primary_standard, secondary_standard, primary_standard_type, secondary_standard_type = IsStandardColors_NotScheme()

	if primary_standard then
		local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_"..primary_standard_type.."_NAME")); 
	else
		local uiButton:object = Controls.ML_IconColorer_Default_Primary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE")); 
	end

	if secondary_standard then
		local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_"..secondary_standard_type.."_NAME"));
	else
		local uiButton:object = Controls.ML_IconColorer_Default_Secondary_PullDown:GetButton();
		uiButton:SetText(Locale.Lookup("LOC_ML_ICON_COLORER_CHOOSE_DEFAULT_COLOR_TITLE"));
	end
	
end


function Update_ColorScheme_Colors()
	--分为两部分，一部分是更新颜色值，一部分是检查所有颜色是否标准

	--先更新颜色
	local scheme_data = color_scheme_colors[current_color_scheme+1]

	scheme_data.Primary_R = primary_R
	scheme_data.Primary_G = primary_G
	scheme_data.Primary_B = primary_B
	scheme_data.Primary_A = primary_A
	scheme_data.Secondary_R = secondary_R
	scheme_data.Secondary_G = secondary_G
	scheme_data.Secondary_B = secondary_B
	scheme_data.Secondary_A = secondary_A

	color_scheme_colors[current_color_scheme+1] = scheme_data

	--更新当前scheme下颜色是否标准
	Update_DefaultColorPulldown(scheme_data)

	local not_standard_primary_color_num = 0 
	local not_standard_secondary_color_num = 0 
	--再检查颜色是否标准
	for j=1,4,1 do  
		local scheme_data = color_scheme_colors[j]
		local primary_standard, secondary_standard, primary_standard_type, secondary_standard_type = IsStandardColors(scheme_data)
		scheme_data.Primary_IsStandardColor = primary_standard
		scheme_data.Secondary_IsStandardColor = secondary_standard

		--如果不是标准的，那么需要新增变量名
		--如果是标准的，则修改变量名跟随标准
		if not primary_standard then
			not_standard_primary_color_num = not_standard_primary_color_num + 1
			scheme_data.Primary_ColorType = "COLOR_"..currentLeaderType.."_PRIMARY_"..tostring(not_standard_primary_color_num)
		else
			scheme_data.Primary_ColorType = primary_standard_type
		end
		if not secondary_standard then
			not_standard_secondary_color_num = not_standard_secondary_color_num + 1
			scheme_data.Secondary_ColorType = "COLOR_"..currentLeaderType.."_SECONDARY_"..tostring(not_standard_secondary_color_num)
		else
			scheme_data.Secondary_ColorType = secondary_standard_type
		end
		
	end
	m_not_standard_color_num = not_standard_primary_color_num + not_standard_secondary_color_num

end

function IsStandardColors(scheme_data)
	local primary_standard = false
	local primary_standard_type = "COLOR_PRIMARY_STANDARD"
	local secondary_standard = false
	local secondary_standard_type = "COLOR_SECONDARY_STANDARD"

	for key, value in ipairs(firaxis_default_colors) do
		if value.R == scheme_data.Primary_R and value.G == scheme_data.Primary_G and value.B == scheme_data.Primary_B and value.A == scheme_data.Primary_A then
			primary_standard = true
			primary_standard_type = value.ColorType
		end
		if value.R == scheme_data.Secondary_R and value.G == scheme_data.Secondary_G and value.B == scheme_data.Secondary_B and value.A == scheme_data.Secondary_A then
			secondary_standard = true
			secondary_standard_type = value.ColorType
		end
	end

	return primary_standard, secondary_standard, primary_standard_type, secondary_standard_type

end

function IsStandardColors_NotScheme()
	local primary_standard = false
	local primary_standard_type = "COLOR_PRIMARY_STANDARD"
	local secondary_standard = false
	local secondary_standard_type = "COLOR_SECONDARY_STANDARD"

	for key, value in ipairs(firaxis_default_colors) do
		if value.R == primary_R and value.G == primary_G and value.B == primary_B and value.A == primary_A then
			primary_standard = true
			primary_standard_type = value.ColorType
		end
		if value.R == secondary_R and value.G == secondary_G and value.B == secondary_B and value.A == secondary_A then
			secondary_standard = true
			secondary_standard_type = value.ColorType
		end
	end

	return primary_standard, secondary_standard, primary_standard_type, secondary_standard_type

end

-- ===========================================================================
--每当颜色发生变化，或者领袖名字发生变化的时候，需要更新代码块

function Populate_Codes()
	local m_code_show = ""
	local m_code_copy = ""

	-- for key, value in ipairs(code_list_part_0) do
	-- 	m_code_show = m_code_show .. value .. "[NEWLINE]"
	-- 	m_code_copy= m_code_copy .. value .. "\n"
	-- end

	--如果没有非标准颜色，则无需填Colors表
	if m_not_standard_color_num > 0 then
		for key, value in ipairs(code_list_part_1) do
			m_code_show = m_code_show .. value .. "[NEWLINE]"
			m_code_copy= m_code_copy .. value .. "\n"
		end

		local not_standard_color_num = 0
		for j=1,4,1 do  
			local scheme_data = color_scheme_colors[j]
			if not scheme_data.Primary_IsStandardColor then
				not_standard_color_num = not_standard_color_num + 1
				local primary_line = string.format(code_color_line_1, scheme_data.Primary_ColorType, scheme_data.Primary_R, scheme_data.Primary_G, scheme_data.Primary_B, scheme_data.Primary_A)
				if not_standard_color_num < m_not_standard_color_num then
					m_code_show = m_code_show .. primary_line .."," .. "[NEWLINE]"
					m_code_copy= m_code_copy .. primary_line .."," .. "\n"
				else
					m_code_show = m_code_show .. primary_line ..";" .. "[NEWLINE]"
					m_code_copy= m_code_copy .. primary_line ..";" .. "\n"
				end
			end
			
			if not scheme_data.Secondary_IsStandardColor then
				local secondary_line = string.format(code_color_line_1, scheme_data.Secondary_ColorType, scheme_data.Secondary_R, scheme_data.Secondary_G, scheme_data.Secondary_B, scheme_data.Secondary_A)
				not_standard_color_num = not_standard_color_num + 1
				if not_standard_color_num < m_not_standard_color_num then
					m_code_show = m_code_show .. secondary_line .."," .. "[NEWLINE]"
					m_code_copy= m_code_copy .. secondary_line .."," .. "\n"
				else
					m_code_show = m_code_show .. secondary_line ..";" .. "[NEWLINE]"
					m_code_copy= m_code_copy .. secondary_line ..";" .. "\n"
				end
			end
		end
	end

	for key, value in ipairs(code_list_part_2) do
		m_code_show = m_code_show .. value .. "[NEWLINE]"
		m_code_copy= m_code_copy .. value .. "\n"
	end

	m_code_show = m_code_show .. string.format("		\"%s\",", currentLeaderType) .. "[NEWLINE]"
	m_code_copy= m_code_copy .. string.format("		\"%s\",", currentLeaderType) .. "\n"

	m_code_show = m_code_show .. "		\"Unique\"," .. "[NEWLINE]"
	m_code_copy= m_code_copy .. "		\"Unique\"," .. "\n"

	for j=1,4,1 do  
		local scheme_data = color_scheme_colors[j]
		local primary_color = string.format("		\"%s\",", scheme_data.Primary_ColorType)
		m_code_show = m_code_show .. primary_color .. "[NEWLINE]"
		m_code_copy= m_code_copy .. primary_color .. "\n"

		local secondary_color = string.format("		\"%s\"", scheme_data.Secondary_ColorType)
		if j < 4 then
			m_code_show = m_code_show .. secondary_color .."," .. "[NEWLINE]"
			m_code_copy= m_code_copy .. secondary_color .."," .. "\n"
		else
			m_code_show = m_code_show .. secondary_color .. "[NEWLINE]"
			m_code_copy= m_code_copy .. secondary_color .. "\n"
		end
	end

	m_code_show = m_code_show .. "	);" .. "[NEWLINE]"
	m_code_copy = m_code_copy .. "	);" .. "\n"

	Controls.ML_IconColorer_Code_Content_Label:SetText(m_code_show)
	m_clipboard_codes = m_code_copy


	
	Controls.ML_IconColorer_Copy_Code_Button:RegisterCallback(Mouse.eLClick,
		function()
			On_Copy_Code_Button_Clicked()
		end
	)

	Controls.ML_IconColorer_Switch_Code_Button:RegisterCallback(Mouse.eLClick,
	function()
		On_Swtich_Code_Button_Clicked()
	end
)
end

function On_Swtich_Code_Button_Clicked()

		local xmlc_lipboard_codes = ''
		-- =============================================COLORS
		if m_not_standard_color_num > 0 then
			local not_standard_color_num = 0
			local code_xml_colors = ''
			for j=1,4,1 do
				local scheme_data = color_scheme_colors[j]
				if not scheme_data.Primary_IsStandardColor then
					not_standard_color_num = not_standard_color_num + 1
					if code_xml_colors ~= '' then
						code_xml_colors = code_xml_colors..'\n'
					end
					code_xml_colors = code_xml_colors..'\t<Row>\n'
					code_xml_colors = code_xml_colors..string.format('\t\t<Type>%s</Type>\n', scheme_data.Primary_ColorType)
					code_xml_colors = code_xml_colors..string.format('\t\t<Color>%d,%d,%d,%d</Color>\n', scheme_data.Primary_R, scheme_data.Primary_G, scheme_data.Primary_B, scheme_data.Primary_A)
					code_xml_colors = code_xml_colors..'\t</Row>'
				end
				
				if not scheme_data.Secondary_IsStandardColor then
					if code_xml_colors ~= '' then
						code_xml_colors = code_xml_colors..'\n'
					end
					code_xml_colors = code_xml_colors..'\t<Row>\n'
					code_xml_colors = code_xml_colors..string.format('\t\t<Type>%s</Type>\n', scheme_data.Secondary_ColorType)
					code_xml_colors = code_xml_colors..string.format('\t\t<Color>%d,%d,%d,%d</Color>\n', scheme_data.Secondary_R, scheme_data.Secondary_G, scheme_data.Secondary_B, scheme_data.Secondary_A)
					code_xml_colors = code_xml_colors..'\t</Row>'
				end
			end

			xmlc_lipboard_codes = '<Colors>\n'..code_xml_colors..'\n</Colors>'
		end


		-- ===============================================PLAYER COLORS
		local PlayerColorsString = '<PlayerColors>\n'

		if xmlc_lipboard_codes ~= '' then
			PlayerColorsString = '\n\n'..PlayerColorsString
		end
		PlayerColorsString = PlayerColorsString..'\t<Row>\n'
		PlayerColorsString = PlayerColorsString..'\t\t<Type>'..currentLeaderType..'</Type>\n'
		PlayerColorsString = PlayerColorsString..'\t\t<Usage>Unique</Usage>\n'

		for j=1,4,1 do  
			local scheme_data = color_scheme_colors[j]
			local p_color = ''
			local s_color = ''
			if j == 1 then
				p_color = string.format("\t\t<PrimaryColor>%s</PrimaryColor>", scheme_data.Primary_ColorType)
				s_color = string.format("\t\t<SecondaryColor>%s</SecondaryColor>", scheme_data.Secondary_ColorType)
			else
				p_color = string.format("\t\t<Alt%dPrimaryColor>%s</Alt%dPrimaryColor>", j-1, scheme_data.Primary_ColorType, j-1)
				s_color = string.format("\t\t<Alt%dSecondaryColor>%s</Alt%dSecondaryColor>", j-1, scheme_data.Secondary_ColorType, j-1)
			end
			PlayerColorsString = PlayerColorsString..p_color..'\n'
			PlayerColorsString = PlayerColorsString..s_color..'\n'
		end

		PlayerColorsString = PlayerColorsString..'\t</Row>\n</PlayerColors>'
		xmlc_lipboard_codes = xmlc_lipboard_codes..PlayerColorsString


		-- Controls.ML_IconColorer_Code_Content_Label:SetText(string.sub(xmlc_lipboard_codes, '\n', '[NEWLINE]'))
		UIManager:SetClipboardString(xmlc_lipboard_codes)
end

function On_Copy_Code_Button_Clicked()
	UIManager:SetClipboardString(m_clipboard_codes)
end
-- ===========================================================================
function SetShow_TopPanel()
	if not RefreshYields() then
		Controls.Vignette:SetSizeY(m_TopPanelHeight);
	end
end

-- ===========================================================================
function RefreshTime()

	local format = UserConfiguration.GetClockFormat();
	
	local strTime;
	
	if(format == 1) then
		strTime = os.date("%H:%M");
	else
		strTime = os.date("%I:%M %p");

		-- Remove the leading zero (if any) from 12-hour clock format
		if(string.sub(strTime, 1, 1) == "0") then
			strTime = string.sub(strTime, 2);
		end
	end

	Controls.ML_IconColorer_Time:SetText( strTime );
	local d = Locale.Lookup("{1_Time : datetime full}", os.time());
	Controls.ML_IconColorer_Time:SetToolTipString(d);
end

function On_RefreshTimeTick_Timer()
	RefreshTime();
	Controls.ML_IconColorer_TimeCallback:SetToBeginning();
	Controls.ML_IconColorer_TimeCallback:Play();

end

-- ===========================================================================
function LateInitialize()
	Controls.ML_IconColorer_TimeCallback:RegisterEndCallback( On_RefreshTimeTick_Timer );

end

-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then
        local takeplace = 0
    end
	LateInitialize();
end

function OnShutdown()
	local takeplace = 0
end

function OnInputHandler(pInputStruct:table)
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
		if not ContextPtr:IsHidden() then
			Close();
		end
		return true;
	end
	return false;
end

-- ===========================================================================
function OnTogglePanel()
	if ContextPtr:IsHidden() then
		Open()
		panelIsOpen = true
	else
		Close()
		panelIsOpen = false
	end
end

function Open()
	local localplayer = Game.GetLocalPlayer()
	local pPlayer = Players[localplayer]
	if pPlayer == nil then
		return
	end
	CloseOtherPanels()

	Realize_IconColorer()

	SetShow_TopPanel()

	--ContextPtr:SetHide(false);
	
	if not UIManager:IsInPopupQueue(ContextPtr) then
		-- Queue the screen as a popup, but we want it to render at a desired location in the hierarchy, not on top of everything.
        local kParameters = {};
        kParameters.RenderAtCurrentParent = true;
        kParameters.InputAtCurrentParent = true;
        kParameters.AlwaysVisibleInQueue = true;
        UIManager:QueuePopup(ContextPtr, PopupPriority.Low, kParameters);
        UI.PlaySound("UI_Screen_Open");
    end

	Controls.ScreenAnimIn:SetToBeginning();
	Controls.ScreenAnimIn:Play();

	LuaEvents.MLIconColorer_OpenPanel();	

end

function Close()
	--Refresh_SoundBank();

	if not ContextPtr:IsHidden() then
		UI.PlaySound("UI_Screen_Close");

		--m_Music_IM:DestroyInstances()

	end
		
	UIManager:DequeuePopup(ContextPtr);

	LuaEvents.MLIconColorer_ClosePanel();
	
end

function CloseOtherPanels()
    LuaEvents.LaunchBar_CloseTechTree()
    LuaEvents.LaunchBar_CloseCivicsTree()
    LuaEvents.LaunchBar_CloseGovernmentPanel()
    LuaEvents.LaunchBar_CloseReligionPanel()
    LuaEvents.LaunchBar_CloseGreatPeoplePopup()
    LuaEvents.LaunchBar_CloseGreatWorksOverview()
    if m_IsXP1Active then
        LuaEvents.GovernorPanel_Close()
        LuaEvents.HistoricMoments_Close()
    end
    if m_IsXP2Active then
        LuaEvents.Launchbar_Expansion2_ClimateScreen_Close()
    end
end

-- ===========================================================================
function On_ML_IconColorer_Debug()

end

-- ===========================================================================
function Initialize()
	
	-- UI Events
	ContextPtr:SetHide(true);
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
	ContextPtr:SetInputHandler( OnInputHandler, true );

	Controls.ML_IconColorer_CloseButton:RegisterCallback(Mouse.eLClick, Close)

	
	--Events.TurnBegin.Add(Close)
	LuaEvents.ML_IconColorer_Button_TogglePopup.Add(OnTogglePanel);
	
	LuaEvents.DiplomacyActionView_HideIngameUI.Add(Close)
    LuaEvents.EndGameMenu_Shown.Add(Close)
    LuaEvents.FullscreenMap_Shown.Add(Close)
    LuaEvents.NaturalWonderPopup_Shown.Add(Close)
    LuaEvents.ProjectBuiltPopup_Shown.Add(Close)
    LuaEvents.Tutorial_ToggleInGameOptionsMenu.Add(Close)
    LuaEvents.WonderBuiltPopup_Shown.Add(Close)
    LuaEvents.NaturalDisasterPopup_Shown.Add(Close)  
    LuaEvents.RockBandMoviePopup_Shown.Add(Close)
	LuaEvents.CivicsTree_OpenCivicsTree.Add(Close);	
	LuaEvents.Government_OpenGovernment.Add(Close);
	LuaEvents.GovernorPanel_Opened.Add(Close);	
	LuaEvents.GreatPeople_OpenGreatPeople.Add(Close);
	LuaEvents.GreatWorks_OpenGreatWorks.Add(Close);
	LuaEvents.HistoricMoments_Opened.Add(Close);
	LuaEvents.Religion_OpenReligion.Add(Close);	
	LuaEvents.PantheonChooser_OpenReligion.Add(Close);	
	LuaEvents.TechTree_OpenTechTree.Add(Close);
	LuaEvents.ClimateScreen_Opened.Add(Close);


	m_TopPanelHeight = Controls.Vignette:GetSizeY() - TOP_PANEL_OFFSET;
	

	--Events.LoadGameViewStateDone.Add(initializeDynamicPlayLists)

end

Initialize()
print("Maple_Leaves Icon Colorer UI Panel Initialized!")