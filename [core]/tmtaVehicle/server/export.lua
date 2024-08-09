function addPlayerVehicle(player, model, fields)
	if (not isElement(player) or type(model) ~= 'string') then
		return false
	end

	return UserVehicle.addPlayerVehicle(player, model, fields)
end

function updatePlayerVehiclesCount(player)
end