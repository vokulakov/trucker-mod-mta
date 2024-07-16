GUI = {}

local sW, sH = guiGetScreenSize() 
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height = 350, 380

local Fonts = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
}

function GUI.render()
    if isElement(GUI.wnd) then 
        return 
    end

    GUI.wnd = guiCreateWindow(0, 0, sW*(width/sDW), sH*(height/sDH), "Налоговая служба", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8

    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, Fonts['RB_10'])
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)

    --GUI.btnRegBusinessEntity = guiCreateButton(0, sH*((height-90)/sDH), sW*(width/sDW), sH*(40/sDH), 'Зарегистрироваться в налоговой службе', false, GUI.wnd)

    GUI.btnPayTax = guiCreateButton(0, sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), 'Оплатить налоги', false, GUI.wnd)
    guiSetFont(GUI.btnPayTax, Fonts['RB_10'])
    guiSetProperty(GUI.btnPayTax, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", GUI.btnPayTax, function() end, false)
end

function GUI.openWindow()
    GUI.render()
    showCursor(true)
    showChat(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function GUI.closeWindow()
    GUI.wnd.visible = false
    setTimer(destroyElement, 100, 1, GUI.wnd)
    showCursor(false)
    showChat(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end