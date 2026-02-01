include('TKH_Constant')

-- ===========================================================================
--	CONSTANTS	/ DEFINES
-- ===========================================================================

-- ===========================================================================
--	CORE LUA
-- ===========================================================================

---获取table长度
---@param pTable table|any
---@return number
function GetTableLength(pTable)
    if not type(pTable) == 'table' then
        return 0
    end

    local length = 0
    for _, value in pairs(pTable) do
        if value then
            length = length + 1
        end
    end

    return length
end

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

--- element是否在table内
---@param tTable table
---@param element any
function IsInTable(tTable, element)
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

-- Return the first index with the given value (or nil if not found).
function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function GetRandomTableElement(tTable)
    if tTable == nil or table.count(tTable) == 0 then
        return nil
    end
    math.randomseed(GetRandomSeed())
    local index = math.random(1, #tTable)
    return tTable[index]
end

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

-- ===========================================================================
--	Helper Functions
-- ===========================================================================

function BaseCheck(eOwner, iUnitID, parameters)
    local pPlayer = Players[eOwner];
    if not pPlayer then
        print("ERROR: Missing player object");
        return false;
    end

    local pUnit = pPlayer:GetUnits():FindID(iUnitID);
    if not pUnit then
        print("ERROR: Missing unit object");
        return false;
    end

    if not parameters[UnitCommandTypes.PARAM_X] or not parameters[UnitCommandTypes.PARAM_Y] then
        print("ERROR: Missing target plot x/y");
        return false;
    end

    local targetPlot = Map.GetPlot(parameters[UnitCommandTypes.PARAM_X], parameters[UnitCommandTypes.PARAM_Y]);
    -- if not targetPlot and not targetPlot:IsUnit() then
    --     print("ERROR: Invalid target plot");
    --     return false;
    -- end

    if not targetPlot then
        print("ERROR: Invalid target plot");
        return false;
    end

    return true, pPlayer, pUnit, targetPlot;
end

function BaseVisibleCheck(pUnit)
    if (pUnit == nil) then
        return false;
    end

    local pOwnerPlayer = Players[pUnit:GetOwner()];
    if (pOwnerPlayer ~= nil and not pOwnerPlayer:IsTurnActive()) then
        return false;
    end

    return true;
end

function IsUnitHasCommand(pUnit, commandType)
    if (pUnit == nil) then
        return false;
    end

    local greatPerson = pUnit:GetGreatPerson()
    local gpInfo = GameInfo.GreatPersonIndividuals[greatPerson:GetIndividual()]
    local unitType = GameInfo.Units[pUnit:GetUnitType()].UnitType
    if gpInfo ~= nil then
        unitType = gpInfo.GreatPersonIndividualType
    end
    for row in GameInfo.TKH_UnitTypeUnitCommands() do
        if row.CommandType == commandType then
            if unitType == row.UnitType then
                return true
            end
        end
    end
    return false
end

function AddWorldViewText(x, y, text, ...)
    local _plot = Map.GetPlot(x, y)
    if not _plot then
        return
    end
    Game.AddWorldViewText(0, Locale.Lookup(text, ...), x, y)
end

--- 单位收到伤害后
---@param pUnit any
function OnUnitGetArmorOrDamageDecreased(pUnit)
    -- 无火洞主-晋升：战斗后回复5点生命值
    if IsUnitHaveAbility(pUnit, 'ABILITY_TKH_S_HERO_SKILL_WU_HUO_DONG_ZHU_2') then
        TreatUnit(pUnit, 5)
    end
    -- zhoutai
    if IsUnitHasPromotion(pUnit, 'PROMOTION_TK_ZHOU_TAI_1_5') then
        TreatUnit(pUnit, 3)
    end
end

--- 显示护甲变换文本
---@param pUnit table
---@param changeValue number
function UnitArmorChangeText(pUnit, changeValue)
    if not pUnit then
        return
    end
    local x = pUnit:GetX()
    local y = pUnit:GetY()
    if changeValue > 0 then
        AddWorldViewText(x, y, 'LOC_TKH_UNIT_GAIN_ARMOR', changeValue)
    elseif changeValue < 0 then
        AddWorldViewText(x, y, 'LOC_TKH_UNIT_LOST_ARMOR', changeValue)
    end
end

function IsUnitHurt(pUnit)
    if pUnit:GetDamage() > 0 then
        return true
    end

    if pUnit:GetProperty('TKH_Armor') and pUnit:GetProperty('TKH_MaxArmor') then
        local maxArmor = (pUnit:GetProperty('TKH_MaxArmor') or 0) + (pUnit:GetProperty('TKH_ExtraMaxArmor') or 0)
        if maxArmor > pUnit:GetProperty('TKH_Armor') then
            return true
        end
    end

    return false
end

--- 恢复单位生命值（计算护甲）
---@param pUnit table
---@param treatValue integer
function TreatUnit(pUnit, treatValue)
    print('On TreatUnit')

    local treatHealth = 0
    local treatArmor = 0

    if not pUnit or treatValue <= 0 then
        return treatHealth, treatArmor
    end

    -- 治疗生命值，超出部分用于恢复护甲值
    local currentDamage = pUnit:GetDamage()
    treatHealth = math.min(currentDamage, treatValue)
    pUnit:ChangeDamage(-treatHealth)
    local currentArmor = pUnit:GetProperty('TKH_Armor')
    if (treatValue - treatHealth) > 0 and currentArmor then
        local maxArmor = (pUnit:GetProperty('TKH_MaxArmor') or 0) + (pUnit:GetProperty('TKH_ExtraMaxArmor') or 0)
        treatArmor = math.min(maxArmor - currentArmor, treatValue - treatHealth)
        if treatArmor > 0 then
            UnitArmorChangeText(pUnit, treatValue)
        end
        pUnit:SetProperty('TKH_Armor', currentArmor + treatArmor)
    end

    return treatHealth, treatArmor
end

function TreatArmor(pUnit, treatValue)
    if not pUnit or treatValue <= 0 then
        return
    end
    local currentArmor = pUnit:GetProperty('TKH_Armor')
    if currentArmor then
        local maxArmor = (pUnit:GetProperty('TKH_MaxArmor') or 0) + (pUnit:GetProperty('TKH_ExtraMaxArmor') or 0)
        local treatArmor = math.min(maxArmor - currentArmor, treatValue)
        if treatArmor > 0 then
            UnitArmorChangeText(pUnit, treatValue)
        end
        pUnit:SetProperty('TKH_Armor', currentArmor + treatArmor)
    end
end

---对单位造成伤害（计算护甲）
---@param pUnit table
---@param damageValue integer 伤害值+
function DamageUnit(pUnit, damageValue)
    if not pUnit then
        return
    end

    -- 收到伤害单位触发效果
    if damageValue > 0 then
        OnUnitGetArmorOrDamageDecreased(pUnit)
    end

    -- 先扣护甲值
    local currentArmor = pUnit:GetProperty('TKH_Armor') or 0
    if currentArmor > 0 then
        if damageValue >= currentArmor then
            damageValue = damageValue - currentArmor
            UnitArmorChangeText(pUnit, -currentArmor)
            pUnit:SetProperty('TKH_Armor', 0)
        else
            UnitArmorChangeText(pUnit, -damageValue)
            pUnit:SetProperty('TKH_Armor', currentArmor - damageValue)
            damageValue = 0
        end
    end

    -- 再扣生命值
    if damageValue > 0 then
        if pUnit:GetDamage() >= (100 - damageValue) then
            UnitManager.Kill(pUnit)
        else
            pUnit:ChangeDamage(damageValue)
        end
    end
end

--- 更改额外护甲值
---@param pUnit any
---@param changeValue any
function ChangeExtraMaxArmor(pUnit, changeValue)
    if not pUnit then
        return
    end

    -- local currentArmor = pUnit:GetProperty('TKH_Armor') or 0
    -- local maxArmor = pUnit:GetProperty('TKH_MaxArmor') or 0
    local old_extra_value = pUnit:GetProperty('TKH_ExtraMaxArmor') or 0
    -- 无论增减，额外最大护甲值最小为0
    local new_extra_value = math.max(old_extra_value + changeValue, 0)
    pUnit:SetProperty('TKH_ExtraMaxArmor', new_extra_value)

    -- local extra_max_change_value = new_extra_value - old_extra_value

    -- 调整当前护甲值
    -- if extra_max_change_value > 0 then
    --     TreatArmor(pUnit, extra_max_change_value)
    -- else
    --     if currentArmor > maxArmor + new_extra_value then
    --         pUnit:SetProperty('TKH_Armor', maxArmor + new_extra_value)
    --     end
    -- end
end

--- 在指定坐标周围创建单位
---@param playerID integer
---@param unitType string
---@param iX integer
---@param iY integer
---@return table|nil 单位对象
function CreatUnitAtXY(playerID, unitType, iX, iY)
    local plots = Map.GetNeighborPlots(iX, iY, 3)
    for i, adjPlot in ipairs(plots) do
        local cUint = UnitManager.InitUnit(playerID, unitType, adjPlot:GetX(), adjPlot:GetY())
        if cUint ~= nil then
            return cUint
        end
    end
    return nil
end

-- ===========================================================================
--	FUNCTIONS   HERO
-- ===========================================================================

--- 判断单位是否为三国英雄单位
--- @param unitTypeName string
function IsTkh(unitTypeName)
    return string.match(unitTypeName, 'UNIT_HERO_TKH_') ~= nil or unitTypeName == 'UNIT_HERO_PHANTA_GUAN_YU' or
        unitTypeName == 'UNIT_HULAO_LUBU'
end

-- ===========================================================================
--	FUNCTIONS   PLOT
-- ===========================================================================

--- 获取地块上的所有单位，排除自身
--- @param pUnit table
function GetPlotUnitsWithoutSelf(pUnit)
    local plot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    local pUnits = Units.GetUnitsInPlot(plot)
    local rUnits = {}
    for _, unit in ipairs(pUnits) do
        if unit ~= pUnit then
            table.insert(rUnits, unit)
        end
    end

    return rUnits
end

--- 获取地块上的第一个单位
--- @param plot table
function GetPlotFirstUnit(plot)
    local pUnits = Units.GetUnitsInPlot(plot)
    if pUnits == nil or #pUnits == 0 then
        return nil
    end

    for _, unit in ipairs(pUnits) do
        if unit ~= nil then
            return unit
        end
    end
end

--- 判断单位X格范围内是否有单位或城市
--- @param iX integer
--- @param iY integer
--- @param iRange integer
function IsPlotHasUnitOrCity(iX, iY, iRange)
    local adjPlots = Map.GetNeighborPlots(iX, iY, iRange);
    if adjPlots ~= nil then
        for _, curPlot in ipairs(adjPlots) do
            for _, adjUnit in ipairs(Units.GetUnitsInPlot(curPlot)) do
                if (adjUnit ~= nil) then
                    return true
                end
            end

            if curPlot:IsCity() then
                return true
            end
        end
    end

    return false
end

--- 获取单位X格范围内的所有单位
--- @param iX integer
--- @param iY integer
--- @param iRange integer
--- @return table nUnits
function GetNeighborUnits(iX, iY, iRange)
    local nUnits = {}
    local adjPlots = Map.GetNeighborPlots(iX, iY, iRange);
    if adjPlots ~= nil then
        for _, curPlot in ipairs(adjPlots) do
            for _, adjUnit in ipairs(Units.GetUnitsInPlot(curPlot)) do
                if (adjUnit ~= nil) then
                    table.insert(nUnits, adjUnit)
                end
            end
        end
    end

    return nUnits
end

--- 判断单位X格范围内是否有受伤单位
--- @param pUnit table
--- @param iRange integer
function IsExistHurtUnitInRangeX(pUnit, iRange)
    if (pUnit == nil) then
        return false;
    end

    local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), iRange)

    for _, adjUnit in ipairs(adjUnits) do
        if adjUnit:GetOwner() == pUnit:GetOwner() and IsUnitHurt(adjUnit) then
            return true
        end
    end

    return false;
