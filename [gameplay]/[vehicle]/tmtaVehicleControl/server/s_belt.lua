----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [НАЧАЛО] --
----------------------------------
local function attachBelt(player)
	local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return end
    local seat = getPedOccupiedVehicleSeat(player) + 1
	local data = getElementData(vehicle, "seat:"..seat)
	
	if data == true then
		--outputChatBox("Вы отстегнули ремень!", player, 0, 255, 0)
		--triggerClientEvent(player, 'exv_notify.addNotification', player, 'Вы отстегнули ремень безопасности', 1)
		triggerClientEvent(player, 'belt_system.doToggleBelt', player, 'veh_belt_out')
		setElementData(player, "belt_system:isPlayerOnBelt", false)
		setElementData(player, "belt_system:isPlayerSeat", nil)
	elseif data == false then
		--outputChatBox("Вы пристегнули ремень!", player, 0, 255, 0)
		--triggerClientEvent(player, 'exv_notify.addNotification', player, 'Вы пристегнули ремень безопасно\nсти', 1)
		triggerClientEvent(player, 'belt_system.doToggleBelt', player, 'veh_belt_in')
		setElementData(player, "belt_system:isPlayerOnBelt", true)
		setElementData(player, "belt_system:isPlayerSeat", seat)
	end

	setElementData(vehicle, "seat:"..seat, not data)
end

addEventHandler("onPlayerVehicleEnter", root, function(veh, seat)
	if not isVehicleHaveBelt(getElementModel(veh)) then
		
		if getElementType(source) == 'ped' then
			return 
		end
		
		if getElementData(source, 'belt_system:isPlayerOnBelt') then
			local seat = getElementData(source, 'belt_system:isPlayerSeat')
			setElementData(veh, "seat:"..seat, false)
			
			setElementData(source, "belt_system:isPlayerOnBelt", false)

			setElementData(source, "belt_system:isPlayerSeat", nil)
			unbindKey(source, "b", "down", attachBelt)
		else
			unbindKey(source, "b", "down", attachBelt)
		end
		
		bindKey(source, "b", "down", attachBelt)

		--triggerClientEvent(source, 'exv_notify.addNotification', source, "Что бы пристегнуться, нажмите 'B'", 1)
	end
end)

addEventHandler("onPlayerVehicleExit", root, function(veh, seat)
	if not isVehicleHaveBelt(getElementModel(veh)) then
		local seat = seat + 1
        setElementData(veh, "seat:"..seat, false)
		setElementData(source, "belt_system:isPlayerOnBelt", false)
		setElementData(source, "belt_system:isPlayerSeat", nil)
        unbindKey(source, "b", "down", attachBelt)
	end
end)

addEventHandler("onPlayerWasted", root, function()
	setElementData(source, "belt_system:isPlayerOnBelt", false)
	setElementData(source, "belt_system:isPlayerSeat", nil)
	unbindKey(source, "b", "down", attachBelt)
	triggerClientEvent(source, 'belt_system:stopSound', source, false)
end)

addEventHandler("onVehicleStartExit", root, function(player, seat)
	if getElementData(source, "seat:"..seat + 1) then

        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AВнимание!", 
            "Отстегните ремень безопасности #FFA07A(нажмите '#FFFFFFB#FFA07A')",  
            {240, 146, 115}
        )

		--triggerClientEvent(player, 'exv_notify.addNotification', player, "Отстегните ремень безопасности!\n(нажмите 'B')", 2)
		cancelEvent()
		return
	else
		triggerClientEvent(player, 'belt_system:stopSound', player, false)
	end

	if isVehicleLocked(source) then 
		--triggerClientEvent(player, 'exv_notify.addNotification', player, "Откройте двери! (нажмите 'K')", 2)
		cancelEvent() 
		return
	end -- если двери заблокированы, то игрок не сможет выйти!
end)

addEventHandler("onVehicleStartEnter", root, function(player, seat, jacked)
	if getElementData(source, "seat:"..seat + 1) then
		if isElement(jacked) and getPedOccupiedVehicleSeat(jacked) == seat then 
			cancelEvent() 
			return
		end
		setElementData(source, "seat:"..seat + 1,  false)
	end
end)

addEventHandler("onElementDestroy", root, function()
 	if getElementType(source) == "vehicle" then
 		local vehicleOccupants = getVehicleOccupants(source)
 		if not vehicleOccupants then return end
		for seat, player in pairs (vehicleOccupants) do
			if player and getElementType(player) == 'player' then
		   	 	local seat = seat + 1
				if getElementData(source, "seat:"..seat) then
			    	setElementData(source, "seat:"..seat, false)
					setElementData(source, "belt_system:isPlayerOnBelt", false)
					setElementData(source, "belt_system:isPlayerSeat", nil)
			    	unbindKey(player, "b", "down", attachBelt)
			    else
					setElementData(player, "belt_system:isPlayerOnBelt", false)
					setElementData(player, "belt_system:isPlayerSeat", nil)
			    	triggerClientEvent(player, 'belt_system:stopSound', player, false)
			    	unbindKey(player, "b", "down", attachBelt)
				end
			end
		end
  	end
end)

addEvent('belt_system.onVehicleDamage', true)
addEventHandler('belt_system.onVehicleDamage', root, function(player, loss)
	if not player then return end
	setElementHealth(player, getElementHealth(player) - loss)
end)
----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [КОНЕЦ] ---
----------------------------------