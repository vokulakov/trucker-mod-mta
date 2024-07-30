Business = {}
local createdBusiness = {}

BUSINESS_TABLE_NAME = 'business'

function Business.setup()
    exports.tmtaSQLite:dbTableCreate(BUSINESS_TABLE_NAME, {
        {name = 'type', type = 'INTEGER'}, -- тип бизнеса
        {name = 'name', type = 'VARCHAR', size = 128, options = 'NOT NULL'}, -- название бизнеса
        {name = 'price', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'}, -- рыночная стоимость
        {name = 'balance', type = 'INTEGER', options = 'DEFAULT 0'}, -- баланс бизнеса
        {name = 'revenue', type = 'INTEGER'}, -- доход
        {name = 'position', type = 'TEXT'},
        {name = 'upgrades', type = 'TEXT'},
        {name = 'userId', type = 'INTEGER'},
        {name = 'editorId', type = 'INTEGER'},
        {name = 'accrueRevenueAt', type = 'INTEGER'}, -- время начисления прибыли (в timestamp)
        {name = 'confiscateAt', type = 'INTEGER'}, -- время конфискации в пользу государства (в timestamp)
    }, 
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (editorId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")

    local successCount, errorCount = 0, 0
    for _, business in pairs(Business.getAll()) do
        if (Business.createMarker(business)) then
            successCount = successCount + 1
        else
            errorCount = errorCount + 1
        end
    end

    outputDebugString('Система бизнесов загружена')
    outputDebugString('Успешно создано: '..successCount)
    outputDebugString('Не удалось создать: '..errorCount)
end

function Business.getAll()
    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME)
end

function Business.get(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number") then
        outputDebugString("Business.get: bad arguments", 1)
        return false
    end

    fields = (type(fields) ~= "table") and {} or fields
    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)
end

function Business.add(posX, posY, posZ, type, price, revenue, callbackFunctionName, ...)
    local player = client
    if not isElement(player) then
        return false
    end

    local businessConfig = Utils.getBusinessConfigByType(type)
    if not businessConfig then
        return false
    end

    local businessData = {
        type = type,
        name = businessConfig.name,
        position = tostring(toJSON({x = posX, y = posY, z = posZ})),
        price = price,
        revenue = revenue,
        balance = 0,
        editorId = player:getData("userId"),
    }

    local success = exports.tmtaSQLite:dbTableInsert(BUSINESS_TABLE_NAME, businessData, callbackFunctionName, ...)
    if success then
        exports.tmtaLogger:log("business", "Added business")
    end

    return exports.tmtaSQLite:dbQuery('SELECT * FROM `business` ORDER BY `businessId` DESC LIMIT 1', callbackFunctionName, ...)
end

addEvent("tmtaBusiness.addBusinessRequest", true)
addEventHandler("tmtaBusiness.addBusinessRequest", resourceRoot,
    function(posX, posY, posZ, type, price, revenue)
        local player = client
        local success = Business.add(posX, posY, posZ, type, price, revenue, "dbAddBusiness", {player = player})
        if not success then
            triggerClientEvent(player, "tmtaBusiness.addBusinessResponse", resourceRoot, false)
        end
    end
)

function dbAddBusiness(result, params)
	if not params or not isElement(params.player) then
        return
    end
    local player = params.player
	local success = not not result
    
    if success then
        Business.createMarker(result[1])
    end

    triggerClientEvent(player, "tmtaBusiness.addBusinessResponse", resourceRoot, success)
end

function Business.remove(player, businessId, callbackFunctionName, ...)
    if not isElement(player) then
        return false
    end

    if type(businessId) ~= "number" then
        outputDebugString("Business.remove: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end

    local success = exports.tmtaSQLite:dbTableDelete(BUSINESS_TABLE_NAME, { businessId = businessId }, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

    exports.tmtaLogger:log("business", 
		string.format("Removed business %s. Success: %s", 
			tostring(businessId), 
			tostring(success)
        )
    )

    return success
end

function Business.update(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("Business.update: bad arguments", 1)
        return false
    end

    local success = exports.tmtaSQLite:dbTableUpdate(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)

    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

-- Получить список всех бизнесов игрока
function Business.getPlayerBusiness(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
        outputDebugString("Business.getPlayerBusiness: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME, {}, { userId = userId }, callbackFunctionName, ...)
end

function Business.createMarker(businessData)
    if type(businessData) ~= 'table' then
        return false
    end

    local businessId = businessData.businessId
    if (not businessId or type(businessId) ~= 'number') then
        outputDebugString("Business.createMarker: error businessId", 1)
        return false
    end

    if businessData.userId then
        local result = exports.tmtaCore:getUserDataById(tonumber(businessData.userId), {'nickname'})
        businessData.owner = result[1].nickname
    end

    local position = fromJSON(businessData.position)
    local businessMarker = createMarker(position.x, position.y, position.z-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
    local businessPickup = createPickup(position.x+0.05, position.y-0.05, position.z, 3, Config.PICKUP_ID, 500)

    businessMarker:setData('businessId', businessId)
    businessMarker:setData('isBusinessMarker', true)
    businessMarker:setData('businessData', businessData)

    createdBusiness[businessId] = {
        businessMarker = businessMarker,
        businessPickup = businessPickup,
    }

    BusinessRevenue.startTracking(businessData)

    return true
end

function Business.updateMarker(businessId)
    if (type(businessId) ~= "number" or not createdBusiness[businessId]) then
        outputDebugString("Business.updateMarker: bad arguments", 1)
        return false
    end

    return Business.get(businessId, {}, 'dbUpdateBusiness', {businessId = businessId})
end

function Business.destroyMarker(businessId)
    if (type(businessId) ~= "number" or not createdBusiness[businessId]) then
        outputDebugString("Business.destroyMarker: bad arguments", 1)
        return false
    end

    BusinessRevenue.stopTracking(businessId)
    destroyElement(createdBusiness[businessId].businessMarker)
    destroyElement(createdBusiness[businessId].businessPickup)
    createdBusiness[businessId] = nil

    return true
end

function Business.buy(player, businessId)
    if (not isElement(player) or type(businessId) ~= 'number') then
        return false
    end

    local businessData = Business.get(businessId)
    businessData = businessData[1]
    if (businessData.userId) then
        outputDebugString("Business.buy: error buying business", 1)
        exports.tmtaLogger:log(
            "business",
            string.format("Error buying business (%d). Business owner user %d", businessId, businessData.userId)
        )
        return triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'error', 'Ошибка покупки бизнеса. Обратитесь к Администратору!')
    end

    local userId = player:getData("userId")
    local playerBusiness = Business.getPlayerBusiness(userId)
    if (#playerBusiness >= Config.PLAYER_MAX_BUSINESS) then
        local errorMessage = string.format('Вы можете одновремено владеть только %d бизнесом', Config.PLAYER_MAX_BUSINESS)
        return false, errorMessage
    end

    -- if (exports.tmtaExperience:getPlayerLvl(player) < Config.PLAYER_REQUIRED_LVL) then
    --     local errorMessage = string.format('Для покупки бизнеса требуется %d+ уровень', Config.PLAYER_REQUIRED_LVL)
    --     return false, errorMessage
    -- end

    if (not exports.tmtaRevenueService:isPlayerBusinessEntity(player)) then
        local errorMessage = 'Для владения бизнесом Вам необходимо всать на учёт в налоговой службе'
        return false, errorMessage
    end

    local playerHouses = exports.tmtaHouse:getPlayerHouses(player)
    if (type(playerHouses) ~= 'table' or #playerHouses == 0) then
        local errorMessage = 'Для покупки бизнеса необходимо наличие недвижимости'
        return false, errorMessage
    end
    
    if (exports.tmtaMoney:getPlayerMoney(player) < businessData.price) then
        local errorMessage = 'Недостаточно средств для покупки бизнеса'
        return false, errorMessage
    end

    local businnesData = {
        userId = userId, 
        accrueRevenueAt = BusinessRevenue.getDateAccrueRevenue(),
    }

    return Business.update(businessId, businnesData, "dbBuyBusiness", {
        player = player, 
        userId = userId, 
        businessId = businessId, 
        businessPrice = businessData.price,
    })
end

addEvent("tmtaBusiness.onPlayerBuyBusiness", true)
addEventHandler("tmtaBusiness.onPlayerBuyBusiness", resourceRoot,
    function(businessId)
        local player = client
        if (not isElement(player) or type(businessId) ~= "number") then
            return
        end

        if not createdBusiness[businessId] then
            return
        end

        local success, errorMessage = Business.buy(player, businessId)
        if (not success and errorMessage) then
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

function dbBuyBusiness(result, params)
    if (not params or not isElement(params.player)) then
        return false
    end

    local player = params.player
    local businessId = params.businessId
    local businessPrice = params.businessPrice

    result = not not result
    if result then
        exports.tmtaMoney:takePlayerMoney(player, tonumber(businessPrice))
        triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'success', 'Поздравляем с покупкой бизнеса!')

        Business.updateMarkerbusinessId)

        exports.tmtaLogger:log(
            "business",
            string.format("User id=%d buy business id=%d for %d", player:getData('userId'), businessId, tonumber(businessPrice))
        )
    end

    return result
end

function dbUpdateBusiness(result, params)
    if (not params) then
        return false
    end
    
    local success = not not result
    if (success) then
        local businessId = params.businessId
        local businessData = result[1]

        if businessData.userId then
            local result = exports.tmtaCore:getUserDataById(tonumber(businessData.userId), {'nickname'})
            businessData.owner = result[1].nickname
        end
    
        createdBusiness[businessId].businessMarker:setData('businessData', businessData)
    end

    return success
end

function Business.sell(businessId)
    if (type(businessId) ~= "number") then
        return false
    end

    local businessData = Business.get(businessId)
    businessData = businessData[1]
    if (not businessData.userId) then
        outputDebugString("Business.sell: error selling business", 1)
        exports.tmtaLogger:log(
            "business",
            string.format("Error selling  business (%d).", businessId)
        )
        return false
    end

    local price = tonumber(businessData.price - (businessData.price * Config.SELL_COMMISSION/100))
    local balance = tonumber(businessData.balance - (businessData.balance * Config.WITHDRAWAL_FEE/100))

    --TODO: снимать неоплаченный налог

    return Business.update(businessId, {
        userId = 'NULL',
        balance = 0,
        accrueRevenueAt = 'NULL',
        confiscateAt = 'NULL',
    }, 'dbSellBusiness', {
        businessId = businessId,
        userId = businessData.userId, 
        price = price,
        balance = balance,
    })
end

addEvent("tmtaBusiness.onPlayerSellBusiness", true)
addEventHandler("tmtaBusiness.onPlayerSellBusiness", resourceRoot,
    function(businessId)
        local player = client
        if (not isElement(player) or type(businessId) ~= "number" or not createdBusiness[businessId]) then
            return
        end
        Business.sell(businessId)
    end
)

function dbSellBusiness(result, params)
    if (not params) then
        return false
    end
    
    local businessId = params.businessId
    local userId = params.userId
    local price = params.price
    local balance = params.balance

    result = not not result
    if result then
        local businessData = Business.get(businessId)
        businessData = businessData[1]

        local userId = tonumber(businessData.userId)
        local money = tonumber(price+balance)

        local player = exports.tmtaCore:getUserPlayerById(userId)
        if (isElement(player)) then
            exports.tmtaMoney:givePlayerMoney(player, money)
            local message = string.format('Вы продали бизнес. На ваш счет зачислено %s ₽', exports.tmtaUtils:formatMoney(money))
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'success', message)
        else
            local userDataResult = exports.tmtaCore:getUserDataById(userId, {'money'})
            local userMoney = tonumber(userDataResult[1].money)
            exports.tmtaCore:updateUserDataById(userId, {money = tonumber(userMoney + money)})
        end

        Business.updateMarker(businessId)

        exports.tmtaLogger:log('business', string.format("User id=%d sell business id=%d for %d", userId, businessId, money))
    end

    return result
end

function Business.takeMoney(player, businessId)
    if (not isElement(player) or type(businessId) ~= "number") then
        return false
    end

    local businessData = Business.get(businessId)
    businessData = businessData[1]
    if (not businessData.userId) then
        outputDebugString("Business.takeMoney: error take money from business", 1)
        exports.tmtaLogger:log(
            "business",
            string.format("Error take money from  business (%d).", businessId)
        )
        triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'error', 'Ошибка вывода средств с бизнеса. Обратитесь к Администратору!')
        return false
    end

    local userId = player:getData("userId")
    if (userId ~= businessData.userId) then
        return false
    end

    return Business.update(businessId, {
        balance = 0,
    }, "dbTakeMoneyFromBusiness", {
        player = player, 
        userId = userId, 
        businessId = businessId,
        balance = tonumber(businessData.balance),
    })
end

addEvent("tmtaBusiness.onPlayerTakeMoneyFromBusiness", true)
addEventHandler("tmtaBusiness.onPlayerTakeMoneyFromBusiness", resourceRoot,
    function(businessId)
        local player = client
        if (not isElement(player) or type(businessId) ~= "number") then
            return
        end

        if (not createdBusiness[businessId]) then
            return
        end

        local success, errorMessage = Business.takeMoney(player, businessId)
        if (not success and errorMessage) then
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

function dbTakeMoneyFromBusiness(result, params)
    if (not params or not isElement(params.player)) then
        return false
    end

    local player = params.player
    local businessId = params.businessId
    local balance = params.balance

    result = not not result
    if result then
        local money = tonumber(balance - (balance * Config.WITHDRAWAL_FEE/100))
        exports.tmtaMoney:givePlayerMoney(player, money)

        local message = string.format('Вы сняли с кассы бизнеса деньги. На ваш счет зачислено %s ₽', exports.tmtaUtils:formatMoney(money))
        triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'success', message)

        Business.updateMarker(businessId)

        exports.tmtaLogger:log("business", string.format("User id=%d take %d from business id=%d", businessData.userId, money, businessId))
    end

    return result
end

-- function Business.sellToPlayer(player, businessId)
-- end

-- function Business.changeName(businessId)
-- end