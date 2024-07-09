--[[
	##########################################################
	# @project: bengines
	# @author: brzys <brzysiekdev@gmail.com>
	# @filename: engine_c.lua
	# @description: new engine sounds & RPM simulation
	# All rights reserved.
	##########################################################
--]]
ENGINE_ENABLED = true
ENGINE_VOLUME_MASTER = 0.15 -- умножитель объема
ENGINE_VOLUME_THROTTLE_BOOST = 2.5 -- увеличение объема двигателя при использовании дроссельной заслонки
ENGINE_SOUND_FADE_DIMENSION = 6969 -- размерность для выгрузки звуков
ENGINE_SOUND_DISTANCE = 80 -- максимальное расстояние

DEBUG = false

local streamedVehicles = {}
local pi = math.pi 

-- Blowoff [BEGIN] -
local VehiclesBlowoff = {}

local function attachEffect(effect, vehicle, position)

    if not VehiclesBlowoff[vehicle] then
		VehiclesBlowoff[vehicle] = {}
    end 

    VehiclesBlowoff[vehicle][effect] = position
   
    addEventHandler("onClientElementDestroy", effect, function() 
        if not VehiclesBlowoff[vehicle] then
            return
        end 

        VehiclesBlowoff[vehicle][effect] = nil 
    end, false)

	addEventHandler("onClientElementDestroy", vehicle, function() 
        if not VehiclesBlowoff[vehicle] then
            return
        end 
        
        VehiclesBlowoff[vehicle][effect] = nil 
    end, false)

	return true
end

local function getPositionFromElementOffset(element, offX, offY, offZ)
	local m = getElementMatrix(element) 
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] 
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z  
end

-- Определение двойной ли выхлоп
local bytes = {["2"] = true, ["6"] = true, ["A"] = true, ["E"] = true}
local function isDoubleExhauts(veh)
    local handling = getVehicleHandling (veh)["modelFlags"]
    local newHandling = string.format ("%X", handling)
    local reversedHex = string.reverse ( newHandling )..string.rep ( "0", 8 - string.len (newHandling))
	
    local byte4 = string.sub(reversedHex, 4, 4)
    if bytes[byte4] then
        return true
    else
        return false
    end
end

function addBlowOff(vehicle, position)
    if not isElement(vehicle) then
        return
    end

	local fumesPosition = {getVehicleModelDummyPosition(vehicle.model, 'exhaust')}
	local fxOffset = VEHICLES_BLOWOFF_POSITION[vehicle.model]
	if not fxOffset then
		fxOffset = {}
		table.insert(fxOffset, {x = fumesPosition[1], y = fumesPosition[2], z = fumesPosition[3]})
		if isDoubleExhauts(vehicle) then
			table.insert(fxOffset, {x = fumesPosition[1]*(-1), y = fumesPosition[2], z = fumesPosition[3]})
		end
	end

    if not fxOffset then
        return
    end

    for _, offset in pairs(fxOffset) do
        local effect = createEffect('gunflash', position.x, position.y, position.z)
        setEffectDensity(effect, 2)
        attachEffect(effect, vehicle, Vector3(offset.x, offset.y -0.2, offset.z))
		
        setTimer(function()
            if isElement(effect) then
                destroyElement(effect)
            end
        end, 1000, 1)
    end 
end
-- Blowoff [END] --


function calculateGearRatios(vehicle, maxRPM, startRatio)
	local ratios = {}
	local handling = getVehicleHandling(vehicle)
	
	local gears = math.max(4, handling.numberOfGears)
	local maxVelocity = handling.maxVelocity
	local acc = handling.engineAcceleration 
	local drag = handling.dragCoeff
	--local c = ((acc*maxVelocity) / maxRPM)*(maxRPM*0.00175)
	--local c = startRatio or ((acc / drag / maxVelocity) * pi) * 20
	
	local curGear, curRatio = 1, 0
	local mRPM = maxVelocity * 100
	mRPM = ((maxRPM*gears)/mRPM)*maxRPM
	
	repeat 
		if mRPM/curGear > maxRPM*curRatio then 
			curRatio = curRatio+0.1/curGear
		else 
			ratios[curGear] = curRatio*0.95
			curGear = curGear+1
			curRatio = 0
		end
	until #ratios == gears 

	ratios[0] = 0 
	ratios[-1] = ratios[1] 
	
	--[[
	ratios[0] = 0
	for gear=1, gears do
		if gear > 1 then 
			c = c - c*(gear*0.02)
		end 
		
		ratios[gear] = (c / gear)
	end
	ratios[-1] = ratios[1]
	--]]
	
	return ratios
