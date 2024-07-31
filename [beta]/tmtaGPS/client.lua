GPS = {}

local sw, sh = guiGetScreenSize()
local texture_point = dxCreateTexture("assets/iPoint.png", "argb", false, "clamp")

local zoom = 1
local baseX = 1920
local minZoom = 2

if sw < baseX then
	zoom = math.min(minZoom, baseX/sw)
end

local w, h = 64/zoom, 64/zoom
local currentPoint = nil

function GPS.drawPoint()
	if not isElement(currentPoint) then 
		return
	end

	local x,y,z = getElementPosition(currentPoint)
	local sx,sy = getScreenFromWorldPosition(x, y, z)
	local rx,ry,rz = getElementPosition(localPlayer)
	local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)

	local dist = 2	

	if (sx and sy and distance > dist) then
		local text = tostring(Utils.convertNumber(math.floor(distance))) .. " м"
		dxDrawImage(sx-(w/1.7), sy-120/zoom, w, h, texture_point, 0, 0, 0, tocolor(255, 255, 255, 255), false)	
		dxDrawText(text, sx-10/zoom+1, sy-45/zoom+1, sx+1, sy+1, tocolor(0, 0, 0, 255), 1.5, "default-bold", "center", "top")
		dxDrawText(text, sx-10/zoom, sy-45/zoom, sx, sy, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "top")
		dxDrawText("Cледуйте к этой метке", sx-10+1, sy-5+1, sx+1+1, sy+1+1, tocolor(0, 0, 0, 125), 1, "default-bold", "center", "top")
		dxDrawText("Cледуйте к этой метке", sx-10, sy-5, sx+1, sy+1, tocolor(255, 255, 255, 125), 1, "default-bold", "center", "top")
	end
end
addEventHandler("onClientRender", root, GPS.drawPoint)

function GPS.addPoint(element)
	currentPoint = element
end
addEvent("tmtaGPS.addPoint", true)
addEventHandler("tmtaGPS.addPoint", root, GPS.addPoint)

addPoint = GPS.addPoint

-- Utils
Utils = {}

function Utils.convertNumber(number)
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k == 0) then
			break
		end
	end
	return formatted
end