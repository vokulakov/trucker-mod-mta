House = {}
local createdHouses = {}

local HOUSE_TABLE_NAME = 'house'

function House.setup()
    exports.tmtaSQLite:dbTableCreate(HOUSE_TABLE_NAME, {
        { name = 'userId', type = 'INTEGER' },
        { name = 'position', type = 'TEXT' },
        { name = 'interiorId', type = 'INTEGER', options = 'NOT NULL' },
        { name = 'price', type = 'INTEGER', options = 'NOT NULL' },
        { name = 'propertyTax', type = 'INTEGER', options = 'NOT NULL DEFAULT 0' },
        { name = 'communalPayment', type = 'INTEGER', options = 'NOT NULL DEFAULT 0' },
        { name = 'doorStatus', type = 'INTEGER', options = 'DEFAULT 0' }, -- открыт или закрыт
        { name = 'doorCode', type = 'VARCHAR', size = 6 }, -- код от двери
        { name = 'parkingSpaces', type = 'INTEGER', options = 'NOT NULL DEFAULT 0' }, -- парковочные места
        { name = 'inventory', type = "TEXT" }, -- feature: инвентарь (шкаф)
        { name = 'wardrobe', type = "TEXT" }, -- feature: гардероб
        { name = 'furniture', type = "TEXT" }, -- feature: мебель
        { name = 'mining', type = "TEXT" }, -- feature: майнинг
        { name = 'upgrades', type = "TEXT" }, -- feature: улучшения
        { name = 'safe', type = 'INTEGER', options = 'NOT NULL DEFAULT 0' }, -- сейф
        { name = 'safeCode', type = 'VARCHAR', size = 4 }, -- код от сейфа
        { name = 'editorId', type = 'INTEGER' }, -- пользователь обновивший дом
        { name = 'taxAt', type = 'INTEGER' }, -- время начисления прибыли (в timestamp)
        { name = 'confiscateAt', type = 'INTEGER' }, -- время конфискации в пользу государства (в timestamp)
    },  
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (editorId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")

    --exports.tmtaSQLite:dbTableAddColumn(HOUSE_TABLE_NAME, 'taxAt', 'INTEGER')
    --exports.tmtaSQLite:dbTableAddColumn(HOUSE_TABLE_NAME, 'confiscateAt', 'INTEGER')
    --exports.tmtaSQLite:dbTableAlter(HOUSE_TABLE_NAME, 'RENAME COLUMN doorLock TO doorStatus;')

    local successCount, errorCount = 0, 0
    for _, house in pairs(House.getAll()) do
        if (House.create(house)) then
            successCount = successCount + 1
        else
            errorCount = errorCount + 1
        end
    end

    outputDebugString('Система домов загружена')
    outputDebugString('Успешно создано: '..successCount)
    outputDebugString('Не удалось создать: '..errorCount)
end

-- Дата сохранения
local dataFields = {
    'doorStatus',
}

function House.getCreatedHouses()
    return createdHouses
end

--- Получить временную метку начисления налога
function House.getTaxDate()
    return tonumber(exports.tmtaUtils:getTimestamp(_, _, getRealTime().monthday + Config.TAX_DAY))
end

-- Получить данные дома
function House.get(houseId, fields, callbackFunctionName, ...)
    if (type(houseId) ~= "number") then
        outputDebugString("House.get: bad arguments", 1)
        return false
    end

    fields = (type(fields) ~= "table") and {} or fields
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME, fields, {houseId = houseId}, callbackFunctionName, ...)
end

-- Получить список всех домов
function House.getAll()
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME)
end

-- Добавить дом
function House.add(posX, posY, posZ, interiorId, price, parkingSpaces, callbackFunctionName, ...)
    local player = client
    if not isElement(player) then
        return false
    end

    local interiorData = Interiors.get(tonumber(interiorId))
    if not interiorData then
        outputDebugString("House.add: error interior", 1)
        return false
    end

    local houseData = {
        position = tostring(toJSON({x = posX, y = posY, z = posZ})),
        interiorId = interiorId,
        price = price,
        parkingSpaces = parkingSpaces,
    }

    local success = exports.tmtaSQLite:dbTableInsert(HOUSE_TABLE_NAME, houseData, callbackFunctionName, ...)
    if not success then
        return false
    end

    return exports.tmtaSQLite:dbQuery('SELECT * FROM `house` ORDER BY `houseId` DESC LIMIT 1', callbackFunctionName, ...)
end

addEvent("tmtaHouse.addHouseRequest", true)
addEventHandler("tmtaHouse.addHouseRequest", resourceRoot,
    function(posX, posY, posZ, interiorId, price, parkingSpaces)
        local player = client
        local success = House.add(posX, posY, posZ, interiorId, price, parkingSpaces, "dbAddHouse", {player = player})
        if not success then
            triggerClientEvent(player, "tmtaHouse.addHouseResponse", resourceRoot, false)
        end
    end
)

