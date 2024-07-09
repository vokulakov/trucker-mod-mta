local function getPosToClipboard()
	local playerPos = Vector3(localPlayer.position)
	local position = string.format("{ x = %.2f, y = %.2f, z = %.2f }", playerPos.x, playerPos.y, playerPos.z)
	setClipboard(position)
	outputChatBox("Позиция "..position.." скопирована в буфер обмена", 0, 255, 0, true)
end
addCommandHandler("pos", getPosToClipboard)