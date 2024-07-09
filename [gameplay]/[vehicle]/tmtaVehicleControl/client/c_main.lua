local SOUNDS = { }

addEvent('tmtaVehControl.doToggleLights', true)
addEventHandler('tmtaVehControl.doToggleLights', root, function()
	if isElement(SOUNDS.light) then
		destroyElement(SOUNDS.light)
	end

	SOUNDS.light = exports.tmtaSounds:playSound('veh_lightswitch')
end)

addEvent('tmtaVehControl.doToggleLocked', true)
addEventHandler('tmtaVehControl.doToggleLocked', root, function()
	if isElement(SOUNDS.lock) then
		destroyElement(SOUNDS.lock)
	end

	SOUNDS.lock = exports.tmtaSounds:playSound('veh_doorlock')
end)

addEvent('tmtaVehControl.doToggleEngine', true)
addEventHandler('tmtaVehControl.doToggleEngine', root, function()
	if isElement(SOUNDS.engine) then
		destroyElement(SOUNDS.engine)
	end

	SOUNDS.engine = exports.tmtaSounds:playSound('veh_starter_car')
end)

-- Перевернуть ТС
local function flipVehicle()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local rX, rY, rZ = getElementRotation(vehicle)
		setElementRotation(vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler('flip', flipVehicle)
addCommandHandler('f', flipVehicle)