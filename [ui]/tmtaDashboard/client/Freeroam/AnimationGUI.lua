AnimationGUI = {}
AnimationGUI.visible = false

local width, height
local posX, posY

function AnimationGUI.create()
    width, height = 250, 430
    posX, posY = 20, (sH-height) /2

    AnimationGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Анимации', false)
    AnimationGUI.wnd.sizible = false
    AnimationGUI.wnd.movable = false
    AnimationGUI.wnd.visible = false

    AnimationGUI.categoryList = guiCreateGridList(0, 30, width, 120, false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.categoryList, false)
    guiGridListAddColumn(AnimationGUI.categoryList, "Категории анимаций", 0.8)

    for _, categoryName in pairs(Animation.category) do
        local row = guiGridListAddRow(AnimationGUI.categoryList)
        guiGridListSetItemText(AnimationGUI.categoryList, row, 1, categoryName, false, false)
    end

    AnimationGUI.animList = guiCreateGridList(0, 120, width, height, false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.animList, false)
    guiGridListAddColumn(AnimationGUI.animList, "Анимации", 0.8)

    --Dashboard.addWindow(AnimationGUI.wnd, AnimationGUI.setVisible)
end

function AnimationGUI.getVisible()
    return AnimationGUI.visible
end

function AnimationGUI.setVisible()
    --Freeroam.visible = Dashboard.setWindowVisible(Freeroam.wnd)
end