local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

addEvent("tmtaPlayerPay.showNotice", true)
addEventHandler("tmtaPlayerPay.showNotice", root, 
    function(typeNotice, typeMessage)
        local posX, posY = sW*((sDW-400)/2 /sDW), sH*((sDH-150) /sDH)
        local width = sW*(400 /sDW)
        exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
    end
)