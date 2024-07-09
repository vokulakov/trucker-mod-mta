local gRoot = getRootElement();
local screen = {guiGetScreenSize()};
local tp_pos = {
	-- { name = "Склад №1", position = { x = -29.184090, y = -1123.820435, z = 1.078125 }},
    -- { name = "Склад №2", position = { x = 2155.457031, y = -2291.581299, z = 13.408688 }},
    -- { name = "Склад №3", position = { x = -520.360413, y = -500.661072, z = 24.990295 }},
    -- { name = "Склад №4", position = { x = 1022.215149, y = 2266.558838, z = 10.820312 }},
	-- { name = "Склад №5", position = { x = 1076.742798, y = 1892.624512, z = 10.820312 }},
    -- { name = "Склад №6", position = { x = 1635.437988, y = 2340.324707, z = 10.489252 }},
    -- { name = "Склад №7", position = { x = 1476.478271, y = 2369.887451, z = 10.820312 }},
    -- { name = "Склад №8", position = { x = 2261.698730, y = 2748.046143, z = 10.820312 }},
    -- { name = "Склад №9", position = { x = 2842.369873, y = 996.828247, z = 10.750000 }},
    -- { name = "Склад №10", position = { x = 1697.538086, y = 918.256042, z = 10.820312 }},
    -- { name = "Склад №11", position = { x = 1423.015991, y = 1066.709717, z = 10.476850 }},
    -- { name = "Склад №12", position = { x = 1725.102661, y = 730.192566, z = 10.820312 }},
    -- { name = "Склад №13", position = { x = 1748.605469, y = 2242.600342, z = 10.820312 }},
    -- { name = "Склад №14", position = { x = 2715.452881, y = -2808.203613, z = 13.546875 }},
    -- { name = "Склад №15", position = { x = 52.266830, y = -286.518005, z = 1.695724 }},
    -- { name = "Склад №16", position = { x = 251.415009, y = -218.031662, z = 1.578125 }},
    -- { name = "Склад №17", position = { x = 830.416992, y = -611.078857, z = 16.335938 }},

	--{ name = "1", position = { x = 2060.671387, y = 2264.524414, z = 10.337642 }}, -- LV
	--{ name = "2", position = { x = 2060.839111, y = 2251.056152, z = 10.323627 }}, -- LV
	--{ name = "3", position = { x = 2061.238770, y = 2238.152588, z = 10.290233 }}, -- LV
	--{ name = "4", position = { x = -1944.616821, y = -1084.584473, z = 30.773438 }}, -- SF (Foster Valley)
	--{ name = "5", position = { x = 314.920258, y = -244.973816, z = 1.578125 }}, -- Blueberry (Red Country)
	--{ name = "Solarin Indudstries", position = { x = 853.07867431641, y = -568.69482421875, z = 17.041128158569 } },
	--{ name = "Storage BM", position = { x = -2282.3894042969, y = 2283.3525390625, z = 4.9704856872559 } },
	--{ name = "Storage BM 1", position = { x = -2431.6862792969, y = 2300.1247558594, z = 4.9821910858154 } },
	--{ name = "6", position = { x = -1492.163696, y = 2695.485107, z = 55.846874 }}, -- какой то минисклад  Tierra Robada
    -- { x = -1823.406250, y = 2.896060, z = 15.117188 } -- solarin industrial

	-- {"Los Santos, Mulholland Intersection |  bank |  Bank of America",	1469.7022705078, -1046.9166259766, 23.832366943359};
	-- {"Red County, Palomino Creek |  bank |  Bank Polomino Creek",	2301.0615234375, -15.232839584351, 26.484375};
	-- {"Los Santos, Rodeo |  bank |  CB Bank",	594.87365722656, -1239.7028808594, 17.99535369873};
	-- {"Los Santos, Commerce |  bank |  First Republic Bank",	1431.5863037109, -1486.2075195313, 20.429838180542};
	-- {"Los Santos, Downtown Los Santos |  bank |  SA Bank Tower",	1579.0372314453, -1327.9857177734, 16.484375};
	-- {"Los Santos, Ganton |  bar |  Ten Green Bottles",	2307.5744628906, -1647.4056396484, 14.827047348022};
	-- {"Los Santos, Temple |  cafe |  Burger Shot",	1198.5173339844, -923.42749023438, 43.035179138184};
	-- {"Los Santos, Marina |  cafe |  Burger Shot",	817.27557373047, -1618.0792236328, 13.82511806488};
	-- {"San Fierro, Garcia |  cafe |  Burger Shot",	-2334.5073242188, -167.4732208252, 35.5546875};
	-- {"San Fierro, Downtown |  cafe |  Burger Shot",	-1912.0101318359, 829.31781005859, 35.178951263428};
	-- {"San Fierro, Juniper Hollow |  cafe |  Burger Shot",	-2359.2504882813, 1008.1652832031, 50.6953125};
	-- {"Whetstone, Angel Pine |  cafe |  Cluckin Bell",	-2152.0085449219, -2463.9184570313, 30.84375};
	-- {"Los Santos, Willowfield |  cafe |  Cluckin Bell",	2397.6401367188, -1896.1461181641, 13.3828125};
	-- {"Los Santos, East Los Santos |  cafe |  Cluckin Bell",	2423.84375, -1509.2326660156, 23.992208480835};
	-- {"Los Santos, Market |  cafe |  Cluckin Bell",	926.13220214844, -1352.9737548828, 13.376754760742};
	-- {"San Fierro, Downtown |  cafe |  Cluckin Bell",	-1816.2913818359, 615.19360351563, 35.171875};
	-- {"San Fierro, Ocean Flats |  cafe |  Cluckin Bell",	-2671.7155761719, 264.01913452148, 4.6328125};
	-- {"Los Santos, Market |  cafe |  Jims Ring",	1038.2893066406, -1337.7701416016, 13.7265625};
	-- {"Red County, Dillimore |  cafe |  The Welcome Pump",	681.20263671875, -481.63214111328, 16.1875};
	-- {"Red County, Montgomery |  cafe |  The Well Stacked Pizza Co.",	1356.4122314453, 253.54023742676, 19.5546875};
	-- {"Red County, Blueberry |  cafe |  The Well Stacked Pizza Co.",	203.75723266602, -207.05776977539, 1.4355098009109};
	-- {"Los Santos, Idlewood |  cafe |  The Well Stacked Pizza Co.",	2094.1276855469, -1806.3448486328, 13.550287246704};
	-- {"Red County, Palomino Creek |  cafe |  The Well Stacked Pizza Co.",	2337.5053710938, 75.482917785645, 26.479633331299};
	-- {"San Fierro, Financial |  cafe |  The Well Stacked Pizza Co.",	-1804.0396728516, 942.36138916016, 24.890625};
	-- {"San Fierro, Esplanade North |  cafe |  The Well Stacked Pizza Co.",	-1723.3764648438, 1358.900390625, 7.1875};
	-- {"San Fierro, Palisades |  cafe |  TUFF NUT Donuts",	-2760.5856933594, 789.84704589844, 53.718124389648};
	-- {"Los Santos, Temple |  cars |  Pay N Spray",	1025.0375976563, -1032.0297851563, 31.9391040802};
	-- {"Los Santos, Idlewood |  cars |  Pay N Spray",	2076.0617675781, -1831.7136230469, 13.554534912109};
	-- {"Red County, Dillimore |  cars |  Pay N Spray",	720.47552490234, -472.46984863281, 16.343704223633};
	-- {"San Fierro, Downtown |  cars |  Pay N Spray",	-1905.4655761719, 273.86798095703, 41.046875};
	-- {"San Fierro, Juniper Hollow |  cars |  Pay N Spray",	-2424.5905761719, 1033.6999511719, 50.390625};
	-- {"Los Santos, Temple |  cars |  Trans Fender",	1040.9158935547, -1030.7067871094, 32.074813842773};
	-- {"San Fierro, Doherty |  cars |  Trans Fender",	-1934.5124511719, 235.79109191895, 34.3125};
	-- {"San Fierro, Downtown |  cars |  Wang Cars",	-1974.2368164063, 289.02734375, 35.171875};
	-- {"San Fierro, Ocean Flats |  cars |  Wheel Arch Angels",	-2710.8947753906, 217.74723815918, 4.1796875};
	-- {"Los Santos, Jefferson |  carshop |  Coutt And Schutz",	2130.7663574219, -1134.8145751953, 25.663595199585};
	-- {"Los Santos, Rodeo |  carshop |  GROTTI",	533.33673095703, -1288.8433837891, 17.2421875};
	-- {"San Fierro, Downtown |  carshop |  Ottos Autos",	-1640.1629638672, 1203.6312255859, 7.2361707687378};
	-- {"Los Santos, Idlewood |  club |  Alhambra",	1832.9885253906, -1682.7487792969, 13.49210357666};
	-- {"Red County, Blueberry Acres |  farm |  Farm Blueberry Acres",	-114.16786193848, 14.807187080383, 3.1171875};
	-- {"Flint County, The Farm |  farm |  Farm Flint County", -1053.8267822266, -1199.3687744141, 129.01573181152};
	-- {"Flint County, Flint Range |  farm |  Farm Flint Range",	-377.80032348633, -1414.0916748047, 25.7265625};
	-- {"Red County, Hilltop Farm |  farm |  Farm Hilltop",	1055.1140136719, -340.36581420898, 73.9921875};
	-- {"Flint County, Leafy Hollow |  farm |  Farm Leafy Hollow",	-1098.8885498047, -1637.5687255859, 76.3671875};
	-- {"Red County, Red County |  farm |  Farm Red County",	1929.826171875, 172.61642456055, 37.28125};
	-- {"Whetstone, Whetstone |  farm |  Farm Wheststone",	-1409.5124511719, -1474.7406005859, 101.72004699707};
	-- {"Los Santos, Commerce |  fd |  San Andreas Fire Department LS",	1747.47265625, -1455.7124023438, 13.546875};
	-- {"San Fierro, Doherty |  fd |  San Andreas Fire Department SF",	-2017.7902832031, 66.25318145752, 28.9748878479};
	-- {"Whetstone, Angel Pine |  gas station |  Gas",	-2242.1452636719, -2557.7392578125, 31.921875};
	-- {"Red County, Dillimore |  gas station |  Gasso",	658.49011230469, -585.48876953125, 16.3359375};
	-- {"Flint County, Flint County |  gas station |  Golng gas (shop)",	-87.290229797363, -1169.4818115234, 2.3359832763672};
	-- {"Los Santos, Idlewood |  gas station |  Golng gas (shop)",	1936.9913330078, -1775.7116699219, 13.3828125};
	-- {"Los Santos, Mulholland |  gas station |  Golng gas (shop)",	996.3544921875, -923.42218017578, 42.1796875};
	-- {"Red County, Montgomery |  gas station |  Tosser",	1386.8690185547, 457.34106445313, 24.145202636719};
	-- {"Whetstone, Whetstone |  gas station |  Xoomer (shop)",	-1577.4600830078, -2735.2893066406, 48.533473968506};
	-- {"San Fierro, Easter Basin |  gas station |  Xoomer (shop)",	-1675.0852050781, 413.59442138672, 7.1796875};
	-- {"San Fierro, Juniper Hollow |  gas station |  Xoomer (shop)",	-2406.7917480469, 968.40014648438, 45.301616668701};
	-- {"San Fierro, Doherty |  gas station |  Xoomer (garage)",	-2022.0408935547, 159.02221679688, 28.8359375};
	-- {"San Fierro, City Hall |  goverment |  City Hall San Fierro",	-2763.927734375, 375.85546875, 6.2360782623291};
	-- {"Los Santos, Los Santos International |  goverment |  Airport LS",	1960.9287109375, -2185.5217285156, 13.546875};
	-- {"San Fierro, Easter Bay Airport |  goverment |  Airport San Fierro",	-1550.3557128906, -435.96621704102, 6};
	-- {"San Fierro, Doherty |  goverment |  Autoschool",	-2026.9495849609, -97.192153930664, 35.1640625};
	-- {"Los Santos, Commerce |  goverment |  City Hall Los Santos",	1480.8232421875, -1766.4490966797, 18.795755386353};
	-- {"Los Santos, Rodeo |  goverment |  Interglobal Television",	644.21575927734, -1356.7564697266, 13.567251205444};
	-- {"Los Santos, Conference Center |  goverment |  Los Santos Convention Center",	1198.7340087891, -1738.6669921875, 13.583253860474};
	-- {"Los Santos, Market |  hospital |  All Saints General Hospital",	1183.1104736328, -1324.2894287109, 13.577887535095};
	-- {"Los Santos, Jefferson |  hospital |  County Central",	2028.0838623047, -1420.7009277344, 16.9921875};
	-- {"Red County, Montgomery |  hospital |  Crippen Memorial",	1249.6818847656, 339.8249206543, 19.40625};
	-- {"Whetstone, Angel Pine |  hospital |  Medical Center Angel Pine",	-2191.8359375, -2293.2043457031, 30.625};
	-- {"San Fierro, Santa Flora |  hospital |  San Fierro Medical Center",	-2662.716796875, 630.88464355469, 14.453125};
	-- {"San Fierro, Doherty |  industrial |  стройка",	-2106.5983886719, 208.19058227539, 35.248222351074};
	-- {"Whetstone, Whetstone |  industrial |  Angel Pine Junkyard (Свалка)",	-1816.3450927734, -1639.0743408203, 22.279537200928};
	-- {"San Fierro, Easter Basin |  industrial |  Docks San Fierro",	-1695.1788330078, 42.901290893555, 3.5546875};
	-- {"Red County, Blueberry Acres |  industrial |  Fleisch Berg (Завод)",	-92.165924072266, -200.67123413086, 24.834213256836};
	-- {"Los Santos, Willowfield |  industrial |  Los Santos Junkyard (Свалка)",	2191.7619628906, -1978.3238525391, 13.552426338196};
	-- {"Whetstone, Angel Pine |  industrial |  Sawmill Angel Pine",	-2065.9274902344, -2362.6201171875, 30.631776809692};
	-- {"Red County, The Panopticon |  Industrial |  Sawmill Red County",	-517.75610351563, -186.4681854248, 78.049575805664};
	-- {"San Fierro, Doherty |  industrial |  Solarin Indudstries",	-1825.5747070313, 55.874164581299, 15.122790336609};
	-- {"Red County, Montgomery |  Industrial |  Sprunk",	1341.3046875, 284.0198059082, 19.561452865601};
	-- {"Red County, Easter Bay Chemicals |  industrial |  Tank Farm (Нефтебаза)",	-1029.4907226563, -625.87353515625, 32.0078125};
	-- {"Los Santos, Ocean Docks |  industrial |  Tank Farm (Нефтебаза)",	2514.962890625, -2103.5498046875, 13.546875};
	-- {"Los Santos, Ganton |  other |  Gym LS",	2228.8068847656, -1722.1674804688, 13.5625};
	-- {"San Fierro, Garcia |  other |  Gym SF",	-2268.6958007813, -155.54769897461, 35.3203125};
	-- {"Los Santos, East Los Santos |  other |  PigPen",	2421.4228515625, -1225.6392822266, 25.123680114746};
	-- {"San Fierro, Queens |  pd |  FBI",	-2440.5900878906, 505.65344238281, 29.944828033447};
	-- {"Los Santos, Pershing Square |  pd |  Police Department Los Santos",	1553.2481689453, -1675.4580078125, 16.1953125};
	-- {"Red County, Dillimore |  pd |  Police Department Red County",	634.62786865234, -571.13098144531, 16.3359375};
	-- {"San Fierro, Downtown |  pd |  San Fierro Police Department",	-1613.0916748047, 721.23010253906, 13.33723449707};
	-- {"Whetstone, Angel Pine |  pd |  Sherif Angel Pine",	-2166.7321777344, -2390.0874023438, 30.46875};
	-- {"Los Santos, Idlewood |  shop |  69C",	1830.3361816406, -1842.5222167969, 13.578125};
	-- {"Los Santos, Rodeo |  shop |  Aeris",	484.42724609375, -1534.8023681641, 19.358598709106};
	-- {"Whetstone, Angel Pine |  shop |  Ammu-Nation",	-2092.4660644531, -2463.4680175781, 30.625};
	-- {"Los Santos, Market |  shop |  Ammu-Nation",	1363.5589599609, -1279.5343017578, 13.546875};
	-- {"Red County, Palomino Creek |  shop |  Ammu-Nation",	2337.7290039063, 62.64249420166, 26.479305267334};
	-- {"Red County, Blueberry |  shop |  Ammu-Nation",	240.83488464355, -178.37939453125, 1.578125};
	-- {"Los Santos, Willowfield |  shop |  Ammu-Nation",	2400.7290039063, -1981.0944824219, 13.546875};
	-- {"Los Santos, Rodeo |  shop |  BANCH",	461.12530517578, -1572.7474365234, 25.4765625};
	-- {"Los Santos, Ganton |  shop |  Barber salon",	2265.6010742188, -1667.9587402344, 15.39724445343};
	-- {"Los Santos, Ganton |  shop |  Binco",	2244.9077148438, -1664.0207519531, 15.4765625};
	-- {"San Fierro, Juniper Hill |  shop |  Binco",	-2376.0380859375, 910.48553466797, 45.4453125};
	-- {"Los Santos, Marina |  shop |  BOBO",	819.54895019531, -1759.5096435547, 13.546875};
	-- {"Whetstone, Angel Pine |  shop |  LIQUOR",	-2104.4755859375, -2434.1748046875, 30.625};
	-- {"Red County, Blueberry |  shop |  LIQUOR",	254.94573974609, -65.03441619873, 1.578125};
	-- {"Los Santos, Rodeo |  shop |  Prolaps",	501.58151245117, -1356.5880126953, 16.1328125};
	-- {"Los Santos, Mulholland |  shop |  Robois food mart",	1315.8713378906, -902.1005859375, 39.437969207764};
	-- {"Los Santos, Commerce |  shop |  Robois food mart",	1352.3542480469, -1753.7230224609, 13.353359222412};
	-- {"Los Santos, Jefferson |  shop |  Sub Urban",	2112.7758789063, -1214.6943359375, 23.967609405518};
	-- {"San Fierro, Hashbury |  shop |  SubUrban",	-2494.658203125, -29.097787857056, 25.765625};
	-- {"San Fierro, Juniper Hill |  shop |  SupraSave",	-2442.6091308594, 751.79510498047, 35.17862701416};
	-- {"Los Santos, East Los Santos |  shop |  Ten Green Bottles",	2348.8774414063, -1374.8992919922, 24};
	-- {"Los Santos, Market |  shop |  Verona Mall",	1126.6153564453, -1427.4769287109, 15.796875};
	-- {"Los Santos, Rodeo |  shop |  Victim",	455.97125244141, -1501.6522216797, 31.041015625};
	-- {"San Fierro, San Fierro |  shop |  Victim",	-1700.345703125, 944.8544921875, 24.890625};
	-- {"San Fierro, Downtown |  shop |  ZIP",	-1885.3913574219, 862.73083496094, 35.171875};
	-- {"Red County, Montgomery |  storage |  BioEnginering",	1343.3371582031, 349.76931762695, 19.5546875};
	-- {"Los Santos, Ocean Docks |  storage |  Docks",	2590.1892089844, -2403.3054199219, 13.625091552734};
	-- {"Flint County, Flint County |  storage |  RS Haul",	-85.847999572754, -1124.7355957031, 1.078125};
	-- {"Red County, Dillimore |  storage |  Solarin Indudstries",	853.07867431641, -568.69482421875, 17.041128158569};
	-- {"Los Santos, Ocean Docks |  storage |  Storage box ocean",	2190.5422363281, -2264.8759765625, 13.527984619141};
	-- {"Red County, Fallen Tree |  storage |  Storage Fallen Tree",	-493.41079711914, -538.94213867188, 25.5234375}
}

