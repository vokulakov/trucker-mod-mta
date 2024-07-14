-- BURGER SHOT
	-- Moo Kid's Meal 			$2
	-- Beef Tower 				$6
	-- Meat Stack 				$12
	-- Salad Meal 				$6

-- CLUCKIN' BELL
	-- Cluckin' Little Meal 	$2
	-- Cluckin' Big Meal		$5
	-- Cluckin' Huge Meal   	$10
	-- Salad Meal				$10

-- WELL STACKED PIZZA CO.
	-- Buster 					$2
	-- Double D-Luxe 			$5
	-- Full Rack 				$10
	-- Salad Meal 				$10

RestaurantsConfig = {}

RestaurantsConfig.foods = {
	['BURGER_SHOT'] = {
		{ name = "Moo Kid's Meal", 	price = 140, 	add = 0.2, img = "assets/img/BURLOW.png" },
		{ name = "Beef Tower", 		price = 460, 	add = 0.35, img = "assets/img/BURMED.png" },
		{ name = "Meat Stack", 		price = 840, add = 0.5, img = "assets/img/BURHIG.png" },
		{ name = "Salad Meal", 		price = 420, 	add = 0.3, img = "assets/img/BURHEAL.png" },
	},
	
	['CLUCKIN_BELL'] = {
		{ name = "Cluckin' Little Meal", 	price = 140, 	add = 0.2, img = "assets/img/CLULOW.png" },
		{ name = "Cluckin' Big Meal", 		price = 349, 	add = 0.35, img = "assets/img/CLUMED.png" },
		{ name = "Cluckin' Huge Meal", 		price = 599, add = 0.5, img = "assets/img/CLUHIG.png" },
		{ name = "Salad Meal", 				price = 420, add = 0.3, img = "assets/img/CLUHEAL.png" },
	},
	
	['PIZZA'] = {
		{ name = "Buster", 				price = 140, 	add = 0.2, img = "assets/img/PIZLOW.png" },
		{ name = "Double D-Luxe ", 		price = 360, 	add = 0.35, img = "assets/img/PIZMED.png" },
		{ name = "Full Rack", 			price = 599, add = 0.5, img = "assets/img/PIZHIG.png" },
		{ name = "Salad Meal", 			price = 420, add = 0.3, img = "assets/img/PIZHEAL.png" },
	}
}

