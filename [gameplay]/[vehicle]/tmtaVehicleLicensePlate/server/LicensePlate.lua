LicensePlate = {}

LICANSE_PLATE_TABLE_NAME = 'licensePlate'

function LicensePlate.setup()
    exports.tmtaSQLite:dbTableCreate(LICANSE_PLATE_TABLE_NAME, {
        {name = 'type', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'}, -- Config.LICENSE_PLATE_TYPE 
        {name = 'numberPlate', type = 'VARCHAR', size = 64},
        {name = 'userId', type = 'INTEGER'},
        {name = 'vehicleId', type = 'INTEGER', options = 'UNIQUE'},
        {name = 'inStorage', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'},
        {name = 'deleteAt', type = 'INTEGER'}, -- время удаления из хранилища
    }, 
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE CASCADE,\n"..
        "FOREIGN KEY (vehicleId)\n\tREFERENCES userVehicle (userVehicleId)\n\tON DELETE CASCADE")
end

local _cacheLicensePlates = false
local function updateCacheLicensePlates()
    _cacheLicensePlates = {}

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[ 
        SELECT * FROM `??` 
    ]], LICANSE_PLATE_TABLE_NAME)

    local result = exports.tmtaSQLite:dbQuery(queryString)
    if (type(result) == 'table' and #result > 0) then
        for _, licensePlate in pairs(result) do
            _cacheLicensePlates[licensePlate.licensePlateId] = licensePlate
        end
    end

    return true
end
setTimer(updateCacheLicensePlates, 60 * 60 * 1000, 0)

local function addLicensePlateToCache(licensePlateId, licensePlateData)
    if (type(licensePlateId) ~= "number" or type(licensePlateData) ~= 'table') then
        return false
    end
    _cacheLicensePlates[licensePlateId] = licensePlateData
end

local function deleteLicensePlateFromCache(licensePlateId)
    if (type(licensePlateId) ~= "number") then
        return false
    end
    _cacheLicensePlates[licensePlateId] = nil
end

function LicensePlate.getLicensePlates()
    if (not _cacheLicensePlates or type(_cacheLicensePlates) ~= 'table') then
        updateCacheLicensePlates()
        return LicensePlate.getLicensePlates()
    end
    return _cacheLicensePlates
end

local _inaccessibleLicensePlate = {}
local function updateInaccessibleLicensePlate(licensePlateType, licensePlate, inaccessible)
    if (not licensePlate or type(licensePlate) ~= 'string' or not licensePlateType or type(licensePlateType) ~= 'string' or type(inaccessible) ~= 'boolean') then
        return false
    end
    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return false
    end

    local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType
    _inaccessibleLicensePlate[string.format('%s_%s', licensePlateType, licensePlate)] = inaccessible and true or nil
    resourceRoot:setData('tmtaVehicleLicensePlate:inaccessibleLicensePlate', _inaccessibleLicensePlate)

    return true
end

local function addInaccessibleLicensePlate(licensePlateType, licensePlate)
    return updateInaccessibleLicensePlate(licensePlateType, licensePlate, true) 
end

local function deleteInaccessibleLicensePlate(licensePlateType, licensePlate)
    return updateInaccessibleLicensePlate(licensePlateType, licensePlate, false)  
end

--- Получить недоступные номерные знаки
function LicensePlate.getInaccessibleLicensePlates()
    _inaccessibleLicensePlate = {}

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT `type`, `numberPlate` 
        FROM `??` 
        WHERE `numberPlate` NOT NULL
    ]], LICANSE_PLATE_TABLE_NAME)

    local result = exports.tmtaSQLite:dbQuery(queryString)
    if (type(result) == 'table' and #result > 0) then
        for _, licensePlate in pairs(result) do
            local licensePlateType = Utils.getCharacterLicensePlateType(licensePlate.type)
            local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType
            if licensePlateType then
                _inaccessibleLicensePlate[string.format('%s_%s', licensePlateType, licensePlate.numberPlate)] = true
            end
        end
    end

    resourceRoot:setData('tmtaVehicleLicensePlate:inaccessibleLicensePlate', _inaccessibleLicensePlate)

    return _inaccessibleLicensePlate
end

--- Получить номерной знак
function LicensePlate.get(licensePlateId, fields, callbackFunctionName, ...)
    if (type(licensePlateId) ~= "number") then
        outputDebugString("LicensePlate.get: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    fields = (type(fields) ~= "table") and {} or fields
    local result = exports.tmtaSQLite:dbTableSelect(LICANSE_PLATE_TABLE_NAME, fields, {licensePlateId = licensePlateId}, callbackFunctionName, ...)
    if not result then
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    return result[1]
end

--- Добавить номерной знак
function LicensePlate.add(licensePlateType, licensePlate, vehicleId, userId, callbackFunctionName, ...)
    if not (
        (licensePlateType and type(licensePlateType) == 'number') and
        (licensePlate and type(licensePlate) == 'string') and
        ((vehicleId and type(vehicleId) == 'number') or (userId and type(userId) == 'number'))
    ) then
        executeCallback(_G[callbackFunctionName], false)
        outputDebugString("LicensePlate.add: bad arguments", 1)
        return false
    end

    local success = exports.tmtaSQLite:dbTableInsert(LICANSE_PLATE_TABLE_NAME, {
        type = licensePlateType,
        numberPlate = licensePlate,
        vehicleId = vehicleId,
        userId = userId,
    })

    success = not not success

    exports.tmtaLogger:log("licensePlate",
        string.format("Added licensePlate %s|%s to vehicleId: %s, userId: %s. Success: %s",
            tostring(licensePlateType),
            tostring(licensePlate),
            tostring(vehicleId),
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
    ]], LICANSE_PLATE_TABLE_NAME, 'licensePlateId')

    local result = exports.tmtaSQLite:dbQuery(queryString, callbackFunctionName, ...)
    licensePlate = result[1]
    
    addInaccessibleLicensePlate(Utils.getCharacterLicensePlateType(licensePlate.type), licensePlate.numberPlate)
    addLicensePlateToCache(licensePlate.licensePlateId, licensePlate)

    return licensePlate
end

--- Обновить номерной знак
function LicensePlate.update(licensePlateId, fields, callbackFunctionName, ...)
    if (type(licensePlateId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("LicensePlate.update: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    local success = exports.tmtaSQLite:dbTableUpdate(LICANSE_PLATE_TABLE_NAME, fields, {licensePlateId = licensePlateId}, callbackFunctionName, ...)
	if not success then
		executeCallback(_G[callbackFunctionName], false)
        return false
	end

	return true
end

--- Удалить номерной знак
function LicensePlate.delete(licensePlateId, callbackFunctionName, ...)
    if (type(licensePlateId) ~= "number") then
        outputDebugString("LicensePlate.delete: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    local licensePlate = LicensePlate.get(licensePlateId, {'licensePlateId', 'type', 'numberPlate'})

    local success = exports.tmtaSQLite:dbTableDelete(LICANSE_PLATE_TABLE_NAME, {licensePlateId = licensePlateId}, callbackFunctionName, ...)
    success = not not success

    if not success then
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    deleteInaccessibleLicensePlate(Utils.getCharacterLicensePlateType(licensePlate.type), licensePlate.numberPlate)
    deleteLicensePlateFromCache(licensePlate.licensePlateId)
    
    return true
end

--- Проверить номерной знак на существование
function LicensePlate.isExist(plateType, numberPlate)
    if (type(plateType) ~= 'number' or type(numberPlate) ~= 'string') then
        outputDebugString("LicensePlate.isExist: bad arguments", 1)
        return false
    end

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT `licensePlateId`
        FROM `??` 
        WHERE `type` = ? AND `numberPlate` = ?
    ]], LICANSE_PLATE_TABLE_NAME, plateType, numberPlate)

    local result = exports.tmtaSQLite:dbQuery(queryString)
    return (type(result) == 'table' and #result > 0)
end

--- Получить номерной знак по id авто
function LicensePlate.getByVehicleId(vehicleId)
    if not (vehicleId and type(vehicleId) == 'number') then
        outputDebugString("LicensePlate.getByVehicleId: bad arguments", 1)
        return false
    end

    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        SELECT `licensePlateId`, `type`, `numberPlate`
        FROM `??` 
        WHERE `vehicleId` = ?
    ]], LICANSE_PLATE_TABLE_NAME, vehicleId)

    local result = exports.tmtaSQLite:dbQuery(queryString)
    if not result then
        return false
    end

    return result[1]
