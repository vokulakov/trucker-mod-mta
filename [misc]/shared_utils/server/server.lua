
function getTimeDifference(date)
	return getRealTime().timestamp - date.timestamp
end

addEvent('timestamp.getFromServer', true)
addEventHandler('timestamp.getFromServer', resourceRoot, function(date)
	triggerClientEvent(client, 'timestamp.receiveFromServer', client, getTimeDifference(date))
end)