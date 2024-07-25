Notice = {}

local createdNotices = {}

local Params = {

    ['success'] = {
        ['icon'] = 'ui_i_success',
        ['lineColor'] = '4CAF50',
        ['title'] = 'Уведомление',
        ['titleColor'] = { 76, 175, 80 },
        ['sound'] = 'ui_success'
    },

    ['warning'] = {
        ['icon'] = 'ui_i_warning',
        ['lineColor'] = 'F4B42B',
        ['title'] = 'Внимание',
        ['titleColor'] = { 244, 180, 43 },
        ['sound'] = 'ui_warning'
    },

    ['info'] = {
        ['icon'] = 'ui_i_info',
        ['lineColor'] = '25B7D3',
        ['title'] = 'Информация',
        ['titleColor'] = { 37, 183, 211 },
        ['sound'] = 'ui_info'
    },

    ['error'] = {
        ['icon'] = 'ui_i_error',
        ['lineColor'] = 'F44336',
        ['title'] = 'Ошибка',
        ['titleColor'] = { 244, 67, 54 },
        ['sound'] = 'ui_error'
    }

}

--TODO:: через определенное время уведомление исчезает (если есть параметр), либо можно закрыть его принудительно
--TODO:: проигрывать звук уведомления (добавить параметр будет ли проигрываться или нет)
--TODO:: если на экране уже есть уведомление, то его нужно уничтожить 

function Notice.create(x, y, width, noticeType, message, disappear)
    local params = Params[noticeType]
    if not params then
        return false
    end

    if not message or message:len() == 0 then
        outputDebugString("не указано сообщение уведомления", 1)
        return false
    end

    -- Удаление предыдуших уведомлений
    for notice in pairs(createdNotices) do
        Notice.delete(notice)
    end

    -- Рассчитатть размер текста
    local lineCount = 1
    for _ in string.gmatch(message, "\n") do
		lineCount = lineCount + 1
	end

    local height = sH*((100+8*lineCount) /sDH)
    disappear = (disappear == nil) and true or disappear

    local wnd = guiCreateWindow(x, y, width, height, "", false)
    if not isElement(wnd) then
        return false
    end 

    guiWindowSetSizable(wnd, false) 
    guiWindowSetMovable(wnd, false)
    wnd.enabled = true
    wnd.alpha = 0.8
    wnd.visible = true

    -- Tittle
    local lblTitle = guiCreateLabel(0.17, 0.25, 1, 0.3, params.title, true, wnd)
    guiSetFont(lblTitle, Fonts['RB_10'])
    guiLabelSetHorizontalAlign(lblTitle, "left", true)
    guiLabelSetColor(lblTitle, params.titleColor[1], params.titleColor[2], params.titleColor[3])
    lblTitle.enabled = false

    -- Message 
    local lblMessage = guiCreateLabel(0.17, 0.45, 0.7, 0.7, message, true, wnd)
    guiSetFont(lblMessage, Fonts['RR_10'])
    guiLabelSetHorizontalAlign(lblMessage, "left", true)
    guiLabelSetColor(lblMessage, 255, 255, 255)
    lblMessage.enabled = false

    -- Icon
    local iconW, iconH = sW*(96/2.5 /sDW), sH*(96/2.5 /sDH)
    local icon = exports.tmtaTextures:createStaticImage(0, (height+10 -iconH) /2, iconW, iconH, params.icon, false, wnd)
    icon.enabled = false

    -- Bottom line
    local line = exports.tmtaTextures:createStaticImage(0, height-12, width, 1, 'part_dot', false, wnd)
	guiSetProperty(line, "ImageColours", 'tl:FF'..params.lineColor..' tr:FF'..params.lineColor..' bl:FF'..params.lineColor..' br:FF'..params.lineColor)
	line.enabled = false

    -- Button close
    local btnW, btnH = sW*(25 /sDW), sH*(25 /sDH)
    local btnClose = guiCreateButton(width - 10 - btnW, (height+10 - btnH) /2, btnW, btnH, 'X', false, wnd)
    guiSetProperty(btnClose, "NormalTextColour", "FFFFFFFF")
    guiSetFont(btnClose, Fonts['RB_10'])

    addEventHandler("onClientGUIClick", btnClose,
        function()
            Notice.delete(wnd)
        end, false)

    local sound = exports.tmtaSounds:playSound(params.sound)
    setSoundVolume(sound, 0.4)

    -- Скрывать
    if disappear then
        disappearTimer = setTimer(Notice.delete, 5000, 1, wnd)
    end

    createdNotices[wnd] = {
        title = lblTitle,
        message = lblMessage,
        sound = sound,
        timer = disappearTimer
    }

    return wnd
end

function Notice.setTitle(notice, title)
    if not createdNotices[notice] or title:len() == 0 then
        return false
    end
    createdNotices[notice].title.text = title
end

function Notice.setMessage(notice, message)
    if not createdNotices[notice] or message:len() == 0 then
        return false
    end
    createdNotices[notice].message.text = message
end

function Notice.delete(notice)
    if not createdNotices[notice] then
        return false
    end

    if isElement(notice) then
        notice.visible = false 
        --TODO:: костыль, чтобы звук щелчка успевал проигрываться 
        setTimer(destroyElement, 500, 1, notice)
    end

    if isTimer(createdNotices[notice].timer) then
        killTimer(createdNotices[notice].timer)
    end 
    
    if isElement(createdNotices[notice].sound) then
        stopSound(createdNotices[notice].sound)
    end

    createdNotices[notice] = nil
end

addEventHandler("onClientElementDestroy", root, 
    function()
        if source.type == 'gui-window' then
            Notice.delete(source)
        end
    end
)

-- Exports
createNotice = Notice.create
deleteNotice = Notice.delete
setNoticeTitle = Notice.setTitle
setNoticeMessage = Notice.setMessage