end

--- 判断单位X格范围内是否有已攻击或已移动单位
--- @param pUnit table
--- @param iRange integer
function IsExistAttackedOrMovedUnitInRangeX(pUnit, iRange)
    if (pUnit == nil) then
        return false;
    end

    local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), iRange)

    for _, adjUnit in ipairs(adjUnits) do
        if adjUnit:GetOwner() == pUnit:GetOwner() then
            if adjUnit:GetAttacksRemaining() == 0 or adjUnit:GetMovesRemaining() == 0 then
                return true
            end
        end
    end

    return false;
end

--- 判断单位X格范围内是否有敌人单位
---@param pUnit table
---@param iRange integer
---@return boolean
function IsEnemyInRangeX(pUnit, iRange)
    if (pUnit == nil) then
        return false;
    end

    local adjUnits = GetNeighborUnits(pUnit:GetX(), pUnit:GetY(), iRange)
    local diplomacy = Players[pUnit:GetOwner()]:GetDiplomacy()

    for _, adjUnit in ipairs(adjUnits) do
        if (adjUnit ~= nil) then
            if adjUnit ~= nil and diplomacy:IsAtWarWith(adjUnit:GetOwner()) then
                return true
            end
        end
    end

    return false;
end

-- ===========================================================================
--	FUNCTIONS   UNIT
-- ===========================================================================

