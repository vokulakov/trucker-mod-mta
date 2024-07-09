--[[
	##########################################################
	# @project: bengines
	# @author: brzys <brzysiekdev@gmail.com>
	# @filename: utils_s.lua
	# @description: utils to calculate proper engines for vehicles
	# All rights reserved.
	##########################################################
--]]

VEHICLES_TYPES = {
	["Bus"] = {431, 437},
	["Truck"] = {403, 406, 407, 408, 413, 414, 427, 432, 433, 443, 444, 455, 456,
				 498, 499, 514, 515, 524, 531, 544, 556, 557, 573, 578, 601, 609},
	["Sport"] = {411, 415, 424, 429, 451, 477, 480, 494, 495, 502, 503, 504, 506, 541, 555, 558, 589, 560,
						 562, 565, 568, 587, 602, 598},
	["Casual"] = {400, 401, 404, 405, 410, 416, 418, 420, 421, 422,
						  426, 436, 438, 440, 445, 458, 459, 470,
						  478, 479, 482, 489, 490, 491, 492, 496, 500, 505, 507, 516, 517, 518,
						  526, 527, 528, 529, 533, 540, 543, 546, 547, 549, 550, 551,
						  554, 561, 566, 579, 580, 585, 597, 596, 599, 600, 604, 605,
						  536, 575, 534, 567, 535, 576, 412},
	["Muscle"] = {474, 545, 466, 467, 439, 542, 603, 475, 419, 402},
	["Plane"] = {592, 577, 511, 548, 512, 593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513},
	["Boat"] = {472, 473, 493, 595, 484, 430, 453, 452, 446, 454},
	["Motorbike"] = {481, 462, 521, 463, 522, 461, 448, 468, 586, 471, 581}
}

CLASSES = {
	[{0, 200}] = "E",
	[{200, 400}] = "D",
	[{400, 600}] = "C",
	[{600, 800}] = "B",
	[{800, 1000000000}] = "A",
}

-- Отстрелы
VEHICLES_BLOWOFF_ENABLED = { -- на каких моделях должны работать
	[429] = true, [602] = true, [589] = true, [490] = true, [521] = true, [471] = true, [506] = true, [604] = true, [555] = true,
	[420] = true, [582] = true, [418] = true, [412] = true, [405] = true, [581] = true, [579] = true, [559] = true, [542] = true,
	[560] = true, [554] = true, [552] = true, [495] = true, [404] = true, [528] = true, [477] = true, [499] = true, [490] = true,
	[541] = true, [502] = true, [503] = true, [566] = true, [540] = true, [492] = true, [580] = true, [516] = true, [445] = true,
	[466] = true, [596] = true, [597] = true, [550] = true, [562] = true, [422] = true, [426] = true, [504] = true, [529] = true,
	[585] = true, [412] = true, [419] = true, [518] = true, [400] = true, [474] = true, [526] = true, [567] = true, [547] = true,
	[405] = true, [546] = true, [467] = true, [402] = true, [470] = true, [587] = true, [401] = true, [561] = true, [507] = true,
	[545] = true, [496] = true, [149] = true, 
	
	[74] = true, [208] = true, [329] = true, [332] = true, [340] = true,  [382] = true,  [383] = true,  [468] = true, [479] = true,
}

VEHICLES_BLOWOFF_POSITION = { -- позиция отстрелов

	[429] = { -- buggati
		{ x = -0.14, y = -2.55, z = -0.31 },
		{ x = 0.14, y = -2.55, z = -0.31 }
	},
	
	[402] = { -- BMW M4 G82
		{ x = -0.33, y = -2.36, z = -0.27 },
		{ x = 0.33, y = -2.36, z = -0.27 },
	},
}

-- Команда для получения координат выхлопа
addCommandHandler('fumes', function(player)
	if isElement(player) or not localPlayer then
		return
	end
	local vehicle = localPlayer.vehicle
	if not isElement(vehicle) then
		return
	end
	local fumesPositionX, fumesPositionY, fumesPositionZ = getVehicleModelExhaustFumesPosition(vehicle.model)
	local position = string.format("{ x = %.2f, y = %.2f, z = %.2f }", fumesPositionX, fumesPositionY, fumesPositionZ)
	setClipboard(position)
	outputChatBox("Позиция выхлопа "..position.." скопирована в буфер обмена", 0, 255, 0, true)
end)

