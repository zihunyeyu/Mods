-- TTK_ToolkitsCore
-- Author: 10704
-- DateCreated: 2/7/2026 3:32:25 PM
--------------------------------------------------------------

-- ==========================
-- COMMON FUNCTIONS
-- ==========================

--===========================================================================
-- Identity-preserving table serialization by Metalua
-- https://github.com/fab13n/metalua
-- https://github.com/fab13n/metalua/blob/no-dll/src/lib/serialize.lua
--===========================================================================

--------------------------------------------------------------------------------
-- 将一个对象序列化为源代码字符串。这个字符串，当作为参数传递给 loadstring()()，
-- 会返回一个结构上与原始对象完全相同的新对象。目前支持以下类型：
-- * 字符串(string)、数字(number)、布尔值(boolean)、nil
-- * 不带环境变量(upvalues)的函数
-- * 包含上述类型的表。表可以有共享的部分，但目前还不支持递归。
-- 注意：元表(metatables)和环境(environments)不会被保存。
--------------------------------------------------------------------------------

local no_identity = { number = 1, boolean = 1, string = 1, ['nil'] = 1 }
function serialize(x)
    local gensym_max   = 0  -- gensym() 符号生成器的索引index
    local seen_once    = {} -- 记录恰好出现一次的元素的集合(表)
    local multiple     = {} -- 记录出现多次的元素及其变量名的集合(表)
    local nested       = {} -- 临时记录正在遍历中的元素集合(表)
    local nest_points  = {}
    local nest_patches = {}

    local function gensym()
        gensym_max = gensym_max + 1; return gensym_max
    end

    -----------------------------------------------------------------------------
    -- nest_points是在表中直接或间接出现自身的位置。
    -- 例如，所有这些代码块都会在表x中创建nest_points：
    -- "x = { }; x[x] = 1", "x = { }; x[1] = x", "x = { }; x[1] = { y = { x } }"。
    -- 为了处理这些情况，mark_nest_point会创建两个表：
    -- * nest_points [parent]将所有在表parent中创建nest_point的键和值与布尔值`true'关联
    -- * nest_patches包含创建nest point的{ parent, key, value }元组列表。
    --   它们都会在所有其他表操作完成之后被处理。
    --
    -- mark_nest_point (p, k, v)填充表nest_points和nest_patches，记录键/值(k,v)在表parent中创建的nest point。
    -- 它还将`parent'标记为出现多次，因为在修复nest points时将需要多次引用它。
    -----------------------------------------------------------------------------
    local function mark_nest_point(parent, k, v)
        local nk, nv = nested[k], nested[v]
        assert(not nk or seen_once[k] or multiple[k])
        assert(not nv or seen_once[v] or multiple[v])
        local mode = (nk and nv and "kv") or (nk and "k") or ("v")
        local parent_np = nest_points[parent]
        local pair = { k, v }
        if not parent_np then
            parent_np = {}; nest_points[parent] = parent_np
        end
        parent_np[k], parent_np[v] = nk, nv
        table.insert(nest_patches, { parent, k, v })
        seen_once[parent], multiple[parent] = nil, true
    end

    -----------------------------------------------------------------------------
    -- 第一次遍历，列出在 x 中出现多次的表和函数
    -----------------------------------------------------------------------------
    local function mark_multiple_occurences(x)
        if no_identity[type(x)] then return end
        if seen_once[x] then
            seen_once[x], multiple[x] = nil, true
        elseif multiple[x] then -- 已经标记过
        else
            seen_once[x] = true
        end

        if type(x) == 'table' then
            nested[x] = true
            for k, v in pairs(x) do
                if nested[k] or nested[v] then
                    mark_nest_point(x, k, v)
                else
                    mark_multiple_occurences(k)
                    mark_multiple_occurences(v)
                end
            end
            nested[x] = nil
        end
    end

    local dumped    = {} -- 已经在localdefs中输出的多次出现的值
    local localdefs = {} -- 已经输出的本地定义作为源代码行


    -- 互相递归的函数：
    local dump_val, dump_or_ref_val

    --------------------------------------------------------------------
    -- 如果x多次出现，输出本地变量而不是值。
    -- 如果是第一次输出，也将在localdefs中输出内容。
    --------------------------------------------------------------------
    function dump_or_ref_val(x)
        if nested[x] then return 'false' end -- 占位符，用于递归引用
        if not multiple[x] then return dump_val(x) end
        local var = dumped[x]
        if var then return "_[" .. var .. "]" end -- 已经引用
        local val = dump_val(x)                   -- 第一次出现，创建并注册引用
        var = gensym()
        table.insert(localdefs, "_[" .. var .. "]=" .. val)
        dumped[x] = var
        return "_[" .. var .. "]"
    end

    -----------------------------------------------------------------------------
    -- 第二遍，输出对象；多次出现的部分被输出为可以多次引用的本地变量，这些本地变量的输出顺序是合理的；
    -- 在输出嵌套部分时需要特别注意。
    -----------------------------------------------------------------------------
    function dump_val(x)
        local t = type(x)
        if x == nil then
            return 'nil'
        elseif t == "number" then
            return tostring(x)
        elseif t == "string" then
            return string.format("%q", x)
        elseif t == "boolean" then
            return x and "true" or "false"
        elseif t == "function" then
            return string.format("loadstring(%q,'@serialized')", string.dump(x))
        elseif t == "table" then
            local acc        = {}
            local idx_dumped = {}
            local np         = nest_points[x]
            for i, v in ipairs(x) do
                if np and np[v] then
                    table.insert(acc, 'false') -- 占位符
                else
                    table.insert(acc, dump_or_ref_val(v))
                end
                idx_dumped[i] = true
            end
            for k, v in pairs(x) do
                if np and (np[k] or np[v]) then
                    --check_multiple(k); check_multiple(v) -- 强制在localdefs中输出
                elseif not idx_dumped[k] then
                    table.insert(acc, "[" .. dump_or_ref_val(k) .. "] = " .. dump_or_ref_val(v))
                end
            end
            return "{ " .. table.concat(acc, ", ") .. " }"
        else
            error("Can't serialize data of type " .. t)
        end
    end

    local function dump_nest_patches()
        for _, entry in ipairs(nest_patches) do
            local p, k, v = unpack(entry)
            assert(multiple[p])
            local set = dump_or_ref_val(p) .. "[" .. dump_or_ref_val(k) .. "] = " ..
                dump_or_ref_val(v) .. " -- rec "
            table.insert(localdefs, set)
        end
    end

    mark_multiple_occurences(x)
    local toplevel = dump_or_ref_val(x)
    dump_nest_patches()

    if next(localdefs) then
        return "local _={ }\n" ..
            table.concat(localdefs, "\n") ..
            "\nreturn " .. toplevel
    else
        return "return " .. toplevel
    end
