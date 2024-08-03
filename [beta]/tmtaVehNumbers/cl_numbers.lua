local scx,scy = guiGetScreenSize()
local px = 1
local font20 = guiCreateFont( "files/font.ttf", 15*px )
local numberFont = dxCreateFont("files/rn.ttf", 45)

local function isCursorOverRectangle(x,y,w,h)
	if isCursorShowing() then
		local mx,my = getCursorPosition() -- relative
		local cursorx,cursory = mx*scx,my*scy
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		end
	end
return false
end

local plateShaders = {}



-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local STREAMED_TEXT = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, function()
	if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
        return
    end

	local cx, cy, cz = getCameraMatrix()
	for _, pickup in pairs(STREAMED_TEXT) do
		local xP, yP, zP = getElementPosition(pickup.pickup)
		local x, y = getScreenFromWorldPosition(xP, yP, zP + pickup.z)
		if x and y then
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, xP, yP, zP)
			if distance < 65 then
				dxDrawCustomText(pickup.text, x, y, x, y, tocolor(255, 255, 0), 1)
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "pickup" then
		if getElementData(source, "arst_numbers.messageNum") then
			STREAMED_TEXT[source] = { pickup = source, text = 'Установка номерных знаков', z = 1 }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "arst_numbers.messageNum") then
		STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

for k,v in pairs(markerPositions) do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",2, 100, 160, 255, 150)

	exports.tmtaBlip:createAttachedTo(
        marker, 
        'blipNumberPlate',
        'Регистрация транспорта',
        tocolor(0, 0, 0, 255),
		blipData[2]
    )

	local marker1 = createPickup(v[1],v[2],v[3]+1, 3, 1318, 50)
	setElementData(marker,"nomera",true)
	setElementData(marker1, "arst_numbers.messageNum", true)
end

local numberWindow = nil
local currentNumberType = false
local oldNumberType = false

addEventHandler("onClientMarkerHit",root,function(ply)
	if getElementData(source,"nomera") and ply == localPlayer then
		if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
			initNewNumberWindow()
		end
	end
end)


local sizeX,sizeY = 1000*px,500*px
local posX,posY = scx/2-sizeX/2+200*px, scy/2-sizeY/2
local windowShown = false
local window = nil
local elements = {}
local oldNumber = dxCreateTexture("number/number_c.png")
local newNumber = dxCreateTexture("number/number_c.png")
local priceTab = {}
local priceNum = 100000
local adminState = false
local motoState = false
local numberText = ""

function initNewNumberWindow(admin)
	if windowShown then
		guiSetInputEnabled(false)
		windowShown = false
		removeEventHandler("onClientRender",root,drawNumberWindow)
		for k,v in pairs(elements) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		elements = {}
		showCursor(false)
	else
		local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
			oldNumber = getNumbersTexture(getElementData(veh,"numberType"),getElementData(veh,"number:plate")) or dxCreateTexture("number/number_c.png")
			oldNumberType = getElementData(veh,"numberType")
			motoState = isMoto(veh)
		end
		newNumber = dxCreateTexture("number/number_c.png")
		windowShown = true
		showCursor(true)
		adminState = admin
		elements.edit = guiCreateEdit(posX+340*px,posY+sizeY/2+80*px,240*px,50*px,"Введите номер",false)
		guiSetFont(elements.edit,font20)
		guiEditSetReadOnly( elements.edit, true )
		guiSetInputEnabled( true )
		addEventHandler("onClientRender",root,drawNumberWindow)
		priceTab = {}
		addEventHandler("onClientGUIChanged",elements.edit,function()
			local text = guiGetText(elements.edit)
			text = convertSymbols(text)
			if isCorrectNumber(currentNumberType,text) then
				newNumber = getNumbersTexture(currentNumberType,text)
				priceTab, priceNum = getNumberPriceTable(currentNumberType,text)
				numberText = text
			else
				newNumber = dxCreateTexture("number/number_"..currentNumberType..".png")
				numberText = "-"
				--priceTab, priceNum = getNumberPriceTable(currentNumberType,text)
				priceTab = {}
				priceNum = ""
			end
		end)
	end
