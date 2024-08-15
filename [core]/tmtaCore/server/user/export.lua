-- Проверка на существование аккаунта
function userExists(login)
	local users = User.getByLogin(login, {"login"})
	return type(users) == "table" and #users > 0
end

function getPlayerByUserId(userId)
	return User.getPlayerById(userId)
end

function getUserDataById(userId, fields)
	return User.getById(userId, fields)
end

function updateUserDataById(userId, fields)
	return User.update(userId, fields)
end

--- Выдать пользователю игровую валюту
-- @tparam number userId
-- @tparam number amount
-- @treturn bool
function giveUserMoney(userId, amount)
	if (type(userId) ~= 'number' or type(amount) ~= 'number') then 
		return false
	end

	amount = math.ceil(math.abs(amount))

	local userDataResult = User.getById(userId, {'money'})
	local userMoney = tonumber(userDataResult[1].money)

	return User.update(userId, {money = tonumber(userMoney + money)})
end