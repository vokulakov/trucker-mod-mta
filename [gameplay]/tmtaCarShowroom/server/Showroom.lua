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

function Showroom.playerBuyVehicle(player, model, price, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
    if (not isElement(player) or type(model) ~= 'string' or type(price) ~= 'number') then
        outputDebugString('Showroom.playerBuyVehicle: bad arguments', 1)
        return false
    end

    local vehicleId = tonumber(Utils.getVehicleModelFromName(model))

    return true
end

addEvent('tmtaCarShowroom.onPlayerBuyVehicle', true)
addEventHandler('tmtaCarShowroom.onPlayerBuyVehicle', root,
    function(model, price, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        local player = source
        if (not isElement(player) or type(model) ~= 'string' or type(price) ~= 'number') then
            return
        end

        local success, errorMessage = Showroom.playerBuyVehicle(player, model, price, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2)
        if (not success and errorMessage) then
        end
    end
)