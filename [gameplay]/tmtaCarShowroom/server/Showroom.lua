Showroom = {}
local PlayersInShowroom = {}

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

    --TODO: exports.tmtaVehicle:addPlayerVehicle()
    
    return true
end

addEvent('tmtaCarShowroom.onPlayerBuyVehicle', true)
addEventHandler('tmtaCarShowroom.onPlayerBuyVehicle', root,
    function(model, price, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        local player = source
        if (not isElement(player)) then
            return
        end

        local success, errorMessage = Showroom.playerBuyVehicle(player, model, price, 0, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        if (not success and errorMessage) then
            --TODO: вынести showNotice в один общий ресурс через shared
            triggerClientEvent(player, 'tmtaCarShowroom.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

function dbPlayerBuyVehicle(result, params)
    if (not params or not isElement(params.player)) then
        return false
    end

    local player = params.player
    local price = params.price
    local vehicleName = params.vehicleName

    local success = not not result
    if success then
        exports.tmtaMoney:takePlayerMoney(player, tonumber(price))
        triggerClientEvent(player, 'tmtaCarShowroom.showNotice', resourceRoot, 'success', string.format('Поздравляем с покупкой %s!', vehicleName))
    end

    return success
end