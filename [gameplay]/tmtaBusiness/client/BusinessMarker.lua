BusinessMarker = {}

local sW, sH = guiGetScreenSize()

local MARKER_OFFSET = 1.5
local MARKER_WIDTH = 250
local MARKER_HEIGHT = 200
local MARKER_MAX_DISTANCE = 40
local MARKER_SCALE = 5.8

addEventHandler("onClientRender", root, 
    function()
        if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
            return
        end

        local cX, cY, cZ = getCameraMatrix()
        for marker, data in pairs(Business.getStreamedAll()) do
            local x, y, z = getElementPosition(marker)
            local posX, posY = getScreenFromWorldPosition(x, y, z + MARKER_OFFSET)
            if posX then
                local distance = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
                if distance < MARKER_MAX_DISTANCE then
                    if isLineOfSightClear(cX, cY, cZ, x, y, z, true, true, false, true, false, true, false, marker) then
                        local scale = 1 / distance * MARKER_SCALE
                        local width = MARKER_WIDTH * scale
                        local height = MARKER_HEIGHT * scale
                        local nx, ny = posX - width / 2, posY - height / 2

                        local offsetY = 0
                        dxDrawText3D('Бизнес #f2ab12#'..data.businessId, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RR_14, 'center', 'top')

                        -- Статус
                        local status = 'Свободен'
                        local statusColor = tocolor(0, 255, 0, 255)
                        if data.owner then
                            status = 'Занят'
                            statusColor = tocolor(0, 153, 255, 255)
                        end
                        offsetY = offsetY + 15
                        dxDrawText3D(status, nx, ny + offsetY*scale, nx + width, ny + height, statusColor, scale, Utils.fonts.DX_Elowen_22, 'center', 'top')

                        -- Название
					    local propertyClassStr = 'Название: #f2ab12'..data.name
					    offsetY = offsetY + 45
					    dxDrawText3D(propertyClassStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'center', 'top')

                        -- Владелец
                        local businessOwner = data.owner or 'государство'
                        local businessOwnerStr = 'Владелец: #f2ab12'..businessOwner
                        offsetY = offsetY + 25
                        dxDrawText3D(businessOwnerStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'center', 'top')
                        
                        -- Стоимость
                        if (not data.owner) then
                            local titleStr = 'Цена:'
                            local priceStr = data.formattedPrice
                            
                            local textTittleWidth = dxGetTextWidth(titleStr, 1, Utils.fonts.DX_RB_12) -- ширина текста
                            local textTittleWidth, textTitleHeight = dxGetTextSize(titleStr, textTittleWidth, 1, Utils.fonts.DX_RB_12, true)
                            local textPriceWidth = dxGetTextWidth(priceStr, 1, Utils.fonts.DX_RB_12) -- ширина текста
                            local iconW, iconH = dxGetMaterialSize(Utils.textures.moneyIcon) -- размеры иконки
                            local iconPadding = 10 -- отступ между текстом и иконкой
                            local textPadding = 10
                            local heightFrame = textTitleHeight
                            local widthFrame = textTittleWidth+textPadding+iconW+iconPadding+textPriceWidth -- общая длина
                            offsetY = offsetY + 35

                            local dxPosX, dxPosY, dxW, dxH = 0, offsetY, width, offsetY+heightFrame
                            local dxPosX = dxPosX+(width-(widthFrame*scale))/2
                            dxDrawText3D(titleStr, nx + dxPosX, ny+(dxPosY)*scale, nx+dxW, ny+(dxH)*scale, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'left', 'center')
                            local offsetX = textTittleWidth+textPadding
                            dxSetTextureEdge(Utils.textures.moneyIcon, "clamp")
                            dxDrawImage(nx + dxPosX + (offsetX)*scale, ny + (dxPosY+((heightFrame-iconH) /2))*scale, iconW*scale, iconH*scale, Utils.textures.moneyIcon)
                            local offsetX = offsetX+iconW+iconPadding
                            dxDrawText3D('#f2ab12'..priceStr, nx + dxPosX + (offsetX)*scale, ny+(dxPosY)*scale, nx+dxW, ny+(dxH)*scale, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'left', 'center')
                        end
                    end
                end
            end
        end
    end
)

function BusinessMarker.getData(marker)
    if (not marker:getData('isBusinessMarker')) then
        return
    end

    local businessData = marker:getData('businessData')
    businessData.formattedPrice = tostring(exports.tmtaUtils:formatMoney(businessData.price))

    return businessData
end

addEventHandler("onClientMarkerHit", resourceRoot, 
    function(player, matchingDimension)
        local marker = source
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

        if marker:getData('isBusinessMarker') then
            local businessData = BusinessMarker.getData(marker)
            BusinessGUI.openWindow(businessData)
		end
    end
)

addEventHandler("onClientMarkerLeave", resourceRoot, 
    function(player, matchingDimension)
        local marker = source
		if (getElementType(player) ~= "player" or player ~= localPlayer or not matchingDimension) then 
            return 
        end

		if marker:getData('isBusinessMarker') then
			BusinessGUI.closeWindow()
		end
	end
)
