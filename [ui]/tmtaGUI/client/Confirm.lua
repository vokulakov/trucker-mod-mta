Confirm = {}

local width, height = 380, 130

function Confirm.create(message, okCallback, cancelCallback)
    if (type(message) ~= 'string' or message:len() == 0) then
        return false
    end

    local lineCount = 1
    for _ in string.gmatch(message, "\n") do
		lineCount = lineCount + 1
	end

    local width = sW*((width) /sDW)
    local height = sH*((height+8*lineCount) /sDH)

    local wnd = guiCreateWindow(0, 0, width, height, '', false)
    Utils.windowCentralize(wnd)
    guiWindowSetSizable(wnd, false)
    guiWindowSetMovable(wnd, false)
    wnd.enabled = true
    wnd.alpha = 0.8

    -- Icon
    local iconW, iconH = sW*((96/2.5) /sDW), sH*((96/2.5) /sDH)
    local icon = exports.tmtaTextures:createStaticImage(0, (height+10 -iconH) /2, iconW, iconH, 'ui_i_question', false, wnd)
    icon.enabled = false

    local line = exports.tmtaTextures:createStaticImage(0, height-12, width, 1, 'part_dot', false, wnd)
	guiSetProperty(line, 'ImageColours', 'tl:FF25B7D3 tr:FF25B7D3 bl:FF25B7D3 br:FF25B7D3')
	line.enabled = false
    
    local sound = exports.tmtaSounds:playSound('ui_info')
    setSoundVolume(sound, 0.2)

    return wnd
end

-- function Utils.showConfirmWindow(title, message, onClickOk, onClickCancel)

--     local message = guiCreateLabel(0, Utils.sH*((25) /Utils.sDH), width, Utils.sH*((55) /Utils.sDH), message, false, windowConfirm)
--     guiLabelSetHorizontalAlign(message, "center")
--     guiLabelSetVerticalAlign(message, "center")
--     guiSetFont(message, "default-bold-small")

--     local line = guiCreateLabel(0, Utils.sH*((75) /Utils.sDH), width, Utils.sH*((25) /Utils.sDH), ('_'):rep(width/4), false, windowConfirm)
--     guiLabelSetHorizontalAlign(line, "center")
--     guiSetFont(line, "default-bold-small")
--     guiLabelSetColor(line, 105, 105, 105)
--     guiSetEnabled(line, false)

--     local btnCancel = guiCreateButton(0, Utils.sH*((95) /Utils.sDH), Utils.sW*((165) /Utils.sDW), Utils.sH*((30) /Utils.sDH), 'Нет', false, windowConfirm)
--     guiSetFont(btnCancel, Utils.fonts.RR_10)
--     addEventHandler("onClientGUIClick", btnCancel, function() executeCallback(onClickCancel) end, false)

--     local btnOk = guiCreateButton(Utils.sW*((165+15) /Utils.sDW), Utils.sH*((95) /Utils.sDH), Utils.sW*((195) /Utils.sDW), Utils.sH*((30) /Utils.sDH), 'Да', false, windowConfirm)
--     guiSetFont(btnOk, Utils.fonts.RR_10)
--     guiSetProperty(btnOk, "NormalTextColour", "FF01D51A")
--     addEventHandler("onClientGUIClick", btnOk, function() executeCallback(onClickOk) end, false)

--     return windowConfirm
-- end

-- Utils.showConfirmWindow('Внимание!', 'Тестовое сообщение', function() iprint('Click Ok') end, function() iprint('Click Cancell') end)
