Config = {}

Config.MAX_BUSINESS = 2 -- максимальное количество бизнесов у игрока
Config.SELL_COMMISSION = 50 -- комиссия за продажу бизнеса государству (в %)
Config.WITHDRAW_MONEY_COMMISSION = 10 -- комиссия за снятие денег с баланса бизнеса (в %)

Config.INCOME_TAX = 15 -- налог на прибыль (в %)
Config.TAX_GRACE_PERIOD = 3 -- сколько можно не оплачивать налог (в неделях)

Config.businessType = {
	{
		name = 'Магазин 24/7',
	},
	{
		name = 'Магазин одежды',
	},
	{
		name = 'АЗС',
	},
	{
		name = 'Закусочная',
	},
	{
		name = 'Автосервис',
	},
	{
		name = 'Автосалон',
	},
	{
		name = 'Амуниция',
	},
}

Config.upgrades = {}

function getConfigSetting(name)
	return Config[name]
end