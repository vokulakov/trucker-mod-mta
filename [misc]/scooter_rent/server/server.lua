local veh = {}
local timer = {}
--[[
function giveVehicleNumberPlate(vehicle)
	if not isElement(vehicle) then 
        return
    end

	vehicle:setData("numberType", 'moto')
    vehicle:setData("number:plate", '1234AB77')
end
]]
function arendaMoped ()

	if exports.tmtaMoney:getPlayerMoney (client) >= Settings.moneyArenda then
	
		local id = Settings.id
		local x, y, z = getElementPosition (client)
		
		if isElement(veh[client]) then
			destroyElement (veh[client])
		end
		if isTimer (timer[veh[client]]) then
			killTimer (timer[veh[client]])
		end
		
		veh[client] = createVehicle(id, x, y, z)
		warpPedIntoVehicle (client, veh[client])
		--giveVehicleNumberPlate(veh[client])

		exports.tmtaNotification:showInfobox(
            client, 
            "info", 
            "#FFA07AАренда", 
            "Вы взяли в аренду скутер за #FFA07A"..convertNumber(Settings.moneyArenda).." ₽ #FFFFFFна #FFA07A"..Settings.timeArenda.." мин", 
            _, 
            {240, 146, 115}
        )

		exports.tmtaMoney:takePlayerMoney (client, Settings.moneyArenda)
		triggerClientEvent("tmtaSounds.playMoneySound", client)

		timer[veh[client]] = setTimer (function(pl)
			
			if isElement(pl) then

				exports.tmtaNotification:showInfobox(
					pl, 
					"info", 
					"#FFA07AВнимание!", 
					"Аренда скутера закончилась", 
					_, 
					{240, 146, 115}
				)

				if isElement(veh[pl]) then
					destroyElement (veh[pl])
				end		
			end
			
		end, Settings.timeArenda * 1000 * 60, 1, client)
		
	else
		exports.tmtaNotification:showInfobox(
            client, 
            "info", 
            "#FFA07AАренда", 
            "У вас нехватает денежных средств для аренды #FFA07Aскутера", 
            _, 
            {240, 146, 115}
        )
	end

end
addEvent ("arendaMoped", true)
addEventHandler ("arendaMoped", resourceRoot, arendaMoped)

addEventHandler("onPlayerQuit", root, function()
	if isElement(veh[source]) then
		destroyElement (veh[source])
	end
	if isTimer (timer[veh[source]]) then
		killTimer (timer[veh[source]])
	end
end)

















