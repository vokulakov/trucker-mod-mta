AntiFlood = {}
local FLOOD_TIME = Config.FLOOD_TIME 
local TEMPORARY_MUTE_TIME = Config.TEMPORARY_MUTE_TIME

local Players = {}

local function unmute(player)
	if not isElement(player) or not Players[player] then
		return false
	end
	Players[player].timer = nil
	Players[player].floodCount = 0
end

function AntiFlood.onMessage(player)
	if not isElement(player) then
		return
	end

	if not Players[player] then 
		Players[player] = {}
		Players[player].timer = nil
		Players[player].floodCount = 0
	end

	local muteTime = FLOOD_TIME
	if AntiFlood.isMuted(player) then
		Players[player].floodCount = Players[player].floodCount + 1
		if Players[player].floodCount >= 3 then
			muteTime = TEMPORARY_MUTE_TIME
			Players[player].floodCount = 0
		end
	end
	if isTimer(Players[player].timer) then
		killTimer(Players[player].timer)
	end
	Players[player].timer = setTimer(unmute, muteTime, 1, player)
end

function AntiFlood.isMuted(player)
	if not isElement(player) or not Players[player] then
		return false
	end
	return isTimer(Players[player].timer)
end

--TODO:: сделать так, чтобы одинаковые сообщения нельзя было писать больше 3 раз