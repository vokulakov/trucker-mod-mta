UserVehicle = {}

USER_VEHICLE_TABLE_NAME = 'userVehicle'

function UserVehicle.setup()
    exports.tmtaSQLite:dbTableCreate(USER_VEHICLE_TABLE_NAME, {
        {name = "model", type = "INTEGER", options = "NOT NULL"},
        {name = "modelName", type = "TEXT", options = "NOT NULL"},
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

        {name = "licensePlateId", type = "INTEGER"},

        {name = "userId", type = "INTEGER", options = "NOT NULL"},
    },
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE CASCADE,\n"..
        "FOREIGN KEY (licensePlateId)\n\tREFERENCES licensePlate (licensePlateId)\n\tON DELETE SET NULL")

    --exports.tmtaSQLite:dbTableAddColumn(USER_VEHICLE_TABLE_NAME, 'modelName', 'TEXT')
end

local function generateVehicleIdentificationNumber()
    local realTime = tostring(getRealTime().timestamp):sub(-2)
	local tick = tostring(getTickCount()):sub(-3)
	return string.format("VIN%03d%.2X%03d", math.random(1, 99), tonumber(realTime..tick), math.random(1, 999))
end

function UserVehicle.add(userId, model, fields, callbackFunctionName, ...)
    if not (type(userId) == 'number' and model and (type(model) == 'number' or type(model) == 'string')) then
        executeCallback(_G[callbackFunctionName], false)
        outputDebugString("UserVehicle.add: bad arguments", 1)
        return false
    end

    if (type(model) == 'string') then
        model = getVehicleModelFromName(model)
    end

    if (not model or type(model) ~= 'number' or not isValidVehicleModel(model)) then
        executeCallback(_G[callbackFunctionName], false)
        outputDebugString("UserVehicle.add: Invalid vehicle model", 1)
        return false
    end

    if (not fields or type(fields) ~= 'table') then
        fields = {}
    end

    fields.model = model
    fields.vin = generateVehicleIdentificationNumber()
    fields.userId = userId
    fields.modelName = getVehicleNameFromModel(model)

    local success = exports.tmtaSQLite:dbTableInsert(USER_VEHICLE_TABLE_NAME, fields)
    success = not not success
    
    exports.tmtaLogger:log("userVehicles",
        string.format("Added vehicle %s to user %s. Success: %s",
            tostring(model),
            tostring(userId),
            tostring(success)
        )
    )
    
    if not success then
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT * FROM `??` ORDER BY `??` DESC LIMIT 1
    ]], USER_VEHICLE_TABLE_NAME, 'userVehicleId')

    return exports.tmtaSQLite:dbQuery(queryString, callbackFunctionName, ...)
end

function UserVehicle.update(vehicleId, fields, callbackFunctionName, ...)
	if (type(vehicleId) ~= "number" or type(fields) ~= "table") then
		executeCallback(_G[callbackFunctionName], false)
        outputDebugString("UserVehicles.update: bad arguments", 1)
		return false
	end

    local success = exports.tmtaSQLite:dbTableUpdate(USER_VEHICLE_TABLE_NAME, fields, {userVehicleId = vehicleId}, callbackFunctionName, ...)
	if not success then
		executeCallback(_G[callbackFunctionName], false)
	end

	return success
end

function UserVehicle.remove(vehicleId, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("UserVehicle.remove: bad arguments", 1)
        return false
    end
    return exports.tmtaSQLite:dbTableDelete(USER_VEHICLE_TABLE_NAME, {userVehicleId = vehicleId}, callbackFunctionName, ...)
end

function UserVehicle.get(vehicleId, fields, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("UserVehicle.get: bad arguments", 1)
        return false
    end

    if (not fields or type(fields) ~= 'table') then
        fields = '*'
    else
        fields = table.concat(fields, ",")
    end

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT ??, t1.userId, t2.numberPlate, t2.type AS numberPlateType 
        FROM `??` AS t1
        LEFT JOIN `??` AS t2 ON t2.vehicleId = t1.userVehicleId
        WHERE t1.userVehicleId = ?
    ]], fields, USER_VEHICLE_TABLE_NAME, 'licensePlate', vehicleId)

    return exports.tmtaSQLite:dbQuery(queryString, callbackFunctionName, ...)
end

function UserVehicle.getUserVehicles(userId, callbackFunctionName, ...)
    if (type(userId) ~= "number") then
		outputDebugString("UserVehicle.get: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT *, t2.numberPlate, t2.type AS numberPlateType
        FROM `??` AS t1
        LEFT JOIN `??` AS t2 ON t2.vehicleId = t1.userVehicleId
        WHERE t1.userId = ?
    ]], USER_VEHICLE_TABLE_NAME, 'licensePlate', userId)

    return exports.tmtaSQLite:dbQuery(queryString, callbackFunctionName, ...)
end

function UserVehicle.getUserVehiclesIds(userId, callbackFunctionName, ...)
	if type(userId) ~= "number" then
        outputDebugString("UserVehicle.getUserVehiclesIds: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
		return false
	end
	return exports.tmtaSQLite:dbTableSelect(USER_VEHICLE_TABLE_NAME, {'userVehicleId'}, {userId = userId}, callbackFunctionName, ...)
end

function UserVehicle.changeOwner()
end

function UserVehicle.getVehicleOwner()
end