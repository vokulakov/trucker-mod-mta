local MIN_PLAYER_LVL = 2
local MAX_DISTANCE = 5
local MAX_AMOUNT = 30000

local PAY_FLOOD_TIME = 2 -- сек
local TEMPORARY_PAY_STOP_TIME = 5 -- сек

local Players = {}

local function isPlayerCanPay(player)
	if (not isElement(player)) then
		return false
	end
	
	if (not Players[player]) then
		return true
	end
		
	return not isTimer(Players[player].timer)
end

local function onPlayerPay(player)
	if not isElement(player) then
		return false
	end
	
	if not Players[player] then 
		Players[player] = {}
		Players[player].timer = nil
		Players[player].floodCount = 0
	end

	local muteTime = PAY_FLOOD_TIME * 1000
	if not isPlayerCanPay(player) then
		Players[player].floodCount = Players[player].floodCount + 1
		if Players[player].floodCount >= 3 then
			muteTime = TEMPORARY_PAY_STOP_TIME * 1000
		end
	end
	
	if isTimer(Players[player].timer) then
		killTimer(Players[player].timer)
	end
	
	Players[player].timer = setTimer(
		function()
			if (not isElement(player) or not Players[player]) then
				return
			end
			
			Players[player].timer = nil
			Players[player].floodCount = 0
		end, muteTime, 1)
end

local function getPlayerById(playerId)
    for _, player in ipairs(getElementsByType('player')) do
        if tonumber(getElementData(player, 'player.serverId')) == tonumber(playerId) then
            return player
        end
    end
    return false
end

addCommandHandler('pay', 
    function(player, cmd, playerId, amount)
        if (exports.tmtaExperience:getPlayerLvl(player) < MIN_PLAYER_LVL) then
            local message = string.format('Для команды /pay требуется %d+ уровень', MIN_PLAYER_LVL)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

		if not isPlayerCanPay(player) then
			onPlayerPay(player)
			local message = 'Подождите, нельзя часто передавать деньги'
			return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
		end
		
        if (not playerId or not amount) then
            local message = '/pay [id игрока] [количество денег]'
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        local receiverPlayer = getPlayerById(playerId)
		if not receiverPlayer then
		    local message = string.format('Игрок не найден!', playerId)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'error', message)
		end
		
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

        if (getElementData(receiverPlayer, 'player.isAFK')) then
            local message = string.format("Игрок '%s' находится в режиме AFK", receiverPlayer.name)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        if (exports.tmtaExperience:getPlayerLvl(receiverPlayer) < MIN_PLAYER_LVL) then
            local message = string.format('Передать деньги можно игроку с уровнем %d+', MIN_PLAYER_LVL)
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        local amount = tonumber(math.ceil(math.abs(amount)))
		if (amount > MAX_AMOUNT) then
		    local message = string.format("Нельзя передавать за раз больше %s ₽", exports.tmtaUtils:formatMoney(MAX_AMOUNT))
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'error', message)
		end
		
        if (exports.tmtaMoney:getPlayerMoney(player) < amount) then
            local message = 'У вас недостаточно денежных средств'
            return triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'warning', message)
        end

        if (exports.tmtaMoney:takePlayerMoney(player, amount)) then
            exports.tmtaMoney:givePlayerMoney(receiverPlayer, amount)
			onPlayerPay(player)
			
            local formatMoney = exports.tmtaUtils:formatMoney(amount)

            local message = string.format("Вы передали игроку '%s' %s ₽", receiverPlayer.name, formatMoney)
            triggerClientEvent(player, 'tmtaPlayerPay.showNotice', resourceRoot, 'success', message)

            local message = string.format("Игрок '%s' передал вам %s ₽", player.money, formatMoney)
            triggerClientEvent(receiverPlayer, 'tmtaPlayerPay.showNotice', resourceRoot, 'success', message)

            exports.tmtaLogger:log('pay', string.format(
                "Player %s (userId %d) pay to player %s (userId %d) amount money %d", 
                player.name, 
                player:getData('userId'), 
                receiverPlayer.name, 
                receiverPlayer:getData('userId'),
                amount
            ))
        end
    end
)