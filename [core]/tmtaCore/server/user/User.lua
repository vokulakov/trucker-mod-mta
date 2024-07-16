User = {}

USER_TABLE_NAME = 'user'
local PASSWORD_SECRET = "e449a876254f324fcf35d9276085"

function User.setup()
    exports.tmtaSQLite:dbTableCreate(USER_TABLE_NAME, {
        -- Логин
		{name = "login", type = "VARCHAR", size = 25, options = "UNIQUE NOT NULL"},
		-- Пароль
		{name = "password", type = "VARCHAR", size = 128, options = "NOT NULL"},
        -- Никнейм
        {name = "nickname", type = "VARCHAR", size = 64, options = "NOT NULL"},
        -- Пол (male / female)
        {name = "sex", type = "VARCHAR", size = 10, options = "DEFAULT 'male' NOT NULL"},
        -- Скин
        {name = "skin", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Здоровье
        {name = "hp", type = "INTEGER", options = "DEFAULT 100 NOT NULL"},
        -- Броня
        {name = "armor", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Голод
        {name = "hunger", type = "INTEGER", options = "DEFAULT 100 NOT NULL"},
        -- Оружие
        {name = "weapon", type = "TEXT"},
        -- Позиция ({x, y, z})
        {name = "position", type = "TEXT"},
        -- Ротация ({rx, ry, rz})
        {name = "rotation", type = "TEXT"},
        -- Интерьер
        {name = "interior", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Измерение
        {name = "dimension", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
    
        -- Деньги
        {name = "money", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Опыт
        {name = "exp", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Уровень
        {name = "lvl", type = "INTEGER", options = "DEFAULT 1 NOT NULL"},
        -- Обший пробег
        {name = "mileage", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Ячеек (мест) в гараже
        {name = "garageSlot", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        
        -- Количество донат-валюты
        {name = "donateCoins", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        
        -- Наигранное время (общее) количество минут, проведённых в игре
        {name = "playtime", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        -- Время сессии
        {name = "sessionTime", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
        
        -- Дата последней активности
        {name = "lastseenTime", type = "INTEGER", options = "DEFAULT 0"},
        -- IP при авторизации
        {name = "lastseenIp", type = "VARCHAR", size = 45},
        -- Serial при авторизации
        {name = "lastseenSerial", type = "VARCHAR", size = 32},
        
        -- Дата регистрации
        {name = "registerTime", type = "TIMESTAMP", options = "DEFAULT CURRENT_TIMESTAMP NOT NULL"},
        -- IP при регистрации
        {name = "registerIp", type = "VARCHAR", size = 45},
        -- Serial при регистрации
        {name = "registerSerial", type = "VARCHAR", size = 32},
    
        {name = "isDeleted", type = "INTEGER", options = "DEFAULT 0 NOT NULL"},
    })

    -- Очистка даты
	for i, player in ipairs(getElementsByType("player")) do
        --PlayerData.clear(player)
    end
end

addEvent(resourceName..".login", true)
addEvent(resourceName..".register", true)

-- Функция хэширования паролей пользователей
local function hashUserPassword(login, password)
    return sha256(password .. tostring(login) .. tostring(string.len(login)) .. tostring(PASSWORD_SECRET))
end

-- Создать пользователя
function User.signUp(player, login, password, callbackFunctionName, ...)
    if (not isElement(player) or type(login) ~= "string" or type(password) ~= "string") then
        outputDebugString("User.signUp: bad arguments", 1)
        return false
    end

	-- Проверка на существование пользователя
	if (userExists(login) or getAccount(login)) then 
		return false, "already_reg"
	end

    -- Проверка имени пользователя и пароля
	if (not checkUsername(login) or not checkPassword(password)) then
		outputDebugString("User.signUp: bad login or password", 1)
		return false, "bad_password"
	end

    -- Хэширование пароля
	password = hashUserPassword(login, password)

    exports.tmtaSQLite:dbTableInsert(USER_TABLE_NAME, {
        login = login,
        password = password,
        nickname = player.name,
        registerIp = player.ip,
        registerSerial = player.serial
    }, callbackFunctionName, ...)

    return true
end

addEvent(resourceName..".signUpRequest", true)
addEventHandler(resourceName..".signUpRequest", resourceRoot, 
    function(login, password)
        local player = client

        local success, errorType = User.signUp(player, login, password, "callbackUserSignUp", {player = player, login = login, password = password})
		if not success then
            triggerClientEvent(player, "tmtaLogin.signUpResponse", resourceRoot, false, errorType)
            triggerEvent(resourceName..".register", player, false, errorType)
        end
    end
)

function callbackUserSignUp(result, params)
	if not params or not isElement(params.player) then
        return
    end

    local player = params.player
	result = not not result
	local errorType = ""
	if result then
        local login = params.login
        local password = params.password
	    password = hashUserPassword(login, password)

        local accountAdded = addAccount(login, password)
        if (not accountAdded) then
            exports.tmtaSQLite:dbTableDelete(USER_TABLE_NAME, {login = login}, 'callback')
            outputDebugString("User.signUp: error addAccount", 1)
            return false
        end

        exports.tmtaLogger:log("auth", string.format("New user registered: '%s'", login))
    else
		errorType = "login_taken"
	end

	triggerClientEvent(player, "tmtaLogin.signUpResponse", resourceRoot, result, errorType)
	triggerEvent(resourceName..".register", player, result, errorType)
end

-- Авторизовать пользователя
function User.login(player, login, password, callbackFunctionName, ...)
    if not isElement(player) or type(login) ~= "string" or type(password) ~= "string" then
        outputDebugString("Users.login: bad arguments", 1)
        return false
    end

	if (Session.isActive(player)) then
        outputDebugString("User.login: User already logged in", 1)
        return false, "already_logged_in"
    end

    local account = getAccount(login)
    if (not account) then
        outputDebugString("User.login: User not found", 1)
        return false, "user_not_found"
    end

    password = hashUserPassword(login, password)
    if (not getAccount(login, password)) then
        outputDebugString("User.login: Incorrect password", 1)
        return false, "incorrect_password"
    end

    if (not logIn(player, account, password)) then
        outputDebugString("User.login: User already logged in", 1)
        return false, "already_logged_in"
    end
    
    return User.getByLogin(login, {}, callbackFunctionName, ...)
end

-- Запрос на авторизацию
addEvent(resourceName..".loginRequest", true)
addEventHandler(resourceName..".loginRequest", resourceRoot, 
    function(login, password)
        local player = client

        local success, errorType = User.login(player, login, password, "callbackLoginPlayer", {player = player, login = login, password = password})
        if not success then
            triggerClientEvent(player, "tmtaLogin.loginResponse", resourceRoot, false, errorType)
            triggerEvent(resourceName..".login", player, false, errorType)
        end
    end
)


function callbackLoginPlayer(result, params)
	if not params or not isElement(params.player) then
        return
    end

	local player = params.player
	local success, errorType = not not result, "user_not_found"
	local account, login, password

    if (success) then
		if (Session.start(player)) then

            account = result
            login = params.login
            password = params.password

			exports.tmtaSQLite:dbTableUpdate(USER_TABLE_NAME, {
                lastseenTime = getRealTime().timestamp,
				lastseenIp = player.ip,
				lastseenSerial = player.serial,
            }, {login = login})

            PlayerData.set(player, account)

            exports.tmtaLogger:log("auth", string.format("User '%s' logged in with nickname '%s'", login, tostring(player.name)))
        else
            errorType = "already_logged_in"
        end
    end
    
    triggerClientEvent(player, "tmtaLogin.loginResponse", resourceRoot, success, errorType)
    triggerEvent(resourceName..".login", player, success, errorType)
end

function User.update(login, fields)
    if (type(login) ~= "string" or type(fields) ~= "table") then
        return false
    end

    return exports.tmtaSQLite:dbTableUpdate(USER_TABLE_NAME, fields, {login = login}, "callback")
end

function User.save(player)
    if not isElement(player) then
        return false
    end
    if not Session.isActive(player) then
        return false
    end

    if (PlayerData.prepare(player)) then
        local login = player:getData("login")

        local fields = PlayerData.get(player)
        fields['lastseenTime'] = getRealTime().timestamp

        User.update(login, fields)
    else
        return false
    end

    return true
end

setTimer(
    function ()
        for i, player in ipairs(getElementsByType("player")) do
            User.save(player)
        end

        outputDebugString("Autosave completed!")
        exports.tmtaLogger:log("systems", "Autosave completed!")
    end, Config.AUTOSAVE_INTERVAL * 60 * 1000, 0)

function User.logout(player)
    if not isElement(player) then
        return false
    end

    if (not Session.isActive(player)) then
        return false
    end

    User.save(player)
    Session.stop(player)

    local login = player:getData("login")
    exports.tmtaLogger:log("auth", string.format("User '%s' has logged out (%s)", login, tostring(player.name)))

    return true
end

addEventHandler("onPlayerQuit", root, 
    function()
        User.logout(source)
    end, 
    true, "low"
)

function User.getByLogin(login, fields, callbackFunctionName, ...)
    if (type(login) ~= "string" or type(fields) ~= "table") then
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(USER_TABLE_NAME, fields, {login = login}, callbackFunctionName, ...)
end

function User.getPlayerById(userId)
    if not userId then
        return false
    end
    for i, player in ipairs(getElementsByType("player")) do
        local playerId = player:getData("userId")
        if playerId and playerId == userId then
            return player
        end
    end
    return false
end

function User.getById(userId, fields, callbackFunctionName, ...)
    if type(userId) ~= "number" or type(fields) ~= "table" then
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(USER_TABLE_NAME, fields, {userId = userId}, callbackFunctionName, ...)
end