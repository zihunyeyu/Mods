-- LuaScript1
-- Author: hnoyy
-- DateCreated: 7/27/2024 7:48:26 PM
--------------------------------------------------------------


-- SRWW2LuaScript3
-- Author: hnoyy
-- DateCreated: 8/2/2024 11:34:40 PM
--------------------------------------------------------------

local Player_Number_LEADER_LADY_TRIEU = 0;
local Player_Number_LEADER_PHANTA_CAO_CAO = 0;
local Player_Number_LEADER_PHANTA_GONGSUN_DU = 0;
local Player_Number_LEADER_PHANTA_GONGSUN_ZAN = 0;
local Player_Number_LEADER_PHANTA_KONG_RONG = 0;
local Player_Number_LEADER_PHANTA_LIU_BEI = 0;
local Player_Number_LEADER_PHANTA_LIU_BIAO = 0;
local Player_Number_LEADER_PHANTA_LIU_YAN = 0;
local Player_Number_LEADER_PHANTA_LIU_YAO = 0;
local Player_Number_LEADER_PHANTA_LV_BU = 0;
local Player_Number_LEADER_PHANTA_MA_TENG = 0;
local Player_Number_LEADER_PHANTA_MENG_HUO = 0;
local Player_Number_LEADER_PHANTA_SHI_XIE = 0;
local Player_Number_LEADER_PHANTA_SUN_CE = 0;
local Player_Number_LEADER_PHANTA_TAO_QIAN = 0;
local Player_Number_LEADER_PHANTA_YUAN_SHAO = 0;
local Player_Number_LEADER_PHANTA_YUAN_SHU = 0;
local Player_Number_LEADER_PHANTA_ZHANG_LU = 0;


-- NEA 系列城邦领袖
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_FUYU = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_HAIYANGJURCHEN = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_PYU = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_TSUSHIMA = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_YELANG = 0;
local Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_YUEZHI = 0;

-- PHANTA 系列城邦领袖
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_DI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_MEI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI = 0;
local Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU = 0;

--function Initialize()
--end

function InitializeNewGameNEASRSANGUO01()


for j = 0, 53 do


if PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_LADY_TRIEU" then
    Player_LEADER_LADY_TRIEU = Players[j];
    Player_Number_LEADER_LADY_TRIEU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_CAO_CAO" then
    Player_LEADER_PHANTA_CAO_CAO = Players[j];
    Player_Number_LEADER_PHANTA_CAO_CAO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_GONGSUN_DU" then
    Player_LEADER_PHANTA_GONGSUN_DU = Players[j];
    Player_Number_LEADER_PHANTA_GONGSUN_DU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_GONGSUN_ZAN" then
    Player_LEADER_PHANTA_GONGSUN_ZAN = Players[j];
    Player_Number_LEADER_PHANTA_GONGSUN_ZAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_KONG_RONG" then
    Player_LEADER_PHANTA_KONG_RONG = Players[j];
    Player_Number_LEADER_PHANTA_KONG_RONG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_LIU_BEI" then
    Player_LEADER_PHANTA_LIU_BEI = Players[j];
    Player_Number_LEADER_PHANTA_LIU_BEI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_LIU_BIAO" then
    Player_LEADER_PHANTA_LIU_BIAO = Players[j];
    Player_Number_LEADER_PHANTA_LIU_BIAO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_LIU_YAN" then
    Player_LEADER_PHANTA_LIU_YAN = Players[j];
    Player_Number_LEADER_PHANTA_LIU_YAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_LIU_YAO" then
    Player_LEADER_PHANTA_LIU_YAO = Players[j];
    Player_Number_LEADER_PHANTA_LIU_YAO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_LV_BU" then
    Player_LEADER_PHANTA_LV_BU = Players[j];
    Player_Number_LEADER_PHANTA_LV_BU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_MA_TENG" then
    Player_LEADER_PHANTA_MA_TENG = Players[j];
    Player_Number_LEADER_PHANTA_MA_TENG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_MENG_HUO" then
    Player_LEADER_PHANTA_MENG_HUO = Players[j];
    Player_Number_LEADER_PHANTA_MENG_HUO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_SHI_XIE" then
    Player_LEADER_PHANTA_SHI_XIE = Players[j];
    Player_Number_LEADER_PHANTA_SHI_XIE = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_SUN_CE" then
    Player_LEADER_PHANTA_SUN_CE = Players[j];
    Player_Number_LEADER_PHANTA_SUN_CE = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_TAO_QIAN" then
    Player_LEADER_PHANTA_TAO_QIAN = Players[j];
    Player_Number_LEADER_PHANTA_TAO_QIAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_YUAN_SHAO" then
    Player_LEADER_PHANTA_YUAN_SHAO = Players[j];
    Player_Number_LEADER_PHANTA_YUAN_SHAO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_YUAN_SHU" then
    Player_LEADER_PHANTA_YUAN_SHU = Players[j];
    Player_Number_LEADER_PHANTA_YUAN_SHU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_PHANTA_ZHANG_LU" then
    Player_LEADER_PHANTA_ZHANG_LU = Players[j];
    Player_Number_LEADER_PHANTA_ZHANG_LU = j;


	elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_FUYU" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_FUYU = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_FUYU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_HAIYANGJURCHEN" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_HAIYANGJURCHEN = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_HAIYANGJURCHEN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_PYU" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_PYU = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_PYU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_TSUSHIMA" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_TSUSHIMA = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_TSUSHIMA = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_YELANG" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_YELANG = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_YELANG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_NEA_CITYSTATE_YUEZHI" then
    Player_LEADER_MINOR_CIV_NEA_CITYSTATE_YUEZHI = Players[j];
    Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_YUEZHI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_BAIBO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_BYEONHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CANGWU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHEN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_DI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_DI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_DI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_DONGYE = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_FUHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_GOGURYEO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINCHENG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUNAKOKU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_MAHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_MEI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_MEI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_MEI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_OKJEO = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_QINGZHOU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_RUNAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_SHANYUE = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_SOUTHERN_XIONGNU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_WU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_WU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WUXIMAN = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_YAMATAI = j;