RestaurantsConfig.position = {

	-- BURGER SHOT --

	-- Los Santos, Temple
	{
		int = 10, -- интерьер
		dim = 1, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 1199.623, -- позиция входа X
		eY = -918.670, -- позиция входа Y
		eZ = 43.117, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- Los Santos, Marina
	{
		int = 10, -- интерьер
		dim = 2, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 811.166, -- позиция входа X
		eY = -1616.321, -- позиция входа Y
		eZ = 13.82511806488, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- San Fierro, Garcia
	{
		int = 10, -- интерьер
		dim = 3, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = -2336.119, -- позиция входа X
		eY = -166.832, -- позиция входа Y
		eZ = 35.5546875, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- San Fierro, Downtown
	{
		int = 10, -- интерьер
		dim = 4, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = -1912.0101318359, -- позиция входа X
		eY = 829.31781005859, -- позиция входа Y
		eZ = 35.178951263428, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- San Fierro, Juniper Hollow
	{
		int = 10, -- интерьер
		dim = 5, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = -2356.718, -- позиция входа X
		eY = 1008.1652832031, -- позиция входа Y
		eZ = 50.6953125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
		
	-- Las Venturas, Whitewood Estates
	{
		int = 10, -- интерьер
		dim = 6, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 1158.704, -- позиция входа X
		eY = 2072.269, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- Las Venturas, Redsands East
	{
		int = 10, -- интерьер
		dim = 7, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 1872.701, -- позиция входа X
		eY = 2071.631, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- Las Venturas, Old Venturas Strip
	{
		int = 10, -- интерьер
		dim = 8, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 2366.509, -- позиция входа X
		eY = 2071.051, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- Las Venturas, Spinybed
	{
		int = 10, -- интерьер
		dim = 9, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 2170.4797363281, -- позиция входа X
		eY = 2795.2456054688, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	-- Las Venturas, Old Venturas Strip
	{
		int = 10, -- интерьер
		dim = 10, -- измерение
		blip = 10,
		pickup = 2703, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = 2472.126, -- позиция входа X
		eY = 2034.278, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	

	-- PIZZA 
	
	{
		int = 5, -- интерьер
		dim = 11, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 2105.2, -- позиция входа X
		eY = -1806.5, -- позиция входа Y
		eZ = 13.5, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Red County, Montgomery
	{
		int = 5, -- интерьер
		dim = 12, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 1356.4122314453, -- позиция входа X
		eY = 253.54023742676, -- позиция входа Y
		eZ = 19.5546875, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Red County, Blueberry
	{
		int = 5, -- интерьер
		dim = 13, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 203.75723266602, -- позиция входа X
		eY = -207.05776977539, -- позиция входа Y
		eZ = 1.4355098009109, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Red County, Palomino Creek
	{
		int = 5, -- интерьер
		dim = 15, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 2337.5053710938, -- позиция входа X
		eY = 75.482917785645, -- позиция входа Y
		eZ = 26.479633331299, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- San Fierro, Financial
	{
		int = 5, -- интерьер
		dim = 16, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = -1804.0396728516, -- позиция входа X
		eY = 942.36138916016, -- позиция входа Y
		eZ = 24.890625, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- San Fierro, Esplanade North
	{
		int = 5, -- интерьер
		dim = 17, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = -1723.3764648438, -- позиция входа X
		eY = 1358.900390625, -- позиция входа Y
		eZ = 7.1875, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Las Venturas, Roca Escalante
	{
		int = 5, -- интерьер
		dim = 18, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 2352.5952148438, -- позиция входа X
		eY = 2530.7990722656, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Las Venturas, Creek
	{
		int = 5, -- интерьер
		dim = 19, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 2755.2697753906, -- позиция входа X
		eY = 2471.3999023438, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- Las Venturas, The Emerald Isle
	{
		int = 5, -- интерьер
		dim = 20, -- измерение
		blip = 10, -- 29
		pickup = 2814, -- пикап
		name = "The Well Stacked Pizza Co.",
		foods = RestaurantsConfig.foods['PIZZA'],

		eX = 2083.2890625, -- позиция входа X
		eY = 2220.3002929688, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	},

	-- CLUCKIN

	-- Whetstone, Angel Pine
	{
		int = 9, -- интерьер
		dim = 12, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = -2152.0085449219, -- позиция входа X
		eY = -2463.9184570313, -- позиция входа Y
		eZ = 30.84375, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
	-- Los Santos, Willowfield
	{
		int = 9, -- интерьер
		dim = 13, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 2397.6401367188, -- позиция входа X
		eY = -1896.1461181641, -- позиция входа Y
		eZ = 13.3828125, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Los Santos, East Los Santos
	{
		int = 9, -- интерьер
		dim = 14, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 2423.84375, -- позиция входа X
		eY = -1509.2326660156, -- позиция входа Y
		eZ = 23.992208480835, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Los Santos, Market
	{
		int = 9, -- интерьер
		dim = 15, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 926.13220214844, -- позиция входа X
		eY = -1352.9737548828, -- позиция входа Y
		eZ = 13.376754760742, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- San Fierro, Downtown
	{
		int = 9, -- интерьер
		dim = 16, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = -1816.2913818359, -- позиция входа X
		eY = 615.19360351563, -- позиция входа Y
		eZ = 35.171875, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- San Fierro, Ocean Flats
	{
		int = 9, -- интерьер
		dim = 17, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = -2671.7155761719, -- позиция входа X
		eY = 264.01913452148, -- позиция входа Y
		eZ = 4.6328125, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Tierra Robada, Tierra Robada
	{
		int = 9, -- интерьер
		dim = 18, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = -1210.9245605469, -- позиция входа X
		eY = 1831.9158935547, -- позиция входа Y
		eZ = 41.9296875, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Bone County, Bone County
	{
		int = 9, -- интерьер
		dim = 19, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 171.58251953125, -- позиция входа X
		eY = 1176.3500976563, -- позиция входа Y
		eZ = 14.764543533325, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Las Venturas, The Emerald Isle
	{
		int = 9, -- интерьер
		dim = 20, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 2105.056640625, -- позиция входа X
		eY = 2228.7541503906, -- позиция входа Y
		eZ = 11.030031204224, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	-- Las Venturas, Old Venturas Strip
	{
		int = 9, -- интерьер
		dim = 21, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 2393.3386230469, -- позиция входа X
		eY = 2045.2077636719, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},

	--  Las Venturas, Creek
	{
		int = 9, -- интерьер
		dim = 22, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап
		name = "Cluckin' Bell",
		foods = RestaurantsConfig.foods['CLUCKIN_BELL'],
		
		eX = 2842.5930175781, -- позиция входа X
		eY = 2403.3088378906, -- позиция входа Y
		eZ = 10.8203125, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
}
