ShowroomGUI = {}

ShowroomGUI._currentColorPick = nil
ShowroomGUI._showroom = nil
ShowroomGUI._cerrentSelectItem = nil

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local Font = {
    RR_10 = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    RR_14 = exports.tmtaFonts:createFontGUI('RobotoRegular', 14),

    RB_10 = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    RB_24 = exports.tmtaFonts:createFontGUI('RobotoBold', 24),

    RBI_24 = exports.tmtaFonts:createFontGUI('RobotoBoldItalic', 24),

    RMI_24 = exports.tmtaFonts:createFontGUI('RobotoMediumItalic', 24),
}

local Texture = {
    bgShadow  = exports.tmtaTextures:createTexture('bg_shadow'),
    bgShadowSmoke = exports.tmtaTextures:createTexture('bg_shadow_smoke'),
    colorPoint = dxCreateTexture('assets/image/colorPoint.png'),
    moneyIcon = exports.tmtaTextures:createTexture('i_money'),
}

function ShowroomGUI.drawBackground()
    dxDrawImage(0, 0, sW, sH, Texture.bgShadowSmoke, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(0, 0, sW, sH, Texture.bgShadow, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

function ShowroomGUI.render()
    local width, height = 380, sDH-40
    ShowroomGUI.wnd = guiCreateWindow(sW*((20) /sDW), sH*((sH-height)/2 /sDH), sW*((width) /sDW), sH*((height) /sDH), '', false)

    ShowroomGUI.title = guiCreateLabel(sW*((0) /sDW), sH*((20) /sDH), sW*((width) /sDW), sH*((55) /sDH), "АВТОСАЛОН", false, ShowroomGUI.wnd)
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
    addEventHandler('onClientGUIChanged', ShowroomGUI.editSearch, ShowroomGUI.onClientSearchVehicle, false)

    --
    ShowroomGUI.vehicleList = guiCreateGridList(sW*(10/sDW), sH*(110 /sDH), sW*(width /sDW), sH*((height-120) /sDH), false, ShowroomGUI.wnd)
    guiGridListSetSortingEnabled(ShowroomGUI.vehicleList, false)
    guiGridListSetSelectionMode(ShowroomGUI.vehicleList, 0)
    guiGridListAddColumn(ShowroomGUI.vehicleList, 'Модель', 0.65)
    guiGridListAddColumn(ShowroomGUI.vehicleList, 'Цена', 0.3)
    ShowroomGUI.renderVehicleList()
    addEventHandler('onClientGUIClick', ShowroomGUI.vehicleList, ShowroomGUI.onClientGUISelectVehicle, false)

    --
    ShowroomGUI.btnClose = guiCreateButton(sW*((sDW-45-20)/sDW), sH*(20/sDH), sW*(45/sDW), sH*(45/sDH), 'Х', false)
    guiSetFont(ShowroomGUI.btnClose, Font.RR_14)
    setElementParent(ShowroomGUI.btnClose, ShowroomGUI.wnd)
    addEventHandler('onClientGUIClick', ShowroomGUI.btnClose, Showroom.exit, false)

    --
    ShowroomGUI.keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
        {"keyMouseRight", "Режим просмотра"},
        {"keyMouse", "Вращать камеру"},
        {"keyMouseWheel", "Отдалить/приблизить камеру"},
    }, true)

    local keyPanelWidth, keyPanelHeight = exports.tmtaUI:guiKeyPanelGetSize(ShowroomGUI.keyPane)
    exports.tmtaUI:guiKeyPanelSetPosition(ShowroomGUI.keyPane, sW*((sW-keyPanelWidth-20) /sDW), sH*((sH-keyPanelHeight-40) /sDH))

    --
    local vehicle = ShowroomGUI.getSelectedVehicle()

    local width = 300
    local height = 400
    local posX = (sW-20)
    local _, posY = exports.tmtaUI:guiKeyPanelGetPosition(ShowroomGUI.keyPane)

    posY = posY-45-20
    ShowroomGUI.btnBuy = guiCreateButton(sW*((posX-255) /sDW), sH*((posY) /sDH), sW*((255) /sDW), sH*((45) /sDH), 'Купить', false)
    guiSetFont(ShowroomGUI.btnBuy, Font.RR_14)
    setElementParent(ShowroomGUI.btnBuy, ShowroomGUI.wnd)
    addEventHandler('onClientGUIClick', ShowroomGUI.btnBuy, ShowroomGUI.onClientGUIClickBuy, false)

    --ShowroomGUI.rectangleVehicleInfo = exports.tmtaUI:guiRectangleCreate(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH))

    posY = posY - 50
    ShowroomGUI.vehiclePrice = ShowroomGUI.renderPrice(posX, posY)
    ShowroomGUI.updatePrice(vehicle.price)

    posY = posY - 40
    ShowroomGUI.lblVehicleName = guiCreateLabel(sW*((0) /sDW), sH*((posY) /sDH), sW*((posX) /sDW), sH*((height) /sDH), '', false)
    guiLabelSetHorizontalAlign(ShowroomGUI.lblVehicleName, 'right')
    guiSetFont(ShowroomGUI.lblVehicleName, Font.RBI_24)
    ShowroomGUI.lblVehicleName.enabled = false
    setElementParent(ShowroomGUI.lblVehicleName, ShowroomGUI.wnd)

    ShowroomGUI.lblVehicleName.text = Utils.getVehicleNameFromModel(vehicle.model)
