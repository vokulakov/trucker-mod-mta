HUD = {}

sW, sH = guiGetScreenSize()
sDW, sDH = exports.tmtaUI:getScreenSize()

Textures = {
    background  = dxCreateTexture('assets/images/bg_shadow.png'),
    logo        = exports.tmtaTextures:createTexture('logo_tmta_86'),
    bg_x2       = dxCreateTexture('assets/images/bg_x2.png'),
    i_hp        = dxCreateTexture('assets/images/i_hp.png'),
    i_hunger    = dxCreateTexture('assets/images/i_hunger.png'),
    i_armor     = dxCreateTexture('assets/images/i_armor.png'),
    i_oxygen    = dxCreateTexture('assets/images/i_oxygen.png'),
    i_clock     = exports.tmtaTextures:createTexture('i_clock'),
}

Fonts = {
    TIME_DATE       = exports.tmtaFonts:createFontDX("GothamProMedium", 11, false, "antialiased"),
    X2              = exports.tmtaFonts:createFontDX("GothamProBold", 13, false, "antialiased"),
}

local posX, posY = sDW-90, 10

function HUD.draw()
    if not exports.tmtaUI:isPlayerComponentVisible("hud") then
        return
    end
    
    local HP_PLAYER = getElementHealth(localPlayer)
    local ARMOUR_PLAYER = getPedArmor(localPlayer)

    -- SHADOW
    dxDrawImage(0, 0, sW, sH, Textures.background, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    
    -- LOGO
    dxSetTextureEdge(Textures.logo, "clamp")
    dxDrawImage(sW*((posX) /sDW), sH*((posY+5) /sDH), sW*((86) /sDW), sH*((86) /sDH), Textures.logo, 15, 0, 0, tocolor(255, 255, 255, 255), false)
    -- X2
    --dxDrawImage(sW*((sW-50) /sDW), sH*((posY+74) /sDH), sW*((50) /sDW), sH*((50) /sDH), Textures.bg_x2, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    --dxDrawImage(sW-(33.39+38.61)*pX, 74*pY, 50*pX, 50*pY, Textures.bg_x2, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    --Utils.dxDrawText("x2", sW-65*pX, 84*pY, 29*pX, 29*pY, tocolor(255, 255, 255, 255), 1, Fonts["X2"], "center", "center")
    --dxDrawText("x2", sW*((sW-80-5) /sDW), sH*((posY+5) /sDH), sW*((80) /sDW), sH*((80) /sDH), tocolor(255, 255, 255, 255), 1, Fonts.X2, "center", "center")
    
    -- TIME
    local timehour, timeminute = getTime()
    local REAL_TIME = getRealTime()
    local timeStr = string.format("%02d:%02d", timehour, timeminute)
    local dateStrt = string.format("%02d.%02d.%02d", REAL_TIME.monthday, REAL_TIME.month + 1, tostring(REAL_TIME.year + 1900):sub(-2))
    local textTimeWidth = dxGetTextWidth(timeStr, sW/sDW*1.0, Fonts.TIME_DATE)
    local textDateWidth = dxGetTextWidth(dateStrt, sW/sDW*1.0, Fonts.TIME_DATE)
    local timeOffsetY = 16 -- смещение даты
    local timeOffsetX = 10
    dxDrawText(dateStrt, sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX) /sDW)-timeOffsetX, sH*((posY+timeOffsetY) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.TIME_DATE, "right", "center")
    timeOffsetX = timeOffsetX+textDateWidth+10
    dxDrawRectangle(sW*((posX) /sDW)-timeOffsetX, sH*((posY) /sDH), sW*((2) /sDW), sH*((16) /sDH), tocolor(255, 255, 255, 155))
    timeOffsetX = timeOffsetX+10
    dxDrawText(timeStr, sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX) /sDW)-timeOffsetX, sH*((posY+timeOffsetY) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.TIME_DATE, "right", "center")
    timeOffsetX = timeOffsetX+textTimeWidth+10+sW*((16) /sDW)
    dxSetTextureEdge(Textures.i_clock, "clamp")
    dxDrawImage(sW*((posX) /sDW)-timeOffsetX, sH*((posY) /sDH), sW*((16) /sDW), sH*((16) /sDH), Textures.i_clock, 0, 0, 0, tocolor(255, 255, 255, 255), false)    
    
    --dxDrawRectangle(0, sH*((posY) /sDH), sW, 1, tocolor(255, 0, 0, 255))
    --dxDrawRectangle(0, sH*((posY+timeOffsetY) /sDH), sW, 1, tocolor(255, 0, 0, 255))

    -- HP
    dxDrawCircle(sW*((posX-10-16) /sDW), sH*((posY+30+16) /sDH), sH*((16) /sDH), 270, -90+360-((HP_PLAYER*360)/100), tocolor(255, 79, 79, 85), tocolor(255, 79, 79, 85), 15)
    dxSetTextureEdge(Textures.i_hp, "clamp")
    dxDrawImage(sW*((posX-10-32) /sDW), sH*((posY+30) /sDH), sW*((32) /sDW), sH*((32) /sDH), Textures.i_hp, 0, 0, 0, tocolor(255, 255, 255, 255))

    -- HUNGER
    local hungerPlayer = exports.tmtaPlayerNeeds:getPlayerHungerLevel()
    dxDrawCircle(sW*((posX-32*2-5) /sDW), sH*((posY+30+16) /sDH), sH*((16) /sDH), 270, -90+360-((hungerPlayer*360)/100), tocolor(255, 170, 5, 85), tocolor(255, 170, 5, 85), 15)
    dxSetTextureEdge(Textures.i_hunger, "clamp")
    dxDrawImage(sW*((posX-32*2-10*2) /sDW), sH*((posY+30) /sDH), sW*((32) /sDW), sH*((32) /sDH), Textures.i_hunger, 0, 0, 0, tocolor(255, 255, 255, 255))

    -- ARMOR
    local posOffsetCircleX = 32*3+5*3
    local posOffsetImageX = 32*3+10*3
    if ARMOUR_PLAYER > 0 then
        dxDrawCircle(sW*((posX-posOffsetCircleX) /sDW), sH*((posY+30+16) /sDH), sH*((16) /sDH), 270, -90+360-((ARMOUR_PLAYER*360)/100), tocolor(255, 255, 255, 85), tocolor(255, 255, 255, 85), 15)
        dxSetTextureEdge(Textures.i_armor, "clamp")
        dxDrawImage(sW*((posX-posOffsetImageX) /sDW), sH*((posY+30) /sDH), sW*((32) /sDW), sH*((32) /sDH), Textures.i_armor, 0, 0, 0, tocolor(255, 255, 255, 255))
        -- костыль для кислорода, чтобы не было дыры, если нет брони
        posOffsetCircleX = 32*4+5*5
        posOffsetImageX = 32*4+10*4 
    end
    
    -- OXYGEN
    if isElementInWater(localPlayer) then
        local OXYGEN_PLAYER = math.floor(getPedOxygenLevel(localPlayer))
        dxDrawCircle(sW*((posX-posOffsetCircleX) /sDW), sH*((posY+30+16) /sDH), sH*((16) /sDH), 270, -90+360-((OXYGEN_PLAYER*360)/1000), tocolor(0, 209, 255, 85), tocolor(0, 209, 255, 85), 15)
        dxSetTextureEdge(Textures.i_oxygen, "clamp")
        dxDrawImage(sW*((posX-posOffsetImageX) /sDW), sH*((posY+30) /sDH), sW*((32) /sDW), sH*((32) /sDH), Textures.i_oxygen, 0, 0, 0, tocolor(255, 255, 255, 255))    
    end

    local moneyOffsetY = 20 -- смещение показтеля денег
    Money.draw(posX, posY+26+32+moneyOffsetY)
    --dxDrawRectangle(0, sH*((posY+26+32+moneyOffsetY) /sDH), sW, 1, tocolor(255, 0, 0, 255))
    --dxDrawRectangle(0, sH*((posY+26+32+moneyOffsetY+28) /sDH), sW, 1, tocolor(255, 0, 0, 255))
end

addEventHandler("onClientHUDRender", root, function()
    dxSetBlendMode("modulate_add")
    HUD.draw()
    Experience.draw()
    Misc.draw()
    dxSetBlendMode("blend")
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    Fonts.RR_8 = exports.tmtaFonts:createFontDX("RobotoRegular", 8, false, "draft")
    Fonts.RR_10 = exports.tmtaFonts:createFontDX("RobotoRegular", 10, false, "draft")
    
    Experience.start()
    Misc.start()
end)