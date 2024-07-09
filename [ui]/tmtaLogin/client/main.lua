LoginPanel = {}

local currentUsername, currentPassword
local musicTimer
local bgMusic

local maxTrackCount = 3 -- максимальное количестов треков (фоновая музыка)
local resourceName = getResourceName(resource)

local Messages = {
    ['login_panel_auth_error'] = "Ошибка авторизации",
	['login_panel_register_error'] = "Ошибка регистрации",

    ['login_panel_err_enter_username'] = "Введите имя пользователя (логин)",
	['login_panel_err_enter_password'] =  "Введите пароль",
    ['login_panel_err_enter_password_confirm'] = "Введите подтверждение пароля",
	['login_panel_err_passwords_do_not_match'] = "Введённые пароли не совпадают",

	['login_panel_err_login_unknown'] = "Не удалось войти",
	['login_panel_err_register_unknown'] = "Не удалось зарегистрироваться",
	['login_panel_err_bad_password'] = "Неверный пароль",
	['login_panel_err_user_not_found'] = "Пользователь не найден",
	['login_panel_err_account_in_use'] = "Этот аккаунт уже используется",
	['login_panel_err_username_taken'] = "Данное имя (логин) уже используется",
    
    ['login_panel_err_username_too_short'] = "Слишком короткое имя (логин)",
	['login_panel_err_username_too_long'] = "Слишком длинное имя (логин)",
	['login_panel_err_password_too_short'] = "Слишком короткий пароль",
	['login_panel_err_password_too_long'] = "Слишком длинный пароль",
	['login_panel_err_username_invalid'] = "Недопустимое имя пользователя (логин)",

    ['login_panel_register_success'] = "Вы успешно зарегистрировались!",
}

-- Action Login
function LoginPanel.actionLogin(username, password)
    if not username or string.len(username) < 1 then
		return false, {'login', 'warning', Messages["login_panel_err_enter_username"]}
	end

	if not password or string.len(password) < 1 then
		return false, {'login', 'warning', Messages["login_panel_err_enter_password"]}
	end

	if not exports.tmtaCore:login(username, password) then
		return false, {'login', 'error', Messages["login_panel_err_login_unknown"]}
	end
    
    currentUsername = username
	currentPassword = password

    return true
end

addEvent(resourceName..".loginResponse", true)
addEventHandler(resourceName..".loginResponse", root, 
    function(success, err)
        if not success then
            local errorText = Messages["login_panel_err_login_unknown"]
            if err == "incorrect_password" then
                errorText = Messages["login_panel_err_bad_password"]
            elseif err == "user_not_found" then
                errorText = Messages["login_panel_err_user_not_found"]
            elseif err == "already_logged_in" then
                errorText = Messages["login_panel_err_account_in_use"]
            end
    
            GUI.showNotice('error', errorText, Messages["login_panel_auth_error"])
            return
        end

        LoginPanel.stop()
    end
)

-- Action Signup
function LoginPanel.actionSignUp(username, password, passwordConfirm, ...)
    if not username or string.len(username) < 1 then
        return false, {'signup', 'warning', Messages["login_panel_err_enter_username"]}
    end
    if not password or string.len(password) < 1 then
        return false, {'signup', 'warning', Messages["login_panel_err_enter_password"]}
    end
    if not passwordConfirm or string.len(passwordConfirm) < 1 then
        return false, {'signup', 'warning', Messages["login_panel_err_enter_password_confirm"]}
    end
    if passwordConfirm ~= password then
        return false, {'signup', 'error', Messages["login_panel_err_passwords_do_not_match"]}
    end

    local success, errorType = exports.tmtaCore:signUp(username, password, ...)
	if not success then
        local noticeType = 'error'
        local noticeText = Messages["login_panel_err_register_unknown"]
        if errorType == "username_too_short" then
            noticeText = Messages["login_panel_err_username_too_short"]
        elseif errorType == "username_too_long" then
            noticeText = Messages["login_panel_err_username_too_long"]
        elseif errorType == "invalid_username" then
            noticeText = Messages["login_panel_err_username_invalid"]
        elseif errorType == "password_too_short" then
            noticeText = Messages["login_panel_err_password_too_short"]
        elseif errorType == "password_too_long" then
            noticeText = Messages["login_panel_err_password_too_long"]
        end

        return false, {'signup', noticeType, noticeText}    
    end

    currentUsername = username
    currentPassword = password

    return true
end

addEvent(resourceName..".signUpResponse", true)
addEventHandler(resourceName..".signUpResponse", root, function(success, err)
	if not success then
        local errorText = Messages["login_panel_err_register_unknown"]
        if err == "already_reg" or err == "login_taken" then
            errorText = Messages["login_panel_err_username_taken"]
        end
        GUI.showNotice('error', errorText, Messages["login_panel_register_error"])
		return
	end
    
    GUI.clearSignupForm()
    GUI.gotoLoginPanel(currentUsername, currentPassword)
    GUI.showNotice('success', Messages["login_panel_register_success"], 'Поздравляем с регистрацией')
end)

function LoginPanel.playMusic(currentTrackNum)
    if isElement(bgMusic) then 
        stopSound(bgMusic)
    end 

    bgMusic = exports.tmtaSounds:playSound('music_game_theme_'..currentTrackNum)
    setSoundVolume(bgMusic, 0.5)

    musicTimer = setTimer(
        function()
            local nextTrackNum = currentTrackNum == maxTrackCount and 1 or currentTrackNum + 1
            LoginPanel.playMusic(nextTrackNum)
        end, getSoundLength(bgMusic) * 1000, 1)
end

function LoginPanel.stopMusic()
    if isElement(bgMusic) then 
        stopSound(bgMusic)
    end

    if isTimer(musicTimer) then
        killTimer(musicTimer)
    end
end

function LoginPanel.start()
    LoginPanel.playMusic(math.random(1, maxTrackCount))

    GUI.render()
    showCursor(true)
    showChat(false)

    local fields = Autologin.load()
    if fields then
        guiSetText(GUI.editLogin, fields.username)
		guiSetText(GUI.editPassword, fields.password)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, LoginPanel.start)

function LoginPanel.stop()
    LoginPanel.stopMusic()
    GUI.hideLoginPanel()
    showCursor(false)
    showChat(true)
    Autologin.remember(currentUsername, currentPassword)
end