GUI = {}

local sW, sH = guiGetScreenSize() 
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height = 350, 520

local Fonts = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),

    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),
}

function GUI.render()
    if isElement(GUI.wnd) then 
        return 
    end

    GUI.wnd = guiCreateWindow(0, 0, sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8

    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, Fonts['RB_10'])
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)
    
    GUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(25/sDH), sW*(width/sDW), sH*(30/sDH), "Личный кабинет\nналогоплательщика", false, GUI.wnd)
    guiSetFont(GUI.lblTitle, Fonts.RB_10)
    GUI.lblTitle.enabled = false
    
    local posY = 50
    local line = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, GUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)

    posY = posY + 20
    GUI.lblInfo = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "ЕДИНЫЙ НАЛОГОВЫЙ СЧЕТ", false, GUI.wnd)
    guiLabelSetHorizontalAlign(GUI.lblInfo, "center", false)
    guiSetFont(GUI.lblInfo, Fonts.RB_10)
    guiLabelSetColor(GUI.lblInfo, 242, 171, 18)
    GUI.lblInfo.enabled = false
 
    -- 
    posY = posY + 30
    GUI.lblIndividualNumber = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Ваш ИНН:", false, GUI.wnd)
    guiSetFont(GUI.lblIndividualNumber, Fonts.RB_10)
    GUI.lblIndividualNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblIndividualNumber)+5
    GUI.lblIndividualNumber = guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, GUI.wnd)
    guiSetFont(GUI.lblIndividualNumber, Fonts.RR_10)
    guiLabelSetColor(GUI.lblIndividualNumber, 242, 171, 18)
    GUI.lblIndividualNumber.enabled = false

    --
    posY = posY + 25
    GUI.lblPropertyTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Налог на имущество:", false, GUI.wnd)
    guiSetFont(GUI.lblPropertyTax, Fonts.RB_10)
    GUI.lblPropertyTax.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblPropertyTax)+10
    GUI.lblPropertyTax = GUI.createMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), "", GUI.wnd)
    guiSetFont(GUI.lblPropertyTax, Fonts.RB_10)
    guiLabelSetColor(GUI.lblPropertyTax, 242, 171, 18)
    GUI.lblPropertyTax.enabled = false

    --
    posY = posY + 25
    GUI.lblVehicleTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Транспортный налог:", false, GUI.wnd)
    guiSetFont(GUI.lblVehicleTax, Fonts.RB_10)
    GUI.lblVehicleTax.enabled = false

    local offsetX = guiLabelGetTextExtent(GUI.lblVehicleTax)+10
    GUI.lblVehicleTax = GUI.createMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), "", GUI.wnd)
    guiSetFont(GUI.lblVehicleTax, Fonts.RB_10)
    guiLabelSetColor(GUI.lblVehicleTax, 242, 171, 18)
    GUI.lblVehicleTax.enabled = false

    --
    posY = posY + 30
    GUI.lblInfo = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "СВЕДЕНИЯ О\nПРЕДПРИНИМАТЕЛЬСКОЙ ДЕЯТЕЛЬНОСТИ", false, GUI.wnd)
    guiLabelSetHorizontalAlign(GUI.lblInfo, "center", false)
    guiSetFont(GUI.lblInfo, Fonts.RB_10)
    guiLabelSetColor(GUI.lblInfo, 242, 171, 18)
    GUI.lblInfo.enabled = false

    posY = posY + 45
    if (not localPlayer:getData('isBusinessEntity')) then
        GUI.lblIsBusinessEntity = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(50/sDH), "Для владения бизнесом Вам необходимо зарегистрироваться в налоговой службе в качестве субъекта предпринимательской деятельности", false, GUI.wnd)
        guiLabelSetHorizontalAlign(GUI.lblIsBusinessEntity, "center", true)
        guiSetFont(GUI.lblIsBusinessEntity, Fonts.RR_10)
        GUI.lblIsBusinessEntity.enabled = false

        GUI.lblTax = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, GUI.wnd)
        guiLabelSetHorizontalAlign(GUI.lblTax, "center", false)
        guiSetFont(GUI.lblTax, Fonts.RB_10)
        GUI.lblTax.enabled = false

        posY = posY + 75
        GUI.btnRegBusinessEntity = guiCreateButton(0, sH*((posY)/sDH), sW*(width/sDW), sH*(40/sDH), 'Зарегистрироваться', false, GUI.wnd)
        guiSetProperty(GUI.btnRegBusinessEntity, "NormalTextColour", "fffcba03")
    else
        GUI.lblIncomeTax = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Подоходный налог:", false, GUI.wnd)
        guiLabelSetHorizontalAlign(GUI.lblIncomeTax, "left", false)
        guiSetFont(GUI.lblIncomeTax, Fonts.RB_10)
        GUI.lblIncomeTax.enabled = false
    
        local offsetX = guiLabelGetTextExtent(GUI.lblIncomeTax)+5
        GUI.lblIncomeTax = guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, GUI.wnd)
        guiLabelSetHorizontalAlign(GUI.lblIncomeTax, "left", false)
        guiSetFont(GUI.lblIncomeTax, Fonts.RR_10)
        guiLabelSetColor(GUI.lblIncomeTax, 242, 171, 18)
        GUI.lblIncomeTax.enabled = false
    end

    -- posY = posY + 45
    -- local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, GUI.wnd)
    -- guiLabelSetHorizontalAlign(line, "center")
    -- guiSetFont(line, "default-bold-small")
    -- guiLabelSetColor(line, 105, 105, 105)





    --
    --local posY = 210
    -- posY = posY + 45

    -- GUI.lblTax = guiCreateLabel(sW*((0)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, GUI.wnd)
    -- guiLabelSetHorizontalAlign(GUI.lblTax, "center", false)
    -- guiSetFont(GUI.lblTax, Fonts.RB_10)
    -- GUI.lblTax.enabled = false

    -- if (localPlayer:getData('taxAmount') > 0) then
    --     posY = posY + 25
    --     GUI.lblTax.text = "К оплате:"

    --     GUI.lblTaxAmount = guiCreateLabel(sW*((0)/sDW), sH*((posY)/sDH), sW*(width/sDW), sH*(30 /sDH), '', false, GUI.wnd)
    --     guiSetFont(GUI.lblTaxAmount, Fonts.RB_11)
    --     guiLabelSetColor(GUI.lblTaxAmount, 242, 171, 18)
    --     GUI.lblTaxAmount.enabled = false

    --     GUI.iconMoney = exports.tmtaTextures:createStaticImage(sW*((0)/sDW), sH*((posY)/sDH), sW*(32 /sDW), sH*(28 /sDH), 'i_money', false, GUI.wnd)
    --     GUI.iconMoney.enabled = false

    --     posY = posY + 40
    --     GUI.btnPayTax = guiCreateButton(sH*((width-width/2)/2/sDH), sH*((posY)/sDH), sW*((width/2)/sDW), sH*(30/sDH), 'Оплатить сейчас', false, GUI.wnd)
    --     guiSetFont(GUI.btnPayTax, Fonts['RB_10'])
    --     guiSetProperty(GUI.btnPayTax, "NormalTextColour", "FF01D51A")
    --     addEventHandler("onClientGUIClick", GUI.btnPayTax, function() end, false)
    -- else
    --     GUI.lblTax.text = "У Вас нет неоплаченных\nналогов и задолженности"
    --     guiLabelSetColor(GUI.lblTax, 0, 255, 0)
    -- end


    -- posY = posY + 25

    local line = guiCreateLabel(0, sH*((height-50-25)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, GUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)


    GUI.btnClose = guiCreateButton(0, sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), 'Выйти', false, GUI.wnd)
    guiSetFont(GUI.btnClose, Fonts['RB_10'])
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)
end