function dbAddHouse(result, params)
	if not params or not isElement(params.player) then
        return
    end
    local player = params.player
    local success = not not result
    
    if success then
        House.create(result[1])
    end

    triggerClientEvent(player, "tmtaHouse.addHouseResponse", resourceRoot, result)
end

-- Удалить дом
function House.remove(player, houseId, callbackFunctionName, ...)
    if not isElement(player) then
        return false
    end

    if type(houseId) ~= "number" then
        outputDebugString("House.remove: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end

    local success = exports.tmtaSQLite:dbTableDelete(HOUSE_TABLE_NAME, {houseId = houseId}, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

    exports.tmtaLogger:log("houses", 
		string.format("Removed house %s. Success: %s", 
			tostring(houseId), 
			tostring(success)
        )
    )

    return success
end

-- Обновить дом
function House.update(houseId, fields, callbackFunctionName, ...)
    if type(houseId) ~= "number" then
        outputDebugString("House.update: bad arguments", 1)
        return false
    end
   
    if type(fields) ~= 'table' then
        fields = {}
    end

    local success = exports.tmtaSQLite:dbTableUpdate(HOUSE_TABLE_NAME, fields, {houseId = houseId}, callbackFunctionName, ...)

    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

function dbUpdateHouse(result, params)
    if (not params) then
        return false
    end
    
    local success = not not result
    if (success) then
        local houseId = params.houseId
        local houseData = House.get(houseId)
        houseData = houseData[1]
        if houseData then
            local result = exports.tmtaCore:getUserDataById(tonumber(houseData.userId), {'nickname'})
            houseData.owner = result[1].nickname

            createdHouses[houseId].houseMarker:setData('houseData', houseData)
            createdHouses[houseId].data = houseData
        end
    end

    return success
end

-- Получить список всех домов игрока
function House.getHousesPlayer(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
        outputDebugString("House.getHousesPlayer: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME, {}, {userId = userId}, callbackFunctionName, ...)
end

-- Создать дом
function House.create(houseData)
    if type(houseData) ~= 'table' then
        return false
    end

    local interiorData = Interiors.get(tonumber(houseData.interiorId))
    if not interiorData then
        outputDebugString("House.create: error interior", 1)
        return false
    end

    local houseId = houseData.houseId
    if not houseId or type(houseId) ~= 'number' then
        outputDebugString("House.create: error houseId", 1)
        return false
    end

    houseData.dimension = tonumber(houseId)

    if houseData.userId then
        local result = exports.tmtaCore:getUserDataById(tonumber(houseData.userId), {'nickname'})
        houseData.owner = result[1].nickname
    end

     -- Определение класса
     for _, data in pairs(Config.houseClass) do
        if houseData.parkingSpaces <= tonumber(data.parkingSpaces) then
            houseData.class = data.class
            break
        end
    end

    local position = fromJSON(houseData.position)
    houseData.position = Vector3(position.x, position.y, position.z)

    -- Маркер дома
    local houseMarker = createMarker(position.x, position.y, position.z-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
    local pickupId = houseData.userId and 1272 or 1273
    local housePickup = createPickup(position.x+0.05, position.y-0.05, position.z, 3, pickupId, 500)

    -- Маркер выхода из дома (в интерьере)
    local position = interiorData.exit
    local exitMarker = createMarker(position.x, position.y, position.z, 'cylinder', 1.5, 255, 255, 255, 0)
    exitMarker.interior = interiorData.interior
    exitMarker.dimension = houseData.dimension
    local exitPickup = createPickup(position.x+0.05, position.y-0.05, position.z+1, 3, 1318, 500)
    exitPickup.interior = interiorData.interior
    exitPickup.dimension = houseData.dimension

    exitMarker:setData('isHouseExitMarker', true)
    exitMarker:setData('houseId', houseId)

    -- Маркер управления домом
    --local position = interiorData.managementPosition
    --local managementMarker = createMarker(position.x, position.y, position.z, 'cylinder', 1.5, 255, 255, 255, 0)
    --managementMarker.interior = interiorData.interior
    --managementMarker.dimension = houseData.dimension
    --local managementPickup = createPickup(position.x+0.05, position.y-0.05, position.z+1, 3, 1277, 500)
    --managementPickup.interior = interiorData.interior
    --managementPickup.dimension = houseData.dimension

    houseData.doorStatus = exports.tmtaUtils:tobool(houseData.doorStatus)

    houseMarker:setData('isHouseMarker', true)
    houseMarker:setData('houseData', houseData)

    createdHouses[houseId] = {
        data = houseData,

        houseMarker = houseMarker,
        housePickup = housePickup,

        exitMarker = exitMarker,
        exitPickup = exitPickup,

        --managementMarker = managementMarker,
        --managementPickup = managementPickup,
    }

    return true
end

-- Удалить дом
function House.destroy(houseId)
    if type(houseId) ~= "number" or not createdHouses[houseId] then
        outputDebugString("House.destroy: bad arguments", 1)
        return false
    end

    destroyElement(createdHouses[houseId].houseMarker)
    destroyElement(createdHouses[houseId].housePickup)
    destroyElement(createdHouses[houseId].exitMarker)
    destroyElement(createdHouses[houseId].exitPickup)
    --destroyElement(createdHouses[houseId].managementMarker)
    --destroyElement(createdHouses[houseId].managementPickup)

    createdHouses[houseId] = nil

    return true
end

addEvent("tmtaHouse.onPlayerHouseEnter", true)
addEventHandler("tmtaHouse.onPlayerHouseEnter", resourceRoot,
    function(houseId)
        local player = client
        if type(houseId) ~= "number" or not isElement(player) then
            return triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, false)
        end
        
        if not createdHouses[houseId] then
            return triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, false)
        end

        if (House.isDoorLocked(houseId) and not House.isPlayerOwned(player, houseId)) then
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'info', 'Дом закрыт')
            return triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, false)
        end 

        local houseData = createdHouses[houseId].data
        local interiorData = Interiors.get(tonumber(houseData.interiorId))
       
        fadeCamera(player, false, 0.5)
        setTimer(
            function()
                player.position = interiorData.entry.position
                player.rotation = interiorData.entry.rotation
                player.interior = interiorData.interior
                player.dimension = houseData.dimension
                fadeCamera(player, true, 0.5)
                triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, true)
            end, 1000, 1)
    end
)

