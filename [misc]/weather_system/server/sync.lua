addEvent("requireWeatherTimestamp", true)
addEventHandler("requireWeatherTimestamp", resourceRoot, function ()
	local timestamp = 6000--getRealTime().timestamp
	triggerClientEvent("onServerWeatherTimestamp", resourceRoot, timestamp)
end)
