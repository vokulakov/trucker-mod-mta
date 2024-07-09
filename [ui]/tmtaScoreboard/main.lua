Scoreboard = {}
Scoreboard.isVisible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local Textures = {
	bg 				= dxCreateTexture('assets/images/bg.png'),
	logo 			= exports.tmtaTextures:createTexture('logo_tmta_64'), 
	icon_online 	= dxCreateTexture('assets/images/icon_online.png'),
	line 			= dxCreateTexture('assets/images/line.png'),
	scroll 			= dxCreateTexture('assets/images/scroll.png'),
	rectangle 		= dxCreateTexture('assets/images/rectangle.png'),
	
	-- Icons
	i_money     	= exports.tmtaTextures:createTexture('i_money'),
	i_clock     	= exports.tmtaTextures:createTexture('i_clock'),
}

local Fonts = {
	['RR_10'] = exports.tmtaFonts:createFontDX("RobotoRegular", 10),
	['RR_12'] = exports.tmtaFonts:createFontDX("RobotoRegular", 12),
	['RR_14'] = exports.tmtaFonts:createFontDX("RobotoRegular", 14.5),
}

-- Setups
local Setups = {
	itemsCount = 7, -- максимальное количестов полей на одной "странице"
	columnsTitleColor = tocolor(255, 255, 255, 155),
	playerColor = tocolor(255, 255, 255, 155),
	playerLocalColor = tocolor(255, 255, 255, 255),--tocolor(242, 171, 18, 255),
	playerAunColor = tocolor(255, 255, 255, 125),
}

local playersList = {}
local playersMaxCount = root:getData("ServerMaxPlayers")

local scrollCurrentPage = 0

local SB_WIDTH, SB_HEIGHT = 1094, 620
local posX, posY = (sDW - SB_WIDTH) /2, (sDH - SB_HEIGHT) /2

local Columns = {
	{ 
		title = "ID", 
		size = 0.06, 
		dataName = "player.serverId",
		isStatic = true,
	},
	{ 
		title = "Никнейм", 
		size = 0.25, 	
		get = function(player)
			local name = player.name:gsub("#%x%x%x%x%x%x", "")
			if utf8.len(name) > 12 then
				return utf8.sub(name, 0, 12) .. '...'
			else
				return name
			end
		end,
		isStatic = true,
	},
	{ 
		title = "Уровень", 
		size = 0.07, 
		get = function(player)
			local lvl = exports.tmtaExperience:getPlayerLvl(player)
			if not lvl then
				return '—'
			end
			return lvl
		end,
		isStatic = true,
	},
	{ 
		title = "Пробег", 
		size = 0.12, 
		get = function(player)
			local mileage = player:getData('mileage')
			if not mileage then
				return '—'
			end
			return string.format("%.f км", math.floor(mileage/1000))
		end,
		isStatic = true,
	},
	{ 
		title = "Рейсов", 
		size = 0.1, 
		get = function(player)
            local PlayerStatistics = player:getData("player:truckerStatistic")
            if (not PlayerStatistics) then 
                return 0 
            end 
            return PlayerStatistics.totalOrders or 0
        end,
		isStatic = true,
	},
	{ 
		title = "Баланс", 
		size = 0.15, 
		get = function(player)
			local money = player:getData("money")
			if not money then
				return '—'
			end
			return exports.tmtaUtils:formatMoneyToShortValue(money)
		end,
		icon = Textures.i_money,
		isStatic = true,
	},
	{ 
		title = "Стаж", 
		size = 0.15, 
		get = function(player)
			local playtime = player:getData("playtime")
			if not playtime then
				return '—'
			end
			local hour, minute = exports.tmtaUtils:convertMinToHour(tonumber(playtime))
			return string.format("%02d:%02d", hour, minute)
		end,
		icon = Textures.i_clock,
		isStatic = true,
	},
	{ 
		title = "Пинг", 
		size = 0.06,
		get = function(player)
			return player.ping
		end,
		isStatic = false,
	},
}

--TODO:: центрировать колонки

