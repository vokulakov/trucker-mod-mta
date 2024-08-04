customCarNames = {
	[587] = 'BMW M8 Competition Gran Coupe',
}

local vehiclesTable = {
	{587, 12500000},
}

ShopTable = {
	[1] = {
		name = 'Автосалон',
        vehicles = vehiclesTable,
		PosX = 2131.79, PosY = -1151.32, PosZ = 23.06,
		vPosX = 1379.3, vPosY = -1170.19, vPosZ = 127.6, 
		CamX = 1378.9, CamY = -1176.8, CamZ = 130.7, 
		lookAtX = 1379.3, lookAtY = -1170.19, lookAtZ = 127.6
	},
    
	[2] = {
		name = 'Автосалон',
		vehicles = vehiclesTable,
		PosX = 1948.2, PosY = 2068.4, PosZ = 10.06,
		vPosX = 1379.3, vPosY = -1170.19, vPosZ = 127.6, 
		CamX = 1378.9, CamY = -1176.8, CamZ = 130.7, 
		lookAtX = 1379.3, lookAtY = -1170.19, lookAtZ = 127.6
	},
	
	[3] = {
		name = 'Автосалон',
		vehicles = vehiclesTable,
		PosX = -1953, PosY = 301, PosZ = 34.5,
		vPosX = 1379.3, vPosY = -1170.19, vPosZ = 127.6,  
		CamX = 1378.9, CamY = -1176.8, CamZ = 130.7, 
		lookAtX = 1379.3, lookAtY = -1170.19, lookAtZ = 127.6
	},
}

vehShopColors = -- Панель цветов в салоне Цвет(R,B,G)
{
	{110, 110, 110},
	{0, 0, 0},
	{255, 255, 255},
	{255, 0, 0},
	{254, 197, 0},
	{125, 253, 0},
	{7, 108, 233},
	{152, 5, 246},
	{254, 119, 0},
}

-- Utils
function convertNumber(number)
	local formatted = number

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if ( k==0 ) then
			break
		end
	end

	return formatted
end

function getNamesTable()
	return customCarNames
end

function getVehicleModelFromNewName(name)
	for i, v in pairs(customCarNames) do
		if v == name then
			return i
		end
	end
	return false
end
