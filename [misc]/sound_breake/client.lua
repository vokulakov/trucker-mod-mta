local sound
local carSounds = {}
local gearSounds = {}
local truckerVehicle = {  
	[515] = true,
    [403] = true, 
    [514] = true,
    [578] = true,
    --[[
    [422] = true, 
    [440] = true,
    [482] = true, 
    [414] = true,
    [605] = true,
    [543] = true,
    [499] = true,
    ]]
} -- список грузовиков, на которых будут работать звуки

-- звук тормоза
function startSound(vehicle)
	if not isElement(vehicle) then return true end
	if not isElement (carSounds[vehicle]) then
		local x,y,z = getElementPosition ( vehicle )
		local sound = playSound3D ( "sounds/blowoff.wav", x, y, z, false )
		setSoundMaxDistance(sound, 60)
		attachElements ( sound, vehicle )
		carSounds[vehicle] = sound
	end
end

addEventHandler( "onClientKey", root, function() 
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isElement(vehicle) then return true end
	local model = getElementModel ( vehicle )
	if truckerVehicle[model] then
		if getVehicleCurrentGear ( vehicle ) == 0 then return end
		if getControlState ( "brake_reverse" ) or getControlState ( "handbrake" ) then
			startSound(vehicle)
		end
    end
end)

-- звук переключения передач 
addEventHandler ("onClientRender", getRootElement(), function()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isElement(vehicle) then return true end
	local model = getElementModel ( vehicle )
	if truckerVehicle[model] then
		local lastGear = getElementData ( vehicle, "carsound:lastGear" ) or 1
		local curGear = getVehicleCurrentGear(vehicle)
		if lastGear < curGear then
			playGearSound(vehicle)
		end
		if lastGear > curGear then
			playGearSound(vehicle)
		end
		setElementData ( vehicle, "carsound:lastGear", curGear, false )
	end
end)

function playGearSound(vehicle)
	if isElement ( vehicle ) then
		if not isElement (gearSounds[vehicle]) then
			local x,y,z = getElementPosition ( vehicle )
			local model = getElementModel ( vehicle )
			local gearSound = playSound3D ( "sounds/gear.wav", x, y, z, false )
			setSoundMaxDistance(gearSound, 60)
			attachElements ( gearSound, vehicle )
			gearSounds[vehicle] = gearSound
		end
	end
end

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "vehicle" then
			if isElement (gearSounds[vehicle]) then 
				playGearSound(source)
			end
			if isElement (carSounds[vehicle]) then
				startSound(vehicle)
			end
        end
    end
)
