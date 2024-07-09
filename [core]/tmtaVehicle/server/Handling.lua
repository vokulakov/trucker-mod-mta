Handling = {}

--- Установить handling по умолчанию
function Handling.setVehicleDefault(vehicle)
	if not isElement(vehicle) then
		return false
	end

	local vehicleName = getVehicleNameFromModel(vehicle.model)
	if not vehicleName then
		return false
	end

	local handlingConfig = getVehicleHandlingConfig(vehicleName)
	if (not handlingConfig or type(handlingConfig) ~= 'table') then
		return false
	end

	for k, v in pairs(handlingConfig) do
		setVehicleHandling(vehicle, k, v, false)
	end

	updateVehicleSuspension(vehicle)

	return true
end