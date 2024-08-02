Help = {}
Help.visible = false

-- Params
Help.params = {}
Help.params['windowTitle'] = "Информация [F9]"
Help.params['bindKey'] = 'f9'

local width, height
local posX, posY

function Help.create()
    width, height = 1280, 720
    posX, posY = (sDW-width) /2, (sDH-height) /2

    Help.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), Help.params['windowTitle'], false)
    Help.wnd.sizible = false
    Help.wnd.movable = false
    Help.wnd.visible = false

    Help.btnClose = guiCreateButton(sW*((width-35) /sDW), sH*((10+25) /sDH), sW*((25) /sDW), sH*((25) /sDH), 'Х', false, Help.wnd)
    guiSetFont(Help.btnClose, Utils.fonts['RR_10'])
    guiSetProperty(Help.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", Help.btnClose, Help.setVisible, false)

    Help.tabPanel = guiCreateTabPanel(0, sH*((50) /sDH), sW*((width) /sDW), sH*((height) /sDH), false, Help.wnd)
  
    -- Управление
    Help.tabControls = guiCreateTab("Управление", Help.tabPanel)

    -- Донат
    Help.tabDonate = guiCreateTab("Донат", Help.tabPanel)

    -- Правила сервера
    RuleTab.create(posX, posY, width, height, Help.tabPanel)

    -- О проекте
    AboutTab.create(posX, posY, width, height, Help.tabPanel)

    -- Add window
    Dashboard.addWindow(Help.wnd, Help.setVisible)
end

function Help.setVisible()
    Help.visible = Dashboard.setWindowVisible(Help.wnd)
    showChat(not Help.visible)
    exports.tmtaUI:setPlayerBlurScreen(Help.visible)
    exports.tmtaUI:setPlayerComponentVisible("all", not Help.visible, {"dashboard"})
end

bindKey(Help.params['bindKey'], 'down',
    function()
        if not Dashboard.getVisible() then
            return
        end
        Help.setVisible()
    end
)