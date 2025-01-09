local Tags = {
	['Console'] = '#00ff00Генеральный директор',
	['Admin'] = '#FF0000Администратор',
}

function getPlayerTag(player)
	if not isElement(player) then 
		return
	end

	local Account = getPlayerAccount(player)
	if not Account then
		return "[Гость]"
	end

	for group, tag in pairs(Tags) do
		if isObjectInACLGroup("user." .. getAccountName(Account), aclGetGroup(group)) then
			return '#FFFFFF['..tag..'#FFFFFF]'
		end
	end

	return "[Игрок]"
end