end
addEvent("initNewNumberWindow", true)
addEventHandler("initNewNumberWindow", root, initNewNumberWindow)

local sectionSize = 420*px/#numberTypes

function drawNumberWindow()
	if windowShown then
	dxDrawRectangle(posX,posY,250*px,sizeY,tocolor(0,0,0,230))
	dxDrawRectangle(posX+260*px,posY,400*px,sizeY/2-10*px,tocolor(0,0,0,230))
	dxDrawText("Ваш старый номер",posX+260*px,posY,posX+260*px+400*px,posY+50*px,tocolor(255,255,255),2*px,"default-bold","center","center")
	if oldNumber then
		if oldNumberType == "moto" or oldNumberType == "motop" then
			dxDrawImage(posX+410*px,posY+45*px,100*px,64*px,oldNumber)
		else
			dxDrawImage(posX+330*px,posY+45*px,256*px,64*px,oldNumber)
		end
	end
	dxDrawText("Ваш новый номер",posX+260*px,posY+100*px,posX+260*px+400*px,posY+150*px,tocolor(255,255,255),2*px,"default-bold","center","center")
	if newNumber then
		if currentNumberType == "moto" or currentNumberType == "motop" then
			dxDrawImage(posX+410*px,posY+150*px,100*px,64*px,newNumber)
		else
			dxDrawImage(posX+330*px,posY+150*px,256*px,64*px,newNumber)
		end
	end

	dxDrawRectangle(posX+260*px,posY+sizeY/2,400*px,sizeY/2,tocolor(0,0,0,230))
	if getNumbersData(currentNumberType) then
		dxDrawText("Формат номера",posX+260*px,posY+260*px,posX+260*px+400*px,posY+280*px,tocolor(100,100,100),1*px,"default-bold","center","top")
		dxDrawText(getNumbersData(currentNumberType)[4],posX+260*px,posY+280*px,posX+260*px+400*px,posY+280*px,tocolor(150,150,155),2*px,"default-bold","center","top")
	end
	if priceTab and #priceTab >= 1 then
		dxDrawRectangle(posX+260*px,posY+sizeY+10*px,400*px,100*px,tocolor(0,0,0,230))
		local ty = 0
		for k,v in pairs(priceTab) do
			dxDrawText(v[1],posX+280*px,posY+sizeY+20*px+ty,posX+280*px+400*px,80*px,tocolor(200,100,100),1*px,"default-bold","center")
			ty = ty+20*px
		end
	end
	if numberText ~= "-" then
		if isCursorOverRectangle(posX+440*px,posY+430*px,200*px,50*px) then
			dxDrawRectangle(posX+440*px,posY+430*px,200*px,50*px,tocolor(0,200,0,230))
			if getKeyState("mouse1") then
				initNewNumberWindow()
				triggerServerEvent("buyNumberPlate",localPlayer,currentNumberType,numberText,priceNum)
			end
		else
			dxDrawRectangle(posX+440*px,posY+430*px,200*px,50*px,tocolor(0,120,0,230))
		end
	else
		dxDrawRectangle(posX+440*px,posY+430*px,200*px,50*px,tocolor(120,120,120,230))
	end
	dxDrawText("Купить\n"..convertNumber(priceNum).." руб",posX+440*px,posY+430*px,posX+640*px,posY+480*px,tocolor(255,255,255),1*px,"default-bold","center","center")
	if isCursorOverRectangle(posX+280*px,posY+430*px,150*px,50*px) then
		dxDrawRectangle(posX+280*px,posY+430*px,150*px,50*px,tocolor(200,0,0,230))
		if getKeyState("mouse1") then
			initNewNumberWindow()
		end
	else
		dxDrawRectangle(posX+280*px,posY+430*px,150*px,50*px,tocolor(120,0,0,230))
	end
	dxDrawText("Отмена",posX+280*px,posY+430*px,posX+430*px,posY+480*px,tocolor(255,255,255),1*px,"default-bold","center","center")

	local typeY = 50*px
	dxDrawRectangle(posX,posY,250*px,40*px,tocolor(50,50,100,230))
	dxDrawText("Выберите тип",posX,posY,posX+250*px,posY+typeY,tocolor(255,255,255),1*px,"default-bold","center","center")

	for k,v in pairs(numberTypes) do
		if v[3] or adminState == true then
			if motoState then
				if v[1] == "moto" or v[1] == "motop" then
					if isCursorOverRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px) or currentNumberType == v[1] then
						dxDrawRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px,tocolor(100,100,150,230))
						dxDrawText(v[2],posX,posY+typeY,posX+250*px,posY+typeY+sectionSize*px,tocolor(255,255,255),1*px,"default-bold","center","center")
						if getKeyState("mouse1") then
							currentNumberType = v[1]
							if isElement(elements.edit) then
								guiSetText(elements.edit,"")
								guiEditSetReadOnly(elements.edit, false)
							end
							newNumber = dxCreateTexture("number/number_"..currentNumberType..".png")
						end
						typeY=typeY+sectionSize+1*px
					else
						dxDrawRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px,tocolor(100,100,100,230))
						dxDrawText(v[2],posX,posY+typeY,posX+250*px,posY+typeY+sectionSize*px,tocolor(255,255,255),1*px,"default-bold","center","center")
						typeY=typeY+sectionSize+1*px
					end
				end
			else
				if v[1] ~= "moto" and v[1] ~= "motop" then
					if isCursorOverRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px) or currentNumberType == v[1] then
						dxDrawRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px,tocolor(100,100,150,230))
						dxDrawText(v[2],posX,posY+typeY,posX+250*px,posY+typeY+sectionSize*px,tocolor(255,255,255),1*px,"default-bold","center","center")
						if getKeyState("mouse1") then
							currentNumberType = v[1]
							if isElement(elements.edit) then
								guiSetText(elements.edit,"")
								guiEditSetReadOnly(elements.edit, false)
							end
							newNumber = dxCreateTexture("number/number_"..currentNumberType..".png")
						end
						typeY=typeY+sectionSize+1*px
					else
						dxDrawRectangle(posX+5*px,posY+typeY,240*px,sectionSize*px,tocolor(100,100,100,230))
						dxDrawText(v[2],posX,posY+typeY,posX+250*px,posY+typeY+sectionSize*px,tocolor(255,255,255),1*px,"default-bold","center","center")
						typeY=typeY+sectionSize+1*px
					end
				end
			end
		end
		--dxDrawText( string text, float left, float top [, float right=left, float bottom=top, int color=white,                   float scale=1, mixed font="default", string alignX="left", string alignY="top",                  bool clip=false, bool wordBreak=false, bool postGUI=false,                  bool colorCoded=false, bool subPixelPositioning=false,                   float fRotation=0, float fRotationCenterX=0, float fRotationCenterY=0 ] )
	end