function IsUnitHasPromotion(pUnit, promotionType)
    local exp = pUnit:GetExperience()
    if exp == nil then
        return false
    end
    local promotion = GameInfo.UnitPromotions[promotionType]
    if promotion == nil then
        return false
    end
    if exp:HasPromotion(promotion.Index) then
        return true
    end
    return false
end

function IsAbilityInAbilities(abilities, unitAbilities)
    local matchAbilities = {}

    if type(abilities) == 'string' then
        -- matchAbilities = { abilities }
        table.insert(matchAbilities, abilities)
    elseif type(abilities) == 'table' then
        for _, v in ipairs(abilities) do
            table.insert(matchAbilities, v)
        end
    end
    if (unitAbilities ~= nil) then
        for _, ability in ipairs(unitAbilities) do
            local abilityType = GameInfo.UnitAbilities[ability].UnitAbilityType
            if abilityType ~= nil then
                if IsInTable(matchAbilities, abilityType) then
                    return true
                end
            end
        end
    end

    return false
end

--- 判断单位是否拥有某能力
--- @param pUnit table
--- @param ability string|table
function IsUnitHaveAbility(pUnit, ability)
    local unitAbility = pUnit:GetAbility()
    if unitAbility == nil then
        return false
    end

    -- print('unitAbilities.GetAbilityCount = ', unitAbilities.GetAbilityCount)
    if unitAbility.GetAbilityCount == nil then
        return IsAbilityInAbilities(ability, unitAbility:GetAbilities())
    else
        if type(ability) == 'string' then
            local iCurrentCount = unitAbility:GetAbilityCount(ability);
            if iCurrentCount > 0 then
                return true
            end
        elseif type(ability) == 'table' then
            for _, v in ipairs(ability) do
                local iCurrentCount = unitAbility:GetAbilityCount(v);
                if iCurrentCount > 0 then
                    return true
                end
            end
        else
            return false
        end
    end

    return false
end

--- 获取单位所有技能在指定table中的数值总和
---@param pUnit table
---@param tTable table
---@param baseValue number|nil
function GetUnitAbilitiesParameterSum(pUnit, tTable, baseValue)
    local sum = baseValue or 0

    local unitAbilities = pUnit:GetAbility():GetAbilities()
    for _, ability in ipairs(unitAbilities) do
        local abilityType = GameInfo.UnitAbilities[ability.Ability].UnitAbilityType
        if abilityType ~= nil then
            local ability_percent = tTable[abilityType] or 0
            sum = sum + ability_percent
        end
    end

    return sum
end

-- ===========================================================================
--	FUNCTIONS   奢侈税
-- ===========================================================================

