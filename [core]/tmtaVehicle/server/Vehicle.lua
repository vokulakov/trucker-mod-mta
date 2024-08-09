Vehicle = {}

VEHICLE_TABLE_NAME = 'vehicle'

VEHICLE_STATUS_DEFAULT = 0
VEHICLE_STATUS_DAMAGED = 1
VEHICLE_STATUS_ARRESTED = 2

VEHICLE_STATUS_DEFAULT_LABEL = 'По умолчанию'
VEHICLE_STATUS_DAMAGED_LABEL = 'Повреждена'
VEHICLE_STATUS_ARRESTED_LABEL = 'Арестована'

VEHICLE_TYPE_PRIVATE = 0
VEHICLE_TYPE_RENT = 1
VEHICLE_TYPE_COMMERCIAL = 2
VEHICLE_TYPE_STATE = 3

VEHICLE_TYPE_PRIVATE_LABEL = 'Личная'
VEHICLE_TYPE_RENT_LABEL = 'Арендная'
VEHICLE_TYPE_COMMERCIAL_LABEL = 'Коммерческая'
VEHICLE_TYPE_STATE_LABEL = 'Государственная'

function Vehicle.setup()
    exports.tmtaSQLite:dbTableCreate(VEHICLE_TABLE_NAME, {
        {name = "model", type = "INTEGER", options = "NOT NULL"},
        {name = "vin", type = "varchar", size = 17, options = "UNIQUE NOT NULL"},

        {name = "price", type = "INTEGER", options = "DEFAULT 0 NOT NULL"}, -- государственная цена транспорта 
        {name = "estimatePrice", type = "INTEGER", options = "DEFAULT 0 NOT NULL"}, -- оценочная цена (тюнинг, пробег)

        {name = "position", type = "TEXT"},
        {name = "rotation", type = "TEXT"},
        {name = "interior", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "dimension", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},

        {name = "mileage", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "health", type = "INTEGER", options = "DEFAULT 1000 NOT NULL"},
        {name = "fuel", type = "INTEGER", options = "DEFAULT 25 NOT NULL"},

        {name = "gloveCompartment", type = "TEXT"}, -- feature: бардачок
        {name = "inventory", type = "TEXT"}, -- feature: инвентарь (багажник)
        {name = "partsWear", type = "TEXT"}, -- feature: износ деталей
        {name = "wheelsState", type = "TEXT"}, -- feature: состояние колес

        {name = "handling", type = "TEXT"},
        {name = "tuning", type = "TEXT"},
        {name = "stickers", type = "TEXT"},

        {name = "numberPlateId", type = "INTEGER"},

        {name = "type", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "status", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "isDoorsLocked", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
    }, "FOREIGN KEY (numberPlateId)\n\tREFERENCES numberPlate (numberPlateId)\n\tON DELETE SET NULL")
end

function vehicleTypeLabels()
    return {
        VEHICLE_TYPE_PRIVATE = VEHICLE_TYPE_PRIVATE_LABEL,
        VEHICLE_TYPE_RENT = VEHICLE_TYPE_RENT_LABEL,
        VEHICLE_TYPE_COMMERCIAL = VEHICLE_TYPE_COMMERCIAL_LABEL,
        VEHICLE_TYPE_STATE = VEHICLE_TYPE_STATE_LABEL,
    }
end

local function generateVehicleIdentificationNumber()
    local realTime = tostring(getRealTime().timestamp):sub(-2)
	local tick = tostring(getTickCount()):sub(-3)
	return string.format("VIN%02d%.2X%02d", math.random(1, 9), tonumber(realTime..tick), math.random(1, 99))
end

function Vehicle.add(vehicleModel, vehicleType, callbackFunctionName, ...)
    if 	(type(vehicleModel) ~= "number" or type(vehicleType) ~= 'number' or not vehicleTypeLabels()[vehicleType]) then
		executeCallback(callbackFunctionName, false)
		outputDebugString("Vehicle.add: bad arguments", 1)
		return false
	end

    if not isValidVehicleModel(vehicleModel) then
        executeCallback(callbackFunctionName, false)
        outputDebugString("Vehicle.add: Invalid vehicle model", 1)
        return false
    end
    
    local vehicleData = {
        model = vehicleModel,
        vin = generateVehicleIdentificationNumber(),
        type = vehicleType,
    }

    local success = exports.tmtaSQLite:dbTableInsert(VEHICLE_TABLE_NAME, vehicleData, callbackFunctionName, ...)
    if not success then
        return false
    end

    return exports.tmtaSQLite:dbQuery('SELECT * FROM `vehicle` ORDER BY `vehicleId` DESC LIMIT 1', callbackFunctionName, ...)
end

function Vehicle.remove(vehicleId, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("Vehicle.remove: bad arguments", 1)
        return false
    end

    return exports.tmtaSQLite:dbTableDelete(VEHICLE_TABLE_NAME, {vehicleId = vehicleId}, callbackFunctionName, ...)
end

function Vehicle.get(vehicleId, fields, callbackFunctionName, ...)
    if (type(vehicleId) ~= "number") then
        outputDebugString("Vehicle.get: bad arguments", 1)
        return false
    end

    fields = (type(fields) ~= "table") and {} or fields
    return exports.tmtaSQLite:dbTableSelect(VEHICLE_TABLE_NAME, fields, {vehicleId = vehicleId}, callbackFunctionName, ...)
end