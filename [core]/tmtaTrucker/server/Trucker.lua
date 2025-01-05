Trucker = {}

TRUCKER_TABLE_NAME = 'trucker'

function Trucker.setup()
    exports.tmtaSQLite:dbTableCreate(TRUCKER_TABLE_NAME, {
        {name = 'userId', type = 'INTEGER', options = 'NOT NULL UNIQUE'},

        -- Cуточное количество заработанных денег
        {name = "currentMoney", type = "INTEGER", options = "DEFAULT 0"},
        -- Cуточное количество рейсов
        {name = "currentOrders", type = "INTEGER", options = "DEFAULT 0"},
        -- Cуточное количество тонн груза
        {name = "currentWeight", type = "INTEGER", options = "DEFAULT 0"},
        -- Cуточное количество пройденной дистанции
        {name = "currentDistance", type = "INTEGER", options = "DEFAULT 0"},

        -- Общее количество рейсов
        {name = "totalOrders", type = "INTEGER", options = "DEFAULT 0"},
        -- Общее количество тонн груза
        {name = "totalWeight", type = "INTEGER", options = "DEFAULT 0"},
        -- Общее количество пройденой дистанции
        {name = "totalDistance", type = "INTEGER", options = "DEFAULT 0"},
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE CASCADE")
end

function Trucker.addUserData(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
		--executeCallback(_G[callbackFunctionName], false)
		outputDebugString("Trucker.addUser: bad arguments", 1)
		return false
	end

    local success = exports.tmtaSQLite:dbTableInsert(TRUCKER_TABLE_NAME, {
        userId = userId,
    })

    if not success then
		--executeCallback(_G[callbackFunctionName], false)
        outputDebugString("Trucker.addUserData: failed to add", 1)
        return false
	end

    return Trucker.getUserDataById(userId, {}, callbackFunctionName, ...)
end

function Trucker.updateUserData(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
        --executeCallback(_G[callbackFunctionName], false)
        return false
    end
    return exports.tmtaSQLite:dbTableUpdate(TRUCKER_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end

function Trucker.getUserDataById(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
		--executeCallback(_G[callbackFunctionName], false)
		outputDebugString("Trucker.getUserDataById: bad arguments", 1)
		return false
	end

    return exports.tmtaSQLite:dbTableSelect(TRUCKER_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end

function Trucker.getPlayerStatistic(player)
    if not isElement(player) then
        return false
    end

    local userId = player:getData('userId')
	if not userId then
		return false
	end
		
    return Trucker.getUserDataById(userId, {}, 'dbTruckerGetUserData', {player = player})
end

function dbTruckerGetUserData(result, params)
    if not params then
        return
    end

    local player = params.player
	local success = not not result

    if (not success or not isElement(player)) then
        return
    end

    if (type(result) ~= 'table' or #result == 0) then
        local userId = player:getData('userId')
		if not userId then
			return false
		end
	
        return Trucker.addUserData(userId, "dbTruckerGetUserData", {player = player})
    end

    result = result[1]
    player:setData('player:truckerStatistic', result)
end

function Trucker.savePlayerStatistic(player)
    if (not isElement(player)) then
        return
    end

    local playerStatistic = player:getData('player:truckerStatistic')
    if not playerStatistic then
        return false
    end


    local fields = {}
    for statisticName, statisticValue in pairs(playerStatistic) do
        fields[statisticName] = statisticValue
	end

    local userId = player:getData('userId')
    return Trucker.updateUserData(userId, fields)
end

function Trucker.resetDailyStatistics()
    local queryString = exports.tmtaSQLite:dbPrepareQueryString([[
        UPDATE `??`
        SET currentMoney = 0, currentOrders = 0, currentWeight = 0, currentDistance = 0;
    ]], TRUCKER_TABLE_NAME)

    return exports.tmtaSQLite:dbQuery(queryString, 'fakeCallback')
end

function Trucker.isPlayerWork(player)
    return player:getData("player:isTrucker")
end

function Trucker.startPlayerWork(player)
    if (not isElement(player) or Trucker.isPlayerWork(player)) then 
        return false
    end

    player:setData("player:isTrucker", true)
    Utils.showNotice("Вы начали рабочую смену. Садитесь в рабочий транспорт.",  player)

    triggerClientEvent(player, 'tmtaTrucker.onClientPlayerStartWork', resourceRoot)

    Cargo.updatePlayerOrderList(player)

    return true
end
addEvent('tmtaTrucker.onPlayerStartWork', true)
addEventHandler('tmtaTrucker.onPlayerStartWork', resourceRoot, Trucker.startPlayerWork)

function Trucker.stopPlayerWork(player)
    if (not isElement(player) or not Trucker.isPlayerWork(player)) then 
        return false
    end

    Cargo.onPlayerOrderCancel(player)
    Trucker.savePlayerStatistic(player)

    player:setData("player:isTrucker", false)
    Utils.showNotice("Вы завершили рабочую смену", player)

    triggerClientEvent(player, 'tmtaTrucker.onClientPlayerStopWork', resourceRoot)
    TruckRental.playerStopTruckRent(player)
    
    return true
end
addEvent('tmtaTrucker.onPlayerStopWork', true)
addEventHandler('tmtaTrucker.onPlayerStopWork', resourceRoot, Trucker.stopPlayerWork)