elseif PlayerConfigurations[j]:GetLeaderTypeName() == "LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU" then
    Player_LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU = Players[j];
    Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_YIZHOU = j;
			end
		
	end
	-- Players have met
	--local NEA_SR02_CHU_PlotTest = Map.GetPlot(30,14);

	local iWar = WarTypes.FORMAL_WAR;
	
	--local iAlliance = AllianceType.FORMAL_WAR;
	--Players[0]:GetDiplomacy():SetHasMet(1);
	




	

	for jjj = 0, 18 do
		Players[jjj]:GetDiplomacy():SetHasMet(1);
		Players[jjj]:GetDiplomacy():SetHasMet(2);
		Players[jjj]:GetDiplomacy():SetHasMet(3);
		Players[jjj]:GetDiplomacy():SetHasMet(4);
		Players[jjj]:GetDiplomacy():SetHasMet(5);
		Players[jjj]:GetDiplomacy():SetHasMet(6);
		Players[jjj]:GetDiplomacy():SetHasMet(7);
		Players[jjj]:GetDiplomacy():SetHasMet(8);
		Players[jjj]:GetDiplomacy():SetHasMet(9);
		Players[jjj]:GetDiplomacy():SetHasMet(10);

		Players[jjj]:GetDiplomacy():SetHasMet(11);
		Players[jjj]:GetDiplomacy():SetHasMet(12);
		Players[jjj]:GetDiplomacy():SetHasMet(13);
		Players[jjj]:GetDiplomacy():SetHasMet(14);
		Players[jjj]:GetDiplomacy():SetHasMet(15);
		Players[jjj]:GetDiplomacy():SetHasMet(16);
		Players[jjj]:GetDiplomacy():SetHasMet(17);
		Players[jjj]:GetDiplomacy():SetHasMet(18);
	end

	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN, iWar, true);
	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_XIANBEI, iWar, true);
	
	Players[Player_Number_LEADER_PHANTA_MA_TENG]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_QIANG, iWar, true);
	

	Players[Player_Number_LEADER_PHANTA_CAO_CAO]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_TAO_QIAN, iWar, true);

	--Players[Player_Number_LEADER_PHANTA_CAO_CAO]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU, iWar, true);


	Players[Player_Number_LEADER_PHANTA_LIU_BEI]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_TAO_QIAN, 1, true);
	Players[Player_Number_LEADER_PHANTA_LIU_BEI]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_KONG_RONG, 2, true);
	Players[Player_Number_LEADER_PHANTA_TAO_QIAN]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_KONG_RONG, 3, true);
	
	Players[Player_Number_LEADER_PHANTA_LIU_BEI]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_GONGSUN_ZAN, 4, true);
	
	
	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetDiplomacy():SetHasMet(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN);
	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN);
	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN);
	Players[Player_Number_LEADER_PHANTA_GONGSUN_ZAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HEISHAN);




	Players[Player_Number_LEADER_PHANTA_TAO_QIAN]:GetDiplomacy():SetHasMet(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN);
	Players[Player_Number_LEADER_PHANTA_TAO_QIAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN);
	Players[Player_Number_LEADER_PHANTA_TAO_QIAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN);
	Players[Player_Number_LEADER_PHANTA_TAO_QIAN]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_TAISHAN);


	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetDiplomacy():SetHasMet(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);

	--local Player_Number_Dongou_City_State = Map.GetPlot(47,39):GetOwner();

	--Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_Dongou_City_State);
	--Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_Dongou_City_State);
	--Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_Dongou_City_State);
	--Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_Dongou_City_State);
	--Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_Dongou_City_State);

	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHENLIU);
	

	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI);
	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_HENEI);
	
	

	Players[Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_CHIYANG]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_MEI, iWar, true);

	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JINGNAN, iWar, true);


	Players[Player_Number_LEADER_PHANTA_LV_BU]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_CAO_CAO, iWar, true);


	Players[Player_Number_LEADER_PHANTA_LIU_YAN]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_ZHANG_LU, iWar, true);

	Players[Player_Number_LEADER_PHANTA_ZHANG_LU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU);
	Players[Player_Number_LEADER_PHANTA_ZHANG_LU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU);
	Players[Player_Number_LEADER_PHANTA_ZHANG_LU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU);
	Players[Player_Number_LEADER_PHANTA_ZHANG_LU]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_BOZHOU);
	
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetDiplomacy():SetHasMet(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	

	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_NEA_CITYSTATE_WUWAN);
	

	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_JIANGXIA);
	
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG);
	Players[Player_Number_LEADER_PHANTA_LIU_BIAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WANCHENG);
	

	Players[Player_Number_LEADER_PHANTA_SUN_CE]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_YUAN_SHU, 3, true);
	

	Players[Player_Number_LEADER_PHANTA_SUN_CE]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_LIU_YAO, iWar, true);
	Players[Player_Number_LEADER_PHANTA_SUN_CE]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_LIU_BIAO, iWar, true);

	Players[Player_Number_LEADER_PHANTA_SUN_CE]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU, iWar, true);
	Players[Player_Number_LEADER_PHANTA_SUN_CE]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI, iWar, true);


	Players[Player_Number_LEADER_PHANTA_YUAN_SHU]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_LIU_YAO, iWar, true);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHU]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_LIU_BIAO, iWar, true);

	Players[Player_Number_LEADER_PHANTA_YUAN_SHU]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU, iWar, true);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHU]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI, iWar, true);

	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU);
	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU);
	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_WU);
	
	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI);
	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI);
	Players[Player_Number_LEADER_PHANTA_LIU_YAO]:GetInfluence():GiveFreeTokenToPlayer(Player_Number_LEADER_MINOR_CIV_PHANTA_CS_TK_KUAIJI);
	

	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetDiplomacy():DeclareWarOn(Player_Number_LEADER_PHANTA_GONGSUN_ZAN, iWar, true);
	Players[Player_Number_LEADER_PHANTA_YUAN_SHAO]:GetDiplomacy():SetHasAllied(Player_Number_LEADER_PHANTA_CAO_CAO, 2, true);
	
	
	
	--Players[Player_Number_JJS]:GetDiplomacy():SetPermanentAlliance(Player_Number_SZY, true);

	
