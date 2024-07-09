local function processResourceByName(resourceName, start)
	local resource = getResourceFromName(resourceName)
	if not resource then
		return false
	end
	if start then
		startResource(resource)
		if getResourceState(resource) == "running" then
			return true
		else
			return false
		end
	else
		return stopResource(resource)
	end
end

local function shutdownGamemode(showMessage, kickPlayers)
	if showMessage then
		for i = 1, 20 do
			outputChatBox(" ", root, 255, 0, 0)
		end
		outputChatBox("*** GAMEMODE RESTART ***", root, 255, 0, 0)
	end

	-- Кик всех игроков перед выключением
	if kickPlayers then
		for i, player in ipairs(getElementsByType("player")) do
			kickPlayer(player, "", "GAMEMODE RESTART")
		end
	end

	-- Выключение всех ресурсов
	for i, resourceName in ipairs(Config.STARTUP_RESOURCES) do
		processResourceByName(resourceName, false)
	end
end

addEventHandler("onResourceStart", resourceRoot, function()
	for i, resourceName in ipairs(Config.STARTUP_RESOURCES) do
		if not processResourceByName(resourceName, true) then
			outputConsole("WARNING!")
			outputConsole("STARTUP: failed to start '" .. tostring(resourceName) .. "'")
		end
	end
end)

addEventHandler("onResourceStop", resourceRoot, function()
	exports.tmtaSQLite:dbDisconnect()
	shutdownGamemode(Config.SHOW_MESSAGE, Config.KICK_PLAYERS)
end)