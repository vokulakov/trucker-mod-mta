local Vehicles = { }

addEventHandler("onClientPedsProcessed", root, function()
	for vehicle, wheelsRotation in pairs(Vehicles) do
		if not isElement(vehicle) then
			Vehicles[vehicle] = nil
			return 
		end
		if not wheelsRotation[1] then
			return
		end
		setVehicleComponentRotation(vehicle, 'wheel_rf_dummy', wheelsRotation[1], wheelsRotation[2], wheelsRotation[3])
		setVehicleComponentRotation(vehicle, 'wheel_lf_dummy', wheelsRotation[4], wheelsRotation[5], wheelsRotation[6])
	end
 end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if seat ~= 0 then 
		return 
	end
	local vehicle = source
	local r_wrx, r_wry, r_wrz = getVehicleComponentRotation(vehicle, 'wheel_rf_dummy')
	local l_wrx, l_wry, l_wrz = getVehicleComponentRotation(vehicle, 'wheel_lf_dummy')
	local wheelsRotation = {r_wrx, r_wry, r_wrz, l_wrx, l_wry, l_wrz}
	vehicle:setData('wheelsRotation', wheelsRotation)
	Vehicles[vehicle] = wheelsRotation
end)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if seat ~= 0 then 
		return 
	end
	local vehicle = source
	vehicle:setData('wheelsRotation', false)
	Vehicles[vehicle] = nil
end)

addEventHandler("onClientElementDestroy", root, function ()
	if getElementType(source) ~= "vehicle" then
		return
	end
	local vehicle = source
	local wheelsRotation = vehicle:getData('wheelsRotation')
	if type(wheelsRotation) ~= 'table' or not Vehicles[vehicle] then
		return
	end
	Vehicles[vehicle] = nil
end)

-- Вносим в обработчик авто, попавшие в стрим
addEventHandler('onClientElementStreamIn', root, function()
	if getElementType(source) ~= 'vehicle' then
		return
	end
	local vehicle = source
	local wheelsRotation = vehicle:getData('wheelsRotation')
	if type(wheelsRotation) ~= 'table' then
		return
	end
	Vehicles[vehicle] = {
		wheelsRotation[1], wheelsRotation[2], wheelsRotation[3], 
		wheelsRotation[4], wheelsRotation[5], wheelsRotation[6]
	}
end)

-- Убираем из обработчика авто, вышедшие из стрима
addEventHandler('onClientElementStreamOut', root, function()
	if getElementType(source) ~= 'vehicle' then
		return
	end
	local vehicle = source
	local wheelsRotation = vehicle:getData('wheelsRotation')
	if type(wheelsRotation) ~= 'table' or not Vehicles[vehicle] then
		return
	end
	Vehicles[vehicle] = nil
end)

-- Вносим в обработчик авто из стрима при вклчении
addEventHandler('onClientResourceStart', resourceRoot, function()
	for key, vehicle in pairs(getElementsByType('vehicle', root, true)) do
		local wheelsRotation = vehicle:getData('wheelsRotation')
		if type(wheelsRotation) == 'table' then
			Vehicles[vehicle] = {
				wheelsRotation[1], wheelsRotation[2], wheelsRotation[3], 
				wheelsRotation[4], wheelsRotation[5], wheelsRotation[6]
			}
		end
	end
end)