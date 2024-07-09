local serverTimestampOffset = 0
local isWeatherLocked = false

-- Останавливает динамическую смену погоды
function setWeatherLocked(locked, reset)
	isWeatherLocked = not not locked
	if isWeatherLocked and reset then
		setCustomWeather(0.5, 0, 0)
	end
end

function getWeatherLocked()
	return isWeatherLocked
end

function getCurrentMinute()
	local h, m = getTime()
	return h * 60 + m
end

-- Число от 0 до 1
-- 0 - полночь
-- 1 - полдень
function getDayMultiplier()
	local halfDay = 24 * 60 / 2
	return 1 - math.floor(math.abs(getCurrentMinute() - halfDay) / halfDay * 1000) / 1000
end

-- Возвращает цвет неба, основанный на текущем времени суток
function getBaseSkyGradient()
	return unpack(SkyGradients[getCurrentMinute() + 1])
end

function getBaseSunColor()
	return unpack(SunColors[getCurrentMinute() + 1])
end

function getGrayscaleColor(r, g, b, level)
	local grayscale = math.floor((r + g + b) / 3)
	r = r + (grayscale - r) * level
	g = g + (grayscale - g) * level
	b = b + (grayscale - b) * level
	return r, g, b
end

-- Эффект молнии
function flashSky()
	local r1, g1, b1, r2, g2, b2 = getSkyGradient()
	setSkyGradient(255, 255, 255, 255, 255, 255)
	setTimer(function ()
		setSkyGradient(r1, g1, b1, r2, g2, b2)

		if math.random() > 0.5 then
			setTimer(setSkyGradient, math.random(150, 200), 1, 255, 255, 255, 255, 255, 255)
			setTimer(setSkyGradient, 200 + math.random(30, 100), 1, r1, g1, b1, r2, g2, b2)
		end
	end, 100, 1)
end

function getDarkerColor(r, g, b, darker)
	return math.floor(r * darker), math.floor(g * darker), math.floor(b * darker)
end

