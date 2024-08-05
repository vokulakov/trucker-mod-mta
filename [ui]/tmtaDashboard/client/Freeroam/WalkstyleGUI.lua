WalkstyleGUI = {}
WalkstyleGUI.visible = false

local width, height
local posX, posY

function WalkstyleGUI.create()
    width, height = 225, 300
    posX, posY = 20, 20

    WalkstyleGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Выбери стиль походки', false)
    WalkstyleGUI.wnd.sizible = false
    WalkstyleGUI.wnd.movable = false
    WalkstyleGUI.wnd.visible = false
end