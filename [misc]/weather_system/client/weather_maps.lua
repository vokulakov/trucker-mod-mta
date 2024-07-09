local weatherMaps = {}

local function loadWeatherMap(name)
	if type(name) ~= "string" then
		return
	end

	local texture = dxCreateTexture(name .. "_map.png")
	local width, height = dxGetMaterialSize(texture)
	local pixels = dxGetTexturePixels(texture)
	destroyElement(texture)

	local map = {}
	for x = 0, width - 1 do
		map[x + 1] = {}
		for y = 0, height - 1 do
			map[x + 1][y + 1] = dxGetPixelColor(pixels, x, y) / 255
		end
	end

	weatherMaps[name] = { size = width, values = map }
end

function getWeatherMapValue(name, x, y, ox, oy)
	if not x or not y then
		return false
	end
	local map = weatherMaps[name]
	x = math.floor((x + 3000) / 6000 * (map.size - 1))
	y = math.floor(map.size - (y + 3000) / 6000 * (map.size - 1))

	x = (x + math.floor(ox or 0)) % (map.size - 1)
	y = (y + math.floor(oy or 0)) % (map.size - 1)

	if x < 0 then x = x + map.size - 1 end
	if y < 0 then y = y + map.size - 1 end

	return map.values[x + 1][y + 1]
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	loadWeatherMap("rain")
	loadWeatherMap("temp")
	loadWeatherMap("wind")
end)