end
end
--initNewNumberWindow(true)


-- русские номера
local textOffset = 12*2
local textWidth = 350
local numberHeight = 128

local regionOffset = 197*2
local regionWidth = 47*2
local regionHeight = 47*2

function russionNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	-- 350
	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%a"), 1, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%d%d%d" ), 1, numberFont )
	w[3] = dxGetTextWidth(string.match(text, "%a%a" ), 1, numberFont )
	local p = {}

	p[1] = 320/2-w[2]/2-w[1]-10
	p[2] = 320/2-w[2]/2
	p[3] = 320/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_ru.png") )
	dxDrawText(string.match(text, "^%a" ), p[1], 0, p[2], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	dxDrawText(string.match(text, "%d%d%d" ), 0, 5, 320, numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	dxDrawText(string.match(text, "%a%a" ), p[3], 0, p[3]+w[3], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	dxDrawText(string.match(text, "%d+$" ), 377, 0, 512, 100, tocolor(0, 0, 0), 0.65, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

function motoNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(400, 350)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 400, 350, dxCreateTexture("number/number_moto.png") )
	dxDrawText(string.match(text, "^%d%d%d%d" ), 0, 30, 400, 350/2-20, tocolor(0, 0, 0), 1.2, numberFont, "center", "center")
	dxDrawText(string.match(text, "%a%a" ), 0,350/2,200,335, tocolor(0, 0, 0), 1.5, numberFont, "center", "center")
	dxDrawText(string.match(text, "%d+$" ), 200, 350/2, 400, 350, tocolor(0, 0, 0), 1.2, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

function motopNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(400, 350)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 400, 350, dxCreateTexture("number/number_motop.png") )
	dxDrawText(string.match(text, "^%d%d%d%d" ), 0, 30, 400, 350/2-20, tocolor(255, 255, 255), 1.2, numberFont, "center", "center")
	dxDrawText(string.match(text, "%a%a" ), 0,350/2,200,335, tocolor(255, 255, 255), 1.5, numberFont, "center", "center")
	dxDrawText(string.match(text, "%d+$" ), 200, 350/2, 400, 350, tocolor(255, 255, 255), 1.2, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

function russionNumberPlate2 ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%a"), 1, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%d%d%d" ), 1, numberFont )
	w[3] = dxGetTextWidth(string.match(text, "%a%a" ), 1, numberFont )
	local p = {}

	p[1] = 320/2-w[2]/2-w[1]-10
	p[2] = 320/2-w[2]/2
	p[3] = 320/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_ru2.png") )
		dxDrawText(string.match(text, "^%a" ), p[1], 0, p[2], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d%d%d" ), 0, 5, 320, numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%a%a" ), p[3], 0, p[3]+w[3], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d+$" ), 377, 0, 512, 100, tocolor(0, 0, 0), 0.65, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

function russionNumberPlate3 ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%a"), 1, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%d%d%d" ), 1, numberFont )
	w[3] = dxGetTextWidth(string.match(text, "%a%a" ), 1, numberFont )
	local p = {}

	p[1] = 320/2-w[2]/2-w[1]-10
	p[2] = 320/2-w[2]/2
	p[3] = 320/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_ru3.png") )
		dxDrawText(string.match(text, "^%a" ), p[1], 0, p[2], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d%d%d" ), 0, 5, 320, numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%a%a" ), p[3], 0, p[3]+w[3], numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- Транзитный номерной знак
