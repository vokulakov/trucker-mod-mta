Config = {}

-- Координаты объекта гаража
Config.paintGaragePosition = Vector3(0, 0, 200)
Config.paintGarageModel = 1872

-- Положение машины в покрасочной
Config.garageVehiclePosition = Config.paintGaragePosition + Vector3(0, 0, -1)
Config.garageVehicleRotation = Vector3(0, 0, 90)
Config.garageInterior = 1

-- Входы в покрасочные
Config.garageMarkerRadius = 3.5
Config.garageMarkerBlip = 63
Config.garageMarkerColor = {255, 255, 255, 100}

-- Виды транспорта, которые можно красить
Config.allowedVehicleTypes = {
    Automobile = true,
}

-- цены на покраску
Config.paintPrice = { 
	['stock'] = 1500, -- стандартный
	['gloss'] = 3500, -- глянцевый
	['matte'] = 6500, -- матовый
	['chrome'] = 9000, -- хром
	['chameleon'] = 15000, -- хамелеон
}

Config.paintGarageMarkers = {
	-- Pay 'n' Spray (Idlewood)	--
	{ 	
		garage = { id = 8, position = Vector3(2058, -1835, 12.5), size = Vector3(20, 7, 4) },
		position = Vector3(2063.522, -1831, 13.728),
		angle = -90,
	},
	
	-- Pay 'n' Spray (Temple Los Santos) --
	{ 	
		garage = { id = 11, position = Vector3(1022, -1035, 31), size = Vector3(6, 17, 4) },
		position = Vector3(1024.9, -1023, 31.5),
	},

	-- Pay 'n' Spray (Santa Maria Beach) --
	{ 	
		garage = { id = 12, position = Vector3(485.28, -1745.7, 10.3906), size = Vector3(6, 17, 4) },
		position = Vector3(487.788, -1741.621, 11.324),
	},

	-- Pay 'n' Spray (Downtown) -- 
	{ 	
		garage = { id = 19, position = Vector3(-1909, 272, 40), size = Vector3(9, 17, 4) },
		position = Vector3(-1905.035, 284.673, 41.227),
	},

	-- Pay 'n' Spray (Juniper Hollow) --
	{ 	
		garage = { id = 27, position = Vector3(-2429.56, 1011.19, 49), size = Vector3(8, 25, 5) },
		position = Vector3(-2425.11, 1020.98, 49.99),
	},

	-- Pay 'n' Spray (Redsands East) --
	{ 	
		garage = { id = 36, position = Vector3(1955, 2158.12, 9.8), size = Vector3(30, 8, 5) },
		position = Vector3(1974.74, 2162.66, 10.66),
	},

	-- Pay 'n' Spray (El Quebrados) --
	{ 	
		garage = { id = 40, position = Vector3(-1423.96, 2576.78, 54.5), size = Vector3(7, 22, 5) },
		position = Vector3(-1420.10, 2585.06, 55.43),
	},

	-- Pay 'n' Spray (Fort Carson) --
	{ 	
		garage = { id = 41, position = Vector3(-104.44, 1104.07, 18.5), size = Vector3(8, 22, 5) },
		position = Vector3(-100.24, 1116.87, 19.33),
	},

	-- Pay 'n' Spray (Dillimore) --
	{ 	
		garage = { id = 47, position = Vector3(716.80, -471.44, 14.5), size = Vector3(8, 22, 5) },
		position = Vector3(720.26, -455.43, 15.93),
	},
} 
