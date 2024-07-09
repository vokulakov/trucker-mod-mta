local sW, sH = guiGetScreenSize() 
local sDW, sDH = exports.tmtaUI:getScreenSize()

GUI = {}

local Fonts = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
}

local width, height = 350, 290

function GUI.render()
    if isElement(GUI.wnd) then 
        return 
    end

    GUI.bg = guiCreateStaticImage(sW*(0 /sDW), sH*(0 /sDH), sW*(1920 /sDW), sH*(1080 /sDH), "assets/img/bg.png", false)
    GUI.bg.enabled = false 
    guiMoveToBack(GUI.bg)

    GUI.wnd = guiCreateWindow(width, height, sW*(width /sDW), sH*(height /sDH), "TRUCKERMTA.RU", false)
    guiWindowSetSizable(GUI.wnd, false) 
    guiWindowSetMovable(GUI.wnd, false) 
    local sX, sY = exports.tmtaGUI:windowCentralize(GUI.wnd)
    GUI.wnd.alpha = 0.8

    GUI.tabPanel = guiCreateTabPanel(0, 0.1, 1, 1, true, GUI.wnd)

    -- АВТОРИЗАЦИЯ --
    GUI.tabLogin = guiCreateTab("Авторизация", GUI.tabPanel)
    
    GUI.lblTabLoginInfo = guiCreateLabel(0, 0, 1, 0.3, "Добро пожаловать на TRUCKER × MTA\nПожалуйста, авторизуйтесь!", true, GUI.tabLogin)
    guiSetFont(GUI.lblTabLoginInfo, Fonts['RR_10'])
    guiLabelSetHorizontalAlign(GUI.lblTabLoginInfo, "center", false)
    guiLabelSetVerticalAlign(GUI.lblTabLoginInfo, "center")
    guiLabelSetColor(GUI.lblTabLoginInfo, 255, 128, 0)
    GUI.lblTabLoginInfo.enabled = false

    GUI.editLogin = guiCreateEdit(0.15, 0.27, 0.7, 0.13, "", true, GUI.tabLogin)
    exports.tmtaGUI:setEditPlaceholder(GUI.editLogin, "Введите логин")
    guiEditSetMaxLength(GUI.editLogin, 25)

    GUI.editPassword = guiCreateEdit(0.15, 0.43, 0.7, 0.13, "", true, GUI.tabLogin)
    guiEditSetMasked(GUI.editPassword, true) 
    exports.tmtaGUI:setEditPlaceholder(GUI.editPassword, "Введите пароль")
    guiEditSetMaxLength(GUI.editPassword, 25)
    
    GUI.cboxRemembeMe = guiCreateCheckBox(0.15, 0.6, 0.35, 0.1, "Запомнить меня", true, true, GUI.tabLogin)
    guiSetFont(GUI.cboxRemembeMe, Fonts['RR_8'])
    
    GUI.btnPassForgot = guiCreateButton(0.55, 0.6, 0.3, 0.1, "Забыли пароль?", true, GUI.tabLogin)
    guiSetFont(GUI.btnPassForgot, Fonts['RR_8'])

    addEventHandler("onClientGUIClick", GUI.btnPassForgot,
        function()
            GUI.showNotice('info', 'Для восстановления пароля обратитетесь в тех.поддержку проекта')
        end,
        false
    )

    GUI.btnLogin = guiCreateButton(0.02, 0.8, 0.96, 0.15, "Войти в игру", true, GUI.tabLogin)
    guiSetFont(GUI.btnLogin, Fonts['RR_10'])
    guiSetProperty(GUI.btnLogin, "NormalTextColour", "ffff8000")

    addEventHandler("onClientGUIClick", GUI.btnLogin, GUI.onClickBtnLogin, false)

    -- РЕГИСТРАЦИЯ --
    GUI.tabSignup = guiCreateTab("Регистрация", GUI.tabPanel)

    GUI.lblTabSignupInfo = guiCreateLabel(0, 0, 1, 0.3, "Пожалуйста, введите данные, чтобы создать\nучетную запись для игры на сервере.", true, GUI.tabSignup)
    guiSetFont(GUI.lblTabSignupInfo, Fonts['RR_10'])
    guiLabelSetHorizontalAlign(GUI.lblTabSignupInfo, "center", false)
    guiLabelSetVerticalAlign(GUI.lblTabSignupInfo, "center")
    guiLabelSetColor(GUI.lblTabSignupInfo, 255, 128, 0)
    GUI.lblTabSignupInfo.enabled = false

    GUI.editSignupLogin = guiCreateEdit(0.15, 0.27, 0.7, 0.13, "", true, GUI.tabSignup)
    exports.tmtaGUI:setEditPlaceholder(GUI.editSignupLogin, "Введите логин")
    exports.tmtaGUI:setEditRequired(GUI.editSignupLogin)
    guiEditSetMaxLength(GUI.editSignupLogin, 25)

    GUI.editSignupPassword = guiCreateEdit(0.15, 0.43, 0.7, 0.13, "", true, GUI.tabSignup)
    guiEditSetMasked(GUI.editSignupPassword, true) 
    exports.tmtaGUI:setEditPlaceholder(GUI.editSignupPassword, "Введите пароль")
    exports.tmtaGUI:setEditRequired(GUI.editSignupPassword)
    guiEditSetMaxLength(GUI.editSignupPassword, 25)

    GUI.editSignupPasswordConfirm = guiCreateEdit(0.15, 0.59, 0.7, 0.13, "", true, GUI.tabSignup)
    guiEditSetMasked(GUI.editSignupPasswordConfirm, true) 
    exports.tmtaGUI:setEditPlaceholder(GUI.editSignupPasswordConfirm, "Повторите пароль")
    exports.tmtaGUI:setEditRequired(GUI.editSignupPasswordConfirm)
    guiEditSetMaxLength(GUI.editSignupPasswordConfirm, 25)

    GUI.btnSignup = guiCreateButton(0.02, 0.8, 0.96, 0.15, "Зарегистрироваться", true, GUI.tabSignup)
    guiSetFont(GUI.btnSignup, Fonts['RR_10'])
    guiSetProperty(GUI.btnSignup, "NormalTextColour", "ffff8000")
    addEventHandler("onClientGUIClick", GUI.btnSignup, GUI.onClickBtnSignup, false)