local numberFont = dxCreateFont("files/rn.ttf", 26.5)

function transitNumberPlate(plate_number)
	local renderTarget = dxCreateRenderTarget(256, 64, true)

	local w_1 = string.match(plate_number, "^%a%a")
	local num = string.match(plate_number, "%d%d%d")
	local w_2 = string.sub(plate_number, 6, 6)

	local w = {}

	w[1] = dxGetTextWidth(w_1, 1, numberFont)
	w[2] = dxGetTextWidth(num, 1, numberFont)
	w[3] = dxGetTextWidth(w_2, 1, numberFont)

	local p = {}

	p[1] = w[1] + 8
	p[3] = 188-w[3]-4

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, -1, 256, 64, dxCreateTexture("number/number_tr.png"))
		dxDrawText(w_1, p[1]-w[1], 2, p[1], 64, tocolor(0, 0, 0), 1, numberFont, nil, "center")

		--dxDrawRectangle(p[1], 0, 1, 64, tocolor(255, 0, 0))
		dxDrawText(num, p[1], 2, p[3], 64, tocolor(0, 0, 0), 1, numberFont, "center", "center")

		--dxDrawRectangle(p[3], 0, 1, 64, tocolor(255, 0, 0))
		dxDrawText(w_2, p[3], 2, 188, 64, tocolor(0, 0, 0), 1, numberFont, nil, "center")
		
		dxDrawText(string.match(plate_number, "(%d%d+)$"), 188, -20, 254, 64, tocolor(0, 0, 0), 0.7, numberFont, "center", "center")
	dxSetRenderTarget()

	local texture = dxCreateTexture(dxGetTexturePixels(renderTarget))
	destroyElement(renderTarget)

	return texture
end 

