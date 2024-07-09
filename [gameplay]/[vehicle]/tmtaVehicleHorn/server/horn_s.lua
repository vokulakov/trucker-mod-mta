addEvent('operTuningGarage.hornBreakModelChange', true)
addEventHandler('operTuningGarage.hornBreakModelChange', root, function(model)
	if not source then 
		return 
	end
	outputDebugString('\nWarning! Извини, но это костыль.', 0, 170, 160, 0)
	setElementModel(source, model)
end)


addEvent('tmtaVehicleHorn.onPlayerBuyHorn', true)
addEventHandler('tmtaVehicleHorn.onPlayerBuyHorn', root,
	function(price)
		exports.tmtaMoney:takePlayerMoney(source, tonumber(price))
		exports.tmtaNotification:showInfobox(
			source, 
			"info", 
			"#FFA07AТюнинг ателье", 
			"Вы установили звуковой сигнал за #FFA07A"..exports.tmtaUtils:formatMoney(tonumber(price)).." #FFFFFF₽", 
			_, 
			{240, 146, 115}
		)
	end
)