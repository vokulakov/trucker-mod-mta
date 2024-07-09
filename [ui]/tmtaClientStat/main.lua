local sW, sH = guiGetScreenSize()

local fps = 0
local nextTick = 0
local currentFPS = 0

local function getCurrentFPS()
    return fps
end

setTimer(function()
    currentFPS = math.floor(getCurrentFPS())
end, 200, 0)

local function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

-- https://wiki.multitheftauto.com/wiki/GetNetworkStats
local weekdayName = {
    [0] = { short = "Вс", full = "Воскресенье" },
    [1] = { short = "Пн", full = "Понедельник" },
    [2] = { short = "Вт", full = "Вторник" },
    [3] = { short = "Ср", full = "Среда" },
    [4] = { short = "Чт", full = "Четверг" },
    [5] = { short = "Пт", full = "Пятница" },
    [6] = { short = "Сб", full = "Суббота" }
}

local FONT_RR = exports.tmtaFonts:createFontDX('RobotoRegular', 7.5)

addEventHandler('onClientRender', root, function()
   
	local time = getRealTime()
    local playerStat = string.format(
        "FPS:  %d  |  PING:  %d  |  Пот. пакетов:  %d%%  |  %02d:%02d |  %s,  %02d.%02d.%04d  |",
        math.floor(currentFPS),
        localPlayer.ping,
        getNetworkStats().packetlossLastSecond,
        time.hour, time.minute,
        weekdayName[time.weekday].short, time.monthday, time.month + 1, time.year + 1900
    )

    dxDrawText(playerStat, 0, 0, sW-75, sH, tocolor(255, 255, 255, 128), 1, FONT_RR, "right", "bottom")
end, true, 'low-10')