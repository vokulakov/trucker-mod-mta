RevenueService = {}

addEventHandler("onClientMarkerHit", resourceRoot, 
    function(player, matchingDimension)
        local marker = source
        if not marker:getData('isRevenueServiceMarker') then
            return
        end

        if getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player) then 
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

--TODO:: вынести в отдельную систему с 3D текстом над пикапами
local STREAMED_MARKERS = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center", _, _, _, true)
end

addEventHandler("onClientRender", root, 
    function()
        if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
            return
        end
        local cx, cy, cz = getCameraMatrix()
        for _, pickup in pairs(STREAMED_MARKERS) do
            local xP, yP, zP = getElementPosition(pickup.pickup)
            if (isLineOfSightClear(xP, yP, zP, cx, cy, cz, true, true, false, false, true, true, true, nil)) then
                local x, y = getScreenFromWorldPosition(xP, yP, zP + pickup.z)
                if x and y then
                    local distance = getDistanceBetweenPoints3D(cx, cy, cz, xP, yP, zP)
                    if distance < 65 then
                        dxDrawCustomText(pickup.text, x, y, x, y, tocolor(255, 255, 0), 1)
                    end
                end
            end
        end
    end
)

addEventHandler("onClientElementStreamIn", root, 
    function()
        if getElementType(source) == "marker" and source:getData('isRevenueServiceMarker') and not STREAMED_MARKERS[source] then
            STREAMED_MARKERS[source] = { pickup = source, text = 'Налоговая служба', z = 1.5 }
        end
    end
)

addEventHandler("onClientElementStreamOut", root, 
    function()
        if getElementType(source) == "marker" and STREAMED_MARKERS[source] then
            STREAMED_MARKERS[source] = nil
        end
    end
)

function RevenueService.registerBusinessEntity()
    return triggerServerEvent('tmtaRevenueService.onPlayerRegisterBusinessEntity', resourceRoot)
end

function RevenueService.payTax(taxType, taxAmount)
    return triggerServerEvent('tmtaRevenueService.onPlayerPayTax', resourceRoot, taxType, taxAmount)
end