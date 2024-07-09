addEvent("takeMoneyPly", true)
addEventHandler("takeMoneyPly", root, function(money, vehicle)
    local vehicleId = vehicle:getData('userVehicleId')
    if not vehicleId then 
        return
    end

	exports.tmtaMoney:takePlayerMoney(source, tonumber(money))
    exports.tmtaNotification:showInfobox(
        source, 
        "info", 
        "#FFA07AТюнинг ателье", 
        "Вы приобрели деталь за #FFA07A"..exports.tmtaUtils:formatMoney(tonumber(money)).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )
end)