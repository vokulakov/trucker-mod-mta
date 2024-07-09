function setVehicleDefaultToner(vehicle)
    if not isElement(vehicle) then
        return
    end

    vehicle:setData('Tinting', 
	    {
	    	['zad_steklo'] = {type = 'color', r = 10, g = 10, b = 10, a = 255},
	    	['pered_steklo'] = {type = 'color', r = 10, g = 10, b = 10, a = 255},
	    	['lob_steklo'] = {type = 'color', r = 10, g = 10, b = 10, a = 255}
	    }
    ) 

end

addEvent("tmtaVehToner.setVehicleToner", true)
addEventHandler("tmtaVehToner.setVehicleToner", root, function(vehicle, price, colorZ, colorP, colorL)
    local player = client 
    if not isElement(player) or not isElement(vehicle) then 
        return 
    end 

    if exports.tmtaMoney:getPlayerMoney(player) < price then

		exports.tmtaNotification:showInfobox(
			player,
			"info", 
			"Внимание!", 
			"У вас недостаточно средств", 
			_, 
			{240, 146, 115}
		)

		return
	end 

    local toner = vehicle:getData('Tinting') or {}

    if colorZ then
        toner['zad_steklo'] = {type = 'color', r = colorZ.r, g = colorZ.g, b = colorZ.b, a = colorZ.a}
    end

    if colorP then
        toner['pered_steklo'] = {type = 'color', r = colorP.r, g = colorP.g, b = colorP.b, a = colorP.a}
    end

    if colorL then
        toner['lob_steklo'] = {type = 'color', r = colorL.r, g = colorL.g, b = colorL.b, a = colorL.a}
    end

    vehicle:setData('Tinting', toner)

    exports.tmtaMoney:takePlayerMoney(player, tonumber(price))
    
    exports.tmtaNotification:showInfobox(
        player, 
        "info", 
        "#FFA07AТюнинг ателье", 
        "Вы установили тонировку за #FFA07A"..convertNumber(price).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )
end)