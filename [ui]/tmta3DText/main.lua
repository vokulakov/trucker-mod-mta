local streamedElements = {}

local WIDTH = 250
local HEIGHT = 200
local SCALE = 5.8
local MAX_DISTANCE = 50

local FONT = exports.tmtaFonts:createFontDX('RobotoBold', 24)

local function dxDrawText3D(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	alignX = alignX or "center"
	alignY = alignY or "center"
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, _, _, _, true)
end

addEventHandler('onClientRender', root,
    function()
        if not exports.tmtaUI:isPlayerComponentVisible('text3d') then
            return
        end

        local cx, cy, cz = getCameraMatrix()
        for element, data in pairs(streamedElements) do
            if isElement(element) then
                local x, y, z = getElementPosition(element)
                if (isLineOfSightClear(cx, cy, cz, x, y, z, true, true, false, true, false, true, false, nil)) then
                    local posX, posY = getScreenFromWorldPosition(x, y, z + data.offset)
                    if (posX and posY) then
                        local distance = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)
                        if (distance < MAX_DISTANCE) then
                            local scale = 1 / distance * SCALE
                            local width = WIDTH * scale
                            local height = HEIGHT * scale
                            local nx, ny = posX - width / 2, posY - height / 2

                            dxDrawText3D(data.text, nx, ny, nx + width, ny + height, tocolor(255, 255, 0), scale, FONT, 'center', 'top')
                        end
                    end
                end
            end
        end
    end
)

addEventHandler('onClientElementStreamIn', root,
    function()
        local text = source:getData('3dText')
        if not text then
            return
        end
        streamedElements[source] = { 
            text = text,
            offset = (getElementType(source) == 'ped') and 1.2 or 0.6
        }
    end
)

addEventHandler('onClientElementStreamOut', root, 
    function()
        if not streamedElements[source] then
            return 
        end
        streamedElements[source] = nil
    end
)