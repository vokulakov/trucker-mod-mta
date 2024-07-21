Config = {}

Config.fuelType = {
    ['92'] = {
        name = 'АИ-92',
        consumption = 0.01,
		maxSpeedAdd = 0,
    },
    ['95'] = {
        name = 'АИ-95',
        consumption = 0.01,
		maxSpeedAdd = 10,
    },
    ['98'] = {
        name = 'АИ-98',
        consumption = 0.01,
		maxSpeedAdd = 20,
    },
    ['100'] = {
        name = 'АИ-100',
        consumption = 0.01,
		maxSpeedAdd = 30,
    },
    ['diesel'] = {
        name = 'ДТ',
        consumption = 0.01,
		maxSpeedAdd = -10,
    },
    ['electro'] = {
        name = 'Электротопливо',
        consumption = 0.01,
		maxSpeedAdd = 0,
    },
}

function getFuelTypeConfig()
	return Config.fuelType
end