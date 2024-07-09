LicensePlateStorage = {}

local IS_NOT_LICANSE_PLATE_IN_STORAGE = 0
local IS_LICANSE_PLATE_IN_STORAGE = 1

--- Получить временную метку удаления номерного знака
local function getTimestampDeleteAt()
    return tonumber(exports.tmtaUtils:getTimestamp(_, _, getRealTime().monthday + Config.STORAGE_PERIOD))
end

--- Установить для игрока количество слотов в хранилище номеров по умолчанию
function LicensePlateStorage.setPlayerDefaultSlot(player)
    if (not isElement(player)) then
        outputDebugString('LicensePlateStorage.setPlayerDefaultSlot: bad arguments', 1)
        return false
    end

    local playerLicensePlateSlotCount = Utils.getPlayerLicensePlateSlotCount(player)
    if (playerLicensePlateSlotCount >= Config.DEFAULT_STORAGE_SIZE) then
        return false
    end

    return LicensePlateStorage.addPlayerSlot(player, Config.DEFAULT_STORAGE_SIZE-playerLicensePlateSlotCount)
end

--- Получить список номерных знаков пользователя
function LicensePlateStorage.getUserLicensePlates(userId, callbackFunctionName, ...)
    if (type(userId) ~= "number") then
        outputDebugString("LicensePlateStorage.getUserLicensePlates: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end

    return exports.tmtaSQLite:dbTableSelect(LICANSE_PLATE_TABLE_NAME, {}, {userId = userId}, callbackFunctionName, ...)
end

--- Получить список номерных знаков игрока
function LicensePlateStorage.getPlayerLicensePlates(player, callbackFunctionName, ...)
    if (not isElement(player)) then
        outputDebugString("LicensePlateStorage.getPlayerLicensePlates: bad arguments", 1)
        return false
    end
    
    return LicensePlateStorage.getUserLicensePlates(player:getData('userId'), callbackFunctionName, ...)
end

--- Добавить пользователю слот в хранилище
function LicensePlateStorage.addUserSlot(userId, amount)
    if (type(userId) ~= 'number' or type(amount) ~= 'number') then
        outputDebugString('LicensePlateStorage.addUserSlot: bad arguments', 1)
        return false
    end
    amount = math.ceil(math.abs(amount))

	local userData = exports.tmtaCore:getUserDataById(userId, {'licensePlateSlot'})
	local userLicensePlateSlot = tonumber(userData.licensePlateSlot)
    local licensePlateSlot = tonumber(userLicensePlateSlot + amount)

    local success = exports.tmtaCore:updateUserDataById(userId, {licensePlateSlot = licensePlateSlot})
    if not success then
        return false
    end

    exports.tmtaLogger:log("licensePlate",
        string.format("Added %s storage slot for userId: %s",
            tostring(licensePlateSlot),
            tostring(userId)
        )
    )

    return true
end

--- Добавить игроку слот в хранилище
function LicensePlateStorage.addPlayerSlot(player, amount)
    if (not isElement(player) or type(amount) ~= 'number') then
        outputDebugString('LicensePlateStorage.addPlayerSlot: bad arguments', 1)
        return false
    end
    amount = math.ceil(math.abs(amount))

    local playerLicensePlateSlotCount = Utils.getPlayerLicensePlateSlotCount(player)
    local _currentLicensePlateSlotCount = tonumber(playerLicensePlateSlotCount + amount)

    player:setData('licensePlateSlot', _currentLicensePlateSlotCount)
    LicensePlateStorage.updatePlayerLicensePlatesList(player)
    
    return true
end

--- Добавить номерной знак игрока в хранилище
function LicensePlateStorage.addPlayerLicensePlateInStorage(player, licensePlateId)
    if (not isElement(player) or type(licensePlateId) ~= 'number') then
        outputDebugString("LicensePlateStorage.addPlayerLicensePlateInStorage: bad arguments", 1)
        return false
    end

    local userId = player:getData('userId')

    local success = LicensePlate.update(licensePlateId, {
        vehicleId = 'NULL',
        userId = userId,
        inStorage = IS_LICANSE_PLATE_IN_STORAGE,
        deleteAt = getTimestampDeleteAt(),
    })

    if not success then
        return false
    end

    exports.tmtaLogger:log("licensePlate",
        string.format("User (id: %s) added license plate (id: %s) in storage",
            tostring(userId),
            tostring(licensePlateId)
        )
    )

    LicensePlateStorage.updatePlayerLicensePlatesList(player)

    return true
end

--- Установить номерной знак из хранилища на транспорт
function LicensePlateStorage.setVehicleLicensePlateFromStorage(vehicleId, licensePlateId)
    if (type(vehicleId) ~= 'number' or type(licensePlateId) ~= 'number') then
        outputDebugString("LicensePlateStorage.setVehicleLicensePlateFromStorage: bad arguments", 1)
        return false
    end

    local success = LicensePlate.update(licensePlateId, {
        vehicleId = vehicleId,
        userId = 'NULL',
        inStorage = IS_NOT_LICANSE_PLATE_IN_STORAGE,
        deleteAt = 'NULL',
    })

    if not success then
        return false
    end

    local vehicle = exports.tmtaVehicle:getVehicleById(vehicleId)
    if isElement(vehicle) then
        local licensePlate = LicensePlate.get(licensePlateId, {'type', 'numberPlate'})
        vehicle:setData('numberPlateType', licensePlate.type)
        vehicle:setData('numberPlate', licensePlate.numberPlate)
    end

    exports.tmtaLogger:log("licensePlate",
        string.format("License plate (id: %s) from storage set on vehicle (id: %s)",
            tostring(licensePlateId),
            tostring(vehicleId)
        )
    )

    return true
end

--- Удалить номерной знак из хранилища пользователя
function LicensePlateStorage.deleteUserLicensePlate(userId, licensePlateId)
    if (type(userId) ~= "number" or type(licensePlateId) ~= 'number') then
        outputDebugString("LicensePlateStorage.deleteUserLicensePlate: bad arguments", 1)
        return false
    end

    local success = LicensePlate.delete(licensePlateId, 'fakeCallBack')
    if not success then
        return false
    end

    exports.tmtaLogger:log("licensePlate",
        string.format("User (id: %s) delete license plate (id: %s)",
            tostring(userId),
            tostring(licensePlateId)
        )
    )

    local player = exports.tmtaCore:getPlayerByUserId(userId)
    if isElement(player) then
        LicensePlateStorage.updatePlayerLicensePlatesList(player)
    end

    return true
end

--- Удалить номерной знак из хранилища игрока
function LicensePlateStorage.deletePlayerLicensePlate(player, licensePlateId, callbackFunctionName, ...)
    if (not isElement(player) or type(licensePlateId) ~= 'number') then
        outputDebugString("LicensePlateStorage.deletePlayerLicensePlate: bad arguments", 1)
        executeCallback(_G[callbackFunctionName], false)
        return false
    end
    return LicensePlateStorage.deleteUserLicensePlate(player:getData('userId'), licensePlateId, callbackFunctionName, ...)
end

addEvent('tmtaVehicleLicensePlate.onDelete', true)
addEventHandler('tmtaVehicleLicensePlate.onDelete', resourceRoot,
    function(licensePlateId, licensePlateString)
        local player = client
        if (
            not isElement(player) or 
            not (licensePlateId and type(licensePlateId) == 'number') or 
            not (licensePlateString and type(licensePlateString) == 'string') 
        ) then
            return
        end

        if not LicensePlateStorage.deletePlayerLicensePlate(player, tonumber(licensePlateId)) then
            return
        end

        Utils.showNotice("#FFFFFFВы удалили номерной знак #FFA07A"..licensePlateString, player)
    end
)

addEvent('tmtaVehicleLicensePlate.onPutInStorage', true)
addEventHandler('tmtaVehicleLicensePlate.onPutInStorage', resourceRoot,
    function()
        local player = client
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
        vehicleId = tonumber(vehicleId)

        local currentLicensePlate = LicensePlate.getByVehicleId(vehicleId)
        if not currentLicensePlate then
            return false
        end

        local price = tonumber(Config.PRICE_PUT_IN_STORAGE)
        local errorMessage = false
        if not Utils.isPlayerHasFreeLicensePlateSlot(player) then
            errorMessage = 'У вас нет свободной ячейки для хранения номерного знака'
        elseif (exports.tmtaMoney:getPlayerMoney(player) < price) then
            errorMessage = 'У вас недостаточно денежных средств'
        end

        local success = LicensePlateStorage.addPlayerLicensePlateInStorage(player, currentLicensePlate.licensePlateId)
        if not success then
            errorMessage = 'Неизвестная ошибка. Обратитесь к администратору!'
        end

        if (type(errorMessage) == 'string') then
            return Utils.showNotice(errorMessage, player)
        end

        local vehicle = exports.tmtaVehicle:getVehicleById(vehicleId)
        if isElement(vehicle) then
            vehicle:removeData('numberPlateType')
            vehicle:removeData('numberPlate')
        end

        exports.tmtaMoney:takePlayerMoney(player, price)

        local _licensePlate = formatLicensePlateToString(currentLicensePlate.type, currentLicensePlate.numberPlate)
        Utils.showNotice("#FFFFFFВы поместили номерной знак #FFA07A".._licensePlate.."#FFFFFF в хранилище за #FFA07A"..exports.tmtaUtils:formatMoney(price).." #FFFFFF₽", player)
    end
)

addEvent('tmtaVehicleLicensePlate.onVehicleSet', true)
addEventHandler('tmtaVehicleLicensePlate.onVehicleSet', resourceRoot,
    function(licensePlateId, licensePlateString)
        local player = client
        if (
            not isElement(player) or 
            not (licensePlateId and type(licensePlateId) == 'number') or 
            not (licensePlateString and type(licensePlateString) == 'string') 
        ) then
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
        vehicleId = tonumber(vehicleId)

        local price = tonumber(Config.PRICE_SET_IN_VEHICLE)
        if (exports.tmtaMoney:getPlayerMoney(player) < price) then
            return Utils.showNotice('У вас недостаточно денежных средств', player)
        end

        local currentLicensePlate = LicensePlate.getByVehicleId(vehicleId)
        if currentLicensePlate then
            local success = LicensePlateStorage.addPlayerLicensePlateInStorage(player, currentLicensePlate.licensePlateId)
            if not success then
                return Utils.showNotice('Неизвестная ошибка. Обратитесь к администратору!', player)
            end
        end

        local success = LicensePlateStorage.setVehicleLicensePlateFromStorage(vehicleId, licensePlateId)
        if not success then
            LicensePlateStorage.setVehicleLicensePlateFromStorage(vehicleId, currentLicensePlate.licensePlateId)
            return Utils.showNotice('Неизвестная ошибка. Обратитесь к администратору!', player)
        end

        exports.tmtaMoney:takePlayerMoney(player, price)
        LicensePlateStorage.updatePlayerLicensePlatesList(player)

        local message = string.format(
            "#FFFFFFВы установили номерной знак #FFA07A'%s'#FFFFFF из хранилища за #FFA07A%s #FFFFFF₽", 
            licensePlateString, 
            exports.tmtaUtils:formatMoney(price)
        )

        Utils.showNotice(message, player)
    end
)

addEvent('tmtaVehicleLicensePlate.onPlayerGetLicensePlates', true)
addEventHandler('tmtaVehicleLicensePlate.onPlayerGetLicensePlates', resourceRoot,
    function()
        local player = client
        if not isElement(player) then
            return false
        end
        LicensePlateStorage.updatePlayerLicensePlatesList(player)
    end
)

addEvent('tmtaVehicleLicensePlate.onPlayerExpandStorage', true)
addEventHandler('tmtaVehicleLicensePlate.onPlayerExpandStorage', resourceRoot,
    function(price)
        local player = client
        if (not isElement(player) or not (price and type(price) == 'number')) then
            return false
        end

        if (exports.tmtaMoney:getPlayerMoney(player) < price) then
            return Utils.showNotice('У вас недостаточно денежных средств', player)
        end

        local success = LicensePlateStorage.addPlayerSlot(player, 1)
        if not success then
            return Utils.showNotice('Неизвестная ошибка. Обратитесь к администратору!', player)
        end

        exports.tmtaMoney:takePlayerMoney(player, price)
        Utils.showNotice(string.format("Вы расширили хранилище за #FFA07A%s #FFFFFF₽", exports.tmtaUtils:formatMoney(price)), player)
    end
)

function LicensePlateStorage.updatePlayerLicensePlatesList(player)
    if (not isElement(player)) then
        outputDebugString("LicensePlateStorage.updatePlayerLicensePlatesList: bad arguments", 1)
        return false
    end
    LicensePlateStorage.getPlayerLicensePlates(player, 'dbLicensePlateUpdatePlayerLicensePlatesList', {player = player})
end

function dbLicensePlateUpdatePlayerLicensePlatesList(result, params)
	if not params then
        return
    end

    local player = params.player
	local success = not not result

    if (not success or not isElement(player)) then
        return
    end

    if type(result) == "table" then
		player:setData('license_plate_slot_count', #result)
	end
    
    triggerClientEvent(player, 'tmtaVehicleLicensePlate.onPlayerLicensePlatesUpdate', resourceRoot, result)
end