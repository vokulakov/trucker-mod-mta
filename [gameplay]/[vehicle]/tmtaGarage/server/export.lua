function isPlayerHasFreeGarageSlot(player)
    if not isElement(player) then
        return false
    end
    return (getPlayerFreeGarageSlotCount(player) > 0)
end

function addPlayerGarageSlot(player, amount)
    return Garage.addPlayerSlot(player, amount)
end

function removePlayerGarageSlot(player, amount)
    return Garage.removePlayerSlot(player, amount)
end

--- Добавить пользователю парковочные места
-- @tparam number userId
-- @tparam number amount
-- @treturn bool
function addUserGarageSlot(userId, amount)
    if (type(userId) ~= 'number' or type(amount) ~= 'number') then
        return false
    end
	amount = math.ceil(math.abs(amount))

	local userData = exports.tmtaCore:getUserDataById(userId, {'garageSlot'})
	local userGarageSlot = tonumber(userData.garageSlot)

	return exports.tmtaCore:updateUserDataById(userId, {garageSlot = tonumber(userGarageSlot + amount)})
end

--- Забрать у пользователя парковочные места
-- @tparam number userId
-- @tparam number amount
-- @treturn bool
function removeUserGarageSlot(userId, amount)
    if (type(userId) ~= 'number' or type(amount) ~= 'number') then
        return false
    end
	amount = math.ceil(math.abs(amount))

	local userData = exports.tmtaCore:getUserDataById(userId, {'garageSlot'})
	local userGarageSlot = tonumber(userData.garageSlot)
	local currentGarageSlotCount = tonumber(userGarageSlot - amount)
	if (currentGarageSlotCount < 0) then
		currentGarageSlotCount = 0
	end

	return exports.tmtaCore:updateUserDataById(userId, {garageSlot = currentGarageSlotCount})
end