end 

function updateEngines(dt)
	if not ENGINE_ENABLED then return end 
	
	local myVehicle = getPedOccupiedVehicle(localPlayer)
	if myVehicle and getVehicleController(myVehicle) ~= localPlayer then 
		myVehicle = false
	end 
	
	local cx, cy, cz = getCameraMatrix()
	local now = getTickCount()
	
	for vehicle, data in pairs(streamedVehicles) do 
		if isElement(vehicle) then
			local engine = getElementData(vehicle, "vehicle:engine")
			if engine then
				local x, y, z = getElementPosition(vehicle)
				local rx, ry, rz = getElementRotation (vehicle)
				local distance = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
				
				if getVehicleEngineState(vehicle) == true and distance < ENGINE_SOUND_DISTANCE*2 then
					local model = getElementModel(vehicle)
					local handling = getVehicleHandling(vehicle)
					local velocityVec = Vector3(getElementVelocity(vehicle))
					local velocity = velocityVec.length * 180
					local controller = getVehicleController(vehicle)
					
					local upgrades = getElementData(vehicle, "vehicle:upgrades") or {} 

					engine.gear = engine.gear or 1
					engine.turbo = upgrades.turbo
					engine.turbo_shifts = upgrades.turbo
					engine.volMult = engine.volMult or 1 
					engine.shiftUpRPM = engine.shiftUpRPM or engine.maxRPM*0.91
					engine.shiftDownRPM = engine.shiftDownRPM or (engine.idleRPM+engine.maxRPM)/2.5
					

					data.prevThrottle = data.throttle
					data.throttle = controller and (getPedControlState(controller, "accelerate"))
					
					if not data.reverse and velocity < 10 then
						data.reverse = controller and (getPedAnalogControlState(controller, "brake_reverse") > 0.5)or false
					elseif data.throttle and velocity < 50 then 
						data.reverse = false
					end
					
					local isSkidding = controller and ( ( getPedControlState(controller, "accelerate") and getPedControlState(controller, "brake_reverse") or getPedControlState(controller, "handbrake") ) and velocity < 40 ) or false
					data.forceNeutral = isSkidding -- w / s or handbrake without moving: neutral gear
								or (isLineOfSightClear(x, y, z, x, y, z-(getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)*1.25), true, false, false, true, true, false, false, vehicle) and data.throttle) -- vehicle in air: neutral gear
								or isElementFrozen(vehicle) or isElementInWater(vehicle) -- frozen / in water: neutral gear
								or (( rx > 110 ) and ( rx < 250 )) -- on roof: neutral gear
								
					data.groundRPM = data.groundRPM or 0
					data.throttlingRPM = data.throttlingRPM or 0
					data.previousGear = data.previousGear or engine.gear
					data.gear = data.gear or 1
					data.currentGear = data.currentGear or 1
					data.changingGear = type(data.changingGear) == "number" and data.changingGear or false
					data.changingRPM = data.changingRPM or 0
					data.changingTargetRPM = data.changingTargetRPM or 0 
					data.turboValue = data.turboValue or 0
					data.prevTurboValue = data.turboValue
					data.als = true --upgrades.als or false
					--data.effects = data.effects or {} 
					
					local changedGear = false 
					
					local gearRatios = calculateGearRatios(vehicle, engine.maxRPM, engine.startRatio or 1)
					local soundPack = engine.soundPack
					local wheel_rpm = velocity*100
					
					local rpm = wheel_rpm -- engine rpm
					
					--if data.reverse then 
						--data.currentGear = -1
					--end
					
					-- calculating rpm + neutral gear
					if getVehicleController(vehicle) then
						rpm = rpm*gearRatios[data.gear]
					else 
						rpm = engine.idleRPM 
					end 
					
					if not data.forceNeutral then
						data.throttlingRPM = math.max(0, data.throttlingRPM - (engine.maxRPM*0.0012)*dt)
					else 
						if data.throttle then 
							data.throttlingRPM = data.throttlingRPM + (engine.maxRPM*0.0012)*dt
						else 
							data.throttlingRPM = math.max(0, data.throttlingRPM - (engine.maxRPM*0.0012)*dt)
						end 
						data.throttlingRPM = math.min(data.throttlingRPM, engine.maxRPM)
					end 			
					rpm = rpm+data.throttlingRPM
					
					-- smooth rpm change
					rpm = rpm+data.changingRPM
					if data.changingGear then
						local progress = (now-data.changingTargetRPM.time) / 300 -- how long
						data.changingRPM = interpolateBetween(data.changingTargetRPM.target, 0, 0, 0, 0, 0, progress, "InQuad")
						
						if progress >= 1 then
							data.changingGear = false
							data.changingGearDirection = false
							data.changingRPM = 0
							data.changingTargetRPM = false
						end
					end 
					
					if data.previousGear ~= data.currentGear then 
						changedGear = (data.currentGear < data.previousGear) and "down" or "up"
												
						data.changingGear = data.currentGear
						data.changingGearDirection = changedGear 
						
						local nextrpm = engine.maxRPM
						if gearRatios[data.changingGear] then
							nextrpm = wheel_rpm*gearRatios[data.changingGear]
						end
						data.changingRPM = rpm-nextrpm
						data.changingTargetRPM = {target=data.changingRPM, time=now}
						
						data.gear = data.currentGear
						data.turboValue = 0
					end 
					
					-- prev gear update
					data.previousGear = data.currentGear 
					
					-- change gears
					if not data.changingGear and data.throttlingRPM == 0 and wheel_rpm > 200 then
						if rpm > engine.shiftUpRPM and data.throttle then 
							data.currentGear = math.min(data.currentGear+1, math.max(4, getVehicleHandling(vehicle).numberOfGears))
						elseif rpm < engine.shiftDownRPM then
							data.currentGear = math.max(1, data.currentGear-1)
						end 
					end 
					
					-- rev limiter
					if rpm < engine.idleRPM then 
						rpm = engine.idleRPM+math.random(0,100)
					elseif rpm > engine.maxRPM then 
						rpm = engine.maxRPM-math.random(0,100)
						data.wasRevLimited = true
					end
					
					-- ALS (отстрелы)
					data.activeALS = false

					if VEHICLES_BLOWOFF_ENABLED[model] then
						if data.wasRevLimited then -- when using throttle
							if (data.rpm or 0) < engine.maxRPM*0.98 then 
								data.wasRevLimited = false
								if data.als then 
									data.activeALS = true
								end
							end
						else 
							if changedGear == "up" and math.random(1, 4) == 1 then -- randomly with gear change
								if data.als then 
									data.activeALS = true
								end
							elseif data.prevThrottle and not data.throttle and data.rpm > engine.maxRPM*0.5 and math.random(1, 2) == 1 then 
								if data.als then 
									data.activeALS = true
								end
							end
						end
					end

					-- save rpm
					data.rpm = rpm 
					
					-- turbo 
					if engine.turbo then
						if data.throttle and rpm > engine.maxRPM/2 then 
							data.turboValue = math.min(0.5, data.turboValue+ 0.0008*dt)
						else 
							data.turboValue = math.max(0, data.turboValue - 0.0005*dt)
						end 
					end 
					
					-- sounds
					local svol = {}
					if not data.sounds then 
						data.sounds = {} 
						data.sounds[1] = playSound3D("sounds/"..soundPack.."/1.wav", x, y, z, true)
						data.sounds[2] = playSound3D("sounds/"..soundPack.."/2.wav", x, y, z, true)
						data.sounds[3] = playSound3D("sounds/"..soundPack.."/3.wav", x, y, z, true)
						data.sounds[4] = playSound3D("sounds/turbo.wav", x, y, z, true)
						
						for i=1, 3 do 
							setSoundEffectEnabled(data.sounds[i], "compressor", true)
						end 
					else 			
						-- engine
						local minMidProgress = math.min(1, (rpm+500)/(engine.maxRPM/2))
						local maxMidProgress = minMidProgress - ((engine.maxRPM/2)/rpm)
						
						local highProgress = (rpm-(engine.maxRPM/2.2))/(engine.maxRPM/2.2)
						
						svol[1] = 1 - 2^(rpm/(engine.idleRPM*1.5) - 2)
						svol[2] =  minMidProgress < 1 and interpolateBetween(0, 0, 0, 0.8, 0, 0, minMidProgress, "InQuad") or interpolateBetween(0.8, 0, 0, 0, 0, 0, maxMidProgress, "OutQuad")
						svol[3] =  interpolateBetween(0, 0, 0, 1, 0, 0, highProgress, "OutQuad")
						
						
						local vol = svol[1]
						vol = vol*ENGINE_VOLUME_MASTER*engine.volMult
						if data.throttle then 
							vol = vol*ENGINE_VOLUME_THROTTLE_BOOST
						end 
						
						setSoundVolume(data.sounds[1], math.max(0, vol))
						setSoundSpeed(data.sounds[2], rpm/(engine.idleRPM*2))
						
						local vol = svol[2]
						vol = vol*ENGINE_VOLUME_MASTER*engine.volMult
						if data.throttle then 
							vol = vol*ENGINE_VOLUME_THROTTLE_BOOST
						end 
						
						if data.changingGearDirection == "up" and vol > 0.1 then 
							vol = vol/2
						end
						
						setSoundVolume(data.sounds[2], math.max(0, vol))
						setSoundSpeed(data.sounds[2], rpm/(engine.maxRPM*0.6))

						local vol = svol[3]
						vol = vol*ENGINE_VOLUME_MASTER*engine.volMult
						if data.throttle then 
							vol = vol*ENGINE_VOLUME_THROTTLE_BOOST
						end 
						
						if data.changingGearDirection == "up" and vol > 0.1 then 
							vol = vol/2
						end
						
						setSoundVolume(data.sounds[3], math.max(0, vol))
						setSoundSpeed(data.sounds[3], rpm/(engine.maxRPM*0.925))
					
						svol[4] = data.turboValue
							
						local vol = svol[4]*ENGINE_VOLUME_MASTER
							
						if data.throttle then 
							vol = vol*ENGINE_VOLUME_THROTTLE_BOOST
						end
							
						setSoundVolume(data.sounds[4], math.max(0, vol*0.9))
						setSoundSpeed(data.sounds[4], svol[4]+0.8)
						
						if ((changedGear == "up" and data.prevTurboValue > 0.2) or (not data.throttle and data.prevTurboValue > 0.2)) and engine.turbo_shifts then
							local sound = 1 
							if changedGear then 
								sound = changedGear and changedGear == "up" and tostring(2) or tostring(1)
							end 
							
							data.sounds[5] = playSound3D("sounds/turbo_shift"..sound..".wav", x, y, z, false)
							setSoundVolume(data.sounds[5], 0.6*ENGINE_VOLUME_MASTER)
							
							if not data.throttle then 
								data.turboValue = 0
							end
						end
						
						if data.activeALS and not isElement(data.sounds[6]) then 
							data.sounds[6] = playSound3D("sounds/als"..math.random(1, 13)..".wav", x, y, z, false)
							setSoundVolume(data.sounds[6], 0.8)
							setSoundSpeed(data.sounds[6], 1.1)
							--setSoundEffectEnabled(data.sounds[6], "reverb", true)
							setSoundEffectEnabled(data.sounds[6], "echo", true)
							setSoundEffectEnabled(data.sounds[6], "compressor", true)
							
							addBlowOff(vehicle, Vector3(vehicle.position))
						
							data.activeALS = false
						end
						
						for i=1, #data.sounds do
							local v = data.sounds[i] 
							if isElement(v) then
								setElementPosition(v, x, y, z)
								setElementDimension(v, (svol[i] or 1) > 0 and getElementDimension(vehicle) or ENGINE_SOUND_FADE_DIMENSION)

								if vehicle == getPedOccupiedVehicle(localPlayer) then 
									setSoundMaxDistance(v, ENGINE_SOUND_DISTANCE*2)
								else 
									setSoundMaxDistance(v, ENGINE_SOUND_DISTANCE)
								end
							end
						end

						local vehicleBlowoff = VehiclesBlowoff[vehicle]
						if vehicleBlowoff then
							local rx, ry, rz = getElementRotation(vehicle)
							for fx, position in pairs(vehicleBlowoff) do
								local x, y, z = getPositionFromElementOffset(vehicle, position.x, position.y, position.z)
								setElementPosition(fx, x, y, z)
								setElementRotation(fx, 90-rx, 0-ry, 180-rz)
							end
						end
					end 
										
					if DEBUG and vehicle == myVehicle then
						dxDrawText("Silnik\nTyp: "..tostring(engine.name).."\nRPM: "..tostring(rpm).."\nVol1: "..tostring(svol[1]).."\nVol2: "..tostring(svol[2]).."\nVol3: "..tostring(svol[3]).."\nTurboVol: "..tostring(svol[4]), 300, 300)
						
						local t = "Biegi\nBieg: "..tostring(data.gear).."/"..tostring(#gearRatios).."\n"
						for k, v in ipairs(gearRatios) do 
							t = t.."Ratio "..tostring(k)..": "..v.."\n"
						end
						dxDrawText(t, 300, 440)
						
					end
				else 
					if data.sounds then 
						for k, v in ipairs(data.sounds) do 
							if isElement(v) then 
								destroyElement(v)
							end
						end
						data.sounds = false
					end
					
					data.rpm = 0
					data.gear = 1
					data.previousGear = 0
				end
			end
		end
	end
end 
addEventHandler("onClientPreRender", root, updateEngines)

function streamInVehicle(vehicle)
	if not streamedVehicles[vehicle] then
		if isElement(vehicle) and getElementData(vehicle, "vehicle:engine") then 
			streamedVehicles[vehicle] = {}
			addEventHandler("onClientElementDestroy", vehicle, function()
				streamOutVehicle(source)
			end)
		end
	end
end

function streamOutVehicle(vehicle)
	if streamedVehicles[vehicle] then 
		if streamedVehicles[vehicle].sounds then 
			for k, v in ipairs(streamedVehicles[vehicle].sounds) do 
				if isElement(v) then 
					destroyElement(v)
				end
			end
		end 
		
		streamedVehicles[vehicle] = nil
	end
end

function toggleGTAEngineSounds(bool)
	setWorldSoundEnabled(7, bool)
	setWorldSoundEnabled(8, bool)
	setWorldSoundEnabled(9, bool)
	setWorldSoundEnabled(10, bool)
	setWorldSoundEnabled(11, bool)
	setWorldSoundEnabled(12, bool)
	setWorldSoundEnabled(13, bool)
	setWorldSoundEnabled(14, bool)
	setWorldSoundEnabled(15, bool)
	setWorldSoundEnabled(16, bool)
	setWorldSoundEnabled(40, bool)
end 

function getGTARPM(vehicle) 
    if (vehicle) then   
		local velocityVec = Vector3(getElementVelocity(vehicle))
		local velocity = velocityVec.length * 180
					
        if (isVehicleOnGround(vehicle)) then
            if (getVehicleEngineState(vehicle) == true) then
                if(getVehicleCurrentGear(vehicle) > 0) then
                    vehicleRPM = math.floor(((velocity/getVehicleCurrentGear(vehicle))*150) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 8000) then
                        vehicleRPM = 8000
                    end
                else
                    vehicleRPM = math.floor(((velocity/1)*220) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 8000) then
                        vehicleRPM = 8000
                    end
                end
            else
                vehicleRPM = 0
            end
        else   
            if (getVehicleEngineState(vehicle) == true) then
                vehicleRPM = vehicleRPM - 150
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 8000) then
                    vehicleRPM = 8000
                end
            else
                vehicleRPM = 0
            end
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

