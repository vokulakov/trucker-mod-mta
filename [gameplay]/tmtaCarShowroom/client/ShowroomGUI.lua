ShowroomGUI = {}

ShowroomGUI._currentColorPick = nil

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
    bgShadowSmoke = exports.tmtaTextures:createTexture('bg_shadow_smoke'),
    colorPoint = dxCreateTexture('assets/image/colorPoint.png')
}

function ShowroomGUI.drawBackground()
    dxDrawImage(0, 0, sW, sH, Texture.bgShadowSmoke, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(0, 0, sW, sH, Texture.bgShadow, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

function ShowroomGUI.render(showroom)
    local width, height = 350, sDH-40
    ShowroomGUI.wnd = guiCreateWindow(sW*((20) /sDW), sH*((sH-height)/2 /sDH), sW*((width) /sDW), sH*((height) /sDH), '', false)

    ShowroomGUI.title = guiCreateLabel(sW*((0) /sDW), sH*((20) /sDH), sW*((width) /sDW), sW*((55) /sDH), "АВТОСАЛОН", false, ShowroomGUI.wnd)
    guiLabelSetHorizontalAlign(ShowroomGUI.title, 'center')
    guiSetFont(ShowroomGUI.title, Font.RB_24)

    local line = guiCreateLabel(0, sH*((50)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, ShowroomGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    --
    ShowroomGUI.editSearch = guiCreateEdit(sW*(10/sDW), sH*(70 /sDH), sW*(width /sDW), sH*(30 /sDH), "", false, ShowroomGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(ShowroomGUI.editSearch, 'Поиск...')

    --
    ShowroomGUI.vehicleList = guiCreateGridList(sW*(10/sDW), sH*(110 /sDH), sW*(width /sDW), sH*((height-120) /sDH), false, ShowroomGUI.wnd)
    guiGridListSetSortingEnabled(ShowroomGUI.vehicleList, false)
    guiGridListSetSelectionMode(ShowroomGUI.vehicleList, 0)
    guiGridListAddColumn(ShowroomGUI.vehicleList, 'Модель', 0.55)
    guiGridListAddColumn(ShowroomGUI.vehicleList, 'Цена', 0.35)

    guiGridListClear(ShowroomGUI.vehicleList)
    if (type(showroom.vehicleList) == 'table') then
        for _, vehicle in ipairs(showroom.vehicleList) do
            local name = Utils.getVehicleNameFromModel(vehicle.model)
            if name then
                local row = guiGridListAddRow(ShowroomGUI.vehicleList)

                if utf8.len(name) >= 30 then
                    name = utf8.sub(name, 0, 30) .. '...'
                end

                guiGridListSetItemText(ShowroomGUI.vehicleList, row, 1, name, false, true)
                guiGridListSetItemData(ShowroomGUI.vehicleList, row, 1, vehicle)

                guiGridListSetItemText(ShowroomGUI.vehicleList, row, 2, tostring(exports.tmtaUtils:formatMoney(vehicle.price))..' ₽', false, true)
                guiGridListSetItemData(ShowroomGUI.vehicleList, row, 2, vehicle.price)
            end
        end

        guiGridListSetSelectedItem(ShowroomGUI.vehicleList, 0, 1)
        addEventHandler("onClientGUIClick", ShowroomGUI.vehicleList, ShowroomGUI.onClientGUISelectVehicle, false)
    end
    
    --
    ShowroomGUI.btnClose = guiCreateButton(sW*((sDW-45-20)/sDW), sH*(20/sDH), sW*(45/sDW), sH*(45/sDH), 'Х', false)
    guiSetFont(ShowroomGUI.btnClose, Font.RR_14)
    setElementParent(ShowroomGUI.btnClose, ShowroomGUI.wnd)
    addEventHandler("onClientGUIClick", ShowroomGUI.btnClose, Showroom.exit, false)

    --
    ShowroomGUI.keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
        {"keyMouseRight", "Режим просмотра"},
        {"keyMouse", "Вращать камеру"},
        {"keyMouseWheel", "Отдалить/приблизить камеру"},
    }, true)

    local keyPanelWidth, keyPanelHeight = exports.tmtaUI:guiKeyPanelGetSize(ShowroomGUI.keyPane)
    exports.tmtaUI:guiKeyPanelSetPosition(ShowroomGUI.keyPane, sW*((sDW-keyPanelWidth-10) /sDW), sH*((sDH-keyPanelHeight-40) /sDH))

    local offsetPosY = sDH-keyPanelHeight-40
    ShowroomGUI.btnBuy = guiCreateButton(sW*((sDW-255-10) /sDW), sH*((sDH-offsetPosY-55-20) /sDH), sW*(255/sDW), sH*(55/sDH), 'Купить', false)
    guiSetFont(ShowroomGUI.btnBuy, Font.RR_14)
    setElementParent(ShowroomGUI.btnBuy, ShowroomGUI.wnd)
    addEventHandler('onClientGUIClick', ShowroomGUI.btnBuy, )
end

local function isMouseInPosition(x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end

	local sx, sy = guiGetScreenSize()
	local cx, cy = getCursorPosition()
	local cx, cy = (cx * sx), (cy * sy)

    return not not ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

function ShowroomGUI.dxDrawColorPicker()
    local width = #Config.colorList*40
    local height = 40
    local posX = (sW-width) /2
    local posY = 32 + 35

    exports.tmtaUI:dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 175), true)
    for colorId, color in pairs(Config.colorList) do
        local color = tocolor(color[1], color[2], color[3], 175)
        local colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight = sW*((posX) /sDW), sH*((posY) /sDH), sW*((32) /sDW), sH*((32) /sDH)
        if (isMouseInPosition(colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight) or ShowroomGUI._currentColorPick == colorId) then
            color = tocolor(color[1], color[2], color[3], 255)
            if getKeyState('mouse1') then
                ShowroomGUI._currentColorPick = colorId
                triggerEvent('tmtaCarShowroom.onClientColorPick', localPlayer, color[1], color[2], color[3])
            end
        end
        dxDrawImage(colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight, Texture.colorPoint, 0, 0, 0, color, false)
        posX = posX + 40
    end
end

function ShowroomGUI.getColorFromColorPicker()
    if not ShowroomGUI._currentColorPick then
        return false
    end
    local color = Config.colorList[tonumber(ShowroomGUI._currentColorPick)]
    return color[1], color[2], color[3]
end

function ShowroomGUI.getSelectedVehicle()
    local selectedItem = guiGridListGetSelectedItem(ShowroomGUI.vehicleList)
    if selectedItem == -1 then
        guiGridListSetSelectedItem(ShowroomGUI.vehicleList, 0, 1)
        selectedItem = guiGridListGetSelectedItem(ShowroomGUI.vehicleList)
    end

    return guiGridListGetItemData(ShowroomGUI.vehicleList, selectedItem, 1)
end

function ShowroomGUI.onClientGUISelectVehicle()
    local vehicle = ShowroomGUI.getSelectedVehicle()
    return Showroom.vehiclePreview(vehicle.model)
end

function ShowroomGUI.onClientGUIClickBuy()
    ShowroomGUI.wnd.visible = false
    exports.tmtaUI:setPlayerBlurScreen(true)
    local vehicle = ShowroomGUI.getSelectedVehicle()
    local message = string.format("Вы хотите приобрести '%s' за %s ₽ ?", Utils.getVehicleNameFromModel(vehicle.model), tostring(exports.tmtaUtils:formatMoney(vehicle.price)))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onShowroomConfirmWindowBuy', 'onShowroomConfirmWindowCancel', 'onShowroomConfirmWindowCancel')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Купить')
end

function onShowroomConfirmWindowCancel()
    exports.tmtaUI:setPlayerBlurScreen(false)
    ShowroomGUI.wnd.visible = true
end

function onShowroomConfirmWindowBuy()
    exports.tmtaUI:setPlayerBlurScreen(false)
    return Showroom.buyVehicle(ShowroomGUI.getSelectedVehicle())
end

function ShowroomGUI.show()
    addEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)

    ShowroomGUI._currentColorPick = math.random(1, #Config.colorList)
    addEventHandler('onClientHUDRender', root, ShowroomGUI.dxDrawColorPicker)

    exports.tmtaHUD:moneyShow(sDW-100, 30)

    local showroom = Showroom.getData()
    if (not showroom or type(showroom) ~= 'table') then
        return Showroom.exit()
    end

    ShowroomGUI.render(showroom)
    showCursor(true)
end

function ShowroomGUI.hide()
    ShowroomGUI.wnd.visible = false
    ShowroomGUI.btnClose.visible = false
    setTimer(destroyElement, 100, 1, ShowroomGUI.wnd)
    destroyElement(ShowroomGUI.keyPane)
    destroyElement(ShowroomGUI.colorPicker)
    showCursor(false)

    removeEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)
    removeEventHandler('onClientHUDRender', root, ShowroomGUI.dxDrawColorPicker)

    exports.tmtaHUD:moneyHide()
end