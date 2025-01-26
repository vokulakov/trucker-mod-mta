InputBox = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local Fonts = {
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
}

local inputBoxElement

function InputBox.create()
    if isElement(inputBoxElement) then
        return
    end 

    inputBoxElement = guiCreateEdit(0, 0, 0, 0, "", false)
    guiSetFont(inputBoxElement, Fonts['RR_10'])
    inputBoxElement.visible = false
    exports.tmtaGUI:setEditPlaceholder(inputBoxElement, "Введите сообщение")

    addEventHandler("onClientGUIChanged", inputBoxElement, onInputBoxChange, false)
    addEventHandler("onClientGUIFocus", inputBoxElement, onInputBoxFocus, false)
    addEventHandler("onClientGUIBlur", inputBoxElement, onInputBoxBlur, false)

    return inputBoxElement
end

function InputBox.isActive()
    return inputBoxElement.visible
end

local timerControl
function InputBox.close()
    if not InputBox.isActive() then 
        return false
    end

    showCursor(false)
    inputBoxElement.visible = false

    triggerEvent(resName..".onCloseInputBox", localPlayer, inputBoxElement)
    --triggerServerEvent(resName..".onCloseInputBox", localPlayer)
	
	setElementData(localPlayer, 'player.isChatting', false, false)

    timerControl = setTimer(
        function()
            guiSetInputEnabled(false)
            toggleControl("chatbox", false)
        end, 500, 1)

    bindKey("t", "up", InputBox.open)

    return true
end

local ChatboxFonts = {
    [0] = "Tahoma",
    [1] = "Verdana",
    [2] = "Tahoma Bold",
    [3] = "Arial"
}

function InputBox.open(key)
    if not isElement(inputBoxElement) or not isChatVisible() or isConsoleActive() then 
        return false
    end

    if InputBox.isActive() then 
        return InputBox.close()
    end

    if isTimer(timerControl) then
        killTimer(timerControl)
    end

    local chatLayout = getChatboxLayout()
    guiEditSetMaxLength(inputBoxElement, getChatboxCharacterLimit()) -- максимальное количество символов
    
    -- Размер поля ввода
    guiSetSize(inputBoxElement, sW*((300*chatLayout.chat_width) /sDW), sH*(30 /sDH), false)
    
    -- Положение поля ввода
    local posX = sW*chatLayout.chat_position_offset_x
    local posY = sH*chatLayout.chat_position_offset_y

    local offsetY = 1.5 + (15.5 *chatLayout.chat_scale[2] *chatLayout.text_scale)*chatLayout.chat_lines
    local marginBottom = sH*((720 -30 -10) /sDH)
    posY = (posY+offsetY) > marginBottom and marginBottom or posY+offsetY
    guiSetPosition(inputBoxElement, posX, posY, false)
  
    guiEditSetCaretIndex(inputBoxElement, inputBoxElement.text:len())
    showCursor(true)
    inputBoxElement.visible = true
 
    triggerEvent(resName..".onOpenInputBox", localPlayer, inputBoxElement)
    --triggerServerEvent(resName..".onOpenInputBox", localPlayer)
	
	setElementData(localPlayer, 'player.isChatting', true, false)

    guiSetInputEnabled(true)

    unbindKey("t", "up", InputBox.open)
    return true
end

function InputBox.setMessage(message)
    if not InputBox.isActive() or not message or message:gsub(" ", "") == "" then 
        return false
    end
    inputBoxElement.text = message
    guiEditSetCaretIndex(inputBoxElement, inputBoxElement.text:len())
    return true
end

function InputBox.reset()
    if not InputBox.isActive() then 
        return false
    end
    inputBoxElement.text = " "
    return true
end

addEventHandler("onClientCharacter", root, function(key)
    if not InputBox.isActive() then
        return
    end
    guiFocus(inputBoxElement)
end)

function onInputBoxChange()
    if not InputBox.isActive() then 
        return
    end
    if pregFind(inputBoxElement.text, "^( )$") then -- если в начале ставится пробел
        inputBoxElement.text = ""
    end
end
    
function onInputBoxFocus()
    if not InputBox.isActive() then 
        return
    end
end 

function onInputBoxBlur()
    if not InputBox.isActive() then 
        return
    end
end

addEventHandler("onClientPaste", root, function(text)
    if not InputBox.isActive() or not text then 
        return
    end
    InputBox.setMessage(text:sub(1, Config.MAX_MESSAGE_LENGTH)) 
end)

addEventHandler("onClientKey", root, function(key, press)
    if not InputBox.isActive() or not press then 
        return
    end

    if (key == "enter" or key == "num_enter") then
        local message = inputBoxElement.text

        -- Обработка сообщения
        if message ~= exports.tmtaGUI:getEditPlaceholder(inputBoxElement) and message:len() > 0 then
            onMessageFromInputBox(message)
        end
        
        InputBox.close()
        inputBoxElement.text = ""
        guiBlur(inputBoxElement)
    elseif (key == "backspace") then
		guiEditSetCaretIndex(inputBoxElement, inputBoxElement.text:len())
        guiFocus(inputBoxElement)
    elseif (key == "arrow_l" or key == "arrow_r") then
        guiFocus(inputBoxElement)
    end
end)

addEventHandler("onClientVehicleStartEnter", root, function(player)
	if (player == localPlayer) then
	end
end)

addEventHandler("tmtaUI.onSetPlayerComponentVisible", root,
    function(changedComponent)
        if not exports.tmtaUI:isPlayerComponentVisible("chat") and InputBox.isActive() then 
            return InputBox.close()
        end
    end
)

bindKey("t", "up", InputBox.open)
bindKey("f6", "up", InputBox.open)