end

function ShowroomGUI.renderPrice(posX, posY)
    local label = guiCreateLabel(sW*((0) /sDW), sH*((posY) /sDH), sW*((posX) /sDW), sH*((60) /sDH), 0, false)
    guiLabelSetHorizontalAlign(label, 'right')
    guiSetFont(label, Font.RMI_24)
    label.enabled = false

    local offsetX = guiLabelGetTextExtent(label)
    local width = sW*((32) /sDW)
    local height = sH*((28) /sDH)
    local iconMoney = exports.tmtaTextures:createStaticImage(sW*((posX) /sDW)-width-10-offsetX, sH*((posY+(guiLabelGetFontHeight(label)-28)/2) /sDH), width, height, 'i_money', false)
    iconMoney.enabled = false
    label:setData('icon', iconMoney, false)
    setElementParent(iconMoney, label)

    return label
end

function ShowroomGUI.updatePrice(price)
    local oldPriceOffsetX = guiLabelGetTextExtent(ShowroomGUI.vehiclePrice)
    ShowroomGUI.vehiclePrice.text = exports.tmtaUtils:formatMoney(price)
    local currentPriceOffsetX = guiLabelGetTextExtent(ShowroomGUI.vehiclePrice)
    local iconMoney = ShowroomGUI.vehiclePrice:getData('icon')
    local posX, posY = guiGetPosition(iconMoney)
    guiSetPosition(iconMoney, posX+oldPriceOffsetX-currentPriceOffsetX, posY, false)
end

function ShowroomGUI.renderVehicleList(searchText)
    searchText = searchText or ''
    guiGridListClear(ShowroomGUI.vehicleList)
    if (type(ShowroomGUI._showroom.vehicleList) == 'table') then
        for _, vehicle in ipairs(ShowroomGUI._showroom.vehicleList) do
            local name = Utils.getVehicleNameFromModel(vehicle.model)
            if name then
                if (pregFind(string.lower(name), string.lower(searchText))) then
                    local row = guiGridListAddRow(ShowroomGUI.vehicleList)

                    if (utf8.len(name) > 35) then
                        name = utf8.sub(name, 0, 35) .. '...'
                    end

                    guiGridListSetItemText(ShowroomGUI.vehicleList, row, 1, name, false, true)
                    guiGridListSetItemData(ShowroomGUI.vehicleList, row, 1, vehicle)

                    guiGridListSetItemText(ShowroomGUI.vehicleList, row, 2, tostring(exports.tmtaUtils:formatMoney(vehicle.price))..' ₽', false, true)
                    guiGridListSetItemData(ShowroomGUI.vehicleList, row, 2, vehicle.price)
                end
            end
        end
        if ShowroomGUI._cerrentSelectItem then
            guiGridListSetSelectedItem(ShowroomGUI.vehicleList, ShowroomGUI._cerrentSelectItem, 1)
        end
    end
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

    exports.tmtaUI:dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 95), true)
    
    for colorId, color in pairs(Config.colorList) do
        local _color = tocolor(color[1], color[2], color[3], 155)
        local colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight = sW*((posX+4) /sDW), sH*((posY+4) /sDH), sW*((32) /sDW), sH*((32) /sDH)

        if (isMouseInPosition(colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight) and colorId ~= ShowroomGUI._currentColorPick) then
            _color = tocolor(color[1], color[2], color[3], 255)
            if (getKeyState('mouse1')) then
                ShowroomGUI._currentColorPick = colorId
                exports.tmtaSounds:playSound('ui_select')
                triggerEvent('tmtaCarShowroom.onClientColorPick', localPlayer, color[1], color[2], color[3])
            end
        end

        if (ShowroomGUI._currentColorPick == colorId) then
            _color = tocolor(color[1], color[2], color[3], 255)
        end

        dxDrawImage(colorPointPosX, colorPointPosY, colorPointWidth, colorPointHeight, Texture.colorPoint, 0, 0, 0, _color, false)
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
    if (not isElement(ShowroomGUI.vehicleList)) then
        return ShowroomGUI._cerrentSelectItem
    end

    local selectedItem = guiGridListGetSelectedItem(ShowroomGUI.vehicleList)

    if (selectedItem == -1) then
        selectedItem = ShowroomGUI._cerrentSelectItem or 0
        guiGridListSetSelectedItem(ShowroomGUI.vehicleList, selectedItem, 1)
    end

    ShowroomGUI._cerrentSelectItem = selectedItem

    return guiGridListGetItemData(ShowroomGUI.vehicleList, selectedItem, 1)
