Misc = {}
Misc.visible = false

--local width, height
local posX, posY

--https://wiki.multitheftauto.com/wiki/GetZoneName

function Misc.draw()
    if not Misc.visible or not exports.tmtaUI:isPlayerComponentVisible("hud") then
        return
    end

    -- Костыль для радара
    if Camera.interior ~= 0 then
		return
	end

    -- Микрофон
    local voiceTexture = localPlayer:getData("isVoice") and Textures.i_voice_on or Textures.i_voice_off
    dxDrawImage(sW*((posX) /sDW), sH*((posY-44) /sDH), sW*((44) /sDW), sH*((44) /sDH), voiceTexture, 0, 0, 0, tocolor(255, 255, 255, 255), false)

    -- Зелёная зона
    local posOffsetY = 44*2+5
    local greenZoneTexture = localPlayer:getData("inGreenZone") and Textures.i_green_on or Textures.i_green_off
    dxDrawImage(sW*((posX) /sDW), sH*((posY-posOffsetY) /sDH), sW*((44) /sDW), sH*((44) /sDH), greenZoneTexture, 0, 0, 0, tocolor(255, 255, 255, 255), false)

    -- Названия местноси
    local x, y, z = getElementPosition(localPlayer)
    local location = getZoneName(x, y, z)
	local city = getZoneName(x, y, z, true)
    dxDrawText(city, sW*((posX+44+5) /sDW), sH*((posY-posOffsetY+12) /sDH), sW, sH*((posY-posOffsetY+20) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_10, "left", "center")
    dxDrawText(location, sW*((posX+44+5) /sDW), sH*((posY-posOffsetY+22) /sDH), sW, sH*((posY-posOffsetY+34) /sDH), tocolor(255, 255, 255, 155), sW/sDW*1.0, Fonts.RR_8, "left", "center")

end

function Misc.start()
    posX, posY = 20+250+5, sDH-40 -- тут параметры от радара в основном

    Textures.i_green_off = dxCreateTexture('assets/misc/i_green_off.png')
    Textures.i_green_on = dxCreateTexture('assets/misc/i_green_on.png')
    Textures.i_voice_off = dxCreateTexture('assets/misc/i_voice_off.png')
    Textures.i_voice_on = dxCreateTexture('assets/misc/i_voice_on.png')

    Misc.visible = true
end
