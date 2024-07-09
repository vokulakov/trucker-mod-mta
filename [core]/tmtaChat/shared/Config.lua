Config = {}
resName = getResourceName(resource) -- название ресурса

Config.colors = {
    --['default'] = 
}

Config.MAX_MESSAGE_LENGTH = 128 -- максимальная длина сообщения
Config.MAX_MESSAGE_BUFER = 50 -- сколько сообщений может храниться в буфере

Config.commandsBlocked = { -- принудительное блокирование команд
    --['say'] = true,
	['me'] = true,
	['msg'] = true,

    ['showhud'] = true, -- ?
    ['showchat'] = true, -- ?

    ['logout'] = true,
    ['login'] = true,
}

-- Flood
Config.FLOOD_TIME = 1000
Config.TEMPORARY_MUTE_TIME = 3000