-- Все параметры изменяются от 0 до 1
function setCustomWeather(temp, rain, wind)
	if type(temp) ~= "number" or type(rain) ~= "number" or type(wind) ~= "number" then
		return false
	end
	-- Ночью холоднее
	local dayMultiplier = getDayMultiplier()
	temp = temp - 0.25 * (1 - dayMultiplier)
	local rainMultiplier = getCurrentMinute()
	-- Ограничить параметры
	temp = math.max(0, math.min(1, temp))
	rain = math.max(0, math.min(1, rain))
	wind = math.max(0, math.min(1, wind))

	--iprint(temp, rain, wind)

	-- Цвет неба
	r1, g1, b1, r2, g2, b2 = getBaseSkyGradient()
	-- Зависимость от дождя
	r1, g1, b1 = getGrayscaleColor(r1, g1, b1, rain)
	r2, g2, b2 = getGrayscaleColor(r2, g2, b2, rain)

	-- Более синий цвет при дожде и менее синий ночью
	r1 = r1 - 30 * rain * dayMultiplier
	g1 = g1 - 10 * rain * dayMultiplier
	b1 = b1 + 30 * rain * dayMultiplier
	r2 = r2 - 30 * rain * dayMultiplier
	g2 = g2 - 10 * rain * dayMultiplier
	b2 = b2 + 30 * rain * dayMultiplier

	-- Сделать небо темнее при дожде
	r1 = r1 - r1 * rain * 0.5
	g1 = g1 - g1 * rain * 0.5
	b1 = b1 - b1 * rain * 0.5
	r2 = r2 - r2 * rain * 0.2
	g2 = g2 - g2 * rain * 0.2
	b2 = b2 - b2 * rain * 0.2

	-- Зависимость от температуры
	if temp > 0.5 then
		r1 = r1 + 20 * (temp - 0.5) * 2
		g1 = g1 + 10 * (temp - 0.5) * 2
		r2 = r2 + 10 * (temp - 0.5) * 2
		g2 = g2 +  5 * (temp - 0.5) * 2

		-- Очень высокая температура
		if temp > 0.9 then
			r1 = r1 + 20 * (temp - 0.9) / 0.1
			g1 = g1 + 10 * (temp - 0.9) / 0.1
			r2 = r2 + 20 * (temp - 0.9) / 0.1
			g2 = g2 + 10 * (temp - 0.9) / 0.1
		end
	elseif temp < 0.5 then
		g1 = g1 + 10 * (0.5 - temp) * 2
		b1 = b1 + 20 * (0.5 - temp) * 2
		g2 = g2 + 20 * (0.5 - temp) * 2
		b2 = b2 + 40 * (0.5 - temp) * 2

		r1, g1, b1 = getGrayscaleColor(r1, g1, b1, 0.75 - temp)
		r2, g2, b2 = getGrayscaleColor(r2, g2, b2, 0.6 - temp)
		r1, g1, b1 = getDarkerColor(r1, g1, b1, 1 - (0.5 - temp) / 0.5 * 0.15)
		r2, g2, b2 = getDarkerColor(r2, g2, b2, 1 - (0.5 - temp) / 0.5 * 0.25)
	end

	math.max(0, math.min(255, r1))
	math.max(0, math.min(255, g1))
	math.max(0, math.min(255, b1))
	math.max(0, math.min(255, r2))
	math.max(0, math.min(255, g2))
	math.max(0, math.min(255, b2))
	setSkyGradient(r1, g1, b1, r2, g2, b2)

	-- Включить дождь
	if rain > 0.2 then
		if temp < 0.2 then
			setRainLevel(rain * Config.maxRainLevel * math.max(0, temp - 0.5))
		else
			setRainLevel(rain * Config.maxRainLevel)
		end
	else
		setRainLevel(0)
	end
	local sr1, sg1, sb1, sr2, sg2, sb2 = getBaseSunColor()
	local sunColorMul = (1 - rain) * math.max(0.02, temp)
	setSunColor(sr1 * sunColorMul, sg1 * sunColorMul, sb1 * sunColorMul, sr2 * sunColorMul, sg2 * sunColorMul, sb2 * sunColorMul)
	-- В жару менее ветренно, ветер видно только в дождь
	wind = wind * (1 - temp) * rain
	setWindVelocity(wind * 2, 0, 0)

	-- Видимость
	local farClip = Config.minFarClipDistance + (Config.maxFarClipDistance - Config.minFarClipDistance) * (1 - rain)
	if temp < 0.5 then
		farClip = farClip - 150 * (0.5 - temp) / 0.5 * (1 - rain * 0.2)
	end
	setFarClipDistance(farClip)
	setFogDistance(Config.minFogDistance + (Config.maxFogDistance - Config.minFogDistance) * (1 - rain))

	setWeather(0)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	triggerServerEvent("requireWeatherTimestamp", resourceRoot)
end)

addEvent("onServerWeatherTimestamp", true)
addEventHandler("onServerWeatherTimestamp", resourceRoot, function (timestamp)
	serverTimestampOffset = timestamp - getRealTime().timestamp
end)

-- Получает параметры погоды в произвольной точке карты в произвольное время
function getCustomWeather(x, y, timestamp)
	if not timestamp then
		timestamp = getRealTime().timestamp + serverTimestampOffset
	end
	local rainOffsetX = math.floor(timestamp / Config.rainCycleTimeX * 128)
	local rainOffsetY = math.floor(timestamp / Config.rainCycleTimeY * 128)

	local temp = getWeatherMapValue("temp", x, y)
	local rain = getWeatherMapValue("rain", x, y, rainOffsetX, rainOffsetY)
	local wind = getWeatherMapValue("wind", x, y)

	rain = rain * (math.sin((timestamp%Config.rainMulCycleTime)/Config.rainMulCycleTime * math.pi * 2) + 1) / 2

	return temp, rain, wind
end

function getLocalWeather()
	local x, y = getCameraMatrix()
	local temp, rain, wind = getCustomWeather(x, y)
	if localPlayer.interior ~= 0 or localPlayer.dimension ~= 0 then
		temp, rain, wind = 0.5, 0, 0
	end
	return temp, rain, wind
end

-- Обновление погоды
setTimer(function ()
	if isWeatherLocked then
		return
	end
	local temp, rain, wind = getLocalWeather()
	setCustomWeather(temp, rain, wind)
end, 100, 0)

addEventHandler("onClientResourceStop", resourceRoot, function()
	resetRainLevel()
	resetWindVelocity()
	resetFarClipDistance()
	resetFogDistance()
	resetSkyGradient()
end)
