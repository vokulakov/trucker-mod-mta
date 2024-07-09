local function repairPlayerVehicle(vehicle)
	if not vehicle then return end

	local veh_hp = math.floor((((getElementHealth(vehicle)-250)/10)*100)/75)
	local veh_price = math.ceil((100-veh_hp)*Config.price)
	
	if veh_hp == 100 then
		veh_price = Config.price_no_hp
	end
	
    local player = source

	if tonumber(exports.tmtaMoney:getPlayerMoney(player)) >= veh_price then

        playSoundFrontEnd(player, 46)
        fixVehicle(vehicle)

        exports.tmtaMoney:takePlayerMoney(player, veh_price)

        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосервис", 
            "Ваш транспорт отремонтирован за #FFA07A"..veh_price.." #FFFFFF₽", 
            _, 
            {240, 146, 115}
        )

        setVehicleDamageProof(vehicle, true)
	else
        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосервис", 
            "У вас нехватает денежных средств для ремонта", 
            _, 
            {240, 146, 115}
        )
	end

end
addEvent('repairPlayerVehicle', true)
addEventHandler('repairPlayerVehicle', root, repairPlayerVehicle)

local createdMarker = {}

addEventHandler('onResourceStart', resourceRoot, function()
	for _, sto in pairs(Config.sto_locations) do

        local fakeMarker = createMarker(sto.blip.x, sto.blip.y, sto.blip.z, "cylinder", 1, 0, 0, 0, 0)
		exports.tmtaBlip:createBlipAttachedTo(
            fakeMarker, 
            'blipSto',
            { name = 'СТО'},
            tocolor(46, 133, 255, 255)
        )

        for _, marker in pairs(sto.markers) do
            local point = createMarker(marker.x, marker.y, marker.z, "cylinder", 2.5, 0, 125, 150, 50)
            local arrow = createPickup(marker.x, marker.y, marker.z + 1.2, 3, 1318, 1)
            setElementData(arrow, 'posinka.isArrow', true)
            createdMarker[point] = true
        end

	end
end)

addEventHandler("onMarkerHit", resourceRoot, 
    function(player)
        local vehicle = player.vehicle
        if (not createdMarker[source] or player.type ~= 'player' or not vehicle or vehicle.controller ~= player) then
            return
        end 

        local verticalDistance = player.position.z - source.position.z
        if (verticalDistance > 5 or verticalDistance < -1) then
            return
        end

        setVehicleDamageProof(vehicle, false)
        setElementVelocity(vehicle, 0, 0, 0)

        local hp = math.floor((((getElementHealth(vehicle)-250)/10)*100)/75)
        if hp < 100 then
            local veh_hp = 100 - hp
            local veh_price = veh_hp*Config.price
            triggerClientEvent(player, 'createRepairWindow', player, veh_hp, veh_price)
        else
            triggerClientEvent(player, 'createRepairWindow', player, 1, Config.price_no_hp)
        end
    end
)