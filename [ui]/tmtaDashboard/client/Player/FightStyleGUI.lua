FightStyleGUI = {}
FightStyleGUI.visible = false

local width, height
local posX, posY

local FIGHT_STYLE_LIST = {
	-- STYLE_STANDARD
	[4] = 'Уличный боец',

	-- STYLE_BOXING
	[5] = 'Боксер',

	-- STYLE_KUNG_FU
	[6] = 'Кунг-Фу',

	-- STYLE_KNEE_HEAD
	[7] = 'С колена в голову',

	-- STYLE_GRAB_KICK
	[15] = 'Удар краба',

	-- STYLE_ELBOWS
	[16] = 'С локтя?',
}

function FightStyleGUI.create()
    width, height = 250, 220
    posX, posY = (sDW-width) /2, (sDH-height) /2

    FightStyleGUI._posX = posX
    FightStyleGUI._posY = posY

    FightStyleGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Навык боя', false)
    guiWindowSetSizable(FightStyleGUI.wnd, false)
    FightStyleGUI.wnd.visible = false
    --WalkstyleGUI.wnd.movable = false

    FightStyleGUI.fightStyleList = guiCreateGridList(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((height-40-30-10) /sDH), false, FightStyleGUI.wnd)
	guiGridListSetSortingEnabled(FightStyleGUI.fightStyleList, false)
	guiGridListAddColumn(FightStyleGUI.fightStyleList, 'Стили походки', 0.8)
    FightStyleGUI.updateFightStyleList()
    addEventHandler('onClientGUIDoubleClick', FightStyleGUI.fightStyleList, FightStyleGUI.onPlayerClickFightStyle, false)

    FightStyleGUI.btnClose = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, FightStyleGUI.wnd)
    guiSetFont(FightStyleGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', FightStyleGUI.btnClose, 
    function()
        FightStyleGUI.setVisible()
        guiSetPosition(FightStyleGUI.wnd, FightStyleGUI._posX, FightStyleGUI._posY, false)
    end, false)

    PlayerGUI.addLinkedWindow(FightStyleGUI.wnd, FightStyleGUI.setVisible, FightStyleGUI.getVisible)
end

function FightStyleGUI.updateFightStyleList(fightStyle)
    guiGridListClear(FightStyleGUI.fightStyleList)

	local currentStyle = fightStyle or getPedFightingStyle(localPlayer)
	for id, style in pairs(FIGHT_STYLE_LIST) do
		local row = guiGridListAddRow(FightStyleGUI.fightStyleList)

		guiGridListSetItemText(FightStyleGUI.fightStyleList, row, 1, style, false, false)
		guiGridListSetItemData(FightStyleGUI.fightStyleList, row, 1, id)

		if tonumber(currentStyle) == tonumber(id) then
			guiGridListSetItemColor(FightStyleGUI.fightStyleList, row, 1, 33, 177, 255)
		end
	end
end

function FightStyleGUI.onPlayerClickFightStyle()
    local sel = guiGridListGetSelectedItem(FightStyleGUI.fightStyleList)
    local fightStyle = guiGridListGetItemData(FightStyleGUI.fightStyleList, sel, 1) or ""

    if fightStyle ~= "" then
		exports.tmtaNotification:showInfobox( 
			"info", 
			"#FFA07AУведомление", 
			"Для персонажа установлен навык боя #FFA07A"..guiGridListGetItemText(FightStyleGUI.fightStyleList, sel, 1), 
			_, 
			{240, 146, 115}
		)
    	triggerServerEvent('tmtaCore.setPlayerFightingStyle', localPlayer, fightStyle)
        FightStyleGUI.updateFightStyleList(fightStyle)
    end
end

function FightStyleGUI.getVisible()
    return FightStyleGUI.visible
end

function FightStyleGUI.setVisible(state)
    local state = (type(state) == 'boolean') and state or not FightStyleGUI.visible
    if (state) then
        FightStyleGUI.updateFightStyleList()
        guiBringToFront(FightStyleGUI.wnd)
    end
    FightStyleGUI.wnd.visible = state
    FightStyleGUI.visible = state
end