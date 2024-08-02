Freeroam = {}
Freeroam.visible = false

-- Params
Freeroam.params = {}
Freeroam.params['windowTitle'] = "Главное меню [F1]"
Freeroam.params['bindKey'] = 'f1'

local width, height
local posX, posY

function Freeroam.create()
    width, height = 250, 430
    posX, posY = 20, ((sDH-170-40)-height) /2

    Freeroam.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), Freeroam.params['windowTitle'], false)
    Freeroam.wnd.sizible = false
    Freeroam.wnd.movable = false
    Freeroam.wnd.visible = false

    Freeroam.btnAnim = guiCreateButton(0, sH*((35) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Анимации", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnAnim, Utils.fonts['RR_10'])

    Freeroam.btnFighStyle = guiCreateButton(0, sH*((70) /sDH), sW*((100) /sDW), sH*((30) /sDH), "Навык боя", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnFighStyle, Utils.fonts['RR_10'])

    Freeroam.btnWalkStyle = guiCreateButton(sW*((115) /sDW), sH*((70) /sDH), sW*((135) /sDW), sH*((30) /sDH), "Стиль походки", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnWalkStyle, Utils.fonts['RR_10'])

    Freeroam.btnPhotoMode = guiCreateButton(0, sH*((105) /sDH), sW*((115) /sDW), sH*((30) /sDH), "Фото режим", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnPhotoMode, Utils.fonts['RR_10'])
    guiSetProperty(Freeroam.btnPhotoMode, "NormalTextColour", "FF21b1ff")

    Freeroam.btnWeapon = guiCreateButton(sW*((130) /sDW), sH*((105) /sDH), sW*((120) /sDW), sH*((30) /sDH), "Предметы", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnWeapon, Utils.fonts['RR_10'])

    Freeroam.btnVoiceEmotion = guiCreateButton(0, sH*((140) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Голосовые эмоции", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnVoiceEmotion, Utils.fonts['RR_10'])

    Freeroam.btnMap = guiCreateButton(0, sH*((175) /sDH), sW*((100) /sDW), sH*((30) /sDH), "Карта", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnMap, Utils.fonts['RR_10'])

    Freeroam.btnNavigation = guiCreateButton(sW*((115) /sDW), sH*((175) /sDH), sW*((130) /sDW), sH*((30) /sDH), "Навигатор", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnNavigation, Utils.fonts['RR_10'])
    guiSetProperty(Freeroam.btnNavigation, "NormalTextColour", "FF21b1ff")

    -- --
    
    Freeroam.btnSettings = guiCreateButton(0, sH*((250) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Настройки игры", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnSettings, Utils.fonts['RR_10'])

    Freeroam.btnDonate = guiCreateButton(0, sH*((285) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Поддержать проект", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnDonate, Utils.fonts['RR_10'])
    guiSetProperty(Freeroam.btnDonate, "NormalTextColour", "ffffd600")

    Freeroam.btnHelp = guiCreateButton(0, sH*((320) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Нужна помощь?", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnHelp, Utils.fonts['RR_10'])
    guiSetProperty(Freeroam.btnHelp, "NormalTextColour", "FFFF7800")

    Freeroam.btnRespawn = guiCreateButton(0, sH*((390) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Респавн", false, Freeroam.wnd)
    guiSetFont(Freeroam.btnRespawn, Utils.fonts['RR_10'])
    guiSetProperty(Freeroam.btnRespawn, "NormalTextColour", "fff01a21")

    AnimationGUI.create()

    -- Add window
    Dashboard.addWindow(Freeroam.wnd, Freeroam.setVisible)
end

function Freeroam.setVisible()
    Freeroam.visible = Dashboard.setWindowVisible(Freeroam.wnd)
    showChat(not Freeroam.visible)
    exports.tmtaUI:setPlayerComponentVisible("controlHelp", not Freeroam.visible)
    exports.tmtaUI:setPlayerComponentVisible("chat", not Freeroam.visible)
end

bindKey(Freeroam.params['bindKey'], 'down',
    function()
        if not Dashboard.getVisible() then
            return
        end
        Freeroam.setVisible()
    end
)

addEventHandler("onClientGUIClick", root, 
    function()
        if (not Dashboard.getVisible()) then
            return
        end

        if (source == Freeroam.btnMap) then
            Freeroam.setVisible()
            return exports.tmtaMap:open()
        elseif (source == Freeroam.btnPhotoMode) then
            Freeroam.setVisible()
            return exports.tmtaCamHack.startCamHack()
        elseif (source == Freeroam.btnSettings) then
            return Settings.setVisible()
        elseif (source == Freeroam.btnHelp) then
            return Help.setVisible()
        elseif (source == Freeroam.btnRespawn) then
            return FreeroamGUI.onPlayerClickBtnRespawn()
        end
    end
)

function FreeroamGUI.onPlayerClickBtnRespawn()
    Freeroam.setVisible()
    local confirmWindow = exports.tmtaGUI:createConfirm('Вас доставят в ближайшую больницу.\nВы действительно хотите переродиться?', 'onConfirmWindowAccept', 'onConfirmWindowClose', 'onConfirmWindowClose')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Респавн')
end

function onConfirmWindowClose()
    Freeroam.setVisible()
end

function onConfirmWindowAccept()
    triggerServerEvent('tmtaCore.killPlayer', localPlayer)
end