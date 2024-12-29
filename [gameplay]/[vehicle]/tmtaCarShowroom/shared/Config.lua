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
}

local VEHICLE_LIST = {}

-- Бюджетный класс
VEHICLE_LIST.TYPE_CLASS_LOW = {
    { model = 'vaz_2101', price = 60000 },
    { model = 'volkswagen_golf_mk1', price = 87000 },
    { model = 'gaz_volga_24', price = 105000 },
    { model = 'vaz_2107', price = 115000 },
    { model = 'vaz_2109', price = 118000 },
    { model = 'vaz_2110', price = 133000 },
    { model = 'volkswagen_passat_b3', price = 135000 },
    { model = 'bmw_e30', price = 350000 },
    { model = 'lada_priora_2170', price = 500000 },
    { model = 'lada_vesta', price = 852900 },
    { model = 'kia_rio', price = 879900 },
}

-- Средний класс
VEHICLE_LIST.TYPE_CLASS_MIDDLE = {
    { model = 'bmw_e34', price = 530000 },
    { model = 'mb_w124', price = 700000 },
    { model = 'nissan_gtr_r34', price = 915000 },
    { model = 'toyota_mark2', price = 1050000 },
    { model = 'mb_w140', price = 1150000 },
    { model = 'subaru_impreza_wrx', price = 1200000 },
    { model = 'bmw_e38', price = 1250000 },
    { model = 'bmw_m3_e46', price = 1300000 },
    { model = 'mitsubishi_lancer_x', price = 1450000 },
    { model = 'bmw_x5_e53', price = 1550000 },
    { model = 'nissan_silvia_s15', price = 1600000 },
    { model = 'toyota_gt86', price = 1768000 },
    { model = 'nissan_370z', price = 2000000 },
    { model = 'skoda_octavia_vrs', price = 2000000 },
    { model = 'lexus_isf', price = 2000000 },
    { model = 'bmw_m5_e60', price = 2835000 },
    { model = 'kia_k5', price = 2990000 },
    { model = 'bmw_850_ci', price = 2990000 },
    { model = 'toyota_camry_v70', price = 3500000 },
    { model = 'alfa_romeo_giulia', price = 4095000 },
    { model = 'mb_cls63_w218', price = 4820000 },
    { model = 'toyota_supra_a90', price = 6000000 },
    { model = 'toyota_lc_200', price = 6800000 },
}

-- Премиальный класс
VEHICLE_LIST.TYPE_CLASS_HIGHT = {
    { model = 'bmw_m5_f10', price = 4000000 },
    { model = 'bmw_x6m', price = 4200000 },
    { model = 'mb_e63_w212', price = 4950000 },
    { model = 'audi_rs5', price = 5490000 },
    { model = 'dodge_challenger_srt', price = 5600000 },
    { model = 'chevrolet_camaro_zl1', price = 6550000 },
    { model = 'bmw_x5m_f85', price = 7000000 },
    { model = 'audi_s8', price = 7785000 },
    { model = 'nissan_gtr_r35', price = 7800000 },
    { model = 'audi_r8', price = 9000000 },
    { model = 'bmw_m760li', price = 9720000 },
    { model = 'mb_e63s_w213', price = 9867000 },
    { model = 'porsche_911_carrera_s', price = 10000000 },
    { model = 'bmw_m4_g82', price = 11000000 },
    { model = 'mb_e63s_w223', price = 12000000 },
    { model = 'mb_maybach_s650_x222', price = 12125000 },
    { model = 'audi_rs6_avant_c8', price = 12500000 },
    { model = 'range_rover_sva', price = 12830000 },
    { model = 'bmw_m3_touring_g81', price = 13000000 },
    { model = 'mb_gt63s', price = 13863000 },
    { model = 'bmw_m8_competition', price = 14500000 },
    { model = 'bantley_continental_gt', price = 14700000 },
    { model = 'bmw_m5_f90', price = 15000000 },
    { model = 'dodge_ram_trx', price = 15000000 },
    { model = 'audi_q8rs', price = 15000000 },
    { model = 'porsche_panamera_turbo_s', price = 15230000 },
    { model = 'bentley_bentayga', price = 18633000 },
    { model = 'mb_g63_amg', price = 19000000 },
    { model = 'ferrari_488', price = 20000000 },
    { model = 'mclaren_p1', price = 20000000 },
    { model = 'lamborghini_aventador_lp700', price = 20050000 },
    { model = 'lamborghini_urus', price = 22450000 },
    { model = 'rolls_royce_wraith', price = 26000000 },
    { model = 'rolls_royce_phantom', price = 65000000 },
    { model = 'ferrari_sf90', price = 80000000 },
    { model = 'bugatti_chiron', price = 93000000 },
    { model = 'koenigsegg_gemera', price = 125000000 },
    { model = 'bugatti_divo', price = 353000000 },
}

Config.showroomList = {
    -- San-Fierro
    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[1],
        
        markerPosition = Vector3(-1657.41, 1211.10, 7.25),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.38),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = VEHICLE_LIST.TYPE_CLASS_LOW,
    },

    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[3],
        
        markerPosition = Vector3(-1954.631226, 302.105896, 35.468750),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.38),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = VEHICLE_LIST.TYPE_CLASS_HIGHT,
    },


    -- Las Venturas
    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[2],
        
        markerPosition = Vector3(1946.61, 2068.86, 10.82),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.38),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = VEHICLE_LIST.TYPE_CLASS_MIDDLE,
    },

    -- Los Santos
    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[1],
        
        markerPosition = Vector3(2132.053467, -1149.092773, 24.307728),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.38),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = VEHICLE_LIST.TYPE_CLASS_LOW,
    },

    {
        name = 'Автосалон',
        type = Config.showroomType[1],
        class = Config.showroomClass[2],
        
        markerPosition = Vector3(542.539490, -1290.478516, 17.242188),
        markerColor = {255, 255, 255, 100},

        vehiclePosition = Vector3(2372, -1643, 298.38),
        vehicleRotation = Vector3(0, 0, 180),

        vehicleList = VEHICLE_LIST.TYPE_CLASS_MIDDLE,
    },

}