PlayerData = {}

local loadData = {
	"userId",
	"login",

	"registerTime",
	"lastseenTime",
	"playtime",

    "nickname",
    "skin",
	"hp",
	"armor",
	'mileage',
    
    "position",
    "rotation",
    "interior",
    "dimension",

    "donateCoins",
    "money",
}

local saveData = {
	"playtime",
	"donateCoins",
	"skin",
	"hp",
	"armor",
	"weapon",
	"money",
    "position",
    "rotation",
    "interior",
    "dimension",
	"exp",
	"lvl",
	"mileage",
	"nickname",
	"garageSlot",
}

local protectedData = { 
	["money"] = true,
	["donateCoins"] = true,
	["exp"] = true,
	["lvl"] = true,
	["garageSlot"] = true,
}

local function filterData(dataName, value)
	if dataName == "lastseenTime" then
		return exports.tmtaUtils:convertTimestampToSeconds(value)
	end
	return value
end

function PlayerData.set(player, account)
	for i, name in ipairs(loadData) do
		player:setData(name, filterData(name, account[name]))
	end
end

function PlayerData.get(player)
	local fields = {}
	for i, name in ipairs(saveData) do
		fields[name] = player:getData(name)
	end
	return fields
end

function PlayerData.clear(player)
	for i, name in ipairs(loadData) do
		player:setData(name, nil)
	end
end

-- Защита даты от изменения на стороне клиента
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if (not client) then
		return
	end
	if protectedData[dataName] then
		source:setData(dataName, oldValue)
	end
end)

-- Подготоивть данные перед сохранением
function PlayerData.prepare(player)
	if not isElement(player) then
		return false 
	end

	-- Никнейм
	local nickname = player.name:gsub("#%x%x%x%x%x%x", "")
	player:setData("nickname", tostring(nickname))

	-- Основное
	player:setData("skin", tostring(player.model))
	player:setData("hp", tostring(player.health))
	player:setData("armor", tostring(player.armor))

	-- Местоположение
	local position = Vector3(player.position)
	player:setData("position", tostring(toJSON({x = position.x, y = position.y, z = position.z})))

	local rotation = Vector3(player.rotation)
    player:setData("rotation", tostring(toJSON({rx = rotation.x, ry = rotation.y, rz = rotation.z})))

	player:setData("interior", player.interior)
	player:setData("dimension", player.dimension)

	return true
end

setTimer(function()
	for i, player in ipairs(getElementsByType("player")) do
		local currentPlaytime = tonumber(player:getData("playtime"))
		if currentPlaytime then
			player:setData("playtime", currentPlaytime + 1)
		end
	end
end, 60000, 0)