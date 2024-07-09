CargoRewardGUI = {}

local width, height = 320, 425

local items = {
    { name = 'По договору', color = {r = 255, g = 255, b = 255}, rewardValue = 0, expValue = 0 },
    { name = 'Бонус', color = {r = 0, g = 255, b = 150}, rewardValue = 0, expValue = 0 },
    { name = 'Неустойка', color = {r = 255, g = 10, b = 0}, rewardValue = 0, expValue = 0 },
    {},
    { name = 'Итого', color = {r = 242, g = 171, b = 18}, rewardValue = 0, expValue = 0 },
}

function CargoRewardGUI.renderWindow()
    CargoRewardGUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), '', false)
    exports.tmtaGUI:windowCentralize(CargoRewardGUI.wnd)
    guiWindowSetSizable(CargoRewardGUI.wnd, false)
    guiWindowSetMovable(CargoRewardGUI.wnd, false)
    CargoRewardGUI.wnd.alpha = 0.9

    local offsetPosY = 25
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 5
    CargoRewardGUI.lblTitle = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), '', false, CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(CargoRewardGUI.lblTitle, "center", false)
    guiSetFont(CargoRewardGUI.lblTitle, guiFont.RB_13)
    guiLabelSetColor(CargoRewardGUI.lblTitle, 0, 255, 150)
    CargoRewardGUI.lblTitle.enabled = false

    offsetPosY = offsetPosY + 25
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 15

    CargoRewardGUI.lblDescription = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(50/sDH), '', false,  CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(CargoRewardGUI.lblDescription, "center", false)
    guiSetFont(CargoRewardGUI.lblDescription, guiFont.RR_10)
    CargoRewardGUI.lblDescription.enabled = false

    offsetPosY = offsetPosY + 60
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 5
    local lbl = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'ВОЗНАГРАЖДЕНИЕ', false, CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "center", false)
    guiSetFont(lbl, guiFont.RB_13)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    offsetPosY = offsetPosY + 25
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    local rowCount = #items
    
    local _offsetPosX = 120
    offsetPosY = offsetPosY + 25
    local line = exports.tmtaTextures:createStaticImage(sW*(_offsetPosX/sDW), sH*((offsetPosY)/sDH), 1, sH*((25*rowCount)/sDH), 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local lbl = guiCreateLabel(sW*(_offsetPosX/sDW), sH*((offsetPosY-25)/sDH), sW*((100)/sDW), sH*(25/sDH), 'Деньги', false,  CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiLabelSetVerticalAlign(lbl, 'center', false)
    guiSetFont(lbl, guiFont.RB_10)
    lbl.enabled = false

    _offsetPosX = _offsetPosX + 100
    local lbl = guiCreateLabel(sW*(_offsetPosX/sDW), sH*((offsetPosY-25)/sDH), sW*((100)/sDW), sH*(25/sDH), 'Опыт', false,  CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiLabelSetVerticalAlign(lbl, 'center', false)
    guiSetFont(lbl, guiFont.RB_10)
    lbl.enabled = false

    local line = exports.tmtaTextures:createStaticImage(sW*(_offsetPosX/sDW), sH*((offsetPosY)/sDH), 1, sH*((25*rowCount)/sDH), 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    for item, data in pairs(items) do
        if (data.name) then
            local lbl = guiCreateLabel(10, sH*((offsetPosY)/sDH), sW*((100)/sDW), sH*(25/sDH), data.name, false, CargoRewardGUI.wnd)
            guiLabelSetVerticalAlign(lbl, 'center', false)
            guiSetFont(lbl, guiFont.RB_10)
            guiLabelSetColor(lbl, data.color.r, data.color.g, data.color.b)
            lbl.enabled = false

            local lbl = guiCreateLabel(sW*(120/sDW), sH*((offsetPosY)/sDH), sW*((100)/sDW), sH*(25/sDH), data.rewardValue, false,  CargoRewardGUI.wnd)
            guiLabelSetHorizontalAlign(lbl, 'center', false)
            guiLabelSetVerticalAlign(lbl, 'center', false)
            guiLabelSetColor(lbl, data.color.r, data.color.g, data.color.b)
            guiSetFont(lbl, guiFont.RR_10)
            lbl.enabled = false

            local lbl = guiCreateLabel(sW*(220/sDW), sH*((offsetPosY)/sDH), sW*((100)/sDW), sH*(25/sDH), data.expValue, false,  CargoRewardGUI.wnd)
            guiLabelSetHorizontalAlign(lbl, 'center', false)
            guiLabelSetVerticalAlign(lbl, 'center', false)
            guiLabelSetColor(lbl, data.color.r, data.color.g, data.color.b)
            guiSetFont(lbl, guiFont.RR_10)
            lbl.enabled = false
        end

        local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
        guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
        line.enabled = false
        offsetPosY = offsetPosY + 25
    end

    --
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 15

    local lvl = exports.tmtaExperience:getPlayerLvl()
    local rank = exports.tmtaExperience:getRankFromLvl(lvl)
    local exp = exports.tmtaExperience:getPlayerExp()
    local requiredExp = exports.tmtaExperience:getExpToLevelUp(tonumber(lvl))
    
    local info = string.format("Уровень %s - %s\nОпыт: %s / %s", lvl, rank, exp, requiredExp)
    local lbl = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(35/sDH), info, false,  CargoRewardGUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "center", false)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    offsetPosY = offsetPosY + 35 + 10
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, CargoRewardGUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 10
    CargoRewardGUI.btnContinue = guiCreateButton(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(35/sDH), 'Продолжить', false, CargoRewardGUI.wnd)
    guiSetFont(CargoRewardGUI.btnContinue, guiFont.RR_11)
    guiSetProperty(CargoRewardGUI.btnContinue, "NormalTextColour", "FF01D51A")
    guiSetProperty(CargoRewardGUI.btnContinue, 'HoverTextColour', 'FF21b1ff')

    addEventHandler("onClientGUIClick", CargoRewardGUI.btnContinue, 
        function()
            CargoRewardGUI.wnd.visible = false
            setTimer(destroyElement, 100, 1, CargoRewardGUI.wnd)
            showCursor(false)
            setPlayerUI(false)
            
            Utils.showNotice("Для поиска груза используйте #FFA07Aпланшет #FFFFFF(нажмите #FFA07A'F10'#FFFFFF)")
        end, false)
end

function CargoRewardGUI.showOrderCompleteWindow(orderRewardData)
    if (not orderRewardData or type(orderRewardData) ~= 'table') then
        return false
    end

    items[1].rewardValue = string.format("%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderBaseReward or 0))
    items[1].expValue = string.format("%s XP", orderRewardData.orderBaseExp or 0)
    
    items[2].rewardValue = string.format("+%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderBonusReward or 0))
    items[2].expValue = string.format("+%s XP", orderRewardData.orderBonusExp or 0)

    items[3].rewardValue = string.format("-%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderSanctionReward or 0))
    items[3].expValue = string.format("-%s XP", orderRewardData.orderSanctionExp or 0)
    
    items[5].rewardValue = string.format("%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderTotalReward or 0))
    items[5].expValue = string.format("%s XP", orderRewardData.orderTotalExp or 0)
    
    CargoRewardGUI.renderWindow()
    CargoRewardGUI.lblTitle.text = 'ЗАКАЗ ВЫПОЛНЕН'
    guiLabelSetColor(CargoRewardGUI.lblTitle, 0, 255, 150)

    CargoRewardGUI.lblDescription.text = string.format("Груз '%s'\nдоставлен по маршруту\n'%s'", orderRewardData.orderName, orderRewardData.orderRoute)

    setPlayerUI(true)
    showCursor(true)
    exports.tmtaSounds:playSound('youwin')
end

function CargoRewardGUI.showOrderCancelWindow(orderRewardData)
    if (not orderRewardData or type(orderRewardData) ~= 'table' or isElement(CargoRewardGUI.wnd)) then
        return false
    end

    items[1].rewardValue = string.format("%s ₽", 0)
    items[1].expValue = string.format("%s XP", 0)
    
    items[2].rewardValue = string.format("+%s ₽", 0)
    items[2].expValue = string.format("+%s XP", 0)

    items[3].rewardValue = string.format("-%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderSanctionReward or 0))
    items[3].expValue = string.format("-%s XP", 0)
    
    items[5].rewardValue = string.format("-%s ₽", exports.tmtaUtils:formatMoney(orderRewardData.orderTotalReward or 0))
    items[5].expValue = string.format("%s XP", 0)

    CargoRewardGUI.renderWindow()
    CargoRewardGUI.lblTitle.text = 'ЗАКАЗ АННУЛИРОВАН'
    guiLabelSetColor(CargoRewardGUI.lblTitle, 255, 10, 0)

    CargoRewardGUI.lblDescription.text = string.format("Груз '%s'\nне доставлен по маршруту\n'%s'", orderRewardData.orderName, orderRewardData.orderRoute)

    setPlayerUI(true)
    showCursor(true)
    exports.tmtaSounds:playSound('youlost')
end