--- 获取玩家城市数量和非平民单位数量
--- @param playerID number
--- @return number total_cities_num 城市总数
--- @return number total_units_num FORMATION_CLASS_CIVILIAN平民总数
function GetPlayerCitiesAndNotCivilianUnitsNum(playerID)
    local pPlayer = Players[playerID]
    local total_cities_num = pPlayer:GetCities():GetCount()
    local total_units_num = 0
    for _, unit in pPlayer:GetUnits():Members() do
        if GameInfo.Units[unit:GetType()].FormationClass ~= 'FORMATION_CLASS_CIVILIAN' then
            total_units_num = total_units_num + 1
        end
    end

    return total_cities_num, total_units_num
end

--- 计算玩家单位奢侈税
---@param playerID integer
function CalculateLuxuryTaxUnits(playerID)
    local localPlayer = Players[playerID]
    local luxuryTax = 0

    if localPlayer == nil or not localPlayer:IsMajor() or not localPlayer:IsAlive() then
        return luxuryTax
    end

    local total_cities_num, total_units_num = GetPlayerCitiesAndNotCivilianUnitsNum(playerID)

    local allow_max_unit_num = CAPITAL_MAX_UNIT_NUM + (total_cities_num - 1) * PER_CITY_MAX_UNIT_NUM
    if allow_max_unit_num >= LUXURY_UNIT_NUM_MAX then
        allow_max_unit_num = LUXURY_UNIT_NUM_MAX
    end
    local extra_unit_num = total_units_num - allow_max_unit_num
    if extra_unit_num <= 0 then
        luxuryTax = 0
    end

    local total_tax = 0
    for _, unitTax in ipairs(LUXURY_TAX_UNIT) do
        if extra_unit_num > unitTax.UNITS_NUM then
            total_tax = total_tax + unitTax.TAX
        end
    end
    luxuryTax = luxuryTax + total_tax * extra_unit_num
    return luxuryTax
end

--- 计算玩家城市奢侈税
---@param playerID integer
function CalculateLuxuryTaxCities(playerID)
    local localPlayer = Players[playerID]
    local luxuryTax = 0
    if localPlayer == nil or not localPlayer:IsMajor() or not localPlayer:IsAlive() then
        return luxuryTax
    end
    local total_cities_num, total_units_num = GetPlayerCitiesAndNotCivilianUnitsNum(playerID)
    local total_tax = 0
    for _, cityTax in ipairs(LUXURY_TAX_CITY) do
        if total_cities_num > cityTax.CITIES_NUM then
            total_tax = total_tax + cityTax.TAX
        end
    end
    luxuryTax = luxuryTax + total_tax * total_cities_num
    return luxuryTax
end

-- ===========================================================================
--	FUNCTIONS   UNIT COMMAND
-- ===========================================================================

function GetCommandValidPlots(pUnit, commandType)
    local range = 1
    local g_targetPlots = {}
    local pUnitAdjPlots = Map.GetNeighborPlots(pUnit:GetX(), pUnit:GetY(), range);
    if commandType == 'UNITCOMMAND_CHANGE_SELECTED_PLOT' then
        local changeType, changeItemIndex, changeItemName = GetCommandPlotChangeInfo(GetUnitType(pUnit),
            'UNITCOMMAND_CHANGE_SELECTED_PLOT')
        if changeType == 'FeatureType' then
            local validTerrainTypes = GetFeatureValidTerrainType(GameInfo.Features[changeItemIndex].FeatureType)
            for _, pAdjPlot in ipairs(pUnitAdjPlots) do
                if IsInTable(validTerrainTypes, GameInfo.Terrains[pAdjPlot:GetTerrainType()].TerrainType) then
                    table.insert(g_targetPlots, pAdjPlot:GetIndex());
                end
            end
        end
    end

    return g_targetPlots
end

function GetFeatureValidTerrainType(featureType)
    local validTerrainTypes = {}
    for row in GameInfo.Feature_ValidTerrains() do
        if row.FeatureType == featureType then
            table.insert(validTerrainTypes, row.TerrainType)
        end
    end
    return validTerrainTypes
end

-- 获取符合地形地貌的资源
function GetValidResources(plotID)
    local plot = Map.GetPlotByIndex(plotID)

    if plot == nil then
        return {}
    end
    local resources = {}
    for row in GameInfo.Resources() do
        if (row.ResourceClassType == 'RESOURCECLASS_BONUS' or row.ResourceClassType == 'RESOURCECLASS_LUXURY') and
            ResourceBuilder.CanHaveResource(plot, row.Index) and IsInTable(GREATPEOPLE_VALID_RESOURCES, row.ResourceType) then
            table.insert(resources, row.Index)
        end
    end

    return resources
end

---
---@param classType string
---@return table resources 资源索引列表
function GetResouecesByClassType(classType)
    local resources = {}
    for row in GameInfo.Resources() do
        if row.ResourceClassType == classType then
            table.insert(resources, row.Index)
        end
    end

    return resources
end

