addEvent("arst_carXenon.setXenonVehicle", true)
addEventHandler("arst_carXenon.setXenonVehicle", root, function(r, g, b, money)
	local vehicle = source.vehicle
	if not vehicle then 
		return 
	end
	
	setVehicleHeadLightColor(vehicle, r, g, b)

	setElementData(vehicle, 'HeadLightColor', {r, g, b})
	setElementData(vehicle, 'vehicle.vehLightState', 0)
	setVehicleOverrideLights(vehicle, 1)
	
	--outputChatBox("#1E90FF[Ксенон] #00FF00Вы установили ксеноновые фары за "..money.." ₽", source, 255, 255, 255, true)
	exports.tmtaNotification:showInfobox(
        source, 
        "info", 
        "#FFA07AТюнинг ателье", 
        "Вы установили ксеноновые фары #FFA07A"..convertNumber(money).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )

	exports.tmtaMoney:takePlayerMoney(source, money)
end)