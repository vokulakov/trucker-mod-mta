local screenWidth, screenHeight = guiGetScreenSize()
local enabled = false
local screenSource

local function drawBlackBar()
	dxDrawRectangle(0, 0, screenWidth, 40, tocolor(0, 0, 0, 255), true)
	dxDrawRectangle(0, screenHeight-40, screenWidth, 40, tocolor(0, 0, 0, 255), true)
end

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        screenSource = dxCreateScreenSource(screenWidth, screenHeight)
    end
)

function drawScreenSource()
    if screenSource then
        dxUpdateScreenSource(screenSource)
        dxDrawImage(screenWidth - screenWidth, screenHeight - screenHeight,  screenWidth, screenHeight, screenSource, 0, 0, 0, tocolor(255, 255, 255, 255), true)
        drawBlackBar()
    end
end

function startCleanScreen()
    if enabled then
        return false 
    end
    addEventHandler("onClientRender", root, drawScreenSource)
    --UI.setPlayerComponentVisible("all", false)
    enabled = true
end

function stopCleanScreen()
    if not enabled then
        return false
    end
    removeEventHandler("onClientRender", root, drawScreenSource)
    --UI.setPlayerComponentVisible("all", true)
    enabled = false
end

--[[
bindKey("I", "down", 
    function()
        enabled = not enabled
        if enabled then
            startCleanScreen()
        else
            stopCleanScreen()
        end
    end
)
]]