-- Полицейские номера
function policeNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%a"), 1, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%d%d%d%d" ), 1, numberFont )
	w[3] = 0
	local p = {}

	p[1] = 440/2-w[2]/2-w[1]-30
	p[2] = 440/2-w[2]/2-30
	p[3] = 440/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_police.png") )
		dxDrawText(string.match(text, "^%a" ), p[1], 0, p[2], numberHeight, tocolor(255, 255, 255), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d%d%d%d" ), 0, 5, 440, numberHeight, tocolor(255, 255, 255), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d+$",6 ), 377, 0, 512, 100, tocolor(255, 255, 255), 0.65, numberFont, "center", "center")
	dxSetRenderTarget()
	--[[
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_police.png") )
	dxDrawText(string.match(text, "^%a" ), textOffset, 0, textOffset + textWidth, numberHeight, tocolor(255, 255, 255), 1, numberFont, "left", "center")
	dxDrawText(string.match(text, "%d%d%d%d" ), textOffset+70, 0, textOffset + textWidth, numberHeight, tocolor(255, 255, 255), 1, numberFont, "center", "center")
	dxDrawText(string.match(text, "%d+$",6 ), regionOffset, 0, regionOffset + regionWidth, regionHeight, tocolor(255, 255, 255), 0.65, numberFont, "center", "center")
	dxSetRenderTarget()
	]]--
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end


