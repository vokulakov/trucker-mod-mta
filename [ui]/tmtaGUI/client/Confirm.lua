Confirm = {}

local createdConfirm = {}
local width, height = 380, 180

function Confirm.create(message, closeCallback, okCallback, cancelCallback)
    if (type(message) ~= 'string' or message:len() == 0) then
        return false
    end

    local lineCount = 1
    for _ in string.gmatch(message, "\n") do
		lineCount = lineCount + 1
	end

    local height = height+8*lineCount
    
    local wnd = guiCreateWindow(0, 0, sW*(width /sDW), sH*(height /sDH), '', false)
    Utils.windowCentralize(wnd)
    guiWindowSetSizable(wnd, false)
    guiWindowSetMovable(wnd, false)
    wnd.enabled = true
    wnd.alpha = 0.8

    local lblTitle = guiCreateLabel(sW*((15) /sDW), sH*((28) /sDH), sW*(width /sDW), sH*(30 /sDH), 'Подтверждение', false, wnd)
    guiSetFont(lblTitle, Fonts['RB_12'])
    guiLabelSetHorizontalAlign(lblTitle, 'left', true)
    lblTitle.enabled = false

    local btnClose = guiCreateButton(sW*((width-25-10) /sDW), sH*(25 /sDH), sW*(25 /sDW), sH*(25 /sDH), 'X', false, wnd)
    addEventHandler("onClientGUIClick", btnClose,
        function()
            Confirm.delete(wnd)
            if (closeCallback and closeCallback:gsub(" ", "") ~= "") then
                return triggerEvent("executeCallback", root, closeCallback)
            end
        end, false)

    local line = exports.tmtaTextures:createStaticImage(0, sH*((55) /sDH), sW*(width /sDW), 1, 'part_dot', false, wnd)
    guiSetProperty(line, 'ImageColours', 'tl:FF808080 tr:FF808080 bl:FF808080 br:FF808080')
    line.enabled = false

    local iconSize = 96/2
    local icon = exports.tmtaTextures:createStaticImage(sW*((0) /sDW), sH*((height+10-iconSize)/2 /sDH), sW*(iconSize /sDW), sH*(iconSize /sDH), 'ui_i_question', false, wnd)
    icon.enabled = false

    local lblMessage = guiCreateLabel(sW*((15+iconSize) /sDW), sH*((5) /sDH), sW*((width-35-50) /sDW), sH*((height) /sDH), message, false, wnd)
    guiSetFont(lblMessage, Fonts['RR_10'])
    guiLabelSetHorizontalAlign(lblMessage, 'left', true)
    guiLabelSetVerticalAlign(lblMessage, 'center', true)
    guiLabelSetColor(lblMessage, 255, 255, 255)
    lblMessage.enabled = false

    local line = exports.tmtaTextures:createStaticImage(0, sH*((height-45) /sDH), sW*(width /sDW), 1, 'part_dot', false, wnd)
	guiSetProperty(line, 'ImageColours', 'tl:FF808080 tr:FF808080 bl:FF808080 br:FF808080')
	line.enabled = false

    local line = exports.tmtaTextures:createStaticImage(sW*((width/2) /sDW), sH*((height-45) /sDH), 1, sH*((height) /sDH), 'part_dot', false, wnd)
	guiSetProperty(line, 'ImageColours', 'tl:FF808080 tr:FF808080 bl:FF808080 br:FF808080')
	line.enabled = false

    local btnCancel = guiCreateButton(sW*((10) /sDW), sH*((height-40) /sDH), sW*((width/2-15) /sDW), sH*((30) /sDH), 'Отмена', false, wnd)
    guiSetFont(btnCancel, Fonts['RR_10'])
    addEventHandler("onClientGUIClick", btnCancel,
        function()
            Confirm.delete(wnd)
            if (cancelCallback and cancelCallback:gsub(" ", "") ~= "") then
                return triggerEvent("executeCallback", root, cancelCallback)
            end
        end, false)

    local btnOk = guiCreateButton(sW*((width/2+5) /sDW), sH*((height-40) /sDH), sW*((width/2-10) /sDW), sH*((30) /sDH), 'Да', false, wnd)
    guiSetFont(btnOk, Fonts['RR_10'])
    guiSetProperty(btnOk, 'NormalTextColour', 'FF01D51A')
    addEventHandler("onClientGUIClick", btnOk,
        function()
            Confirm.delete(wnd)
            if (okCallback and okCallback:gsub(" ", "") ~= "") then
                return triggerEvent("executeCallback", root, okCallback)
            end
        end, false)

    local sound = exports.tmtaSounds:playSound('ui_info')
    setSoundVolume(sound, 0.2)

    createdConfirm[wnd] = {
        title = lblTitle,
        btnCancel = btnCancel,
        btnOk = btnOk,
        sound = sound,
    }

    return wnd
end

function Confirm.delete(confirm)
    if (not createdConfirm[confirm]) then
        return false
    end

    if isElement(confirm) then
        confirm.visible = false 
        setTimer(destroyElement, 500, 1, confirm)
    end

    if (isElement(createdConfirm[confirm].sound)) then
        stopSound(createdConfirm[confirm].sound)
    end

    createdConfirm[confirm] = nil
end

function Confirm.setBtnOkLabel(confirm, label)
    if (not createdConfirm[confirm] or type(label) ~= 'string' or label:len() == 0) then
        return false
    end
    createdConfirm[confirm].btnOk.text = label
end

-- Exports
createConfirm = Confirm.create
deleteConfirm = Confirm.delete
setBtnOkLabel = Confirm.setBtnOkLabel