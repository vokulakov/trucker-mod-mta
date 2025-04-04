Config = {}

Config.AUTOSAVE_INTERVAL = 10 -- время автосохранения в минутах

-- Const
Config.SELL_COMMISSION = 25 -- комиссия за продажу дома государству 
Config.PLAYER_MAX_HOUSES = 1 -- максимальное количество домов у игрока
Config.PROPERTY_TAX = 1 -- налог на недвижимость (в %)

Config.TAX_DAY = 7 -- день налога с момента покупки дома
Config.TAX_PAYMENT_PERIOD = 30 -- сколько дней дается на оплату налога

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