-- EKSPORT 
function getVehicleRPM(vehicle)
	if streamedVehicles[vehicle] then 
		return streamedVehicles[vehicle].rpm or getGTARPM(vehicle)
	else 
		return getGTARPM(vehicle)
	end
end 

function getVehicleGear(vehicle)
	if streamedVehicles[vehicle] then 
		return streamedVehicles[vehicle].gear or getVehicleCurrentGear(vehicle)
	else 
		return getVehicleCurrentGear(vehicle)
	end
end

function toggleEngines(bool)
	ENGINE_ENABLED = bool
	toggleGTAEngineSounds(not ENGINE_ENABLED)
	
	if bool == true then
		for k, v in ipairs(getElementsByType("vehicle", root, true)) do 
			streamInVehicle(v)
		end
	else
		for vehicle, data in pairs(streamedVehicles) do 
			streamOutVehicle(vehicle)
		end
		streamedVehicles = {}
	end
end

addEvent("onClientRefreshEngineSounds", true)
addEventHandler("onClientRefreshEngineSounds", root, function()
	for _, v in pairs(streamedVehicles) do 
		for _, sound in pairs(v.sounds or {}) do 
			if isElement(sound) then 
				stopSound(sound)
			end
		end
		v.sounds = nil
	end
end)

addEventHandler("onClientElementStreamIn", root, 
	function()
		if getElementType(source) == "vehicle" then 
			streamInVehicle(source)
		end
	end
)

addEventHandler("onClientElementStreamOut", root, 
	function()
		streamOutVehicle(source)
	end
)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if seat == 0 then 
		setTimer(streamInVehicle, 200, 1, source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	toggleEngines(true)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k, v in pairs(streamedVehicles) do 
		if v.sounds and #v.sounds > 0 then 
			for _, sound in pairs(v.sounds) do 
				if isElement(sound) then 
					destroyElement(sound)
				end
			end
		end
	end
	
	toggleGTAEngineSounds(true)
end)

addEvent("openMusicGUI", true)
addEventHandler("openMusicGUI", root, function()
	iprint('openMusicGUI')
end)

addEvent("ceshMusicGUI", true)
addEventHandler("ceshMusicGUI", root, function()
	iprint('ceshMusicGUI')
end)