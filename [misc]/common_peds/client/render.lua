
function getScaleFromDistance(distance, mindist, maxdist)
	local progress = distance - mindist
	local scale = progress/(maxdist - mindist)
	return math.clamp(1 - scale, 0, 1)
end


function renderPed(ped)

	local x,y,z = getElementPosition(ped)
	local cx,cy,cz = getCameraMatrix()
	local px,py,pz = getElementPosition(localPlayer)

	if ped:getData('attach') then

		local r = findRotation(px, py, x,y)
		setElementRotation(ped, 0, 0, r + 180)

	end

	local distance = getDistanceBetweenPoints3D(x,y,z, cx,cy,cz)
	local scale = getScaleFromDistance(distance, 5, 20)
	local dx,dy = getScreenFromWorldPosition(x,y,z+1.1 + (0.4)*(1-scale))

	if dx and dy and distance < 15 then
	end 

	--[[
	local text = ped:getData('3dText')
	if text then

		local distance = getDistanceBetweenPoints3D(x,y,z, cx,cy,cz)

		local scale = getScaleFromDistance(distance, 5, 20)
		
		local dx,dy = getScreenFromWorldPosition(x,y,z+1.1 + (0.4)*(1-scale))

		if dx and dy and distance < 15 then

			dxDrawTextShadow(text,
				dx,dy,dx,dy,
				tocolor(255,255,255,255*scale),
				1, getFont('proximanova_semibold_italic', 18, 'light', true),
				'center', 'center', 1, tocolor(0, 0, 0, 50*scale), false, dxDrawText
			)

		end

	end
	]]

end

addEventHandler('onClientRender', root, function()

	for _, ped in pairs( getElementsByType('ped', resourceRoot, true) ) do

		if isElementOnScreen(ped) then
			renderPed(ped)
		end

	end

end)