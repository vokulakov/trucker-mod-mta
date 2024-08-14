HouseMarker = {}

local sW, sH = guiGetScreenSize()
local StreamingHouses = {}

local Textures = {
	moneyIcon = exports.tmtaTextures:createTexture('i_money'),
}

local HOUSE_DEFAULT_OFFSET = 1.2
local HOUSE_WIDTH = 250
local HOUSE_HEIGHT = 200
local HOUSE_MAX_DISTANCE = 40
local HOUSE_SCALE = 5.8

addEventHandler("onClientRender", root, 
	function()
		if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
			return
		end
		
		local cX, cY, cZ = getCameraMatrix()
		for houseMarker, houseData in pairs(StreamingHouses) do
			local x, y, z = getElementPosition(houseMarker)
			local HOUSE_OFFSET = houseData.owner and HOUSE_DEFAULT_OFFSET or 1.5
			local posX, posY = getScreenFromWorldPosition(x, y, z + HOUSE_OFFSET)
			if posX then
				local distance = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
				if distance < HOUSE_MAX_DISTANCE then
					if isLineOfSightClear(cX, cY, cZ, x, y, z, true, true, false, true, false, true, false, houseMarker) then
						local scale = 1 / distance * HOUSE_SCALE
						local width = HOUSE_WIDTH * scale
						local height = HOUSE_HEIGHT * scale
						local nx, ny = posX - width / 2, posY - height / 2
		
						--dxDrawRectangle(nx, ny, width, height, tocolor(0, 0, 0, 255))

						local offsetY = 0
						dxDrawText3D('Дом #f2ab12№'..houseData.houseId, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RR_14, 'center', 'top')

						-- Статус
						local status = 'Свободен'
						local statusColor = tocolor(0, 255, 0, 255)
						if houseData.owner then
							status = 'Занят'
							statusColor = tocolor(0, 153, 255, 255)
						end
						offsetY = offsetY + 15
						dxDrawText3D(status, nx, ny + offsetY*scale, nx + width, ny + height, statusColor, scale, Utils.fonts.DX_Elowen_22, 'center', 'top')

						-- Владелец
						local houseOwner = houseData.owner or 'государство'
						local houseOwnerStrt = 'Владелец: #f2ab12'..houseOwner
						offsetY = offsetY + 45
						dxDrawText3D(houseOwnerStrt, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'center', 'top')

						-- Класс имущества
						local propertyClassStr = 'Класс: #f2ab12'..houseData.class
						offsetY = offsetY + 25
						dxDrawText3D(propertyClassStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'center', 'top')

						-- Парковочные места
						if (not houseData.owner) then
							local parkingSpacesStr = 'Парковочных мест: #f2ab12'..houseData.parkingSpaces
							offsetY = offsetY + 25
							dxDrawText3D(parkingSpacesStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'center', 'top')
							
							-- Цена
							local titleStr = 'Цена:'
							local priceStr = houseData.formattedPrice
							
							local textTittleWidth = dxGetTextWidth(titleStr, 1, Utils.fonts.DX_RB_12) -- ширина текста
							local textTittleWidth, textTitleHeight = dxGetTextSize(titleStr, textTittleWidth, 1, Utils.fonts.DX_RB_12, true)
							local textPriceWidth = dxGetTextWidth(priceStr, 1, Utils.fonts.DX_RB_12) -- ширина текста
							local iconW, iconH = dxGetMaterialSize(Textures.moneyIcon) -- размеры иконки
							local iconPadding = 10 -- отступ между текстом и иконкой
							local textPadding = 10
							local heightFrame = textTitleHeight
							local widthFrame = textTittleWidth+textPadding+iconW+iconPadding+textPriceWidth -- общая длина
							offsetY = offsetY + 35

							local dxPosX, dxPosY, dxW, dxH = 0, offsetY, width, offsetY+heightFrame
							local dxPosX = dxPosX+(width-(widthFrame*scale))/2
							dxDrawText3D(titleStr, nx + dxPosX, ny+(dxPosY)*scale, nx+dxW, ny+(dxH)*scale, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'left', 'center')
							local offsetX = textTittleWidth+textPadding
							dxSetTextureEdge(Textures.moneyIcon, "clamp")
							dxDrawImage(nx + dxPosX + (offsetX)*scale, ny + (dxPosY+((heightFrame-iconH) /2))*scale, iconW*scale, iconH*scale, Textures.moneyIcon)
							local offsetX = offsetX+iconW+iconPadding
							dxDrawText3D('#f2ab12'..priceStr, nx + dxPosX + (offsetX)*scale, ny+(dxPosY)*scale, nx+dxW, ny+(dxH)*scale, tocolor(255, 255, 255, 255), scale, Utils.fonts.DX_RB_12, 'left', 'center')
						end
					end 
				end
			end
		end
	end
)

function HouseMarker.onStreamIn(houseMarker)
	if getElementType(houseMarker) ~= "marker" or not houseMarker:getData('isHouseMarker') then
		return
	end
	if not StreamingHouses[houseMarker] then
		local houseData = houseMarker:getData('houseData')
		if not houseData then
			return
		end
		houseData.houseId = tostring(houseData.houseId)
		houseData.formattedPrice = tostring(exports.tmtaUtils:formatMoney(houseData.price))
		
		local blipColor = houseData.owner and tocolor(0, 153, 255, 255) or tocolor(0, 255, 0, 255)
		HouseBlip.add(houseMarker, houseData.houseId, blipColor)

		StreamingHouses[houseMarker] = houseData
	end
end

function HouseMarker.onStremOut()
    local houseMarker = source
    if getElementType(houseMarker) ~= "marker" or not houseMarker:getData('isHouseMarker') then
        return
    end
    if StreamingHouses[houseMarker] then
        StreamingHouses[houseMarker] = nil
		HouseBlip.remove(houseMarker)
    end
end

addEventHandler("onClientElementStreamIn", root, 
	function()
		HouseMarker.onStreamIn(source)
	end
)

addEventHandler("onClientElementStreamOut", root, HouseMarker.onStremOut)
addEventHandler("onClientElementDestroy", root, HouseMarker.onStremOut)

addEventHandler("onClientElementDataChange", root, 
	function(dataName)
		local houseMarker = source
		if getElementType(houseMarker) ~= "marker" or dataName ~= 'houseData' then
			return
		end
		HouseMarker.onStreamIn(houseMarker)
	end
)

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
		
        -- Вход в дом
        if marker:getData('isHouseMarker') then
            local houseData = marker:getData('houseData')
		    houseData.houseId = tostring(houseData.houseId)
		    houseData.formattedPrice = tostring(exports.tmtaUtils:formatMoney(houseData.price))
			houseData.formattedPropertyTax = tostring(exports.tmtaUtils:formatMoney(houseData.propertyTax))
            HouseGUI.openWindow(houseData)
        elseif marker:getData('isHouseExitMarker') then
            local houseId = marker:getData('houseId')
            House.exit(houseId)
        end

    end
)

function HouseMarker.init()
	for _, houseMarker in pairs(getElementsByType('marker', resourceRoot)) do
		HouseMarker.onStreamIn(houseMarker)
	end
end