Config = {}

-- Const
Config.SELL_COMMISSION = 0.5 -- комиссия за продажу дома государству 
Config.PLAYER_MAX_HOUSES = 3 -- максимальное количество домов у игрока
Config.PROPERTY_TAX = 0.13 -- налог на имущество

-- communal payments

Config.upgrades = {
}


-- Количество парковочнх мест взависимости от стоимости дома
-- Максимум 10 парковочных мест
Config.parkingSpacesDependingOnprice = {
    { parkingSpaces = 1, minPrice = 250000 },
    { parkingSpaces = 2, minPrice = 1000000 },
    { parkingSpaces = 3, minPrice = 1200000 },
    { parkingSpaces = 5, minPrice = 2000000 },
    { parkingSpaces = 6, minPrice = 4000000 },
    { parkingSpaces = 8, minPrice = 10000000 },
    { parkingSpaces = 10, minPrice = 50000000 },
}

-- В зависимости от количества парковочных мест, разделяется на классы
Config.houseClass = {
	{ parkingSpaces = 1, class = 'эконом' },
    { parkingSpaces = 3, class = 'низкий' },
	{ parkingSpaces = 6, class = 'средний' },
	{ parkingSpaces = 8, class = 'высокий' },
	{ parkingSpaces = 10, class = 'люкс' },
}