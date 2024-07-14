addEventHandler('onClientResourceStart', resourceRoot,
    function ()
    end
)

addEventHandler("onClientPlayerVehicleEnter", root, function()
	if (source ~= localPlayer) then
		return
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
    if (player ~= localPlayer or seat ~= 0) then
        return
    end
end)

addEventHandler("onClientPlayerVehicleExit", root, 
    function()
        if (source ~= localPlayer) then
            return
        end
    end
)

addEventHandler("onClientElementDestroy", root, 
    function()
        if (getElementType(source) ~= "vehicle" or getPedOccupiedVehicle(localPlayer) ~= source) then
            return
        end
    end
)

addEventHandler("onClientPlayerWasted", localPlayer, 
    function()
        if (not getPedOccupiedVehicle(source)) then 
            return 
        end
    end
)