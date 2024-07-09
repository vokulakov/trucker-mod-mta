local startingSkins = {24, 36, 37, 67, 101, 133}

local startingSpawnLocations = {
	{ position = { x = 295, y = -2483, z = 8 }, rotation = { rx = 0, ry = 0, rz = 270 }},
	{ position = { x = 295, y = -2485, z = 8 }, rotation = { rx = 0, ry = 0, rz = 270 }},
	{ position = { x = 295, y = -2487, z = 8 }, rotation = { rx = 0, ry = 0, rz = 270 }},
	{ position = { x = 295, y = -2489, z = 8 }, rotation = { rx = 0, ry = 0, rz = 270 }},
}

local function handlePlayerFirstSpawn(player)
	if not isElement(player) then
		return
	end
	
	local skin = startingSkins[math.random(1, #startingSkins)]
	player:setData("skin", skin)

	local location = startingSpawnLocations[math.random(1, #startingSpawnLocations)]
	player:setData("position", tostring(toJSON(location.position)))
    player:setData("rotation", tostring(toJSON(location.rotation)))

	PlayerSpawn.spawn(player)
end

addEvent(resourceName..".login", true)
addEventHandler(resourceName..".login", root, 
    function(success)
        if (not success) then
            return
        end
        
        local player = source
        if not player:getData("position") then
            handlePlayerFirstSpawn(player)
        else
            PlayerSpawn.spawn(player)
        end
    end
)