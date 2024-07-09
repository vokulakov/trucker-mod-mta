WalkstyleGUI = {}
WalkstyleGUI.visible = false

local width, height = 225, 300
local posX, posY

local WALK_STYLE_LIST = {
	[54]  	= 'Default',
	[55]  	= 'Default Fat',
	[56]  	= 'Default Muscular',
	[69]  	= 'Sneak',
	[118]  	= 'Man',
	[119] 	= 'Shuffle',
	[120]  	= 'Old Man',
	[121]  	= 'Gang One',
	[122]  	= 'Gang Two',
	[124]  	= 'Fat Man',
	[123]  	= 'Old Fat Man',
	[125]  	= 'Jogger',
	[126]  	= 'Drunk',
	[127]  	= 'Blind Man',
	[128]  	= 'SWAT Team',
	[129]  	= 'Woman',
	[130]  	= 'Shopper',
	[131]  	= 'Busy Woman',
	[132]  	= 'Sexy Woman',
	[133]  	= 'Hooker',
	[134]  	= 'Old Woman',
	[135]  	= 'Fat Woman',
	[136]  	= 'Jogger Woman',
	[137]  	= 'Old Fat Woman',
}

function WalkstyleGUI.create()
    width, height = 250, 420
    posX, posY = (sDW-width) /2, (sDH-height) /2

    WalkstyleGUI._posX = posX
    WalkstyleGUI._posY = posY

    WalkstyleGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Стиль походки', false)
    guiWindowSetSizable(WalkstyleGUI.wnd, false)
    WalkstyleGUI.wnd.visible = false
    --WalkstyleGUI.wnd.movable = false

    WalkstyleGUI.walkStyleList = guiCreateGridList(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((height-40-30-10) /sDH), false, WalkstyleGUI.wnd)
	guiGridListSetSortingEnabled(WalkstyleGUI.walkStyleList, false)
	local column = guiGridListAddColumn(WalkstyleGUI.walkStyleList, 'Стили походки', 0.8)
    WalkstyleGUI.updateWalkstyleList()
    addEventHandler('onClientGUIDoubleClick', WalkstyleGUI.walkStyleList, WalkstyleGUI.onPlayerClickWalkStyle, false)

    WalkstyleGUI.btnClose = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, WalkstyleGUI.wnd)
    guiSetFont(WalkstyleGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', WalkstyleGUI.btnClose, 
    function()
        WalkstyleGUI.setVisible()
        guiSetPosition(WalkstyleGUI.wnd, WalkstyleGUI._posX, WalkstyleGUI._posY, false)
    end, false)

    PlayerGUI.addLinkedWindow(WalkstyleGUI.wnd, WalkstyleGUI.setVisible, WalkstyleGUI.getVisible)
end

function WalkstyleGUI.updateWalkstyleList(walkStyle)
    guiGridListClear(WalkstyleGUI.walkStyleList)

	local currentStyle = walkStyle or getPedWalkingStyle(localPlayer)
	for id, style in pairs(WALK_STYLE_LIST) do
		local row = guiGridListAddRow(WalkstyleGUI.walkStyleList)

		guiGridListSetItemText(WalkstyleGUI.walkStyleList, row, 1, style, false, false)
		guiGridListSetItemData(WalkstyleGUI.walkStyleList, row, 1, id)

		if tonumber(currentStyle) == tonumber(id) then
			guiGridListSetItemColor(WalkstyleGUI.walkStyleList, row, 1, 33, 177, 255)
		end
	end
end

function WalkstyleGUI.onPlayerClickWalkStyle()
    local sel = guiGridListGetSelectedItem(WalkstyleGUI.walkStyleList)
    local walkStyle = guiGridListGetItemData(WalkstyleGUI.walkStyleList, sel, 1) or ""

    if (walkStyle ~= "") then
        exports.tmtaNotification:showInfobox( 
			"info", 
			"#FFA07AУведомление", 
			"Для персонажа установлен стиль походки #FFA07A"..guiGridListGetItemText(WalkstyleGUI.walkStyleList, sel, 1), 
			_, 
			{240, 146, 115}
		)
    	triggerServerEvent('tmtaCore.setPlayerWalkingStyle', localPlayer, walkStyle)
        WalkstyleGUI.updateWalkstyleList(walkStyle)
    end
end

function WalkstyleGUI.getVisible()
    return WalkstyleGUI.visible
end

function WalkstyleGUI.setVisible(state)
    local state = (type(state) == 'boolean') and state or not WalkstyleGUI.visible
    if (state) then
        WalkstyleGUI.updateWalkstyleList()
        guiBringToFront(WalkstyleGUI.wnd)
    end
    WalkstyleGUI.wnd.visible = state
    WalkstyleGUI.visible = state
end