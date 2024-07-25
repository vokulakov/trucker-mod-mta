BusinessGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 350, 220

function BusinessGUI.renderInfoBusinessWindow(businessData)
    local height = height + 40

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
    BusinessGUI.lblBusinessNumber = guiCreateLabel(15+offsetX, sH*(80/sDH), sW*(width/sDW), 30, businessData.number, false, BusinessGUI.wnd)
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
    BusinessGUI.lblBusinessName = guiCreateLabel(15+offsetX, sH*(105/sDH), sW*(width/sDW), 30, businessData.name, false, BusinessGUI.wnd)
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
    BusinessGUI.lblBusinessPrice = Utils.guiCreateMoneyLabel(15+offsetX, sH*((155)/sDH), businessData.price, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblBusinessPrice, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessPrice, 242, 171, 18)
    BusinessGUI.lblBusinessPrice.enabled = false

    -- Кнопки
    BusinessGUI.btnBuy = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), "Купить", false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.btnBuy, Utils.fonts.RR_10)
    guiSetProperty(BusinessGUI.btnBuy, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", BusinessGUI.btnBuy, 
        function()
            Business.buy(tonumber(businessData.number))
        end, false
    )
end

function BusinessGUI.renderManagerBusinessWindow(businessData)
    local height = height + 240

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

    BusinessGUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "Мой бизнес\n«"..businessData.name.."»", false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.lblTitle, Utils.fonts.RB_10)
    BusinessGUI.lblTitle.enabled = false

    posY = posY + 25
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)

    posY = posY + 20
    local lblBusiness = guiCreateLabel(0, sH*(posY/sDH), sW*(width/sDW), 30, "ОБЩАЯ СВОДКА", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusiness, "center", false)
    guiSetFont(lblBusiness, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusiness, 242, 171, 18)
    lblBusiness.enabled = false

    posY = posY + 30
    local lblAccrueRevenueAt = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "До начисления прибыли:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblAccrueRevenueAt, "left", false)
    guiSetFont(lblAccrueRevenueAt, Utils.fonts.RB_10)
    lblAccrueRevenueAt.enabled = false

    local offsetX = guiLabelGetTextExtent(lblAccrueRevenueAt)+5
    --TODO:: обновление в онлайн режиме
    local lblAccrueRevenueAt= guiCreateLabel(sW*((15+offsetX)/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(30/sDH), "6 д. 11 ч. 50 мин.", false, BusinessGUI.wnd)
    guiSetFont(lblAccrueRevenueAt, Utils.fonts['RR_10'])
    guiLabelSetColor(lblAccrueRevenueAt, 242, 171, 18)
    lblAccrueRevenueAt.enabled = false

    posY = posY + 25
    local lblRevenueAmount = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "Доход:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblRevenueAmount, "left", false)
    guiSetFont(lblRevenueAmount, Utils.fonts.RB_10)
    lblRevenueAmount.enabled = false

    local offsetX = guiLabelGetTextExtent(lblRevenueAmount)+10
    lblRevenueAmount = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), exports.tmtaUtils:formatMoney(businessData.revenue), BusinessGUI.wnd)
    guiSetFont(lblRevenueAmount, Utils.fonts.RB_11)
    guiLabelSetColor(lblRevenueAmount, 242, 171, 18)
    lblRevenueAmount.enabled = false

    --
    posY = posY + 25
    local lblUnpaidTaxesAmount = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "Неоплаченные налоги:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblUnpaidTaxesAmount, "left", false)
    guiSetFont(lblUnpaidTaxesAmount, Utils.fonts.RB_10)
    lblUnpaidTaxesAmount.enabled = false

    local offsetX = guiLabelGetTextExtent(lblUnpaidTaxesAmount)+10
    lblUnpaidTaxesAmount = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), 0, BusinessGUI.wnd)
    guiSetFont(lblUnpaidTaxesAmount, Utils.fonts.RB_11)
    guiLabelSetColor(lblUnpaidTaxesAmount, 242, 171, 18)
    lblUnpaidTaxesAmount.enabled = false

    --
    posY = posY + 25
    local lblBalance = guiCreateLabel(15, sH*(posY/sDH), sW*(width/sDW), 30, "В кассе:", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBalance, "left", false)
    guiSetFont(lblBalance, Utils.fonts.RB_10)
    lblBalance.enabled = false

    local offsetX = guiLabelGetTextExtent(lblBalance)+10
    lblBalance = Utils.guiCreateMoneyLabel(15+offsetX, sH*((posY)/sDH), exports.tmtaUtils:formatMoney(businessData.balance), BusinessGUI.wnd)
    guiSetFont(lblBalance, Utils.fonts.RB_11)
    guiLabelSetColor(lblBalance, 242, 171, 18)
    lblBalance.enabled = false

    posY = posY + 60
    local line = guiCreateLabel(0, sH*((posY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)

    posY = posY + 20
    local lblBusiness = guiCreateLabel(0, sH*(posY/sDH), sW*(width/sDW), 30, "УПРАВЛЕНИЕ БИЗНЕСОМ", false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(lblBusiness, "center", false)
    guiSetFont(lblBusiness, Utils.fonts.RB_11)
    guiLabelSetColor(lblBusiness, 242, 171, 18)
    lblBusiness.enabled = false

    posY = posY + 30
    local btnSell = guiCreateButton(sW*(0/sDW), sH*((posY)/sDH), sW*((width)/sDW), sH*(40/sDH), "Продать бизнес", false, BusinessGUI.wnd)
    guiSetFont(btnSell, Utils.fonts.RB_10)
    guiSetProperty(btnSell, "NormalTextColour", "FFCE070B")

    local line = guiCreateLabel(0, sH*((height-80)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)

    BusinessGUI.btnClose = guiCreateButton(0, sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), 'Закрыть', false, BusinessGUI.wnd)
    guiSetFont(BusinessGUI.btnClose, Utils.fonts.RB_10)
    addEventHandler("onClientGUIClick", BusinessGUI.btnClose, BusinessGUI.closeWindow, false)
end

function BusinessGUI.openWindow(businessData)
    if type(businessData) ~= 'table' then
        return
    end

    if isElement(BusinessGUI.wnd) then 
        return
    end

    if (businessData.owner) then
        if (businessData.owner ~= localPlayer:getData('nickname')) then
            return
        end
        BusinessGUI.renderManagerBusinessWindow(businessData)
    else
        BusinessGUI.renderInfoBusinessWindow(businessData)
    end

    showCursor(true)
    showChat(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function BusinessGUI.closeWindow()
    BusinessGUI.wnd.visible = false
    setTimer(destroyElement, 100, 1, BusinessGUI.wnd)
    showCursor(false)
    showChat(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end