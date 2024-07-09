Experience = {}
Experience.visible = false

local width, height
local posX, posY

Experience.setup = {
    lvlBgColor = tocolor(0, 0, 0, 125),
    xpBackgroundColor = tocolor(242, 171, 18, 100),
    xpProgressColor = tocolor(242, 171, 18, 255),
}

function Experience.draw()
    if not Experience.visible or not exports.tmtaUI:isPlayerComponentVisible("hud") then
        return
    end

    local exp = exports.tmtaExperience:getPlayerExp()
    local lvl = exports.tmtaExperience:getPlayerLvl()
    local requiredExp = exports.tmtaExperience:getExpToLevelUp(tonumber(lvl))
    
    -- Основа
    dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 155))
    -- Уровень
    dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY+5) /sDH), sW*((40-10) /sDW), sH*((height-10) /sDH), Experience.setup.lvlBgColor)
    dxDrawText(lvl, sW*((posX+5) /sDW), sH*((posY+5) /sDH), sW*((posX+5+40-10) /sDW), sH*((posY+5+height-10) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_10, 'center', 'center')
    -- Опыт
    dxDrawRectangle(sW*((posX+40) /sDW), sH*((posY+5) /sDH), sW*((width-45) /sDW), sH*((height-10) /sDH), Experience.setup.xpBackgroundColor)
    dxDrawRectangle(sW*((posX+40) /sDW), sH*((posY+5) /sDH), sW*((exp/requiredExp*(width-45)) /sDW), sH*((height-10) /sDH), Experience.setup.xpProgressColor)
    dxDrawText(exp.." / "..requiredExp, sW*((posX+40) /sDW), sH*((posY+5) /sDH), sW*((width+15) /sDW), sH*((posY+5+height-10) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_10, 'center', 'center')
end

function Experience.start()
    width, height = 250, 25
    posX, posY = 20, sDH-height-10

    Experience.visible = true
end