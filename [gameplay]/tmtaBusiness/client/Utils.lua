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
    label.enabled = false
    label:setData("icon", iconMoney)

    return label
end

function Utils.getBusinnesTypeTitle(businessType)
    if (type(businessType) ~= 'number') then
        return false
    end
    for _, typeData in pairs (Config.businessTypeList) do
        if (typeData.type == businessType) then
            return typeData.name
        end
    end
    return false
end

function Utils.showNotice(typeNotice, typeMessage)
	local posX, posY = Utils.sW*((Utils.sDW-400)/2 /Utils.sDW), Utils.sH*((Utils.sDH-130) /Utils.sDH)
	local width = Utils.sW*(400 /Utils.sDW)
	exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
end

addEvent("tmtaBusiness.showNotice", true)
addEventHandler("tmtaBusiness.showNotice", root, Utils.showNotice)