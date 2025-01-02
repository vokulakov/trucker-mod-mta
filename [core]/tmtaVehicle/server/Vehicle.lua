Vehicle = {}

local _createdVehicle = {}

-- Время, через которое удаляется взорвавшийся автомобиль
local EXPLODED_VEHICLE_DESTROY_TIMEOUT = 5000

-- Автомобили, заспавненные игроком
-- ключ - userId владельца (string)
local userSpawnedVehicles = {}

-- data, находящаяся в автомобиле
local dataFields = {
	'userVehicleId', 'vin', 'userId', 'mileage', 'tuning', 'stickers',
	'health', 'fuel', 'colors', 'handling',

	'numberPlateType', 'numberPlate',
}

local autosaveFields = {
	'mileage',
	'health',
	'fuel',
	'colors',
}

-- Поля, которые можно менять на клиенте
local allowedFields = {
	mileage = true,
}

local _spawnVehicle = spawnVehicle
local function spawnVehicle(...)
	local vehicle = createVehicle(...)
	vehicle:setColor(255, 255, 255)
	setVehicleOverrideLights(vehicle, 1)
	setVehicleEngineState(vehicle, false)

	if vehicle.vehicleType == 'Bike' then 
		vehicle.velocity = Vector3(0, 0, -0.01) 
	end

	local x, y, z = getElementPosition(vehicle)
	local colSphere = createColSphere(x, y, z, 5.0) 
	attachElements(colSphere, vehicle, 0, 0, 0)
	
	vehicle:setData('vehicle.actionColsphere', colSphere)
	Handling.setVehicleDefault(vehicle)

	_createdVehicle[vehicle] = trues

	return vehicle
end

local function saveVehicle(vehicle, saveTuning)
	if not isElement(vehicle) then
		return false
	end

	local vehicleId = vehicle:getData('userVehicleId')
	if not vehicleId then
		return false
	end

	-- Сохранение даты
	local fields = {}
	for i, name in ipairs(autosaveFields) do
		fields[name] = vehicle:getData(name)
	end

	-- Сохранение тюнинга
	if saveTuning then
		fields['tuning'] = VehicleTuning.prepareToSave(vehicle)
	end

	-- Handlings
	local handlings = getVehicleHandling(vehicle)
	fields['handling'] = toJSON(handlings)

	UserVehicle.update(vehicleId, fields)

	return true
end

local function getUserSpawnedVehiclesTable(userId)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	return userSpawnedVehicles[userId]
end

local function addUserSpawnedVehicle(userId, vehicle)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	if not userSpawnedVehicles[userId] then
		userSpawnedVehicles[userId] = {}
	end
	userSpawnedVehicles[userId][vehicle] = true
end

local function removeUserSpawnedVehicle(userId, vehicle)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	if not userSpawnedVehicles[userId] then
		userSpawnedVehicles[userId] = {}
	end
	userSpawnedVehicles[userId][vehicle] = nil
end

function Vehicle.spawn(model, position, rotation)
    if (not (type(model) == 'string' or type(model) == 'number') or type(position) ~= 'userdata') then
		outputDebugString('Vehicle.spawn: bad arguments', 1)
		return false
	end

	if not rotation then rotation = Vector3() end

	local model = (type(model) ~= 'number') and getVehicleModelFromName(model) or model
	if not isValidVehicleModel(model) then
		return false
	end

	local vehicle = spawnVehicle(model, position, rotation)

	triggerEvent('onVehicleCreated', vehicle)
	triggerClientEvent(root, 'onClientVehicleCreated', vehicle)

	return vehicle
end

function Vehicle.destroy(vehicle)
	if not isElement(vehicle) then
		return false
	end

	local playerId = vehicle:getData("userId")
	if playerId then
		if (type(getUserSpawnedVehiclesTable(playerId)) ~= "table") then
			return false
		end
		removeUserSpawnedVehicle(playerId, vehicle)
	end

	local colsphere = vehicle:getData('vehicle.actionColsphere')
	if isElement(colsphere) then
		destroyElement(colsphere)
	end

	saveVehicle(vehicle, true)
	
	for dataName in pairs(getAllElementData(vehicle)) do
		vehicle:removeData(dataName)
    end

	for _, attachedElement in pairs(getAttachedElements(vehicle)) do
		if isElement(attachedElement) then
			destroyElement(attachedElement)
		end
	end
	
	_createdVehicle[vehicle] = nil

	return destroyElement(vehicle)
end

function Vehicle.destroyById(vehicleId)
    if (type(vehicleId) ~= "number") then
		outputDebugString('Vehicle.destroyById: bad arguments', 1)
		return false
	end

	local vehicle = getElementByID(string.format("vehicle_%d", vehicleId))
	if not isElement(vehicle) then
		return false
	end

	return Vehicle.destroy(vehicle)