-- Черные номера
function blackNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)

	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%d%d%d%d"), 1, numberFont )

	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_black.png") )
	dxDrawText(string.match(text, "^%d%d%d%d" ), textOffset, 0, textOffset + textWidth, numberHeight, tocolor(255, 255, 255), 1, numberFont, "left", "center")
	dxDrawText(string.match(text, "%a%a" ), textOffset+w[1]+20, 0, textOffset + textWidth, numberHeight, tocolor(255, 255, 255), 1, numberFont, "left", "center")
	dxDrawText(string.match(text, "%d%d",6 ), 380, 0, 512, regionHeight, tocolor(255, 255, 255), 0.65, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- автобусные номера
local bus_textOffset = 24
local bus_textWidth = 164*2
local bus_numberHeight = 128

local bus_regionOffset = 197*2
local bus_regionWidth = 47*2
local bus_regionHeight = 47*2

function busNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_bus.png") )
	dxDrawText(string.match(text, "^%a%a" ), bus_textOffset+10, 0, bus_textOffset + bus_textWidth, bus_numberHeight, tocolor(0, 0, 0), 1, numberFont, "left", "center")
	dxDrawText(string.match(text, "%d%d%d" ), bus_textOffset+120, 0, bus_textOffset + bus_textWidth, bus_numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	--dxDrawText(string.match(text, "%a%a" ), bus_textOffset, 0, bus_textOffset + bus_textWidth + 10, bus_numberHeight, tocolor(0, 0, 0), 1, numberFont, "right", "center")
	dxDrawText(string.match(text, "%d+$",6 ), 380, 0, 512, bus_regionHeight, tocolor(0, 0, 0), 0.7, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- укринские номера

function ukraineNumberPlate ( text, vehicle)
	renderTarget = dxCreateRenderTarget(512, 128)

	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%a%a"), 1, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%d%d%d%d" ), 1, numberFont )
	w[3] = dxGetTextWidth(string.match(text, "%a%a",6 ), 1, numberFont )
	local p = {}

	p[1] = 560/2-w[2]/2-w[1]-10
	p[2] = 560/2-w[2]/2
	p[3] = 560/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_ua.png") )
		dxDrawText(string.match(text, "^%a%a" ), p[1], 0, p[2], numberHeight-15, tocolor(0, 0, 0), 1,1.2, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d%d%d%d" ), 100, 5, 460, numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
		dxDrawText(string.match(text, "%a%a",6 ), p[3], 0, p[3]+w[3], numberHeight-15, tocolor(0, 0, 0), 1,1.2, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- казахстанские номера

function kzNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)

	local w = {}
	w[1] = dxGetTextWidth(string.match(text,"^%d%d%d"), 0.9, numberFont )
	w[2] = dxGetTextWidth(string.match(text, "%a%a%a" ), 0.9, numberFont )
	w[3] = dxGetTextWidth(string.match(text, "%d%d",7 ), 1, numberFont )
	local p = {}

	p[1] = 610/2-w[2]/2-w[1]-20
	p[2] = 610/2-w[2]/2
	p[3] = 610/2+w[2]/2+10

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_kz.png") )
		dxDrawText(string.match(text, "^%d%d%d" ), p[1], 0, p[2], numberHeight, tocolor(0, 0, 0), 0.9, numberFont, "center", "center")
		dxDrawText(string.match(text, "%a%a%a" ), 100, 5, 510, numberHeight-10, tocolor(0, 0, 0), 0.9, numberFont, "center", "center")
		dxDrawText(string.match(text, "%d%d",7 ), 390, 0, 512, numberHeight, tocolor(0, 0, 0), 0.95, numberFont, "center", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- белорусские номера
local by_textOffset = 40*2
local by_textWidth = 256*2
local by_numberHeight = 64*2

function byNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(256*2, 64*2)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 256*2, 64*2, dxCreateTexture("number/number_by.png") )
	dxDrawText(string.gsub(text, "([ABEIKMHOPCTX][ABEIKMHOPCTX])[-](%d)$", "" ), by_textOffset+10, 0, by_textOffset + by_textWidth, by_numberHeight, tocolor(0, 0, 0), 1, 1, numberFont, "left", "center")
	dxDrawText(string.gsub(text, "^(%d%d%d%d)", "" ), by_textOffset, 0, by_textOffset + by_textWidth - 90, by_numberHeight, tocolor(0, 0, 0), 1, 1, numberFont, "right", "center")
		
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- азейборджанские номера
local arm_textOffset = 55*2
local arm_textWidth = 256*2
local arm_numberHeight = 64*2

function armNumberPlate ( text, vehicle)
	renderTarget = dxCreateRenderTarget(256*2, 64*2)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 256*2, 64*2, dxCreateTexture("number/number_arm.png") )
	--dxDrawText(string.gsub(text, "", "" ), arm_textOffset, 0, arm_textOffset + arm_textWidth, arm_numberHeight, tocolor(0, 0, 0), 3.4, 4.5, "default-bold", "left", "center")
	dxDrawText(string.match(text, "^%d%d" ), arm_textOffset, 0, arm_textOffset + arm_textWidth, arm_numberHeight, tocolor(0, 0, 0), 0.95, numberFont, "left", "center")
	dxDrawText(""..string.match(text, "%a%a" ), arm_textOffset+55*2, -22, arm_textOffset + arm_textWidth, arm_numberHeight, tocolor(0, 0, 0), 0.95, 1.2, numberFont, "left", "center")
	dxDrawText(""..string.match(text, "%d%d%d" ), arm_textOffset+115*2, 0, arm_textOffset + arm_textWidth, arm_numberHeight, tocolor(0, 0, 0), 0.95, numberFont, "left", "center")
	dxSetRenderTarget()
	
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

-- пустые номера
local c_textOffset = 0
local c_textWidth = 512
local c_numberHeight = 128

function clearNumberPlate ( text, vehicle )
	renderTarget = dxCreateRenderTarget(512, 128)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 512, 128, dxCreateTexture("number/number_c.png") )
	dxDrawText(text, c_textOffset, 0, c_textOffset + c_textWidth, c_numberHeight, tocolor(0, 0, 0), 5,6, "default-bold", "center", "center")
	dxSetRenderTarget()
	local texture = renderTarget
	--destroyElement(renderTarget)
	return texture
end

