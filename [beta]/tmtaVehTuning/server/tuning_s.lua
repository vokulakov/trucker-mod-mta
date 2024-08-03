addEvent("takeMoneyPly", true)
addEventHandler("takeMoneyPly", getRootElement(), function(money, veh)

	exports.tmtaMoney:takePlayerMoney(source, tonumber(money))

    exports.tmtaNotification:showInfobox(
        source, 
        "info", 
        "#FFA07AТюнинг ателье", 
        "Вы приобрели деталь за #FFA07A"..convertNumber(money).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )

end)

function convertNumber(number)
	local formatted = number

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
		if ( k==0 ) then
			break
		end
	end

	return formatted
end