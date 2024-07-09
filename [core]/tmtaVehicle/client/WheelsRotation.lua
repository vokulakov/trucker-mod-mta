local Vehicles = {}

local defaultWheelDummy = { 'wheel_rf_dummy', 'wheel_lf_dummy' }
local overriddenVehicle = {}

addEventHandler('onClientPedsProcessed', root, 
	function()
		for vehicle, wheelsRotation in pairs(Vehicles) do
			if not isElement(vehicle) then
				Vehicles[vehicle] = nil
				return 
			end

			for wheelDummy, wheelRotation in pairs(wheelsRotation) do
				if (wheelRotation[1]) then
					setVehicleComponentRotation(vehicle, wheelDummy, wheelRotation[1], wheelRotation[2], wheelRotation[3])
				end
			end
		end
	end
)

addEventHandler('onClientVehicleStartExit', root, 
	function(player, seat)
		if seat ~= 0 then 
			return 
		end

		local vehicle = source
		local wheelsRotation = {}

		local wheelDummy = (overriddenVehicle[vehicle.model]) and overriddenVehicle[vehicle.model] or defaultWheelDummy

		for _, dummy in pairs(wheelDummy) do
			local rx, ry, rz = getVehicleComponentRotation(vehicle, dummy)
			wheelsRotation[dummy] = {rx, ry, rz}
		end

		vehicle:setData('wheelsRotation', wheelsRotation)
		Vehicles[vehicle] = wheelsRotation
	end
)

addEventHandler('onClientVehicleEnter', root, 
	function(player, seat)
		if seat ~= 0 then 
			return 
		end
		local vehicle = source
		vehicle:setData('wheelsRotation', false)
		Vehicles[vehicle] = nil
	end
)

addEventHandler('onClientElementDestroy', root, 
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		local vehicle = source
		local wheelsRotation = vehicle:getData('wheelsRotation')
		if type(wheelsRotation) ~= 'table' or not Vehicles[vehicle] then
			return
		end
		Vehicles[vehicle] = nil
	end
)

addEventHandler('onClientElementStreamIn', root, 
	function()
		if getElementType(source) ~= 'vehicle' then
			return
		end
		local vehicle = source
		local wheelsRotation = vehicle:getData('wheelsRotation')
		if type(wheelsRotation) ~= 'table' then
			return
		end
		Vehicles[vehicle] = wheelsRotation
	end
)

addEventHandler('onClientElementStreamOut', root, 
	function()
		if getElementType(source) ~= 'vehicle' then
			return
		end
		local vehicle = source
		local wheelsRotation = vehicle:getData('wheelsRotation')
		if type(wheelsRotation) ~= 'table' or not Vehicles[vehicle] then
			return
		end
		Vehicles[vehicle] = nil
	end
)

addEventHandler('onClientResourceStart', resourceRoot, 
	function()
		for key, vehicle in pairs(getElementsByType('vehicle', root, true)) do
			local wheelsRotation = vehicle:getData('wheelsRotation')
			if type(wheelsRotation) == 'table' then
				Vehicles[vehicle] = wheelsRotation
			end
		end
	end
)