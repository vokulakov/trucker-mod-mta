g_Me = getLocalPlayer( );
g_Root = getRootElement( );
g_ResRoot = getResourceRootElement( );

addEventHandler( "onClientResourceStart", g_ResRoot,	function( )		
	bindKey( "vehicle_fire", "both", toggleNOS );		
	bindKey( "vehicle_secondary_fire", "both", toggleNOS );	
end)
local lastTick = getTickCount()
function calculateNitroSeconds()	
	if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end	
	local veh = getPedOccupiedVehicle(localPlayer)	
	if not veh then return end	
	local occupant = getVehicleOccupant(veh)	
	local nitroSeconds = getElementData(veh, 'nitro.seconds') or 0	
	local maxNitro = getElementData(veh, 'nitro.seconds.max') or 7000	
	local nitroState = getElementData(veh, 'nitro')	
	local deltaTick = getTickCount() - lastTick	
	local infiniteNitro = false	

	if nitroState and not infiniteNitro then		
		nitroSeconds = nitroSeconds - deltaTick		
		if nitroSeconds <= 0 then			
			nitroSeconds = 0			
			disableNitro(veh)		
		end		
		setElementData(veh, 'nitro.seconds', nitroSeconds, false)	
	else		
		if nitroSeconds < maxNitro then			
			nitroSeconds = nitroSeconds + math.floor(deltaTick/1.5)			
			if nitroSeconds >= maxNitro then				
				nitroSeconds = maxNitro			
			end			
			setElementData(veh, 'nitro.seconds', nitroSeconds, false)		
		end	
	end	
	lastTick = getTickCount()
end
addEventHandler('onClientRender', root, calculateNitroSeconds)

function enableNitro(veh)	
	setElementData(veh, 'nitro', true, false)
end

function disableNitro(veh)	
	setElementData(veh, 'nitro', false, false)	
	setPedControlState( "vehicle_fire", false )
end 

addEventHandler('onClientElementDataChange', root, function(dn)	
	if getElementType(source) ~= 'vehicle' then return end	
	if not isElementStreamedIn(source) then return end	
	if dn ~= 'nitro' then return end	
	if getElementData(source, 'nitro') then		
		addVehicleUpgrade( source, 1010 )	
	else		
		removeVehicleUpgrade( source, 1010 )
	end
end)

function toggleNOS( key, state )	
	if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end	
	local veh = getPedOccupiedVehicle( g_Me )	
	if getElementData(veh, 'nitroBlocked') then return end    
	local nitroSeconds = getElementData(veh, 'nitro.seconds') or 0	
	if veh then	    
		if nitroSeconds > 0 then			
			if state == "up" then				
				disableNitro(veh)			
			else				
				enableNitro(veh)			
			end	    
		end
	end
end