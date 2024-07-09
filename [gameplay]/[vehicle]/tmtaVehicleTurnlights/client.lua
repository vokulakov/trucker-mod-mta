local shader = {}
shader[1] = dxCreateShader("files/shader.fx") -- Blinkers
shader[2] = dxCreateShader("files/shader3.fx") -- Alternative blinkers
local animShads = {}

local tex_left = "leftflash" -- Левая сторона мигает текстуры
local tex_right = "rightflash" -- Правая сторона мигает текстуры
local tex_reverse = "vehiclelights128" -- Текста фары

local texturesLeft = {
	{"leftflash"},
	{"*turn_left*"},
}

local texturesRight = {
	{"*turn_right*"},
	{"rightflash"},
}

--[[
local soundTurnSignal
local turnSoundTimer 

local function playTurnSound()
	if isElement(soundTurnSignal) then
		destroyElement(soundTurnSignal)
	end
	
	soundTurnSignal = exports.tmtaSounds:playSound('veh_turnsignal')
end
]]

function getShaderType(veh)
	--[[
	if aVehicles[getElementModel(veh)] then 
		return 2 
	else 
		return 1
	end
	]]
	return 1
end

function updateShaders(veh)
	local state = getElementData(veh,"turnlight")
	local t = getShaderType(veh)

	--[[
	if not isTimer(turnSoundTimer) then
		playTurnSound()
		turnSoundTimer = setTimer(playTurnSound, 1200, 0)
	end
	]]

	if state == 0 then
		for i, v in ipairs (texturesLeft) do
			engineRemoveShaderFromWorldTexture( shader[t], v[1], veh )
		end
		for i, v in ipairs (texturesRight) do
			engineRemoveShaderFromWorldTexture( shader[t], v[1], veh )
		end

		if isTimer(turnSoundTimer) then 
			killTimer(turnSoundTimer)
		end 
		
		if isElement(soundTurnSignal) then
			destroyElement(soundTurnSignal)
		end
	elseif state == 1 then
		for i, v in ipairs (texturesLeft) do
			engineApplyShaderToWorldTexture( shader[t], v[1], veh )
		end	
		for i, v in ipairs (texturesRight) do
			engineRemoveShaderFromWorldTexture( shader[t], v[1], veh )
		end
	elseif state == 2 then
		for i, v in ipairs (texturesRight) do
			engineApplyShaderToWorldTexture( shader[t], v[1], veh )
		end
		for i, v in ipairs (texturesLeft) do
			engineRemoveShaderFromWorldTexture( shader[t], v[1], veh )
		end			
	elseif state == 3 then
		for i, v in ipairs (texturesLeft) do
			engineApplyShaderToWorldTexture( shader[t], v[1], veh )
		end				
		for i, v in ipairs (texturesRight) do
			engineApplyShaderToWorldTexture( shader[t], v[1], veh )
		end
	end
end

bindKey(",", "down",
	function()
		local vehicle = localPlayer.vehicle
		if not vehicle or vehicle.controller ~= localPlayer then
			return
		end
		local state = (vehicle:getData("turnlight") == 1) and 0 or 1
		vehicle:setData("turnlight", state, false)
	end
)


bindKey(".", "down",
	function()
		local vehicle = localPlayer.vehicle
		if not vehicle or vehicle.controller ~= localPlayer then
			return
		end
		local state = (vehicle:getData("turnlight") == 2) and 0 or 2
		vehicle:setData("turnlight", state, false)
	end
)

bindKey("/", "down",
	function()
		local vehicle = localPlayer.vehicle
		if not vehicle or vehicle.controller ~= localPlayer then
			return
		end
		local state = (vehicle:getData("turnlight") == 3) and 0 or 3
		vehicle:setData("turnlight", state, false)
	end
)

toggleControl("vehicle_look_right", false)
toggleControl("vehicle_look_left", false)

addEventHandler('onClientElementDataChange', root, 
	function(dataName, _, value)
		local vehicle = source
		if (isElement(vehicle) and getElementType(vehicle) == 'vehicle' and dataName == "turnlight") then
			local trailer = getVehicleTowedByVehicle(vehicle)
			if (isElement(trailer) and trailer:getData('isTrailer')) then
				trailer:setData("turnlight", value)
				updateShaders(trailer)
			end
			updateShaders(vehicle)
		end
	end
)

addEventHandler('onClientTrailerAttach', root, 
    function(truck)
		local trailer = source
		if (isElement(trailer) and trailer:getData('isTrailer') and getVehicleTowedByVehicle(truck) == trailer) then
			trailer:setData("turnlight", truck:getData("turnlight"))
			updateShaders(trailer)
		end
    end
)

addEventHandler('onClientTrailerDetach', root,
    function(truck)
		local trailer = source
		if (isElement(trailer) and trailer:getData('isTrailer')) then
			trailer:setData("turnlight", 0, false)
			updateShaders(trailer)
		end
    end
)