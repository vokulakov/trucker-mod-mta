


addEventHandler('onResourceStart', resourceRoot, function()

	for _, pedConfig in pairs( Config.peds ) do
		createWorldPed(pedConfig)
	end

end)
