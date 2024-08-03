componentsFromData = {
	["FrontBump"] 	= "Передний бампер",
	["RearBump"]	= "Задний бампер", 
	["Bonnets"]		= "Капот",
	["SideSkirts"]	= "Юбки",
	["RearLights"] 	= "Задние фары",
	["FrontLights"] = "Передние фары",
	["FrontPovorots"] = "Передние поворотники",
	["FrontFends"]	= "Передние фендеры",
	["RearFends"]	= "Задние фендеры",
	["Acces"]		= "Аксессуары",
	["Spoilers"]	= "Спойлер",
	["Priborka"]	= "Приборная панель",
	["Salon"]	= "Салон",
	["Exhaust"]		= "Глушитель",
	["Dvigatel"]	= "Двигатель",
	["Resh"]		= "Решётка",
	["Diffuzor"]	= "Диффузор",
	["Splitter"]	= "Сплитер",
	["Fenders"]	= "Фендеры",
	["RightDoorMirror"]	= "Правые зеркала",
	["LeftDoorMirror"]	= "Левые зекрала",	
	["Skits"]	= "Пороги",
	["Acces"]		= "Аксессуары",
	["Roof"]	= "Крыша",
	["Resh"]	= "Решётка",
	["Skirts"]	= "Пороги",
	["Interior"]	= "Интерьер",
	["NakladkaFar"]	= "Накладка на фары",
	["RearDef"]		= "Фендер заднего бампера",
	["FrontDef"]	= "Фендер переднего бампера",
	["Bagazh"]	= "Багажник",
	["Badge"]	= "Багажник",
	["Grills"]	= "Решётка",
	["Hood"]	= "Верх",
    ["bumper_f"]      = "Передний бампер",
    ["bumper_r"]      = "Задний бампер",
    ["skirts"]        = "Боковые юбки",
    ["fenders_f"]     = "Передние фендеры",
    ["fenders_r"]     = "Задние фендеры",
    ["misc"]          = "Прочее",
    ["head_lights"]   = "Передние фары",
    ["tail_lights"]   = "Задние фары",
    ["scoop"]         = "Детали крыши",
    ["bonnet"]        = "Капот",
    ["spoiler"]       = "Спойлер",
    ["trunk"]         = "Багажник",
    ["trunk_badge"]   = "Шильдики",
    ["wheels"]        = "Диски",
    ["splitter"]      = "Сплиттер",
    ["diffuser"]      = "Диффузор",
    ["interior"]      = "Салон",
    ["interiorparts"] = "Части салона",
    ["kit"]           = "Комплекты",
    ["licence_frame"] = "Номерная рамка",
    ["door_pside_f"]  = "Правая передняя дверь",
    ["door_dside_f"]  = "Левая передняя дверь",
    ["door_pside_r"]  = "Левая задняя дверь",
    ["door_dside_r"]  = "Правая задняя дверь",
    ["wheels_config"] = "Настройка колёс",
    ["sgu_config"] 	  = "СГУ",
    ["bonnet_attach"] = "Накладки на капот",
    ["wheels_tire"]   = "Производитель резины",
    ["xenon"]         = "Ксенон",
	["exhaust"]		  = "Выхлоп",

}

motoTable = {
	[523] = true,
}

upgradesFromData = {
	["Spoilers"] = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}
}

tableComponents = {
    --[[
	[543] = {--ВАЗ 2121 "Нива"
		["FrontBump"] = {
			{"FrontBump0", "Stock", 8000},
			{"FrontBump1", "Urban", 10000},
			{"FrontBump2", "Off Road", 12000},
			{"FrontBump3", "G65", 13000},
		},
		["RearBump"] = {
			{"RearBump0", "Stock", 5000},
			{"RearBump1", "Urban", 10000},
			{"RearBump2", "Off Road", 21000},
			{"RearBump3", "G65", 12000},
		},
		["Fenders"] = {
			{"Fenders0", "Stock", 8000},
			{"Fenders1", "Off Road", 12000},
			{"Fenders2", "G65", 14000},
		},
		["Resh"] = {
			{"Resh0", "Stock", 10000},
			{"Resh1", "Hamann", 15000},
			{"Resh2", "Убрать крылышки", 18000},
		},
		["Bonnets"] = {
			{"Bonnets0", "Stock", 9000},
			{"Bonnets1", "G65", 10000},
		},
		["FrontPovorots"] = {
			{"FrontPovorots0", "Stock", 9000},
			{"FrontPovorots1", "Urban", 10000},
		},
		["Skirts"] = {
			{"Skirts0", "Убрать", 9000},
			{"Skirts1", "G65", 10000},
		},
		["Acces"] = {
			{"Acces0", "Stock", 8000},
			{"Acces1", "Шнорхель", 8000},
		},
		["RearLights"] = {
			{"RearLights0", "Stock", 8000},
			{"RearLights1", "Urban", 9000},
		},
		["FrontLights"] = {
			{"FrontLights0", "Stock", 8000},
			{"FrontLights1", "Urban", 9000},
			{"FrontLights2", "G65", 10000},
		},
		["Roof"] = {
			{"Roof0", "Убрать", 8000},
			{"Roof1", "Багажник", 10000},
			{"Roof2", "Спойлер G65", 12000},
		},
		["Interior"] = {
			{"Interior0", "Сидения", 10000},
			{"Interior1", "Аккустическая система", 18000},
		},
		["RightDoorMirror"] = {
			{"RightDoorMirror0", "Stock", 8000},
			{"RightDoorMirror1", "G65", 10000},
		},
		["LeftDoorMirror"] = {
			{"LeftDoorMirror0", "Stock", 8000},
			{"LeftDoorMirror1", "G65", 10000},
		},
	},
    ]]
}

-- Exports
getComponents = function() return componentsFromData end