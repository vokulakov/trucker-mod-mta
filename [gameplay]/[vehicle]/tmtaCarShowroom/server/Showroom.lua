Showroom = {}
local PlayersInShowroom = {}

addEvent('tmtaCarShowroom.onPlayerBuyVehicle', true)

function Showroom.playerEnter(player)
    if (not isElement(player)) then
        return
    end

    player.interior = Config.showroomObjectInterior
    player.dimension = getDimensionForPlayer(player)
    --player.position = Config.showroomObjectPosition
    
    return triggerClientEvent(player, 'tmtaCarShowroom.onPlayerEnterCarShowroom', player)
end

addEvent('tmtaCarShowroom.onPlayerEnterCarShowroom', true)
addEventHandler('tmtaCarShowroom.onPlayerEnterCarShowroom', root,
    function()
        local player = client
        if (not isElement(player) or player.dimension ~= 0) then 
            return
        end 

        PlayersInShowroom[player] = true
        setTimer(Showroom.playerEnter, 1100, 1, player)
    end
)

function Showroom.playerExit(player)
    PlayersInShowroom[player] = nil

    player.dimension = 0
    player.interior = 0
    
    clearPlayerDimension(player)

    return triggerClientEvent(player, 'tmtaCarShowroom.onPlayerExitCarShowroom', player)
end

addEvent('tmtaCarShowroom.onPlayerExitCarShowroom', true)
addEventHandler('tmtaCarShowroom.onPlayerExitCarShowroom', root,
    function()
        local player = client
        if (not isElement(player)) then
            return
        end

        setTimer(Showroom.playerExit, 1100, 1, player)
    end
)

function Showroom.playerBuyVehicle(player, model, price, level, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
    if (not isElement(player) or type(model) ~= 'string' or type(price) ~= 'number' or type(level) ~= 'number') then
        outputDebugString('Showroom.playerBuyVehicle: bad arguments', 1)
        return false
    end

    local vehicleId = tonumber(Utils.getVehicleModelFromName(model))
    local vehicleName = Utils.getVehicleNameFromModel(model)

    if (exports.tmtaExperience:getPlayerLvl(player) < level) then
        local errorMessage = string.format('Для покупки %s требуется %d+ уровень', vehicleName, level)
        return false, errorMessage
    end

    if (exports.tmtaMoney:getPlayerMoney(player) < price) then
        local errorMessage = string.format('Недостаточно средств для покупки %s', vehicleName)
        return false, errorMessage
    end

    if (not exports.tmtaGarage:isPlayerHasFreeGarageSlot(player)) then
        local errorMessage = string.format('У вас нет парковочных мест для покупки %s. Чтобы увеличить количество парковочных мест купите недвижимость.\n', vehicleName)
        return false, errorMessage
    end

    local success = exports.tmtaVehicle:addPlayerVehicle(player, model, {
        price = price,
        colors = toJSON({
            BodyColor = {colorR1, colorG1, colorB1},
            BodyColorAdditional = {colorR2, colorG2, colorB2}
        }),
        tuning = toJSON({
            BodyColor = {colorR1, colorG1, colorB1},
            BodyColorAdditional = {colorR2, colorG2, colorB2},
        }),
    })
    success = not not success
    
    if (success) then
        exports.tmtaMoney:takePlayerMoney(player, tonumber(price))

        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосалон", 
            "Поздравляем! Вы приобрели #FFA07A"..vehicleName.." #FFFFFFза #FFA07A"..tostring(exports.tmtaUtils:formatMoney(price)).." #FFFFFF₽", 
            _, 
            {240, 146, 115}
        )
    end

    triggerEvent('tmtaCarShowroom.onPlayerBuyVehicle', player, success)

    return success
end

addEvent('tmtaCarShowroom.buyPlayerVehicle', true)
addEventHandler('tmtaCarShowroom.buyPlayerVehicle', root,
    function(model, price, level, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        local player = source
        if (not isElement(player)) then
            return
        end

        local success, errorMessage = Showroom.playerBuyVehicle(player, model, price, level, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        if (not success and errorMessage) then
            return triggerClientEvent(player, 'tmtaCarShowroom.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

addEventHandler('onPlayerQuit', root, 
    function()
        local player = source
        if not PlayersInShowroom[player] then
            return
        end
        Showroom.playerExit(player)
    end
)

addEventHandler('onPlayerWasted', root, 
	function()
        local player = source
        if not PlayersInShowroom[player] then
            return
        end
        Showroom.playerExit(player)
	end
)