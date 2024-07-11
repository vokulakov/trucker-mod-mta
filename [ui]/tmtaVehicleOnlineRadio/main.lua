local sW, sH = guiGetScreenSize()

local sDW, sDH = exports.tmtaUI:getScreenSize()
local Width, Height = 500, 120
local posX, posY = (sDW-Width) /2, 10

local vehicles = {}

local RADIO_STATIONS = getStationsList()
local CURRENT_RADIO_IND = 1

local SOUND_TIMER = nil
local SHOW_TIMER = nil
local SOUND_TUNE = nil
local SOUND_RADIO = nil

local SHOW_RADIO_UI = false

local FONTS = { 
	['TITTLE'] = exports.tmtaFonts:createFontDX("RobotoBold", 12),
	['INFO'] = exports.tmtaFonts:createFontDX("RobotoRegular", 11)
}

local function showRadioSwitch()
	if not exports.tmtaUI:isPlayerComponentVisible("radio") or not SHOW_RADIO_UI then
        return
    end

	local veh = getPedOccupiedVehicle(localPlayer) 
	if not veh then return end

	local radio = RADIO_STATIONS[CURRENT_RADIO_IND]
	if type(radio) == 'number' then
		-- Радио выключено
		return 
	end

	dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((Height) /sDW), sH*((Height) /sDH), tocolor(33, 33, 33, 255), false)
	dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((Width) /sDW), sH*((Height) /sDH), tocolor(33, 33, 33, 200), false)

	-- ICON
	dxDrawImage(sW*((posX+5) /sDW), sH*((posY+5) /sDH), sW*((Height-10) /sDW), sH*((Height-10) /sDH), radio.logo, 0, 0, 0, tocolor(255, 255, 255, 255))

	-- RADIO NAME
	dxDrawText(radio.name, sW*((posX+Height+10) /sDW), sH*((posY+25) /sDH), sW*((posX+Width) /sDW), 0, tocolor(255, 255, 255, 255), sW/sDW*1.0, FONTS['TITTLE'], 'left', 'top', false, true)

	-- MetaTags
	local tittle = 'Название трека неизвестно'

	if isElement(SOUND_RADIO) then
		local sound_meta = getSoundMetaTags(SOUND_RADIO)
		if sound_meta.stream_title then
			tittle = sound_meta.stream_title  
		end
	end
	
	dxDrawText(tittle, sW*((posX+Height+10) /sDW), sH*((posY+50) /sDH), sW*((posX+Width) /sDW), sH*((posY+Height) /sDH), tocolor(255, 255, 255, 175), sW/sDW*1.0, FONTS['INFO'], 'left', 'top', true, true)

	-- Sound Wave
	local samples = 256
	local r, g, b

	if isElement(SOUND_RADIO) then 
		local waveData = getSoundWaveData(SOUND_RADIO, samples)
		for index = 0, samples - 1 do
			if waveData then
				local colorFactor = index / samples
				r, g, b = 242, 171 * (1 - colorFactor), 18 * colorFactor
				local offsetPosX = Height+10 + ((Width-Height)-20)*colorFactor
				dxDrawRectangle(sW*((posX+offsetPosX) /sDW), sH*((posY + Height-5) /sDH), 1, sH*((math.abs(waveData[index]) * -28) /sDH), tocolor(r, g, b, 255))
			end
		end
	end

end
addEventHandler("onClientHUDRender", root, showRadioSwitch)

addEventHandler("onClientSoundChangedMeta", root, 
	function()
		if not isElement(SOUND_RADIO) or source ~= SOUND_RADIO then
			return
		end

		SHOW_RADIO_UI = true
		exports.tmtaUI:setPlayerComponentVisible("driftpoints", false)

		SHOW_TIMER = setTimer(function()
			exports.tmtaUI:setPlayerComponentVisible("driftpoints", true)
			SHOW_RADIO_UI = false
		end, 8000, 1)

	end
)

local function stopRadio()
	if isElement(SOUND_RADIO) then 
		destroyElement(SOUND_RADIO)
	end

	if isTimer(SOUND_TIMER) then
		killTimer(SOUND_TIMER)
		if isElement(SOUND_TUNE) then
			stopSound(SOUND_TUNE)
		end
	end

	if isTimer(SHOW_TIMER) then
		killTimer(SHOW_TIMER)
		exports.tmtaUI:setPlayerComponentVisible("driftpoints", true)
		SHOW_RADIO_UI = false
	end
