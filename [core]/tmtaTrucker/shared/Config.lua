Config = {}

Config.DRIVER_REVENUE_PER_M         = 1.078      -- коэффицент дохода за М пути
Config.DRIVER_REVENUE_PER_WEIGHT    = 0.186      -- коэффицент дохода за КГ груза
Config.DRIVER_EXP_PER_M             = 0.005     -- коэффицент опыта за М пути
Config.DRIVER_EXP_PER_WEIGHT        = 0.000126  -- коэффицент опыта за КГ грузами

Config.RENT_TIME = 60 -- время аренды ТС в минутах
Config.ORDER_LIST_UPDATE_TIME = 60 -- время обновления списка заказов

Config.FORFEIT_PERCENT = 15 -- неустойка за отмену заказа (в %)

-- Список транспорта для аренды

--[[
Config.TRUCK_RENT = {
    { model = 'izh_2715', price = 200, level = 1 },
    { model = 'izh_2717', price = 450, level = 1 },
    { model = 'izh_oda_2717', price = 750, level = 1 },
    { model = 'raf_2203', price = 900, level = 1 },
    { model = 'vw_transporter', price = 1300, level = 1 },

    { model = 'gazel_3302', price = 2250, level = 2 },
    { model = 'mercedes_benz_sprinter', price = 4500, level = 2 },

    { model = 'gaz_3307', price = 2250, level = 3 },
    { model = 'gazon_next', price = 2250, level = 3 },

    { model = 'kamaz_54115', price = 9500, level = 4 },
    { model = 'iveco_stralis_500', price = 7000, level = 4 },
    { model = 'scania_r700', price = 9500, level = 4 },

    { model = 'volvo_fh12', price = 12500, level = 6 },

    { model = 'kamaz_54901', price = 13750, level = 7 },
    { model = 'freightliner_columbia', price = 15000, level = 8 },
    { model = 'volvo_fh460', price = 22750, level = 8 },
}
]]

Config.TRUCK_RENT = {
    { model = 'izh_2715', price = 200, level = 1 }, -- 605
    { model = 'izh_2717', price = 450, level = 1 }, -- 543
    { model = 'izh_oda_2717', price = 750, level = 1 }, -- 528
    { model = 'raf_2203', price = 900, level = 1 }, -- 478
    { model = 'vw_transporter', price = 1300, level = 1 }, -- 609

    { model = 'gazel_3302', price = 2250, level = 1 }, -- 414
    { model = 'mercedes_benz_sprinter', price = 4500, level = 1 }, -- 482

    { model = 'gaz_3307', price = 2250, level = 1 }, -- 455
    { model = 'gazon_next', price = 2250, level = 1 }, -- 499

    { model = 'kamaz_54115', price = 9500, level = 1 }, -- 573
    { model = 'iveco_stralis_500', price = 7000, level = 1 }, -- 544
    { model = 'scania_r700', price = 9500, level = 1 }, -- 433

    { model = 'volvo_fh12', price = 12500, level = 1 }, -- 578

    { model = 'kamaz_54901', price = 13750, level = 1 }, -- 515
    { model = 'freightliner_columbia', price = 15000, level = 1 }, -- 403
    { model = 'volvo_fh460', price = 22750, level = 1 }, -- 514
}
