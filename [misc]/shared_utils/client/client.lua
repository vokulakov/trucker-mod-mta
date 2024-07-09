
whiteTexture = dxCreateTexture('assets/images/white.png')
closeTexture = dxCreateTexture('assets/images/close.png')
scrollTexture = dxCreateTexture('assets/images/scroll.png')

function getWhiteTexture()
	return whiteTexture
end
function getCloseTexture()
	return closeTexture
end
function getScrollTexture()
	return scrollTexture
end



serverTimeDifference = 0
function _getServerTimestamp()
	return getRealTime(getRealTime().timestamp + serverTimeDifference)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	triggerServerEvent('timestamp.getFromServer', resourceRoot, getRealTime())
end)

addEvent('timestamp.receiveFromServer', true)
addEventHandler('timestamp.receiveFromServer', root, function(difference)
	serverTimeDifference = difference
end)