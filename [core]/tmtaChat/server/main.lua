--- Сообщение в глобальный чат
function sendGlobalMessage(message, sender, toSend, r, g, b)
	toSend = toSend or root
	triggerClientEvent(toSend, resName..".onPlayerSendMessage", resourceRoot, message, r, g, b, sender)
end

--- Сообщение от имени сервера
-- @tparam userdata toSend
function sendServerMessage(message, toSend, r, g, b)
	toSend = toSend or root
	local sender = "TRUCKER × MTA"
	triggerClientEvent(toSend, resName..".onPlayerSendMessage", resourceRoot, message, r, g, b, sender)
end

-- Прилетает сообщение с клиента (это точка входа, дальше вся сортировка от сюда)
local function onMessage(player, ...)
	if not isElement(player) then
		return
	end
	local message = table.concat({ ... }, " ")
	if not message or message:gsub(" ", "") == "" then
		return
	end

	if message:find("^/%a") ~= nil then
		return startCommandServer(string.gsub(message, "(/)", ""), player)
	end
	
    if AntiFlood.isMuted(player) or isPlayerMuted(player) then
		AntiFlood.onMessage(player)
        --outputChatBox("#FF0000* Тихо - тихо, не флуди!", player, 255, 0, 0, true)
		sendServerMessage("#FF0000 Тихо - тихо, не флуди!", player)
		return
	end

	if AntiCaps.onMessage(message) or AntiSpam.onMessage(message) then
		--outputChatBox("#FF0000* Нельзя писать капсом!", player, 255, 0, 0, true)
		sendServerMessage("#FF0000 Нельзя писать капсом!", player)
		return
	end

	message = WordsFilter.filter(message)
	
	-- Глобальное сообщение
	local message = message:gsub("#%x%x%x%x%x%x", "")
	local sender = player.name:gsub("#%x%x%x%x%x%x", "")
	sendGlobalMessage(message, sender)

	exports.tmtaLogger:log("chat", 
		string.format("%s (%s): %s",
			tostring(sender),
			tostring(getAccountName(getPlayerAccount(player))),
			tostring(message)
		)
	)

	AntiFlood.onMessage(player)
end

addEvent(resName..".onPlayerSendMessage", true)
addEventHandler(resName..".onPlayerSendMessage", root, onMessage)

-- Серверные команды
function startCommandServer(command, player)
	local params = {}
	local commands = split(command, " ")
	for k, v in ipairs(commands) do
		params[k] = v
	end

	--[[
	if params[1] == 'me' then
		return onPlayerChatMe(player, string.gsub(command, params[1], ""))
	elseif params[1] == 'try' then
		return onPlayerChatTry(player, string.gsub(command, params[1], ""))
	elseif params[1] == 'do' then
		return onPlayerChatDo(player, string.gsub(command, params[1], ""))
	elseif params[1] == 'todo' then
		return onPlayerChatToDo(player, string.gsub(command, params[1], ""))
	end
	]]

	local state = executeCommandHandler(params[1], player, params[2], params[3], params[4], params[5], params[6], params[7])
	if not state then
		triggerClientEvent(resName..".startCommandClient", player, params[1], params[2], params[3], params[4], params[5], params[6], params[7])
	end
	params = nil
end

-- БЛОК КОМАНД --
addEventHandler("onPlayerCommand", root, function(command)
	if Config.commandsBlocked[command] then
		--outputChatBox('* Неизвестная команда!', source, 255, 0, 0)
		sendServerMessage('Неизвестная команда!', source, 255, 0, 0)
		--triggerClientEvent(source, 'operNotification.addNotification', source, 'Неизвестная команда', 2, true)
		cancelEvent()
	end
end)

-- Это своего рода костыль для любителей делать бинд
addEventHandler("onPlayerChat", root, function(message, messageType)
    if (messageType ~= 0) then
        cancelEvent()
    end
	onMessage(source, message)
	cancelEvent()
end)

addEventHandler("onPlayerLogout", root, function()
	--outputChatBox('* Неизвестная команда!', source, 255, 0, 0)
	sendServerMessage('Неизвестная команда!', source, 255, 0, 0)
	--triggerClientEvent(source, 'operNotification.addNotification', source, "Неизвестная команда", 2, true)
	cancelEvent() 
end)