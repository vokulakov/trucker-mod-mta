addEventHandler("onResourceStart", resourceRoot, function()

	for _, garageData in ipairs(Config.tuningGarageMarkers) do
		Garage.create(garageData.garage.id, garageData.garage.position, garageData.garage.size)
	end

end)