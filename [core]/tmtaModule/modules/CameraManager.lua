CameraManager = {}

local ANIMATION_SPEED = 2
local currentAnimationSpeed = ANIMATION_SPEED
local currentCameraState
local MOUSE_LOOK_SPEED = 50
local mouseLookEnabled = false
local MOUSE_LOOK_VERTICAL_MAX = 35
local MOUSE_LOOK_VERTICAL_MIN = -5
local cameraScrollValue = 0

local currentVehicle
local moveVehicleDoorsEnabled = true

local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 5,
	FOV = 70,
	targetPosition = Vector3(),
	roll = 0
}

local targetCamera = {}

cameraPresets = {}

cameraPresets.startingCamera = {
	targetPosition = Vector3(0, 1, 0,25),
	rotationHorizontal = -40,
	rotationVertical = 5,
	distance = 5,
	FOV = 60,
	roll = 0
}

cameraPresets.freeLookCamera = {
	targetPosition = Vector3(0, 0.05, 0.25),
	rotationHorizontal = 30,
	rotationVertical = 5,
	distance = 7,
	FOV = 60,
	roll = 0
}

local function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		if k == "rotationHorizontal" then
			local diff = differenceBetweenAngles(camera[k], targetCamera[k])
			camera[k] = camera[k] + diff * deltaTime * currentAnimationSpeed
		else
			camera[k] = camera[k] + (targetCamera[k] - camera[k]) * deltaTime * currentAnimationSpeed
		end
	end

	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.002
	local shakeY = math.cos(getTickCount() / 250) * (math.sin(getTickCount() / 300) + 1) * 0.0005
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.002
	local shakeOffset = Vector3(shakeX, shakeY, shakeZ)

	local pitch = math.rad(camera.rotationVertical)
	local yaw = math.rad(camera.rotationHorizontal)
	local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
	cameraOffset = cameraOffset + shakeOffset / 8
	local works = Camera.setMatrix(
		camera.targetPosition + cameraOffset * camera.distance, 
		camera.targetPosition - shakeOffset * 10, 
		camera.roll, 
		camera.FOV
	)
end

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

local function moveVehicleDoors(vehicle, ratio)
	for i = 0, 5 do
		setVehicleDoorOpenRatio(vehicle, i, ratio, 250)
	end
end 

local function onMouseWheel(key, state, delta)
	cameraScrollValue = math.min(1, math.max(0, cameraScrollValue + delta * 0.25))

	targetCamera.FOV = 65 - cameraScrollValue * 5
	targetCamera.distance = 7 - 2 * cameraScrollValue
end

local function mouseMove(x, y)
	if not mouseLookEnabled then
		return
	end
	local mx = x - 0.5
	local my = y - 0.5
	targetCamera.rotationHorizontal = targetCamera.rotationHorizontal - mx * MOUSE_LOOK_SPEED
	targetCamera.rotationVertical = targetCamera.rotationVertical + my * MOUSE_LOOK_SPEED
	
	if targetCamera.rotationVertical > MOUSE_LOOK_VERTICAL_MAX then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MAX 
	elseif targetCamera.rotationVertical < MOUSE_LOOK_VERTICAL_MIN then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MIN
	end
end

local function startMouseLook()
	if mouseLookEnabled or isMTAWindowActive() then
		return
	end

	mouseLookEnabled = true
	local rotationHorizontal = camera.rotationHorizontal
	local rotationVertical = camera.rotationVertical

	if targetCamera.rotationVertical == 5 then
		CameraManager.setState("freeLookCamera", false, 5)
	end

	camera.rotationHorizontal = rotationHorizontal
	camera.rotationVertical = rotationVertical
	targetCamera.rotationHorizontal = rotationHorizontal
	targetCamera.rotationVertical = rotationVertical		
	showCursor(false)

    if CameraManager.isMoveVehicleDoorsEnabled() then
	    moveVehicleDoors(currentVehicle, 1)
    end

    CameraManager.onStartMouseLook()

	bindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	bindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
end

function CameraManager.onStartMouseLook()
end

local function stopMouseLook()
	if not mouseLookEnabled then
		return
	end

	mouseLookEnabled = false
	showCursor(true)

    if CameraManager.isMoveVehicleDoorsEnabled() then
	    moveVehicleDoors(currentVehicle, 0)
    end

    CameraManager.onStopMouseLook()

	unbindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	unbindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
end

function CameraManager.onStopMouseLook()
end

