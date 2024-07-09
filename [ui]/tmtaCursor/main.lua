Cursor = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local currentCursorTexture
local currentCursorSize

local cursorAlpha = getCursorAlpha()
local cursorScale = 0.1

local CursorTextures = {}

addEventHandler("onClientRender", root,
    function()
        if not isCursorShowing() or isConsoleActive() then
            return
        end

        local cursorPosX, cursorPosY = getCursorPosition()
        local posX, posY = cursorPosX * sW, cursorPosY * sH
        local sizeX, sizeY = dxGetMaterialSize(currentCursorTexture)
        sizeX, sizeY = sW*(sizeX*cursorScale /sDW), sH*(sizeY*cursorScale /sDH)

        dxSetTextureEdge(currentCursorTexture, "clamp")

        dxDrawImage(
            posX, posY,
            sizeX, sizeY,
			currentCursorTexture, 
            0, 0, 0, 
            tocolor(255, 255, 255, cursorAlpha), 
            true
        )

    end, true, "low-999999999"
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        CursorTextures['pointer'] = dxCreateTexture("assets/cur_pointer.png", "argb", true, "clamp")
        currentCursorTexture = CursorTextures["pointer"]
        setCursorAlpha(0)
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
	    setCursorAlpha(cursorAlpha)
	end
)