Tires = {}

local FRICTION_STATE = {
    [1] = 'slip_with_acceleration', -- Пробуксовка с ускорением (только для ведущих колес)
    [2] = 'slip_without_acceleration', -- Скольжение без ускорения
    [3] = 'locked_wheel' -- Колесо заблокировано (на тормозе или ручнике).
}

local TIRE_SOUND_ENABLE = true
local TIRE_SOUND_SRC = 'assets/sounds/general/sound_tires.wav'
local TIRE_SOUND_DISTANCE = 80 -- максимальная дистанция
local TIRE_MAX_VOLUME = 0.5 -- максимальная громкость

local MIN_DRIFT_SPEED = 0.02
local MIN_DRIFT_ANGLE = 10

function Tires.getVehicleState(vehicle, dt)
    if (not isElement(vehicle) or not Vehicles[vehicle]) then 
        return 
    end 

    local sound = Vehicles[vehicle].tires
    if not sound then
        return 
    end

    local targetSound = sound.targetSound
    local targetVolume = sound.targetVolume
    local targetSpeed = sound.targetSpeed

    local driftAngle, isDrifting = Tires.isVehicleDetectedDrift(vehicle)
    local mul = (driftAngle - MIN_DRIFT_ANGLE) / (90 - MIN_DRIFT_ANGLE)
    
    if not isDrifting then
        mul = 0
    end

    if mul < 0 then
        mul = 0
    elseif mul > 1 then
        mul = 1
    end

    local friction, state = Tires.getFrictionState(vehicle)
    local surface = Utils.getSurfaceVehicleIsOn(vehicle)

    if state then
        if surface == 0 or surface == 1 then
            local velocityMul = 0.5 + (0.5 - #vehicle.velocity * 20)
            
            if velocityMul > 0.8 then
                targetVolume = TIRE_MAX_VOLUME * velocityMul
                targetSpeed = 1 * velocityMul
            elseif friction == 'locked_wheel' then
                targetVolume = TIRE_MAX_VOLUME
                targetSpeed = 1 
            else 
                targetVolume = mul * TIRE_MAX_VOLUME
                targetSpeed = 0.75 + 0.25 * mul
            end
        end
    end 

    targetSpeed = targetSound.speed + (targetSpeed - targetSound.speed) * (dt/1000) * 5
    targetVolume = targetSound.volume + (targetVolume - targetSound.volume) * (dt/1000) * 10 

    vehicle:setData("sound:tires", 
        { 
            targetSpeed = targetSpeed,
            targetVolume = targetVolume
        }
    )
end

function Tires.isVehicleDetectedDrift(vehicle)
	if not isElement(vehicle) then 
		return 0, false
	end

	if vehicle.velocity.length < MIN_DRIFT_SPEED then
		return 0, false
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	angle = math.abs(angle)

	if angle > MIN_DRIFT_ANGLE and angle < 120 then
		return angle, true
	else
		return angle, false
	end
end

function Tires.getFrictionState(vehicle)
    if not isElement(vehicle) or vehicle.vehicleType ~= 'Automobile' then 
        return 
    end

    local wheels_friction = {}
    local wheels_ground = {}

    for wheel_id = 0, 3 do
        local wheel_friction = getVehicleWheelFrictionState(vehicle, wheel_id)

        if tonumber(wheel_friction) ~= 0 then 
            table.insert(wheels_friction, wheel_friction)
        end
    end

    local isGround = Utils.isVehicleWheelOnGround(vehicle)

    if #wheels_friction > 0 and isGround then
        return FRICTION_STATE[math.min(unpack(wheels_friction))], true
    end

    return false
end

function Tires.addVehicleSound(vehicle)
    if not isElement(vehicle) then
        return false
    end

    local pos = Vector3(vehicle.position)
    local sound = playSound3D(TIRE_SOUND_SRC, pos.x, pos.y, pos.z, true)
    sound.maxDistance = TIRE_SOUND_DISTANCE
    attachElements(sound, vehicle)
    
    sound.speed = 1
    sound.volume = 0 

    return {targetSound = sound, targetVolume = sound.volume, targetSpeed = sound.speed}
end

function Tires.removeVehicleSound(vehicle)
    if not isElement(vehicle) then 
        return 
    end

    local sound = Vehicles[vehicle].tires.targetSound

    if isElement(sound) then
        destroyElement(sound)
    end
end

addEventHandler("onClientElementDataChange", root, function(data, _, new_sound_data)
	if getElementType(source) ~= "vehicle" or data ~= 'sound:tires' then 
		return 
	end

    if not Vehicles[source] then
		return
	end

    local sound = Vehicles[source].tires

    if not sound then 
        return 
    end
    if (new_sound_data and isElement(sound.targetSound)) then
        sound.targetSound.speed = tonumber(new_sound_data.targetSpeed)
        sound.targetSound.volume = tonumber(new_sound_data.targetVolume)
    end
end)

function Tires.onVehicleStreamIn(vehicle)
    if Vehicles[vehicle].tires then 
        return 
    end     

    Vehicles[vehicle].tires = Tires.addVehicleSound(vehicle)
end 

function Tires.onVehicleStreamOut(vehicle)
    if not Vehicles[vehicle].tires then 
        return 
    end 

    Tires.removeVehicleSound(vehicle)

    Vehicles[vehicle].tires = nil
end 