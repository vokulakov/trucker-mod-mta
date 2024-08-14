GUI = {}

local sW, sH = guiGetScreenSize() 
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height = 350, 0

local Fonts = {
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),
}

function GUI.renderTemplate(window)
    if not isElement(window) then
        return
    end

    local posY = 25
    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(posY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, window)
    guiSetFont(GUI.btnClose, Fonts['RB_10'])
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)
    
    GUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Личный кабинет\nналогоплательщика", false, window)
    guiSetFont(GUI.lblTitle, Fonts.RB_10)
    GUI.lblTitle.enabled = false
    
    posY = posY + 25
    local line = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, window)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    posY = posY + 20
    GUI.lblInfo = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "ЕДИНЫЙ НАЛОГОВЫЙ СЧЕТ", false, window)
    guiLabelSetHorizontalAlign(GUI.lblInfo, "center", false)
    guiSetFont(GUI.lblInfo, Fonts.RB_11)
    guiLabelSetColor(GUI.lblInfo, 242, 171, 18)
    GUI.lblInfo.enabled = false
 
    -- 
    posY = posY + 30
    GUI.lblIndividualNumber = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Ваш ИНН:", false, window)
    guiSetFont(GUI.lblIndividualNumber, Fonts.RR_11)
    GUI.lblIndividualNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblIndividualNumber)+5
    GUI.lblIndividualNumber = guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, window)
    guiSetFont(GUI.lblIndividualNumber, Fonts.RB_11)
    guiLabelSetColor(GUI.lblIndividualNumber, 242, 171, 18)
    GUI.lblIndividualNumber.enabled = false

    --
    posY = posY + 25
    GUI.lblPropertyTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Налог на имущество:", false, window)
    guiSetFont(GUI.lblPropertyTax, Fonts.RR_11)
    GUI.lblPropertyTax.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblPropertyTax)+10
    GUI.lblPropertyTax = GUI.createMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), "", window)
    guiSetFont(GUI.lblPropertyTax, Fonts.RB_11)
    guiLabelSetColor(GUI.lblPropertyTax, 242, 171, 18)
    GUI.lblPropertyTax.enabled = false

    --
    posY = posY + 25
    GUI.lblVehicleTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Транспортный налог:", false, window)
    guiSetFont(GUI.lblVehicleTax, Fonts.RR_11)
    GUI.lblVehicleTax.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblVehicleTax)+10
    GUI.lblVehicleTax = GUI.createMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), "", window)
    guiSetFont(GUI.lblVehicleTax, Fonts.RB_11)
    guiLabelSetColor(GUI.lblVehicleTax, 242, 171, 18)
    GUI.lblVehicleTax.enabled = false

    if (localPlayer:getData('isBusinessEntity')) then
        posY = posY + 25
        GUI.lblIncomeTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Подоходный налог:", false, window)
        guiLabelSetHorizontalAlign(GUI.lblIncomeTax, "left", false)
        guiSetFont(GUI.lblIncomeTax, Fonts.RR_11)
        GUI.lblIncomeTax.enabled = false

        local offsetX = guiLabelGetTextExtent(GUI.lblIncomeTax)+10
        GUI.lblIncomeTax = GUI.createMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), "", window)
        guiSetFont(GUI.lblIncomeTax, Fonts.RB_11)
        guiLabelSetColor(GUI.lblIncomeTax, 242, 171, 18)
        GUI.lblIncomeTax.enabled = false
    end

    --
    posY = posY + 25
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, window)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    posY = posY + 25
    GUI.lblTax = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, window)
    guiLabelSetHorizontalAlign(GUI.lblTax, "center", false)
    guiSetFont(GUI.lblTax, Fonts.RB_10)
    GUI.lblTax.enabled = false

    if (localPlayer:getData('taxAmount') > 0) then
        GUI.lblTax.text = "Итого к оплате:"

        posY = posY + 30
        GUI.lblTaxAmount = guiCreateLabel(sW*((0)/sDW), sH*((posY)/sDH), sW*(width/sDW), sH*(30 /sDH), '', false, window)
        guiSetFont(GUI.lblTaxAmount, Fonts.RB_11)
        guiLabelSetColor(GUI.lblTaxAmount, 242, 171, 18)
        GUI.lblTaxAmount.enabled = false

        GUI.iconMoney = exports.tmtaTextures:createStaticImage(sW*((0)/sDW), sH*((posY)/sDH), sW*(32 /sDW), sH*(28 /sDH), 'i_money', false, window)
        GUI.iconMoney.enabled = false

        posY = posY + 30
        GUI.btnPayTax = guiCreateButton(sH*((width-width/2)/2/sDH), sH*((posY)/sDH), sW*((width/2)/sDW), sH*(30/sDH), 'Оплатить', false, window)
        guiSetFont(GUI.btnPayTax, Fonts.RR_10)
        guiSetProperty(GUI.btnPayTax, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", GUI.btnPayTax, GUI.onClickPayTax, false)
    else
        GUI.lblTax.text = "У Вас нет неоплаченных\nналогов и задолженности"
    end

    posY = posY + 30
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, window)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    --
    if (not localPlayer:getData('isBusinessEntity')) then
        posY = posY + 25
        GUI.lblInfo = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "СВЕДЕНИЯ О\nПРЕДПРИНИМАТЕЛЬСКОЙ ДЕЯТЕЛЬНОСТИ", false, window)
        guiLabelSetHorizontalAlign(GUI.lblInfo, "center", false)
        guiSetFont(GUI.lblInfo, Fonts.RB_11)
        guiLabelSetColor(GUI.lblInfo, 242, 171, 18)
        GUI.lblInfo.enabled = false
    
        posY = posY + 45
        GUI.lblIsBusinessEntity = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(60/sDH), "Для владения бизнесом Вам необходимо зарегистрироваться в налоговой службе в качестве субъекта предпринимательской деятельности", false, window)
        guiLabelSetHorizontalAlign(GUI.lblIsBusinessEntity, "center", true)
        guiSetFont(GUI.lblIsBusinessEntity, Fonts.RR_10)
        GUI.lblIsBusinessEntity.enabled = false

        posY = posY + 55
        GUI.lblBusinessEntityPrice = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(50/sDH), "Стоимость регистрации:", false, window)
        guiLabelSetHorizontalAlign(GUI.lblBusinessEntityPrice, "center", true)
        guiSetFont(GUI.lblBusinessEntityPrice, Fonts.RR_11)
        GUI.lblBusinessEntityPrice.enabled = false

        posY = posY + 25
        GUI.lblBusinessEntityPrice = GUI.createMoneyLabel(sW*((0)/sDW), sH*((posY)/sDH), tostring(exports.tmtaUtils:formatMoney(Config.BUSINESS_ENTITY_PRICE)), window)
        guiSetFont(GUI.lblBusinessEntityPrice, Fonts.RB_11)
        guiLabelSetColor(GUI.lblBusinessEntityPrice, 242, 171, 18)
        GUI.lblBusinessEntityPrice.enabled = false
        GUI.centralizeMoneyLabel(GUI.lblBusinessEntityPrice)

        posY = posY + 30
        GUI.btnRegBusinessEntity = guiCreateButton(0, sH*((posY)/sDH), sW*(width/sDW), sH*(40/sDH), "Зарегистрироваться", false, window)
        guiSetFont(GUI.btnRegBusinessEntity, Fonts.RR_10)
        guiSetProperty(GUI.btnRegBusinessEntity, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", GUI.btnRegBusinessEntity, GUI.onClickRegisterBusinessEntity, false)

        posY = posY + 40
        local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, window)
        guiLabelSetHorizontalAlign(line, "center")
        guiSetFont(line, "default-bold-small")
        guiLabelSetColor(line, 105, 105, 105)
        guiSetEnabled(line, false)
    end
    
    posY = posY + 25
    GUI.btnClose = guiCreateButton(0, sH*((posY)/sDH), sW*(width/sDW), sH*(40/sDH), 'Выйти', false, window)
    guiSetFont(GUI.btnClose, Fonts.RR_10)
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)
    posY = posY + 50

    height = posY
