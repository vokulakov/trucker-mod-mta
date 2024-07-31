Vehicle = {}

VEHICLE_TABLE_NAME = 'vehicle'

local VEHICLE_STATUS_DEFAULT = 0
local VEHICLE_STATUS_DAMAGED = 1
local VEHICLE_STATUS_ARRESTED = 2

local VEHICLE_STATUS_DEFAULT_LABEL = 'По умолчанию'
local VEHICLE_STATUS_DAMAGED_LABEL = 'Повреждена'
local VEHICLE_STATUS_ARRESTED_LABEL = 'Арестована'

local VEHICLE_TYPE_PRIVATE = 0
local VEHICLE_TYPE_RENT = 1
local VEHICLE_TYPE_COMMERCIAL = 2
local VEHICLE_TYPE_STATE = 3

local VEHICLE_TYPE_PRIVATE_LABEL = 'Личная'
local VEHICLE_TYPE_RENT_LABEL = 'Арендная'
local VEHICLE_TYPE_COMMERCIAL_LABEL = 'Коммерческая'
local VEHICLE_TYPE_STATE_LABEL = 'Государственная'

function Vehicle.setup()
    exports.tmtaSQLite:dbTableCreate(HOUSE_TABLE_NAME, {
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

        {name = "type", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "status", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "isDoorsLocked", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
    })
end

local function generateVehicleIdentificationNumber()
end

function Vehicle.add(model, callbackFunctionName, ...)
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