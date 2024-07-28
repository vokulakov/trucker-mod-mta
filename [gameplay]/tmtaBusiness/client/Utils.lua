Utils.sW, Utils.sH = guiGetScreenSize()
Utils.sDW, Utils.sDH = exports.tmtaUI:getScreenSize()

Utils.textures = {
	moneyIcon = exports.tmtaTextures:createTexture('i_money'),
}

-- Шрифты
Utils.fonts = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),

    ['DX_RR_12'] = exports.tmtaFonts:createFontDX('RobotoRegular', 12),
    ['DX_RR_14'] = exports.tmtaFonts:createFontDX('RobotoRegular', 14),
    ['DX_Elowen_22'] = exports.tmtaFonts:createFontDX('Elowen', 22),

    ['DX_RB_12'] = exports.tmtaFonts:createFontDX('RobotoBold', 12),
}

function dxDrawText3D(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	alignX = alignX or "center"
	alignY = alignY or "center"
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, _, _, _, true)
end

function Utils.guiCreateMoneyLabel(posX, posY, money, window)
    centerAlign = centerAlign or false

    local iconMoney = exports.tmtaTextures:createStaticImage(posX, posY-Utils.sH*((0) /Utils.sDH), Utils.sW*((32/1.4) /Utils.sDW), Utils.sH*((28/1.4) /Utils.sDH), 'i_money', false, window)
    iconMoney.enabled = false

	local windowWidth, windowHeight = guiGetSize(window, false)
    local label = guiCreateLabel(posX+Utils.sW*((10+32/1.4) /Utils.sDW), posY, Utils.sW*(windowWidth/Utils.sDW), Utils.sH*(30/Utils.sDH), money, false, window)
    label:setData("icon", iconMoney)

    return label
end

--TODO: вынести в tmtaGUI для универсального окна подтверждения
function Utils.showConfirmWindow(title, message, onClickOk, onClickCancel)
    if (type(title) ~= 'string' or type(message) ~= 'string') then
        return
    end

    local width, height = Utils.sW*((380) /Utils.sDW), Utils.sH*((130) /Utils.sDH)

    local windowConfirm = guiCreateWindow(0, 0, width, height, title, false)
	exports.tmtaGUI:windowCentralize(windowConfirm)
    guiWindowSetSizable(windowConfirm, false)
    guiWindowSetMovable(windowConfirm, false)
    guiSetAlpha(windowConfirm, 0.9)

    local message = guiCreateLabel(0, Utils.sH*((25) /Utils.sDH), width, Utils.sH*((55) /Utils.sDH), message, false, windowConfirm)
    guiLabelSetHorizontalAlign(message, "center")
    guiLabelSetVerticalAlign(message, "center")
    guiSetFont(message, "default-bold-small")

    local line = guiCreateLabel(0, Utils.sH*((75) /Utils.sDH), width, Utils.sH*((25) /Utils.sDH), ('_'):rep(width/4), false, windowConfirm)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    local btnCancel = guiCreateButton(0, Utils.sH*((95) /Utils.sDH), Utils.sW*((165) /Utils.sDW), Utils.sH*((30) /Utils.sDH), 'Нет', false, windowConfirm)
    guiSetFont(btnCancel, Utils.fonts.RR_10)
    addEventHandler("onClientGUIClick", btnCancel, function() executeCallback(onClickCancel) end, false)

    local btnOk = guiCreateButton(Utils.sW*((165+15) /Utils.sDW), Utils.sH*((95) /Utils.sDH), Utils.sW*((195) /Utils.sDW), Utils.sH*((30) /Utils.sDH), 'Да', false, windowConfirm)
    guiSetFont(btnOk, Utils.fonts.RR_10)
    guiSetProperty(btnOk, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", btnOk, function() executeCallback(onClickOk) end, false)

    return windowConfirm
end

Utils.showConfirmWindow('Внимание!', 'Тестовое сообщение', function() iprint('Click Ok') end, function() iprint('Click Cancell') end)



function Utils.showNotice(typeNotice, typeMessage)
	local posX, posY = Utils.sW*((Utils.sDW-400)/2 /Utils.sDW), Utils.sH*((Utils.sDH-150) /Utils.sDH)
	local width = Utils.sW*(400 /Utils.sDW)
	exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
end

addEvent("tmtaBusiness.showNotice", true)
addEventHandler("tmtaBusiness.showNotice", root, Utils.showNotice)