Session = {} 

local authorizedUsers = {}

function Session.isActive(player)
	if not isElement(player) then
		return false
	end

	return not not authorizedUsers[player]
end

function Session.start(player)
	if not isElement(player) then
		return false
	end

	if Session.isActive(player) then
		return false
	end

	authorizedUsers[player] = true
	return true
end

function Session.stop(player)
	if not Session.isActive(player) then
		return false
	end

	authorizedUsers[player] = nil
	return true
end