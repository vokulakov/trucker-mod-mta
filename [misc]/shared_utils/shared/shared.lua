local players = {}
function getPlayerFromLogin(l)
	if isElement(players[l]) then return players[l] end
	for k,v in pairs(getElementsByType('player')) do
		if tostring(getElementData(v, 'accountName')) == l then
			players[l] = v
			return v
		end
	end
	return false
end

function string.split(str)

	if not str or type(str) ~= "string" then return false end

	local splitStr = {}
	for i=1,string.len(str) do
		local char = str:sub( i, i )
		table.insert( splitStr , char )
	end

	return splitStr 
end

function splitWithPoints(s, splstr)
	splstr = splstr or ','
	local t = ''
	s = tonumber(s)
	local str = tostring(math.abs(s))
	local mvstr = ''
	if s < 0 then
	mvstr = '-'
	end
	local arr = string.split(string.reverse(str), '')
	local sp = 1
	for k,v in pairs(arr) do
	if sp == 4 then
	sp = 1
	t = t .. splstr
	end

	t = t .. v

	sp = sp + 1
	end
	return mvstr .. string.reverse(t)
end

local colorSchemes = {
	[1] = {
		rgb = {255,0,0},
		hex = '#ff0000',
		hlsl = {1, 0, 0},
	},
	[2] = {
		rgb = {11,112,200},
		hex = '#0b70c6',
		hlsl = {11/255,112/255,200/255},
	},
}

function getServerIndex()
	return getElementData(root, 'serverIndex') or 1
end


function around(fst, snd)
     local mid = math.pow(10,snd)
     return math.floor((fst*mid)+0.5)/mid
end

function getElementSpeed(element, k)
	local speedx, speedy, speedz = getElementVelocity(element)
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	if k == "kmh" or k == nil or k == 1 then return around(actualspeed * 180, 5)
	elseif k == "mps" or k == 2 then return around(actualspeed * 50, 5)
	elseif k == "mph" or k == 3 then return around(actualspeed * 111.847, 5) end
end


function isResourceRunning (resName)

    local res = getResourceFromName(resName)

    return (res) and (getResourceState(res) == "running")
end

local townsRussian = {
    ['Las Venturas']='Лас-Вентурас',
    ['Los Santos']='Лос-Сантос',
    ['Whetstone']='Уэтстоун',
    ['San Fierro']='Сан-Фиерро',
    ['Flint County']='Флинт',
    ['Red County']='Ред',
    ['Tierra Robada']='Тьера Робада',
    ['Bone County']='Боун',
    ['Unknown']='Неизвестно',
}
function getTown(x,y)
    local town = getZoneName(x, y, 0, true)
    return (townsRussian[town] or town)
end


function increaseAccountData(account, dataName, incNumber)
	setAccountData(account, dataName, 
		(getAccountData(account, dataName) or 0) + incNumber
	)
end

function increaseElementData(element, dataName, incNumber, noSync)
	setElementData(element, dataName, 
		(getElementData(element, dataName) or 0) + incNumber, not noSync
	)
end

function findRotation3D( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getTableLength(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

function getServerWebsite()
	return 'dailymta.ru'
end

function isAdmin(player)
	return exports['acl']:isPlayerInGroup(player, 'admin')
end
function isFounder(player)
	return exports['acl']:isPlayerInGroup(player, 'founder')
end

function isModerator(player)
	return exports['acl']:isPlayerInGroup(player, 'moderator')
	 	or exports['acl']:isPlayerInGroup(player, 'admin')
end

function isYoutube(player)
	return exports['acl']:isPlayerInGroup(player, 'youtube')
end

function getDonateConvertMul()
	return 10000
end

function getEconomicsMultiplier()
	return 1
end