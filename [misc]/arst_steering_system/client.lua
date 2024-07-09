
local maxDistance = 5 -- максимальная дистанция, на которой видно поворот руля для других игроков

local wheel_rotate_time = 1000
local rotate_start = 1
local rotatingVehicles = {}

local vehicleSteeringNames = {
	--  [модель] = "название руля",
	[0] = "steering_ok", -- дефолтное
}

addEventHandler ( "onClientRender", root,
function()
	for i, v in pairs (rotatingVehicles) do
		if v.rotating == 1 then
			rotatingVehicles[i].wheel_rotation = interpolateBetween ( v.wheel_rotation, 0, 0, 90, 0, 0, (getTickCount()-v.rotate_start)/wheel_rotate_time, "Linear" )
		elseif v.rotating == 2 then
			rotatingVehicles[i].wheel_rotation = interpolateBetween ( v.wheel_rotation, 0, 0, 0, 0, 0, (getTickCount()-v.rotate_start)/wheel_rotate_time, "Linear" )
		elseif v.rotating == 3 then
			rotatingVehicles[i].wheel_rotation = interpolateBetween ( v.wheel_rotation, 0, 0, -90, 0, 0, (getTickCount()-v.rotate_start)/wheel_rotate_time, "Linear" )
		end
	--	outputChatBox(rotatingVehicles[i].wheel_rotation)
		setVehicleComponentRotation ( i, v.name, 0, rotatingVehicles[i].wheel_rotation, 0 )
	end
end)


function startMovingWheelRight()
	local veh = getPedOccupiedVehicle ( localPlayer )
	if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		setElementData(veh, "dyn:steering", 1)
		setElementData(veh, "dyn:vehicle_right", true)
	end
end

function startMovingWheelLeft()
	local veh = getPedOccupiedVehicle ( localPlayer )
	if veh and getPedOccupiedVehicleSeat (localPlayer) == 0 then
		setElementData(veh, "dyn:steering", 3)
		setElementData(veh, "dyn:vehicle_left", true)
	end
end

function stopMovingWheel(key)

	local veh = getPedOccupiedVehicle ( localPlayer )
	if veh and getPedOccupiedVehicleSeat (localPlayer) == 0 then
		setElementData(getPedOccupiedVehicle(localPlayer), "dyn:steering", 2)

		if key == 'vehicle_right' then
			setElementData(veh, "dyn:vehicle_right", false)
		elseif key == 'vehicle_left' then
			setElementData(veh, "dyn:vehicle_left", false)
		end

		if getElementData(veh, 'dyn:vehicle_right') then
			setElementData(veh, "dyn:steering", 1)
		elseif getElementData(veh, 'dyn:vehicle_left') then
			setElementData(veh, "dyn:steering", 3)
		end

	end
end

bindKey("vehicle_right", "down", startMovingWheelRight)
bindKey("vehicle_right", "up", stopMovingWheel)
bindKey("vehicle_left", "down", startMovingWheelLeft)
bindKey("vehicle_left", "up", stopMovingWheel)

addEventHandler("onClientElementDataChange", getRootElement(),
function ( dataName)
	if getElementType ( source ) == "vehicle" and dataName == "dyn:steering" then

		local x,y,z = getElementPosition ( localPlayer )
		local vx,vy,vz = getElementPosition ( source )
		if getDistanceBetweenPoints3D(x,y,z,vx,vy,vz) < maxDistance or getVehicleOccupant ( source ) == localPlayer then
			
			local name = vehicleSteeringNames[getElementModel(source)] or vehicleSteeringNames[0]
			local res = getVehicleComponents(source)
			if not res[name] then return end

			if not rotatingVehicles[source] then
				rotatingVehicles[source] = {}
			end
			if isTimer (rotatingVehicles[source].timer) then killTimer (rotatingVehicles[source].timer) end
			
			local _, ry, _ = getVehicleComponentRotation(source, name)

			if ry > 90 then ry = -(360-ry) end
			rotatingVehicles[source].rotate_start = getTickCount()
			rotatingVehicles[source].wheel_rotation = ry
			rotatingVehicles[source].name = name
			rotatingVehicles[source].rotating = getElementData (source,dataName)
			rotatingVehicles[source].timer = setTimer (function(veh) rotatingVehicles[veh] = nil end,wheel_rotate_time,1,source)
		end		
	end
end )


-- СПИДОМЕТР/ТАХОМЕТР [НАЧАЛО]
local function getElementSpeed(element, unit)
	if (unit == nil) then
		unit = 0
	end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)

		if (unit == "mph" or unit == 1 or unit == '1') then
			return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100)
		else
			return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100 * 1.609344)
		end
	else
		return false
	end
end

local function getVehicleRPM(vehicle)
	local vehicleRPM = 0
	if (vehicle) then
		if (getVehicleEngineState(vehicle) == true) then
			if getVehicleCurrentGear(vehicle) > 0 then
				vehicleRPM = math.floor(((getElementSpeed(vehicle, "kmh") / getVehicleCurrentGear(vehicle)) * 180) + 0.5)
				if (vehicleRPM < 650) then
					vehicleRPM = math.random(650, 750)
				elseif (vehicleRPM >= 9800) then
					vehicleRPM = math.random(9800, 9900)
				end
			else
				vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh") * 180) + 0.5)
				if (vehicleRPM < 650) then
					vehicleRPM = math.random(650, 750)
				elseif (vehicleRPM >= 9800) then
					vehicleRPM = math.random(9800, 9900)
				end
			end
		else
			vehicleRPM = 0
		end
		return tonumber(vehicleRPM)
	else
		return 0
	end
end

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and getPedOccupiedVehicleSeat (localPlayer) == 0 then
		local rpm = getVehicleRPM(veh)
		setVehicleComponentRotation(veh, "tahook", 0, rpm/35, 0)
		local spd = getElementSpeed(veh, "kmh")
		setVehicleComponentRotation(veh, "speedook", 0, spd, 0)
	end
end) 

-- СПИДОМЕТР/ТАХОМЕТР [КОНЕЦ]