--- 获取UNITCOMMAND_CREATE_RESOURCE资源索引
---@param pUnitType string
---@return table resourceIndexes 资源索引
function GetCommandResourceIndex(pUnitType)
    local resourceTypes = {}
    local resourceIndex = -1
    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        'UNITCOMMAND_CREATE_RESOURCE');
    if results then
        for _, row in ipairs(results) do
            if row.Name == 'ResourceType' then
                if string.match(row.Value, '|') then
                    resourceTypes = SplitString(row.Value, '|')
                else
                    if GameInfo.Resources[row.Value] then
                        table.insert(resourceTypes, row.Value)
                    end
                end
            elseif row.Name == 'ResourceClassType' then
                if row.Value == 'RESOURCECLASS_BONUS' then
                    table.insert(resourceTypes, GetRandomTableElement(GetResouecesByClassType('RESOURCECLASS_BONUS')))
                elseif row.Value == 'RESOURCECLASS_LUXURY' then
                    table.insert(resourceTypes, GetRandomTableElement(GetResouecesByClassType('RESOURCECLASS_LUXURY')))
                elseif row.Value == 'RESOURCECLASS_STRATEGIC' then
                    table.insert(resourceTypes, GetRandomTableElement(GetResouecesByClassType('RESOURCECLASS_STRATEGIC')))
                end
            end
        end
    end

    local resourceIndexes = {}
    for _, resourceType in ipairs(resourceTypes) do
        if GameInfo.Resources[resourceType] then
            table.insert(resourceIndexes, GameInfo.Resources[resourceType].Index)

            -- print(resourceType, GameInfo.Resources[resourceType].Index)
        end
    end

    return resourceIndexes
end

--- 获取command参数
---@param pUnitType string
---@param commandType string
function GetCommandParameters(pUnitType, commandType)
    return DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        commandType)
end

--- 获取UNITCOMMAND_CHANGE_PLOT信息
---@param pUnitType any
---@return string changeTyp 单元格更改类型
---@return integer changeItemIndex 更改项索引
---@return string changeItemName 更改项名称
function GetCommandPlotChangeInfo(pUnitType, commandType)
    if commandType == nil then
        commandType = 'UNITCOMMAND_CHANGE_PLOT'
    end
    local changeType;
    local changeItemType;
    local changeItemIndex = -1
    local changeItemName = '原样'

    local results = DB.Query(
        "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
        commandType);
    if results then
        for _, row in ipairs(results) do
            changeType = row.Name
            changeItemType = row.Value
        end
    end

    if changeType == 'TerrainType' then
        local terrain = GameInfo.Terrains[changeItemType]
        if terrain then
            changeItemIndex = terrain.Index
            changeItemName = Locale.Lookup(terrain.Name)
        end
    elseif changeType == 'FeatureType' then
        local feature = GameInfo.Features[changeItemType]
        if feature then
            changeItemIndex = feature.Index
            changeItemName = Locale.Lookup(feature.Name)
        end
    end

    return changeType, changeItemIndex, changeItemName
end

--- 判断拥有命令的单位是否为伟人单位
---@param pUnit table
function IsCommandUnitGP(pUnit)
    local isGP = false
    local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
    local gInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
    if gInfo then
        isGP = true
    end

    return isGP
end

--- 获取UnitType
---@param pUnit table
function GetUnitType(pUnit)
    local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType
    local isGP = IsCommandUnitGP(pUnit)
    if isGP then
        local greatPersonIndividualID = pUnit:GetGreatPerson():GetIndividual()
        local gInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
        pUnitType = gInfo.GreatPersonIndividualType
    end
    return pUnitType
end

--- 获取命令描述字符串
--- @param pUnitType string
--- @param commandType string
--- @return string commandString 命令描述字符串
function GetCommandString(pUnitType, commandType)
    local helpTooltip = Locale.Lookup('LOC_' .. commandType .. '_HELP')

    if commandType == 'UNITCOMMAND_CREATE_UNIT' then
        local sUnitType;
        local count = 1;
        local form;

        local results = DB.Query(
            "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ?", pUnitType,
            commandType);

        if results then
            for _, row in ipairs(results) do
                if row.Name == 'UnitType' then
                    sUnitType = row.Value
                elseif row.Name == 'Count' then
                    count = row.Value
                elseif row.Name == 'Form' then
                    form = row.Value
                end
            end
        end



        if sUnitType ~= nil then
            local unitName = Locale.Lookup('LOC_' .. sUnitType .. '_NAME')
            if form == '1' then
                unitName = unitName .. ' [ICON_Army] 军队'
            elseif form == '2' then
                unitName = unitName .. ' [ICON_Corps] 军团'
            end
            helpTooltip = Locale.Lookup('LOC_UNITCOMMAND_CREATE_UNIT_HELP', count, unitName)
        end
    elseif commandType == 'UNITCOMMAND_CREATE_RESOURCE' then
        local resourceIndexes = GetCommandResourceIndex(pUnitType)
        if table.count(resourceIndexes) == 0 then
            return Locale.Lookup('LOC_UNITCOMMAND_CREATE_RESOURCE_HELP', '随机', '加成或奢侈品资源')
        else
            local resourceStrings = {}
            for _, rIndex in ipairs(resourceIndexes) do
                local resource = GameInfo.Resources[rIndex]
                if resource then
                    table.insert(resourceStrings,
                        ' [ICON_' .. resource.ResourceType .. '] ' .. Locale.Lookup(resource.Name))
                end
            end
            return Locale.Lookup('LOC_UNITCOMMAND_CREATE_RESOURCE_HELP', '', table.concat(resourceStrings, '或'))
        end
    elseif commandType == 'UNITCOMMAND_ENDOW_ABILITY' then
        local results = DB.Query(
            "SELECT Name, Value from TKH_UnitTypeUnitCommandArguments where UnitType = ? and CommandType = ? and Name = ?",
            pUnitType, 'UNITCOMMAND_ENDOW_ABILITY', 'ABILITY');
        local ability = GameInfo.UnitAbilities[results[1].Value]
        return Locale.Lookup('LOC_ENDOW_UNIT_ABILITY', Locale.Lookup(ability.Name),
            Locale.Lookup(ability.Description))
    elseif commandType == 'UNITCOMMAND_CHANGE_PLOT' then
        local changeType, changeItemIndex, changeItemName = GetCommandPlotChangeInfo(pUnitType, commandType)
        return Locale.Lookup('LOC_UNITCOMMAND_CHANGE_PLOT_HELP', changeItemName)
    elseif commandType == 'UNITCOMMAND_CHANGE_SELECTED_PLOT' then
        local changeType, changeItemIndex, changeItemName = GetCommandPlotChangeInfo(pUnitType, commandType)
        return Locale.Lookup('LOC_UNITCOMMAND_CHANGE_SELECTED_PLOT_HELP', changeItemName)
    end

    return helpTooltip
