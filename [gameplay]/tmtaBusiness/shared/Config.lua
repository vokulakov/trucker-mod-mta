Config = {}

Config.MAX_BUSINESS = 2 -- максимальное количество бизнесов у игрока
Config.SELL_COMMISSION = 50 -- комиссия за продажу бизнеса государству (в %)
Config.WITHDRAW_MONEY_COMMISSION = 10 -- комиссия за снятие денег с баланса бизнеса (в %)

Config.INCOME_TAX = 15 -- налог на прибыль (в %)
Config.TAX_GRACE_PERIOD = 3 -- сколько можно не оплачивать налог (в неделях)

Config.businessType = {
	{
		name = 'Магазин 24/7',
		price = {3000000, 6000000},
	},
	{
		name = 'Магазин одежды',
		price = {3000000, 6000000},
	},
	{
		name = 'АЗС',
		price = {15000000, 20000000},
	},
	{
		name = 'Закусочная',
		price = {3000000, 6000000},
	},
	{
		name = 'Автосервис',
		price = {3000000, 6000000},
	},
	{
		name = 'Автосалон',
		price = {50000000, 70000000},
	},
}

Config.upgrades = {}

function getConfigSetting(name)
	return Config[name]
end

