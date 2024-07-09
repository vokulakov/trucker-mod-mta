function spawnVehicle(...)
	return Vehicle.spawn(...)
end

function spawnPlayerVehicle(...)
	return Vehicle.spawnById(...)
end

function destroyVehicle(vehicleId)
	if (not vehicleId or type(vehicleId) ~= 'number') then
		return false
	end
	return Vehicle.destroyById(vehicleId)
end

--- Получить список транспорта игрока
function getPlayerVehicles(player)
	if (not isElement(player)) then
        outputDebugString("getPlayerVehicles: bad arguments", 1)
        return false
    end

	return --UserVehicle.getUserVehicles()
end

--- Получить список транспорта (асинхронно)
function getPlayerVehiclesAsync(player, callbackEventName, ...)
	if not isElement(player) then
		return false
	end

	return UserVehicle.getUserVehicles(player:getData('userId'), callbackEventName, ...)
end

--- Добавить транспорт игроку
function addPlayerVehicle(player, model, fields)
	if not isElement(player) then
		return false
	end

	local result = UserVehicle.add(player:getData('userId'), model, fields)
	local success = not not result

	if (success) then
		exports.tmtaVehicleLicensePlate:setVehicleRandomLicensePlate(result[1].userVehicleId, 'ru_tr')
		updatePlayerVehiclesCount(player)
	end

	return success
end

--- Удалить транспорт игрока
function deletePlayerVehicle(player, vehicleId)
	if (not isElement(player) or not vehicleId or type(vehicleId) ~= 'number') then
		return false
	end

	destroyVehicle(vehicleId)
	local success = UserVehicle.remove(vehicleId)
	success = not not success
	if (success) then
		exports.tmtaVehicleLicensePlate:deleteLicensePlateByVehicleId(vehicleId)
		updatePlayerVehiclesCount(player)
	end

	return success
end

function updatePlayerVehiclesCount(player)
	if not isElement(player) then
		return false
	end

	local result = UserVehicle.getUserVehiclesIds(player:getData('userId'))
	if type(result) ~= "table" then
		return false
	end

	player:setData('garage_cars_count', #result)

	return true
end

function updateVehicleTuning(...)
	return VehicleTuning.updateVehicleTuning(...)
end

--- Запись id номерного знака в таблицу
function setVehicleNumberPlate(vehicleId, licensePlateId)
	if (not vehicleId or type(vehicleId) ~= 'number' or not licensePlateId or type(licensePlateId) ~= 'number') then
		return false
	end
	return UserVehicle.update(vehicleId, {licensePlateId = licensePlateId})
end

--- Вернуть весь транспорт игрока в гараж
function returnPlayerVehiclesToGarage(player)
	if not isElement(player) then
		return false
	end
	return Vehicle.destroyPlayerVehicles(player)
end

--- Сбросить handling
function resetVehicleHandling(vehicle)
	return Vehicle.resetHandling(vehicle)
end