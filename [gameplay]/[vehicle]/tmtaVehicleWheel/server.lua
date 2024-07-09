function updateDimension(dim)
	setElementDimension(client,dim)
	if getPedOccupiedVehicle( client ) then
		setElementDimension(getPedOccupiedVehicle( client ),dim)
	end
end
addEvent("updateDimension",true)
addEventHandler("updateDimension",root,updateDimension)

function applyWheelsData(data, price)
	local veh = getPedOccupiedVehicle( client )

	if exports.tmtaMoney:getPlayerMoney(client) < price then

		exports.tmtaNotification:showInfobox(
			client,
			"info", 
			"Внимание!", 
			"У вас недостаточно средств", 
			_, 
			{240, 146, 115}
		)

		return
	end 

	for k,v in pairs(data) do
		setElementData(veh,k,v)
	end

	exports.tmtaMoney:takePlayerMoney(client, tonumber(price))

    exports.tmtaNotification:showInfobox(
        client, 
        "info", 
        "#FFA07AТюнинг ателье", 
        "Вы установили диски за #FFA07A"..convertNumber(price).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )

	
	triggerClientEvent(client,"initWheelsWindow",client,true)
end
addEvent("applyWheelsData",true)
addEventHandler("applyWheelsData",root,applyWheelsData)
