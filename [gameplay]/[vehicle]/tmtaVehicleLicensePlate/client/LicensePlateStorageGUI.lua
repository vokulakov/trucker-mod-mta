LicensePlateStorageGUI = {}

local _playerLicensePlateSlots = {}
local _currentSelectLicensePlateSlot = nil

function LicensePlateStorageGUI.create(tabPanel)
    if not isElement(tabPanel) then
        return
    end

    LicensePlateStorageGUI.tab = guiCreateTab("Хранилище номерных знаков", tabPanel)

    local tabWidth, tabHeight = guiGetSize(tabPanel, false)

    -- line
    local colPosX = tabWidth/1.7
    local line = exports.tmtaTextures:createStaticImage(colPosX, sH*((5) /sDH), 1, tabHeight-37, 'part_dot', false, LicensePlateStorageGUI.tab)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false
    
    --
    local offsetPosY = 20
    local lbl = guiCreateLabel(0, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), "ВАШИ НОМЕРНЫЕ ЗНАКИ", false, LicensePlateStorageGUI.tab)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    offsetPosY = offsetPosY + 25
    LicensePlateStorageGUI.licenesPlateList = guiCreateGridList(sW*(10 /sDW), sH*(offsetPosY /sDH), colPosX-sW*(20 /sDW), sH*((330) /sDH), false, LicensePlateStorageGUI.tab)
    guiGridListSetSelectionMode(LicensePlateStorageGUI.licenesPlateList, 0)
    guiGridListSetSortingEnabled(LicensePlateStorageGUI.licenesPlateList, false)
    addEventHandler('onClientGUIClick', LicensePlateStorageGUI.licenesPlateList, LicensePlateStorageGUI.onPlayerClickLicensePlateList, false)

    guiGridListAddColumn(LicensePlateStorageGUI.licenesPlateList, "Слот", 0.15)
    guiGridListAddColumn(LicensePlateStorageGUI.licenesPlateList, "Номерной знак", 0.45)
    guiGridListAddColumn(LicensePlateStorageGUI.licenesPlateList, "Срок хранения", 0.3)

    --
    local offsetPosY = 390
    local line = exports.tmtaTextures:createStaticImage(10, sH*(offsetPosY/sDH), colPosX-20, 1, 'part_dot', false, LicensePlateStorageGUI.tab)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 10
    LicensePlateStorageGUI.lblPreviewLicensePlateTitle = guiCreateLabel(0, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), "ВАШ ТЕКУЩИЙ НОМЕРНОЙ ЗНАК", false, LicensePlateStorageGUI.tab)
    guiLabelSetHorizontalAlign(LicensePlateStorageGUI.lblPreviewLicensePlateTitle, 'center', false)
    guiSetFont(LicensePlateStorageGUI.lblPreviewLicensePlateTitle, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(LicensePlateStorageGUI.lblPreviewLicensePlateTitle, 242, 171, 18)
    LicensePlateStorageGUI.lblPreviewLicensePlateTitle.enabled = false

    --
    --local btnPayHeight = sH*(45/sDH)

    -- LicensePlateStorageGUI.btnPay = guiCreateButton(10, tabHeight-35-btnPayHeight, colPosX-20, btnPayHeight, 'Купить слот', false, LicensePlateGUI.tabRegistrate)
    -- guiSetFont(LicensePlateStorageGUI.btnPay, LicensePlateGUI.font.RR_11)
    -- guiSetProperty(LicensePlateStorageGUI.btnPay, "NormalTextColour", "FF01D51A")
    -- LicensePlateStorageGUI.btnPay.enabled = false
    --addEventHandler('onClientGUIClick', LicensePlateGUI.btnPay, LicensePlateGUI.onClientGUIClickBtnPay, false)

    --
    local offsetPosY = 20
    local lbl = guiCreateLabel(colPosX, sH*((20) /sDH), tabWidth-colPosX, sH*(30/sDH), "ИНФОРМАЦИЯ", false, LicensePlateStorageGUI.tab)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    local offsetPosX = colPosX+sW*(10/sDW)
    offsetPosY = offsetPosY + 25

    local lbl = guiCreateLabel(offsetPosX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), 'Номер слота:', false, LicensePlateStorageGUI.tab)
    guiSetFont(lbl, LicensePlateGUI.font.RR_10)
    guiLabelSetColor(lbl, 125, 125, 125)
    lbl.enabled = false

    local offsetX = guiLabelGetTextExtent(lbl)+5
    LicensePlateStorageGUI.lblNumberSlot = guiCreateLabel(offsetPosX+offsetX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '-', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.lblNumberSlot, LicensePlateGUI.font.RB_10)
    guiLabelSetColor(LicensePlateStorageGUI.lblNumberSlot, 242, 171, 18)
    LicensePlateStorageGUI.lblNumberSlot.enabled = false
    
    offsetPosY = offsetPosY + 20
    local lbl = guiCreateLabel(offsetPosX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), 'Номерной знак:', false, LicensePlateStorageGUI.tab)
    guiSetFont(lbl, LicensePlateGUI.font.RR_10)
    guiLabelSetColor(lbl, 125, 125, 125)
    lbl.enabled = false

    local offsetX = guiLabelGetTextExtent(lbl)+5
    LicensePlateStorageGUI.lblLicensePlate = guiCreateLabel(offsetPosX+offsetX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '-', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.lblLicensePlate, LicensePlateGUI.font.RB_10)
    guiLabelSetColor(LicensePlateStorageGUI.lblLicensePlate, 242, 171, 18)
    LicensePlateStorageGUI.lblLicensePlate.enabled = false

    offsetPosY = offsetPosY + 20
    local lbl = guiCreateLabel(offsetPosX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), 'Срок хранения:', false, LicensePlateStorageGUI.tab)
    guiSetFont(lbl, LicensePlateGUI.font.RR_10)
    guiLabelSetColor(lbl, 125, 125, 125)
    lbl.enabled = false

    local offsetX = guiLabelGetTextExtent(lbl)+5
    LicensePlateStorageGUI.lblDeleteAtString = guiCreateLabel(offsetPosX+offsetX, sH*(offsetPosY/sDH), colPosX, sH*(30/sDH), '-', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.lblDeleteAtString, LicensePlateGUI.font.RB_10)
    guiLabelSetColor(LicensePlateStorageGUI.lblDeleteAtString, 242, 171, 18)
    LicensePlateStorageGUI.lblDeleteAtString.enabled = false

    --
    offsetPosY = offsetPosY + 40
    local line = exports.tmtaTextures:createStaticImage(offsetPosX, sH*(offsetPosY/sDH), tabWidth-colPosX-sW*(20/sDW), 1, 'part_dot', false, LicensePlateStorageGUI.tab)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 10
    local lbl = guiCreateLabel(colPosX, sH*((offsetPosY) /sDH), tabWidth-colPosX, sH*(30/sDH), "УПРАВЛЕНИЕ", false, LicensePlateStorageGUI.tab)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, LicensePlateGUI.font.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    offsetPosY = offsetPosY + 30
    LicensePlateStorageGUI.btnSetOnVehicle = guiCreateButton(offsetPosX, sH*((offsetPosY) /sDH), tabWidth-colPosX-sW*(20/sDW), sH*(40 /sDH), 'Установить', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.btnSetOnVehicle, LicensePlateGUI.font.RR_10)
    guiSetProperty(LicensePlateStorageGUI.btnSetOnVehicle, 'HoverTextColour', 'FF21b1ff')
    LicensePlateStorageGUI.btnSetOnVehicle.enabled = false
    addEventHandler('onClientGUIClick', LicensePlateStorageGUI.btnSetOnVehicle, LicensePlateStorageGUI.onPlayerClickBtnSetLicensePlateOnVehicle, false)

    --
    offsetPosY = offsetPosY + 45
    LicensePlateStorageGUI.btnDeleteLicensePlate = guiCreateButton(offsetPosX, sH*((offsetPosY) /sDH), tabWidth-colPosX-sW*(20/sDW), sH*(40 /sDH), 'Удалить', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.btnDeleteLicensePlate, LicensePlateGUI.font.RR_10)
    guiSetProperty(LicensePlateStorageGUI.btnDeleteLicensePlate, 'HoverTextColour', 'FF21b1ff')
    LicensePlateStorageGUI.btnDeleteLicensePlate.enabled = false
    addEventHandler('onClientGUIClick', LicensePlateStorageGUI.btnDeleteLicensePlate, LicensePlateStorageGUI.onPlayerClickBtnDeleteLicensePlate, false)

    --
    offsetPosY = offsetPosY + 80
    LicensePlateStorageGUI.btnExpandStorage = guiCreateButton(offsetPosX, sH*((offsetPosY) /sDH), tabWidth-colPosX-sW*(20/sDW), sH*(45 /sDH), 'Расширить хранилище', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.btnExpandStorage, LicensePlateGUI.font.RR_10)
    guiSetProperty(LicensePlateStorageGUI.btnExpandStorage, 'HoverTextColour', 'FF21b1ff')
    addEventHandler('onClientGUIClick', LicensePlateStorageGUI.btnExpandStorage, LicensePlateStorageGUI.onPlayerClickBtnExpandStorage, false)

    --
    offsetPosY = 455
    LicensePlateStorageGUI.btnPutInStorage = guiCreateButton(offsetPosX, sH*((offsetPosY) /sDH), tabWidth-colPosX-sW*(20/sDW), sH*(45 /sDH), 'Поместить текущий\nномерной знак в хранилище', false, LicensePlateStorageGUI.tab)
    guiSetFont(LicensePlateStorageGUI.btnPutInStorage, LicensePlateGUI.font.RR_10)
    guiSetProperty(LicensePlateStorageGUI.btnPutInStorage, 'HoverTextColour', 'FF21b1ff')
    addEventHandler('onClientGUIClick', LicensePlateStorageGUI.btnPutInStorage, LicensePlateStorageGUI.onPlayerClickBtnPutInStorage, false)

    return LicensePlateStorageGUI.tab
