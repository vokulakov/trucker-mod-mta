function spawnVehicle(...)
end

function addPlayerVehicle(player, model)
	if not isElement(player) then
		return false
	end

	local result = UserVehicle.add(player:getData("userId"), model)
	return result
end