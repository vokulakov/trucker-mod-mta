Sounds = {}

Vehicles = {}

local SOUND_DISTANCE = 80 -- max distance

local function getPositionFromElementOffset(element, offX, offY, offZ)
	local m = getElementMatrix(element) 
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] 
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z  
end

addEventHandler("onClientPreRender", root, function(dt)
    local cx, cy, cz = getCameraMatrix()

    for veh, data in pairs(Vehicles) do
        local x, y, z = getElementPosition(veh)
        local distance = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)

        if distance < SOUND_DISTANCE*2 then
            Doors.getVehicleDoorsState(veh)
        end
    end 
	
	 -- Обновление исключительно для локального игрока
    local veh = localPlayer.vehicle

    if not isElement(veh) or veh.controller ~= localPlayer then 
        return 
    end

    Tires.getVehicleState(veh, dt)
    
end)

function Sounds.streamInVehicle(vehicle)
    if not isElement(vehicle) or Vehicles[vehicle] then 
        return
    end

    Vehicles[vehicle] = {}
    
    Doors.onVehicleStreamIn(vehicle)
    Tires.onVehicleStreamIn(vehicle)
   
end

function Sounds.streamOutVehicle(vehicle)
    if not isElement(vehicle) or not Vehicles[vehicle] then 
        return 
    end 
    
    Doors.onVehicleStreamOut(vehicle)
    Tires.onVehicleStreamOut(vehicle)

    Vehicles[vehicle] = nil
end

function Sounds.toogleDefaultSounds(state)
    -- Двери 
    setWorldSoundEnabled(19, 40, state)
    setWorldSoundEnabled(19, 33, state)

    -- Резина
    setWorldSoundEnabled(19, 24, state)
end

addEventHandler("onClientElementStreamIn", root, function()
    if source and getElementType(source) == "vehicle" then
    	Sounds.streamInVehicle(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if source and getElementType(source) == "vehicle" then
        Sounds.streamOutVehicle(source)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if source and getElementType(source) == "vehicle" then
        Sounds.streamOutVehicle(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
        	Sounds.streamInVehicle(vehicle)
        end
    end

    Sounds.toogleDefaultSounds(false)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	Sounds.toogleDefaultSounds(true)
end)