end

function LicensePlateStorageGUI.updatePlayerLicensePlateList(playerLicensePlates)
    local list = LicensePlateStorageGUI.licenesPlateList
    guiGridListClear(list)

    local licensePlateSlotCount = Utils.getPlayerLicensePlateSlotCount()
    local freeLicensePlateSlotCount = Utils.getPlayerFreeLicensePlateSlotCount()

    -- Инициализация слотов
    _playerLicensePlateSlots = {}
    local slotMaxCount = (licensePlateSlotCount > Config.MAX_STORAGE_SIZE) and licensePlateSlotCount or Config.MAX_STORAGE_SIZE
    for slotIndex = 1, slotMaxCount do
        local _isAvailable = (slotIndex <= licensePlateSlotCount)
        local _isFree = (_isAvailable and slotIndex > (licensePlateSlotCount-freeLicensePlateSlotCount))

        _playerLicensePlateSlots[slotIndex] = {
            slot = tonumber(slotIndex),
            free = _isFree,
            available = _isAvailable,
        }
    end

    -- Добавляет номерные знаки в слоты
    if (type(playerLicensePlates) == 'table' and #playerLicensePlates > 0) then
        -- Сортировка по времени удаления
        table.sort(playerLicensePlates, function(a, b) 
            return (a.deleteAt < b.deleteAt) 
        end)

        for slotIndex, licensePlate in ipairs(playerLicensePlates) do
            _playerLicensePlateSlots[slotIndex].licensePlate = licensePlate
        end
    end

    -- Поиск первого слота для покупки
    for slotIndex, slotData in pairs(_playerLicensePlateSlots) do
        if (not slotData.available and not slotData.free) then
            _playerLicensePlateSlots[slotIndex].price = exports.tmtaUtils:roundUpHundred(
                Config.STARTING_PRICE_STORAGE_SLOT + Config.STARTING_PRICE_STORAGE_SLOT * (slotIndex - 1)
            )
            break
        end
    end 

    -- Вывод слотов
    for slotIndex, slotData in pairs(_playerLicensePlateSlots) do
        local row = guiGridListAddRow(list)
        guiGridListSetItemText(list, row, 1, '    '..slotIndex, true, true)
        guiGridListSetItemData(list, row, 1, slotIndex)

        _playerLicensePlateSlots[slotIndex].row = row

        local colorR, colorG, colorB = 255, 255, 255
        local licensePlateString = ''
        local licensePlateDeleteAtString = ''

        local sectionState = true

        if (slotData.licensePlate) then
            local licensePlate = slotData.licensePlate
            local formattedTime = exports.tmtaUtils:secondAsTimeFormat(tonumber(licensePlate.deleteAt - getRealTime().timestamp))
            
            licensePlateString = formatLicensePlateToString(licensePlate.type, licensePlate.numberPlate)
            licensePlateDeleteAtString = string.format('%d д. %02d ч. %02d мин.', formattedTime.d, formattedTime.h, formattedTime.i)
            sectionState = false

            _playerLicensePlateSlots[slotIndex].licensePlateString = licensePlateString
            _playerLicensePlateSlots[slotIndex].licensePlateDeleteAtString = licensePlateDeleteAtString
        elseif (slotData.free) then
            licensePlateString = (' '):rep(25)..'  свободное место'
            colorR, colorG, colorB = 0, 175, 0
        elseif (slotData.price) then
            licensePlateString = string.format("%s %s ₽", (' '):rep(35), tostring(exports.tmtaUtils:formatMoney(slotData.price)))
            colorR, colorG, colorB = 242, 171, 18
        elseif (not slotData.available) then
            licensePlateString = (' '):rep(26)..'  заблокировано'
            colorR, colorG, colorB = 60, 60, 60
        end

        guiGridListSetItemText(list, row, 2, licensePlateString, sectionState, false)
        guiGridListSetItemText(list, row, 3, licensePlateDeleteAtString, sectionState, false)

        guiGridListSetItemColor(list, row, 1, colorR, colorG, colorB)
        guiGridListSetItemColor(list, row, 2, colorR, colorG, colorB)
        guiGridListSetItemColor(list, row, 3, colorR, colorG, colorB)
    end
end

function LicensePlateStorageGUI.resetLicensePlateInfo()
    LicensePlateStorageGUI.lblNumberSlot.text = '-'
    LicensePlateStorageGUI.lblLicensePlate.text = '-'
    LicensePlateStorageGUI.lblDeleteAtString.text = '-'
    LicensePlateStorageGUI.lblPreviewLicensePlateTitle.text = 'ВАШ ТЕКУЩИЙ НОМЕРНОЙ ЗНАК'

    LicensePlateStorageGUI.btnPutInStorage.enabled = true
    LicensePlateStorageGUI.btnDeleteLicensePlate.enabled = false
    LicensePlateStorageGUI.btnSetOnVehicle.enabled = false

    LicensePlateGUI.resetPreviewLicensePlateTexture()
    LicensePlateGUI.updateCurrentLicensePlateTexture()
end

addEventHandler('tmtaServerTimecycle.onServerMinutePassed', root, 
    function()
        if not LicensePlateGUI.visible then
            return
        end
        for slotIndex, slotData in pairs(_playerLicensePlateSlots) do
            if (slotData.licensePlate and slotData.licensePlate) then
                local formattedTime = exports.tmtaUtils:secondAsTimeFormat(tonumber(slotData.licensePlate.deleteAt - getRealTime().timestamp))
                licensePlateDeleteAtString = string.format('%d д. %02d ч. %02d мин.', formattedTime.d, formattedTime.h, formattedTime.i)

                guiGridListSetItemText(LicensePlateStorageGUI.licenesPlateList, slotData.row, 3, licensePlateDeleteAtString, false, false)
                _playerLicensePlateSlots[slotIndex].licensePlateDeleteAtString = licensePlateDeleteAtString

                if (type(_currentSelectLicensePlateSlot) == 'table' and _currentSelectLicensePlateSlot.slot == slotIndex) then
                    LicensePlateStorageGUI.lblDeleteAtString.text = licensePlateDeleteAtString
                end
            end
        end
    end
)

--- Получить цену расширения хранилища
function LicensePlateStorageGUI.getExpandStoragePrice()
    if (Utils.getPlayerLicensePlateSlotCount() < Config.MAX_STORAGE_SIZE) then
        for _, slotData in pairs(_playerLicensePlateSlots) do
            if (not slotData.available and not slotData.free) then
                return tonumber(slotData.price)
            end
        end
    end
    return false
end

function LicensePlateStorageGUI.getSelectedSlot()
    local selectedItem = guiGridListGetSelectedItem(LicensePlateStorageGUI.licenesPlateList)
    if (selectedItem == -1) then
        _currentSelectLicensePlateSlot = nil
        return false
    end

    local licensePlateSlot = guiGridListGetItemData(LicensePlateStorageGUI.licenesPlateList, selectedItem, 1)
    if not _playerLicensePlateSlots[licensePlateSlot] then
        _currentSelectLicensePlateSlot = nil
        return false
    end
    _currentSelectLicensePlateSlot = _playerLicensePlateSlots[licensePlateSlot]

    return _currentSelectLicensePlateSlot
end

function LicensePlateStorageGUI.onPlayerClickLicensePlateList()
    LicensePlateStorageGUI.resetLicensePlateInfo()

    local selectedSlot = LicensePlateStorageGUI.getSelectedSlot()
    if not selectedSlot then
        return
    end
   
    LicensePlateStorageGUI.lblNumberSlot.text = selectedSlot.slot

    if (selectedSlot.licensePlateString and selectedSlot.licensePlateDeleteAtString) then
        LicensePlateStorageGUI.lblLicensePlate.text = selectedSlot.licensePlateString
        LicensePlateStorageGUI.lblDeleteAtString.text = selectedSlot.licensePlateDeleteAtString
    end

    if (selectedSlot.licensePlate) then
        LicensePlateStorageGUI.lblPreviewLicensePlateTitle.text = 'НОМЕРНОЙ ЗНАК ИЗ ХРАНИЛИЩА'

        LicensePlateStorageGUI.btnDeleteLicensePlate.enabled = true
        LicensePlateStorageGUI.btnSetOnVehicle.enabled = true
        LicensePlateStorageGUI.btnPutInStorage.enabled = false

        local licensePlateType = Utils.getCharacterLicensePlateType(selectedSlot.licensePlate.type)
        LicensePlateGUI.setPreviewLicensePlateTexture(licensePlateType, selectedSlot.licensePlate.numberPlate)
    end
end

addEvent('tmtaVehicleLicensePlate.onPlayerLicensePlatesUpdate', true)
addEventHandler('tmtaVehicleLicensePlate.onPlayerLicensePlatesUpdate', resourceRoot,
    function(playerLicensePlates)
        LicensePlateStorageGUI.resetLicensePlateInfo()
        LicensePlateStorageGUI.updatePlayerLicensePlateList(playerLicensePlates)
    end
)

-- Окно подтверждения расширения хранилища
function LicensePlateStorageGUI.onPlayerClickBtnExpandStorage()
    LicensePlateGUI.wnd.visible = false

    local price = LicensePlateStorageGUI.getExpandStoragePrice()
    if not price then
        errorMessage = 'Вы расширили хранилище на максимальное количество слотов'
    elseif (tonumber(exports.tmtaMoney:getPlayerMoney()) < price) then
        errorMessage = 'У вас недостаточно денежных средств'
    end

    if (type(errorMessage) == 'string') then
        Utils.showNotice(errorMessage)
        return onLicensePlateStorageGUIConfirmWindowCancel()
    end

    local message = string.format("Вы действительно хотите расширить хранилище за %s ₽ ?", tostring(exports.tmtaUtils:formatMoney(price)))

    LicensePlateGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onLicensePlateStorageGUIConfirmWindowExpandStorage', 'onLicensePlateStorageGUIConfirmWindowCancel', 'onLicensePlateStorageGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(LicensePlateGUI.confirmWindow, 'Расширить')
end

-- Окно подтверждения помещения номерного знака в хранилище
function LicensePlateStorageGUI.onPlayerClickBtnPutInStorage()
    LicensePlateGUI.wnd.visible = false

    local licensePlateType, licensePlate = getVehicleLicensePlate(localPlayer.vehicle)
    if (not licensePlateType or not licensePlate) then
        Utils.showNotice('На вашем транспорте отсутствует номерной знак')
        return onLicensePlateStorageGUIConfirmWindowCancel()
    end

    local message = string.format(
        "Вы хотите поместить регистрационный\nзнак '%s' на хранение за %s ₽ ?", 
        formatLicensePlateToString(licensePlateType, licensePlate), 
        tostring(exports.tmtaUtils:formatMoney(Config.PRICE_PUT_IN_STORAGE))
    )

    LicensePlateGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onLicensePlateStorageGUIConfirmWindowPut', 'onLicensePlateStorageGUIConfirmWindowCancel', 'onLicensePlateStorageGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(LicensePlateGUI.confirmWindow, 'Поместить')
end

-- Окно подтверждения удаления номерного знака
function LicensePlateStorageGUI.onPlayerClickBtnDeleteLicensePlate()
    LicensePlateGUI.wnd.visible = false

    local selectedSlot = LicensePlateStorageGUI.getSelectedSlot()
    if not selectedSlot then
        return onLicensePlateStorageGUIConfirmWindowCancel()
    end

    local message = string.format("Вы уверены, что хотите навсегда удалить регистрационный знак '%s' ?", selectedSlot.licensePlateString)

    LicensePlateGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onLicensePlateStorageGUIConfirmWindowDelete', 'onLicensePlateStorageGUIConfirmWindowCancel', 'onLicensePlateStorageGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(LicensePlateGUI.confirmWindow, 'Удалить')
end

-- Окно подтверждения установки номерного знака
function LicensePlateStorageGUI.onPlayerClickBtnSetLicensePlateOnVehicle()
    LicensePlateGUI.wnd.visible = false

    local selectedSlot = LicensePlateStorageGUI.getSelectedSlot()
    if not selectedSlot then
        return onLicensePlateStorageGUIConfirmWindowCancel()
    end

    local message = string.format(
        "Вы уверены, что хотите установить регистрационный знак '%s'\nза %s ₽ ?",
        selectedSlot.licensePlateString,
        tostring(exports.tmtaUtils:formatMoney(Config.PRICE_SET_IN_VEHICLE))
    )

    local licensePlateType, licensePlate = getVehicleLicensePlate(localPlayer.vehicle)
    if (licensePlateType and licensePlate) then
        message = string.format("%s\n\nТекущий номерной знак '%s' будет помещен в хранилище.\n", message, formatLicensePlateToString(licensePlateType, licensePlate))
    end

    LicensePlateGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onLicensePlateStorageGUIConfirmWindowSetOnVehicle', 'onLicensePlateStorageGUIConfirmWindowCancel', 'onLicensePlateStorageGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(LicensePlateGUI.confirmWindow, 'Установить')
end

function onLicensePlateStorageGUIConfirmWindowCancel()
    LicensePlateGUI.wnd.visible = true
end

function onLicensePlateStorageGUIConfirmWindowPut()
    onLicensePlateStorageGUIConfirmWindowCancel()

    local errorMessage = false
    if not Utils.isPlayerHasFreeLicensePlateSlot() then
        errorMessage = 'У вас нет свободной ячейки для хранения номерного знака'
    elseif (tonumber(exports.tmtaMoney:getPlayerMoney()) < tonumber(Config.PRICE_PUT_IN_STORAGE)) then
        errorMessage = 'У вас недостаточно денежных средств'
    end

    if (type(errorMessage) == 'string') then
        return Utils.showNotice(errorMessage)
    end

    return triggerServerEvent('tmtaVehicleLicensePlate.onPutInStorage', resourceRoot)
end

function onLicensePlateStorageGUIConfirmWindowDelete()
    onLicensePlateStorageGUIConfirmWindowCancel()

    local selectedSlot = LicensePlateStorageGUI.getSelectedSlot()
    if not selectedSlot.licensePlate then
        return
    end

    return triggerServerEvent('tmtaVehicleLicensePlate.onDelete', resourceRoot, tonumber(selectedSlot.licensePlate.licensePlateId), selectedSlot.licensePlateString)
end

function onLicensePlateStorageGUIConfirmWindowSetOnVehicle()
    onLicensePlateStorageGUIConfirmWindowCancel()

    local selectedSlot = LicensePlateStorageGUI.getSelectedSlot()
    if not selectedSlot.licensePlate then
        return
    end

    return triggerServerEvent('tmtaVehicleLicensePlate.onVehicleSet', resourceRoot, tonumber(selectedSlot.licensePlate.licensePlateId), selectedSlot.licensePlateString)
end

function onLicensePlateStorageGUIConfirmWindowExpandStorage()
    onLicensePlateStorageGUIConfirmWindowCancel()

    local price = LicensePlateStorageGUI.getExpandStoragePrice()
    if not price then
        return
    end

    return triggerServerEvent('tmtaVehicleLicensePlate.onPlayerExpandStorage', resourceRoot, tonumber(price))
end