end

-- Возвращает массив автомобилей, принадлежащих пользователю с userId
function Vehicle.getUserSpawnedVehicles(userId)
	if not userId then
		return false
	end
	if not getUserSpawnedVehiclesTable(userId) then
		return {}
	end
	local spawnedVehicles = {}
	for vehicle in pairs(getUserSpawnedVehiclesTable(userId)) do
		table.insert(spawnedVehicles, vehicle)
	end
	return spawnedVehicles
end

-- Возвращает массив автомобилей, заспавненных игроком
function Vehicle.getPlayerSpawnedVehicles(player)
	if not isElement(player) then
		return false
	end
	return Vehicle.getUserSpawnedVehicles(player:getData('userId'))
end

-- Спавн транспорта по vehicleId
function Vehicle.spawnById(vehicleId, position, rotation)
    if (type(vehicleId) ~= "number" or type(position) ~= 'userdata') then
		outputDebugString('Vehicle.spawnById: bad arguments', 1)
		return false
	end
	if not rotation then rotation = Vector3() end

	local _id = "vehicle_" .. tostring(vehicleId)

	local vehicle = getElementByID(_id)
	if isElement(vehicle) then
		vehicle.position = position
		vehicle.rotation = rotation
		return false
	end

	local vehicleInfo = UserVehicle.get(vehicleId)
	if (type(vehicleInfo) ~= "table" or #vehicleInfo == 0) then
		outputDebugString("Vehicle.spawn: Vehicle does not exist")
		return false
	end
	vehicleInfo = vehicleInfo[1]

	if (not vehicleInfo.userId) then
		outputDebugString("Vehicle.spawn: Bad vehicle info (no userId)")
		return false
	end
	
	local player = exports.tmtaCore:getPlayerByUserId(vehicleInfo.userId)
	if (not isElement(player)) then
		outputDebugString("Vehicle.spawn: Player not found (userId: ".. tostring(vehicleInfo.userId) ..")")
		return false
	end

	local vehicle = spawnVehicle(vehicleInfo.model, position, rotation)

	VehicleTuning.applyToVehicle(vehicle, vehicleInfo.tuning)

	-- Покраска
	local BodyColor = vehicle:getData('BodyColor')
	local BodyColorAdditional = vehicle:getData('BodyColorAdditional')
	setVehicleColor(
		vehicle, 
		BodyColor[1] or 255, BodyColor[2] or 255, BodyColor[3] or 255, 
		BodyColorAdditional[4] or 255, BodyColorAdditional[5] or 255, BodyColorAdditional[6] or 255
	)

	for _, name in ipairs(dataFields) do
		vehicle:setData(name, vehicleInfo[name])
	end
	vehicle.id = _id
	vehicle:setData('owner', player)

	-- Handlings
	if (vehicleInfo['handling']) then
		local handlings = fromJSON(vehicleInfo['handling'])
		for key, value in pairs(handlings or {}) do
			setVehicleHandling(vehicle, key, value)
		end
	end

	addUserSpawnedVehicle(vehicleInfo.userId, vehicle)

	triggerEvent('onVehicleCreated', vehicle)
	triggerClientEvent(root, 'onClientVehicleCreated', vehicle)

	return vehicle
end

function Vehicle.destroyPlayerVehicles(player)
	if not isElement(player) then
		return false
	end

	local vehicles = Vehicle.getPlayerSpawnedVehicles(player)
	local vehicleCount = 0
	if type(vehicles) == "table" then
		for i, vehicle in ipairs(vehicles) do
			if Vehicle.destroy(vehicle) then
				vehicleCount = vehicleCount + 1
			end
		end
	end

	return (vehicleCount > 0)
end

function Vehicle.resetHandling(vehicle)
	if (not isElement(vehicle) or not _createdVehicle[vehicle]) then
		return false
	end

	return Handling.setVehicleDefault(vehicle)
end

-- Защита даты
--TODO: пока не нужный функционал
addEventHandler('onElementDataChange', root, 
	function(dataName, oldValue)
		if not client then
			return
		end
		if source.type == "vehicle" then
			--[[
			if not allowedFields[dataName] then
				source:setData(dataName, oldValue)
			end
			]]
		end
	end
)

addEventHandler('onVehicleExplode', root, 
	function()
		local vehicle = source
		setTimer(function ()
			if isElement(vehicle) then
				Vehicle.destroy(vehicle)
			end
		end, EXPLODED_VEHICLE_DESTROY_TIMEOUT, 1)
	end, true, 'low-10')

addEventHandler('onElementDestroy', root,
	function()
		if (not _createdVehicle[source] or source.type ~= 'vehicle') then
			return cancelEvent()
		end
		Vehicle.destroy(source)
	end, true, 'low-10')