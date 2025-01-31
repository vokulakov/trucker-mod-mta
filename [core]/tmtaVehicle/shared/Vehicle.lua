-- @link https://wiki.multitheftauto.com/wiki/RU/Vehicle_IDs
local vehicleIDs = { 
    602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 
    589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 
    585, 405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 
    553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
    417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 
    586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 438, 
    437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 
    407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 423, 532, 
    414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 
    478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 567, 535, 576, 
    412, 402, 542, 603, 475, 449, 537, 538, 570, 441, 464, 501, 465, 564, 568, 
    557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 444, 556, 429, 411, 
    541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 
    477, 503, 579, 400, 404, 489, 505, 479, 442, 458, 606, 607, 610, 590, 569, 
    611, 584, 608, 435, 450, 591, 594,
}

local validVehicleModels = {}
for _, model in ipairs(vehicleIDs) do
	validVehicleModels[model] = true
end

-- Краткие названия для использования в коде вместо ID
local vehicleModels = {
    -- Рабочие
    [605] = 'izh_2715',
    [543] = 'izh_2717',
    [528] = 'izh_oda_2717',

    [414] = 'gazel_3302',
    [478] = 'raf_2203',
    [455] = 'gaz_3307',
    [499] = 'gazon_next',
    [609] = 'vw_transporter',
    [482] = 'mercedes_benz_sprinter',

    [544] = 'iveco_stralis_500',
    [578] = 'volvo_fh12',
    [433] = 'scania_r700',
    [573] = 'kamaz_54115',

    [403] = 'freightliner_columbia',
    [515] = 'kamaz_54901',
    [514] = 'volvo_fh460',

    -- Транспорт
    [412] = 'alfa_romeo_giulia',
    [474] = 'audi_q8rs',
    [565] = 'audi_r8',
    [559] = 'audi_rs5',
    [458] = 'audi_rs6_avant_c8',
    [547] = 'audi_s8',
    [535] = 'bantley_continental_gt',
    [489] = 'bentley_bentayga',
    [477] = 'bmw_850_ci',
    [534] = 'bmw_e30',
    [507] = 'bmw_e34',
    [540] = 'bmw_e38',
    [429] = 'bmw_m3_e46',
    [529] = 'bmw_m3_touring_g81',
    [602] = 'bmw_m4_g82',
    [600] = 'bmw_m5_e60',
    [419] = 'bmw_m5_f10',
    [585] = 'bmw_m5_f90',
    [410] = 'bmw_m8_competition',
    [550] = 'bmw_m760li',
    [566] = 'bmw_x5_e53',
    [516] = 'bmw_x5m_f85',
    [401] = 'bmw_x6m',
    [415] = 'bugatti_chiron',
    [502] = 'bugatti_divo',
    [575] = 'chevrolet_camaro_zl1',
    [542] = 'dodge_challenger_srt',
    [500] = 'dodge_ram_trx',
    [541] = 'ferrari_488',
    [494] = 'ferrari_sf90',
    [576] = 'gaz_volga_24',
    [517] = 'kia_k5',
    [436] = 'kia_rio',
    [506] = 'koenigsegg_gemera',
    [405] = 'lada_priora_2170',
    [561] = 'lada_vesta',
    [451] = 'lamborghini_aventador_lp700',
    [418] = 'lamborghini_urus',
    [558] = 'lexus_isf',
    [422] = 'mb_cls63_w218',
    [426] = 'mb_e63_w212',
    [546] = 'mb_e63s_w213',
    [551] = 'mb_e63s_w223',
    [442] = 'mb_gt63s',
    [409] = 'mb_maybach_s650_x222',
    [439] = 'mb_w124',
    [400] = 'mb_g63_amg',
    [492] = 'mb_w140',
    [411] = 'mclaren_p1',
    [526] = 'mitsubishi_lancer_x',
    [555] = 'nissan_370z',
    [589] = 'nissan_gtr_r34',
    [503] = 'nissan_gtr_r35',
    [562] = 'nissan_silvia_s15',
    [603] = 'porsche_911_carrera_s',
    [402] = 'porsche_panamera_turbo_s',
    [579] = 'range_rover_sva',
    [466] = 'rolls_royce_phantom',
    [508] = 'rolls_royce_wraith',
    [536] = 'skoda_octavia_vrs',
    [475] = 'subaru_impreza_wrx',
    [420] = 'toyota_camry_v70',
    [496] = 'toyota_gt86',
    [421] = 'toyota_lc_200',
    [491] = 'toyota_mark2',
    [587] = 'toyota_supra_a90',
    [527] = 'vaz_2101',
    [467] = 'vaz_2107',
    [567] = 'vaz_2109',
    [533] = 'vaz_2110',
    [545] = 'volkswagen_golf_mk1',
    [549] = 'volkswagen_passat_b3',
}