function CameraManager.setState(name, noAnimation, animationSpeed)
	if not noAnimation and type(animationSpeed) == "number" then
		currentAnimationSpeed = animationSpeed
	else
		currentAnimationSpeed = ANIMATION_SPEED
	end
	if not isElement(currentVehicle) then
		return 
	end
	local vehicle = currentVehicle
	local vehicleMatrix = vehicle.matrix
	for k, v in pairs(cameraPresets[name]) do
		if k == "targetPosition" then
			if type(v) == "string" then
				if v == "car" then				
					targetCamera.targetPosition = Vector3(vehicle.position)
				else
					local componentOffset = Vector3(vehicle:getComponentPosition(v))
					targetCamera.targetPosition = vehicleMatrix:transformPosition(componentOffset)
				end
			else
				vehicle = getPedOccupiedVehicle(localPlayer)
				targetCamera.targetPosition = vehicleMatrix:transformPosition(v)
			end
			if noAnimation then
				camera.targetPosition = Vector3(targetCamera.targetPosition)
			end
		else
			if k == "rotationHorizontal" then
				v = wrapAngle(v)
			end
			targetCamera[k] = v
			if noAnimation then
				camera[k] = v
			end
		end
	end
	currentCameraState = name
end

function CameraManager.start(vehicle)
	if (not isElement(vehicle)) then
		outputDebugString('CameraManager.start: bad arguments', 1)
		return
	end

	currentVehicle = vehicle
	CameraManager.setState("startingCamera", true)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, mouseMove)
	bindKey("mouse2", "down", startMouseLook)
	bindKey("mouse2", "up", stopMouseLook)
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, mouseMove)
	unbindKey("mouse2", "down", startMouseLook)
	unbindKey("mouse2", "up", stopMouseLook)
	Camera.setTarget(localPlayer)
end

function CameraManager.setMoveVehicleDoorsEnabled(state)
    moveVehicleDoorsEnabled = state or not moveVehicleDoorsEnabled
end

function CameraManager.isMoveVehicleDoorsEnabled()
	return not not moveVehicleDoorsEnabled
end

function CameraManager.getTargetPosition()
	return camera.targetPosition
end

function CameraManager.isMouseLookEnabled()
	return not not mouseLookEnabled
end

function CameraManager.getTargetCamera()
    return targetCamera
end

local function getCameraPresets(currentCameraPresets, targetPosition, rotationHorizontal, rotationVertical, distance, FOV, roll)
    if (not currentCameraPresets or type(currentCameraPresets) ~= 'table') then
        return false, 'error getCameraPresets()'
    end
    if (targetPosition and type(targetPosition) ~= 'userdata') then
        return false, 'bad argument #1 `targetPosition`'
    end
    if (rotationHorizontal and type(rotationHorizontal) ~= 'number') then
        return false, 'bad argument #2 `rotationHorizontal`'
    end
    if (rotationVertical and type(rotationVertical) ~= 'number') then
        return false, 'bad argument #3 `rotationVertical`'
    end
    if (distance and type(distance) ~= 'number') then
        return false, 'bad argument #4 `distance`'
    end
    if (FOV and type(FOV) ~= 'number') then
        return false, 'bad argument #5 `FOV`'
    end
    if (roll and type(roll) ~= 'number') then
        return false, 'bad argument #6 `roll`'
    end

    return {
        targetPosition = targetPosition or currentCameraPresets.targetPosition,
        rotationHorizontal = rotationHorizontal or currentCameraPresets.rotationHorizontal,
        rotationVertical = rotationVertical or currentCameraPresets.rotationVertical,
        distance = distance or currentCameraPresets.distance,
        FOV = FOV or currentCameraPresets.FOV,
        roll = roll or currentCameraPresets.roll,
    }
end

function CameraManager.setStartingCameraPresets(targetPosition, rotationHorizontal, rotationVertical, distance, FOV, roll)
    local result, error = getCameraPresets(cameraPresets.startingCamera, targetPosition, rotationHorizontal, rotationVertical, distance, FOV, roll)
    if (not result or type(result) ~= 'table') then
        outputDebugString('CameraManager.setStartingCameraPresets: '..error, 1)
        return false
    end
    cameraPresets.startingCamera = result
    return true
end

function CameraManager.setfreeLookCameraPresets(targetPosition, rotationHorizontal, rotationVertical, distance, FOV, roll)
    local result, error = getCameraPresets(cameraPresets.freeLookCamera, targetPosition, rotationHorizontal, rotationVertical, distance, FOV, roll)
    if (not result or type(result) ~= 'table') then
        outputDebugString('CameraManager.setfreeLookCameraPresets: '..error, 1)
        return false
    end
    cameraPresets.freeLookCamera = result
    return true
end