function GUI.createMoneyLabel(posX, posY, money, window)
    local iconMoney = exports.tmtaTextures:createStaticImage(posX, posY-sH*((2.5) /sDH), sW*((32/1.4) /sDW), sH*((28/1.4) /sDH), 'i_money', false, window)
    iconMoney.enabled = false

    return guiCreateLabel(posX+sW*((10+32/1.4) /sDW), posY, sW*(width/sDW), sH*(30/sDH), "", false, GUI.wnd)
end

function GUI.updatePlayerStats()
    GUI.lblIndividualNumber.text = localPlayer:getData('individualNumber')
    GUI.lblPropertyTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('propertyTaxPayable')))
    --GUI.lblIncomeTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('incomeTaxPayable')))
    GUI.lblVehicleTax.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('vehicleTaxPayable')))
    --GUI.lblTaxAmount.text = tostring(exports.tmtaUtils:formatMoney(localPlayer:getData('taxAmount')))
    GUI.lblVehicleTax.text = tostring(exports.tmtaUtils:formatMoney(57800))
end

function GUI.renderTaxAmount()
    if (localPlayer:getData('taxAmount') <= 0) then
        return
    end

    local taxAmountWidth = guiLabelGetTextExtent(GUI.lblTaxAmount)
    local iconSizeX = guiStaticImageGetNativeSize(GUI.iconMoney)
    local widthFrame = iconSizeX + 10 + taxAmountWidth

    local posX, posY = guiGetPosition(GUI.lblTax)

    guiSetPosition(GUI.iconMoney, sW*(((width-widthFrame)/2)/sDW), sH*((posY+30-5)/sDH))
    guiSetPosition(GUI.lblTaxAmount, sW*(((width-widthFrame)/2+iconSizeX+10)/sDW), sH*((posY+30)/sDH))
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