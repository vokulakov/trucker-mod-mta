local NAMETAG_MAX_DISTANCE = 50
local NAMETAG_OFFSET = 0.15
local NAMETAG_FONT = exports.tmtaFonts:createFontDX("RobotoRegular", 10) or "default-bold"

local streamedPlayers = {}

local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, NAMETAG_FONT, "center", "center")
end

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

                -- AFK
                if player:getData("isAFK") then
					local AFK_TIME = player:getData("timeAFK")
					yOffset = yOffset + 16
					dxDrawNametagText('AFK ['..tostring(AFK_TIME)..']', x, y-yOffset, x, y-yOffset, tocolor(200, 0, 0, 255), 1)
                end

                dxDrawNametagText(info.name, x, y, x, y, tocolor(255, 255, 255, 255), 1)

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