end

function GUI.render()
    if isElement(GUI.wnd) then 
        return 
    end

    -- Костыль для получения размеров окна [НАЧАЛО] --
    local window = guiCreateWindow(0, 0, 0, 0, "", false)
    window.enabled = false
    window.alpha = 0
    GUI.renderTemplate(window)
    destroyElement(window)
    -- Костыль для получения размеров окна [КОНЕЦ] --

    GUI.wnd = guiCreateWindow(0, 0, sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8
    GUI.renderTemplate(GUI.wnd)
end

function GUI.createMoneyLabel(posX, posY, money, window)
    centerAlign = centerAlign or false

    local iconMoney = exports.tmtaTextures:createStaticImage(posX, posY-sH*((0) /sDH), sW*((32/1.4) /sDW), sH*((28/1.4) /sDH), 'i_money', false, window)
    iconMoney.enabled = false

    local label = guiCreateLabel(posX+sW*((10+32/1.4) /sDW), posY, sW*(width/sDW), sH*(30/sDH), money, false, window)
    label:setData("icon", iconMoney)

    return label
end

function GUI.centralizeMoneyLabel(label)
    local icon = label:getData('icon')
    local taxAmountWidth = guiLabelGetTextExtent(label)
    local iconSizeX, iconSizeY = guiStaticImageGetNativeSize(icon)
    local widthFrame = iconSizeX + 10 + taxAmountWidth

    local posX, posY = guiGetPosition(label)
    guiSetPosition(icon, sW*(((width-widthFrame)/2)/sDW), sH*((posY)/sDH))
    guiSetPosition(label, sW*(((width-widthFrame)/2+iconSizeX)/sDW), sH*((posY)/sDH))
end

function GUI.updatePlayerStats()
    GUI.lblIndividualNumber.text = localPlayer:getData('individualNumber')
    GUI.lblPropertyTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('propertyTaxPayable')))
    GUI.lblVehicleTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('vehicleTaxPayable')))

    if (isElement(GUI.lblIncomeTax)) then
        GUI.lblIncomeTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('incomeTaxPayable')))
    end
    if (isElement(GUI.lblTaxAmount)) then
        GUI.lblTaxAmount.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('taxAmount')))
    end
