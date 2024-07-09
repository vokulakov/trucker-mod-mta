local debugDrawEnabled = false --false
local screenWidth, screenHeight = guiGetScreenSize()
local mapSize  = 700
local gridSize = 35

local function draw()
	local x, y = (screenWidth - mapSize) / 2, (screenHeight - mapSize) / 2
	local size = math.floor(mapSize / gridSize)

	dxDrawImage(x, y, mapSize, mapSize, "world_map.png")
	for my = 1, gridSize do
		for mx = 1, gridSize do
			local temp, rain, wind = getCustomWeather(mx/gridSize*6000-3000, 3000-my/gridSize*6000)
			local c1 = tocolor(0, 255, 0, 100 * wind)
			local c2 = tocolor(255, 150, 0, 150 * temp)
			local c3 = tocolor(0, 150, 255, 200 * rain)
			dxDrawRectangle(x+(mx-1)*size,y+(my-1)*size,size,size,c1)
			dxDrawRectangle(x+(mx-1)*size,y+(my-1)*size,size,size,c2)
			dxDrawRectangle(x+(mx-1)*size,y+(my-1)*size,size,size,c3)
		end
	end
	local px, py = getCameraMatrix()
	dxDrawRectangle(x+(px+3000)/6000*mapSize-4, y+(-py+3000)/6000*mapSize-4, 8, 8, tocolor(255, 0, 0))
end

local function toggle()
	debugDrawEnabled = not debugDrawEnabled
	if debugDrawEnabled then
		addEventHandler("onClientRender", root, draw)
	else
		removeEventHandler("onClientRender", root, draw)
	end
end

--addCommandHandler("wdebug", toggle)