MAX_VELOCITY = {
	[400] = 150,
	[401] = 140,
	[402] = 178,
	[404] = 126,
	[405] = 156,
	[409] = 150,
	[410] = 123,
	[411] = 210,
	[412] = 161,
	[415] = 182,
	[418] = 110,
	[419] = 142,
	[421] = 246,
	[422] = 134,
	[424] = 128,
	[426] = 165,
	[429] = 192,
	[434] = 159,
	[436] = 142,
	[439] = 160,
	[445] = 156,
	[451] = 182,
	[458] = 150,
	[461] = 153,
	[463] = 138,
	[466] = 140,
	[467] = 134,
	[468] = 138,
	[471] = 102,
	[474] = 142,
	[475] = 165,
	[477] = 178,
	[478] = 112,
	[479] = 133,
	[480] = 178,
	[482] = 149,
	[483] = 118,
	[489] = 133,
	[491] = 142,
	[492] = 134,
	[495] = 168,
	[496] = 155,
	[500] = 134,
	[506] = 170,
	[507] = 158,
	[508] = 102,
	[516] = 150,
	[517] = 150,
	[518] = 158,
	[521] = 154,
	[526] = 150,
	[527] = 142,
	[529] = 142,
	[533] = 159,
	[534] = 161,
	[535] = 150,
	[536] = 165,
	[540] = 142,
	[541] = 192,
	[542] = 156,
	[543] = 144,
	[545] = 140,
	[546] = 142,
	[547] = 136,
	[549] = 146,
	[550] = 138,
	[551] = 150,
	[554] = 137,
	[555] = 150,
	[558] = 162,
	[559] = 169,
	[560] = 169,
	[561] = 146,
	[562] = 173,
	[565] = 165,
	[566] = 152,
	[567] = 165,
	[575] = 150,
	[576] = 150,
	[579] = 150,
	[580] = 145,
	[581] = 145,
	[585] = 145,
	[586] = 138,
	[587] = 157,
	[589] = 155,
	[600] = 144,
	[602] = 169,
	[603] = 163,
	[522] = 210,
}
function getVehicleMaxVelocity(model)
	return MAX_VELOCITY[model] or 0
end 

function getVehicleTypeByModel(model)
	for type, models in pairs(VEHICLES_TYPES) do 
		for _, mdl in pairs(models) do 
			if mdl == model then 
				return type
			end
		end
	end 
	
	return "Casual"
end

function calculateVehicleClass(vehicle)
	local handling = nil
	local v_type = nil
	if type(vehicle) == "number" then 
		handling = getOriginalHandling(vehicle)
		v_type = getVehicleTypeByModel(vehicle)
	else 
		handling = getVehicleHandling(vehicle)
		v_type = getElementData(vehicle, "vehicle:type")
	end
	
	-- engine
	local acc = handling.engineAcceleration 
	local vel = handling.maxVelocity
	local drag = handling.dragCoeff
	local c = (acc / drag / vel)
	if v_type == "Casual" then 
		c = c-0.010
	elseif v_type == "Sport" then 
		c =c-0.005
	elseif v_type == "Muscle" then 
		c = c-0.02
	elseif v_type == "Truck" then 
		c =c+0.01
	end
	
	-- steering
	local turnMass = handling.turnMass 
	local mass = handling.mass 
	local traction = handling.tractionLoss
	c = c - (turnMass/mass/traction)*0.001 
	
	return math.ceil(c*(10^4.54))
end

function getVehicleClass(vehicle)
	local class = calculateVehicleClass(vehicle)
	for required, name in pairs (CLASSES) do 
		if class >= required[1] and class <= required[2] then 
			return name
		end
	end
	
	return "E"
end 

if getModelHandling then
	for name, models in pairs(VEHICLES_TYPES) do 
		table.sort(models, function(a, b)
			return calculateVehicleClass(a) > calculateVehicleClass(b)
		end)	
	end

	--[[
	for name, models in pairs(VEHICLES_TYPES) do 
		outputChatBox("Najgorszy z "..name..": "..models[#models])
		outputChatBox("Najlepszy z "..name..": "..models[1])
	end 
	--]]
	
	function getBestVehicleClassByType(type)
		if type then 
			return VEHICLES_TYPES[type][1]
		end
	end 	
end