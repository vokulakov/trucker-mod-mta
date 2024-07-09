Scooter = {}
Scooter.markers = {}

local sX, sY = guiGetScreenSize()
local GUI = {}

function Scooter.createWindow()
    GUI.window = guiCreateWindow(sX/2-300/2, sY/2-160/2, 300, 160, 'Добро пожаловать!', false)
    GUI.window.alpha = 0.9
	guiWindowSetSizable(GUI.window, false)

	GUI.label_welcome = guiCreateLabel(0, 25, 300, 36, 'Здесь вы можете арендовать скутер', false, GUI.window)
	guiLabelSetHorizontalAlign(GUI.label_welcome, "center")
	guiLabelSetColor(GUI.label_welcome, 10, 183, 220)

	GUI.label_hp = guiCreateLabel(10, 50, 300, 36, 'Время аренды: ', false, GUI.window)
	GUI.label_hp_info = guiCreateLabel(100, 50, 300, 36, Settings.timeArenda..' минут', false, GUI.window)
	guiLabelSetColor(GUI.label_hp_info, 10, 183, 220)

	GUI.label_price = guiCreateLabel(10, 70, 300, 36, 'Стоимость аренды:', false, GUI.window)
	GUI.label_price_info = guiCreateLabel(125, 70, 300, 36, convertNumber(Settings.moneyArenda)..' ₽', false, GUI.window)
	guiLabelSetColor(GUI.label_price_info, 0, 255, 0)

	GUI.b_pay = guiCreateButton(0, 100, 300, 25, 'Арендовать', false, GUI.window)
	guiSetFont(GUI.b_pay, "default-bold-small")
	guiSetProperty(GUI.b_pay, "NormalTextColour", "FF0ab7dc")
    GUI.b_pay:setData('tmtaSounds.UI', 'ui_select')

    addEventHandler("onClientGUIClick", GUI.b_pay, Scooter.onPlayerRent, false)

	GUI.b_close = guiCreateButton(0, 130, 300, 20, 'Закрыть', false, GUI.window)
	guiSetFont(GUI.b_close, "default-bold-small")
	guiSetProperty(GUI.b_close, "NormalTextColour", "FFCE070B")
    GUI.b_close:setData('tmtaSounds.UI', 'ui_back')

    addEventHandler("onClientGUIClick", GUI.b_close, Scooter.closeWindow, false)
end

function Scooter.openWindow()
    if isElement(GUI.window) then 
        return 
    end

	exports.tmtaUI:setPlayerComponentVisible("all", false)
	exports.tmtaUI:setPlayerComponentVisible("notifications", true)
	exports.tmtaUI:setPlayerBlurScreen(true)
    showChat(false)

    Scooter.createWindow()
    showCursor(true)
end

function Scooter.closeWindow()
    if not isElement(GUI.window) then 
        return 
    end

	exports.tmtaUI:setPlayerComponentVisible("all", true)
	exports.tmtaUI:setPlayerBlurScreen(false)
    showCursor(false)
    showChat(true)
	destroyElement(GUI.window) 
end

function Scooter.onPlayerRent()
    triggerServerEvent ("arendaMoped", resourceRoot)
    Scooter.closeWindow()
end

local function hitMarker(el)
	local verticalDistance = el.position.z - source.position.z
	if (verticalDistance > 5 or verticalDistance < -1) then
		return
	end

	if getElementType(el) == "player" and el == localPlayer then
		if not isPedInVehicle(el) then
			Scooter.openWindow()
		end
	end
end

local function leaveMarker(el)
	if getElementType(el) == "player" and el == localPlayer then
		if not isPedInVehicle(el) then
			Scooter.closeWindow()
		end
	end
end

function Scooter.createMarker()
    for i, v in ipairs (Settings.markers) do
		local marker = createMarker(v[1], v[2], v[3] - 1, "cylinder", 1.5, 255, 100, 50, 50)
		marker.alpha = 0

		exports.tmtaBlip:createBlipAttachedTo(
            marker, 
            'blipScooterRent',
            {name='Аренда скутера'},
			tocolor(255, 153, 36, 255)
        )
		
        exports.common_peds:createWorldPed({
			position = {
				coords = { v[1], v[2], v[3] },
				int = 0,
				dim = 0,
			},

			attachToLocalPlayer = true,
			text = "Аренда скутера",

			model = 19,

            animations = {
                steps = 6,
                time = 10000,
                cycles = {
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"DANCING", "dnce_M_d", -1, false, false, false, false},
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"DEALER", "DEALER_IDLE_01", -1, false, false, false, false},
                    {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                    {"DANCING", "dnce_M_b", -1, false, false, false, false}
                }
            }

		})

        Scooter.markers[marker] = true 
        
		addEventHandler("onClientMarkerHit", marker, hitMarker)
		addEventHandler("onClientMarkerLeave", marker, leaveMarker)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    Scooter.createMarker()
end)