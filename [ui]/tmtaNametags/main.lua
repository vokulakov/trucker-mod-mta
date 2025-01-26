local NAMETAG_MAX_DISTANCE = 50
local NAMETAG_OFFSET = 0.15
local NAMETAG_FONT = "default-bold"--exports.tmtaFonts:createFontDX("RobotoRegular", 10) or "default-bold"

local VOICE_ICON = dxCreateTexture("assets/vois.png")
local CHAT_ICON = dxCreateTexture("assets/chat.png")

local streamedPlayers = {}

local _dxDrawText = dxDrawText
local function dxDrawText(text, x1, y1, x2, y2, color, scale, font)
	_dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font or NAMETAG_FONT, "center", "center")
	_dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font or NAMETAG_FONT, "center", "center")
	_dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font or NAMETAG_FONT, "center", "center")
	_dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font or NAMETAG_FONT, "center", "center")
	_dxDrawText(text, x1, y1, x2, y2, color, scale, font or NAMETAG_FONT, "center", "center")
end

local function dxDrawBorderedImage(x, y, width, height, image)
	dxDrawRectangle(x, y - 1, width, 1, tocolor(0, 0, 0, 250), false, true)
	dxDrawRectangle(x + width, y, 1, height, tocolor(0, 0, 0, 250), false, true)
	dxDrawRectangle(x, y + height, width, 1, tocolor(0, 0, 0, 250), false, true)
	dxDrawRectangle(x - 1, y, 1, height, tocolor(0, 0, 0, 250), false, true)
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 250), false, true)
	
	dxDrawImage(x + 2, y + 2, width - 4, height - 4, image)
end 

local MESSAGE_TIME_VISIBLE = 5000
local playerMessages = {}

addEvent("tmtaChat.onClientSendMessage", true)
addEventHandler("tmtaChat.onClientSendMessage", root,
	function(message)
		local player = source
		if not isElement(player) or player == localPlayer then
			return
		end
			
		if (not playerMessages[player]) then
			playerMessages[player] = {}
		end
		
		local tick = getTickCount()
		
		table.insert(playerMessages[player], {
			text = message:gsub("#%x%x%x%x%x%x", ""), 
			tick = tick,
			endTime = tick + 2000, 
			alpha = 0,
		})
	end
)

addEventHandler("onClientRender", root, function()
    if not exports.tmtaUI:isPlayerComponentVisible("nametags") then
        return
    end

	local cx, cy, cz = getCameraMatrix()
	local tick = getTickCount()

	for player, info in pairs(streamedPlayers) do
        local px, py, pz = getPedBonePosition(player, (player.health > 0) and 6 or 3)
		local x, y = getScreenFromWorldPosition(px, py, pz + 0.5, 50, false)
		if x and y then
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			if distance < NAMETAG_MAX_DISTANCE then
                local yOffset = 16

				local lvl = exports.tmtaExperience:getPlayerLvl()
				if not lvl then
					return
				end
            	
                -- AFK
                if player:getData("player.isAFK") then
					yOffset = yOffset + 16
					local AFK_TIME = player:getData("player.timeAFK")
					dxDrawText('AFK ['..tostring(AFK_TIME)..']', x, y-yOffset, x, y-yOffset, tocolor(200, 0, 0, 255), 1, "default-bold")
				elseif player:getData('player.isChatting') then
					yOffset = yOffset + 16
					dxDrawText('Строчит сообщение...', x, y-yOffset, x, y-yOffset, tocolor(33, 177, 255, 255), 1, "default-bold")
                end
				
				-- Голосовой чат --
				if player:getData("isVoice") then
					yOffset = yOffset + 32 + 16
					dxDrawBorderedImage(x -11 -2, y-yOffset, 22, 22, VOICE_ICON)
				end
				
				local rank = exports.tmtaExperience:getRankFromLvl(lvl) or ""
				dxDrawText(rank, x, y-16, x, y-16, tocolor(238, 174, 39, 255), 1, NAMETAG_FONT)

                dxDrawText(string.format("%s (%s)", info.name, info.playerId), x, y, x, y, tocolor(255, 255, 255, 255), 1)
				
				-- Здоровье/ броня
                if player.armor > 0 then
                    NAMETAG_OFFSET = 1.25
                    dxDrawRectangle(x-50/2, y+10, 50, 6, tocolor(0, 0, 0, 150))
                    dxDrawRectangle(x-48/2, y+11, player.armor*48 / 100, 4, tocolor(200, 200, 200, 250))
                    dxDrawRectangle(x-50/2, y+18, 50, 6, tocolor(0, 0, 0, 150))
                    dxDrawRectangle(x-48/2, y+19, player.health*48 / 100, 4, tocolor(200, 0, 0, 250))
                else
                    NAMETAG_OFFSET = 1.15
                    dxDrawRectangle(x-50/2, y+10, 50, 6, tocolor(0, 0, 0, 150))
                    dxDrawRectangle(x-48/2, y+11, player.health*48 / 100, 4, tocolor(200, 0, 0, 250))
                end

				-- СООБЩЕНИЕ НАД ИГРОКОМ
				if playerMessages[player] then
					yOffset = yOffset + 16
					for messageIndex, message in ipairs(playerMessages[player]) do
						if (tick-message.tick < MESSAGE_TIME_VISIBLE) then
							message.alpha = message.alpha < 200 and message.alpha + 5 or message.alpha
							
							local elapsedTime = tick - message.tick
							local duration = message.endTime - message.tick
							local progress = elapsedTime / duration
							local width = dxGetTextWidth(message.text, 1, NAMETAG_FONT)

							local yPos = interpolateBetween(y, 0, 0, y-10-yOffset*messageIndex, 0, 0, progress, progress > 1 and "Linear" or "OutElastic")
							
							dxDrawRectangle(x-width/2-10, yPos - 16, width + 16, 20, tocolor(0, 0, 0, message.alpha))
							_dxDrawText(message.text, x-width/2-2, yPos - 14, width, 20, tocolor( 255, 255, 255, message.alpha+50), 1, NAMETAG_FONT, "left", "top", false, false, false, true)
						else
							table.remove(playerMessages[player], messageIndex)
						end
					end
				end
            end
        end
    end
end)

local function showPlayer(player)
	if not isElement(player) then
		return false
	end

	setPlayerNametagShowing(player, false)
	if player == localPlayer then
		return
	end

    streamedPlayers[player] = {
        name = player.name:gsub("#%x%x%x%x%x%x", ""),
		playerId = getElementData(player, 'player.serverId'),
    }

	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, player in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(player) then 
			showPlayer(player)
		end
		setPlayerNametagShowing(player, false)
	end
end)

addEventHandler("onClientPlayerJoin", root, function()
	if isElementStreamedIn(source) then
		showPlayer(source)
	end
	setPlayerNametagShowing(source, false)
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if getElementType(source) == "player" then
		showPlayer(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if getElementType(source) == "player" then
		streamedPlayers[source] = nil
	end
end)

addEventHandler("onClientPlayerQuit", root, function ()
	streamedPlayers[source] = nil
end)