end

--Initialize();
LuaEvents.NewGameInitialized.Add(InitializeNewGameNEASRSANGUO01);






function NeaSR02CaptureCity(INewplayerID, IOldplayerID, INewcityID, IPiX, IPiY)

--function NeaMVS8CaptureCity(INewplayerID, INewcityID)	
	


	
	
		local pcity=CityManager.GetCity(INewplayerID,INewcityID);
		local pPlayer = Players[INewplayerID];

		
		local NEAOriginalOwner = pcity:GetOriginalOwner();
		local ipcf = PlayerConfigurations[NEAOriginalOwner];
		if (Players[NEAOriginalOwner]:GetCities():GetOriginalCapitalCity()~=pcity) or ipcf:GetCivilizationLevelTypeID() ~= CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV  then
	
		local pcityiX=pcity:GetX();
		local pcityiY=pcity:GetY();
		local pcityPop = pcity:GetPopulation();
		local pcityname = pcity:GetName();


		local NEAdistricttable = {};

		local NEAbuildingtable = {};
		local NEAbuildingLocationtable = {};

		local NEAplottable = {};

		local NEAWonder = {};

		local tpPlot=Map.GetPlot(pcityiX+1, pcityiY+1);
		local jjkl = tpPlot:GetOwner();

		local pCityBldgs:table = pcity:GetBuildings();
		--local pCityBldgsLoca:table = pCityBldgs:GetBuildingLocation();
		--local pCityBldgsSave=pCityBldgs;
		--for buildingInfo in pCityBldgs do
			--local pCityBldgsLoca = pcity:GetBuildings():GetBuildingLocation();
		--end
		--local kCityPlots		:table = Map.GetCityPlots():GetPurchasedPlots( pcity );
	
		for buildingInfo in GameInfo.Buildings() do
			local buildingIndex:number = buildingInfo.Index;
			local buildingType:string = buildingInfo.BuildingType;
			if(pCityBldgs:HasBuilding(buildingIndex)) then
				
				NEAbuildingtable[buildingIndex]=1;
				--NEAbuildingLocationtable[buildingIndex]=pCityBldgsLoca[buildingIndex];
				NEAbuildingLocationtable[buildingIndex]=pCityBldgs:GetBuildingLocation(buildingIndex);
			end
		end

	
		--local kCityPlots		:table = Map.GetCityPlots():GetPurchasedPlots( pcity );
		--pcity:SetName(Locale.Lookup('yeya'))
		

		
		--if pcityiX<10 do
			--xx_l=0;
		--else
			--xx_l=pcityiX-7;
		--end