local vehicleReadableNames = {
    izh_2715 = 'Иж-2715',
    izh_2717 = 'Иж-27175',
    izh_oda_2717 = 'Иж-2717 «Ода-версия»',

    gazel_3302 = 'ГАЗ 3302 Газель',
    raf_2203 = 'РАФ-2203',
    gaz_3307 = 'ГАЗ 3307',
    gazon_next = 'Газон NEXT',
    vw_transporter = 'Volkswagen Transporter',
    mercedes_benz_sprinter = 'Mercedes-Benz Sprinter',

    iveco_stralis_500 = 'Iveco Stralis 500',
    volvo_fh12 = 'Volvo FH12',
    scania_r700 = 'Scania R700',
    kamaz_54115 = 'KAMAZ-54115',

    freightliner_columbia = 'Freightliner Columbia',
    kamaz_54901 = 'KAMAZ-54901',
    volvo_fh460 = 'Volvo FH460',

    alfa_romeo_giulia = 'Alfa Romeo Giulia',
    audi_q8rs = 'Audi SQ8',
    audi_r8 = 'Audi R8',
    audi_rs5 = 'Audi RS5',
    audi_rs6_avant_c8 = 'Audi RS6 Avant (C8)',
    audi_s8 = 'Audi S8',
    bantley_continental_gt = 'Bentley Continental GT',
    bentley_bentayga = 'Bentley Bentyaga',
    bmw_850_ci = 'BMW 850 Ci',
    bmw_e30 = 'BMW 323i (E30)',
    bmw_e34 = 'BMW 525i (E34)',
    bmw_e38 = 'BMW 750i (E38)',
    bmw_m3_e46 = 'BMW M3 (E46)',
    bmw_m3_touring_g81 = 'BMW M3 Touring (G81)',
    bmw_m4_g82 = 'BMW M4 (G82)',
    bmw_m5_e60 = 'BMW M5 (E60)',
    bmw_m5_f10 = 'BMW M5 (F10)',
    bmw_m5_f90 = 'BMW M5 (F90)',
    bmw_m8_competition = 'BMW M8 Competition Coupe (F92)',
    bmw_m760li = 'BMW M760Li xDrive (G12)',
    bmw_x5_e53 = 'BMW X5 (E53)',
    bmw_x5m_f85 = 'BMW X5M (F85)',
    bmw_x6m = 'BMW X6M (F86)',
    bugatti_chiron = 'Bugatti Chiron',
    bugatti_divo = 'Bugatti Divo',
    chevrolet_camaro_zl1 = 'Chevrolet Camaro ZL1',
    dodge_challenger_srt = 'Dodge Challenger SRT',
    dodge_ram_trx = 'Dodge RAM TRX',
    ferrari_488 = 'Ferrari 488',
    ferrari_sf90 = 'Ferrari SF90',
    gaz_volga_24 = 'ГАЗ-24 "Волга"',
    kia_k5 = 'KIA K5 GT',
    kia_rio = 'KIA Rio',
    koenigsegg_gemera = 'Koenigsegg Gemera',
    lada_priora_2170 = 'Lada Priora',
    lada_vesta = 'Lada Vesta',
    lamborghini_aventador_lp700 = 'Lamborghini Aventador LP700-4',
    lamborghini_urus = 'Lamborghini Urus',
    lexus_isf = 'Lexus ISF',
    mb_cls63_w218 = 'Mercedes CLS63 AMG (W218)',
    mb_e63_w212 = 'Mercedes-Benz E63 AMG (W212)',
    mb_e63s_w213 = 'Mercedes-Benz E63s AMG (W213)',
    mb_e63s_w223 = 'Mercedes-Benz S500 (W223)',
    mb_gt63s = 'Mercedes-Benz GT63s AMG ',
    mb_maybach_s650_x222 = 'Mercedes-Benz Maybach S650 (X222)',
    mb_w124 = 'Mercedes-Benz E500 (W124)',
    mb_g63_amg = 'Mercedes-Benz G63 AMG (W464)',
    mb_w140 = 'Mercedes-Benz 600SEL (W140)',
    mclaren_p1 = 'McLaren P1',
    mitsubishi_lancer_x = 'Mitsubishi Lancer Evolution X',
    nissan_370z = 'Nissan 370Z',
    nissan_gtr_r34 = 'Nissan Skyline GT-R (R34)',
    nissan_gtr_r35 = 'Nissan GT-R (R35)',
    nissan_silvia_s15 = 'Nissan Silvia S15',
    porsche_911_carrera_s = 'Porsche 911 Carrera S (992)',
    porsche_panamera_turbo_s = 'Porsche Panamera Turbo S Sport Turismo',
    range_rover_sva = 'Range Rover SVAutobiography',
    rolls_royce_phantom = 'Rolls Royce Phantom VIII',
    rolls_royce_wraith = 'Rolls Royce Wraith',
    skoda_octavia_vrs = 'Skoda Octavia VRS',
    subaru_impreza_wrx = 'Subaru Impreza WRX STI',
    toyota_camry_v70 = 'Toyota Camry V70',
    toyota_gt86 = 'Toyota GT86',
    toyota_lc_200 = 'Toyota Land Cruiser 200',
    toyota_mark2 = 'Toyota Mark II Tourer V (90JZX)',
    toyota_supra_a90 = 'Toyota Supra RG A90',
    vaz_2101 = 'ВАЗ 2101',
    vaz_2107 = 'ВАЗ 2107',
    vaz_2109 = 'ВАЗ 2109',
    vaz_2110 = 'ВАЗ 2110',
    volkswagen_golf_mk1 = 'Volkswagen Golf (Mk1)',
    volkswagen_passat_b3 = 'Volkswagen Passat GL (B3)',
}

--- Валидация модели
function isValidVehicleModel(model)
	if (not model or type(model) ~= 'number') then
		return false
	end
	return not not validVehicleModels[model]
end

--- Получить модель по названию
function getVehicleModelFromName(name)
	if (not name or type(name) ~= 'string') then
		return false
	end

    for model, currentName in pairs(vehicleModels) do
		if currentName == name then
			return model
		end
	end

    return false
end

--- Получить название по модели
function getVehicleNameFromModel(model)
    if (not model or type(model) ~= 'number') then
        return false
    end
    if (not isValidVehicleModel(model)) then
        outputDebugString('tmtaVehicle.getVehicleNameFromModel: invalid vehicle model', 1)
        return false
    end
    return vehicleModels[model]
end

--- Получить читаемое название по модели
function getVehicleReadableNameFromName(name)
    if (not name or type(name) ~= 'string') then
		return false
	end
    return vehicleReadableNames[name]
end

--- Получить список моделей
function getVehicleModels()
    return vehicleModels
end