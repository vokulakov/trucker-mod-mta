addEventHandler('onClientPlayerDamage', root, 
	function()
		if localPlayer:getData("inGreenZone") then 
			cancelEvent()
		end
	end
)

addEventHandler("onClientPlayerWasted", localPlayer, 
	function()
		if localPlayer:getData("inGreenZone") then 
			cancelEvent()
		end
	end
)