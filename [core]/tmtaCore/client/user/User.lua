User = {}

function User.signUp(login, password, ...)
    if type(login) ~= "string" or type(password) ~= "string" then
		return false
	end	

	local success, errorType = checkUsername(login)
	if not success then
		return false, errorType
	end

	local success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end
    
    triggerServerEvent(resourceName..".signUpRequest", resourceRoot, login, password, ...)
    return true
end 

function User.login(login, password)
    if type(login) ~= "string" or type(password) ~= "string" then
		return false
	end

	triggerServerEvent(resourceName..".loginRequest", resourceRoot, login, password)
	return true
end

-- Exports
signUp = User.signUp
login = User.login