end

local function onPlayerRadioSwitch()
	
	stopRadio()

	if CURRENT_RADIO_IND == 1 then -- ВЫКЛЮЧИТЬ РАДИО
		return
	end

	if not isElement(SOUND_TUNE) then
		SOUND_TUNE = exports.tmtaSounds:playSound('veh_radio_tune', false)

		if not SHOW_RADIO_UI then
			SHOW_RADIO_UI = true
			exports.tmtaUI:setPlayerComponentVisible("driftpoints", false)
		end

		SOUND_TIMER = setTimer(
			function()
				stopSound(SOUND_TUNE)

				local radio = RADIO_STATIONS[CURRENT_RADIO_IND]
	
				if isElement(SOUND_RADIO) then 
					destroyElement(SOUND_RADIO) 
				end

				if type(radio) == 'number' then return end

				SOUND_RADIO = playSound(radio.url)
				setSoundVolume(SOUND_RADIO, 1.0)

				SHOW_TIMER = setTimer(function()
					exports.tmtaUI:setPlayerComponentVisible("driftpoints", true)
					SHOW_RADIO_UI = false
				end, 8000, 1)

			end, 2000, 1)

	end

end 

local function onRadioNext()
	local vehicle = localPlayer.vehicle
    if not isElement(vehicle) or vehicle.controller ~= localPlayer then
        return
    end

	if localPlayer.interior ~= 0 then
		return
	end

	local nextIndex = ((CURRENT_RADIO_IND)%(#RADIO_STATIONS))+1
	CURRENT_RADIO_IND = nextIndex
	vehicle:setData("radioStation", tonumber(CURRENT_RADIO_IND))
end
bindKey("5", "down", onRadioNext)

local function onRadioPrevios()
	local vehicle = localPlayer.vehicle
    if not isElement(vehicle) or vehicle.controller ~= localPlayer then
        return
    end

	if localPlayer.interior ~= 0 then
		return
	end

	local nextIndex = ((CURRENT_RADIO_IND-2)%(#RADIO_STATIONS))+1
    CURRENT_RADIO_IND = nextIndex
	vehicle:setData("radioStation", tonumber(CURRENT_RADIO_IND))
end
bindKey("4", "down", onRadioPrevios)

addEventHandler("onClientElementDataChange", root, function(dataName, _, value)
	local vehicle = source
	if isElement(vehicle) and getElementType(vehicle) == "vehicle" and dataName == "radioStation" then
	    if not isElement(vehicle) or vehicle ~= localPlayer.vehicle then
			return
		end
		if value then
			CURRENT_RADIO_IND = value
			onPlayerRadioSwitch()
		end
	end
end)

addEventHandler('onClientPlayerVehicleEnter', root, function(veh, seat)
	if source ~= localPlayer then return end
	setRadioChannel(0)
	CURRENT_RADIO_IND = veh:getData('radioStation') or 1
	onPlayerRadioSwitch()
end)

addEventHandler('onClientVehicleExit', root, function(player, seat)
	if player ~= localPlayer then return end
	stopRadio()
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if player ~= localPlayer then return end
	stopRadio()
end)

addEventHandler("onClientElementDestroy", root, function()
	if source and getElementType(source) == "vehicle" then
		if source == getPedOccupiedVehicle(localPlayer) then
			if isElement(SOUND_RADIO) then 
				stopRadio()
			end
		end
	end
end)

addEventHandler("onClientVehicleExplode", root, function()
	if source and getElementType(source) == "vehicle" then
		if source == getPedOccupiedVehicle(localPlayer) then
			if isElement(SOUND_RADIO) then 
				stopRadio()
			end
		end
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if isElement(SOUND_RADIO) then 
		stopRadio()
	end
end)

addEventHandler("onClientPlayerRadioSwitch", localPlayer, function(station) 
	if station ~= 0 then 
		cancelEvent() 
	end 
end)

-- События на вход в покраску, тюнинг
addEventHandler("tmtaVehPaint.onPlayerEnterGarage", root, stopRadio)
addEventHandler("tmtaVehPaint.onPlayerExitGarage", root, onPlayerRadioSwitch)
addEventHandler("tmtaVehTuning.onPlayerEnterGarage", root, stopRadio)
addEventHandler("tmtaVehTuning.onPlayerExitGarage", root, onPlayerRadioSwitch)