--local ScoreboardRenderTarget = dxCreateRenderTarget(sW*((SB_WIDTH) /sDW), sH*((SB_HEIGHT) /sDH), true)
--dxSetRenderTarget(rt, true)
--dxSetBlendMode("modulate_add")
--dxSetBlendMode("blend")
--dxSetRenderTarget()

local showMaketMarkers = false -- разметка для верстки

local function drawScoreboard()

	if showMaketMarkers then
		dxDrawRectangle(sW*((posX) /sDW), sH*((posY+60-0.5) /sDH), SB_WIDTH, 1, tocolor(0, 255, 255, 255))
		dxDrawRectangle(sW*((posX) /sDW), sH*((posY+120-0.5) /sDH), SB_WIDTH, 1, tocolor(0, 255, 255, 255))
		dxDrawRectangle(sW*((posX) /sDW), sH*((posY+142-0.5) /sDH), SB_WIDTH, 1, tocolor(0, 255, 255, 255))

		dxDrawRectangle(sW*((posX+20) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255))
		dxDrawRectangle(sW*((posX+42) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255))

		dxDrawRectangle(sW*((posX+SB_WIDTH/2) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255)) -- center
		dxDrawRectangle(sW*((posX+SB_WIDTH-50) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255))
		dxDrawRectangle(sW*((posX+SB_WIDTH-50+16) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255))
		dxDrawRectangle(sW*((posX+SB_WIDTH-14) /sDW), sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 255, 255))
	end

	--dxSetBlendMode("modulate_add")
	dxDrawImage(sW*((posX) /sDW), sH*((posY) /sDH), sW*((SB_WIDTH) /sDW), sH*((SB_HEIGHT) /sDH), Textures.bg, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	-- Шапка
	dxDrawText("TRUCKER × MTA", sW*((posX+20) /sDW), sH*((posY+60) /sDH), 100, sH*((posY+60) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_14, "left", "center")
	dxDrawText("truckermta.ru", sW*((posX+20) /sDW), sH*((posY+80) /sDH), 100, sH*((posY+80) /sDH), tocolor(255, 255, 255, 155), sW/sDW*1.0, Fonts.RR_10, "left", "center")

	dxSetTextureEdge(Textures.logo, "clamp")
	dxDrawImage(sW*((posX+SB_WIDTH/2-64/2) /sDW), sH*((posY+120/2-64/2) /sDH), sW*((64) /sDW), sH*((64) /sDH), Textures.logo, 0, 0, 0, tocolor(255, 255, 255, 255), false)

	dxDrawText("из "..playersMaxCount, sW*((posX) /sDW), sH*((posY+60) /sDH), sW*((posX+SB_WIDTH-50) /sDW), sH*((posY+60) /sDH), tocolor(255, 255, 255, 155), sW/sDW*1.0, Fonts.RR_14, "right", "center")
	local posOffsetX = dxGetTextWidth("из "..playersMaxCount, sW/sDW*1.0, Fonts.RR_14)+5
	dxDrawText(#playersList, sW*((posX) /sDW), sH*((posY+60) /sDH), sW*((posX+SB_WIDTH-50) /sDW)-posOffsetX, sH*((posY+60) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_14, "right", "center")
	posOffsetX = posOffsetX+dxGetTextWidth(#playersList, sW/sDW*1.0, Fonts.RR_14)+sW*((18) /sDW)+10
	dxDrawImage(sW*((posX+SB_WIDTH-50) /sDW)-posOffsetX, sH*((posY+60-18/2) /sDH), sW*((18) /sDW), sH*((18) /sDH), Textures.icon_online, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText("Онлайн", sW*((posX) /sDW), sH*((posY+60) /sDH), sW*((posX+SB_WIDTH-50) /sDW)-posOffsetX-10, sH*((posY+60) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.RR_14, "right", "center")

	-- Столбцы
	local marginLeft = 20 -- допустимо с лева
	local marginRight = 50 -- допустимо справа
	local borderWidth = sW*((posX+SB_WIDTH-marginRight) /sDW)-sW*((posX+marginLeft) /sDW)  -- (990 px)
	local posOffsetX = sW*((posX+marginLeft) /sDW) -- начальная позиция
	
	for _, column in pairs(Columns) do
		local columnWidth = borderWidth*column.size
		dxDrawText(tostring(column.title), posOffsetX, sH*((posY+120) /sDH), posOffsetX+columnWidth, sH*((posY+142) /sDH), Setups.columnsTitleColor, sW/sDW*1.0, Fonts.RR_12, "center", "center")
		
		if showMaketMarkers then
			dxDrawRectangle(posOffsetX, sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(255, 0, 0, 255))
			dxDrawRectangle(posOffsetX+columnWidth/2, sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 255, 0, 255))
			dxDrawRectangle(posOffsetX+columnWidth, sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(255, 0, 0, 255))
		end

		posOffsetX = posOffsetX + columnWidth
	end 

	-- Список игроков
	local posOffsetY = 0
	for i = scrollCurrentPage + 1, math.min(Setups.itemsCount + scrollCurrentPage, #playersList) do
		local player = playersList[i].player
		local posOffsetX = sW*((posX+marginLeft) /sDW) -- начальная позиция
		if isElement(player) and player:getData('userId') then
			local fieldsColor = Setups.playerColor
			if player == localPlayer then
				fieldsColor = Setups.playerLocalColor
			end
			dxDrawImage(sW*((posX+20+3) /sDW), sH*((posY+142+12+(posOffsetY)) /sDH), sW*((1020) /sDW), sH*((60) /sDH), Textures.rectangle, 0, 0, 0, tocolor(255, 255, 255, 255), false)
			for _, field in pairs(Columns) do
				local columnWidth = borderWidth*field.size
				
				local playerData = playersList[i].data -- данные игрока
				local data = playerData[tostring(field.title)]
				if not field.isStatic then
					if field.dataName then
						data = player:getData(field.dataName) or '—'
					else
						data = field.get(player)
					end
				end
				
				--TODO:: размеры рамки учитывать еще
				local dxPosX, dxPosY, dxW, dxH = posOffsetX, posY+142+12+posOffsetY, posOffsetX+columnWidth, posY+142+12+posOffsetY+60

				if field.icon then
					--TODO:: в tmtaUtils или GUI вынести отдельную функцию на вычисление
					--TODO:: во входных параметрах должны быть размеры "рамки"
					local textWidth = dxGetTextWidth(tostring(data), sW/sDW*1.0, Fonts.RR_12) -- ширина текста
					local iconW, iconH = dxGetMaterialSize(field.icon) -- размеры иконки
					local iconPadding = 10 -- отступ между текстом и иконкой
					local widthFrame = sW*((iconW)/sDW)+textWidth+iconPadding -- общая длина иконки, текста с учетом отступа
		
					local dxPosX = dxPosX+columnWidth/2-widthFrame/2
					dxDrawImage(dxPosX, sH*(( dxPosY+((60-iconH) /2) ) /sDH), sW*((iconW) /sDW), sH*((iconH) /sDH), field.icon, 0, 0, 0, tocolor(255, 255, 255, 255))
					dxDrawText(tostring(data), dxPosX+(sW*((iconW)/sDW)+iconPadding), sH*((dxPosY) /sDH), dxW, sH*((dxH) /sDH), fieldsColor, sW/sDW*1.0, Fonts.RR_12, "left", "center")
					
					if showMaketMarkers then
						dxDrawRectangle(dxPosX, sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 0, 255, 255))
						dxDrawRectangle(dxPosX+widthFrame, sH*((posY) /sDH), 1, SB_HEIGHT, tocolor(0, 0, 255, 255))
					end
				else
					dxDrawText(tostring(data), dxPosX, sH*((dxPosY) /sDH), dxW, sH*((dxH) /sDH), fieldsColor, sW/sDW*1.0, Fonts.RR_12, "center", "center")
				end
				
				posOffsetX = posOffsetX + columnWidth
			end
			posOffsetY = posOffsetY + 60 + 6
		end
	end

	-- Скролл
	dxDrawImage(sW*((posX+SB_WIDTH-50/2) /sDW), sH*((posY+180) /sDH), sW*((4) /sDW), sH*((SB_HEIGHT-180) /sDH), Textures.line, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	local marginTop = 40
	local marginBottom = 40
	local borderHeight = sH*((SB_HEIGHT-marginBottom) /sDH) - sH*((posY+180+marginTop) /sDH)
	local posOffsetY = sH*((posY+180+marginTop) /sDH) -- начальная позиция marginTopBottom + scrollCurrentPage
	local scrollOffset = (borderHeight/(#playersList-Setups.itemsCount))*scrollCurrentPage

	if #playersList-Setups.itemsCount > 0 then
		dxDrawImage(sW*((posX+SB_WIDTH-50/2-20/2+4/2) /sDW), posOffsetY+scrollOffset, sW*((20) /sDW), sH*((60) /sDH), Textures.scroll, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	--dxSetBlendMode("blend")
end

-- Получить данные игрока
local function getPlayerData(player)
	if not isElement(player) then
		return false
	end
	local playerData = {}
	for _, field in pairs(Columns) do
		local data = "—"
		if field.dataName then
			data = player:getData(field.dataName) or "—"
		else
			data = field.get(player)
		end
		playerData[field.title] = data
	end
	return playerData
end

-- Добавить игрока в список
function Scoreboard.addPlayerToList(player)
	return table.insert(playersList, {
		player = player, 
		data = getPlayerData(player)
	})
end

-- Убрать игрока из списка
function Scoreboard.removePlayerFromList(player)
	for playerIndex, data in pairs(playersList) do
		if data.player == player then
			return table.remove(playersList, playerIndex)
		end
	end
end

-- Обновить список игроков
function Scoreboard.updatePlayersList()
	playersList = {}
	for _, player in pairs(getElementsByType('player')) do
		Scoreboard.addPlayerToList(player)
	end
end

local function mouseDown()
	if #playersList <= Setups.itemsCount then
		return
	end
	scrollCurrentPage= scrollCurrentPage + 1
	if scrollCurrentPage >= #playersList - Setups.itemsCount then
		scrollCurrentPage = #playersList - Setups.itemsCount
	end
end

local function mouseUp()
	if #playersList <= Setups.itemsCount then
		return
	end
	scrollCurrentPage = scrollCurrentPage - 1
	if scrollCurrentPage < 0 then
		scrollCurrentPage = 0
	end
end

function Scoreboard.open()
	if not exports.tmtaUI:isPlayerComponentVisible("scoreboard") then
        return
    end

	playersMaxCount = root:getData("ServerMaxPlayers") or 0

	Scoreboard.updatePlayersList()

	exports.tmtaUI:setPlayerBlurScreen(true)
	exports.tmtaUI:setPlayerComponentVisible("all", false)

	showChat(false)
	showCursor(true)
	Scoreboard.isVisible = true
	addEventHandler("onClientRender", root, drawScoreboard)

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
end

function Scoreboard.close()
	if not Scoreboard.isVisible then
		return
	end
	
	showChat(true)
	showCursor(false)
	Scoreboard.isVisible = false
	removeEventHandler("onClientRender", root, drawScoreboard)

	exports.tmtaUI:setPlayerBlurScreen(false)
	exports.tmtaUI:setPlayerComponentVisible("all", true)

	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)
end

bindKey("tab", "down", 
	function()
		if not isCursorShowing() or not exports.tmtaUI:isPlayerComponentVisible("scoreboard") then
			Scoreboard.open()
		end
	end
)

bindKey("tab", "up", 
	function()
		Scoreboard.close()
	end
)

addEventHandler('onClientPlayerJoin', root, 
	function()
		Scoreboard.addPlayerToList(source)
	end
)

addEventHandler('onClientPlayerQuit', root, 
	function()
		Scoreboard.removePlayerFromList(source)
	end
)