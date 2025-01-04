Garage = {}

addEvent('tmtaGarage.onPlayerVehiclesReceived', false)
addEventHandler('tmtaGarage.onPlayerVehiclesReceived', root, 
    function(playerVehicles, params)
        local player = params.player
        triggerClientEvent(player, 'tmtaGarage.onPlayerVehiclesUpdate', resourceRoot, playerVehicles)
    end
)

function Garage.getPlayerVehicles(player)
    if not isElement(player) then
        return false
    end

    exports.tmtaVehicle:getPlayerVehiclesAsync(player, 'tmtaGarage.onPlayerVehiclesReceived', {player = player})
end

addEvent('tmtaGarage.getPlayerVehicles', true)
addEventHandler('tmtaGarage.getPlayerVehicles', resourceRoot,
    function()
        local player = client
        if not isElement(player) then
            return false
        end
        Garage.getPlayerVehicles(player)
    end
)

function Garage.setPlayerDefaultSlot(player)
    if (not isElement(player)) then
        outputDebugString('Garage.setPlayerDefaultSlot: bad arguments', 1)
        return false
    end

    local playerGarageSlotCount = getPlayerGarageSlotCount(player)
    if (playerGarageSlotCount >= Config.DEFAULT_GARAGE_SLOT) then
        return false
    end

    return Garage.addPlayerSlot(player, Config.DEFAULT_GARAGE_SLOT-playerGarageSlotCount)
end

function Garage.addPlayerSlot(player, amount)
    if (not isElement(player) or type(amount) ~= 'number') then
        outputDebugString('Garage.addPlayerSlot: bad arguments', 1)
        return false
    end
    amount = math.ceil(math.abs(amount))

    local playerGarageSlotCount = getPlayerGarageSlotCount(player)
    player:setData('garageSlot', tonumber(playerGarageSlotCount + amount))
    triggerClientEvent(player, 'tmtaGarage.onClientUpdateGarageSlotCount', resourceRoot)

    return true
end

function Garage.removePlayerSlot(player, amount)
    if (not isElement(player) or type(amount) ~= 'number') then
        outputDebugString('Garage.removePlayerSlot: bad arguments', 1)
        return false
    end
    amount = math.ceil(math.abs(amount))

    local playerGarageSlotCount = getPlayerGarageSlotCount(player)
    local currentGarageSlotCount = tonumber(playerGarageSlotCount - amount)
	if (currentGarageSlotCount < 0) then
		currentGarageSlotCount = 0
	end

    player:setData('garageSlot', tonumber(currentGarageSlotCount))
    triggerClientEvent(player, 'tmtaGarage.onClientUpdateGarageSlotCount', resourceRoot)

    return true
end

addEvent('tmtaGarage.spawnVehicle', true)
addEventHandler('tmtaGarage.spawnVehicle', resourceRoot,
    function(vehicle)
        local player = client
        if (not player or not vehicle or type(vehicle) ~= 'table') then
            return false
        end
        
        local spawnedVehicle = exports.tmtaVehicle:spawnPlayerVehicle(tonumber(vehicle.userVehicleId), player.position + Vector3(2, 2, 0.1), player.rotation)
        if not isElement(spawnedVehicle) then
            return
        end

        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AГараж", 
            "Вы выгнали #FFA07A"..vehicle.name.." #FFFFFF из гаража", 
            _, 
            {240, 146, 115}
        )
    end
)

addEvent('tmtaGarage.destroyVehicle', true)
addEventHandler('tmtaGarage.destroyVehicle', resourceRoot,
    function(vehicle)
        local player = client
        if (not player or not vehicle or type(vehicle) ~= 'table') then
            return false
        end
        
        if exports.tmtaVehicle:destroyVehicle(tonumber(vehicle.userVehicleId)) then
            exports.tmtaNotification:showInfobox(
                player, 
                "info", 
                "#FFA07AГараж", 
                "Вы загнали #FFA07A"..vehicle.name.." #FFFFFF в гараж", 
                _, 
                {240, 146, 115}
            )
        end
    end
)

addEvent('tmtaGarage.returnVehiclesToGarage', true)
addEventHandler('tmtaGarage.returnVehiclesToGarage', resourceRoot,
    function()
        local player = client
        if exports.tmtaVehicle:returnPlayerVehiclesToGarage(player) then
            exports.tmtaNotification:showInfobox(
                player, 
                "info", 
                "#FFA07AГараж", 
                "Вы загнали весь транспорт в гараж", 
                _, 
                {240, 146, 115}
            )
        end
    end
)

addEvent('tmtaGarage.sellVehicle', true)
addEventHandler('tmtaGarage.sellVehicle', resourceRoot,
    function(vehicle)
        local player = client
        if (not player or not vehicle or type(vehicle) ~= 'table') then
            return
        end

        local success = exports.tmtaVehicle:deletePlayerVehicle(player, tonumber(vehicle.userVehicleId))
        if not success then
            return
        end

        local price = tonumber(vehicle.price - (vehicle.price * Config.SELL_COMMISSION/100))
        exports.tmtaMoney:givePlayerMoney(player, price)
        Garage.getPlayerVehicles(player)

        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AГараж", 
            "Вы продали государству #FFA07A"..vehicle.name.." #FFFFFFза #FFA07A"..tostring(exports.tmtaUtils:formatMoney(price)).." #FFFFFF₽",
            _, 
            {240, 146, 115}
        )
    end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end
        Garage.setPlayerDefaultSlot(player)
        Garage.getPlayerVehicles(player)
    end
)

addEventHandler('tmtaCarShowroom.onPlayerBuyVehicle', root,
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end
        Garage.getPlayerVehicles(player)
    end
)

addEventHandler('onResourceStart', resourceRoot, 
    function()
        for _, player in ipairs(getElementsByType("player")) do
            Garage.getPlayerVehicles(player)
        end
    end
)