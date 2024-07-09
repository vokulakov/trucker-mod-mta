NavigationGUI = {}
NavigationGUI.visible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height = 350, 500

-- Шрифты
local Font = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
}

-- Поиск меток осуществляется по блипам (resource: tmtaBlip)
local NAVIGATION_POSITION_LIST = {
    blipTrucker = 'База дальнобойщиков (работа дальнобойщика)',
    blipScooterRent = 'Аренды скутера',
    blipGasStation = 'Заправка (АЗС)',
    blipSto = 'СТО (автосервис)',
    blipRestaurant = 'Кафе (ресторан)',
    blipCarshop = 'Автосалон',
    blipClothes = 'Магазин одежды (скинов)',
    blipTuning = 'Тюнинг ателье',
    blipRevenueService = 'Налоговая',
    blipPaint = 'Пакрасочная',
    blipLicensePlate = 'Установка номеров (ЕКХ)',
    blipJobLoader = 'Работа грузчика (подработка)',
}

local _currentPoint = nil

NavigationGUI.wnd = guiCreateWindow(0, 0, sW*((width) /sDW), sH*((height) /sDH), 'Навигация (GPS)', false)
exports.tmtaGUI:windowCentralize(NavigationGUI.wnd)
guiWindowSetSizable(NavigationGUI.wnd, false)
NavigationGUI.wnd.visible = false
NavigationGUI._posX, NavigationGUI._posY = guiGetPosition(NavigationGUI.wnd, false)

NavigationGUI.lbl = guiCreateLabel(10, 25, width, height, "* Двойной клик 'ЛКМ' для установки метки", false, NavigationGUI.wnd)
guiSetFont(NavigationGUI.lbl, Font.RR_8)
guiLabelSetColor(NavigationGUI.lbl, 10, 183, 220)
guiLabelSetHorizontalAlign(NavigationGUI.lbl, 'left')
NavigationGUI.lbl.enabled = false

NavigationGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, NavigationGUI.wnd)
guiSetFont(NavigationGUI.btnClose, Font.RR_10)
guiSetProperty(NavigationGUI.btnClose, "NormalTextColour", "FFCE070B")

NavigationGUI.positionList = guiCreateGridList(0, sH*((25+30) /sDH), sW*((width-15) /sDW), sH*((height-60-40) /sDH), false, NavigationGUI.wnd)
guiGridListSetSortingEnabled(NavigationGUI.positionList, false)
guiGridListAddColumn(NavigationGUI.positionList, 'Найти', 0.9)

for itemBlip, itemName in pairs(NAVIGATION_POSITION_LIST) do
    local row = guiGridListAddRow(NavigationGUI.positionList)
    guiGridListSetItemText(NavigationGUI.positionList, row, 1, itemName, false, false)
    guiGridListSetItemData(NavigationGUI.positionList, row, 1, itemBlip)
end

NavigationGUI.btnStop = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Отключить навигацию', false, NavigationGUI.wnd)
guiSetFont(NavigationGUI.btnStop, Font.RR_10)
NavigationGUI.btnStop.enabled = false
guiSetProperty(NavigationGUI.btnStop, 'NormalTextColour', 'fff01a21')

addEventHandler("onClientGUIClick", NavigationGUI.btnStop, 
    function()
        if isElement(_currentPoint) then
            Navigation.destroyPoint(_currentPoint)
            NavigationGUI.btnStop.enabled = false
        end
    end, false)

function NavigationGUI.onPlayerClickFindNearestPoint()
    local pointBlipIcon = guiGridListGetItemData(NavigationGUI.positionList, guiGridListGetSelectedItem(NavigationGUI.positionList), 1) or ""
    if pointBlipIcon ~= "" then
        if isElement(_currentPoint) then
            Navigation.destroyPoint(_currentPoint)
        end

        _currentPoint = exports.tmtaUtils:getNearestElementByType(localPlayer, 'blip', _, 'icon', pointBlipIcon)
        local data = _currentPoint:getData('data')
        Navigation.createPointWithMarker(_currentPoint, data.name)

        exports.tmtaNotification:showInfobox(
            'info', 
            "#FFA07AНавигация (GPS)", 
            "Метка #FFA07A'"..data.name.."' #FFFFFFустановлена", 
            _, 
            {240, 146, 115}
        )

        NavigationGUI.btnStop.enabled = true
    end
end
addEventHandler("onClientGUIDoubleClick", NavigationGUI.positionList, NavigationGUI.onPlayerClickFindNearestPoint, false)

addEvent('tmtaNavigation.onPointDestroy', false)
addEventHandler('tmtaNavigation.onPointDestroy', root,
    function()
        if (source == _currentPoint) then
            _currentPoint = nil
            NavigationGUI.btnStop.enabled = false

            exports.tmtaNotification:showInfobox(
                'info', 
                "#FFA07AНавигация (GPS)", 
                "Вы прибыли на место назначения!", 
                _, 
                {240, 146, 115}
            )
        end
    end
)

function NavigationGUI.getVisible()
    return NavigationGUI.visible
end

function NavigationGUI.setVisible(state)
    local state = (type(state) == 'boolean') and state or not NavigationGUI.visible
    NavigationGUI.wnd.visible = state
    NavigationGUI.visible = state
end

addEventHandler("onClientGUIClick", NavigationGUI.btnClose, 
    function()
        NavigationGUI.setVisible(false)
        guiSetPosition(NavigationGUI.wnd, NavigationGUI._posX, NavigationGUI._posY, false)
    end, false)

-- exports
setWindowVisible = NavigationGUI.setVisible
getWindowVisible = NavigationGUI.getVisible
getWindow = function() return NavigationGUI.wnd end