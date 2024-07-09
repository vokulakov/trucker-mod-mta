-- Очискта чата
function clearChat(player)
    player = player or root
    triggerEvent(resName..".clearChat", resourceRoot)
    triggerClientEvent(player, resName..".clearChat", resourceRoot)
end