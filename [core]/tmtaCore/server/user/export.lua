-- Проверка на существование аккаунта
function userExists(login)
	local users = User.getByLogin(login, {"login"})
	return type(users) == "table" and #users > 0
end