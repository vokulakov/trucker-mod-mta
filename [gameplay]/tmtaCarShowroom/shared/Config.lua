Config = {}

Config.showroomObjectId = 3900
Config.showroomObjectPosition = Vector3(2372, -1642.9, 300)
Config.showroomObjectInterior = 1

Config.colorList = {
    {0, 0, 0},
    {255, 255, 255},
	{110, 110, 110},
	{255, 0, 0},
	{254, 197, 0},
	{125, 253, 0},
	{7, 108, 233},
	{152, 5, 246},
	{254, 119, 0},
}

Config.showroomType = {
    [1] = 'Легковые автомобили',
    [2] = 'Мото',
    [3] = 'Грузовые автомобили',
}

Config.showroomClass = {
    [1] = 'Бюджетный',
    [2] = 'Средний',
    [3] = 'Премиальный',
    [4] = 'Элитный',
}

Config.showroomList = {
    -- San-Fierro
    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[1],
        
        markerPosition = Vector3(-1657.41, 1211.10, 7.25),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.5),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = {
            { model = 'vaz_2110', price = 140000 },
        },
    },
}