end

function LicensePlate.setVehicleLicensePlate(vehicleId, licensePlateType, licensePlate)
    if not (
        (vehicleId and type(vehicleId) == 'number') and
        (licensePlateType and type(licensePlateType) == 'string') and
        (licensePlate and type(licensePlate) == 'string')
    ) then
        outputDebugString("LicensePlate.setVehicleLicensePlate: bad arguments", 1)
        return false
    end

    local isLicensePlateValid, licensePlateValidErrorMessage = Utils.isLicensePlateValid(licensePlate, licensePlateType)
    local isLicensePlateAvailable = (isLicensePlateValid)
        and Utils.isLicensePlateAvailable(licensePlateType, licensePlate) 
        or false
    
    if (not isLicensePlateValid) then
        return false, licensePlateValidErrorMessage
    elseif (not isLicensePlateAvailable) then
        return false, 'Данный регистрационный знак недоступен'
    end

    local licensePlateType = Utils.getNumericLicensePlateType(licensePlateType)

    if (LicensePlate.isExist(licensePlateType, licensePlate)) then
        return false, 'Данный регистрационный знак недоступен'
    end

    local currentLicensePlate = LicensePlate.getByVehicleId(vehicleId)
    if currentLicensePlate then
        LicensePlate.update(currentLicensePlate.licensePlateId, {vehicleId = 'NULL'}, 'fakeCallBack')
    end

    local result = LicensePlate.add(licensePlateType, licensePlate, vehicleId)
    if not result then
        if currentLicensePlate then
            LicensePlate.update(currentLicensePlate.licensePlateId, {vehicleId = vehicleId}, 'fakeCallBack')
        end
        return false
    end

    if currentLicensePlate then
        LicensePlate.delete(currentLicensePlate.licensePlateId, 'fakeCallBack')
    end

    local vehicle = exports.tmtaVehicle:getVehicleById(vehicleId)
    if isElement(vehicle) then
        vehicle:setData('numberPlateType', licensePlateType)
        vehicle:setData('numberPlate', licensePlate)
    end

    return true
