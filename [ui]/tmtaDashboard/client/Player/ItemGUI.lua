ItemGUI = {}
ItemGUI.visible = false

local width, height
local posX, posY

local ITEM_LIST = {
    [43]    = 'Фотоаппарат',
    [5]     = 'Бита',
    [14]    = 'Букет цветов',
    [1]     = 'Кастет',
    [6]     = 'Лопата',
    [41]    = 'Болончик краски',
    [42]    = 'Огнетушитель',
    [46]    = 'Парашют',
    [3]     = 'Дубинка',
}

function ItemGUI.create()
    width, height = 250, 300
    posX, posY = (sDW-width) /2, (sDH-height) /2

    ItemGUI._posX = posX
    ItemGUI._posY = posY

    ItemGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Предметы', false)
    guiWindowSetSizable(ItemGUI.wnd, false)
    ItemGUI.wnd.visible = false
    --WalkstyleGUI.wnd.movable = false

    ItemGUI.itemList = guiCreateGridList(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((height-40-30-10) /sDH), false, ItemGUI.wnd)
	guiGridListSetSortingEnabled(ItemGUI.itemList, false)
	local column = guiGridListAddColumn(ItemGUI.itemList, 'Предметы', 0.8)

    for itemId, itemName in pairs(ITEM_LIST) do
		local row = guiGridListAddRow(ItemGUI.itemList)
		guiGridListSetItemText(ItemGUI.itemList, row, 1, itemName, false, false)
		guiGridListSetItemData(ItemGUI.itemList, row, 1, itemId)
	end

    addEventHandler('onClientGUIDoubleClick', ItemGUI.itemList, ItemGUI.onPlayerClickItem, false)

    ItemGUI.btnClose = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, ItemGUI.wnd)
    guiSetFont(ItemGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', ItemGUI.btnClose, 
    function()
        ItemGUI.setVisible()
        guiSetPosition(ItemGUI.wnd, ItemGUI._posX, ItemGUI._posY, false)
    end, false)

    PlayerGUI.addLinkedWindow(ItemGUI.wnd, ItemGUI.setVisible, ItemGUI.getVisible)
end

function ItemGUI.onPlayerClickItem()
    local sel = guiGridListGetSelectedItem(ItemGUI.itemList)
    local item = guiGridListGetItemData(ItemGUI.itemList, sel, 1) or ""

    if (item ~= "") then
        exports.tmtaNotification:showInfobox( 
			"info", 
			"#FFA07AУведомление", 
			"#FFA07A"..guiGridListGetItemText(ItemGUI.itemList, sel, 1).."#FFFFFF в руках персонажа", 
			_, 
			{240, 146, 115}
		)
    	triggerServerEvent('tmtaCore.givePlayerItem', localPlayer, item)
    end
end

function ItemGUI.getVisible()
    return ItemGUI.visible
end

function ItemGUI.setVisible(state)
    local state = (type(state) == 'boolean') and state or not ItemGUI.visible
    if (state) then
        guiBringToFront(ItemGUI.wnd)
    end
    ItemGUI.wnd.visible = state
    ItemGUI.visible = state
end