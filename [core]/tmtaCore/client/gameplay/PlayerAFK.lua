local AFK_TIMER
local RESET_TIMER
local AFK_TIMEOUT = 5 -- время бездействия (в минутах)

local function startTimer()
	if localPlayer:getData("player.isAFK") then
		return
	end

	localPlayer:setData("player.isAFK", true)

	local s = 0

	AFK_TIMER = setTimer(
        function()
            s = s + 1000
            local m, s, c = exports.tmtaUtils:convertMsToTimeStr(s)
            local time = tostring(m..":"..s)
            if tonumber(m) > 60 then
                time = tostring("60:00+")
            end
			localPlayer:setData("player.msTimeAFK", s)
            localPlayer:setData("player.strTimeAFK", time)
	    end, 1000, 0
    )
end

local function stopTimer()
    localPlayer:setData("player.isAFK", false)
	if isTimer(AFK_TIMER) then 
		killTimer(AFK_TIMER)
        localPlayer:setData("player.strTimeAFK", "00:00")
		localPlayer:setData("player.msTimeAFK", 0)
	end
end

addEventHandler("onClientMinimize", root, function() -- свернул игру
	startTimer()
end)

addEventHandler("onClientRestore", root, function() -- развернул игру
	stopTimer()
end)

addEventHandler("onClientMTAFocusChange", root, function(mtaFocused)
	if mtaFocused then
		stopTimer()
	else
		startTimer()
	end
end)

local function resetTimer()
	if isTimer(RESET_TIMER) then
		killTimer(RESET_TIMER)
		stopTimer()
	end

	RESET_TIMER = setTimer(startTimer, 1000 * 60 * AFK_TIMEOUT, 1)
end

addEventHandler("onClientCursorMove", root, resetTimer)
addEventHandler("onClientKey", root, resetTimer)
addEventHandler("onClientClick", root, resetTimer)