function getNumbersTexture(ntype,text)
	if ntype == "ru" then
		return russionNumberPlate ( text )
	elseif ntype == "ru2" then
		return russionNumberPlate2 ( text )
	elseif ntype == "ru3" then
		return russionNumberPlate3 ( text )
	elseif ntype == "tr" then
		return transitNumberPlate ( text )
	elseif ntype == "moto" then
		return motoNumberPlate ( text )
	elseif ntype == "motop" then
		return motopNumberPlate ( text )
	elseif ntype == "ua" then
		return ukraineNumberPlate ( text )
	elseif ntype == "arm" then
		return armNumberPlate ( text )
	elseif ntype == "by" then
		return byNumberPlate ( text )
	elseif ntype == "kz" then
		return kzNumberPlate ( text )
	elseif ntype == "police" then
		return policeNumberPlate ( text )
	elseif ntype == "black" then
		return blackNumberPlate ( text )
	elseif ntype == "bus" then
		return busNumberPlate ( text )
	elseif ntype == "c" then
		return clearNumberPlate ( text )
	end
end

function getTextureFromRenderTarget(renderTarget)
	return dxCreateTexture(dxGetTexturePixels(renderTarget))
end



local outlineShader = dxCreateShader( "files/texreplace.fx" )
local rt = dxCreateRenderTarget(1024, 256, true)

dxSetRenderTarget(rt)
	dxDrawImage(0, 0, 1024, 256, "files/ramka.png")
	dxDrawText(serverName,0,210,1024,256,tocolor(255, 255, 255, 255),2,"default-bold","center","center")
dxSetRenderTarget()

local tx = dxCreateTexture(dxGetTexturePixels(rt))
dxSetShaderValue( outlineShader, "gTexture", tx)

-- установка номера
function setVehicleNumberPlate ( vehicle )
	if not plateShaders[vehicle] then
		plateShaders[vehicle] = dxCreateShader("files/texreplace.fx")
	end
	if not getElementData (vehicle, "numberType" ) then return end
	engineApplyShaderToWorldTexture(plateShaders[vehicle], "nomer", vehicle)


	if outlineReplace then
		engineApplyShaderToWorldTexture(outlineShader, "ramka", vehicle)
		engineApplyShaderToWorldTexture(outlineShader, "ram", vehicle)
		engineApplyShaderToWorldTexture(outlineShader, "license_frame", vehicle)
	end

	local texture = nil
	if getElementData (vehicle, "numberType") == "ru" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = russionNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "ru2" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = russionNumberPlate2 ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "ru3" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = russionNumberPlate3 ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "tr" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = transitNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "moto" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = motoNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "motop" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = motopNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType") == "ua" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = ukraineNumberPlate ( getElementData (vehicle, "number:plate"), vehicle )
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "c" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = clearNumberPlate ( getElementData (vehicle, "number:plate"), vehicle )
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "kz" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = kzNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "arm" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = armNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "by" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = byNumberPlate ( getElementData (vehicle, "number:plate"), vehicle)
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "police" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = policeNumberPlate ( getElementData (vehicle, "number:plate"), vehicle )
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "black" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = blackNumberPlate ( getElementData (vehicle, "number:plate"), vehicle )
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	elseif getElementData (vehicle, "numberType" ) == "bus" then
		if not getElementData (vehicle, "number:plate" ) then return end
		texture = busNumberPlate ( getElementData (vehicle, "number:plate"), vehicle )
		dxSetShaderValue(plateShaders[vehicle], "gTexture", texture)
	end
end

addEventHandler( "onClientElementStreamIn", getRootElement(), function()
	if getElementType( source ) == "vehicle" then
	if not getElementData (source, "numberType" ) then return end
	setVehicleNumberPlate ( source )
	end
end)

addEventHandler ( "onClientElementDataChange", getRootElement(),
function ( dataName )
	if getElementType ( source ) == "vehicle" and dataName == "number:plate" then
		setVehicleNumberPlate ( source )
	end
end )

addEventHandler("onClientResourceStart",getResourceRootElement(),function()
	for k,v in pairs(getElementsByType("vehicle")) do
		if getElementData(v,"number:plate") then
			setVehicleNumberPlate ( v )
		end
	end
end)

convertableSymbolsTable =
{
	{'A','А'},
	{'B','В'},
	{'C','С'},
	{'Y','У'},
	{'O','О'},
	{'P','Р'},
	{'T','Т'},
	{'E','Е'},
	{'X','Х'},
	{'M','М'},
	{'H','Н'},
	{'K','К'},
}

