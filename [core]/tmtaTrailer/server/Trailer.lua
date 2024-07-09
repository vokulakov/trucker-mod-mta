Trailer = {}

local _spawnedTrailers = {}

local _spawnVehicle = spawnVehicle
local function spawnVehicle(...)
	local trailer = createVehicle(...)

	trailer:setColor(255, 255, 255)
	setVehicleOverrideLights(trailer, 1)
	setVehicleEngineState(trailer, false)

	return trailer
end

function Trailer.spawn(trailerModel, position, rotation)
    if (type(trailerModel) ~= "number" or not Config.TRAILER[trailerModel] or type(position) ~= 'userdata') then
		outputDebugString('Trailer.spawn: bad arguments', 1)
		return false
	end
	if not rotation then rotation = Vector3() end

    local trailer = spawnVehicle(trailerModel, position, rotation)
	trailer:setData('isTrailer', true)

    trailer:setData('trailer:type', Config.TRAILER[trailerModel].type)
    trailer:setData('trailer:loadCapacity', tonumber(Config.TRAILER[trailerModel].loadCapacity))

    _spawnedTrailers[trailer] = true
    
	--triggerEvent('onTrailerCreated', trailer)
	--triggerClientEvent(root, 'onClientTrailerCreated', trailer)

	return trailer
end

function Trailer.destroy(trailer)
	if not isElement(trailer) then
		return
	end

	for dataName in pairs(getAllElementData(trailer)) do
		trailer:removeData(dataName)
    end

	_spawnedTrailers[trailer] = nil
end

addEventHandler('onVehicleExplode', root, 
	function()
		setTimer(Trailer.destroy, 5000, 1, source)
	end, true, 'low-10')

addEventHandler('onElementDestroy', root,
	function()
		if (not _spawnedTrailers[source] or source.type ~= 'vehicle') then
			return cancelEvent()
		end
		Trailer.destroy(source)
	end, true, 'low-10')

-- exports
spawnTrailer = Trailer.spawn

