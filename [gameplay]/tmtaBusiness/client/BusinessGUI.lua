BusinessGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 350, 220
local posX, posY = (sDW-width) /2, (sDH-height) /2

local textures = {
	moneyIcon = exports.tmtaTextures:createTexture('i_money'),
}

function BusinessGUI.render(businessData)
    if isElement(BusinessGUI.wnd) then 
        return 
    end

    local isSell = (not businessData.owner) and true or false
    businessData.owner = businessData.owner or 'государство'
    local height = isSell and height+40 or height

    BusinessGUI.wnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
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
    BusinessGUI.lblBusinessOwner = guiCreateLabel(15+offsetX, sH*(130/sDH), sW*(width/sDW), 30, businessData.owner, false, BusinessGUI.wnd)
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
    BusinessGUI.iconMoney = exports.tmtaTextures:createStaticImage(15+offsetX, sH*((155)/sDH), sW*(32 /sDW), sH*(28 /sDH), 'i_money', false, BusinessGUI.wnd)
    BusinessGUI.iconMoney.enabled = false

    BusinessGUI.lblBusinessPrice = guiCreateLabel(15+offsetX+32+5, sH*((155+5)/sDH), sW*(width/sDW), 30, businessData.price, false, BusinessGUI.wnd)
    guiLabelSetHorizontalAlign(BusinessGUI.lblBusinessPrice, "left", false)
    guiSetFont(BusinessGUI.lblBusinessPrice, Utils.fonts.RB_11)
    guiLabelSetColor(BusinessGUI.lblBusinessPrice, 242, 171, 18)
    BusinessGUI.lblBusinessPrice.enabled = false

    -- Кнопки
    if isSell then
        BusinessGUI.btnBuy = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), "Купить", false, BusinessGUI.wnd)
        guiSetFont(BusinessGUI.btnBuy, Utils.fonts.RR_10)
        guiSetProperty(BusinessGUI.btnBuy, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", BusinessGUI.btnBuy, 
            function()
                Business.buy(tonumber(businessData.number))
            end, false
        )
    end
end

function BusinessGUI.openWindow(businessData)
    if type(businessData) ~= 'table' then
        return
    end
    BusinessGUI.render(businessData)
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