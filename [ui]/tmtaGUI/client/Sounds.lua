Sounds = {}

-- Hover
local EnabledElementsHover = {
    ['gui-button'] = true,
    ['gui-checkbox'] = true,
    ['gui-tabpanel'] = true
}

local ActiveElementsHover = {}

function Sounds.onClientGUIHover(guiElement)
    if not EnabledElementsHover[tostring(guiElement.type)] then
        return
    end

    ActiveElementsHover[guiElement] = true
    exports.tmtaSounds:playSound('ui_hover')
end

addEventHandler("onClientMouseMove", root, 
    function()
        if not isElement(source) or ActiveElementsHover[source] then
            return
        end
        Sounds.onClientGUIHover(source)
    end
)

addEventHandler("onClientMouseLeave", root, 
    function()
        if not isElement(source) then
            return
        end
        ActiveElementsHover[source] = nil
    end
)

-- Swithed/Select 
local EnabledElementsSelect = {
    ['gui-tabpanel'] = 'ui_change',
    ['gui-checkbox'] = 'ui_change',

    ['gui-button'] = 'ui_select',
    ['gui-edit'] = 'ui_back'
}

local ActiveElementsSelect = {}

function Sounds.onClientGUISelect(guiElement)
    local currentSound = EnabledElementsSelect[tostring(guiElement.type)]
    if not currentSound then
        return
    end

    ActiveElementsSelect[guiElement] = true
    exports.tmtaSounds:playSound(currentSound)
end

addEventHandler("onClientGUIClick", root,
    function()
        if not isElement(source) or ActiveElementsSelect[source] then
            return
        end
        Sounds.onClientGUISelect(source)
    end,
    true,
    "high+10"
)

addEventHandler("onClientGUIMouseUp", root,
    function(btnMouse)
        if btnMouse ~= "left" then
            return 
        end
        ActiveElementsSelect[source] = nil
    end
)