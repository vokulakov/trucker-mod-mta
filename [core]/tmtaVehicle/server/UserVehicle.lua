UserVehicle = {}

USER_VEHICLE_TABLE_NAME = 'userVehicle'

USER_VEHICLE_IS_NOT_OWNER = 0
USER_VEHICLE_IS_OWNER = 1

function UserVehicle.setup()
    exports.tmtaSQLite:dbTableCreate(USER_VEHICLE_TABLE_NAME, {
        {name = "userId", type = "INTEGER", options = "NOT NULL"},
        {name = "vehicleId", type = "INTEGER", options = "NOT NULL"},
        {name = "isOwner", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        {name = "ownedStartDate", type = "INTEGER", options = "DEFAULT 0"},
        {name = "ownedEndDate", type = "INTEGER", options = "DEFAULT 0"},
    },
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (vehicleId)\n\tREFERENCES vehicle (vehicleId)\n\tON DELETE SET NULL")
end

function UserVehicle.add(userId, vehicleId, isOwner, callbackFunctionName, ...)
    if 	(type(userId) ~= "number" or type(vehicleId) ~= "number" or type(isOwner) ~= 'number') then
		executeCallback(callbackFunctionName, false)
		outputDebugString("UserVehicle.add: bad arguments", 1)
		return false
	end

    return exports.tmtaSQLite:dbTableInsert(USER_VEHICLE_TABLE_NAME, { 
        userId = userId,
        vehicleId = vehicleId,
        isOwner = isOwner,
     }, callbackFunctionName, ...)
end

function UserVehicle.getUserVehicles(userId, callbackFunctionName, ...)
    if 	(type(userId) ~= "number") then
		outputDebugString("UserVehicle.getUserVehicles: bad arguments", 1)
        return false
    end
end

function UserVehicles.updateVehicle(vehicleId, fields, callbackFunctionName, ...)
	if (type(vehicleId) ~= "number" or type(fields) ~= "table") then
		executeCallback(callbackFunctionName, false)
        outputDebugString("UserVehicles.updateVehicle: bad arguments", 1)
		return false
	end

    local success = exports.tmtaSQLite:dbTableUpdate(USER_VEHICLE_TABLE_NAME, fields, {vehicleId = vehicleId}, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

	return success
end

function UserVehicle.addPlayerNewVehicle(player, model, callbackFunctionName, ...)
    if (not isElement(player) or type(model) ~= 'number') then
        return false
    end

    local result = Vehicle.add(tonumber(model), VEHICLE_TYPE_PRIVATE)
    if not result then
        executeCallback(callbackFunctionName, false)
        return false
    end

    local vehicleId = result[1]
    local success = UserVehicle.add(player:getData("userId"), tonumber(vehicleId), USER_VEHICLE_IS_OWNER, callbackFunctionName, ...)
    if not success then
		executeCallback(callbackFunctionName, false)
	end

	return success
end

function dbAddNewUserVehicle(result, params)
    if not params or not isElement(params.player) then
        return
    end

    local player = params.player
	local success = not not result

    if success then
        --TODO:
    end
end