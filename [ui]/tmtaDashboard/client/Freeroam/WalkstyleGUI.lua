WalkstyleGUI = {}
WalkstyleGUI.visible = false

local width, height = 225, 300
local posX, posY = (sDW-width) /2, (sDH-height) /2

function WalkstyleGUI.create()
    WalkstyleGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Выбери стиль походки', false)
    WalkstyleGUI.wnd.sizible = false
    WalkstyleGUI.wnd.movable = false

    WalkstyleGUI.walkstyleList = guiCreateGridList(0, 30, sW*((width-15) /sDW), sH*((height-60) /sDH), false, WalkstyleGUI.wnd)
	guiGridListSetSortingEnabled(WalkstyleGUI.walkstyleList, false)
	local column = guiGridListAddColumn(WalkstyleGUI.walkstyleList, 'Стили походки', 0.8)

    WalkstyleGUI.btnClose = guiCreateButton(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, WalkstyleGUI.wnd)
    guiSetFont(WalkstyleGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', WalkstyleGUI.btnClose, WalkstyleGUI.setVisible, false)

    Dashboard.addWindow(WalkstyleGUI.wnd)
end

function WalkstyleGUI.getVisible()
    return WalkstyleGUI.visible
end

function WalkstyleGUI.setVisible()
    WalkstyleGUI.visible = Dashboard.setWindowVisible(WalkstyleGUI.wnd)
end