ShowroomGUI = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local Font = {
    RR_10 = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    RR_14 = exports.tmtaFonts:createFontGUI('RobotoRegular', 14),
    RB_10 = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    RB_24 = exports.tmtaFonts:createFontGUI('RobotoBold', 24),
}

local Texture = {
    bgShadow  = exports.tmtaTextures:createTexture('bg_shadow'),
    bgShadowSmoke  = exports.tmtaTextures:createTexture('bg_shadow_smoke'),
}

function ShowroomGUI.drawBackground()
    dxDrawImage(0, 0, sW, sH, Texture.bgShadowSmoke, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(0, 0, sW, sH, Texture.bgShadow, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

function ShowroomGUI.render(showroom)
    local width, height = 350, sDH-40
    ShowroomGUI.wnd = guiCreateWindow(sW*((20) /sDW), sH*((sH-height)/2 /sDH), sW*((width) /sDW), sH*((height) /sDH), '', false)

    ShowroomGUI.btnClose = guiCreateButton(sW*((sDW-45-20)/sDW), sH*(20/sDH), sW*(45/sDW), sH*(45/sDH), 'Х', false)
    guiSetFont(ShowroomGUI.btnClose, Font.RR_14)
    setElementParent(ShowroomGUI.btnClose, ShowroomGUI.wnd)
    addEventHandler("onClientGUIClick", ShowroomGUI.btnClose, Showroom.exit, false)

    ShowroomGUI.keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
        {"keyMouseRight", "Режим просмотра"},
        {"keyMouse", "Вращать камеру"},
        {"keyMouseWheel", "Отдалить/приблизить камеру"},
    }, true)

    local width, height = exports.tmtaUI:guiKeyPanelGetSize(ShowroomGUI.keyPane)
    exports.tmtaUI:guiKeyPanelSetPosition(ShowroomGUI.keyPane, sW*((sDW-width-10) /sDW), sH*((sDH-height-40) /sDH))

    ShowroomGUI.title = guiCreateLabel(sW*((0) /sDW), sH*((20) /sDH), sW*((width) /sDW), sW*(55 /sDW), "АВТОСАЛОН", false, ShowroomGUI.wnd)
    setElementParent(ShowroomGUI.title, ShowroomGUI.wnd)
    guiLabelSetHorizontalAlign(ShowroomGUI.title, "center", false)
    guiSetFont(ShowroomGUI.title, Font.RB_24)

    local line = guiCreateLabel(0, sH*((50)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, ShowroomGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    ShowroomGUI.editSearch = guiCreateEdit(sW*(10/sDW), sH*(70 /sDH), sW*(width /sDW), sH*(30 /sDH), "", false, ShowroomGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(ShowroomGUI.editSearch, 'Поиск...')

    ShowroomGUI.vehicleList = guiCreateGridList(sW*(10/sDW), sH*(110 /sDH), sW*(width /sDW), sH*((height-120) /sDH), false, ShowroomGUI.wnd)
    guiGridListSetSortingEnabled(ShowroomGUI.vehicleList, false)
    guiGridListSetSelectionMode(ShowroomGUI.vehicleList, 0)

    guiGridListClear(ShowroomGUI.vehicleList)

end

function ShowroomGUI.show()
    exports.tmtaUI:setPlayerComponentVisible('all', false)
    exports.tmtaUI:setPlayerComponentVisible('notifications', true)
	showChat(false)

    addEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)
    exports.tmtaHUD:moneyShow(sDW-100, 30)

    local showroom = Showroom.getData()
    if (not showroom or type(showroom) ~= 'table') then
        return Showroom.exit()
    end

    ShowroomGUI.render(showroom)
    showCursor(true)
end

function ShowroomGUI.hide()
    destroyElement(ShowroomGUI.wnd)
    destroyElement(ShowroomGUI.keyPane)
    showCursor(false)

    removeEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)
    exports.tmtaHUD:moneyHide()
    exports.tmtaUI:setPlayerComponentVisible("all", true)
    showChat(true)
end