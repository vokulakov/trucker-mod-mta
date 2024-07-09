local STREAMED_MARKERS = {}
local marker_texture = dxCreateTexture("img.png")

local function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... )
    return dxDrawMaterialLine3D( x, y, z, x + width, y + height, z + tonumber( rotation or 0 ), material, height, color or 0xFFFFFFFF, ... )
end

addEventHandler("onClientPreRender", root, function()
	for _, marker in pairs(STREAMED_MARKERS) do
		local r, g, b, a = marker:getColor()
		if a > 0 and isElement(marker) then
			local x, y, z = getElementPosition(marker)
			local size = marker.size
			if a ~= 65 then
				marker:setColor(r, g, b, 65)
			end
			dxDrawMaterialLine3D (x + size/2.5, y + size/2.5, z + 0.01, x - size/2.5, y - size/2.5, z + 0.01, marker_texture, size/2.5 * 3, tocolor(r, g, b), x, y, z + 1)
		end
	end 
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "marker" and source.markerType == "cylinder" then
		STREAMED_MARKERS[source] = source
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "marker" and STREAMED_MARKERS[source] then
		STREAMED_MARKERS[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "marker" and STREAMED_MARKERS[source] then
		STREAMED_MARKERS[source] = nil
	end
end)