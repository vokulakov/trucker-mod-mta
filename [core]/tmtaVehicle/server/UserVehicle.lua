UserVehicle = {}

USER_VEHICLE_TABLE_NAME = 'userVehicle'

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

function UserVehicle.add(userId, vehicleId, callbackFunctionName, ...)
    if 	(type(userId) ~= "number" or type(vehicleId) ~= "number") then
		executeCallback(callbackFunctionName, false)
		outputDebugString("UserVehicle.add: bad arguments", 1)
		return false
	end


    --TODO: обращение к бд
end

function UserVehicle.getUserVehicles(userId, callbackFunctionName, ...)
    if 	(type(userId) ~= "number") then
		outputDebugString("UserVehicle.getUserVehicles: bad arguments", 1)
        return false
    end
end

function UserVehicle.addPlayerVehicle(player, model)
end