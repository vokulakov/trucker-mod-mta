local MIN_PLAYER_LVL = 2
local MAX_DISTANCE = 40 

local function getPlayerById(playerId)
    for _, player in ipairs(getElementsByType('player', true)) do
        if tonumber(getElementData(player, 'player.serverId')) == tonumber(playerId) then
            return player
        end
    end
    return false
end

addCommandHandler('pay', 
    function(player, cmd, playerId, amount)
        if (exports.tmtaExperience:getPlayerLvl(receiverPlayer) < MIN_PLAYER_LVL) then
            local message = string.format('Для команды /pay требуется %d+ уровень', MIN_PLAYER_LVL)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', errorMessage)
        end

        if (not playerId or not amount) then
            local message = '/pay [id игрока] [количество денег]'
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        local receiverPlayer = getPlayerById(playerId)
        if (receiverPlayer == player) then
            local message = 'Нельзя передать деньги самому себе!'
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'error', message)
        end

        local playerPosX, playerPosY, playerPosZ = getElementPosition(player)
        local receiverPlayerPosX, receiverPlayerPosY, receiverPlayerPosZ = getElementPosition(receiverPlayer)
        if (getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, receiverPlayerPosX, receiverPlayerPosY, receiverPlayerPosZ) > MAX_DISTANCE) then
            local message = string.format('Игрок слишком далеко от вас!', MIN_PLAYER_LVL)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message) 
        end

        if (exports.tmtaExperience:getPlayerLvl(receiverPlayer) < MIN_PLAYER_LVL) then
            local message = string.format('Передать деньги можно игроку с уровнем %d+', MIN_PLAYER_LVL)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        local amount = tonumber(math.ceil(math.abs(amount)))
        if (exports.tmtaMoney:getPlayerMoney(player) < amount) then
            local message = 'У вас недостаточно денежных средств'
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        if (exports.tmtaMoney:takePlayerMoney(player, amount)) then
            exports.tmtaMoney:givePlayerMoney(receiverPlayer, amount)

            local formatMoney = exports.tmtaUtils:formatMoney(amount)

            local message = string.format("Вы передали игроку '%s' %s ₽", receiverPlayer.name formatMoney)
            triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'success', message)

            local message = string.format("Игрок '%s' передал вам %s ₽", player.money, formatMoney)
            triggerClientEvent(receiverPlayer, 'tmtaPlayerPay.showNotice', resourceRoot, 'success', message)

            exports.tmtaLogger:log('pay', string.format(
                "Player %s (userId %d) pay to player %s (userId %d) amount money %d", 
                player.name, 
                player:getData('userId'), 
                receiverPlayer.name, 
                receiverPlayer:getData('userId'),
                amount,
            ))
        end

    end
)