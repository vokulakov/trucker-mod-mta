RevenueService = {}

REVENUE_SERVICE_TABLE_NAME = 'revenueService'

function RevenueService.setup()
    exports.tmtaSQLite:dbTableCreate(REVENUE_SERVICE_TABLE_NAME, {
        {name = 'userId', type = 'INTEGER', options = 'NOT NULL UNIQUE'},
        {name = 'individualNumber', type = 'VARCHAR', size = '12', options = 'NOT NULL UNIQUE'},
        {name = 'isBusinessEntity', type = 'INTEGER', options = 'DEFAULT 0'}, -- флаг юридической регистрации
        {name = 'propertyTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате налог на имущество
        {name = 'incomeTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате подоходный налог
        {name = 'vehicleTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате транспортный налог
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

addEvent('tmtaRevenueService.onPlayerPaidTax', true)

--- Генерация индивидуального номера налогоплательщика
local function generateIndividualTaxNumber()
    local code = string.format("%02d", math.random(1, 9))
    local inspection = string.format("%02d", math.random(1, 99))

    local realTime = tostring(getRealTime().timestamp):sub(-2)
    local tick = tostring(getTickCount()):sub(-3)
    local num = tonumber(realTime..tick)

    return code..inspection..num
end

function RevenueService.add(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
		executeCallback(callbackFunctionName, false)
		outputDebugString("RevenueService.addUser: bad arguments", 1)
		return false
	end

    local individualNumber = generateIndividualTaxNumber()
	if not individualNumber then
		outputDebugString("RevenueService.add: failed to generate individualNumber", 1)
		return false
	end

    local success = exports.tmtaSQLite:dbTableInsert(REVENUE_SERVICE_TABLE_NAME, {
        userId = userId,
        individualNumber = individualNumber
    }, callbackFunctionName, ...)

    if not success then
		outputDebugString("RevenueService.add: failed to add", 1)
		executeCallback(callbackFunctionName, false)
	end

    exports.tmtaLogger:log(
		"revenueService", 
		string.format("Added individualNumber %s to user %s.", 
			tostring(individualNumber),
			tostring(userId)
		)
	)

	return not not success, RevenueService.getUserDataById(userId, {}, callbackFunctionName, ...)
end

function RevenueService.update(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
        return false
    end
    
    return exports.tmtaSQLite:dbTableUpdate(REVENUE_SERVICE_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end

function RevenueService.getUserDataById(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
		executeCallback(callbackFunctionName, false)
		outputDebugString("RevenueService.getDataByUserId: bad arguments", 1)
		return false
	end

    return exports.tmtaSQLite:dbTableSelect(REVENUE_SERVICE_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end

function RevenueService.getPlayerData(player)
    if not isElement(player) then
        return false
    end

    local userId = player:getData('userId')
    return RevenueService.getUserDataById(userId, {}, 'dbRevenueServiceGetUserData', {player = player})
end

function dbRevenueServiceGetUserData(result, params)
	if not params then
        return
    end

    local player = params.player
	local success = not not result

    if (not success or not isElement(player)) then
        return
    end

    if (type(result) ~= 'table' or #result == 0) then
        local userId = player:getData('userId')
        return RevenueService.add(userId, "dbRevenueServiceGetUserData", {player = player})
    end

    result = result[1]

    player:setData('individualNumber', result.individualNumber)
    player:setData('isBusinessEntity', exports.tmtaUtils:tobool(result.isBusinessEntity))

    local propertyTaxPayable = tonumber(result.propertyTaxPayable) or 0
    player:setData('propertyTaxPayable', propertyTaxPayable)

    local incomeTaxPayable = tonumber(result.incomeTaxPayable) or 0
    player:setData('incomeTaxPayable', incomeTaxPayable)

    local vehicleTaxPayable = tonumber(result.vehicleTaxPayable) or 0
    player:setData('vehicleTaxPayable', vehicleTaxPayable)

    player:setData('taxAmount', propertyTaxPayable+incomeTaxPayable+vehicleTaxPayable)
end

function RevenueService.setPlayerBisinessEntity(player)
    if not isElement(player) then
        return false
    end
    return not not RevenueService.update(player:getData('userId'), {isBusinessEntity = true})
end

addEvent('tmtaRevenueService.onPlayerRegisterBusinessEntity', true)
addEventHandler('tmtaRevenueService.onPlayerRegisterBusinessEntity', root, 
    function()
        local player = client
        if not isElement(player) then
            return
        end

        if (player:getData('isBusinessEntity')) then
            local message = 'Вы уже зарегистрированы в налоговой службе'
            triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'warning', message)
            return
        end

        if (exports.tmtaMoney:getPlayerMoney(player) < Config.BUSINESS_ENTITY_PRICE) then
            local message = 'У вас недостаточно средств для регистрации в налоговой службе'
            triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'error', message)
            return
        end

        local success = RevenueService.setPlayerBisinessEntity(player)
        if (not success) then
            local message = 'Неизвестная ошибка. Обратитесь к администратору!'
            triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'error', message)
            return
        end

        exports.tmtaMoney:takePlayerMoney(player, tonumber(Config.BUSINESS_ENTITY_PRICE))
        RevenueService.getPlayerData(player)

        local message = 'Поздравляем! Теперь Вы можете заниматься предпринимательской\nдеятельностью.'
        triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'success', message)
        triggerClientEvent(player, 'tmtaRevenueService.updateRevenueServiceGUI', resourceRoot)

        exports.tmtaLogger:log("revenueService", string.format("Register user %s as business entity", tostring(player:getData('userId'))))
    end
)

function RevenueService.addUserPropertyTax(userId, taxAmount)
    if (type(userId) ~= "number" or type(taxAmount) ~= "number") then
        return false
    end
    taxAmount = math.ceil(math.abs(taxAmount))

    local result = RevenueService.getUserDataById(userId, {'propertyTaxPayable'})
    propertyTaxPayable = (type(result) ~= "table" or #result == 0) and 0 or tonumber(result[1].propertyTaxPayable)
    propertyTaxPayable = propertyTaxPayable + taxAmount

    local success = not not RevenueService.update(userId, {propertyTaxPayable = propertyTaxPayable})
    if (success) then
        local player = exports.tmtaCore:getPlayerByUserId(userId)
        if (isElement(player)) then
            player:setData('propertyTaxPayable', propertyTaxPayable)
            player:setData('taxAmount', player:getData('taxAmount') + taxAmount)
            local message = string.format('Вам начислен налог на имущество в размере %s ₽. Оплатите его в ближайшем отделение налоговой службы.', taxAmount)
            triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'info', message)

            exports.tmtaLogger:log("revenueService", string.format('The user %s is charged a tax of %d', tostring(userId), tonumber(taxAmount)))
        end
    end

    return success
end

function RevenueService.userPayTax(userId, taxType, taxAmount)
    if (type(userId) ~= 'number' or type(taxAmount) ~= 'number') then
        return false
    end

    if (taxType == 'all') then
    end
 
    return not not RevenueService.update(userId, fields)
end

addEvent('tmtaRevenueService.onPlayerPayTax', true)
addEventHandler('tmtaRevenueService.onPlayerPayTax', root, 
    function(taxType, taxAmount)
        local player = client
        if not isElement(player) then
            return
        end

        if (not taxType and not taxAmount) then
            taxType = 'all'
            taxAmount = player:getData('taxAmount')
        end

        if (taxAmount <= 0) then
            return
        end

        if (exports.tmtaMoney:getPlayerMoney(player) < taxAmount) then
            local message = 'У вас недостаточно средств для оплаты налога'
            triggerClientEvent(player, 'tmtaRevenueService.showNotice', resourceRoot, 'error', message)
            return
        end

        if (RevenueService.userPayTax(player:getData('userId'), taxType, taxAmount)) then
            triggerClientEvent(player, 'tmtaRevenueService.onPlayerPaidTax', resourceRoot, taxType, taxAmount)
            triggerEvent('tmtaRevenueService.onPlayerPaidTax', player, taxType, taxAmount)

            RevenueService.getPlayerData(player)

            triggerClientEvent(player, 'tmtaRevenueService.updateRevenueServiceGUI', resourceRoot)
        end
    end
)