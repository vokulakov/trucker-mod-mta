local p_lights = {}
local p_timer = {}
local p_lvar = {}
local p_pvar = {}
local p_lvar2 = {}
local p_lvar3 = {}
local p_lvar4 = {}

-- Мигалка
local function setVehicleFlashers(vehicle)
	if not getVehicleSirensOn(vehicle) then
		setVehicleSirensOn(vehicle, true)
		toggleLights(vehicle, math.random(1,2))
	else
		setVehicleSirensOn(vehicle, false)
		destroyStrobe(vehicle)
	end
end
addEvent( "sirens.setVehicleFlashers", true)
addEventHandler( "sirens.setVehicleFlashers", root, setVehicleFlashers)

-- Стробоскопы
function toggleLights(veh, level)
	local level = tonumber(level)
	if (level == 1) then
		if (p_lights[veh] == 0) or(p_lights[veh] == nil) then
			p_pvar[veh] = 1
			p_lights[veh] = 1
			setVehicleOverrideLights ( veh, 2 )
			p_timer[veh] = setTimer(
			function()
				if(p_lvar[veh] == 0) or (p_lvar[veh] == nil) then
					p_lvar[veh] = 1
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 0, 1)
					setVehicleLightState ( veh, 3, 1)
					setVehicleHeadLightColor(veh, 0, 0, 255)
				else
					setVehicleLightState ( veh, 3, 0)
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 1)
					setVehicleLightState ( veh, 2, 1)	
					setVehicleHeadLightColor(veh, 255, 0, 0)
					p_lvar[veh] = 0
				end
			end, 500, 0)
		else
			p_lights[veh] = 0
			killTimer(p_timer[veh])
			setVehicleLightState ( veh, 0, 0)
			setVehicleLightState ( veh, 1, 0)
			setVehicleLightState ( veh, 2, 0)
			setVehicleLightState ( veh, 3, 0)	
			setVehicleHeadLightColor(veh, 255, 255, 255)
			setVehicleOverrideLights ( veh, 2 )
		end
		elseif(level == 2) then
			if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
				p_lights[veh] = 1
				setVehicleOverrideLights ( veh, 2 )
				p_timer[veh] = setTimer(
				function()
					if(p_lvar3[veh] == 4) then
						setTimer(function() p_lvar3[veh] = 0 end, 1000, 1)
						setTimer(
						function()
							if(p_lvar4[veh] == 1)then
								p_lvar4[veh] = 0
								setVehicleLightState ( veh, 1, 0)
								setVehicleLightState ( veh, 2, 0)
								setVehicleLightState ( veh, 0, 1)
								setVehicleLightState ( veh, 3, 1)
								setVehicleHeadLightColor(veh, 77, 77, 255)
							else
								setVehicleLightState ( veh, 3, 0)
								setVehicleLightState ( veh, 0, 0)
								setVehicleLightState ( veh, 1, 1)
								setVehicleLightState ( veh, 2, 1)	
								setVehicleHeadLightColor(veh, 255, 77, 77)
								p_lvar4[veh] = 1
							end
						end, 50, 5)
				return end
				if (p_lvar2[veh] == 0) or (p_lvar2[veh] == nil) then
					p_lvar2[veh] = 1
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 0, 1)
					setVehicleLightState ( veh, 3, 1)
					setVehicleHeadLightColor(veh, 0, 0, 255)
				else
					setVehicleLightState ( veh, 3, 0)
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 1)
					setVehicleLightState ( veh, 2, 1)	
					setVehicleHeadLightColor(veh, 255, 0, 0)
					p_lvar2[veh] = 0
				end
			if (p_lvar3[veh] == nil) then p_lvar3[veh] = 0  end
				p_lvar3[veh] = (p_lvar3[veh]+1)
			end, 500, 0)
		else
			p_lights[veh] = 0
			killTimer(p_timer[veh])
			setVehicleLightState ( veh, 0, 0)
			setVehicleLightState ( veh, 1, 0)
			setVehicleLightState ( veh, 2, 0)
			setVehicleLightState ( veh, 3, 0)	
			setVehicleHeadLightColor(veh, 255, 255, 255)
			setVehicleOverrideLights ( veh, 2 )
		end
	end
end

function destroyStrobe(vehicle)
	if (p_lights[vehicle] == 1) then
		p_lights[vehicle] = 0
		killTimer(p_timer[vehicle])
		setVehicleLightState(vehicle, 0, 0)
		setVehicleLightState(vehicle, 1, 0)
		setVehicleLightState(vehicle, 2, 0)
		setVehicleLightState(vehicle, 3, 0)	
		setVehicleHeadLightColor(vehicle, 255, 255, 255)
		setVehicleOverrideLights(vehicle, 2)
	end
end

addEventHandler("onVehicleExplode", getRootElement(), function()
	destroyStrobe(source)
end)

addEventHandler("onVehicleRespawn", getRootElement(), function()
	destroyStrobe(source)
end)

addEventHandler("onElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" then
		destroyStrobe(source)
	end
end)