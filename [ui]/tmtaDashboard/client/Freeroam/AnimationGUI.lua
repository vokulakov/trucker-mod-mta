AnimationGUI = {}
AnimationGUI.visible = false

local width, height
local posX, posY

function AnimationGUI.create()
    width, height = 250, sDH-170-80
    posX, posY = 20, 20

    AnimationGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Анимации', false)
    AnimationGUI.wnd.sizible = false
    AnimationGUI.wnd.movable = false
    AnimationGUI.wnd.visible = false

    AnimationGUI.categoryList = guiCreateGridList(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((140) /sDH), false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.categoryList, false)
    guiGridListAddColumn(AnimationGUI.categoryList, 'Категории анимаций', 0.8)

    for _, categoryName in pairs(Animation.category) do
        local row = guiGridListAddRow(AnimationGUI.categoryList)
        guiGridListSetItemText(AnimationGUI.categoryList, row, 1, categoryName, false, false)
    end

    AnimationGUI.animList = guiCreateGridList(0, sH*((140+40) /sDH), sW*((width-15) /sDW), sH*((height-140-40-85) /sDH), false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.animList, false)
    guiGridListAddColumn(AnimationGUI.animList, 'Анимации', 0.8)

    AnimationGUI.btnAnimStop = guiCreateButton(0, sH*((height-75) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Остановить анимацию', false, AnimationGUI.wnd)
    guiSetFont(AnimationGUI.btnAnimStop, Font['RR_10'])

    AnimationGUI.btnClose = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, AnimationGUI.wnd)
    guiSetFont(AnimationGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', AnimationGUI.btnClose, AnimationGUI.setVisible, false)

    Dashboard.addWindow(AnimationGUI.wnd, AnimationGUI.setVisible)
end

function AnimationGUI.updateAnimationList(categoryName)
    for _, animationData in ipairs(Animation.list) do
        if animationData[3] == categoryName then
            local row = guiGridListAddRow(AnimationGUI.animList)
            guiGridListSetItemText(AnimationGUI.animList, row, 1, animationData[4], false, false)
            guiGridListSetItemData(AnimationGUI.animList, row, 1, {animationData[1], animationData[2]})
        end
    end
end

function AnimationGUI.getVisible()
    return AnimationGUI.visible
end

function AnimationGUI.setVisible()
    AnimationGUI.visible = Dashboard.setWindowVisible(AnimationGUI.wnd)
    showChat(not AnimationGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("controlHelp", not AnimationGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("chat", not AnimationGUI.visible)
end