addEvent("tmtaServerTimecycle.onServerTimeUpdate", true) -- обновление серверного времени
addEvent("tmtaServerTimecycle.onServerHourPassed", true) -- на сервере прошел час
addEvent("tmtaServerTimecycle.onServerMinutePassed", true) -- на сервере прошла минута
addEvent("tmtaServerTimecycle.onWeekdayChange", true) -- на сервере прошла смена дня

function syncPlayerGameTime(player)
    local player = player or localPlayer
    if (not isElement(player)) then
        return false
    end

    triggerEvent('tmtaTimecycle.onServerSyncPlayerGameTime', player)
    triggerServerEvent('tmtaTimecycle.onServerSyncPlayerGameTime', player)

    return true
end

addEvent('tmtaTimecycle.onClientSyncPlayerGameTime', true)
addEventHandler('tmtaTimecycle.onClientSyncPlayerGameTime', root, 
    function(time, minuteDuration)
        setTime(unpack(time))
        setMinuteDuration(minuteDuration)
    end
)