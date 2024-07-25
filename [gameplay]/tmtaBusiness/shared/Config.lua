Config = {}

Config.PLAYER_MAX_BUSINESS = 1 -- максимальное количество бизнесов у игрока
Config.PLAYER_REQUIRED_LVL = 7 -- требуемый уровень

Config.SELL_COMMISSION = 50 -- комиссия за продажу бизнеса государству (в %)
Config.WITHDRAWAL_FEE = 10 -- комиссия за снятие денег с баланса бизнеса (в %)

Config.ACCRUE_REVENUE_DAY = 7 -- день получения дохода/налога с момента покупки бизнеса

Config.REVENUE_TAX = 15 -- налог на прибыль (в %)
Config.TAX_PAYMENT_PERIOD = 3 -- сколько дней дается на оплату налога

Config.PICKUP_ID = 1274 -- ID пикапа

Config.businessTypeList = {
	{
		type = 1,
		name = 'Магазин 24/7',
		price = {3000000, 6000000}, -- минимальное/максимальное
		revenue = 1000000, -- доход
	},
	{
		type = 2,
		name = 'Магазин одежды',
		price = {3000000, 6000000},
		revenue = 1000000,
	},
	{
		type = 3,
		name = 'Закусочная',
		price = {3000000, 6000000},
		revenue = 1000000,
	},
	{
		type = 4,
		name = 'Автосервис',
		price = {3000000, 6000000},
		revenue = 1000000,
	},
	{
		type = 5,
		name = 'АЗС',
		price = {15000000, 20000000},
		revenue = 6900000,
	},
	{
		type = 6,
		name = 'Автосалон',
		price = {50000000, 70000000},
		revenue = 18100000,
	},
}