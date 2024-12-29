local function isUserExist(username)
    if (not username or type(username) ~= "string") then
        return false
    end
    return exports.tmtaCore:userExists(username)
end

local function getUserId(username)
    if (not username or type(username) ~= "string") then
        return false
    end

    local result = exports.tmtaCore:getUserDataByLogin(username, {'userId'})
    if result then
        return result.userId
    end

    return true
end

--- Выдача игровой валюты
function giveUserMoney(username, amount)
    if (not username or type(username) ~= "string" or not amount) then
        outputDebugString('giveUserMoney: bad arguments', 1)
        return false
    end
	
    if not isUserExist(username) then
        local message = string.format("[error] User '%s' not found", tostring(username))
        exports.tmtaLogger:log("donate", message)
        outputDebugString('giveUserMoney: '..message, 1)
        return false
    end

    local userId = getUserId(username)
    if not userId then
        local message = string.format("[error] Not found userId for user '%s'", tostring(username))
        exports.tmtaLogger:log("donate", message)
        outputDebugString('giveUserMoney: '..message, 1)
        return false
    end
	
    amount = math.ceil(math.abs(amount))
    if (exports.tmtaX2:isPromoActive()) then
        amount = amount * 2
    end

    local player = exports.tmtaCore:getPlayerByUserId(userId)
    if isElement(player) then
        exports.tmtaMoney:givePlayerMoney(player, amount)
        local message = string.format("На ваш аккаунт зачислено #FFA07A%s #FFFFFF₽ игровой валюты", exports.tmtaUtils:formatMoney(amount))
        exports.tmtaNotification:showInfobox(player, "info", '#FFA07AУведомление', message, _, {240, 146, 115})
    else
        exports.tmtaCore:giveUserMoney(userId, amount)
    end

    local message = string.format("[success] User '%s' received money amount: %s", tostring(username), tostring(amount))
    exports.tmtaLogger:log("donate", message)

    return true
end