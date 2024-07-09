local streamedVehicle = {}

local dataFields = {
    ['numberPlateType'] = true,
    ['numberPlate'] = true,
}

local function onVehicleStreamIn(vehicle)
    if streamedVehicle[vehicle] then
        return false
    end

    LicensePlate.setOnVehicle(vehicle)

    streamedVehicle[vehicle] = true
end

local function onVehicleStreamOut(vehicle)
    if not streamedVehicle[vehicle] then
        return false
    end

    LicensePlate.destroyFromVehicle(vehicle)

    streamedVehicle[vehicle] = nil
end

addEventHandler('onClientResourceStart', resourceRoot,
    function()
        LicensePlateMarker.createMarkers()
        for _, vehicle in pairs(getElementsByType('vehicle', root, true)) do
            onVehicleStreamIn(vehicle)
        end
    end
)

addEventHandler('onClientResourceStop', resourceRoot,
    function()
        for vehicle in pairs(streamedVehicle) do
            onVehicleStreamOut(vehicle)
        end
    end
)

addEventHandler('onClientElementStreamIn', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end
        onVehicleStreamIn(source)
    end
)

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
    end
)

addEventHandler('onClientElementDataChange', root, 
    function(dataName)
        if (getElementType(source) ~= 'vehicle' or not dataFields[dataName]) then
            return
        end
        if (isElementStreamedIn(source)) then
            LicensePlate.setOnVehicle(source)
        end
    end
)

addEventHandler('onClientVehicleSetColor', root,
    function(BodyColor, BodyColorAdditional)
        local vehicle = source
        if (not isElement(vehicle) or not isElementStreamedIn(vehicle)) then
            return
        end

        local licensePlateType = Config.LICENSE_PLATE_TYPE[tonumber(vehicle:getData('numberPlateType'))] or Config.LICENSE_PLATE_TYPE[0]
        if licensePlateType ~= Config.LICENSE_PLATE_TYPE[0] then
            return false
        end
 
        LicensePlate.setOnVehicle(vehicle)
    end
)

addEventHandler('onClientVehicleStartExit', root, 
    function(player, seat)
        if (player ~= localPlayer or seat ~= 0) then
            return
        end
        LicensePlateMarker.destroyActionButton()
        LicensePlateGUI.closeWindow()
    end
)

addEventHandler('onClientElementDestroy', root, 
    function()
	    if getElementType(source) ~= "vehicle" or getPedOccupiedVehicle(localPlayer) ~= source then
            return
        end
        LicensePlateMarker.destroyActionButton()
        LicensePlateGUI.closeWindow()
    end
)

addEventHandler('onClientPlayerWasted', localPlayer, 
    function()
        LicensePlateMarker.destroyActionButton()
        LicensePlateGUI.closeWindow()
    end
)

