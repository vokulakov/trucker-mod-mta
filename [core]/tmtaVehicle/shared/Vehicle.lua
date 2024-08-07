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
	vehicleIDs[model] = true
end

-- Краткие названия для использования в коде вместо ID
local vehicleModels = {
    [439] = 'vaz_2110',
}

local vehicleReadableNames = {
    vaz_2110 = 'ВАЗ 2110',
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
    return exports.tmtaUtils:tableReverse(vehicleModels)
end