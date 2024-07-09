local ui = {}

local screenSize = Vector2(guiGetScreenSize())
local isVisible = false

local currentSettings = {}
local settignsPath = "@weather.json"
local ignoreScrollEvent = false
local saveTimer

local function saveSettings()
    if not ui.saveCheckBox.selected or not getWeatherLocked() then
        if fileExists(settignsPath) then
            fileDelete(settignsPath)
        end
        return
    end
    local temp = guiScrollBarGetScrollPosition(ui.tempScroll) / 100
    local rain = guiScrollBarGetScrollPosition(ui.rainScroll) / 100
    local wind = guiScrollBarGetScrollPosition(ui.windScroll) / 100
    saveFile(settignsPath, toJSON({
        temp = temp,
        wind = wind,
        rain = rain
    }))
end

local function resetSettings()
    ui.saveCheckBox.selected = false
    setWeatherLocked(false)
    ignoreScrollEvent = true
    guiScrollBarSetScrollPosition(ui.tempScroll, 50)
    guiScrollBarSetScrollPosition(ui.rainScroll, 0)
    guiScrollBarSetScrollPosition(ui.windScroll, 0)
    ignoreScrollEvent = false
    saveSettings()
end

local function loadSettings()
    local jsonData = loadFile(settignsPath)
    if not jsonData then
        resetSettings()
        return
    end
    local settings = fromJSON(jsonData)
    if not settings then
        resetSettings()
        return
    end
    if not settings.temp or not settings.rain or not settings.wind then
        resetSettings()
        return
    end
    guiScrollBarSetScrollPosition(ui.tempScroll, settings.temp * 100)
    guiScrollBarSetScrollPosition(ui.rainScroll, settings.rain * 100)
    guiScrollBarSetScrollPosition(ui.windScroll, settings.wind * 100)

    ui.saveCheckBox.selected = true
    setWeatherLocked(true)
end

addEventHandler("onClientGUIScroll", resourceRoot, function ()
    if ignoreScrollEvent then
        return
    end
    local temp = guiScrollBarGetScrollPosition(ui.tempScroll) / 100
    local rain = guiScrollBarGetScrollPosition(ui.rainScroll) / 100
    local wind = guiScrollBarGetScrollPosition(ui.windScroll) / 100

    setWeatherLocked(true)
    setCustomWeather(temp, rain, wind)

    if isTimer(saveTimer) then
        killTimer(saveTimer)
    end
    saveTimer = setTimer(saveSettings, 300, 1)
end)

--[[
function toggleWindow()
    isVisible = not isVisible

    ui.window.visible = isVisible
    showCursor(isVisible)
end

addCommandHandler("weather", toggleWindow)
]]

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width = 300
    local height = 250
    ui.window = GuiWindow(10, screenSize.y - 10 - height, width, height, "Изменение погоды", false)

    local y = 0.12
    GuiLabel(0.05, y, 0.9, 0.07, "Температура", true, ui.window)
    y = y + 0.09
    ui.tempScroll = GuiScrollBar(0.05, y, 0.9, 0.07, true, true, ui.window)
    y = y + 0.11
    GuiLabel(0.05, y, 0.9, 0.07, "Влажность", true, ui.window)
    y = y + 0.09
    ui.rainScroll = GuiScrollBar(0.05, y, 0.9, 0.07, true, true, ui.window)
    y = y + 0.11
    GuiLabel(0.05, y, 0.9, 0.07, "Ветер", true, ui.window)
    y = y + 0.09
    ui.windScroll = GuiScrollBar(0.05, y, 0.9, 0.07, true, true, ui.window)
    y = y + 0.11
    ui.saveCheckBox = GuiCheckBox(0.05, y, 0.9, 0.08, "Сохранять свою погоду при перезаходе", false, true, ui.window)
    y = y + 0.12
    ui.resetButton = GuiButton(0.05, y, 0.425, 0.1, "Сбросить погоду", true, ui.window)
    ui.closeButton = GuiButton(0.5, y, 0.475, 0.1, "Закрыть", true, ui.window)

    ui.window.visible = false

    addEventHandler("onClientGUIClick", ui.resetButton, resetSettings, false)
    addEventHandler("onClientGUIClick", ui.saveCheckBox, saveSettings, false)

    addEventHandler("onClientGUIClick", ui.closeButton, function ()
        toggleWindow()
    end, false)

    loadSettings()
end)

addEventHandler("onClientResourceStop", resourceRoot, saveSettings)
