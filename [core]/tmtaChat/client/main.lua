local bufferMessages = {}
local bufferSize = Config.MAX_MESSAGE_BUFER
local bufferSelectionIndex = 0

--TODO:: серверные сообщения выводить в одной стилистике и цвете (например, 139, 140, 141)
--FEATURE:: реализовать команду для очистки буфера

local function outputMessageOnChatBox(message, r, g, b, sender)
    local time = getRealTime()
    local timestamp = string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)

    local messageColor = "#FFFFFF"
    if r and g and b then
        messageColor = exports.tmtaUtils:RGBToHex(r, g, b)
    end
    
    sender = (sender) and string.format("%s: ", sender) or ""
	
	--TODO: тоже переработать иначе реагирует на всякие слова
	message = WordsFilter.filter(message)
	
    message = string.format("#FFFFFF[%s] ", timestamp)..sender..string.format("%s%s", messageColor, message)
    
    outputChatBox(message, 255, 255, 255, true)
end
addEvent(resName..".onPlayerSendMessage", true)
addEventHandler(resName..".onPlayerSendMessage", root, outputMessageOnChatBox)

-- Получаем сообщение из InputBox
function onMessageFromInputBox(message)
    if not message or message:gsub(" ", "") == "" then
        return
    end

    triggerServerEvent(resName..".onPlayerSendMessage", localPlayer, message)
    
    -- Буфер
    for i = 1, #bufferMessages do
        if bufferMessages[i] == message then
            table.remove(bufferMessages, i)
        end
    end

    if #bufferMessages >= bufferSize then
        table.remove(bufferMessages, 1)
    end

    table.insert(bufferMessages, message)
end

-- Переключение буфера
addEventHandler("onClientKey", root, function(key, press)
    if not InputBox.isActive() or not press then 
        return
    end
    if (key == "arrow_u") then
        local message = bufferMessages[bufferSelectionIndex - 1]
        if message then
            InputBox.setMessage(message)
            bufferSelectionIndex = bufferSelectionIndex - 1
        end
    elseif (key == "arrow_d") then
        if bufferSelectionIndex ~= #bufferMessages then
            local message = bufferMessages[bufferSelectionIndex + 1]
            if bufferMessages[bufferSelectionIndex + 1] then
                InputBox.setMessage(message)
                bufferSelectionIndex = bufferSelectionIndex + 1
            end
        else
            InputBox.reset()
            bufferSelectionIndex = #bufferMessages + 1
        end
    end
end)

addEvent(resName..".onCloseInputBox", false)
addEventHandler(resName..".onCloseInputBox", localPlayer, function()
    bufferSelectionIndex = #bufferMessages + 1
end)

--https://wiki.multitheftauto.com/wiki/OnClientChatMessage
--Отлавливание всех сообщений в чат (в том числе системных)
--срабатывает только после outputChatBox
addEventHandler("onClientChatMessage", root, function(message, r, g, b, messageType)
    if messageType then
        --outputMessageOnChatBox('SERVER', message, r, g, b)
        cancelEvent()
    end
   -- local time = getRealTime()
   -- local timestamp = string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)
   -- local message = string.format("#FFFFFF[%s] %s", timestamp, message)
   -- iprint(message)
end)

-- клиентские команды
local function startCommandClient(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	if source ~= localPlayer then return end
	local state = executeCommandHandler(arg1, arg2, arg3, arg4, arg5, arg6, arg7)

	if not state then
        outputMessageOnChatBox("Неизвестная команда!", 255, 0, 0, "SERVER")
		--outputChatBox('* Неизвестная команда!', 255, 0, 0)
		--triggerEvent('operNotification.addNotification', localPlayer, 'Неизвестная команда', 2, true)
	end
end
addEvent(resName..".startCommandClient", true)
addEventHandler(resName..".startCommandClient", root, startCommandClient)

addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(toggleControl, 100, 0, "chatbox", false) -- принудительное отключение поля вводя сообщения
    setChatboxCharacterLimit(Config.MAX_MESSAGE_LENGTH)
    clearChat()
    loadChatBoxSetup()
    InputBox.create()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    saveChatBoxSetup()
end)

-- Сохрание параметров чата
function loadChatBoxSetup()
    local data = loadFile("chatBoxSetup.json")
    if data then
        data = teaDecodeBinary(data, "wHF2nyXlyTrV4kfq")
		local setup = fromJSON(data)
        if setup then
            bufferMessages = setup["bufferMessages"] or {}
            if #bufferMessages > 0 then
				bufferSelectionIndex = #bufferMessages + 1;
			end
        end
    end
end

function saveChatBoxSetup()
    local tempSetup = {
        ["bufferMessages"] = bufferMessages
    }

    local data = toJSON(tempSetup)
    data = teaEncodeBinary(data, "wHF2nyXlyTrV4kfq")
    saveFile("chatBoxSetup.json", data)
    tempSetup = nil
end