local function getPosToClipboard()
	local playerPos = Vector3(localPlayer.position)
	local position = string.format("{ x = %f, y = %f, z = %f }", playerPos.x, playerPos.y, playerPos.z)
	--local position = string.format("%.2f, %.2f, %.2f", playerPos.x, playerPos.y, playerPos.z)
	setClipboard(position)
	outputChatBox("Позиция "..position.." скопирована в буфер обмена", 0, 255, 0, true)
end
addCommandHandler("pos", getPosToClipboard)

--[[
addEventHandler ( "onClientRender", root,
	function()
		if isPedInVehicle ( localPlayer ) and getPedOccupiedVehicle ( localPlayer ) then
			local veh = getPedOccupiedVehicle ( localPlayer )
			for v in pairs ( getVehicleComponents(veh) ) do
				local x,y,z = getVehicleComponentPosition ( veh, v, "world" )
				local wx,wy,wz = getScreenFromWorldPosition ( x, y, z )
				if wx and wy then
					dxDrawText ( v, wx -1, wy -1, 0 -1, 0 -1, tocolor(0,0,0), 1, "default-bold" )
					dxDrawText ( v, wx +1, wy -1, 0 +1, 0 -1, tocolor(0,0,0), 1, "default-bold" )
					dxDrawText ( v, wx -1, wy +1, 0 -1, 0 +1, tocolor(0,0,0), 1, "default-bold" )
					dxDrawText ( v, wx +1, wy +1, 0 +1, 0 +1, tocolor(0,0,0), 1, "default-bold" )
					dxDrawText ( v, wx, wy, 0, 0, tocolor(0,255,255), 1, "default-bold" )
				end
			end
		end
	end
)

addCommandHandler('comps',
    function(command, lib, name)
       for v in pairs ( getVehicleComponents(getPedOccupiedVehicle(localPlayer)) ) do
		outputChatBox(tostring(v))
	   end
    end
)
]]