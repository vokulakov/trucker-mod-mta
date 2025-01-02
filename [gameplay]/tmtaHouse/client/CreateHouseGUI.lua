CreateHouseGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 250, 520
local posX, posY = sDW-width-20, (sDH-height) /2

-- Окно создания дома
function CreateHouseGUI.render()
    if CreateHouseGUI.mainWnd then
        return
    end

    CreateHouseGUI.mainWnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "Создание дома", false)
    guiWindowSetSizable(CreateHouseGUI.mainWnd, false)
    guiWindowSetMovable(CreateHouseGUI.mainWnd, false)
    CreateHouseGUI.mainWnd.alpha = 0.8
    CreateHouseGUI.mainWnd.visible = false

    CreateHouseGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.btnClose, Utils.fonts.RR_10)
    guiSetProperty(CreateHouseGUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", CreateHouseGUI.btnClose, CreateHouseGUI.closeWindow, false)

    CreateHouseGUI.lblCursorInfo = guiCreateLabel(sW*(10/sDW), sH*(25/sDH), sW*(width/sDW), 50, "* Нажмите ПКМ, чтобы\n   скрыть/показать курсор", false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.lblCursorInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateHouseGUI.lblCursorInfo, 255, 0, 0)
    CreateHouseGUI.lblCursorInfo.enabled = false

    -- Позиция входа
    CreateHouseGUI.lblEnteryInfo = guiCreateLabel(0, sH*(60/sDH), sW*(width/sDW), 15, "Позиция входа", false, CreateHouseGUI.mainWnd)
    guiLabelSetHorizontalAlign(CreateHouseGUI.lblEnteryInfo, "center", false)
    guiSetFont(CreateHouseGUI.lblEnteryInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateHouseGUI.lblEnteryInfo, 255, 128, 0)
    CreateHouseGUI.lblEnteryInfo.enabled = false

    CreateHouseGUI.editEnteryPosX = guiCreateEdit(sW*(10/sDW), sH*(80/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editEnteryPosX, "Координата X")
    guiEditSetReadOnly(CreateHouseGUI.editEnteryPosX, true)

    CreateHouseGUI.editEnteryPosY = guiCreateEdit(sW*(10/sDW), sH*(115/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editEnteryPosY, "Координата Y")
    guiEditSetReadOnly(CreateHouseGUI.editEnteryPosY, true)

    CreateHouseGUI.editEnteryPosZ = guiCreateEdit(sW*(10/sDW), sH*(150/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editEnteryPosZ, "Координата Z")
    guiEditSetReadOnly(CreateHouseGUI.editEnteryPosZ, true)

    CreateHouseGUI.btnSetEnteryPos = guiCreateButton(sW*(10/sDW), sH*(185/sDH), sW*(width/sDW), sH*(25/sDH), "Установить позицию", false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.btnSetEnteryPos, Utils.fonts.RR_10)

    -- Интерьер
    CreateHouseGUI.lblInteriorInfo = guiCreateLabel(0, sH*(220/sDH), sW*(width/sDW), 15, "Интерьер", false, CreateHouseGUI.mainWnd)
    guiLabelSetHorizontalAlign(CreateHouseGUI.lblInteriorInfo, "center", false)
    guiSetFont(CreateHouseGUI.lblInteriorInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateHouseGUI.lblInteriorInfo, 255, 128, 0)
    CreateHouseGUI.lblInteriorInfo.enabled = false

    CreateHouseGUI.editInterior = guiCreateEdit(sW*(10/sDW), sH*(240/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editInterior, "Выберите интерьер")
    guiEditSetReadOnly(CreateHouseGUI.editInterior, true)

    CreateHouseGUI.btnSelectInterior = guiCreateButton(sW*(0/sDW), sH*(275/sDH), sW*(width/sDW), sH*(25/sDH), "Список интерьеров", false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.btnSelectInterior, Utils.fonts.RR_10)
    addEventHandler("onClientGUIClick", CreateHouseGUI.btnSelectInterior, 
        function()
            CreateHouseGUI.interiorWnd.visible = not CreateHouseGUI.interiorWnd.visible
        end, false
    )

    -- Парковочные места
    CreateHouseGUI.lblParkingSpacesInfo = guiCreateLabel(0, sH*(310/sDH), sW*(width/sDW), 15, "Парковочные места", false, CreateHouseGUI.mainWnd)
    guiLabelSetHorizontalAlign(CreateHouseGUI.lblParkingSpacesInfo, "center", false)
    guiSetFont(CreateHouseGUI.lblParkingSpacesInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateHouseGUI.lblParkingSpacesInfo, 255, 128, 0)
    CreateHouseGUI.lblParkingSpacesInfo.enabled = false

    CreateHouseGUI.editParkingSpaces = guiCreateEdit(sW*(10/sDW), sH*(330/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editParkingSpaces, "Количество мест")
    guiEditSetReadOnly(CreateHouseGUI.editParkingSpaces, true)

    -- Стоимость
    CreateHouseGUI.lblPriceInfo = guiCreateLabel(0, sH*(370/sDH), sW*(width/sDW), 15, "Стоимость", false, CreateHouseGUI.mainWnd)
    guiLabelSetHorizontalAlign(CreateHouseGUI.lblPriceInfo, "center", false)
    guiSetFont(CreateHouseGUI.lblPriceInfo, Utils.fonts.RR_10)
    guiLabelSetColor(CreateHouseGUI.lblPriceInfo, 255, 128, 0)
    CreateHouseGUI.lblPriceInfo.enabled = false

    CreateHouseGUI.editPrice = guiCreateEdit(sW*(10/sDW), sH*(390/sDH), sW*(width/sDW), sH*(30/sDH), "", false, CreateHouseGUI.mainWnd)
    guiSetProperty(CreateHouseGUI.editPrice, "ValidationString", "^[0-9]*$") 
    exports.tmtaGUI:setEditPlaceholder(CreateHouseGUI.editPrice, "Введите стоимость")
    addEventHandler("onClientGUIChanged", CreateHouseGUI.editPrice, CreateHouseGUI.onPriceChanged, false)

    CreateHouseGUI.btnReset = guiCreateButton(sW*(0/sDW), sH*((height-40-30)/sDH), sW*(width/sDW), sH*(25/sDH), "Очистить поля", false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.btnReset, Utils.fonts.RR_10)
    guiSetProperty(CreateHouseGUI.btnReset, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", CreateHouseGUI.btnReset, CreateHouseGUI.resetEditBox, false)

    CreateHouseGUI.btnCreate = guiCreateButton(sW*(0/sDW), sH*((height-40)/sDH), sW*(width/sDW), sH*(30/sDH), "Создать", false, CreateHouseGUI.mainWnd)
    guiSetFont(CreateHouseGUI.btnCreate, Utils.fonts.RR_10)
    guiSetProperty(CreateHouseGUI.btnCreate, "NormalTextColour", "FF01D51A")

    -- Окно интерьеров
    CreateHouseGUI.interiorWnd = guiCreateWindow(sW*((posX-540-20)/sDW), sH*(posY/sDH), sW*(540/sDW), sH*(410/sDH), "Выбор интерьера", false)
    guiWindowSetSizable(CreateHouseGUI.interiorWnd, false)
    guiWindowSetMovable(CreateHouseGUI.interiorWnd, false)
    CreateHouseGUI.interiorWnd.alpha = 0.8
    CreateHouseGUI.interiorWnd.visible = false

    CreateHouseGUI.btnCloseInteriorWnd = guiCreateButton(sW*((540-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), "X", false, CreateHouseGUI.interiorWnd)
    guiSetFont(CreateHouseGUI.btnCloseInteriorWnd, Utils.fonts.RR_10)
    guiSetProperty(CreateHouseGUI.btnCloseInteriorWnd, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", CreateHouseGUI.btnCloseInteriorWnd, 
        function()
            CreateHouseGUI.interiorWnd.visible = false
        end, false
    )

    --CreateHouseGUI.lblInteriorInfo = guiCreateLabel(sW*(230/sDW), sH*(25/sDH), sW*(540/sDW), 50, "* Выберите интерьер и нажмите 'Применить'", false, CreateHouseGUI.interiorWnd)
    --guiSetFont(CreateHouseGUI.lblInteriorInfo, Utils.fonts.RR_10)
    --guiLabelSetColor(CreateHouseGUI.lblInteriorInfo, 255, 0, 0)
    --CreateHouseGUI.lblInteriorInfo.enabled = false

    CreateHouseGUI.listInterior = guiCreateGridList(sW*(10/sDW), sH*(25/sDH), sW*(210/sDW), sH*(410/sDH), false, CreateHouseGUI.interiorWnd)
    guiGridListSetSortingEnabled(CreateHouseGUI.listInterior, false)
    guiGridListAddColumn(CreateHouseGUI.listInterior, " №", 0.15)
    guiGridListAddColumn(CreateHouseGUI.listInterior, "Название", 0.7)
    addEventHandler("onClientGUIClick", CreateHouseGUI.listInterior, CreateHouseGUI.onSelectedInterior, false)

    for interiorId, interiorData in pairs(Interiors.list) do
        local row = guiGridListAddRow(CreateHouseGUI.listInterior, interiorId, ' '..interiorData.name)
        guiGridListSetItemData(CreateHouseGUI.listInterior, row, 1, interiorId)
    end

    CreateHouseGUI.imgInterior = guiCreateStaticImage(sW*(230/sDW), sH*(55/sDH), sW*(300/sDW), sH*(300/sDH), "assets/images/choose.jpg", false, CreateHouseGUI.interiorWnd)

    -- Выбрать интерьер
    CreateHouseGUI.btnAcceptInterior = guiCreateButton(sW*(230/sDW), sH*(370/sDH), sW*(300/sDW), sH*(30/sDH), "Выбрать интерьер", false, CreateHouseGUI.interiorWnd)
    guiSetFont(CreateHouseGUI.btnAcceptInterior, Utils.fonts.RR_10)
    CreateHouseGUI.btnAcceptInterior.enabled = false
    guiSetProperty(CreateHouseGUI.btnAcceptInterior, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", CreateHouseGUI.btnAcceptInterior, CreateHouseGUI.onSelectedInterior, false)
end

addEventHandler("onClientGUIClick", root,
    function()
        if not CreateHouseGUI.mainWnd.visible then
            return
        end
        if source == CreateHouseGUI.btnSetEnteryPos then
            CreateHouseGUI.editEnteryPosX.text = localPlayer.position.x
            CreateHouseGUI.editEnteryPosY.text = localPlayer.position.y
            CreateHouseGUI.editEnteryPosZ.text = localPlayer.position.z
        elseif source == CreateHouseGUI.btnCreate then
            local x = tonumber(CreateHouseGUI.editEnteryPosX.text)
            local y = tonumber(CreateHouseGUI.editEnteryPosY.text)
            local z = tonumber(CreateHouseGUI.editEnteryPosZ.text)
            local interiorId = tonumber(CreateHouseGUI.editInterior.text)
            local price = tonumber(CreateHouseGUI.editPrice.text)
            local parkingSpaces = tonumber(CreateHouseGUI.editParkingSpaces.text)

            if (not x or not y or not z or not interiorId or not price or not parkingSpaces) then
                return exports.tmtaGUI:createNotice(sW*((sDW-400)/2 /sDW), sH*((sDH-150)/sDH), sW*(400/sDW), 'warning', 'Для создания дома необходимо заполнить все поля', true)
            elseif (price <= 0) then
                return exports.tmtaGUI:createNotice(sW*((sDW-400)/2 /sDW), sH*((sDH-150)/sDH), sW*(400/sDW), 'warning', 'Стоимость дома должна быть больше 0', true)
            end

            
            return triggerServerEvent("tmtaHouse.addHouseRequest", resourceRoot, x, y, z, interiorId, price, parkingSpaces)
        end
    end
)

-- Выбор интерьера
function CreateHouseGUI.onSelectedInterior()
    if not CreateHouseGUI.interiorWnd.visible then
        return
    end

    local selectedInterior = guiGridListGetSelectedItems(CreateHouseGUI.listInterior)
    if selectedInterior[1] then
        local listInteriorRow = tonumber(selectedInterior[1]["row"])
        local interiorId = guiGridListGetItemData(CreateHouseGUI.listInterior, listInteriorRow, 1)
        if interiorId then
            local imagePath = Interiors.list[tonumber(interiorId)].interiorImage
			guiStaticImageLoadImage(CreateHouseGUI.imgInterior, imagePath)
			local w, h = guiStaticImageGetNativeSize(CreateHouseGUI.imgInterior)
			guiSetSize(CreateHouseGUI.imgInterior, sW*(w/sDW), sH*(h/sDH), false)
            CreateHouseGUI.btnAcceptInterior.enabled = true

            -- Кнопка 'Выбрать интерьер'
            if source == CreateHouseGUI.btnAcceptInterior then
                CreateHouseGUI.editInterior.text = interiorId
                CreateHouseGUI.interiorWnd.visible = false
            end

            return
        end
    end

    guiStaticImageLoadImage(CreateHouseGUI.imgInterior, 'assets/images/choose.jpg')
	guiSetSize(CreateHouseGUI.imgInterior, sW*(300/sDW), sH*(300/sDH), false)
    CreateHouseGUI.btnAcceptInterior.enabled = false
end

-- Ввод стоимости дома (установка количества парковочных мест)
function CreateHouseGUI.onPriceChanged()
    if source ~= CreateHouseGUI.editPrice then
        return
    end
    local price = tonumber(CreateHouseGUI.editPrice.text)
    if not price then
        return
    end
    local parkingSpaces = 1
    for _, data in pairs(Config.parkingSpacesDependingOnprice) do
        if (price >= tonumber(data.minPrice)) then
            parkingSpaces = data.parkingSpaces
        end
    end
    if parkingSpaces == 0 then
        parkingSpaces = Config.parkingSpacesDependingOnprice[#Config.parkingSpacesDependingOnprice].parkingSpaces
    end
    CreateHouseGUI.editParkingSpaces.text = parkingSpaces
end

function CreateHouseGUI.resetEditBox()
    CreateHouseGUI.editEnteryPosX.text = ''
    CreateHouseGUI.editEnteryPosY.text = ''
    CreateHouseGUI.editEnteryPosZ.text = ''
    CreateHouseGUI.editInterior.text = ''
    CreateHouseGUI.editPrice.text = ''
    CreateHouseGUI.editParkingSpaces.text = ''
end

function CreateHouseGUI.changeCursorShowing()
    local state = not isCursorShowing()
    CreateHouseGUI.mainWnd.alpha = state and 0.8 or 0.5
    CreateHouseGUI.interiorWnd.alpha = CreateHouseGUI.mainWnd.alpha
    return showCursor(state)
end

-- Открытие окна
function CreateHouseGUI.openWindow()
    if CreateHouseGUI.mainWnd.visible then
        return
    end
    CreateHouseGUI.mainWnd.visible = true
    showCursor(true)
    bindKey("mouse2", "up", CreateHouseGUI.changeCursorShowing)
end

function CreateHouseGUI.closeWindow()
    if not CreateHouseGUI.mainWnd.visible then
        return
    end
    CreateHouseGUI.mainWnd.visible = false
    CreateHouseGUI.interiorWnd.visible = false
    showCursor(false)
    unbindKey("mouse2", "up", CreateHouseGUI.changeCursorShowing)
end

addEvent("tmtaHouse.openCreateHouseWindow", true)
addEventHandler("tmtaHouse.openCreateHouseWindow", root, CreateHouseGUI.openWindow)