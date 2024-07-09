Config = {}

Config.TRAILER_TYPE = {
    [1] = 'Полуприцеп-цистерна',
    [2] = 'Полуприцеп рефрижератор',
    [3] = 'Полуприцеп изотермический',
    [4] = 'Контейнерное-шасси',
}

-- Конфигурация прицепов
--@link: https://ttm-centr.ru/vidy-i-tipy-gruzovyh-pritsepov/
Config.TRAILER = {

    [584] = { 
        type = 1, 
        loadCapacity = 27500,
        name = 'Schmitz Cargobull',
    },

    [591] = { 
        type = 2, 
        loadCapacity = 26000,
        name = '',
    },

    [435] = { 
        type = 3, 
        loadCapacity = 26000,
        name = '',
    },

    [450] = {
        type = 4, 
        loadCapacity = 26000,
        name = 'Schmitz Cargobull',
    },

}