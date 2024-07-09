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

		eX = 1366.389404, -- позиция входа X
		eY = 249.008377, -- позиция входа Y
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

		eX = 203.150528, -- позиция входа X
		eY = -202.598785, -- позиция входа Y
		eZ = 1.578125, -- позиция входа Z

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

		eX = 2333.170166, -- позиция входа X
		eY = 75.155449, -- позиция входа Y
		eZ = 26.620975, -- позиция входа Z
		
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

		eX = -1807.848267, -- позиция входа X
		eY = 944.915649, -- позиция входа Y
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

		eX = -1721.399170, -- позиция входа X
		eY = 1359.578735, -- позиция входа Y
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

		eX = 2351.808838, -- позиция входа X
		eY = 2532.743164, -- позиция входа Y
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

		eX = 2755.844482, -- позиция входа X
		eY = 2476.794678, -- позиция входа Y
		eZ = 11.062500, -- позиция входа Z

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

		eX = 2083.302002, -- позиция входа X
		eY = 2223.633057, -- позиция входа Y
		eZ = 11.023438, -- позиция входа Z
		
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
		
		eX = 2397.871826, -- позиция входа X
		eY = -1898.132568, -- позиция входа Y
		eZ = 13.546875, -- позиция входа Z
		
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
		
		eX = 2420.628662, -- позиция входа X
		eY = -1508.811646, -- позиция входа Y
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
		
		eX = -1817.0102549, -- позиция входа X
		eY = 617.489075, -- позиция входа Y
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
		
		eX = -2671.413086, -- позиция входа X
		eY = 258.600555, -- позиция входа Y
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
		
		eX = -1213.153809, -- позиция входа X
		eY = 1830.841064, -- позиция входа Y
		eZ = 41.929688, -- позиция входа Z
		
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
		
		eX = 2102.673340, -- позиция входа X
		eY = 2228.541260, -- позиция входа Y
		eZ = 11.023438, -- позиция входа Z
		
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
		
		eX = 2393.165283, -- позиция входа X
		eY = 2042.172119, -- позиция входа Y
		eZ = 10.820312, -- позиция входа Z
		
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
		
		eX = 2838.712158, -- позиция входа X
		eY = 2407.149170, -- позиция входа Y
		eZ = 11.068956, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
}