end

--- 为单位添加能力
---@param playerID number
---@param unitID number
---@param abilityName string
---@param recover boolean @覆盖添加：true|abilityAmount = 1，false|abilityAmount += 1
function AddAbilityForUnit(playerID, unitID, abilityName, recover)
    -- print('AddAbilityForUnit: abilityType = ', abilityName, playerID, unitID)

    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil then
        return
    end
    local unitAbilities = pUnit:GetAbility()
    if unitAbilities == nil then
        return
    end

    if recover then
        local iCurrentCount = unitAbilities:GetAbilityCount(abilityName);
        local iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
        unitAbilities:ChangeAbilityCount(abilityName, iChange + 1)
    else
        unitAbilities:ChangeAbilityCount(abilityName, 1)
    end
end

--- 移除单位能力 pUnit, abilityName,
---@param playerID number
---@param unitID number
---@param abilityName string
---@param isAll boolean @全部移除：true|全部，false|移除1个
function RemoveAbilityFromUnit(playerID, unitID, abilityName, isAll)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil then
        return
    end
    local unitAbilities = pUnit:GetAbility()
    if unitAbilities == nil then
        return
    end

    if isAll then
        local iCurrentCount = unitAbilities:GetAbilityCount(abilityName);
        local iChange = (iCurrentCount ~= 0) and -iCurrentCount or 0
        unitAbilities:ChangeAbilityCount(abilityName, iChange)
    else
        unitAbilities:ChangeAbilityCount(abilityName, -1)
    end
end

function GetCombatResult(pCombatResult)
    local combatType = pCombatResult[CombatResultParameters.COMBAT_TYPE]
    local location = pCombatResult[CombatResultParameters.LOCATION];

    -- 攻击者信息
    local attacker = pCombatResult[CombatResultParameters.ATTACKER];
    local aInfo = attacker[CombatResultParameters.ID]
    local damageToAttacker = attacker[CombatResultParameters.DAMAGE_TO]
    local attackerLocation = attacker[CombatResultParameters.LOCATION]
    local aCType = aInfo.type


    -- 防御者信息
    local defender = pCombatResult[CombatResultParameters.DEFENDER]
    local dInfo = defender[CombatResultParameters.ID]
    local damageToDefender = defender[CombatResultParameters.DAMAGE_TO]
    local defenderLocation = defender[CombatResultParameters.LOCATION]
    local dCType = dInfo.type


    local combatComponentTypes = 0


    if aInfo.type == ComponentType.UNIT and dInfo.type == ComponentType.UNIT then
        combatComponentTypes = CombatVSComponentTypes.UNIT_UNIT
    elseif aInfo.type == ComponentType.UNIT and dInfo.type == ComponentType.CITY then
        combatComponentTypes = CombatVSComponentTypes.UNIT_CITY
    elseif aInfo.type == ComponentType.UNIT and dInfo.type == ComponentType.DISTRICT then
        combatComponentTypes = CombatVSComponentTypes.UNIT_DISTRICT
    elseif aInfo.type == ComponentType.CITY and dInfo.type == ComponentType.UNIT then
        combatComponentTypes = CombatVSComponentTypes.CITY_UNIT
    elseif aInfo.type == ComponentType.DISTRICT and dInfo.type == ComponentType.UNIT then
        combatComponentTypes = CombatVSComponentTypes.DISTRICT_UNIT
    end


    return {
        CombatComponentTypes = combatComponentTypes,
        CombatType = combatType,
        Location = location,
        Attacker = { attacker, aInfo, damageToAttacker, attackerLocation, aCType },
        Dfender = { defender, dInfo, damageToDefender, defenderLocation, dCType }
    }
end

--- 匹配单位Tag
---@param unitType string
---@param key table|string
function MatchUnitTag(unitType, key)
    -- GameInfo.TypeTags()
    local res = DB.Query("SELECT Tag from TypeTags where Type = ?", unitType)

    if res and #res > 0 then
        for _, tagInfo in ipairs(res) do
            local tag = tagInfo.Tag
            -- for _, v in ipairs(tags) do

            -- end
            if type(key) == 'string' then
                if string.match(tag, key) then
                    return true
                end
            elseif type(key) == 'table' then
                for _, k in ipairs(key) do
                    if tag == k then
                        return true
                    end
                end
            end
        end
    end

    return false
end

--- 生成单位
---@param playerID number
---@param parameters table
function GenerateUnitInPlot(playerID, parameters)
    local x = parameters.PosX
    local y = parameters.PosY
    local unitType = parameters.UnitType
    local form = parameters.Form
    if not x or not y or not unitType or not form then
        return nil
    end

    local unit = UnitManager.InitUnit(playerID, unitType, x, y)
    if not unit then
        return nil
    end

    if form == '1' then
        unit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION);
    elseif form == '2' then
        unit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION);
    end

    return unit
