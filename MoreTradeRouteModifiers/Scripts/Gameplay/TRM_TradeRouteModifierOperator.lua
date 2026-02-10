print('Load TRM_TradeRouteModifierInstanceOperator.lua')

include('TRM_Helper')
include('TTK_ToolkitsCore')

include('TRM_Constants')
include('TRM_TradeRouteModifierInstance')

-- ===========================================================================
--	VARIABLES
-- ===========================================================================

ExposedMembers.GameEvents = GameEvents


local m_TradeRouteModifierManager = {}
local m_TradeRouteModifierUpdater = {}
-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

function SetGameProperty(propertyName, propertyValue)
    Game:SetProperty(propertyName, propertyValue)
end

GameEvents.SetGameProperty.Add(SetGameProperty)


function ChangeModifierDecimalYields(tradeRouteID, changeType)
    local op, oc, dp, dc = unpack(SplitString(tradeRouteID, '-'))
    local cities = { CityManager.GetCity(op, oc), CityManager.GetCity(dp, dc) }
    for _, city in ipairs(cities) do
        if city then
            if changeType == 1 then
                local totalYields = GetCityTradeRouteModifierYields(city, 'CityYieldsDecimal')
                local decimalAmountModifierStrings = {}
                for cityKey, yieldDecimalAmounts in pairs(totalYields) do
                    for yieldType, decimalAmount in pairs(yieldDecimalAmounts) do
                        -- print(yieldType, decimalAmount[1], decimalAmount[2])
                        local decimalAmountInteger, decimalAmountDecimal = math.modf(decimalAmount.BaseAmount)
                        if decimalAmountDecimal >= 0.5 then
                            decimalAmountInteger = decimalAmountInteger + 1
                        end
                        if decimalAmountInteger > 0 then
                            local modifierString = string.format(MODIFIER_IN_COMING, yieldType, decimalAmountInteger)
                            city:AttachModifierByID(modifierString)
                            table.insert(decimalAmountModifierStrings, modifierString)
                            -- print('attach modifierString: ', modifierString)
                        end
                    end
                end
                city:SetProperty('decimalAmountModifierStrings', decimalAmountModifierStrings)
            else
                local decimalAmountModifierStrings = city:GetProperty('decimalAmountModifierStrings') or {}
                for _, modifierString in ipairs(decimalAmountModifierStrings) do
                    city:DetachModifierByID(modifierString)
                    -- print('detach modifierString: ', modifierString)
                end
                city:SetProperty('decimalAmountModifierStrings', nil)
            end
        end
    end
end

---执行Gameplay环境下的修改器行为
---@param playerID number
---@param params table
function TradeRouteModifierExecuteOperation(playerID, params)
    local tradeRouteIDs = params.TradeRouteIDs
    local operationType = params.OperationType

    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}


    for _, tradeRouteID in ipairs(tradeRouteIDs) do
        if operationType == TRM_OperationType.DESTROY then
            if m_TradeRouteModifierManager[tradeRouteID] then
                ChangeModifierDecimalYields(tradeRouteID, 0)
                for index, instance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
                    setmetatable(instance, TradeRouteModifierInstance)
                    instance:Remove()
                    for _, updateType in ipairs(instance.Updater) do
                        if m_TradeRouteModifierUpdater[updateType] then
                            m_TradeRouteModifierUpdater[updateType][tradeRouteID] = nil
                        end
                    end
                end
                m_TradeRouteModifierManager[tradeRouteID] = nil
            end
        elseif operationType == TRM_OperationType.REMOVE then
            ChangeModifierDecimalYields(tradeRouteID, 0)
            if m_TradeRouteModifierManager[tradeRouteID] then
                for _, instance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
                    setmetatable(instance, TradeRouteModifierInstance)
                    instance:Remove()
                end
            end
        elseif operationType == TRM_OperationType.APPLY then
            if m_TradeRouteModifierManager[tradeRouteID] then
                for _, instance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
                    setmetatable(instance, TradeRouteModifierInstance)
                    m_TradeRouteModifierUpdater = instance:SetUpdater(m_TradeRouteModifierUpdater)
                    instance:Apply()
                end
                ChangeModifierDecimalYields(tradeRouteID, 1)
            end
        elseif operationType == (TRM_OperationType.UPDATE) then
            if m_TradeRouteModifierManager[tradeRouteID] then
                ChangeModifierDecimalYields(tradeRouteID, 0)
                for _, instance in pairs(m_TradeRouteModifierManager[tradeRouteID]) do
                    setmetatable(instance, TradeRouteModifierInstance)
                    instance:Remove()
                    instance:Apply()
                end
                ChangeModifierDecimalYields(tradeRouteID, 1)
            end
        end
    end

    Game:SetProperty('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)
end

function ApplyAllTRMs(playerID, params)
    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}

    for tradeRouteID, trmInstances in pairs(m_TradeRouteModifierManager) do
        ChangeModifierDecimalYields(tradeRouteID, 0)
        for _, trmInstance in pairs(trmInstances) do
            setmetatable(trmInstance, TradeRouteModifierInstance)
            m_TradeRouteModifierUpdater = trmInstance:SetUpdater(m_TradeRouteModifierUpdater)
            trmInstance:Apply()
        end
        ChangeModifierDecimalYields(tradeRouteID, 1)
    end
    Game:SetProperty('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)
end

-- =========================================================================
--	TEST
-- =========================================================================


-- ===========================================================================
--	Initialize
-- ===========================================================================

function InitializeTRMs()
    m_TradeRouteModifierManager = Game:GetProperty('TradeRouteModifierInstanceManager') or {}
    for trmID, trmInstances in pairs(m_TradeRouteModifierManager) do
        if trmInstances then
            for _, instance in pairs(trmInstances) do
                setmetatable(instance, TradeRouteModifierInstance)
                instance:Remove()
            end
            m_TradeRouteModifierManager[trmID] = nil
        end
    end
    Game:SetProperty('TradeRouteModifierInstanceManager', m_TradeRouteModifierManager)
end

function InitializePlayerTRMs()
    local m_PlayerTraitTradeRouteModifiers = {}
    local m_PlayerTradeRouteModifiers = {}
    for _, playerID in ipairs(PlayerManager.GetAliveIDs()) do
        m_PlayerTraitTradeRouteModifiers[playerID] = GetPlayerTraitTradeRouteModifiers(playerID)
        if not m_PlayerTradeRouteModifiers[playerID] then
            m_PlayerTradeRouteModifiers[playerID] = {}
        end
        for _, trm in ipairs(m_PlayerTraitTradeRouteModifiers[playerID]) do
            table.insert(m_PlayerTradeRouteModifiers[playerID], GameInfo.TRM_TradeRouteModifier[trm])
        end
    end
    Game:SetProperty('PlayerTradeRouteModifiers', m_PlayerTradeRouteModifiers)
end

function Initialize()
    -- ========TEST========
    UnlockTech(Game.GetLocalPlayer(), 'TECH_CURRENCY')
    UnlockCivc(Game.GetLocalPlayer(), 'CIVIC_FOREIGN_TRADE')


    -- UI operation GameEvents
    GameEvents.ApplyAllTRMs.Add(ApplyAllTRMs)
    GameEvents.TradeRouteModifierExecuteOperation.Add(TradeRouteModifierExecuteOperation)
end

-- ========INITIALIZE========
InitializeTRMs()
InitializePlayerTRMs()
Initialize()
