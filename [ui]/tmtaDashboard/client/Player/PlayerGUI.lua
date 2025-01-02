PlayerGUI = {}
PlayerGUI.visible = false

-- Params
PlayerGUI.params = {}
PlayerGUI.params['windowTitle'] = "Главное меню [F1]"
PlayerGUI.params['bindKey'] = 'f1'

PlayerGUI.linkedWindows = {}

local width, height
local posX, posY

function PlayerGUI.create()
    width, height = 250, 430
    posX, posY = 20, ((sDH-170-40)-height) /2

    PlayerGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), PlayerGUI.params['windowTitle'], false)
    guiWindowSetSizable(PlayerGUI.wnd, false)
    PlayerGUI.wnd.movable = false
    PlayerGUI.wnd.visible = false

    PlayerGUI.btnAnim = guiCreateButton(0, sH*((35) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Анимации", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnAnim, Font['RR_10'])
    AnimationGUI.create()

    PlayerGUI.btnFighStyle = guiCreateButton(0, sH*((70) /sDH), sW*((100) /sDW), sH*((30) /sDH), "Навык боя", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnFighStyle, Font['RR_10'])
    FightStyleGUI.create()

    PlayerGUI.btnWalkStyle = guiCreateButton(sW*((115) /sDW), sH*((70) /sDH), sW*((135) /sDW), sH*((30) /sDH), "Стиль походки", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnWalkStyle, Font['RR_10'])
    WalkstyleGUI.create()

    PlayerGUI.btnPhotoMode = guiCreateButton(0, sH*((105) /sDH), sW*((115) /sDW), sH*((30) /sDH), "Фото режим", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnPhotoMode, Font['RR_10'])
    guiSetProperty(PlayerGUI.btnPhotoMode, "NormalTextColour", "FF21b1ff")

    PlayerGUI.btnItem = guiCreateButton(sW*((130) /sDW), sH*((105) /sDH), sW*((120) /sDW), sH*((30) /sDH), "Предметы", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnItem, Font['RR_10'])
    ItemGUI.create()

    PlayerGUI.btnVoiceEmotion = guiCreateButton(0, sH*((140) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Голосовые эмоции", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnVoiceEmotion, Font['RR_10'])

    PlayerGUI.btnMap = guiCreateButton(0, sH*((175) /sDH), sW*((100) /sDW), sH*((30) /sDH), "Карта", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnMap, Font['RR_10'])

    PlayerGUI.btnNavigation = guiCreateButton(sW*((115) /sDW), sH*((175) /sDH), sW*((130) /sDW), sH*((30) /sDH), "Навигатор", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnNavigation, Font['RR_10'])
    guiSetProperty(PlayerGUI.btnNavigation, "NormalTextColour", "FF21b1ff")

    -- --

    PlayerGUI.btnSettings = guiCreateButton(0, sH*((250) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Настройки игры", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnSettings, Font['RR_10'])

    PlayerGUI.btnDonate = guiCreateButton(0, sH*((285) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Поддержать проект", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnDonate, Font['RR_10'])
    guiSetProperty(PlayerGUI.btnDonate, "NormalTextColour", "ffffd600")

    PlayerGUI.btnHelp = guiCreateButton(0, sH*((320) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Нужна помощь?", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnHelp, Font['RR_10'])
    guiSetProperty(PlayerGUI.btnHelp, "NormalTextColour", "FFFF7800")

    PlayerGUI.btnRespawn = guiCreateButton(0, sH*((390) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), "Респавн", false, PlayerGUI.wnd)
    guiSetFont(PlayerGUI.btnRespawn, Font['RR_10'])
    guiSetProperty(PlayerGUI.btnRespawn, "NormalTextColour", "fff01a21")

    -- Add window
    Dashboard.addWindow(PlayerGUI.wnd, PlayerGUI.setVisible, PlayerGUI.getVisible)
end

function PlayerGUI.addLinkedWindow(window, setVisibleFunction, getVisibleFunction)
    if (not isElement(window) or type(setVisibleFunction) ~= 'function' or type(getVisibleFunction) ~= 'function') then
        outputDebugString('PlayerGUI.addLinkedWindow: bad arguments', 1)
        return false
    end

    PlayerGUI.linkedWindows[window] = {
        setVisible = setVisibleFunction,
        getVisible = getVisibleFunction,
    }

    return true
end

function PlayerGUI.getVisible()
    return PlayerGUI.visible
end

function PlayerGUI.setVisible()
    PlayerGUI.visible = Dashboard.setWindowVisible(PlayerGUI.wnd)
    showChat(not PlayerGUI.visible)

    for window in pairs(PlayerGUI.linkedWindows) do
        local _window = PlayerGUI.linkedWindows[window]
        if (not PlayerGUI.visible or (PlayerGUI.visible and _window.getVisible()) ) then
            window.visible = PlayerGUI.visible
        end
    end

    exports.tmtaUI:setPlayerComponentVisible("controlHelp", not PlayerGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("chat", not PlayerGUI.visible)
end

bindKey(PlayerGUI.params['bindKey'], 'down',
    function()
        if not isElement(PlayerGUI.wnd) then
            PlayerGUI.create()
        end
        if not Dashboard.getVisible() then
            return
        end
        PlayerGUI.setVisible()
    end
)

addEventHandler("onClientGUIClick", root, 
    function()
        if (not Dashboard.getVisible()) then
            return
        end

        if (source == PlayerGUI.btnMap) then
            PlayerGUI.setVisible()
            return exports.tmtaMap:open()
        elseif (source == PlayerGUI.btnPhotoMode) then
            PlayerGUI.setVisible()
            return exports.tmtaCamHack.startCamHack()
        elseif (source == PlayerGUI.btnSettings) then
            return SettingsGUI.setVisible()
        elseif (source == PlayerGUI.btnHelp) then
            return HelpGUI.openControlTab()
        elseif (source == PlayerGUI.btnDonate) then
            return HelpGUI.openDonateTab()
        elseif (source == PlayerGUI.btnRespawn) then
            return PlayerGUI.onPlayerClickBtnRespawn()
        elseif (source == PlayerGUI.btnAnim) then
            return AnimationGUI.setVisible()
        elseif (source == PlayerGUI.btnWalkStyle) then
            return WalkstyleGUI.setVisible()
        elseif (source == PlayerGUI.btnFighStyle) then
            return FightStyleGUI.setVisible()
        elseif (source == PlayerGUI.btnItem) then
            return ItemGUI.setVisible()
        elseif (source == PlayerGUI.btnVoiceEmotion) then
            return PlayerGUI.onPlayerClickBtnVoiceEmotion()
        elseif (source == PlayerGUI.btnNavigation) then
            return PlayerGUI.onPlayerClickBtnNavigation()
        end
    end
)

function PlayerGUI.onPlayerClickBtnVoiceEmotion()
    local window = exports.tmtaPlayerEmotion:getWnd()
    if not PlayerGUI.linkedWindows[window] then
        PlayerGUI.linkedWindows[window] = {
            setVisible = function() return exports.tmtaPlayerEmotion:setWndVisible() end,
            getVisible = function() return exports.tmtaPlayerEmotion:getWndVisible() end,
        }
    end
    guiBringToFront(window)
    exports.tmtaPlayerEmotion:setWndVisible()
end

function PlayerGUI.onPlayerClickBtnNavigation()
    local window = exports.tmtaNavigation:getWindow()
    if not PlayerGUI.linkedWindows[window] then
        PlayerGUI.linkedWindows[window] = {
            setVisible = function() return exports.tmtaNavigation:setWindowVisible() end,
            getVisible = function() return exports.tmtaNavigation:getWindowVisible() end,
        }
    end
    guiBringToFront(window)
    exports.tmtaNavigation:setWindowVisible()
end

function PlayerGUI.onPlayerClickBtnRespawn()
    PlayerGUI.setVisible()

    showChat(false)
    toggleAllControls(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)

    local windowConfirmRespawn = exports.tmtaGUI:createConfirm('Вас доставят в ближайшую больницу.\nВы действительно хотите переродиться?', 'onPlayerGUIWindowConfirmRespawnAccept', 'onPlayerGUIWindowConfirmRespawnClose', 'onPlayerGUIWindowConfirmRespawnClose')
    exports.tmtaGUI:confirmSetBtnOkLabel(windowConfirmRespawn, 'Респавн')
end

function onPlayerGUIWindowConfirmRespawnAccept()
    onPlayerGUIWindowConfirmRespawnClose()
    triggerServerEvent('tmtaCore.killPlayer', localPlayer)
end

function onPlayerGUIWindowConfirmRespawnClose()
    PlayerGUI.setVisible()
    showChat(true)
    toggleAllControls(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end