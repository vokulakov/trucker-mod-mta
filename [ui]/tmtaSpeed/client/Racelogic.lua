Racelogic = {}
Racelogic.visible = false

Racelogic.start_tick = false
Racelogic.stop_tick = false
Racelogic.visible_tick = false

Racelogic.enableAlpha = false
Racelogic.alpha = 0
Racelogic.xs = 0

Racelogic.curMsec = 0
Racelogic.prevSpeed = 0

Racelogic.timer = false

Racelogic.textureRacelogic = dxCreateTexture('assets/images/bg_Racelogic.png')
Racelogic.fontSpeed = exports.tmtaFonts:createFontDX('GothamProMedium', 18)
Racelogic.fontDescription = exports.tmtaFonts:createFontDX('GothamProBold', 7.5)

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

function Racelogic.draw(posX, posY, speed)
    if not exports.tmtaUI:isPlayerComponentVisible("racelogic") then
        return
    end

    if Racelogic.prevSpeed < 1 and speed > 0 and not isTimer(Racelogic.timer) then
		Racelogic.start_tick = getTickCount()
	end

    if speed >= 100 and Racelogic.start_tick then
		Racelogic.stop_tick = getTickCount()
		Racelogic.curMsec = exports.tmtaUtils:round(math.abs(Racelogic.start_tick - Racelogic.stop_tick)/1000, 2)
		Racelogic.start_tick = nil
		Racelogic.visible = true
         
        Racelogic.visible_tick = getTickCount()
        Racelogic.enableAlpha = true 
	end
	Racelogic.prevSpeed = speed

    if Racelogic.enableAlpha then
        if Racelogic.visible_tick then 
            Racelogic.alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - Racelogic.visible_tick)/500, "OutQuad")
			Racelogic.xs = interpolateBetween(-100,0,0,0,0,0,(getTickCount() - Racelogic.visible_tick)/200,  "OutQuad")
        end
    else
        if Racelogic.visible_tick then 
            Racelogic.alpha = interpolateBetween(255,0,0,0,0,0, (getTickCount() - Racelogic.visible_tick)/1000, "OutQuad")
			Racelogic.xs = interpolateBetween(0,0,0,-300,0,0,(getTickCount() - Racelogic.visible_tick)/500, "OutQuad")

            Racelogic.timer = setTimer(
                function()
                    Racelogic.visible = false
                    Racelogic.visible_tick = false
                end, 100, 1)
        end
    end

    if Racelogic.visible then
        posY = posY-92-40
        dxSetTextureEdge(Racelogic.textureRacelogic, "clamp")
        dxDrawImage(sW*((posX-241-Racelogic.xs) /sDW), sH*((posY) /sDH), sW*((241) /sDW), sH*((92) /sDH), Racelogic.textureRacelogic, 0, 0, 0, tocolor(255, 255, 255, Racelogic.alpha))
        dxDrawText(string.format('%.2f Сек', Racelogic.curMsec), sW*((posX-225+78-Racelogic.xs) /sDW), sH*((posY+22) /sDH), sW*((posX-20) /sDW), sH*((posY) /sDH), tocolor(238, 174, 39, Racelogic.alpha), sW/sDW*1.0, Racelogic.fontSpeed, "center", "top", false, false, false, true)
        dxDrawText('Разгон от 0 до 100 км/ч', sW*((posX-225+78-Racelogic.xs) /sDW), sH*((posY+22+28) /sDH), sW*((posX-20) /sDW), sH*((posY) /sDH), tocolor(255, 255, 255, Racelogic.alpha), sW/sDW*1.0, Racelogic.fontDescription, "center", "top", false, false, false, true)
        if not isTimer(Racelogic.timer) then
            Racelogic.timer = setTimer(
                function()
                    Racelogic.visible_tick = getTickCount()
                    Racelogic.enableAlpha = false
                end, 3000, 1)
        end
    end
end