Config = {}

-- Типы грузовиков
Config.TRUCK_TYPE = {
    [1] = "Седельный тягач",
    [2] = "Грузовой-фургон",
    [3] = "Грузовой-пикап",
    [4] = "Грузовой-цистерна",
}

-- Конфигурация грузовиков
Config.TRUCK = {

    -- Грузовой пикап
    izh_2715 = { type = 3, loadCapacity = 400 },
    izh_2717 = { type = 3, loadCapacity = 575 },
    izh_oda_2717 = { type = 3, loadCapacity = 650 },
    
    -- Седельные тягачи
    freightliner_columbia = { type = 1 }, 
    kamaz_54901 = { type = 1 }, 
    volvo_fh460 = { type = 1 },

    -- Грузовой фургон
    gazel_3302 = { type = 2, loadCapacity = 1480 },
    raf_2203 = { type = 2, loadCapacity = 1100 },
    vw_transporter = { type = 2, loadCapacity = 1279 },
    mercedes_benz_sprinter = { type = 2, loadCapacity = 2600 },

    gaz_3307 = { type = 2, loadCapacity = 4500 },
    gazon_next = { type = 2, loadCapacity = 5000 },
    
    kamaz_54115 = { type = 2, loadCapacity = 16800 },
    iveco_stralis_500 = { type = 2, loadCapacity = 15700 },
    scania_r700 = { type = 2, loadCapacity = 16000 },
  
    -- Грузовой цистерна
    volvo_fh12 = { type = 4, loadCapacity = 21500 },
}