addEvent("tmtaHouse.onPlayerHouseExit", true)
addEventHandler("tmtaHouse.onPlayerHouseExit", resourceRoot,
    function(houseId)
        local player = client
        if type(houseId) ~= "number" or not isElement(player) then
            triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseExit", resourceRoot, false)
            return
        end

        if not createdHouses[houseId] then
            triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseExit", resourceRoot, false)
            return
        end

        local houseData = createdHouses[houseId].data
        fadeCamera(player, false, 0.5)
        setTimer(
            function()
                player.position = houseData.position
                player.interior = 0
                player.dimension = 0
                fadeCamera(player, true, 0.5)
                triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseExit", resourceRoot, true)
            end, 1000, 1)
    end
)

function House.buy(player, houseId)
    if (not isElement(player) or type(houseId) ~= 'number') then
        return false
    end

    local houseData = createdHouses[houseId].data
    if (houseData.userId) then
        outputDebugString("House.buy: error buying house", 1)
        exports.tmtaLogger:log(
            "houses",
            string.format("Error buying house (%d). Business owner user %d", houseId, houseData.userId)
        )
        return triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'error', 'Ошибка покупки бизнеса. Обратитесь к Администратору!')
    end

    local userId = player:getData("userId")
    local playerHouses = House.getHousesPlayer(userId)
    if #playerHouses >= Config.PLAYER_MAX_HOUSES then
        local errorMessage = string.format('Вы можете одновремено владеть только %d домами', Config.PLAYER_MAX_HOUSES)
        return false, errorMessage
    end

    local playerMoney = exports.tmtaMoney:getPlayerMoney(player)
    if playerMoney < houseData.price then
        return false, 'Недостаточно средств для покупки дома'
    end

    return House.update(houseId, {
        userId = userId,
        taxAt = House.getTaxDate(),
    }, "dbBuyHouse", {
        player = player, 
        userId = userId, 
        houseId = houseId, 
        housePrice = houseData.price,
        parkingSpaces = houseData.parkingSpaces,
    })
end

