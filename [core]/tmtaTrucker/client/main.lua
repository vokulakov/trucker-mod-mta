sW, sH = guiGetScreenSize()
sDW, sDH = exports.tmtaUI:getScreenSize()

guiFont = {
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),

    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),
    ['RB_13'] = exports.tmtaFonts:createFontGUI('RobotoBold', 13),
}

dxFont = {
    ['RB_8'] = exports.tmtaFonts:createFontDX('RobotoBold', 8, false, "draft"),
	['RR_8'] = exports.tmtaFonts:createFontDX('RobotoRegular', 8, false, "draft"),
    ['RR_10'] = exports.tmtaFonts:createFontDX('RobotoRegular', 10, false, "draft"),
	['RR_7'] = exports.tmtaFonts:createFontDX('RobotoRegular', 7, false, "draft"),
}

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        Base.init()
        Cargo.renderWindow()
    end
)

function setPlayerUI(state)
    exports.tmtaUI:setPlayerComponentVisible("all", not state, {"notifications"})
	exports.tmtaUI:setPlayerBlurScreen(state)
    showChat(not state)
    showCursor(state)
    toggleAllControls(not state)
    guiSetInputMode(state and "no_binds" or "allow_binds")
end

--setPlayerUI(false)
--RoadsideAssistance.renderWindow()

addEvent('tmtaTrucker.onClientPlayerStopWork', true)
addEventHandler('tmtaTrucker.onClientPlayerStopWork', resourceRoot,
    function()
        Cargo.closeWindow()
        exports.tmtaSounds:playSound('finish_work')
    end
)

addEvent('tmtaTrucker.onClientPlayerStartWork', true)
addEventHandler('tmtaTrucker.onClientPlayerStartWork', resourceRoot,
    function()
        exports.tmtaSounds:playSound('start_work')
    end
)

-- Protected Trigger Server Event
local _triggerServerEvent = triggerServerEvent
triggerServerEvent = nil

function protectedTriggerServerEvent(...)
    return _triggerServerEvent(...)
end