end

function GetPlayerData(playerID, dataName)
    local dataSetIndex = 0
    local initialTurn = GameConfiguration.GetStartTurn()
    local finalTurn = Game.GetCurrentGameTurn()
    local count = GameSummary.GetDataSetCount()

    for i = 0, count - 1, 1 do
        local name = GameSummary.GetDataSetName(i);
        if name == dataName then
            dataSetIndex = i
        end
    end
    local gdata = GameSummary.CoalesceDataSet(dataSetIndex, initialTurn, finalTurn)
    if not gdata or not gdata[0] then
        return 0
    end
    local res = gdata[0][#gdata[0]]
    if not res then
        for _, value in pairs(gdata[0]) do
            res = value
        end
    end
    return res or 0
end

function GetRandomSeed()
    local playerIDS = PlayerManager.GetAliveIDs();
    local result = 0;
    for i, playerId in ipairs(playerIDS) do
        local pPlayer = Players[playerId];
        local playerConfig = PlayerConfigurations[playerId];
        if pPlayer:IsMajor() and pPlayer:IsAlive() then
            for _, pCity in pPlayer:GetCities():Members() do
                result = result + pCity:GetGrowth():GetTurnsUntilGrowth();
                result = result + pCity:GetGrowth():GetHappiness();
                result = result + pCity:GetGrowth():GetFoodSurplus();
                result = result + pCity:GetGrowth():GetHousing();
            end
        end
    end
    result = result + math.abs(tonumber(MapConfiguration.GetValue("RANDOM_SEED"))) *
        (table.count(PlayerManager.GetAliveMajorIDs()) % 7 + 1) + os.time()
    return tonumber(tostring(result):reverse():sub(1, 6))
end

function ToStringEx(value)
    if type(value) == 'table' then
        return TableToStr(value)
    elseif type(value) == 'string' then
        return "\'" .. value .. "\'"
    else
        return tostring(value)
    end
end

function TableToStr(t)
    if t == nil then return "" end
    local retstr = "{"

    local i = 1
    for key, value in pairs(t) do
        local signal = ","
        if i == 1 then
            signal = ""
        end

        if key == i then
            retstr = retstr .. signal .. ToStringEx(value)
        else
            if type(key) == 'number' or type(key) == 'string' then
                retstr = retstr .. signal .. '[' .. ToStringEx(key) .. "]=" .. ToStringEx(value)
            else
                if type(key) == 'userdata' then
                    retstr = retstr .. signal .. "*s" .. TableToStr(getmetatable(key)) .. "*e" .. "=" ..
                        ToStringEx(value)
                else
                    retstr = retstr .. signal .. key .. "=" .. ToStringEx(value)
                end
            end
        end

        i = i + 1
    end

    retstr = retstr .. "}"
    return retstr
end

function StrToTable(str)
    if str == nil or type(str) ~= "string" then
        return
    end

    return loadstring("return " .. str)()
end

-- ===========================================================================
--	FUNCTIONS   EQUIPMENT_DATA
-- ===========================================================================

--- 获取玩家奖励
---@param playerID number
---@param rewardType number
---@return number counter 计数器
---@return table recorder 奖励列表
function GetPlayerReward(playerID, rewardType)
    local _playerID = 'TKH_' .. tostring(playerID)
    local m_EquipmentRewardManager = Game:GetProperty('EquipmentRewardManager') or {}
    m_EquipmentRewardManager[_playerID] = m_EquipmentRewardManager[_playerID] or {}
    m_EquipmentRewardManager[_playerID][rewardType] = m_EquipmentRewardManager[_playerID][rewardType] or {}
    local counter = m_EquipmentRewardManager[_playerID][rewardType].Counter or 0
    local recorder = m_EquipmentRewardManager[_playerID][rewardType].Recorder or {}

    return counter, recorder
end

--- 获取剩余装备数量
--- @param equipmentAllocator table 装备分配表
--- @param equipmentType string 装备类型
--- @return number amount 装备数量
function GetRemainEquipmentAmount(equipmentAllocator, equipmentType)
    if equipmentAllocator ~= nil and #equipmentAllocator > 0 then
        if not equipmentType then
            return #equipmentAllocator
        else
            local amount = 0
            for _, equipmentIndex in ipairs(equipmentAllocator) do
                local equipment = GameInfo.TKH_Equipments[equipmentIndex]
                if equipment and equipment.EquipmentType == equipmentType then
                    amount = amount + 1
                end
            end
            return amount
        end
    else
        return 0
    end
end

--- 装备奖励-总击杀需求计算
---@param rewardTimes number
function GetTotalKillNeeds(rewardTimes)
    local function _getKillRewardReqNum(_rewardTime)
        if _rewardTime == 0 then
            return 10
        elseif _rewardTime == 1 then
            return 20
        else
            return _getKillRewardReqNum(_rewardTime - 1) + _getKillRewardReqNum(_rewardTime - 2)
        end
    end

    return _getKillRewardReqNum(rewardTimes)
end

function GetEquipmentRewardNeedsNum(rewardType, rewardTimes)
    if rewardType == EQUIPMENT_REWARD_TYPES.TOTAL_KILL then
        return GetTotalKillNeeds(rewardTimes)
    elseif rewardType == EQUIPMENT_REWARD_TYPES.TOTAL_CITIES then
        return 10 + 5 * rewardTimes
    elseif rewardType == EQUIPMENT_REWARD_TYPES.DESTORY_BARBARIAN_CAMP then
        return 2 + 4 * rewardTimes
    elseif rewardType == EQUIPMENT_REWARD_TYPES.GOODYHUT_REWARD then
        return 2 * (rewardTimes + 1)
    elseif rewardType == EQUIPMENT_REWARD_TYPES.CONQUERED_ORIGINAL_CAPITAL then
        return 4 * (rewardTimes + 1)
    else
        return -1
    end
end

-- ===========================================================================
--	SAMPLE
-- ===========================================================================

-- ModifierCombatResult

-- info：存储相关信息的表。
-- info.PlotX：战斗发生地点的X坐标。
-- info.PlotY：战斗发生地点的Y坐标。
-- info.CombatType：战斗类型的Hash值，一般如下：
-- CombatTypes.BOMBARD = 1338578493
-- CombatTypes.RANGED = 784649805
-- CombatTypes.MELEE = 748940753
-- CombatTypes.RELIGIOUS = 1580168296
-- CombatTypes.ICBM = 1640240290
-- CombatTypes.AIR = 1184946373
-- info.CombatVersusType：战斗中对战双方类型的Hash值，一般如下：
-- DB.MakeHash('COMBAT_UNIT_VS_UNIT')
-- DB.MakeHash('COMBAT_UNIT_VS_DISTIRCT')
-- DB.MakeHash('COMBAT_UNIT_VS_LOCATION')
-- DB.MakeHash('COMBAT_DISTIRCT_VS_UNIT')
-- DB.MakeHash('COMBAT_DISTIRCT_VS_DISTIRCT')
-- DB.MakeHash('COMBAT_DISTIRCT_VS_LOCATION')
-- info.CityDefenseType：城市防御类型的Hash值，一般如下：
-- DefenseTypes.DISTRICT_GARRISON = 1587009065
-- DefenseTypes.DISTRICT_OUTER = 1839557181
-- info.NoPreview：是否是战斗预览。为true则没有战斗预览，多用于AI进行价值判断。
-- info.UseAvergeDamage：是否取平均伤害，为true则表明该结果用于生成战斗预览，而非真正的战斗。
-- info.AttackerPlayerID：进攻方玩家ID。
-- info.AttackerUnitID：进攻方单位ID。
-- info.AttackerDistrictID：进攻方区域ID。
-- info.AttackerMaxDamage：进攻方最大可承受伤害，即进攻方最大生命值。
-- info.AttackerDamageTaken：进攻方在本次战斗中受到的伤害。
-- info.AttackerDamageTakenFromDefender：进攻方在本次战斗中受到的来自防御方的伤害。
-- info.AttackerDamageTakenFromInterceptor：进攻方在本次战斗中受到的来自拦截机的伤害。
-- info.AttackerDamageTakenFromLocation：进攻方在本次战斗中受到的来自某一位置的伤害，一般多为来自防空单位的伤害。
-- info.AttackerPostDamage：进攻方在战斗结束后受到的总伤害，即进攻方在战斗结束后已经损失的生命值。
-- info.AttackerExperienceEarned：进攻方获得的经验值。
-- info.AttackerCombat：进攻方基础战斗力。
-- info.AttackerStrengthModifier：进攻方来自Modifier的战斗力。
-- info.DefenderPlayerID：防御方玩家ID。
-- info.DefenderUnitID：防御方单位ID。
-- info.DefenderDistrictID：防御方区域ID。
-- info.DefenderMaxDamage：防御方最大可承受伤害，即防御方最大生命值。
-- info.DefenderDamageTaken：防御方在本次战斗中受到的伤害。
-- info.DefenderPostDamage：防御方在战斗结束后受到的总伤害，即防御方在战斗结束后已经损失的生命值。
-- info.DefenderInterceptorMaxDamage：防御方拦截机最大可承受伤害，即防御方最大生命值。
-- info.DefenderInterceptorDamageTaken：防御方拦截机在本次战斗中受到的伤害。
-- info.DefenderInterceptorPostDamage：防御方拦截机在战斗结束后受到的总伤害，即防御方在战斗结束后已经损失的生命值。
-- info.DefenderOuterMaxDamage：防御方外围防御最大可承受伤害，即防御方外围防御最大生命值。
-- info.DefenderOuterDamageTaken：防御方外围防御在本次战斗中受到的伤害。
-- info.DefenderOuterPostDamage：防御方外围防御在战斗结束后受到的总伤害，即防御方外围防御在战斗结束后已经损失的生命值。
-- info.DefenderExperienceEarned：防御方获得的经验值。
-- info.DefenderCombat：防御方基础战斗力。
-- info.DefenderStrengthModifier：防御方来自Modifier的战斗力。
-- info.DefenderAntiAirUnitExperienceEarned：防御方防空单位获得的经验值。
-- info.DefenderAntiAirUnitCombat：防御方防空单位基础战斗力
-- info.DefenderAntiAirUnitStrengthModifier：防御方防空单位来自Modifier的战斗力。
-- info.DefenderInterceptorExperienceEarned：防御方拦截机获得的经验值。
-- info.DefenderInterceptorCombat：防御方拦截机基础战斗力
-- info.DefenderInterceptorStrengthModifier：防御方拦截机来自Modifier的战斗力。