end

function deserialize(str) return str and loadstring(str)() or nil end

--- 简易三目运算
---@param condition boolean
---@param a any
---@param b any
function aORb(condition, a, b)
    return (condition and { a } or { b })[1]
end

--- 多重逻辑判断
---@param logicT table @逻辑列表
---@param _or boolean @是否或逻辑
---@return boolean @返回逻辑结果
function MutiLogic(logicT, _or)
    local res
    for _, value in ipairs(logicT) do
        if res == nil then
            res = value
        else
            if _or then
                res = res or value
            else
                res = res and value
            end
        end
    end

    return res
end

---精确小数位数
---@param nNum any
---@param n any
---@return string
function GetPreciseDecimalRound(nNum, n)
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local format = "%." .. n .. "f"
    return string.format(format, nNum)
end

---保留小数
---@param nNum number @输入数值
---@param n number @保留的小数位数
---@return number
function GetPreciseDecimalFloor(nNum, n)
    if type(nNum) ~= "number" then
        return nNum
    end
    n = n or 0
    n = math.floor(n)
    if n < 0 then
        n = 0
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end

-- ==========================
-- TABLE FUNCTIONS
-- ==========================

TableHelper = {}
TableHelper.__add = function(self, otherTable)
    if not type(otherTable) == 'table' then
        return self
    end

    for _, value in pairs(otherTable) do
        if value then
            table.insert(self, value)
        end
    end

    return self
