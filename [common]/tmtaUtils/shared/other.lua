function defaultValue(value, default)
	if value == nil then
		return default
	else
		return value
	end
end

function clearChat(...)
	outputChatBox(('\n'):rep(getChatboxLayout("chat_lines")))
end

function isResourceRunning(name)
	local resource = Resource.getFromName(name)
	if not resource then
		return false
	end
	return resource.state == "running"
end

function getPlayersByPartOfName(namePart, caseSensitive)
	if not namePart then
		return
	end
	local players = getElementsByType("player")
	if not caseSensitive then
		namePart = string.lower(namePart)
	end
	local matchingPlayers = {}
	for i, player in ipairs(players) do
		local playerName = getPlayerName(player)
		if not caseSensitive then
			playerName = string.lower(playerName)
		end
		if string.find(playerName, namePart) then
			table.insert(matchingPlayers, player)
		end
	end
	return matchingPlayers
end

local _getElementData = getElementData
function getElementDataDefault(element, dataName, defaultValue)
	if not element then
		return defaultValue
	end
	if not dataName then
		return defaultValue
	end
	local value = _getElementData(element, dataName)
	if not value then
		return defaultValue
	end
	return value
end