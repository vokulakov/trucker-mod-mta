-- выдача денег
-- установка навигатора на диспетчера
local UserBonus = {}

local USER_BONUS_TABLE = 'userBonus'

function UserBonus.setup()
    exports.tmtaSQLite:dbTableCreate(USER_BONUS_TABLE, {
        {name = 'userId', type = 'INTEGER', options = 'NOT NULL UNIQUE'},
        {name = 'isTakeBonus', type = 'INTEGER', options = 'DEFAULT 0'},
        {name = "receivedAt", type = "TIMESTAMP", options = "DEFAULT CURRENT_TIMESTAMP"},
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

function UserBonus.update(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
        return false
    end
    return exports.tmtaSQLite:dbTableUpdate(USER_BONUS_TABLE, fields, {userId = userId}, callbackFunctionName, ...)
end

function UserBonus.getUserDataById(userId, fields, callbackFunctionName, ...)
    if (type(userId) ~= "number" or type(fields) ~= "table") then
		outputDebugString("UserBonus.getUserDataById: bad arguments", 1)
		return false
	end

    return exports.tmtaSQLite:dbTableSelect(USER_BONUS_TABLE, fields, {userId = userId}, callbackFunctionName, ...)
end

function UserBonus.isPlayerTakeBonus(player)
    if not isElement(player) then
        return false
    end

    local userId = player:getData('userId')
    local result = UserBonus.getUserDataById(userId, {'isTakeBonus'})
    if (type(result) ~= 'table' or #result == 0) then
        return
    end

    return exports.tmtaUtils:tobool(result[1].isTakeBonus)
end

function UserBonus.givePlayerBonus(player)
    if not isElement(player) then
        return false
    end

    local userId = player:getData('userId')

    local success = exports.tmtaSQLite:dbTableInsert(USER_BONUS_TABLE, {
        userId = userId,
        isTakeBonus = true,
    })

    return not not success
end

addEventHandler('onResourceStart', resourceRoot,
    function()
        UserBonus.setup()
    end
)

addEvent('tmtaUserBonus.onPlayerTakeBonusRequest', true)
addEventHandler('tmtaUserBonus.onPlayerTakeBonusRequest', root, 
    function()
        local player = client
        if not isElement(player) then
            return
        end

        if UserBonus.isPlayerTakeBonus(player) then
            local message = 'Вы уже получили свой бонус.\nПриятной игры!'
            triggerClientEvent(player, 'tmtaUserBonus.showNotice', resourceRoot, 'warning', message)
            return
        end

        local success = UserBonus.givePlayerBonus(player)
        if (not success) then
            local message = 'Неизвестная ошибка. Обратитесь к администратору!'
            triggerClientEvent(player, 'tmtaUserBonus.showNotice', resourceRoot, 'error', message)
            return
        end

        exports.tmtaMoney:givePlayerMoney(player, tonumber(Config.USER_BONUS_AMOUNT))

        local message = string.format('Вы получили стартовый бонус %s ₽\nПриятной игры!', exports.tmtaUtils:formatMoney(Config.USER_BONUS_AMOUNT))
        triggerClientEvent(player, 'tmtaUserBonus.showNotice', resourceRoot, 'success', message)
    end
)