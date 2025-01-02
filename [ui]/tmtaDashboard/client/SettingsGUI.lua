SettingsGUI = {}
SettingsGUI.visible = false

-- Params
SettingsGUI.params = {}
SettingsGUI.params['windowTitle'] = "Настройки игры [F7]"
SettingsGUI.params['bindKey'] = 'f7'

local width, height
local posX, posY

local gameSettings = {}

-- Настройки по умолчанию
local gameSettingsDefault = {
    graphicsWaterShader = true,
    graphicsSkyboxShader = true,
    graphicsSnowEnabled = true,
}

function SettingsGUI.create()
    width, height = 380, 490
    posX, posY = (sW-width) /2, (sH-height) /2

    SettingsGUI.wnd = guiCreateWindow(posX, posY, width, height, SettingsGUI.params['windowTitle'], false)
    guiWindowSetSizable(SettingsGUI.wnd, false)
    SettingsGUI.wnd.movable = false
    SettingsGUI.wnd.visible = false

    SettingsGUI.btnClose = guiCreateButton(width-35, 25, 25, 25, 'Х', false, SettingsGUI.wnd)
    guiSetFont(SettingsGUI.btnClose, Font['RR_10'])
    guiSetProperty(SettingsGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", SettingsGUI.btnClose, SettingsGUI.setVisible, false)

    SettingsGUI.lbl = guiCreateLabel(10, 25, width, height, "Внимание! Настройки графики могут повлиять\nна производительность вашего ПК.", false, SettingsGUI.wnd)
    guiSetFont(SettingsGUI.lbl, Font['RR_8'])
    guiLabelSetColor(SettingsGUI.lbl, 240, 26, 33)
    guiLabelSetHorizontalAlign(SettingsGUI.lbl, 'left')
    SettingsGUI.lbl.enabled = false

    SettingsGUI.tabPanel = guiCreateTabPanel(0, 60, width-15, height, false, SettingsGUI.wnd)
   
    -- Графика
    SettingsGUI.tabGraphics = guiCreateTab("Графика", SettingsGUI.tabPanel)

    SettingsGUI.lbl = guiCreateLabel(0, 15, width-25, 20, "Улучшения графики", false, SettingsGUI.tabGraphics)
    guiSetFont(SettingsGUI.lbl, Font['RR_10'])
    guiLabelSetColor(SettingsGUI.lbl, 33, 177, 255)
    guiLabelSetHorizontalAlign(SettingsGUI.lbl, 'center')
    SettingsGUI.lbl.enabled = false

    SettingsGUI.btnWaterGraphics = guiCreateCheckBox(10, 40, width, 20, " Реалистичная вода", false, false, SettingsGUI.tabGraphics)
    guiSetFont(SettingsGUI.btnWaterGraphics, Font['RR_10'])
    SettingsGUI.btnWaterGraphics.enabled = false

    SettingsGUI.btnSkyGraphics = guiCreateCheckBox(10, 60, width, 20, " Реалистичное небо", false, false, SettingsGUI.tabGraphics)
    guiSetFont(SettingsGUI.btnSkyGraphics, Font['RR_10'])
    SettingsGUI.btnSkyGraphics.enabled = false

    SettingsGUI.btnSnowEnabled = guiCreateCheckBox(10, 80, width, 20, " Снег", false, false, SettingsGUI.tabGraphics)
    guiSetFont(SettingsGUI.btnSnowEnabled, Font['RR_10'])
    SettingsGUI.btnSnowEnabled.enabled = false

    --SettingsGUI.btnVegetationGraphics = guiCreateCheckBox(10, 80, width, 20, " Улучшенная растительность", false, false, SettingsGUI.tabGraphics)
    --guiSetFont(SettingsGUI.btnVegetationGraphics, Font['RR_10'])

    -- Оптимизация
    --SettingsGUI.tabOptimization = guiCreateTab("Оптимизация", SettingsGUI.tabPanel)

    -- Интерфейс
    --SettingsGUI.tabUi = guiCreateTab("Интерфейс", SettingsGUI.tabPanel)
    -- Скрыть весь интерфейс

    -- Прочее
    --SettingsGUI.tabOther = guiCreateTab("Прочее", SettingsGUI.tabPanel)
    -- Отключить онлайн радиостанции
    -- Отключить звук покрышек
   
    SettingsGUI.applyGameSettings()

    -- Add window
    Dashboard.addWindow(SettingsGUI.wnd, SettingsGUI.setVisible, SettingsGUI.getVisible)
end

function SettingsGUI.getVisible()
    return SettingsGUI.visible
end

function SettingsGUI.setVisible()
    SettingsGUI.visible = Dashboard.setWindowVisible(SettingsGUI.wnd)
    showChat(not SettingsGUI.visible)
    exports.tmtaUI:setPlayerBlurScreen(SettingsGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("all", not SettingsGUI.visible, {"dashboard"})
end

bindKey(SettingsGUI.params['bindKey'], 'down',
    function()
        if not isElement(SettingsGUI.wnd) then
            SettingsGUI.create()
        end
        if not Dashboard.getVisible() then
            return
        end
        SettingsGUI.setVisible()
    end
)

addEventHandler('onClientGUIClick', resourceRoot, 
    function()
        if not SettingsGUI.visible then
            return
        end

        if (source == SettingsGUI.btnSkyGraphics) then
            return setGraphicsSkyboxShader(source.selected)
        elseif (source == SettingsGUI.btnWaterGraphics) then
            return setGraphicsWaterShader(source.selected)
        elseif (source == SettingsGUI.btnSnowEnabled) then
            return setGraphicsSnowEnabled(source.selected)
        end
    end
)

function SettingsGUI.applyGameSettings()
    if (not gameSettings or type(gameSettings) ~= 'table') then
        gameSettings = gameSettingsDefault
    end

    setGraphicsWaterShader(gameSettings['graphicsWaterShader'])
    setGraphicsSkyboxShader(gameSettings['graphicsSkyboxShader'])
    setGraphicsSnowEnabled(gameSettings['graphicsSnowEnabled'])
end

-- Установить графику реалистичной воды
function setGraphicsWaterShader(state)
    if (not exports.tmtaUtils:isResourceRunning('tmtaShaderWater')) then
        SettingsGUI.btnWaterGraphics.enabled = false
        SettingsGUI.btnWaterGraphics.selected = false
        return false
    end

    SettingsGUI.btnWaterGraphics.enabled = true

    if state then
        exports.tmtaShaderWater.start()
    else
        exports.tmtaShaderWater.stop()
    end

    SettingsGUI.btnWaterGraphics.selected = exports.tmtaShaderWater:getStatus()
    gameSettings['graphicsWaterShader'] = SettingsGUI.btnWaterGraphics.selected

    return gameSettings['graphicsWaterShader']
end

-- Установить графиу реалистичного неба
function setGraphicsSkyboxShader(state)
    if (not exports.tmtaUtils:isResourceRunning('tmtaShaderSkybox')) then
        SettingsGUI.btnSkyGraphics.enabled = false
        SettingsGUI.btnSkyGraphics.selected = false
        return false
    end

    SettingsGUI.btnSkyGraphics.enabled = true

    if state then
        exports.tmtaShaderSkybox.start()
    else
        exports.tmtaShaderSkybox.stop()
    end

    SettingsGUI.btnSkyGraphics.selected = exports.tmtaShaderSkybox:getStatus()
    gameSettings['graphicsSkyboxShader'] = SettingsGUI.btnSkyGraphics.selected

    return gameSettings['graphicsSkyboxShader']
end

--- Снег
function setGraphicsSnowEnabled(state)
    if (not exports.tmtaUtils:isResourceRunning('winter_snow')) then
        SettingsGUI.btnSnowEnabled.enabled = false
        SettingsGUI.btnSnowEnabled.selected = false
        return false
    end

    SettingsGUI.btnSnowEnabled.enabled = true

    if state then
        exports.winter_snow.start()
    else
        exports.winter_snow.stop()
    end

    SettingsGUI.btnSnowEnabled.selected = exports.winter_snow:getStatus()
    gameSettings['graphicsSnowEnabled'] = SettingsGUI.btnSnowEnabled.selected

    return gameSettings['graphicsSnowEnabled']
end

-- Сохранение параметров настроек
local fileName = 'gameSettings.json'
local secretKey = 'm3GX5pJLEzNtmlFt'

local function loadSettings()
    local settingsData = loadFile(fileName)
    if not settingsData then
        return false
    end

	local settings = fromJSON(teaDecodeBinary(settingsData, secretKey))
 
    if settings then
        gameSettings = settings
    end

    return not not settings
end

local function saveSettings()
    local settingsData = toJSON(gameSettings)
    saveFile(fileName, teaEncodeBinary(settingsData, secretKey))
end

addEventHandler('onClientResourceStart', resourceRoot, loadSettings)
addEventHandler('onClientResourceStop', resourceRoot, saveSettings)