end

function GUI.hideLoginPanel()
    destroyElement(GUI.wnd)
    destroyElement(GUI.bg)
end

function GUI.gotoLoginPanel(username, password)
	guiSetSelectedTab(GUI.tabPanel, GUI.tabLogin)
	if username and password then
		GUI.editLogin.text = username
		GUI.editPassword.text = password
	end
end

function GUI.showNotice(typeNotice, messageNotice, titleNotice)
    local posX, posY = guiGetPosition(GUI.wnd, false)
    local width, height = guiGetSize(GUI.wnd, false)

    GUI.notice = exports.tmtaGUI:createNotice(posX, posY+height+15, width, typeNotice, messageNotice, true)
    if titleNotice and titleNotice:len() > 0 then
        exports.tmtaGUI:setNoticeTitle(GUI.notice, titleNotice)
    end
end

function GUI.clearSignupForm()
    GUI.editSignupLogin.text = GUI.editSignupLogin:getData('placeholder') or ''
    GUI.editSignupPassword.text = GUI.editSignupPassword:getData('placeholder') or ''
    GUI.editSignupPasswordConfirm.text = GUI.editSignupPasswordConfirm:getData('placeholder') or ''
end

function GUI.onClickBtnLogin()
    if source ~= GUI.btnLogin then
        return 
    end

    local username = GUI.editGetText(GUI.editLogin)
    local password = GUI.editGetText(GUI.editPassword)

    local success, error = LoginPanel.actionLogin(username, password)
    if not success then
        GUI.showNotice(error[2], error[3])
    end
end

-- Получить текст из поля ввода
-- Без учета placeholder
function GUI.editGetText(edit)
    if not isElement(edit) then
        return false
    end
    local text = edit.text
    if edit:getData('placeholder') == text then
        return ""
    end
    return text
end

function GUI.onClickBtnSignup()
    if source ~= GUI.btnSignup then
        return
    end

    local username = GUI.editGetText(GUI.editSignupLogin)
    local password = GUI.editGetText(GUI.editSignupPassword)
    local passwordConfirm = GUI.editGetText(GUI.editSignupPasswordConfirm)

    local success, error = LoginPanel.actionSignUp(username, password, passwordConfirm)
    if not success then
        GUI.showNotice(error[2], error[3])
    end
end