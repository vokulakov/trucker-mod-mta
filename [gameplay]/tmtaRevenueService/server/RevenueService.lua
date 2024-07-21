RevenueService = {}

REVENUE_SERVICE_TABLE_NAME = 'revenueService'

function RevenueService.setup()
    exports.tmtaSQLite:dbTableCreate(REVENUE_SERVICE_TABLE_NAME, {
        {name = 'userId', type = 'INTEGER', options = 'NOT NULL UNIQUE'},
        {name = 'individualNumber', type = 'VARCHAR', size = '12', options = 'NOT NULL UNIQUE'},
        {name = 'isBusinessEntity', type = 'INTEGER', options = 'DEFAULT 0'}, -- флаг юридической регистрации
        {name = 'propertyTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате налог на имущество
        {name = 'revenueTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате подоходный налог
        {name = 'vehicleTaxPayable', type = 'INTEGER', options = 'DEFAULT 0'}, -- подлежащий уплате транспортный налог
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

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

function RevenueService.getUserDataById(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
		executeCallback(callbackFunctionName, false)
		outputDebugString("RevenueService.getDataByUserId: bad arguments", 1)
		return false
	end

    return exports.tmtaSQLite:dbTableSelect(REVENUE_SERVICE_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end

function RevenueService.update()
    if (type(userId) ~= "string" or type(fields) ~= "table") then
        return false
    end
    return exports.tmtaSQLite:dbTableUpdate(REVENUE_SERVICE_TABLE_NAME, fields, {userId = userId}, "callback")
end