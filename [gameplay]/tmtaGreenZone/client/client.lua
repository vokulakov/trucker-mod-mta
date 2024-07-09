setDevelopmentMode(true)

addEventHandler("onClientPlayerDamage", root, function()
    if localPlayer:getData("player.isInArea") then 
        cancelEvent()
    end
end)

--TODO:: WELCOME
--[[
local screenWidth, screenHeight = guiGetScreenSize()

local help_label = ""
local help_text = ""

local function drawHelpMessage()
	dxDrawRectangle( screenWidth/2-350/2, screenHeight/12, 350, 80, tocolor (0,0,0,150) )
	dxDrawText(help_label, screenWidth/2-350/2, screenHeight/12+20, screenWidth/2+350/2, screenHeight/12+40, tocolor(150,150,255,255), 1, "default-bold", "center", "center" )
	dxDrawText(help_text, screenWidth/2-350/2, screenHeight/12+40, screenWidth/2+350/2, screenHeight/12+80, tocolor(255,255,255,255), 1, "default-bold", "center", "center" )
end

function showWelcomeMessage(label, text, time_to_show)
	help_label = label
	help_text = text

	if isTimer(killHelpMessage) then
		killTimer(killHelpMessage)
	else
		addEventHandler("onClientRender", root, drawHelpMessage)
	end

	killHelpMessage = setTimer(
        function() 
            removeEventHandler("onClientRender", root, drawHelpMessage) 
        end, time_to_show * 1000, 1 )
end
addEvent("tmtaGreenZones.showWelcomeMessage", true)
addEventHandler("tmtaGreenZones.showWelcomeMessage", root, showWelcomeMessage)
]]