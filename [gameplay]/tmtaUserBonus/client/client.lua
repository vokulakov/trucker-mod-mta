local GUI = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()
local width, height = 550, 320

local Fonts = {
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),

    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
    ['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),
    ['RB_13'] = exports.tmtaFonts:createFontGUI('RobotoBold', 13),
}

function GUI.renderWindow()
    GUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8

    --
    local offsetPosY = 30

    local _offsetPosY = (offsetPosY + 30 + 10)-64/1.5-5
    local iconLogo = exports.tmtaTextures:createStaticImage(sW*((0)/sDW), sH*((_offsetPosY)/sDH), sW*((64/1.5)/sDW), sH*((64/1.5)/sDH), 'logo_tmta_64', false, GUI.wnd)
    iconLogo.enabled = false

    local lblTitle = guiCreateLabel(sW*((64/1.5+15)/sDW), sH*(offsetPosY/sDH), sW*(width/sDW), sH*(40/sDH), "TRUCKER × MTA", false, GUI.wnd)
    guiSetFont(lblTitle, Fonts.RB_10)
    lblTitle.enabled = false

    local lblSubTitle = guiCreateLabel(sW*((64/1.5+15)/sDW), sH*((offsetPosY+15)/sDH), sW*(width/sDW), sH*(40/sDH), "Пожалуй лучший дальнобойный сервер!", false, GUI.wnd)
    guiSetFont(lblSubTitle, Fonts.RR_10)
    guiLabelSetColor(lblSubTitle, 155, 155, 155)
    lblSubTitle.enabled = false
    
    local offsetPosX = width-35
    GUI.btnClose = guiCreateButton(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, Fonts.RB_10)
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, GUI.closeWindow, false)

    offsetPosY = offsetPosY + 30 + 10
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local title = string.format('Добро пожаловать, %s!', localPlayer:getData('nickname'))
    offsetPosY = offsetPosY + 20
    GUI.lblInfo = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), title, false, GUI.wnd)
    guiLabelSetHorizontalAlign(GUI.lblInfo, "center", false)
    guiSetFont(GUI.lblInfo, Fonts.RB_11)
    guiLabelSetColor(GUI.lblInfo, 242, 171, 18)
    GUI.lblInfo.enabled = false
    
    local message = [[ 
    Рады тебя видеть на дальнобойном сервере, ёкарный бабай!
    Запах топлива и жжёной резины, километры дорог и тонны грузов ждут тебя.
    Доставляй грузы, прокачивай опыт и открывай новые возможности.

    А чтобы твой путь был легче, мы дарим тебе небольшой бонус.
    ]]

    offsetPosY = offsetPosY + 40
    GUI.lblInfo = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(200/sDH), message, false, GUI.wnd)
    guiLabelSetHorizontalAlign(GUI.lblInfo, "center", true)
    guiSetFont(GUI.lblInfo, Fonts.RR_10)
    GUI.lblInfo.enabled = false

    -- 
    offsetPosY = height - 45 - 15
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = height - 45
    GUI.btnTakeBonus = guiCreateButton(0, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*(40/sDH), 'Забрать бонус', false, GUI.wnd)
    guiSetProperty(GUI.btnTakeBonus, "NormalTextColour", "FF01D51A")
    guiSetFont(GUI.btnTakeBonus, Fonts.RR_11)
    addEventHandler("onClientGUIClick", GUI.btnTakeBonus, GUI.onPlayerClickBtnTakeBonus, false)
end

function GUI.openWindow()
    if isElement(GUI.wnd) then
        return
    end
    GUI.renderWindow()
    showCursor(true)
    showChat(false)
    toggleAllControls(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function GUI.closeWindow()
    GUI.wnd.visible = false
    setTimer(destroyElement, 100, 1, GUI.wnd)
    showCursor(false)
    showChat(true)
    toggleAllControls(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end

function GUI.onPlayerClickBtnTakeBonus()
    GUI.closeWindow()
    triggerServerEvent('tmtaUserBonus.onPlayerTakeBonusRequest', resourceRoot)
end

addEvent("tmtaUserBonus.showNotice", true)
addEventHandler("tmtaUserBonus.showNotice", resourceRoot, 
    function(typeNotice, typeMessage)
        local posX, posY = sW*((sDW-400)/2 /sDW), sH*((sDH-150)/sDH), sW*(400/sDW)
        local width = sW*(400 /sDW)
        exports.tmtaGUI:createNotice(posX, posY, width, typeNotice, typeMessage, true)
    end
)


addEventHandler('onClientResourceStart', resourceRoot,
    function()

        local txd = engineLoadTXD('assets/fedor.txd')
        engineImportTXD(txd, 43)
    
        local dff = engineLoadDFF('assets/fedor_winter.dff', 43)
        engineReplaceModel(dff, 43)

        exports.common_peds:createWorldPed({
            position = {
                coords = { 297, -2473, 7.946875, 0 },
                int = 0,
                dim = 0,
            },
            attachToLocalPlayer = true,
            text = '#fcba03Фёдор Иванович', 
            model = 43,
            animations = {
                steps = 7,
                time = 10000,
                cycles = {
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"RAPPING", "RAP_A_Loop"},
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"COP_AMBIENT", "Coplook_think", 0, false, false, false, false},
                    {"DEALER", "DEALER_IDLE_01", -1, false, false, false, false},
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"COP_AMBIENT", "Coplook_think", 0, false, false, false, false}
                }
            }
        })

        local position = { x = 329.419220, y = -2482.813721, z = 7.946875 }
        local marker = createMarker(position.x, position.y, position.z-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
        local pickup = createPickup(position.x+0.05, position.y-0.05, position.z, 3, 1239, 500)

        addEventHandler("onClientMarkerHit", marker, 
            function(player, matchingDimension)
                local marker = source
                if (getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player)) then 
                    return 
                end

                local verticalDistance = player.position.z - source.position.z
                if verticalDistance > 5 or verticalDistance < -1 then
                    return
                end

                if not matchingDimension then
                    return
                end

                GUI.openWindow()
            end
        )
    end
)