end

--- Удалить номерной знак по id транспорта
function LicensePlate.deleteVehicleLicensePlate(vehicleId)
    if (not vehicleId or type(vehicleId) ~= 'number') then
		return false
	end

    local result = LicensePlate.getByVehicleId(vehicleId)
    if not result then
        return false
    end

    LicensePlate.delete(result.licensePlateId, 'fakeCallBack')

    return true
end

addEvent('tmtaVehicleLicensePlate.onPlayerBuyLicensePlate', true)
addEventHandler('tmtaVehicleLicensePlate.onPlayerBuyLicensePlate', root,
    function(licensePlateType, licensePlate, licensePlatePrice)
        local player = source
        if (not isElement(player)) then
            return
        end
    
        local vehicle = player.vehicle
        if (not isElement(vehicle) or vehicle.controller ~= player) then
            return
        end
    
        local vehicleId = vehicle:getData('userVehicleId')
        if not vehicleId then 
            return
        end
    
        if (exports.tmtaMoney:getPlayerMoney(player) < licensePlatePrice) then
            return Utils.showNotice("У вас недостаточно денежных средств", player)
        end
    
        local success, errorMessage = LicensePlate.setVehicleLicensePlate(vehicleId, licensePlateType, licensePlate)
        if not success then
            return Utils.showNotice(errorMessage, player)
        end
    
        exports.tmtaMoney:takePlayerMoney(player, tonumber(licensePlatePrice))
    
        local _licensePlate = formatLicensePlateToString(licensePlateType, licensePlate)
        Utils.showNotice("#FFFFFFВы приобрели номерной знак #FFA07A".._licensePlate.."#FFFFFF за #FFA07A"..exports.tmtaUtils:formatMoney(licensePlatePrice).." #FFFFFF₽", player)
    end
)