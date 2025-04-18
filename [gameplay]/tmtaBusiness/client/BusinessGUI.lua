BusinessGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 350, 220

local _businessData = nil

function BusinessGUI.renderInfoBusinessWindow()
    local isSell = (not _businessData.owner) and true or false
    local height = isSell and height + 40 or height

    BusinessGUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(BusinessGUI.wnd)
    guiWindowSetSizable(BusinessGUI.wnd, false)
    guiWindowSetMovable(BusinessGUI.wnd, false)
    BusinessGUI.wnd.alpha = 0.8

    BusinessGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.btnClose, Utils.fonts.RR_10)
    guiSetProperty(BusinessGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", BusinessGUI.btnClose, BusinessGUI.closeWindow, false)

    BusinessGUI.lblBusiness = guiCreateLabel(0, sH*(35/sDH), sW*(width/sDW), 30, "Информация о бизнесе", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusiness, "center", false)
    guiSetFont(BusinessGUI.lblBusiness, Utils.fonts.RB_11)
    BusinessGUI.lblBusiness.enabled = false

    --
    BusinessGUI.lblBusinessNumber = guiCreateLabel(15, sH*(80/sDH), sW*(width/sDW), 30, "Номер бизнеса:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessNumber, "left", false)
    guiSetFont(BusinessGUI.lblBusinessNumber, Utils.fonts.RR_11)
    BusinessGUI.lblBusinessNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(BusinessGUI.lblBusinessNumber)+5
    BusinessGUI.lblBusinessNumber = guiCreateLabel(15+offsetX, sH*(80/sDH), sW*(width/sDW), 30, _businessData.businessId, false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessNumber, "left", false)
    guiSetFont(BusinessGUI.lblBusinessNumber, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessNumber, 242, 171, 18)
    BusinessGUI.lblBusinessNumber.enabled = false

    --
    BusinessGUI.lblBusinessName = guiCreateLabel(15, sH*(105/sDH), sW*(width/sDW), 30, "Название:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessName, "left", false)
    guiSetFont(BusinessGUI.lblBusinessName, Utils.fonts.RR_11)
    BusinessGUI.lblBusinessName.enabled = false

    local offsetX = guiLabelGetTextExtent(BusinessGUI.lblBusinessName)+5
    BusinessGUI.lblBusinessName = guiCreateLabel(15+offsetX, sH*(105/sDH), sW*(width/sDW), 30, _businessData.name, false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessName, "left", false)
    guiSetFont(BusinessGUI.lblBusinessName, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessName, 242, 171, 18)
    BusinessGUI.lblBusinessName.enabled = false

    --
    BusinessGUI.lblBusinessOwner = guiCreateLabel(15, sH*(130/sDH), sW*(width/sDW), 30, "Владелец:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessOwner, "left", false)
    guiSetFont(BusinessGUI.lblBusinessOwner, Utils.fonts.RR_11)
    BusinessGUI.lblBusinessOwner.enabled = false

    local offsetX = guiLabelGetTextExtent(BusinessGUI.lblBusinessOwner)+5
    BusinessGUI.lblBusinessOwner = guiCreateLabel(15+offsetX, sH*(130/sDH), sW*(width/sDW), 30, 'государство', false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessOwner, "left", false)
    guiSetFont(BusinessGUI.lblBusinessOwner, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessOwner, 242, 171, 18)
    BusinessGUI.lblBusinessOwner.enabled = false

    --
    BusinessGUI.lblBusinessPrice = guiCreateLabel(15, sH*(155/sDH), sW*(width/sDW), 30, "Цена:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessPrice, "left", false)
    guiSetFont(BusinessGUI.lblBusinessPrice, Utils.fonts.RR_11)
    BusinessGUI.lblBusinessPrice.enabled = false

    local offsetX = guiLabelGetTextExtent(BusinessGUI.lblBusinessPrice)+10
    BusinessGUI.lblBusinessPrice = Utils.guiCreateMoneyLabel(15+offsetX, sH*((155)/sDH), _businessData.formattedPrice, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblBusinessPrice, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessPrice, 242, 171, 18)
    BusinessGUI.lblBusinessPrice.enabled = false

    -- Кнопки
    if isSell then
        local btnBuy = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), "Купить", false, BusinessGUI.wnd)
        guiSetFont(btnBuy, Utils.fonts.RR_10)
        guiSetProperty(btnBuy, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", btnBuy, BusinessGUI.onPlayerBuyBusiness, false)
    end
end

function BusinessGUI.renderManagerBusinessWindow()
    local height = height + 380
    local width = 400

    BusinessGUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(BusinessGUI.wnd)
    guiWindowSetSizable(BusinessGUI.wnd, false)
    guiWindowSetMovable(BusinessGUI.wnd, false)
    BusinessGUI.wnd.alpha = 0.8

    local posY = 25
    BusinessGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(posY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.btnClose, Utils.fonts.RB_10)
    guiSetProperty(BusinessGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", BusinessGUI.btnClose, BusinessGUI.closeWindow, false)

    BusinessGUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Мой бизнес\n«".._businessData.name.."»", false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblTitle, Utils.fonts.RB_10)
    BusinessGUI.lblTitle.enabled = false

    posY = posY + 25
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    posY = posY + 20
    local lblBusiness = guiCreateLabel(0, sH*(posY/sDH), sW*(width/sDW), 30, "ОБЩАЯ ИНФОРМАЦИЯ", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusiness, "center", false)
    guiSetFont(lblBusiness, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusiness, 242, 171, 18)
    lblBusiness.enabled = false

    --
    posY = posY + 30
    local lblBusinessNumber = guiCreateLabel(15, sH*((posY)/sDH), sW*(width/sDW), 30, "Номер бизнеса:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessNumber, "left", false)
    guiSetFont(lblBusinessNumber, Utils.fonts.RR_11)
    lblBusinessNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBusinessNumber)+5
    local lblBusinessNumber = guiCreateLabel(15+offsetX, sH*((posY)/sDH), sW*(width/sDW), 30, _businessData.businessId, false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessNumber, "left", false)
    guiSetFont(lblBusinessNumber, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusinessNumber, 242, 171, 18)
    lblBusinessNumber.enabled = false

    --
    posY = posY + 25
    local lblBusinessType = guiCreateLabel(15, sH*((posY)/sDH), sW*(width/sDW), 30, "Тип бизнеса:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessType, "left", false)
    guiSetFont(lblBusinessType, Utils.fonts.RR_11)
    lblBusinessType.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBusinessType)+5
    local lblBusinessType = guiCreateLabel(15+offsetX, sH*((posY)/sDH), sW*(width/sDW), 30, Utils.getBusinnesTypeTitle(_businessData.type), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessType, "left", false)
    guiSetFont(lblBusinessType, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusinessType, 242, 171, 18)
    lblBusinessType.enabled = false

    --
    posY = posY + 25
    local lblBusinessPrice = guiCreateLabel(15, sH*((posY)/sDH), sW*(width/sDW), 30, "Цена:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessPrice, "left", false)
    guiSetFont(lblBusinessPrice, Utils.fonts.RR_11)
    lblBusinessPrice.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBusinessPrice)+10
    local lblBusinessPrice = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), _businessData.formattedPrice, BusinessGUI.wnd)
    guiSetFont(lblBusinessPrice, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusinessPrice, 242, 171, 18)
    lblBusinessPrice.enabled = false

    --
    posY = posY + 25
    local lblRevenueAmount = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "Доход:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblRevenueAmount, "left", false)
    guiSetFont(lblRevenueAmount, Utils.fonts.RR_11)
    lblRevenueAmount.enabled = false

    local offsetX = guiLabelGetTextExtent(lblRevenueAmount)+10
    lblRevenueAmount = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), exports.tmtaUtils:formatMoney(_businessData.revenue), BusinessGUI.wnd)
    guiSetFont(lblRevenueAmount, Utils.fonts.RB_11)
    guiLabelSetColor(lblRevenueAmount, 242, 171, 18)
    lblRevenueAmount.enabled = false

    --
    posY = posY + 25
    local lblBalance = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "В кассе:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBalance, "left", false)
    guiSetFont(lblBalance, Utils.fonts.RR_11)
    lblBalance.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBalance)+10
    BusinessGUI.lblBalance = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), 0, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblBalance, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBalance, 242, 171, 18)
    BusinessGUI.lblBalance.enabled = false

    --
    posY = posY + 25
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    posY = posY + 20
    local lblBusiness = guiCreateLabel(0, sH*(posY/sDH), sW*(width/sDW), 30, "ПОДОХОДНЫЙ НАЛОГ", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusiness, "center", false)
    guiSetFont(lblBusiness, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusiness, 242, 171, 18)
    lblBusiness.enabled = false

    --
    posY = posY + 35
    local lblBusinessTax = guiCreateLabel(15, sH*((posY) /sDH), sW*(width/sDW), 30, "Размер налога:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusinessTax, "left", false)
    guiSetFont(lblBusinessTax, Utils.fonts.RR_11)
    lblBusinessTax.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBusinessTax)+10
    lblBusinessTax = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY) /sDH), _businessData.formattedRevenueTax, BusinessGUI.wnd)
    guiSetFont(lblBusinessTax, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusinessTax, 242, 171, 18)
    lblBusinessTax.enabled = false

    --
    posY = posY + 25
    local lblAccrueRevenueAt = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "До начисления прибыли:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblAccrueRevenueAt, "left", false)
    guiSetFont(lblAccrueRevenueAt, Utils.fonts.RR_11)
    lblAccrueRevenueAt.enabled = false

    local offsetX = guiLabelGetTextExtent(lblAccrueRevenueAt)+5
    BusinessGUI.lblAccrueRevenueAt = guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblAccrueRevenueAt, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblAccrueRevenueAt, 242, 171, 18)
    BusinessGUI.lblAccrueRevenueAt.enabled = false

    --
    posY = posY + 25
    local lblUnpaidTaxesAmount = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "Неоплаченные налоги:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblUnpaidTaxesAmount, "left", false)
    guiSetFont(lblUnpaidTaxesAmount, Utils.fonts.RR_11)
    lblUnpaidTaxesAmount.enabled = false

    local offsetX = guiLabelGetTextExtent(lblUnpaidTaxesAmount)+10
    BusinessGUI.lblUnpaidTaxesAmount = Utils.guiCreateMoneyLabel(sW*((15+offsetX)/sDW), sH*((posY)/sDH), 0, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblUnpaidTaxesAmount, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblUnpaidTaxesAmount, 242, 171, 18)
    BusinessGUI.lblUnpaidTaxesAmount.enabled = false

    local btnTaxHelp = guiCreateButton(sW*((width-15-20)/sDW), sH*((posY-2.5)/sDH), sW*(25/sDW), sH*(25/sDH), "?", false, BusinessGUI.wnd)
    guiSetFont(btnTaxHelp, Utils.fonts.RR_11)
    addEventHandler("onClientGUIClick", btnTaxHelp, 
        function()
            Utils.showNotice('info', 'Оплатить налог можно в налоговой службе')
        end, false
    )

    --
    posY = posY + 25
    BusinessGUI.lblConfiscateAt = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "Конфискация через:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblConfiscateAt, "left", false)
    guiSetFont(BusinessGUI.lblConfiscateAt, Utils.fonts.RR_11)
    BusinessGUI.lblConfiscateAt.enabled = false

    local offsetX = guiLabelGetTextExtent(BusinessGUI.lblConfiscateAt)+5
    BusinessGUI.lblConfiscateAt = guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "", false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblConfiscateAt, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblConfiscateAt, 242, 171, 18)
    BusinessGUI.lblConfiscateAt.enabled = false

    --
    posY = posY + 35
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    posY = posY + 20
    local lblBusiness = guiCreateLabel(0, sH*(posY/sDH), sW*(width/sDW), 30, "УПРАВЛЕНИЕ БИЗНЕСОМ", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusiness, "center", false)
    guiSetFont(lblBusiness, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusiness, 242, 171, 18)
    lblBusiness.enabled = false

    posY = posY + 25
    local btnTakeMoney = guiCreateButton(sW*(0/sDW), sH*((posY)/sDH), sW*((width)/sDW), sH*(40/sDH), "Взять деньги с кассы", false, BusinessGUI.wnd)
    guiSetFont(btnTakeMoney, Utils.fonts.RB_10)
    guiSetProperty(btnTakeMoney, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", btnTakeMoney, BusinessGUI.onPlayerTakeMoney, false)

    if (_businessData.balance <= 0) then
        btnTakeMoney.enabled = false
    end 

    posY = posY + 45
    local btnSell = guiCreateButton(sW*(0/sDW), sH*((posY)/sDH), sW*((width)/sDW), sH*(40/sDH), 'Продать бизнес', false, BusinessGUI.wnd)
    guiSetFont(btnSell, Utils.fonts.RB_10)
    guiSetProperty(btnSell, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", btnSell, BusinessGUI.onPlayerSellBusiness, false)

    local line = guiCreateLabel(0, sH*((height-80)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    BusinessGUI.btnClose = guiCreateButton(0, sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), 'Закрыть', false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.btnClose, Utils.fonts.RB_10)
    addEventHandler("onClientGUIClick", BusinessGUI.btnClose, BusinessGUI.closeWindow, false)
end

function BusinessGUI.updateManagerBusinessWindow()
    if (not isElement(BusinessGUI.lblAccrueRevenueAt)) then
        return
    end

    local formattedTime = exports.tmtaUtils:secondAsTimeFormat(tonumber(_businessData.accrueRevenueAt - getRealTime().timestamp))
    BusinessGUI.lblAccrueRevenueAt.text = (formattedTime ~= nil) 
        and string.format("%dд. %02dч. %02dмин. %02dсек.", formattedTime.d, formattedTime.h, formattedTime.i, formattedTime.s) 
        or "ожидание информации"

        
    BusinessGUI.lblConfiscateAt.text = '—'
    if (_businessData.confiscateAt and type(_businessData.confiscateAt) == 'number') then
        local formattedTime = exports.tmtaUtils:secondAsTimeFormat(tonumber(_businessData.confiscateAt - getRealTime().timestamp))
        BusinessGUI.lblConfiscateAt.text = (formattedTime ~= nil) 
            and string.format("%dд. %02dч. %02dмин. %02dсек.", formattedTime.d, formattedTime.h, formattedTime.i, formattedTime.s)
            or "ожидание информации"
    end

    local incomeTaxDebt = exports.tmtaRevenueService:getPlayerIncomeTaxDebt()
    BusinessGUI.lblUnpaidTaxesAmount.text = exports.tmtaUtils:formatMoney(incomeTaxDebt)

    BusinessGUI.lblBalance.text = exports.tmtaUtils:formatMoney(_businessData.balance)
end

function BusinessGUI.openWindow(businessData)
    if (type(businessData) ~= 'table' or isElement(BusinessGUI.wnd)) then
        return
    end
    _businessData = businessData

    if (_businessData.userId) then
        if (_businessData.userId ~= localPlayer:getData('userId')) then
            return
        end
        BusinessGUI.renderManagerBusinessWindow()
        addEventHandler("onClientHUDRender", root, BusinessGUI.updateManagerBusinessWindow)
    else
        BusinessGUI.renderInfoBusinessWindow()
    end

    showCursor(true)
    showChat(false)
    toggleAllControls(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function BusinessGUI.closeWindow()
    if not isElement(BusinessGUI.wnd) then
        return
    end

    BusinessGUI.wnd.visible = false
    setTimer(destroyElement, 100, 1, BusinessGUI.wnd)
    removeEventHandler("onClientHUDRender", root, BusinessGUI.updateManagerBusinessWindow)
    showCursor(false)
    showChat(true)
    toggleAllControls(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end

function BusinessGUI.onPlayerBuyBusiness()
    BusinessGUI.wnd.visible = false

    local message = string.format("Вы хотите приобрести бизнес\n'%s' за %s ₽ ?", _businessData.name, exports.tmtaUtils:formatMoney(_businessData.price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onConfirmWindowBuy', 'onConfirmWindowCancel', 'onConfirmWindowClose')
    exports.tmtaGUI:confirmSetBtnOkLabel(confirmWindow, 'Купить')
end

function BusinessGUI.onPlayerTakeMoney()
    BusinessGUI.wnd.visible = false

    local message = string.format(
        "Вы собираетесь вывести %s ₽ с кассы\nбизнеса '%s'. При выводе будет удержана комиссия в размере %d%%",
        exports.tmtaUtils:formatMoney(_businessData.balance),
        _businessData.name,
        Config.WITHDRAWAL_FEE
    )

    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onConfirmWindowTakeMoney', 'onConfirmWindowCancel', 'onConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(confirmWindow, 'Вывести')
end

function BusinessGUI.onPlayerSellBusiness()
    BusinessGUI.wnd.visible = false

    local price = tonumber(_businessData.price - (_businessData.price * Config.SELL_COMMISSION/100))
    local message = string.format("Вы действительно хотите продать бизнес\n'%s' государству за %s ₽ ?", _businessData.name, exports.tmtaUtils:formatMoney(price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onConfirmWindowSell', 'onConfirmWindowCancel', 'onConfirmWindowClose')
    exports.tmtaGUI:confirmSetBtnOkLabel(confirmWindow, 'Продать')
end

function onConfirmWindowClose()
    return BusinessGUI.closeWindow()
end

function onConfirmWindowCancel()
    BusinessGUI.wnd.visible = true
end

function onConfirmWindowSell()
    BusinessGUI.closeWindow()
    Business.sell(tonumber(_businessData.businessId))
end

function onConfirmWindowBuy()
    BusinessGUI.closeWindow()
    Business.buy(tonumber(_businessData.businessId))
end

function onConfirmWindowTakeMoney()
    BusinessGUI.closeWindow()
    Business.takeMoney(tonumber(_businessData.businessId))
end