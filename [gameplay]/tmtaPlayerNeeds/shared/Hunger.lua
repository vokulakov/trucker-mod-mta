Hunger = {}

-- Получить уровень голода
function Hunger.getPlayer(player)
	local player = player or localPlayer
	if not isElement(player) then
		return false
	end
	local playerNeeds = Needs.getPlayer(player)
	return tonumber(playerNeeds.hunger) or 0
end

-- Установить уровень голода
function Hunger.setPlayer(player, amount)
	if not isElement(player) then
		return false
	end
	local playerNeeds = Needs.getPlayer(player)
	playerNeeds.hunger = (amount > 0) and math.abs(amount) or 0
	return player:setData('needs', toJSON(playerNeeds))
end

-- Понизить уровень голода
function Hunger.givePlayer(player, amount)
    if not isElement(player) then
		return false
	end
	local hunger = Hunger.getPlayer(player)
	return Hunger.setPlayer(player, hunger+math.abs(amount))
end

-- Повысить уровень голода
function Hunger.takePlayer(player, amount)
	if not isElement(player) then
		return false
	end
	local hunger = Hunger.getPlayer(player)
	Hunger.onPlayerTakeHunger()
	return Hunger.setPlayer(player, hunger-math.abs(amount))
end

function Hunger.onPlayerTakeHunger()
	if not isElement(localPlayer) then
		return
	end

	local hungerAmount = Hunger.getPlayer(localPlayer)
	if hungerAmount > 20 then
		return
	end

	if isTimer(Hunger.infoTimer) then
		return
	end

	Hunger.infoTimer = setTimer(function() end, 2 * 60 * 1000, 1)

	triggerServerEvent("tmtaPlayerNeeds.onPlayerTakeHunger", localPlayer, hungerAmount)

	exports.tmtaNotification:showInfobox(
		"info", 
		"#FFA07AВы голодны!", 
		"Посетите ресторан быстрого питания", 
		_, 
		{240, 146, 115}
	)
	
	local soundFX = exports.tmtaSounds:playSound('sound_eat1')
	setSoundVolume(soundFX, 0.2)
end

-- Exports
getPlayerHungerLevel = Hunger.getPlayer
givePlayerHungerLevel = Hunger.givePlayer
takePlayerHungerLevel = Hunger.takePlayer
setPlayerHungerLevel = Hunger.setPlayer