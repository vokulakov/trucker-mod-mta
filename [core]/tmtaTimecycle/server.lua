RealTime = {}

function RealTime.get()
    local time = getRealTime()
    if (RealTime.currentWeekday ~= time.weekday) then
        triggerEvent("tmtaServerTimecycle.onWeekdayChange", root)
        triggerClientEvent(root, "tmtaServerTimecycle.onWeekdayChange", root)
    elseif (RealTime.currentHour ~= time.hour) then
		RealTime.currentHour = time.hour
		outputDebugString('Серверное время '..string.format("%02d:%02d:%02d", getRealTime().hour, getRealTime().minute, getRealTime().second))
		triggerEvent("tmtaServerTimecycle.onServerHourPassed", root)
        triggerClientEvent(root, "tmtaServerTimecycle.onServerHourPassed", root)
    elseif (RealTime.currentMinute ~= time.minute) then
        RealTime.currentMinute = time.minute
        triggerEvent("tmtaServerTimecycle.onServerMinutePassed", root)
        triggerClientEvent(root, "tmtaServerTimecycle.onServerMinutePassed", root)
    end
end

function RealTime.resetTimeOfDay()
    local CYCLES_PER_DAY = 4 -- каждые 6 часов с 00:00 проходят новые сутки
    local MINUTE_DURATION = 60 * 1000 / CYCLES_PER_DAY
    local FULL_DAY_MINUTES = 24 * 60

    local REALTIME = getRealTime()
    local REAL_H, REAL_M = REALTIME.hour, REALTIME.minute

    local passed_minutes = REAL_H * 60 + REAL_M
    local passed_percent = passed_minutes / ( 24 * 60 )

    local required_percent = passed_percent * CYCLES_PER_DAY
    local required_minutes_total = ( required_percent - math.floor( required_percent ) ) * FULL_DAY_MINUTES

    local required_hours = math.floor( required_minutes_total / 60 )
    local required_minutes = math.floor( required_minutes_total - required_hours * 60 )

    setTime(required_hours, required_minutes)
    setMinuteDuration(MINUTE_DURATION)
end

addEvent('tmtaTimecycle.onServerSyncPlayerGameTime', true )
addEventHandler('tmtaTimecycle.onServerSyncPlayerGameTime', root, 
    function()
        triggerClientEvent(source, 'tmtaTimecycle.onClientSyncPlayerGameTime', source, {getTime()}, getMinuteDuration())
    end
)

addEventHandler("onResourceStart", resourceRoot, 
    function()
        RealTime.currentHour = getRealTime().hour
        RealTime.currentMinute = getRealTime().minute
        RealTime.currentWeekday = getRealTime().weekday
        setTimer(RealTime.get, 1000, 0)
        RealTime.resetTimeOfDay()
    end
)