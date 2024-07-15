House = {}
local houseMarkers = {}

local HOUSE_TABLE_NAME = 'house'

function House.setup()
    exports.tmtaSQLite:dbTableCreate(HOUSE_TABLE_NAME, {
        { name = "userId", type = 'INTEGER' },
        { name = "position", type = "TEXT" },
        { name = "interiorId", type = "INTEGER", options = "NOT NULL" },
        { name = "price", type = "INTEGER", options = "NOT NULL" },
        { name = "propertyTax", type = "INTEGER", options = "NOT NULL DEFAULT 0" },
        { name = "communalPayment", type = "INTEGER", options = "NOT NULL DEFAULT 0" },
        { name = "doorLock", type = "INTEGER", options = "DEFAULT 0" }, -- открыт или закрыт
        { name = "doorCode", type = "VARCHAR", size = 6 }, -- код от двери
        { name = "parkingSpaces", type = "INTEGER", options = "NOT NULL DEFAULT 0" }, -- парковочные места
        { name = "inventory", type = "TEXT" }, -- feature: инвентарь (шкаф)
        { name = "wardrobe", type = "TEXT" }, -- feature: гардероб
        { name = "furniture", type = "TEXT" }, -- feature: мебель
        { name = "mining", type = "TEXT" }, -- feature: майнинг
        { name = "upgrades", type = "TEXT" }, -- улучшения
        { name = "safe", type = "INTEGER", options = "NOT NULL DEFAULT 0" }, -- сейф
        { name = "safeCode", type = "VARCHAR", size = 4 }, -- код от сейфа
        { name = "editorId", type = "INTEGER" }, -- пользователь обновивший дом
    },  
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (editorId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
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
    if success then
        exports.tmtaLogger:log("houses", "Added house")
    end
    return success
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

    local success = exports.tmtaSQLite:dbTableDelete(HOUSE_TABLE_NAME, { houseId = houseId }, callbackFunctionName, ...)
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

    local success = exports.tmtaSQLite:dbTableUpdate(HOUSE_TABLE_NAME, fields, { houseId = houseId }, callbackFunctionName, ...)

    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

-- Получить данные дома
function House.get(houseId)
    if type(houseId) ~= "number" then
        outputDebugString("House.get: bad arguments", 1)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME, {}, { houseId = houseId })
end

-- Получить список всех домов игрока
function House.getHousesPlayer(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
        outputDebugString("House.getHousesPlayer: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME, {}, { userId = userId }, callbackFunctionName, ...)
end

-- Получить список всех домов
function House.getList()
    return exports.tmtaSQLite:dbTableSelect(HOUSE_TABLE_NAME)
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
    local position = houseData.position
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

    houseMarker:setData('isHouseMarker', true)
    houseMarker:setData('houseData', houseData)

    houseMarkers[houseId] = {
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
    if type(houseId) ~= "number" or not houseMarkers[houseId] then
        outputDebugString("House.destroy: bad arguments", 1)
        return false
    end

    destroyElement(houseMarkers[houseId].houseMarker)
    destroyElement(houseMarkers[houseId].housePickup)
    destroyElement(houseMarkers[houseId].exitMarker)
    destroyElement(houseMarkers[houseId].exitPickup)
    --destroyElement(houseMarkers[houseId].managementMarker)
    --destroyElement(houseMarkers[houseId].managementPickup)

    houseMarkers[houseId] = nil

    return true
end

-- Events
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

addEvent("tmtaHouse.onPlayerHouseEnter", true)
addEventHandler("tmtaHouse.onPlayerHouseEnter", resourceRoot,
    function(houseId)
        local player = client
        if type(houseId) ~= "number" or not isElement(player) then
            triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, false)
            return
        end
        --TODO:: проверка на открыт/закрыт замок дома
        if not houseMarkers[houseId] then
            triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseEnter", resourceRoot, false)
            return
        end

        local houseData = houseMarkers[houseId].data
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

        if not houseMarkers[houseId] then
            triggerClientEvent(player, "tmtaHouse.onClientPlayerHouseExit", resourceRoot, false)
            return
        end

        local houseData = houseMarkers[houseId].data
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

addEvent("tmtaHouse.onPlayerBuyHouse", true)
addEventHandler("tmtaHouse.onPlayerBuyHouse", resourceRoot,
    function(houseId)
        local player = client
        if type(houseId) ~= "number" or not isElement(player) then
            return
        end

        if not houseMarkers[houseId] then
            return
        end

        local userId = player:getData("userId")

        local playerHouses = House.getHousesPlayer(userId)
        if #playerHouses >= Config.PLAYER_MAX_HOUSES then
            local message = string.format('Вы можете одновремено владеть только %d домами', Config.PLAYER_MAX_HOUSES)
            triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'warning', message)
            return
        end
        
        local houseData = houseMarkers[houseId].data
        local playerMoney = exports.tmtaMoney:getPlayerMoney(player)
        
        if playerMoney < houseData.price then
            triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'error', 'Недостаточно средств для покупки дома')
            return
        end

        if houseData.userId then
            outputDebugString("tmtaHouse.onPlayerBuyHouse: error buying house", 1)
            exports.tmtaLogger:log(
                "houses",
                string.format("Error buying house (%d). House owner user %d", houseId, houseData.userId)
            )
            return
        end

        updatePlayerLots(player, houseData)

        House.update(houseId, {userId = userId}, "dbBuyHouse", 
            {
                player = player, 
                userId = userId, 
                houseId = houseId, 
                housePrice = houseData.price
            }
        )

    end
)

-- Callbacks
function dbAddHouse(result, params)
	if not params or not isElement(params.player) then
        return
    end
    local player = params.player
	result = not not result
    if result then
        local houses = House.getList()
        for _, houseData in pairs(houses) do
            House.create(houseData)
        end
    end
    triggerClientEvent(player, "tmtaHouse.addHouseResponse", resourceRoot, result)
end

function dbBuyHouse(result, params)
    if not params or not isElement(params.player) then
        return false
    end
    local player = params.player
    local houseId = params.houseId
    local housePrice = params.housePrice
    result = not not result
    if result then
        exports.tmtaMoney:takePlayerMoney(player, tonumber(housePrice))
        triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', 'Поздравляем с покупкой дома')
        House.destroy(houseId)
        local houseData = House.get(houseId)
        if houseData[1] then
            House.create(houseData[1])
        end
    end

    return result
end