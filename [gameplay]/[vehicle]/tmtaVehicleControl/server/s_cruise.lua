addEvent("tmtaVehControl.enableVehicleCruiseSpeed", true)
addEventHandler ("tmtaVehControl.enableVehicleCruiseSpeed", getRootElement (), function (state) 
	if state then 
		setElementSyncer (source, getVehicleController (source))
	else 		
		setElementSyncer (source, true)
	end
end)


addEventHandler("onVehicleStartExit", root, function(thePlayer, seat)
	if getElementData(source, "vehicle.cruiseSpeedEnabled") and seat == 0 then
		triggerClientEvent(thePlayer, "tmtaVehControl.toggleCruiseSpeed", thePlayer) 
	end
end)