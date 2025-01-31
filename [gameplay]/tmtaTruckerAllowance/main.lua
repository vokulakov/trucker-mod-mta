local maxPlayers = getMaxPlayers() 

addEventHandler("tmtaServerTimecycle.onServerHourPassed", root, 
    function()
        exports.tmtaChat:clearChat()

        exports.tmtaChat:sendGlobalMessage("#00b9ff► Вы играете на проекте #ffffffTRUCKER × MTA")
        exports.tmtaChat:sendGlobalMessage("#00b9ff► Наша официальная страница #ffffffvk.com/truckermta #00b9ffприсоединяйся!")
        exports.tmtaChat:sendGlobalMessage("#00b9ff► Поддержать проект #fffffftruckermta.ru")
        exports.tmtaChat:sendGlobalMessage("#d43422► Администрация проекта желает вам приятной игры!")
    
        local players = getElementsByType("player")
        local allowance = math.random(3000, 6000)*((maxPlayers-#players+1)/maxPlayers)
        allowance = exports.tmtaX2:isPromoActive() and allowance*2 or allowance

        local allowanceAmount = exports.tmtaUtils:formatMoney(allowance)
        for _, player in ipairs(players) do
            if (
                not getElementData(player, 'player.isAFK') or
                (getElementData(player, 'player.isAFK') and tonumber(getElementData(player, 'player.msTimeAFK')) < 30 * 60 * 1000)
            ) then
                exports.tmtaChat:sendGlobalMessage("#0bfc03► Профсоюз дальнобойщиков выделил вам #ffffff".. allowanceAmount .." ₽", nil, player)
                exports.tmtaMoney:givePlayerMoney(player, tonumber(allowance))
            end
        end
    end
)