end

TableHelper.Invert = function(self)
    local inverted = {}
    for key, value in pairs(self) do
        inverted[value] = key
    end

    self = inverted
end

-- TableHelper.Filter = function(self, filterFunction)

-- end

function TableHelper:Filter(filterFunction)
    local out = {}
    for k, v in pairs(self) do
        if filterFunction(v, k, self) then out[k] = v end
    end
    self = out
end

TableHelper.Recomprehensions = function(self, func)
    local out = {}
    for key, value in pairs(self) do
        out[key] = func(value)
    end

    return out
end

function TableHelper:IsContains(element)
    for _, v in pairs(self) do
        if v == element then
            return true
        end
    end
    return false
end

function RemoveByLengthEfficient(tbl, conditionFunc)
    local newTable = {}
    for _, item in ipairs(tbl) do
        if not conditionFunc(item) then
            table.insert(newTable, item)
        end
    end
    return newTable
end

--- 通过value输出key
---@param v any
---@param t table
---@param length boolean|nil
function GetKeyByValue(v, t, length)
    local f = true
    if length == false then
        f = length
    end
    if not type(t) == 'table' then
        return nil
    end
    for key, value in pairs(t) do
        if v == value then
            local k = key
            if f then
                while string.len(k) < 20 do
                    k = k .. ' '
                end
            end
            return k
        end
    end

    return nil
end

-- ==========================
-- STRING FUNCTIONS
-- ==========================


