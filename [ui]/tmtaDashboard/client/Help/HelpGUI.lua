HelpGUI = {}
HelpGUI.visible = false

-- Params
HelpGUI.params = {}
HelpGUI.params['windowTitle'] = "Информация [F9]"
HelpGUI.params['bindKey'] = 'f9'

local width, height
local posX, posY

function HelpGUI.create() 
    width, height = 1280, 720
    posX, posY = (sDW-width) /2, (sDH-height) /2

    HelpGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), HelpGUI.params['windowTitle'], false)
    guiWindowSetSizable(HelpGUI.wnd, false)
    HelpGUI.wnd.movable = false
    HelpGUI.wnd.visible = false

    HelpGUI.btnClose = guiCreateButton(sW*((width-35) /sDW), sH*((25) /sDH), sW*((25) /sDW), sH*((25) /sDH), 'Х', false, HelpGUI.wnd)
    guiSetFont(HelpGUI.btnClose, Font['RR_10'])
    guiSetProperty(HelpGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", HelpGUI.btnClose, HelpGUI.setVisible, false)

    HelpGUI.tabPanel = guiCreateTabPanel(0, sH*((50) /sDH), sW*((width) /sDW), sH*((height) /sDH), false, HelpGUI.wnd)
  
    -- Управление
    HelpGUI.controlTab = ControlsTab.create(posX, posY, width, height, HelpGUI.tabPanel)

    --Донат
    HelpGUI.donateTab = DonateTab.create(posX, posY, width, height, HelpGUI.tabPanel)

    -- Add window
    Dashboard.addWindow(HelpGUI.wnd, HelpGUI.setVisible, HelpGUI.getVisible)
end

function HelpGUI.openDonateTab()
    HelpGUI.setVisible()
    guiSetSelectedTab(HelpGUI.tabPanel, HelpGUI.donateTab)
end

function HelpGUI.openControlTab()
    HelpGUI.setVisible()
    guiSetSelectedTab(HelpGUI.tabPanel, HelpGUI.controlTab)
end

function HelpGUI.getVisible()
    return HelpGUI.visible
end

function HelpGUI.setVisible()
    HelpGUI.visible = Dashboard.setWindowVisible(HelpGUI.wnd)
    showChat(not HelpGUI.visible)
    exports.tmtaUI:setPlayerBlurScreen(HelpGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("all", not HelpGUI.visible, {"dashboard"})
end

bindKey(HelpGUI.params['bindKey'], 'down',
    function()
        if not isElement(HelpGUI.wnd) then
            HelpGUI.create()
        end
        if not Dashboard.getVisible() then
            return
        end
        HelpGUI.setVisible()
    end
)