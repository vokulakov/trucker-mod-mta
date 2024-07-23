Utils = {}

-- Разместить окно по центру экрана
function Utils.windowCentralize(window)
    if not isElement(window) then
        return false
    end

    local windowW, windowH = guiGetSize(window, false)
    local x, y = (sW - windowW) /2, (sH - windowH) /2
    guiSetPosition(window, x, y, false)
    
    return x, y
end 

-- Пометить поле, как обязательное
function Utils.setEditRequired(editBox)
    if not isElement(editBox) then
        return false
    end

    local lblRequired = guiCreateLabel(0.95, 0.1, 1, 1, "*", true, editBox)
    guiSetFont(lblRequired, Fonts['RB_12'])
    guiLabelSetColor(lblRequired, 255, 0, 0)
    lblRequired.enabled = false

    addEventHandler("onClientGUIChanged", editBox, function()
        guiSetVisible(lblRequired, true)

        local placeholderText = source:getData("placeholder") or ""
        if source.text:len() ~= 0 and source.text ~= placeholderText then
            guiSetVisible(lblRequired, false)
        end
    end, false)

    return true
end

-- Установить заполнение поля
function Utils.setEditPlaceholder(editBox, placeholderText)
    if not isElement(editBox) or placeholderText:len() == 0 then
        return false
    end

    local isMasked = guiEditIsMasked(editBox)

    editBox.text = placeholderText
    editBox:setData('placeholder', placeholderText)
    guiSetProperty(editBox, "NormalTextColour", "ff808080")
    guiEditSetMasked(editBox, false)

    addEventHandler("onClientGUIFocus", editBox, function()
        if source.text == placeholderText then
            source.text = ''
            guiSetProperty(source, "NormalTextColour", "ff000000")
            guiEditSetMasked(source, isMasked)
        end
    end, false)

    addEventHandler("onClientGUIBlur", editBox, function()
        if source.text ~= placeholderText and source.text:len() ~= 0 and not pregFind(source.text, "^( )$") then
            return cancelEvent()
        end

        source.text = placeholderText
        guiSetProperty(source, "NormalTextColour", "ff808080")
        guiEditSetMasked(source, false)
    end, false)

    addEventHandler("onClientGUIClick", root, function()
        if not isElement(editBox) or source == editBox then 
            return cancelEvent()
        end 
       
        guiBlur(editBox)

        if editBox.text ~= placeholderText and editBox.text:len() ~= 0 then
            return cancelEvent()
        end
        
        editBox.text = placeholderText
        guiSetProperty(editBox, "NormalTextColour", "ff808080")
        guiEditSetMasked(editBox, false)
    end)

    addEventHandler("onClientGUIChanged", editBox, function(element) 
        if not isElement(editBox) or element ~= editBox then 
            return cancelEvent()
        end
        guiSetProperty(source, "NormalTextColour", "ff000000")
        guiEditSetMasked(source, isMasked)
    end, false)

    return true
end

function Utils.getEditPlaceholder(editBox)
    if not isElement(editBox) then 
        return false 
    end
    return editBox:getData("placeholder") or ""
end

-- exports 
windowCentralize = Utils.windowCentralize
setEditRequired = Utils.setEditRequired
setEditPlaceholder = Utils.setEditPlaceholder
getEditPlaceholder = Utils.getEditPlaceholder