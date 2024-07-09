Config = {}

-- Звания в соответствии с уровнем
Config.ranks = {
    ['Новичок'] = { minLvl = 1, maxLvl = 4 },
    ['Энтузиаст'] = { minLvl = 5, maxLvl = 9 },
    ['Любитель'] = { minLvl = 10, maxLvl = 14 },
    ['Экспедитор'] = { minLvl = 15, maxLvl = 19 },
    ['Опытный'] = { minLvl = 20, maxLvl = 25 },
    ['Профессионал'] = { minLvl = 25, maxLvl = 29 },
    ['Мастер'] = { minLvl = 30, maxLvl = 39 },
    ['Элита'] = { minLvl = 40, maxLvl = 49 },
    ['Король дорог'] = { minLvl = 50, maxLvl = 99 },
    ['Легенда'] = { minLvl = 100, maxLvl = 100 },
}

Config.levelsData = Utils.initializeLevels()