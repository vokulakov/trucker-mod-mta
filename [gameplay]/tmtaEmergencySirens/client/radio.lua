local RADIO_POLICE
local RADIO_POLICE_TIMER

local function generateNumber()
	return string.format("%03d", math.random(1, 66))
end

local function playPoliceRadio()
	RADIO_POLICE = playSound("assets/police_radio/Track_"..generateNumber()..".ogg", false)
	setSoundVolume(RADIO_POLICE, 0.5)
end

function startPoliceRadio()
	if isElement(RADIO_POLICE) then return end
	RADIO_POLICE_TIMER = setTimer(playPoliceRadio, POLICE_RADIO_TIME, 1)
end

function stopPoliceRadio()
	if isTimer(RADIO_POLICE_TIMER) then
		killTimer(RADIO_POLICE_TIMER)
	end

	if isElement(RADIO_POLICE) then
		stopSound(RADIO_POLICE)
	end
end

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if source == RADIO_POLICE then  
		local VEHICLE = getPedOccupiedVehicle(getLocalPlayer())
		if not VEHICLE then return end
		if getElementData(VEHICLE, "sirens.SOUND_STATE") and getElementData(VEHICLE, "sirens.QUACK_STATE") then return end
		RADIO_POLICE_TIMER = setTimer(playPoliceRadio, POLICE_RADIO_TIME, 1)
	end
end)