--
		--if pcityiY<10 do
			--yy_l=0;
		--else
			--yy_l=pcityiX-7;
		--end


		for xx=pcityiX-10,pcityiX+10 do
		NEAdistricttable[xx]={};
		--NEAbuildingtable[xx] = {};
		NEAplottable[xx]={};

		NEAWonder[xx]={};
		
		
			for yy=pcityiY-10,pcityiY+10 do
				local pPlot=Map.GetPlot(xx, yy);

				if pPlot ~= nil then
				--local pDistrict = CityManager.GetDistrictAt(pPlot);
				local pDistrict = pPlot:GetDistrictType();
				
				NEAdistricttable[xx][yy]=pDistrict;

				if NEAdistricttable[xx][yy]~=nil then
					--NEAWonder[xx][yy]=pCityBldgs:GetBuildingsAtLocation(pPlot);
					--local asd:table = pCityBldgs:GetBuildingsAtLocation(pPlot:GetIndex());
					--local pCityBuildings	:table = pcity:GetBuildings();
					--local plotID		:number = pPlot:GetIndex();	
					--local buildingTypes = pCityBuildings:GetBuildingsAtLocation(plotID);
					--local pBuilding = pPlot:GetBuildingType();
				end

				--NEAbuildingtable[xx][yy]= cityBuildings:GetBuildingsAtLocation(pPlot:GetIndex());
				--local AAASDSA = cityBuildings:GetBuildingsAtLocation(pPlot);

				if pPlot:GetOwner()==INewplayerID then
					NEAplottable[xx][yy]=1;
				else
					NEAplottable[xx][yy]=0;
				end

				end
			end
		end

		

		if Players[NEAOriginalOwner]:GetCities():GetOriginalCapitalCity()==pcity then
			CityManager.SetAsOriginalCapital(Players[NEAOriginalOwner]:GetCities():GetCapitalCity());
		end

	

		CityManager.DestroyCity(pcity);
		pPlayer:GetCities():Create(pcityiX, pcityiY);
		--pcity:SetName(Locale.Lookup('LOC_NEACITYNAME_uiuiuiu'))
		--pPlayer:GetCities():Create(3, 7);
		--pPlayer:GetCities():Create(pcityiX-3, pcityiY-3);
		local ppcity=CityManager.GetCityAt(pcityiX, pcityiY);
		ppcity:ChangePopulation(pcityPop-ppcity:GetPopulation());

		--ppcity:SetName('LKN');

		ppcity:SetName(pcityname);
		--ppcity:SetName('231');

		for xx=pcityiX-10,pcityiX+10 do
			for yy=pcityiY-10,pcityiY+10 do
				local pPlot=Map.GetPlot(xx, yy);
				if pPlot ~= nil then
				if NEAplottable[xx][yy]==1 then
					if pPlot:GetOwner()~=INewplayerID then
						WorldBuilder.CityManager():SetPlotOwner(pPlot, ppcity);
					end
					
					--pPlot:SetOwner(pPlayer);
					--pPlot:SetOwner(IPplayerID);
					WorldBuilder.CityManager():CreateDistrict(ppcity, NEAdistricttable[xx][yy], 100, pPlot);
					

					
				end
				end
			end
		end

		
		for buildingInfo in GameInfo.Buildings() do
			local buildingIndex:number = buildingInfo.Index;
			local buildingType:string = buildingInfo.BuildingType;
			--WorldBuilder.CityManager():CreateBuilding(ppcity,buildingIndex,95);
			--WorldBuilder.CityManager():CreateBuilding(ppcity,buildingIndex,100);
			if NEAbuildingtable[buildingIndex]==1 then
				--ppcity:SetName(Locale.Lookup('LOC_NEACITYNAME_NEWNEW'))
				--NEAbuildingtable[buildingIndex]=1;
				--WorldBuilder.CityManager():CreateBuilding(ppcity,buildingIndex,100);

				ppcity:GetBuildQueue():CreateBuilding(buildingIndex,NEAbuildingLocationtable[buildingIndex]);
				
			end

						--ppcity:SetName(Locale.Lookup('LOC_NEACITYNAME_NEWNEW'))
		end


    end



end




function Citynameset05(iPlayerID,iCityID,PlotX,PlotY)
local ipcf = PlayerConfigurations[iPlayerID];

	if ipcf:GetCivilizationLevelTypeID() ~= CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV then
        --local pCity = CityManager.GetCity(iPlayerID,iCityID)
		--pCity:SetName(Locale.Lookup('LOC_NEACITYNAME_TAIPEI'))
		PlotY = 999
    end

	

	local iplotindex = Map.GetPlotIndex(PlotX, PlotY);
	local pCity = CityManager.GetCity(iPlayerID,iCityID)

	

	if pCity:GetName() == 'LOC_NEA_SR02_NEWCITY' or pCity:GetName() == 'LOC_NEA_SR02_NEWCITY_02' or pCity:GetName() =='LOC_CITY_NAME_BLANK' then

		local icityname = GameInfo.NEA_CityName_CP[tostring(iplotindex)].CityName;
		pCity:SetName(Locale.Lookup(icityname))
		Network.BroadcastPlayerInfo();
		Network.BroadcastGameConfig();
		
	end

	
end





GameEvents.CityConquered.Add(NeaSR02CaptureCity);

Events.CityInitialized.Add(Citynameset05);
--Events.CityBuilt.Add(Citynameset05);



--Events.CityRemovedFromMap.Add(NeaMVS8CaptureCity);
--Events.CityRemovedFromMap