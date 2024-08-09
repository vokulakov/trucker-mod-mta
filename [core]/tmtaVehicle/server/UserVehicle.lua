UserVehicle = {}

USER_VEHICLE_TABLE_NAME = 'userVehicle'

function UserVehicle.setup()
    exports.tmtaSQLite:dbTableCreate(USER_VEHICLE_TABLE_NAME, {
        {name = "model", type = "INTEGER", options = "NOT NULL"},
        {name = "vin", type = "varchar", size = 17, options = "UNIQUE NOT NULL"},

        {name = "price", type = "INTEGER", options = "DEFAULT 0 NOT NULL"}, -- государственная цена транспорта 
        {name = "estimatePrice", type = "INTEGER", options = "DEFAULT 0 NOT NULL"}, -- оценочная цена (тюнинг, пробег)

        {name = "mileage", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "health", type = "INTEGER", options = "DEFAULT 1000 NOT NULL"},
        {name = "fuel", type = "INTEGER", options = "DEFAULT 25 NOT NULL"},

        {name = "gloveCompartment", type = "TEXT"}, -- feature: бардачок
        {name = "inventory", type = "TEXT"}, -- feature: инвентарь (багажник)
        {name = "partsWear", type = "TEXT"}, -- feature: износ деталей
        {name = "wheelsState", type = "TEXT"}, -- feature: состояние колес
        
        {name = "colors", type = "TEXT"},
        {name = "handling", type = "TEXT"},
        {name = "tuning", type = "TEXT"},
        {name = "stickers", type = "TEXT"},

        {name = "numberPlateId", type = "INTEGER"},

        {name = "userId", type = "INTEGER", options = "NOT NULL"},
    },
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (numberPlateId)\n\tREFERENCES vehicleNumberPlate (numberPlateId)\n\tON DELETE SET NULL")
end

local function generateVehicleIdentificationNumber()
    local realTime = tostring(getRealTime().timestamp):sub(-2)
	local tick = tostring(getTickCount()):sub(-3)
	return string.format("VIN%02d%.2X%02d", math.random(1, 9), tonumber(realTime..tick), math.random(1, 99))
end

function UserVehicle.addVehicle(userId, model, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(model) ~= "number") then
		executeCallback(callbackFunctionName, false)
		outputDebugString("UserVehicle.addVehicle: bad arguments", 1)
		return false
	end

    if not isValidVehicleModel(model) then
        executeCallback(callbackFunctionName, false)
        outputDebugString("UserVehicle.addVehicle: Invalid vehicle model", 1)
        return false
    end

    if (not fields or type(fields) ~= 'table') then
        fields = {}
    end

    fields.model = model
    fields.vin = generateVehicleIdentificationNumber()

    local success = exports.tmtaSQLite:dbTableInsert(USER_VEHICLE_TABLE_NAME, fields, callbackFunctionName, ...)
    if not success then
        executeCallback(callbackFunctionName, false)
        return false
    end

    exports.tmtaLogger:log("userVehicles",
        string.format("Added vehicle %s to user %s. Success: %s",
            tostring(model),
            tostring(userId),
            tostring(success)
        )
    )

    return exports.tmtaSQLite:dbQuery('SELECT * FROM `userVehicle` ORDER BY `userVehicleId` DESC LIMIT 1', callbackFunctionName, ...)
end

function UserVehicle.updateVehicle(vehicleId, fields, callbackFunctionName, ...)
	if (type(vehicleId) ~= "number" or type(fields) ~= "table") then
		executeCallback(callbackFunctionName, false)
        outputDebugString("UserVehicles.updateVehicle: bad arguments", 1)
		return false
	end

    local success = exports.tmtaSQLite:dbTableUpdate(USER_VEHICLE_TABLE_NAME, fields, {userVehicleId = vehicleId}, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

	return success
end

function UserVehicle.removeVehicle(vehicleId, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("UserVehicle.removeVehicle: bad arguments", 1)
        return false
    end
    return exports.tmtaSQLite:dbTableDelete(USER_VEHICLE_TABLE_NAME, {userVehicleId = vehicleId}, callbackFunctionName, ...)
end

function UserVehicle.getVehicle(vehicleId, fields, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("UserVehicle.getVehicle: bad arguments", 1)
        return false
    end

    if (not fields or type(fields) ~= 'table') then
        fields = {}
    end

    return exports.tmtaSQLite:dbTableSelect(USER_VEHICLE_TABLE_NAME, fields, {userVehicleId = vehicleId}, callbackFunctionName, ...)
end

function UserVehicle.getVehicles(userId, callbackFunctionName, ...)
    if (type(userId) ~= "number") then
		outputDebugString("UserVehicle.getVehicles: bad arguments", 1)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(USER_VEHICLE_TABLE_NAME, {}, {userId = userId}, callbackFunctionName, ...)
end