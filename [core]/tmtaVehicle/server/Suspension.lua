local MIN_SUSPENSION_DEFAULT = 0.04
local MAX_SUSPENSION_DEFAULT = 0.21

local overrideSuspension = {
	vaz_2110 = {0.02, 0.2},
}

function updateVehicleSuspension(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Suspension")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).suspensionLowerLimit
	else
		local minSuspension = MIN_SUSPENSION_DEFAULT
		local maxSuspension = MAX_SUSPENSION_DEFAULT
		local vehicleName = getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideSuspension[vehicleName] then
			minSuspension = overrideSuspension[vehicleName][1]
			maxSuspension = overrideSuspension[vehicleName][2]
		end
		value = -minSuspension - value * (maxSuspension - minSuspension)
	end
	setVehicleHandling(vehicle, "suspensionLowerLimit", value)
end

addEventHandler("onElementDataChange", root, 
	function(dataName)
		if source.type ~= "vehicle" then
			return
		end
		if dataName == "Suspension" then
			updateVehicleSuspension(source)
		end
	end
)