Settings = {}
Settings.visible = false

-- Params
Settings.params = {}
Settings.params['windowTitle'] = "Настройки игры [F7]"
Settings.params['bindKey'] = 'f7'

local width, height = 380, 490
local posX, posY = (sW-width) /2, (sH-height) /2

function Settings.create()
    Settings.wnd = guiCreateWindow(posX, posY, width, height, Settings.params['windowTitle'], false)
    Settings.wnd.sizible = false
    Settings.wnd.movable = false
    Settings.wnd.visible = false

    Settings.btnClose = guiCreateButton(width-35, 25, 25, 25, 'Х', false, Settings.wnd)
    guiSetFont(Settings.btnClose, Font['RR_10'])
    guiSetProperty(Settings.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", Settings.btnClose, Settings.setVisible, false)

    Settings.lbl = guiCreateLabel(10, 25, width, height, "Внимание! Настройки графики могут повлиять\nна производительность вашего ПК.", false, Settings.wnd)
    guiSetFont(Settings.lbl, Font['RR_8'])
    guiLabelSetColor(Settings.lbl, 240, 26, 33)
    guiLabelSetHorizontalAlign(Settings.lbl, 'left')
    Settings.lbl.enabled = false

    Settings.tabPanel = guiCreateTabPanel(0, 60, width-15, height, false, Settings.wnd)
   
    -- Графика
    Settings.tabGraphics = guiCreateTab("Графика", Settings.tabPanel)

    Settings.lbl = guiCreateLabel(0, 15, width-25, 20, "Улучшения графики", false, Settings.tabGraphics)
    guiSetFont(Settings.lbl, Font['RR_10'])
    guiLabelSetColor(Settings.lbl, 33, 177, 255)
    guiLabelSetHorizontalAlign(Settings.lbl, 'center')
    Settings.lbl.enabled = false

    Settings.btnWaterGraphics = guiCreateCheckBox(10, 40, width, 20, " Реалистичная вода", false, false, Settings.tabGraphics)
    guiSetFont(Settings.btnWaterGraphics, Font['RR_10'])

    Settings.btnSkyGraphics = guiCreateCheckBox(10, 60, width, 20, " Реалистичное небо", false, false, Settings.tabGraphics)
    guiSetFont(Settings.btnSkyGraphics, Font['RR_10'])

    Settings.btnVegetationGraphics = guiCreateCheckBox(10, 80, width, 20, " Улучшенная растительность", false, false, Settings.tabGraphics)
    guiSetFont(Settings.btnVegetationGraphics, Font['RR_10'])

    -- Оптимизация
    Settings.tabOptimization = guiCreateTab("Оптимизация", Settings.tabPanel)

    -- Интерфейс
    Settings.tabUi = guiCreateTab("Интерфейс", Settings.tabPanel)
    -- Скрыть весь интерфейс

    -- Прочее
    Settings.tabOther = guiCreateTab("Прочее", Settings.tabPanel)
    -- Отключить онлайн радиостанции
    -- Отключить звук покрышек
   
    -- Add window
    Dashboard.addWindow(Settings.wnd, Settings.setVisible)
end

function Settings.setVisible()
    Settings.visible = Dashboard.setWindowVisible(Settings.wnd)
    showChat(not Settings.visible)
    exports.tmtaUI:setPlayerBlurScreen(Settings.visible)
    exports.tmtaUI:setPlayerComponentVisible("all", not Settings.visible, {"dashboard"})
end

bindKey(Settings.params['bindKey'], 'down',
    function()
        if not Dashboard.getVisible() then
            return
        end
        Settings.setVisible()
    end
)