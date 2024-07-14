-- Денежное пособие от профсоюза дальнобойщиков
-- Каждый час выдается пособие
local maxPlayers = getMaxPlayers()
local ALLOWANCE = 12792/2 

local function givePlayerAllowance()

    exports.tmtaChat:clearChat()

    exports.tmtaChat:sendGlobalMessage("#00b9ff► Вы играете на проекте #ffffffTRUCKER × MTA")
    exports.tmtaChat:sendGlobalMessage("#00b9ff► Наша официальная страница #ffffffvk.com/truckermta #00b9ffприсоединяйся!")
    exports.tmtaChat:sendGlobalMessage("#00b9ff► Поддержать проект #fffffftruckermta.ru")
    exports.tmtaChat:sendGlobalMessage("#d43422► Администрация проекта желает вам приятной игры!")

    local players = getElementsByType("player")
    local allowance = ALLOWANCE*((maxPlayers-#players+1)/maxPlayers)
    local allowanceAmount = exports.tmtaUtils:formatMoney(allowance)
    for _, player in ipairs(players) do 
        exports.tmtaChat:sendGlobalMessage("#0bfc03► Профсоюз дальнобойщиков выделил вам #ffffff".. allowanceAmount .." ₽", nil, player)
        exports.tmtaMoney:givePlayerMoney(player, allowance) 
        --TODO: здесь нужно фиксировать статистику выдачи пособий
    end
end 
addEventHandler("tmtaServerTimecycle.onServerHourPassed", root, givePlayerAllowance)