function tp_menu()
	tabTp = guiCreateTab("Teleport", tabPanel)

	buttonTp = guiCreateButton(10, 290, 480, 30, "Teleport", false, tabTp);
	gridlist = guiCreateGridList(10, 10, 480, 270, false, tabTp);
	guiGridListAddColumn(gridlist, "Positions", 0.9);
	for key, teleports in pairs(tp_pos) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, teleports.name, false, false)
		guiGridListSetItemData(gridlist, row, 1, { x = teleports.position.x, y = teleports.position.y, z = teleports.position.z})
	end
	addEventHandler("onClientGUIClick", buttonTp, btn_tp);
end
addEventHandler("onClientResourceStart", resourceRoot, tp_menu);

function btn_tp(btn)
	local vehicle = getPedOccupiedVehicle(localPlayer);
	local tpPos = guiGridListGetItemData(gridlist, guiGridListGetSelectedItem(gridlist), 1)
	if (tpPos) then
		fadeCamera(false, 1.0)
		setTimer(fadeCamera, 1000, 1, true)
		setTimer(setElementPosition, 1000, 1, localPlayer, tpPos.x, tpPos.y, tpPos.z)
		if vehicle then
			setTimer(setElementPosition, 1000, 1, vehicle, tpPos.x, tpPos.y, tpPos.z)
		end
	end
end