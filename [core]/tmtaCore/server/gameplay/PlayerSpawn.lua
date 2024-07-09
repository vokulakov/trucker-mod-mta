PlayerSpawn = {}

function PlayerSpawn.spawn(player, position, rotation, health, armor, isWasted)
	if (not isElement(player)) then
		return false
	end

	local pos = fromJSON(player:getData("position"))
	local position = position or Vector3(pos.x, pos.y, pos.z)
	player:spawn(position)

	local rot = fromJSON(player:getData("rotation"))
	player.rotation = rotation or Vector3(rot.rx, rot.ry, rot.rz)

	player.interior = player:getData("interior") or 0
	player.dimension = player:getData("dimension") or 0

	if (isWasted) then
		player.health = health or 100
		player.armor = armor or 0
	else
		player.health = health or player:getData("hp")
		player.armor = armor or player:getData("armor")
	end

	player.model = player:getData("skin")

	player:fadeCamera(true, 3)
	player:setCameraTarget()

	triggerClientEvent(player, resourceName..".onPlayerSpawn", player, isWasted)
	triggerEvent(resourceName..".onPlayerSpawn", player, isWasted)

	return true
end

addEventHandler("onPlayerWasted", root, 
	function()
		local player = source
		player:fadeCamera(false, 3)
		setTimer(function ()
			if (isElement(player)) then
				local position = exports.tmtaHospital:getNearestToPlayer(player)
				local rotation = Vector3(0, 0, 0)
				PlayerSpawn.spawn(player, position, rotation, _, _, true)
			end
		end, 3000, 1)
	end
)