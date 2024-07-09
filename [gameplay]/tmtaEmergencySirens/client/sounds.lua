local VEHICLES_SOUND = {}
VEHICLES_SOUND.SIR = {}
VEHICLES_SOUND.QUA = {}

local function createVehicleSound(veh, sound_url)
	local x, y, z = getElementPosition(veh)
	local SOUND = playSound3D("assets/sounds/"..sound_url, x, y, z, true)
	setSoundVolume(SOUND, 1.0)
	setSoundMaxDistance(SOUND, SOUND_MAX_DISTANCE) 
	attachElements(SOUND, veh)

	return SOUND
end

local function onVehicleSirens(veh)
	if getElementData(veh, "sirens.SOUND_STATE") then
		VEHICLES_SOUND.SIR[veh] = createVehicleSound(veh, 'sirens1.wav')
	else
		stopSound(VEHICLES_SOUND.SIR[veh])
		VEHICLES_SOUND.SIR[veh] = nil
	end
end

local function onVehicleQuack(veh)
	if getElementData(veh, "sirens.QUACK_STATE") then
		if not getVehicleSirensOn(veh) then
			VEHICLES_SOUND.QUA[veh] = createVehicleSound(veh, 'sirens2.wav')
		else 
			if VEHICLES_SOUND.SIR[veh] then 
				setSoundVolume(VEHICLES_SOUND.SIR[veh], 0.2) 
				VEHICLES_SOUND.QUA[veh] = createVehicleSound(veh, 'sirens3.wav')
			else
				VEHICLES_SOUND.QUA[veh] = createVehicleSound(veh, 'sirens2.wav')
			end
		end
	else
		if VEHICLES_SOUND.SIR[veh] then setSoundVolume(VEHICLES_SOUND.SIR[veh], 1.0) end
		stopSound(VEHICLES_SOUND.QUA[veh])
		VEHICLES_SOUND.QUA[veh] = nil
	end
end

addEventHandler("onClientElementDataChange", root, function(data)
	if not getElementType(source) == "vehicle" then return end
	if not POLICE_VEHICLE[getElementModel(source)] then return end

	if (data == 'sirens.SOUND_STATE') then
		onVehicleSirens(source)
	end

	if (data == 'sirens.QUACK_STATE') then
		onVehicleQuack(source)
	end

end)
