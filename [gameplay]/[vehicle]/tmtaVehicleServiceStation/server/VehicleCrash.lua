setTimer(
	function()
		for _, vehicle in ipairs(getElementsByType("vehicle")) do
			if getElementHealth(vehicle) < 300 then
				setVehicleDamageProof(vehicle, true)
				setElementHealth(vehicle, 255.5)
                setVehicleEngineState(vehicle, false)
			else
				if getElementHealth(vehicle) > 301 then
					setVehicleDamageProof(vehicle, false)
				end
  			end
 		end
	end, 100, 0)


addEvent("tmtaVehSTO.doToggleEngine", true)
addEventHandler("tmtaVehSTO.doToggleEngine", root, function(vehicle)
    local player = source
    if not isElement(player) or not isElement(vehicle) then 
        return
    end
    setVehicleEngineState(vehicle, false)
end)
   