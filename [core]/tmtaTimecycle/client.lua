RealTime = {}

function RealTime.onGameTimeRequest(time, weather)
    setTime(unpack(time))
    setWeather(weather)
end
addEvent("tmtaServerTimecycle.onGameTimeRecieve", true )
addEventHandler("tmtaServerTimecycle.onGameTimeRecieve", root, RealTime.onGameTimeRequest)