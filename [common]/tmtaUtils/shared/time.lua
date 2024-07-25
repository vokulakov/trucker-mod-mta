-- https://wiki.multitheftauto.com/wiki/IsLeapYear
-- This function checks if a year is a leap year or not.
function isLeapYear(year)
	if year then year = math.floor(year)
	else year = getRealTime().year + 1900 end
	return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

-- https://wiki.multitheftauto.com/wiki/GetTimestamp
-- With this function you can get the UNIX timestamp
function getTimestamp(year, month, day, hour, minute, second)
	-- initiate variables
	local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
	local timestamp = 0
	local datetime = getRealTime()
	year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
	hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

	-- calculate timestamp
	for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
	for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
	timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

	timestamp = timestamp - 10800 --GMT+3 compensation
	--if datetime.isdst then timestamp = timestamp - 3600 end

	return timestamp
end

-- Преобразование MySQL-timestamp'а в UNIX формат
-- MySQL: 2016-03-29 18:55:36
function convertTimestampToSeconds(str)
	if type(str) ~= "string" then
		return false
	end
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local years, months, days, hours, minutes, seconds = str:match(pattern)
	return getTimestamp(years, months, days, hours, minutes, seconds)
end

-- Преобразование миллисекунд
function convertMsToTimeStr(ms)
	if not ms then
		return ''
	end
	
	if ms < 0 then
		return "0","00","00"
	end
	
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	
	return minutes, seconds, centiseconds
end

--Конвертировать минуты в часы
function convertMinToHour(minutes)
	if type(minutes) ~= 'number' then
		return false
	end
	local hour = math.floor(minutes/60)
	local minute = math.fmod(minutes, 60)
	return hour, minute
end

-- Преобразует простое целое число секунд в удобное для пользователя описание времени
-- @link https://wiki.multitheftauto.com/wiki/SecondsToTimeDesc
function secondAsTimeFormat(seconds)
	if (type(seconds) ~= 'number' or seconds == nil) then
		return nil
	end

	return {
		d = math.floor(seconds /86400),
		h = math.floor((seconds % 86400) /3600),
		i = math.floor((seconds % 3600) /60),
		s = (seconds %60),
	}
end