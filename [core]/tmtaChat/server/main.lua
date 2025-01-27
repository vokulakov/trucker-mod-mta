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
local function onMessage(...)
	if not client then
		return
	end
	
	local player = client
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

	--TODO: доработать, чтобы нормально работали фиксированные слова,
	-- иначе блочит все сообщение
	--[[
	if AntiCaps.onMessage(message) or AntiSpam.onMessage(message) then
		--outputChatBox("#FF0000* Нельзя писать капсом!", player, 255, 0, 0, true)
		sendServerMessage("#FF0000 Нельзя писать капсом!", player)
		return
	end
	]]

	-- Глобальное сообщение
	local sender = string.format("%s %s", getPlayerTag(player), player.name:gsub("#%x%x%x%x%x%x", ""))
	message = message:gsub("#%x%x%x%x%x%x", "")

	sendGlobalMessage(message, sender)

	exports.tmtaLogger:log("chat", 
		string.format("%s (%s): %s",
			tostring(sender),
			tostring(getAccountName(getPlayerAccount(player))),
			tostring(message)
		)
	)
	
	triggerClientEvent(resName..'.onClientSendMessage', player, message)

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

	local args = table.concat(params, " ", 2)
	local state = executeCommandHandler(params[1], player, args)
	if not state then
		triggerClientEvent(resName..".startCommandClient", player, args)
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

addEventHandler("onPlayerLogout", root, 
	function()
		--outputChatBox('* Неизвестная команда!', source, 255, 0, 0)
		sendServerMessage('Неизвестная команда!', source, 255, 0, 0)
		--triggerClientEvent(source, 'operNotification.addNotification', source, "Неизвестная команда", 2, true)
		cancelEvent() 
	end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end
		
		local playerName = string.format("%s %s", getPlayerTag(player), player.name:gsub("#%x%x%x%x%x%x", ""))
		sendGlobalMessage(string.format("* %s #FFFFFFподтянулся к игре", playerName))
    end
)

addEventHandler('onPlayerQuit', root, 
    function(quitType)
		local player = source
		local playerName = string.format("%s %s", getPlayerTag(player), player.name:gsub("#%x%x%x%x%x%x", ""))
		sendGlobalMessage(string.format("* %s #FFFFFFсплавился из игры #FF0000[Причина: %s]", playerName, quitType))
    end
)