end

function GUI.renderTaxAmount()
    if (localPlayer:getData('taxAmount') <= 0) then
        return
    end

    local taxAmountWidth = guiLabelGetTextExtent(GUI.lblTaxAmount)
    local iconSizeX = guiStaticImageGetNativeSize(GUI.iconMoney)
    local widthFrame = iconSizeX + 10 + taxAmountWidth

    local posX, posY = guiGetPosition(GUI.lblTaxAmount)

    guiSetPosition(GUI.iconMoney, sW*(((width-widthFrame)/2)/sDW), sH*((posY-5)/sDH))
    guiSetPosition(GUI.lblTaxAmount, sW*(((width-widthFrame)/2+iconSizeX+10)/sDW), sH*((posY)/sDH))
end

function GUI.openWindow()
    GUI.render()
    GUI.updatePlayerStats()
    GUI.renderTaxAmount()
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

function GUI.onClickPayTax()
    return RevenueService.payTax()
end

function GUI.onClickRegisterBusinessEntity()
    return RevenueService.registerBusinessEntity()
end

addEvent("tmtaRevenueService.showNotice", true)
addEventHandler("tmtaRevenueService.showNotice", resourceRoot, 
    function(typeNotice, typeMessage)
        local posX, posY = sW*((sDW-400)/2 /sDW), sH*((sDH-150) /sDH)
        local width = sW*(400 /sDW)
        exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
    end
)

addEvent('tmtaRevenueService.updateRevenueServiceGUI', true)
addEventHandler('tmtaRevenueService.updateRevenueServiceGUI', resourceRoot, 
    function()
        GUI.closeWindow()
        GUI.openWindow()
    end
)