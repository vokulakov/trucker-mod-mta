function addPlayerVehicle(player, model)
	if (not isElement(player) or type(model) ~= 'string') then
		return false
	end

	local result = UserVehicle.addPlayerVehicle(player)
	return result
end