addEvent("tmtaHouse.onPlayerBuyHouse", true)
addEventHandler("tmtaHouse.onPlayerBuyHouse", resourceRoot,
    function(houseId)
        local player = client
        if (type(houseId) ~= "number" or not isElement(player) or not createdHouses[houseId]) then
            return
        end

        local success, errorMessage = House.buy(player, houseId)
        if (not success and errorMessage) then
            triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

function dbBuyHouse(result, params)
    if not params or not isElement(params.player) then
        return false
    end

    local player = params.player
    local houseId = tonumber(params.houseId)
    local housePrice = tonumber(params.housePrice)
    local parkingSpaces = tonumber(params.parkingSpaces)

    local success = not not result
    if success then
        exports.tmtaMoney:takePlayerMoney(player, housePrice)
        triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', 'Поздравляем с покупкой дома!')

        House.destroy(houseId)
        local houseData = House.get(houseId)
        if houseData[1] then
            House.create(houseData[1])
        end

        --TODO: обновить количество слотов в гараже
    end

    return success
end

function House.sell(houseId)
    if (type(houseId) ~= "number") then
        return false
    end

    local houseData = createdHouses[houseId].data
    if (not houseData.userId) then
        outputDebugString("House.sell: error selling house", 1)
        exports.tmtaLogger:log("houses", string.format("Error selling  house (%d).", houseId))
        return false
    end

    local price = tonumber(houseData.price - (houseData.price * Config.SELL_COMMISSION/100))

    return House.update(houseId, {
        userId = 'NULL',
        taxAt = 'NULL',
        confiscateAt = 'NULL',
        doorStatus = 0,
        doorCode = '',
    }, 'dbSellHouse', {
        houseId = houseId,
        userId = houseData.userId,
        price = price,
    })
end

addEvent("tmtaHouse.onPlayerSellHouse", true)
addEventHandler("tmtaHouse.onPlayerSellHouse", resourceRoot,
    function(houseId)
        local player = client
        if (not isElement(player) or type(houseId) ~= "number" or not createdHouses[houseId]) then
            return
        end

        local houseData = createdHouses[houseId].data
        if (not houseData.userId or not House.isPlayerOwned(player, houseId)) then
            return
        end

        House.sell(houseId)
    end
)

function dbSellHouse(result, params)
    if (not params) then
        return false
    end

    local houseId = tonumber(params.houseId)
    local userId = tonumber(params.userId)
    local price = tonumber(params.price)

    local success = not not result
    if success then

        local player = exports.tmtaCore:getPlayerByUserId(userId)
        if (isElement(player)) then
            exports.tmtaMoney:givePlayerMoney(player, price)
            local message = string.format('Ваш дом №%d продан.\nНа ваш счет зачислено %s ₽', houseId, exports.tmtaUtils:formatMoney(price))
            triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', message)
        else
            exports.tmtaCore:giveUserMoney(userId, tonumber(price))
        end

        House.destroy(houseId)
        local houseData = House.get(houseId)
        if houseData[1] then
            House.create(houseData[1])
        end

        exports.tmtaLogger:log('houses', string.format("User id=%d sell house id=%d for %d", userId, houseId, price))
    end

    return success
end

function House.changeDoorStatus(houseId)
    if (type(houseId) ~= "number") then
        return false
    end

    local houseData = createdHouses[houseId].data
    if (not houseData) then
        return false
    end

    houseData.doorStatus = (not House.isDoorLocked(houseId)) and 1 or 0
    createdHouses[houseId].houseMarker:setData('houseData', houseData)
    createdHouses[houseId].data = houseData

    return true
end

function House.isDoorLocked(houseId)
    if (type(houseId) ~= "number") then
        return
    end

    local houseData = createdHouses[houseId].data
    if (not houseData) then
        return
    end

    return exports.tmtaUtils:tobool(createdHouses[houseId].data.doorStatus)
end

addEvent('tmtaHouse.onPlayerChangeDoorStatus', true)
addEventHandler('tmtaHouse.onPlayerChangeDoorStatus', resourceRoot,
    function(houseId)
        local player = client
        if (not isElement(player) or type(houseId) ~= "number" or not createdHouses[houseId]) then
            return
        end
       
        local houseData = createdHouses[houseId].data
        if (not houseData.userId or houseData.userId ~= player:getData('userId')) then
            return
        end

        if (House.changeDoorStatus(houseId)) then
            local doorStatus = House.isDoorLocked(houseId)
            triggerClientEvent(player, 'tmtaHouse.onClientPlayerChangeDoorStatus', resourceRoot, doorStatus)
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'info', (doorStatus) and 'Двери дома закрыты!' or 'Двери дома открыты!')
        end
    end
)

function House.getOwnerUserId(houseId)
    if (type(houseId) ~= "number") then
        return
    end

    local houseData = createdHouses[houseId].data
    if (not houseData) then
        return
    end

    return houseData.userId
end

function House.isPlayerOwned(player, houseId)
    if (not isElement(player) or type(houseId) ~= "number") then
        return
    end
    return House.getOwnerUserId(houseId) == player:getData('userId')
end

function House.save(houseId)
    if (type(houseId) ~= "number") then
        return false
    end

    local house = createdHouses[houseId]
    if (not house or type(house.data) ~= 'table') then
        return false
    end

    local fields = {}
    for _, name in ipairs(dataFields) do
        if house.data[name] then
		    fields[name] = house.data[name]
        end
	end

    if (#fields == 0) then
        return false
    end

    return House.update(houseId, fields)
end
