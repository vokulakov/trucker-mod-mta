addEventHandler("onResourceStart", resourceRoot, function()
    Database.setup()
    
    -- TODO:: с таймером костыль, ибо не успевают зарегаться клиентские события
    setTimer(function()
        for _, player in ipairs(getElementsByType("player")) do
            Garage.updatePlayerVehiclesInfo(player)
        end 
    end, 1000, 1)

end)

addEventHandler("onResourceStop", resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        Garage.destroyVehicle(vehicle)
    end
end)

addEvent("tmtaCore.login", true)
addEventHandler("tmtaCore.login", root,
    function()
        Garage.updatePlayerVehiclesInfo(source)
    end
)

addEventHandler("onPlayerQuit", root, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if getElementData(vehicle, "owner") == source then
			Garage.destroyVehicle(vehicle)
		end
	end
end)

--Bugfix setElementModel
addEventHandler("onElementModelChange", root, 
	function(oldModel)
        local vehicle = source
		if getElementType(vehicle) ~= 'vehicle' then
			return
		end
		local owner = getElementData(vehicle, "owner")
        if not owner then
            return
        end
        setElementModel(vehicle, oldModel)
	end
)