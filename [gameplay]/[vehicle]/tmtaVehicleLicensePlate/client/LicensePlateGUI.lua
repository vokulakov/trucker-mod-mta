LicensePlateGUI = {}
LicensePlateGUI.visible = false

sW, sH = guiGetScreenSize()
sDW, sDH = exports.tmtaUI:getScreenSize()
--sDW, sDH = 1920, 1080

LicensePlateGUI.font = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),

    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),
    ['RB_16'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 16),
    ['RB_18'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 18),
}

LicensePlateGUI.texture = {
    frame = exports.tmtaTextures:createTexture('vehicleFrame0'),
}

local width, height = 750, 650

local _currentLicensePlateType = 'ru'
local _currentLicensePlate = ''
local _currentLicensePlatePrice
local _currentLicensePlateProperty

function LicensePlateGUI.renderManageWindow()
    LicensePlateGUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(LicensePlateGUI.wnd)
    guiWindowSetSizable(LicensePlateGUI.wnd, false)
    guiWindowSetMovable(LicensePlateGUI.wnd, false)
    LicensePlateGUI.wnd.alpha = 0.8

    local posY = 25
    LicensePlateGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(posY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, LicensePlateGUI.wnd)
    guiSetFont(LicensePlateGUI.btnClose, LicensePlateGUI.font.RB_10)
    guiSetProperty(LicensePlateGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", LicensePlateGUI.btnClose, LicensePlateGUI.closeWindow, false)

    LicensePlateGUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(40/sDH), "ГОСУДАРСТВЕННАЯ РЕГИСТРАЦИЯ\nТРАНСПОРТНЫХ СРЕДСТВ", false, LicensePlateGUI.wnd)
    guiSetFont(LicensePlateGUI.lblTitle, LicensePlateGUI.font.RB_10)
    LicensePlateGUI.lblTitle.enabled = false

    posY = posY + 25
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, LicensePlateGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    --
    posY = posY + 25
    LicensePlateGUI.tabPanel = guiCreateTabPanel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(height/sDH), false, LicensePlateGUI.wnd)

    --
    LicensePlateGUI.tabRegistrate = guiCreateTab("Регистрация ТС", LicensePlateGUI.tabPanel)

    local tabWidth, tabHeight = guiGetSize(LicensePlateGUI.tabPanel, false)

    -- line
    local colPosX = tabWidth/1.7
    local line = exports.tmtaTextures:createStaticImage(colPosX, sH*((5) /sDH), 1, tabHeight-37, 'part_dot', false, LicensePlateGUI.tabRegistrate)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false
    
    --
    local lbl = guiCreateLabel(0, sH*(20/sDH), colPosX, sH*(30/sDH), "ВАШ ТЕКУЩИЙ НОМЕРНОЙ ЗНАК", false, LicensePlateGUI.tabRegistrate)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    local lbl = guiCreateLabel(0, sH*(165/sDH), colPosX, sH*(30/sDH), "ВАШ НОВЫЙ НОМЕРНОЙ ЗНАК", false, LicensePlateGUI.tabRegistrate)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    local offsetPosY = 300
    local line = exports.tmtaTextures:createStaticImage(10, offsetPosY, colPosX-20, 1, 'part_dot', false, LicensePlateGUI.tabRegistrate)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 10
    local editLicensePlateWidth = sW*((1024/2.5) /sDW)
    LicensePlateGUI.editLicensePlate = guiCreateEdit(colPosX-editLicensePlateWidth-10, sH*(offsetPosY/sDH), editLicensePlateWidth, sH*(50 /sDH), "", false, LicensePlateGUI.tabRegistrate)
    exports.tmtaGUI:setEditPlaceholder(LicensePlateGUI.editLicensePlate, 'Введите номер')
    guiSetFont(LicensePlateGUI.editLicensePlate, LicensePlateGUI.font.RB_16)
    --guiSetProperty(LicensePlateGUI.editLicensePlate, 'TextFormatting', 'HorzCentred')

    addEventHandler('onClientGUIChanged', LicensePlateGUI.editLicensePlate, LicensePlateGUI.onClientGUIChangedLicensePlate, false)
    
    --
    offsetPosY = offsetPosY + 50 + 5
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), 'Допустимые символы:', false, LicensePlateGUI.tabRegistrate)
    guiSetFont(lbl, LicensePlateGUI.font.RR_10)
    guiLabelSetColor(lbl, 125, 125, 125)
    lbl.enabled = false

    local offsetX = guiLabelGetTextExtent(lbl)+5
    LicensePlateGUI.lblLicensePlateCharacters = guiCreateLabel(10+offsetX, sH*(offsetPosY/sDH), colPosX-20, sH*(30/sDH), '', false, LicensePlateGUI.tabRegistrate)
    guiSetFont(LicensePlateGUI.lblLicensePlateCharacters, LicensePlateGUI.font.RB_10)
    guiLabelSetColor(LicensePlateGUI.lblLicensePlateCharacters, 242, 171, 18)
    LicensePlateGUI.lblLicensePlateCharacters.enabled = false

    offsetPosY = offsetPosY + 20
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), 'Пример:', false, LicensePlateGUI.tabRegistrate)
    guiSetFont(lbl, LicensePlateGUI.font.RR_10)
    guiLabelSetColor(lbl, 125, 125, 125)
    lbl.enabled = false
   
    local offsetX = guiLabelGetTextExtent(lbl)+5
    LicensePlateGUI.lblLicensePlateExample = guiCreateLabel(10+offsetX, sH*(offsetPosY/sDH), colPosX-20, sH*(30/sDH), '', false, LicensePlateGUI.tabRegistrate)
    guiSetFont(LicensePlateGUI.lblLicensePlateExample, LicensePlateGUI.font.RB_10)
    guiLabelSetColor(LicensePlateGUI.lblLicensePlateExample, 242, 171, 18)
    LicensePlateGUI.lblLicensePlateExample.enabled = false

    --
    offsetPosY = offsetPosY + 20
    LicensePlateGUI.lblPriceTittle = guiCreateLabel(0, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '', false, LicensePlateGUI.tabRegistrate)
    guiLabelSetHorizontalAlign(LicensePlateGUI.lblPriceTittle, 'center', false)
    guiSetFont(LicensePlateGUI.lblPriceTittle, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(LicensePlateGUI.lblPriceTittle, 242, 171, 18)
    LicensePlateGUI.lblPriceTittle.enabled = false

    offsetPosY = offsetPosY + 30
    LicensePlateGUI.lblPriceAmount = LicensePlateGUI.createMoneyLabel(0, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '', LicensePlateGUI.font.RB_18, LicensePlateGUI.tabRegistrate)
    guiLabelSetColor(LicensePlateGUI.lblPriceAmount, 255, 255, 255)
    LicensePlateGUI.moneyLabelSetPosition(LicensePlateGUI.lblPriceAmount, 0, _, colPosX, _, 'center')

    LicensePlateGUI.lblPriceMessage = guiCreateLabel(0, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '', false, LicensePlateGUI.tabRegistrate)
    guiLabelSetHorizontalAlign(LicensePlateGUI.lblPriceMessage, 'center', false)
    guiSetFont(LicensePlateGUI.lblPriceMessage, LicensePlateGUI.font['RR_11'])
    guiLabelSetColor(LicensePlateGUI.lblPriceMessage, 255, 255, 255)
    LicensePlateGUI.lblPriceMessage.enabled = false
    LicensePlateGUI.lblPriceMessage.visible = false

    --
    local btnPayHeight = sH*(45/sDH)

    local line = exports.tmtaTextures:createStaticImage(10, tabHeight-35-btnPayHeight-10, colPosX-20, 1, 'part_dot', false, LicensePlateGUI.tabRegistrate)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    LicensePlateGUI.btnPay = guiCreateButton(10, tabHeight-35-btnPayHeight, colPosX-20, btnPayHeight, 'Оплатить и установить', false, LicensePlateGUI.tabRegistrate)
    guiSetFont(LicensePlateGUI.btnPay, LicensePlateGUI.font.RR_11)
    guiSetProperty(LicensePlateGUI.btnPay, "NormalTextColour", "FF01D51A")
    LicensePlateGUI.btnPay.enabled = false
    addEventHandler('onClientGUIClick', LicensePlateGUI.btnPay, LicensePlateGUI.onClientGUIClickBtnPay, false)

    --
    local lbl = guiCreateLabel(colPosX, sH*((20) /sDH), tabWidth-colPosX, sH*(30/sDH), "ВЫБЕРИТЕ ТИП НОМЕРА", false, LicensePlateGUI.tabRegistrate)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    LicensePlateGUI.btnLicensePlateType = {}
    local btnPosY = 45
    for _, licensePlateType in pairs(Config.LICENSE_PLATE_TYPE_PUBLIC) do
        local licensePlateTypeName = Utils.getLicensePlateTypeProperty(licensePlateType, 'name')
        if licensePlateTypeName then
            local button = guiCreateButton(colPosX+10, sH*((btnPosY) /sDH), tabWidth-colPosX-20, sH*(40 /sDH), licensePlateTypeName, false, LicensePlateGUI.tabRegistrate)
            guiSetFont(button, LicensePlateGUI.font.RR_10)
            guiSetProperty(button, 'HoverTextColour', 'FF21b1ff')
            LicensePlateGUI.btnLicensePlateType[button] = licensePlateType
            btnPosY = btnPosY+25+20
        end
    end
    
    -- Хранилище
    LicensePlateGUI.tabStorage = LicensePlateStorageGUI.create(LicensePlateGUI.tabPanel)

    LicensePlateGUI.onClientSelectLicensePlateType(_, _currentLicensePlateType)
end

--TODO: вынести в tmtaGUI для использования в других системах
function LicensePlateGUI.createMoneyLabel(posX, posY, width, height, money, font, guiElement)
    local guiElement = guiElement or nil

    local _iconWidthCoef = 1
    local iconWidth = 32/_iconWidthCoef
    local iconHeight = 28/_iconWidthCoef

	local windowWidth, windowHeight = guiGetSize(guiElement, false)
    local width = width or windowWidth
    local height = height or windowHeight

    local label = guiCreateLabel(posX+10+iconWidth, posY, width, height, money, false, guiElement)
    guiSetFont(label, font or 'default-bold')
    label.enabled = false

    local iconMoney = exports.tmtaTextures:createStaticImage(posX, posY+(guiLabelGetFontHeight(label)-iconHeight)/2, iconWidth, iconHeight, 'i_money', false, guiElement)
    iconMoney.enabled = false
    label:setData('icon', iconMoney, false)
    setElementParent(iconMoney, label)

    return label
end

--TODO: вынести в tmtaGUI для использования в других системах
function LicensePlateGUI.moneyLabelSetVisible(label, visible)
    local visible = type(visible) ~= 'boolean' and not label.visible or visible

    label.visible = visible
    local icon = label:getData('icon')
    if isElement(icon) then
        icon.visible = visible
    end
    return true
end

--TODO: вынести в tmtaGUI для использования в других системах
--TODO: доработать надобно
--TODO: центрирование текста можно сделать через event (onClientGUIChanged)
function LicensePlateGUI.moneyLabelSetPosition(label, leftX, topY, rightX, bottomY, alignX, alignY)
    local rightX = rightX or leftX
    local bottomY = bottomY or topY

    local icon = label:getData('icon')
    local iconPosX, iconPosY = guiGetPosition(icon, false)
    local iconWidth, iconHeight = guiStaticImageGetNativeSize(icon)

    local labelOffsetX = 10
    local labelPosX, labelPosY = guiGetPosition(label, false)
    local labelTextExtent = guiLabelGetTextExtent(label)
    local labelWidth, labelHeight = guiGetSize(label, false)
    
    local frameLeftX = iconPosX
    local frameTopY = (iconPosY > labelPosY) and iconPosY or labelPosY
    local frameWidth = iconWidth + labelOffsetX + labelTextExtent
    local frameHeight = (iconHeight > labelHeight) and iconHeight or labelHeight
    local frameRightX = rightX or labelWidth
    local frameBottomY = bottomY or labelHeight

    local _iconPosX = frameLeftX
    local _iconPosY = frameTopY

    local _labelPosX = frameLeftX + iconWidth + labelOffsetX
    local _labelPosY = frameTopY

    if (alignX) then
        if (alignX == 'center') then
            _iconPosX = (frameRightX-frameWidth)/2
            _labelPosX = _iconPosX + iconWidth + labelOffsetX
        elseif (alignX == 'right') then
            _labelPosX = frameRightX - labelTextExtent
            _iconPosX = _labelPosX - iconWidth - labelOffsetX
        end
    end

    guiSetPosition(icon, _iconPosX, _iconPosY)
    guiSetPosition(label, _labelPosX, _labelPosY)
end

local function dxDrawLicensePlate(x, y, w, h, licensePlateTexture)
    if not isElement(licensePlateTexture) then return end
    dxDrawImage(x+sW*(5/sDW), y+sH*(2/sDH), w-sW*(12/sDW), h-sH*(12/sDH), licensePlateTexture, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    dxDrawImage(x, y, w, h, LicensePlateGUI.texture.frame, 0, 0, 0, tocolor(255, 255, 255, 255), true)
end

--- Рендеринг номерных знаков в GUI
local _renderLicensePlatesParam = {}
function LicensePlateGUI.renderLicensePlates()
    if not LicensePlateGUI.wnd.visible then
        return
    end

    local _posX = _renderLicensePlatesParam.posX
    local _posY = _renderLicensePlatesParam.posY
    local _width = _renderLicensePlatesParam.width
    local _height = _renderLicensePlatesParam.height

    -- Регистрация номерных знаков
    local selectedTab = guiGetSelectedTab(LicensePlateGUI.tabPanel)
    if (selectedTab == LicensePlateGUI.tabRegistrate) then
        dxDrawLicensePlate(_posX, _posY, _width, _height, _renderLicensePlatesParam.currentLicensePlateTexture)
        --TODO: live-ввод номера 
        dxDrawLicensePlate(_posX, _posY+sH*((145) /sDH), _width, _height, _renderLicensePlatesParam.editedLicensePlateTexture)
    elseif (selectedTab == LicensePlateGUI.tabStorage) then
        local licensePlateTexture = _renderLicensePlatesParam.previewLicensePlateTexture or _renderLicensePlatesParam.currentLicensePlateTexture
        dxDrawLicensePlate(_posX, _posY+sH*((380) /sDH), _width, _height, licensePlateTexture)
    end
end

function LicensePlateGUI.setPreviewLicensePlateTexture(_currentLicensePlateType, _currentLicensePlate)
    _renderLicensePlatesParam.previewLicensePlateTexture = LicensePlate.guiGetLicensePlateTexture(_currentLicensePlateType, _currentLicensePlate)
end

function LicensePlateGUI.resetPreviewLicensePlateTexture()
    _renderLicensePlatesParam.previewLicensePlateTexture = nil
end

function LicensePlateGUI.updateCurrentLicensePlateTexture()
    _renderLicensePlatesParam.currentLicensePlateTexture = LicensePlate.getTextureByVehicle(localPlayer.vehicle, _, _, true)
end

--- Обновить информацию в блоке оплаты номерного знака
function LicensePlateGUI.updateLicensePlatePayBlock()
    local isLicensePlateValid, licensePlateValidErrorMessage = Utils.isLicensePlateValid(_currentLicensePlate, _currentLicensePlateType)

    local isLicensePlateAvailable = (isLicensePlateValid)
        and Utils.isLicensePlateAvailable(_currentLicensePlateType, _currentLicensePlate) 
        or false

    local licensePlatePrice = (isLicensePlateAvailable) 
        and Utils.getLicensePlatePrice(_currentLicensePlateType, _currentLicensePlate) 
        or (_currentLicensePlateProperty.price or 0)

    local isPriceVisible = (tonumber(licensePlatePrice) > 0)

    _currentLicensePlatePrice = licensePlatePrice
    LicensePlateGUI.lblPriceAmount.text = tostring(exports.tmtaUtils:formatMoney(licensePlatePrice))
    LicensePlateGUI.moneyLabelSetPosition(LicensePlateGUI.lblPriceAmount, _, _, _, _, 'center')

    LicensePlateGUI.lblPriceTittle.text = 'К оплате:'
    LicensePlateGUI.lblPriceMessage.text = ''

    if (isLicensePlateValid and isPriceVisible and not isLicensePlateAvailable) then
        LicensePlateGUI.lblPriceTittle.text = 'Внимание:'
        LicensePlateGUI.lblPriceMessage.text = 'Данный регистрационный знак недоступен!'
        isPriceVisible = false
    end

    if (licensePlateValidErrorMessage ~= nil) then
        LicensePlateGUI.lblPriceTittle.text = 'Внимание:'
        LicensePlateGUI.lblPriceMessage.text = licensePlateValidErrorMessage
        isPriceVisible = false
    end

    LicensePlateGUI.moneyLabelSetVisible(LicensePlateGUI.lblPriceAmount, isPriceVisible)
    LicensePlateGUI.lblPriceMessage.visible = not isPriceVisible

    LicensePlateGUI.btnPay.enabled = (isLicensePlateAvailable and isPriceVisible)
end

function LicensePlateGUI.onClientSelectLicensePlateType(btnLicensePlateType, licensePlateType)
    local licensePlateProperty = Utils.getLicensePlateTypeProperty(licensePlateType)
    if (not licensePlateProperty) then
        return
    end

    if not isElement(btnLicensePlateType) then
        for button, _licensePlateType in pairs(LicensePlateGUI.btnLicensePlateType) do
            if (_licensePlateType == licensePlateType) then
                btnLicensePlateType = button
                break
            end
        end
    end

    for button in pairs(LicensePlateGUI.btnLicensePlateType) do
        if (button ~= btnLicensePlateType) then
            guiSetProperty(button, 'NormalTextColour', 'FFAAAAAA')
        end
    end
    guiSetProperty(btnLicensePlateType, 'NormalTextColour', 'FF21b1ff')

    LicensePlateGUI.lblLicensePlateExample.text = licensePlateProperty.example or '-'
    LicensePlateGUI.lblLicensePlateCharacters.text = licensePlateProperty.characters or '-'

    _currentLicensePlateType = licensePlateType
    _currentLicensePlateProperty = licensePlateProperty
    _currentLicensePlate = ''

    _renderLicensePlatesParam.editedLicensePlateTexture = LicensePlate.guiGetLicensePlateTexture(_currentLicensePlateType, '')
    guiSetText(LicensePlateGUI.editLicensePlate, exports.tmtaGUI:getEditPlaceholder(LicensePlateGUI.editLicensePlate))
    guiSetProperty(LicensePlateGUI.editLicensePlate, 'ValidationString', "^[a-zA-Zа-яА-Я0-9]*$")

    LicensePlateGUI.updateLicensePlatePayBlock()
end

function LicensePlateGUI.onClientGUIChangedLicensePlate()
    local text = guiGetText(LicensePlateGUI.editLicensePlate)
    local placeholder = exports.tmtaGUI:getEditPlaceholder(LicensePlateGUI.editLicensePlate)
    
    _currentLicensePlate = ''
    if (text ~= placeholder and text:len() > 0) then
        local maxTextLenght = _currentLicensePlateProperty.validate.maxLength or 0
        guiEditSetMaxLength(LicensePlateGUI.editLicensePlate, maxTextLenght)

        text = utf8.upper(text)
        
        _currentLicensePlate = Utils.formatLicensePlate(text)

        --TODO: придумать, как можно сделать live-ввод номера, нужна посимвольная валидация (в самой валидации это нужно делать)
        local isLicensePlateValid = Utils.isLicensePlateValid(_currentLicensePlate, _currentLicensePlateType)
        if isLicensePlateValid then
            _renderLicensePlatesParam.editedLicensePlateTexture = LicensePlate.guiGetLicensePlateTexture(_currentLicensePlateType, _currentLicensePlate)
        else
            _renderLicensePlatesParam.editedLicensePlateTexture = LicensePlate.guiGetLicensePlateTexture(_currentLicensePlateType, '')
        end
    
        LicensePlateGUI.updateLicensePlatePayBlock()

        return guiSetText(LicensePlateGUI.editLicensePlate, text)
    end

    LicensePlateGUI.updateLicensePlatePayBlock()
    
    _renderLicensePlatesParam.editedLicensePlateTexture = LicensePlate.guiGetLicensePlateTexture(_currentLicensePlateType, '')
end

function LicensePlateGUI.onClientGUIClickBtnPay()
    LicensePlateGUI.wnd.visible = false
    local message = string.format(
        "Вы хотите установить регистрационный\nзнак '%s' за %s ₽ ?\nУведомляем, что текущий номерной знак будет удален навсегда.", 
        _currentLicensePlate, 
        tostring(exports.tmtaUtils:formatMoney(_currentLicensePlatePrice))
    )
    LicensePlateGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onLicensePlateGUIConfirmWindowBuy', 'onLicensePlateGUIConfirmWindowCancel', 'onLicensePlateGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(LicensePlateGUI.confirmWindow, 'Установить')
end

function onLicensePlateGUIConfirmWindowCancel()
    LicensePlateGUI.wnd.visible = true
end

function onLicensePlateGUIConfirmWindowBuy()
    if (not _currentLicensePlateType or not _currentLicensePlate or not _currentLicensePlatePrice) then
        return
    end
    
    local price = tonumber(_currentLicensePlatePrice)
    if (tonumber(exports.tmtaMoney:getPlayerMoney()) < price) then
        return Utils.showNotice("У вас недостаточно денежных средств")
    end

    LicensePlateGUI.closeWindow()

    return triggerServerEvent('tmtaVehicleLicensePlate.onPlayerBuyLicensePlate', localPlayer, _currentLicensePlateType, _currentLicensePlate, _currentLicensePlatePrice)
end

addEventHandler('onClientGUIClick', resourceRoot,
    function()
        if not LicensePlateGUI.visible then
            return
        end

        -- Выбор типа номера
        local licensePlateType = LicensePlateGUI.btnLicensePlateType[source]
        if (licensePlateType) then
            return LicensePlateGUI.onClientSelectLicensePlateType(source, licensePlateType)
        end
    end
)

addEventHandler('tmtaUI.onClientChangeConsoleActive', resourceRoot,
    function(consoleVisible)
        if not LicensePlateGUI.visible then
            return
        end
        LicensePlateGUI.wnd.visible = not consoleVisible
    end
)

function LicensePlateGUI.openWindow()
    if LicensePlateGUI.visible then
        return
    end

    LicensePlateMarker.destroyActionButton()
    LicensePlateGUI.renderManageWindow()
    LicensePlateGUI.visible = true
    
     if (not _renderLicensePlatesParam.width and not _renderLicensePlatesParam.height) then
        local posX, posY = guiGetPosition(LicensePlateGUI.wnd, false)
        local width = sW*((1024/2.5) /sDW)
        local height = sH*((256/2.5) /sDH)
        
        local tabWidth, tabHeight = guiGetSize(LicensePlateGUI.tabPanel, false)
        local colPosX = tabWidth/1.7

        posX = posX+10+(colPosX-width)/2
        posY = posY+sH*((145) /sDH)

        _renderLicensePlatesParam.posX = posX
        _renderLicensePlatesParam.posY = posY
        _renderLicensePlatesParam.width = width
        _renderLicensePlatesParam.height = height
    end

    LicensePlateGUI.updateCurrentLicensePlateTexture()
    addEventHandler('onClientHUDRender', root, LicensePlateGUI.renderLicensePlates)

    triggerServerEvent('tmtaVehicleLicensePlate.onPlayerGetLicensePlates', resourceRoot)

    showCursor(true)
    showChat(false)
    toggleAllControls(false)
    guiSetInputMode("no_binds")
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false, {"notifications"})
end

function LicensePlateGUI.closeWindow()
    if not LicensePlateGUI.visible then
        return
    end

    LicensePlateGUI.wnd.visible = false
    LicensePlateGUI.visible = false
    setTimer(destroyElement, 100, 1, LicensePlateGUI.wnd)

    removeEventHandler('onClientHUDRender', root, LicensePlateGUI.renderLicensePlates)

    if isElement(LicensePlateGUI.confirmWindow) then
        destroyElement(LicensePlateGUI.confirmWindow)
    end

    showCursor(false)
    showChat(true)
    toggleAllControls(true)
    guiSetInputMode("allow_binds")
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end