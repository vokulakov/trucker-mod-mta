CreateBusinessGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 250, 500
local posX, posY = sDW-width-20, (sDH-height) /2

function CreateBusinessGUI.render()
    if CreateBusinessGUI.wnd then
        return
    end

    CreateBusinessGUI.wnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "Создание бизнеса", false)
    guiWindowSetSizable(CreateBusinessGUI.wnd, false)
    guiWindowSetMovable(CreateBusinessGUI.wnd, false)
    CreateBusinessGUI.wnd.alpha = 0.8
    CreateBusinessGUI.wnd.visible = false

    CreateBusinessGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, CreateBusinessGUI.wnd)
    guiSetFont(CreateBusinessGUI.btnClose, Utils.fonts.RR_10)
    guiSetProperty(CreateBusinessGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", CreateBusinessGUI.btnClose, CreateBusinessGUI.closeWindow, false)

    CreateBusinessGUI.lblCursorInfo = guiCreateLabel(sW*(10/sDW), sH*(25/sDH), sW*(width/sDW), 50, "* Нажмите ПКМ, чтобы\n   скрыть/показать курсор", false, CreateBusinessGUI.wnd)
    guiSetFont(CreateBusinessGUI.lblCursorInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateBusinessGUI.lblCursorInfo, 255, 0, 0)
    CreateBusinessGUI.lblCursorInfo.enabled = false

    -- Тип бизнеса
    CreateBusinessGUI.lblType = guiCreateLabel(0, sH*(65/sDH), sW*(width/sDW), 15, "Тип бизнеса", false, CreateBusinessGUI.wnd)
    guiLabelSetHorizontalAlign(CreateBusinessGUI.lblType, "center", false)
    guiSetFont(CreateBusinessGUI.lblType, Utils.fonts.RR_10)
    guiLabelSetColor(CreateBusinessGUI.lblType, 255, 128, 0)
    CreateBusinessGUI.lblType.enabled = false

    CreateBusinessGUI.listType = guiCreateComboBox(sW*(10/sDW), sH*(85/sDH), sW*(width/sDW), sH*(130/sDH), "Выберите тип бизнеса...", false, CreateBusinessGUI.wnd )
    guiSetFont(CreateBusinessGUI.listType, Utils.fonts.RR_10)

    for _, typeData in ipairs (Config.businessType) do
		guiComboBoxAddItem(CreateBusinessGUI.listType, typeData.name)
	end

    -- Расположение
    CreateBusinessGUI.lblPosition = guiCreateLabel(0, sH*(125/sDH), sW*(width/sDW), 15, "Расположение", false, CreateBusinessGUI.wnd)
    guiLabelSetHorizontalAlign(CreateBusinessGUI.lblPosition, "center", false)
    guiSetFont(CreateBusinessGUI.lblPosition, Utils.fonts.RR_10)
    guiLabelSetColor(CreateBusinessGUI.lblPosition, 255, 128, 0)
    CreateBusinessGUI.lblPosition.enabled = false

    CreateBusinessGUI.editPosX = guiCreateEdit(sW*(10/sDW), sH*(145/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateBusinessGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(CreateBusinessGUI.editPosX, "Координата X")
    guiEditSetReadOnly(CreateBusinessGUI.editPosX, true)

    CreateBusinessGUI.editPosY = guiCreateEdit(sW*(10/sDW), sH*(180/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateBusinessGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(CreateBusinessGUI.editPosY, "Координата Y")
    guiEditSetReadOnly(CreateBusinessGUI.editPosY, true)

    CreateBusinessGUI.editPosZ = guiCreateEdit(sW*(10/sDW), sH*(215/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateBusinessGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(CreateBusinessGUI.editPosZ, "Координата Z")
    guiEditSetReadOnly(CreateBusinessGUI.editPosZ, true)

    CreateBusinessGUI.btnSetPos = guiCreateButton(sW*(10/sDW), sH*(255/sDH), sW*(width/sDW), sH*(25/sDH), "Установить позицию", false, CreateBusinessGUI.wnd)
    guiSetFont(CreateBusinessGUI.btnSetPos, Utils.fonts.RR_10)

    -- Доход
    CreateBusinessGUI.lblRevenueInfo = guiCreateLabel(0, sH*(295/sDH), sW*(width/sDW), 15, "Доход", false, CreateBusinessGUI.wnd)
    guiLabelSetHorizontalAlign(CreateBusinessGUI.lblRevenueInfo, "center", false)
    guiSetFont(CreateBusinessGUI.lblRevenueInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateBusinessGUI.lblRevenueInfo, 255, 128, 0)
    CreateBusinessGUI.lblRevenueInfo.enabled = false

    CreateBusinessGUI.editRevenue = guiCreateEdit(sW*(10/sDW), sH*(315/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateBusinessGUI.wnd)
    exports.tmtaGUI:setEditPlaceholder(CreateBusinessGUI.editRevenue, "Сумма дохода")
    guiEditSetReadOnly(CreateBusinessGUI.editRevenue, true)
    
    -- Стоимость
    CreateBusinessGUI.lblPriceInfo = guiCreateLabel(0, sH*(355/sDH), sW*(width/sDW), 15, "Стоимость", false, CreateBusinessGUI.wnd)
    guiLabelSetHorizontalAlign(CreateBusinessGUI.lblPriceInfo, "center", false)
    guiSetFont(CreateBusinessGUI.lblPriceInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateBusinessGUI.lblPriceInfo, 255, 128, 0)
    CreateBusinessGUI.lblPriceInfo.enabled = false

    CreateBusinessGUI.editPrice = guiCreateEdit(sW*(10/sDW), sH*(375/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateBusinessGUI.wnd)
    guiSetProperty(CreateBusinessGUI.editPrice, "ValidationString", "^[0-9]*$") 
    exports.tmtaGUI:setEditPlaceholder(CreateBusinessGUI.editPrice, "Введите стоимость")
    addEventHandler("onClientGUIChanged", CreateBusinessGUI.editPrice, CreateBusinessGUI.onPriceChanged, false)

    CreateBusinessGUI.btnReset = guiCreateButton(sW*(0/sDW), sH*((height-40-30)/sDH), sW*(width/sDW), sH*(25/sDH), "Очистить поля", false, CreateBusinessGUI.wnd)
    guiSetFont(CreateBusinessGUI.btnReset, Utils.fonts.RR_10)
    guiSetProperty(CreateBusinessGUI.btnReset, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", CreateBusinessGUI.btnReset, CreateBusinessGUI.reset, false)

    CreateBusinessGUI.btnCreate = guiCreateButton(sW*(0/sDW), sH*((height-40)/sDH), sW*(width/sDW), sH*(30/sDH), "Создать", false, CreateBusinessGUI.wnd)
    guiSetFont(CreateBusinessGUI.btnCreate, Utils.fonts.RR_10)
    guiSetProperty(CreateBusinessGUI.btnCreate, "NormalTextColour", "FF01D51A")
end

addEventHandler("onClientGUIClick", root,
    function()
        if not CreateBusinessGUI.wnd.visible then
            return
        end
        if (source == CreateBusinessGUI.btnSetPos) then
            CreateBusinessGUI.editPosX.text = localPlayer.position.x
            CreateBusinessGUI.editPosY.text = localPlayer.position.y
            CreateBusinessGUI.editPosZ.text = localPlayer.position.z
        elseif (source == CreateBusinessGUI.btnCreate) then
            local x = tonumber(CreateBusinessGUI.editPosX.text)
            local y = tonumber(CreateBusinessGUI.editPosY.text)
            local z = tonumber(CreateBusinessGUI.editPosZ.text)

            local typeItem = guiComboBoxGetSelected(CreateBusinessGUI.listType)
            local text = guiComboBoxGetItemText(CreateBusinessGUI.listType, typeItem)
            
            local price = tonumber(CreateBusinessGUI.editPrice.text) or 0

            if (typeItem == -1 or not x or not y or not z or not price) then
                return exports.tmtaGUI:createNotice(sW*((sDW-400)/2 /sDW), sH*((sDH-150)/sDH), sW*(400/sDW), 'warning', 'Для создания бизнеса необходимо заполнить все поля', true)
            elseif (price <= 0) then
                return exports.tmtaGUI:createNotice(sW*((sDW-400)/2 /sDW), sH*((sDH-150)/sDH), sW*(400/sDW), 'warning', 'Стоимость бизнеса должна быть больше 0', true)
            end

            return
        end
    end
)

function CreateBusinessGUI.onPriceChanged()
    if source ~= CreateBusinessGUI.editPrice then
        return
    end
    local price = tonumber(CreateBusinessGUI.editPrice.text)
    if not price then
        return
    end
end

function CreateBusinessGUI.reset()
    CreateBusinessGUI.editPosX.text = ''
    CreateBusinessGUI.editPosY.text = ''
    CreateBusinessGUI.editPosZ.text = ''
    CreateBusinessGUI.editRevenue.text = ''
    CreateBusinessGUI.editPrice.text = ''

    guiComboBoxSetSelected(CreateBusinessGUI.listType, -1)
end

function CreateBusinessGUI.changeCursorShowing()
    local state = not isCursorShowing()
    CreateBusinessGUI.wnd.alpha = state and 0.8 or 0.5
    return showCursor(state)
end

function CreateBusinessGUI.openWindow()
    if CreateBusinessGUI.wnd.visible then
        return
    end
    CreateBusinessGUI.wnd.visible = true
    showCursor(true)
    bindKey("mouse2", "up", CreateBusinessGUI.changeCursorShowing)
end

function CreateBusinessGUI.closeWindow()
    if not CreateBusinessGUI.wnd.visible then
        return
    end
    CreateBusinessGUI.wnd.visible = false
    showCursor(false)
    unbindKey("mouse2", "up", CreateBusinessGUI.changeCursorShowing)
end

addEvent("tmtaBusiness.openCreateBusinessWindow", true)
addEventHandler("tmtaBusiness.openCreateBusinessWindow", root, CreateBusinessGUI.openWindow)