NumberPlate = {}

local NUMBER_PLATE_TABLE_NAME = 'numberPlate'

function NumberPlate.setup()
    exports.tmtaSQLite:dbTableCreate(NUMBER_PLATE_TABLE_NAME, {
        {name = 'type', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'},
        {name = 'region', type = 'INTEGER'},
        {name = "numberPlate", type = "VARCHAR", size = 64, options = 'NOT NULL'},
        {name = 'userId', type = 'INTEGER'},
        {name = 'vehicleId', type = 'INTEGER'},
        {name = 'inStorage', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'},
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

function NumberPlate.add()
end

function NumberPlate.delete(numberPlateId, callbackFunctionName, ...)
    if (type(numberPlateId) ~= "number") then
        outputDebugString("NumberPlate.delete: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end

    local success = exports.tmtaSQLite:dbTableDelete(NUMBER_PLATE_TABLE_NAME, { businessId = businessId }, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

function NumberPlate.update(numberPlateId, fields, callbackFunctionName, ...)
    if (type(numberPlateId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("NumberPlate.update: bad arguments", 1)
        return false
    end

    local success = exports.tmtaSQLite:dbTableUpdate(BUSINESS_TABLE_NAME, fields, {numberPlateId = numberPlateId}, callbackFunctionName, ...)
    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

function NumberPlate.get(numberPlateId, fields, callbackFunctionName, ...)
    if (type(numberPlateId) ~= "number") then
        outputDebugString("NumberPlate.get: bad arguments", 1)
        return false
    end

    fields = (type(fields) ~= "table") and {} or fields
    return exports.tmtaSQLite:dbTableSelect(NUMBER_PLATE_TABLE_NAME, fields, {numberPlateId = numberPlateId}, callbackFunctionName, ...)
end

function NumberPlate.getUserNumberPlates(userId, callbackFunctionName, ...)
    if (type(userId) ~= "number") then
        outputDebugString("NumberPlate.getUserNumberPlates: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end

    return exports.tmtaSQLite:dbTableSelect(NUMBER_PLATE_TABLE_NAME, {}, { userId = userId }, callbackFunctionName, ...)
end

function NumberPlate.getPlayerNumberPlates(player, callbackFunctionName, ...)
    if (not isElement(player)) then
        outputDebugString("NumberPlate.getPlayerNumberPlates: bad arguments", 1)
        return false
    end
    
    return NumberPlate.getUserNumberPlates(player:getData('userId'), callbackFunctionName, ...)
end