end

function ShowroomGUI.onClientGUISelectVehicle()
    local vehicle = ShowroomGUI.getSelectedVehicle()
    if (not vehicle) then
        return
    end
    
    playSoundFrontEnd(33)
    Showroom.vehiclePreview(vehicle.model)
    ShowroomGUI.lblVehicleName.text = Utils.getVehicleNameFromModel(vehicle.model)
    ShowroomGUI.updatePrice(vehicle.price)
end

function ShowroomGUI.onClientGUIClickBuy()
    ShowroomGUI.hide()
    exports.tmtaUI:setPlayerBlurScreen(true)
    local vehicle = ShowroomGUI.getSelectedVehicle()
    local message = string.format("Вы хотите приобрести\n'%s' за %s ₽ ?", Utils.getVehicleNameFromModel(vehicle.model), tostring(exports.tmtaUtils:formatMoney(vehicle.price)))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onShowroomConfirmWindowBuy', 'onShowroomConfirmWindowCancel', 'onShowroomConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(confirmWindow, 'Купить')
end

function ShowroomGUI.onClientSearchVehicle()
    local text = guiGetText(source)
    if (text ~= exports.tmtaGUI:getEditPlaceholder(source) and text:len() > 0) then
        return ShowroomGUI.renderVehicleList(text)
    end
    return ShowroomGUI.renderVehicleList()
end

function onShowroomConfirmWindowCancel()
    exports.tmtaUI:setPlayerBlurScreen(false)
    ShowroomGUI.show()
end

function onShowroomConfirmWindowBuy()
    exports.tmtaUI:setPlayerBlurScreen(false)
    ShowroomGUI.show()
    return Showroom.buyVehicle(ShowroomGUI.getSelectedVehicle())
end

function ShowroomGUI.show()
    addEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)
    addEventHandler('onClientHUDRender', root, ShowroomGUI.dxDrawColorPicker)

    exports.tmtaHUD:moneyShow(sDW-100, 30)

    ShowroomGUI._showroom = Showroom.getData()
    if (not ShowroomGUI._showroom or type(ShowroomGUI._showroom) ~= 'table') then
        return Showroom.exit()
    end

    ShowroomGUI.render()
    showCursor(true)
end

function ShowroomGUI.hide()
    ShowroomGUI.wnd.visible = false
    ShowroomGUI.btnClose.visible = false
    ShowroomGUI.lblVehicleName.visible = false
    ShowroomGUI.btnBuy.visible = false

    setTimer(destroyElement, 100, 1, ShowroomGUI.wnd)
    destroyElement(ShowroomGUI.keyPane)
    --destroyElement(ShowroomGUI.rectangleVehicleInfo)
    destroyElement(ShowroomGUI.vehiclePrice)
    showCursor(false)

    removeEventHandler('onClientHUDRender', root, ShowroomGUI.drawBackground)
    removeEventHandler('onClientHUDRender', root, ShowroomGUI.dxDrawColorPicker)

    exports.tmtaHUD:moneyHide()
end

function ShowroomGUI.showNotice(typeNotice, typeMessage)
	local posX, posY = sW*((sDW-400)/2 /sDW), sH*((sDH-150) /sDH)
	local width = sW*(400 /sDW)
	exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
end
addEvent("tmtaCarShowroom.showNotice", true)
addEventHandler("tmtaCarShowroom.showNotice", root, ShowroomGUI.showNotice)