Business = {}

BUSINESS_TABLE_NAME = 'business'

function Business.setup()
    exports.tmtaSQLite:dbTableCreate(BUSINESS_TABLE_NAME, {
        {name = 'name', type = 'VARCHAR', size = 128, options = 'NOT NULL'},
        {name = 'price', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'},
        {name = 'balance', type = 'INTEGER'},

        {name = 'payAmount', type = 'INTEGER'},
        {name = 'taxAmount', type = 'INTEGER'}, -- сумма налога (к оплате)
        {name = 'taxUnpayedWeeks', type = 'INTEGER'}, -- сколько недель не оплачивался налог

        {name = 'position', type = 'TEXT'},
        {name = 'upgrades', type = 'TEXT'},
        {name = 'ownerId', type = 'INTEGER'},
        {name = 'editorId', type = 'INTEGER'},
    }, 
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (editorId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

function Business.get(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("Business.get: bad arguments", 1)
        return false
    end

    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)
end

function Business.add(posX, posY, posZ, callbackFunctionName, ...)
    local player = client
    if not isElement(player) then
        return false
    end
end

function Business.remove()
end

function Business.update(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("Business.update: bad arguments", 1)
        return false
    end

    local success = DatabaseTable.update(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)

    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

function Business.buy(player, businessId)
end

function Business.takeMoney(player, businessId)
end

function Business.sell(player, businessId)
end

function Business.sellToPlayer(player, businessId)
end

function Business.buyUpgrade(player, businessId)
end

function Business.changeName(businessId)
end