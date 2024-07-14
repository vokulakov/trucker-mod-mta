StreamedVehicles = {}

local function onVehicleStreamIn(vehicle)
    if StreamedVehicles[vehicle] then
        return false
    end
    StreamedVehicles[vehicle] = true
end

addEventHandler('onClientElementStreamIn', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end
        onVehicleStreamIn(source)
    end
)

local function onVehicleStreamOut(vehicle)
    if not StreamedVehicles[vehicle] then
        return false
    end
    StreamedVehicles[vehicle] = nil
end

addEventHandler('onClientElementStreamOut', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end
        onVehicleStreamOut(source)
    end
)

addEventHandler('onClientElementDestroy', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end
        onVehicleStreamOut(source)
        Mileage.stopCalculate()
    end
)

addEventHandler('onClientPlayerVehicleEnter', root, 
    function()
        if (source ~= localPlayer) then
            return
        end
        Mileage.startCalculate()
    end
)

addEventHandler('onClientVehicleStartExit', root, 
    function(player, seat)
        if (player ~= localPlayer or seat ~= 0) then
            return
        end
        Mileage.stopCalculate()
    end
)

addEventHandler('onClientPlayerVehicleExit', root, 
    function()
        if (source ~= localPlayer) then
            return
        end
        Mileage.stopCalculate()
    end
)

addEventHandler('onClientPlayerWasted', localPlayer, 
    function()
        if (not getPedOccupiedVehicle(source)) then 
            return 
        end
        Mileage.stopCalculate()
    end
)

addEventHandler('onClientResourceStart', resourceRoot,
    function ()
        for _, vehicle in pairs(getElementsByType('vehicle', root, true)) do
            onVehicleStreamIn(vehicle)
        end
    end
)