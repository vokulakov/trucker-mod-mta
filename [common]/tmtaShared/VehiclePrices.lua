local vehiclePrices = {
    vaz_2110 = 140000,
}

function getVehiclePrice(name)
    if (not name or type(name) ~= 'string') then
		return false
	end
    return vehiclePrices[name]
end