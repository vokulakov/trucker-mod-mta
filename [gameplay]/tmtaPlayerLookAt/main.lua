local streamedPlayers = {}

-- TODO:: добавить настройку на отключение вращения головы на всех игроков

addEventHandler("onClientRender", root, function()
	
	for _, player in pairs(streamedPlayers) do

			if getElementHealth(player) >= 1 then

				--if player:getData('player.isShowingHeadMoving') then
					local x, y, z, lx, ly, lz = getCameraMatrix()
					local vec = {x-lx, y-ly, z-lz}
					lx = lx + vec[1]*-100
					ly = ly + vec[2]*-100
					lz = lz + vec[3]*-100

					setPedLookAt(player, lx, ly, lz, -1)
				--end
			end 
		
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- TODO:: isElementStreamedIn можно перенести в getElementsByType
	for i, player in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(player) then 
			streamedPlayers[player] = player
			--player:setData('player.isShowingHeadMoving', true)
		end
	end
end)

addEventHandler("onClientPlayerJoin", root, function()
	if isElementStreamedIn(source) then
		streamedPlayers[source] = source
		--source:setData('player.isShowingHeadMoving', true)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "player" then
		streamedPlayers[source] = source
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "player" then
		streamedPlayers[source] = nil
	end
end)

addEventHandler("onClientPlayerQuit", root, function()
	streamedPlayers[source] = nil
end)