function convertSymbols(text)
	local str = utf8.upper(text)
	for k,v in pairs(convertableSymbolsTable) do
		str = utf8.gsub(str,v[2],v[1])
	end
	return str
end

function convertNumber(amount)
	local formatted = amount
	while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
    if (k==0) then
     	break
    end
  	end
	return formatted
end

numberSymbols =
{
	'A',
	'B',
	'C',
	'Y',
	'O',
	'P',
	'T',
	'E',
	'X',
	'M',
	'H',
	'K'
}

function isCorrectNumber(type,str)
	str = string.upper(str)
	if type == "ru" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "ru2" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "ru3" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])$") and #str <= 6 then
			return true
		end
	elseif type == "tr" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "moto" then
		if string.find(str,"^(%d%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 8 then
			return true
		end
	elseif type == "motop" then
		if string.find(str,"^(%d%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 8 then
			return true
		end
	elseif type == "ua" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY])$" ) and #str <= 8 then
			return true
		end
	elseif type == "kz" then
		if string.find(str,"^(%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d)$" ) and #str <= 8 then
			return true
		end
	elseif type == "by" then
		if string.find(str,"^(%d%d%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX][-])(%d)$" ) and #str <= 10 then
			return true
		end
	elseif type == "arm" then
		if string.find(str,"^(%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d)$" ) and #str <= 10 then
			return true
		end
	elseif type == "police" then
		if string.find(str,"^([ABCEHKMOPTXY])(%d%d%d%d%d%d)$" ) and #str <= 8 then
			return true
		end
	elseif type == "bus" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d%d)$" ) and #str <= 7 then
			return true
		end
	elseif type == "black" then
		if string.find(str,"^(%d%d%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX])(%d%d)$" ) and #str <= 8 then
			return true
		end
	elseif type == "c" then
		if utf8.len(str) <= 14 then
			return true
		end
	end
end

function countSymbols(str)
	for k,v in pairs(numberSymbols) do
		local _, count = string.gsub(str, v, "")
		if count > 1 then
			return count
		end
	end
end

function countNumbers(str)
	for i = 0,9 do
		local _, count = string.gsub(str, tostring(i), "")
		if count > 1 then
			return count 
		end
	end
end

function getNumberPrice(str)
	local sum1 = countSymbols(str) or 0
	local sum2 = countNumbers(str) or 0
	--outputChatBox(sum1.." "..sum2)
	return counterPrices[sum1]+counterPrices[sum2]
end

function findCombo(str)
	for k,v in pairs(comboPrices) do
		local combo = string.find(str,v[1][1].."%d%d%d"..v[1][2]..v[1][3])
		if combo then
			return {v[1][1]..v[1][2]..v[1][3], v[2]}
		end
	end
end

function getNumberPriceTable(ntype,ntext)
	local symbols = countSymbols(ntext) or 0
	local digits = countNumbers(ntext) or 0
	if ntype == "ru" then
		digits = countNumbers(string.sub(ntext,2,5)) or 0
	end
	local combo = 0
	local totalprice = getNumbersData(ntype)[5]
	if ntype == "ru" or ntype == "ru2" or ntype == "ru3" then
		if findCombo(ntext) then
			combo = findCombo(ntext)
		end
	end
	local tab = {}
	if symbols >= 2 then
		table.insert(tab,{"Совпадение "..symbols.." символов - "..convertNumber(symbolPrices[symbols]).." руб"})
		totalprice = totalprice + symbolPrices[symbols]
	end
	if digits >= 2 then
		table.insert(tab,{"Совпадение "..digits.." цифр - "..convertNumber(digitPrices[digits]).." руб"})
		totalprice = totalprice + digitPrices[digits]
	end
	if combo and type(combo) == "table" then
		table.insert(tab,{"Комбинация символов ["..combo[1].."] - "..convertNumber(combo[2]).." руб"})
		totalprice = totalprice + combo[2]
	end

	return tab, totalprice
end