---分割字符串
---@param str string @目标字符串
---@param reps string @分隔符
---@return table
function SplitString(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

---提取字符串数字（整数及小数）
---@param input string
---@return number
function ExtractNumbers(input)
    local numbers = {}             -- 用于存储提取的数字
    local pattern = "%-?%d+%.?%d*" -- 匹配整数和小数的正则表达式

    -- 遍历字符串中的所有匹配项
    for number in string.gmatch(input, pattern) do
        -- 将提取的字符串转换为数字并插入表中
        table.insert(numbers, tonumber(number))
    end

    if next(numbers) then
        return numbers[1]
    else
        return 0
    end
end

-- ==========================
-- GAME FUNCTIONS
-- ==========================


--
-- ==========================
function AddWorldViewText(x, y, text, ...)
    local _plot = Map.GetPlot(x, y)
    if not _plot then
        return
    end
    Game.AddWorldViewText(0, Locale.Lookup(text, ...), x, y)
end

function GetBuildingTypes(buildings, plotID)
    local buildingTypes = {}
    if buildings and buildings.GetBuildingsAtLocation then
        buildingTypes = buildings:GetBuildingsAtLocation(plotID)
    end
    return buildingTypes
end

--- 获取城市内的所有巨作
---@param pCity table @城市
---@return table {buildingIndex: {greatWorkIndex, ...}, ...}
function GetGreatWorksInCity(pCity)
    local result = {};
    if pCity then
        local pCityBldgs = pCity:GetBuildings();
        for buildingInfo in GameInfo.Buildings() do
            local buildingIndex = buildingInfo.Index;
            if (pCityBldgs:HasBuilding(buildingIndex)) then
                local numSlots = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
                if (numSlots ~= nil and numSlots > 0) then
                    local greatWorksInBuilding = {};

                    -- populate great works
                    for index = 0, numSlots - 1 do
                        local greatWorkIndex = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
                        if greatWorkIndex ~= -1 then
                            table.insert(greatWorksInBuilding, greatWorkIndex);
                        end
                    end

                    -- create association between building type and great works
                    if table.count(greatWorksInBuilding) > 0 then
                        result[buildingIndex] = greatWorksInBuilding;
                    end
                end
            end
        end
    end
    return result;
end

--- 获取单元格内的所有巨作
---@param plotID any
---@return table {buildingType: {greatWorkInfo, ...}, ...}
function GetGreatWorksInPlot(plotID)
    local result = {}
    local plot = Map.GetPlotByIndex(plotID)
    if not plot then
        return result
    end

    local pCity = Cities.GetPlotPurchaseCity(plot)
    if not pCity then
        return result
    end

    if pCity then
        local pCityBldgs = pCity:GetBuildings();
        local plotBuildings = pCityBldgs:GetBuildingsAtLocation(plotID)
        for _, buildingType in ipairs(plotBuildings) do
            local buildingInfo = GameInfo.Buildings[buildingType]
            if buildingInfo then
                local buildingIndex = buildingInfo.Index;
                local numSlots = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
                if (numSlots ~= nil and numSlots > 0) then
                    local greatWorksInBuilding = {};

                    -- populate great works
                    for index = 0, numSlots - 1 do
                        local greatWorkIndex = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
                        if greatWorkIndex ~= -1 then
                            local greatWorkType = pCityBldgs:GetGreatWorkTypeFromIndex(greatWorkIndex);
                            table.insert(greatWorksInBuilding, GameInfo.GreatWorks[greatWorkType]);
                        end
                    end

                    -- create association between building type and great works
                    if table.count(greatWorksInBuilding) > 0 then
                        result[buildingType] = greatWorksInBuilding;
                    end
                end
            end
        end
    end

    return result
end

---获取城市单元格
---@param playerID number
---@param cityID number
---@return table @[plotIndex, ...]
function GetCityPlots(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)
    if city then
        return Map.GetCityPlots():GetPurchasedPlots(city)
    else
        return {}
    end
end

---获取领袖名（短）
---@param playerID number
---@param length number|nil
---@return string
function GetShortLeaderName(playerID, length)
    local shortLen = length ~= nil and length or 10
    local leaderName = Locale.Lookup(PlayerConfigurations[playerID]:GetLeaderName())
    if #leaderName > shortLen then
        leaderName = string.sub(leaderName, 1, shortLen - 1) .. '...'
    end

    return leaderName
end

--- 获取宗教创建者
function GetReligionFounders()
    local religions = Game.GetReligion():GetReligions() or {}

    -- CustomName	LOC_RELIGION_CATHOLICISM
    -- Religion	2
    -- Beliefs	table: 0000000105486DA0
    -- Founder	0
    local res = {}
    for _, religion in ipairs(religions) do
        -- 用玩家ID（number）作为table的key会导致bug
        res[religion.Religion .. '_'] = religion.Founder
    end

    return res
end

--- 获取玩家游戏参数
---@param playerID number @玩家ID
---@param key string @参数Key
function GetPlayerGameSummary(playerID, key)
    local cTurn = Game.GetCurrentGameTurn()

    for i = 0, GameSummary.GetDataSetCount() - 1, 1 do
        local name = GameSummary.GetDataSetName(i);
        if name == key then
            local gdata = GameSummary.CoalesceDataSet(i, cTurn, cTurn)
            if gdata then
                return gdata[playerID][1]
            else
                return 0
            end
        end
    end

    return 0
end

--- 获取玩家解锁科技数量
---@param playerID number @玩家ID
function GetPlayerUnlockTechCount(playerID)
    local player = Players[playerID]
    local techNums = 0
    for row in GameInfo.Technologies() do
        if player:GetTechs():HasTech(row.Index) then
            techNums = techNums + 1
        end
    end
    return techNums
end

--- 玩家解锁市政数量
---@param playerID number @玩家ID
function GetPlayerUnlockCivicCount(playerID)
    local player = Players[playerID]
    local civicNums = 0
    for row in GameInfo.Civics() do
        if player:GetCulture():HasCivic(row.Index) then
            civicNums = civicNums + 1
        end
    end
    return civicNums
end

---获取城邦GameInfo
---@param civType string
---@return table
function GetCityStateData(civType)
    -- Refresh the cache if needed
    local stateInfo = {}
    local query = "SELECT * from CityStates where CivilizationType = ?";
    local kResults = DB.ConfigurationQuery(query, civType);
    if (kResults) then
        for i, t in ipairs(kResults) do
            for key, value in pairs(t) do
                stateInfo[key] = value
            end
        end
    end
    return stateInfo
end

function GetPlayerRelationshipAmount(playerID, tPlayerID)
    local ms_SelectedPlayer = Players[tPlayerID]
    local selectedPlayerDiplomaticAI = ms_SelectedPlayer:GetDiplomaticAI()
    local toolTips = selectedPlayerDiplomaticAI:GetDiplomaticModifiers(playerID)
    local totalScore = 0

    if (toolTips) then
        table.sort(toolTips, function(a, b)
            return a.Score > b.Score;
        end)
        for i, tip in ipairs(toolTips) do
            local score = tip.Score

            if (score ~= 0) then
                totalScore = totalScore + score
            end
        end
    end

    return math.abs(totalScore)
end

-- 获取玩家所有城市的单元格
function GetPlayerAllCityPlots(playerID)
    local cPlots = {}
    setmetatable(cPlots, TableHelper)
    local player = Players[playerID]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local cityPlots = GetCityPlots(playerID, city:GetID())
        cPlots = cPlots + cityPlots
    end
    return cPlots
end

function GetMinorPlayerInTrade(gPlayerID, rPlayerID)
    if Players[gPlayerID]:IsMajor() and not Players[rPlayerID]:IsMajor() then
        return Players[rPlayerID]
    elseif Players[rPlayerID]:IsMajor() and not Players[gPlayerID]:IsMajor() then
        return Players[gPlayerID]
    end
    return nil
end

--- func desc
---@param plot Plot
function IsPlotSea(plot)
    if plot:IsLake() then
        return false
    end
    local terrainIndex = plot:GetTerrainType() or -1
    -- print(GameInfo.Terrains[terrainIndex].TerrainType)
    if terrainIndex == GameInfo.Terrains['TERRAIN_OCEAN'].Index or terrainIndex == GameInfo.Terrains['TERRAIN_COAST'].Index then
        return true
    end

    return false
end

--- 判断单元格是否有指定建筑
---@param buildingType any
---@param plotIndex any
function IsBuildingInPlot(buildingType, plotIndex)
    local plot = Map.GetPlotByIndex(plotIndex)
    if not plot then
        return false
    end

    local pCity = Cities.GetPlotPurchaseCity(plot)
    if not pCity then
        return false
    end

    local cityBuildings = pCity:GetBuildings();
    if (cityBuildings) then
        local buildingTypes = cityBuildings:GetBuildingsAtLocation(plotIndex);
        for _, type in ipairs(buildingTypes) do
            local building = GameInfo.Buildings[type];
            if building.BuildingType == buildingType then
                return true
            end
        end
    end
    return false
end

--- 为玩家解锁科技
---@param playerID integer
---@param techName string
function UnlockTech(playerID, techName)
    local playerTechs = Players[playerID]:GetTechs();
    local tech = GameInfo.Technologies[techName];
    if (tech ~= nil) then
        playerTechs:SetTech(tech.Index, true)
    end
end

--- 为玩家解锁市政
---@param playerID integer
---@param civicName string
function UnlockCivc(playerID, civicName)
    local playerCulture = Players[playerID]:GetCulture();
    local civic = GameInfo.Civics[civicName];
    if (civic ~= nil) then
        playerCulture:SetCivic(civic.Index, true);
    end
end
