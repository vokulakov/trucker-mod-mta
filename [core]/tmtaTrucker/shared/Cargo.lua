Cargo = {}
Cargo.list = {}


-- Крупные склады
local TEMPLATE_LARGE_WAREHOUSES = { 1, 2, 3 }
-- Средние склады
local TEMPLATE_MEDIUM_WAREHOUSES = { 4, 5, 6, 7, 8, 9, 10, 11 }
-- Мелкие склады
local TEMPLATE_SMALL_WAREHOUSES = { 12, 13, 14, 15, 16, 17 }


-- Грузовики
local TEMPLATE_TRUCK_DEFAULT = { 499, 573, 433 }
-- Пикапы
local TEMPLATE_TRUCK_PICKUP = { 605, 543, 528 }
-- Фургоны
local TEMPLATE_TRUCK_VAN = { 478, 609, 482 }
-- Рефрежираторы
local TEMPLTAE_TRUCK_REFRIGERATOR = { 544 }
-- Изотермический
local TEMPLTAE_TRUCK_ISOTHERMAL = { 414, 455 }
-- Цистерна
local TEMPLATE_TRUCK_TANK = { 578 }


-- Обычный
local TEMPLATE_TRAILER_DEFAULT = { 450 }
-- Цистерна
local TEMPLATE_TRAILER_TANK = { 584 }
-- Рефрежиратор
local TEMPLATE_TRAILER_REFRIGERATOR = { 591 }
-- Изотермический
local TEMPLATE_TRAILER_ISOTHERMAL = { 435 }

Cargo.list['Топливо'] = {
    order = {
        { name = 'Дизельное топливо', weight = 25000 },
        { name = 'Бензин (АИ-92)', weight = 21000 },
        { name = 'Бензин (АИ-95)', weight = 21000 },
        { name = 'Бензин (АИ-98)', weight = 18000 },
        { name = 'Бензин (АИ-100)', weight = 16000 },
    },
    truck = TEMPLATE_TRUCK_TANK,
    trailer = TEMPLATE_TRAILER_TANK,
    loadingPoint = { 'oilRefinery' },
    deliveryPoint = { 'gasStation' },
}

Cargo.list['Одежда'] = {
    order = {
        { name = 'Футболки', weight = 16500 },
        { name = 'Головные уборы', weight = 21000 },
        { name = 'Брюки', weight = 13000 },
        { name = 'Обувь', weight = 18000 },
        { name = 'Нижнее белье', weight = 16000 },
    },
    truck = TEMPLATE_TRUCK_VAN,
    trailer = TEMPLATE_TRAILER_DEFAULT,
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_MEDIUM_WAREHOUSES,
    deliveryPoint = { 'clothes' },
}

Cargo.list['Пиломатериалы'] = {
    order = {
        { name = 'Вагонка', weight = 25000 },
        { name = 'Двухкантный брус', weight = 21000 },
        { name = 'Брусок', weight = 21000 },
        { name = 'Доска', weight = 18000 },
    },
    truck = { 573, },
    trailer = TEMPLATE_TRAILER_DEFAULT,
    loadingPoint = { 'sawmill', },
    deliveryPoint = { 'build' },
}

Cargo.list['Канцтовары'] = {
    order = {
        { name = 'Ручки', weight = 16500 },
        { name = 'Бумага', weight = 21000 },
        { name = 'Карандаши', weight = 13000 },
		{ name = 'Фото-бумага', weight = 17000 },
		{ name = 'Ежедневники', weight = 12000 },
		{ name = 'Настенные календари', weight = 12500 },
    },
    truck = { 499, 573, 433, 605, 543, 528, 478, 609, 482, },
    trailer = TEMPLATE_TRAILER_DEFAULT,
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_MEDIUM_WAREHOUSES,
    deliveryPoint = { 'hospital', 'office', },
}

Cargo.list['Медикаменты'] = {
    order = {
        { name = "Жгут кровоостанавливающий", weight = 16500 },
        { name = "Уголь активированный", weight = 18500 },
        { name = "Перчатки медицинские нестерильные", weight = 13000 },
        { name = "Медицинские вакцины", weight = 16500 },
        { name = "Парацетомол", weight = 18500 },
        { name = "Перекись водорода", weight = 13000 },
        { name = "Бактерицидный лейкопластырь", weight = 16500 },
    },
    truck = { 478, 609, 482, 414, 455, },
    trailer = { 591, 435, },
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_SMALL_WAREHOUSES,
    deliveryPoint = { 'hospital', },
}

Cargo.list['Хозтовары'] = {
    order = {
        { name = 'Стиральный порошок', weight = 16500 },
        { name = 'Батарейки алкалиновые', weight = 13000 },
        { name = 'Хозяйственное мыло', weight = 13000 },
        { name = 'Ткань', weight = 16500 },
        { name = 'Хлорка', weight = 16500 },
        { name = 'Мусорные мешки', weight = 17400 },
        { name = 'Пищевая пленка', weight = 18000 },
        { name = 'Зубная паста', weight = 18000 },
        { name = 'Зубные щетки', weight = 13000 },
        { name = 'Туалетная бумага', weight = 14000 },
        { name = 'Пена для бритья', weight = 13000 },
    },
    truck = { 605, 543, 528, 478, 609, 482, 499, 573, 433, },
    trailer = TEMPLATE_TRAILER_DEFAULT,
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_LARGE_WAREHOUSES,
    deliveryPoint = { 'shop', },
}

Cargo.list['Электроника'] = {
    order = {
        { name = 'Наушники', weight = 18000 },
        { name = 'Телевизоры', weight = 18000 },
        { name = 'Смарт-часы', weight = 18000 },
        { name = 'Холодильное оборудование', weight = 18000 },
        { name = 'Фотоаппараты', weight = 18000 },
        { name = 'Стиральные машины', weight = 18000 },
        { name = 'Микроволновки', weight = 18000 },
        { name = 'Ноутбуки', weight = 18000 },
        { name = 'Мобильные телефоны', weight = 18000 },
        { name = 'Компьютерная периферия', weight = 18000 },
        { name = 'Пылесосы', weight = 18000 },
        { name = 'Игровые приставки', weight = 18000 },
        { name = 'Принтера', weight = 18000 },
    },
    truck = { 499, 573, 433, 478, 609, 482, },
    trailer = TEMPLATE_TRAILER_DEFAULT,
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_LARGE_WAREHOUSES,
}

Cargo.list['Полуфабрикаты'] = {
	order = {
		{ name = 'Котлеты', weight = 18000 },
		{ name = "Фарш из говядины", weight = 19000 },
        { name = "Шашлык из свинины", weight = 13000 },
        { name = "Шашлык в маринаде", weight = 14000 },
	},
	truck = TEMPLTAE_TRUCK_REFRIGERATOR,
	trailer = TEMPLATE_TRAILER_REFRIGERATOR,
	warehousePoint = TEMPLATE_MEDIUM_WAREHOUSES,
    loadingPoint = { 'port', },
	deliveryPoint = { 'shop', 'restaurant', },
}

Cargo.list["Молочная продукция"] = {
    order = {
        { name = "Козий сыр", weight = 15000 },
        { name = "Йогурт", weight = 19000 },
        { name = "Молоко", weight = 18000 },
        { name = "Сливки питьевые", weight = 14000 },
        { name = "Кефир обезжиренный", weight = 17000 },
        { name = "Ряженка", weight = 17000 },
        { name = "Напиток кисломолочный", weight = 17000 },
        { name = "Сметана", weight = 19000 },
        { name = "Творог", weight = 17000 },
        { name = "Масло сливочное", weight = 14000 },
    },
	truck = TEMPLTAE_TRUCK_REFRIGERATOR,
	trailer = TEMPLATE_TRAILER_REFRIGERATOR,
    loadingPoint = { 'farm', },
    warehousePoint = TEMPLATE_LARGE_WAREHOUSES,
    deliveryPoint = { 'shop', 'restaurant', },
}

Cargo.list["Рыба и морепродукты"] = {
    order = {
        { name = "Форель", weight = 15000 },
        { name = "Филе кальмара", weight = 19000 },
        { name = "Скумбрия", weight = 18000 },
        { name = "Икра горбуши", weight = 14000 },
        { name = "Фарш трески", weight = 17000 },
        { name = "Горбуша свежемороженая", weight = 17000 },
        { name = "Икра Щуки", weight = 17000 },
        { name = "Семга", weight = 19000 },
        { name = "Консервы трески", weight = 17000 },
        { name = "Минтай тушка", weight = 14000 },
    },
	truck = TEMPLTAE_TRUCK_REFRIGERATOR,
	trailer = TEMPLATE_TRAILER_REFRIGERATOR,
    loadingPoint = { 'port', },
    warehousePoint = TEMPLATE_MEDIUM_WAREHOUSES,
    deliveryPoint = { 'shop', 'restaurant', },
}

--[[
Cargo.list['Нефтепродукты'] = {
    order = {
        --{ name = 'Мазут', weight = 17000 },
        --{ name = 'Солидол', weight = 17000 },
        --{ name = 'Керосин', weight = 17000 },
        --{ name = 'Битум', weight = 19000 },
        --{ name = 'Гудрон', weight = 17000 },
        --{ name = 'Моторное масло', weight = 12000 },
        --{ name = 'Трансмиссионное масло', weight = 12000 },
        --{ name = 'Авиационное топливо', weight = 17000 },
    },
    truck = { 578, },
    trailer = { 584, },
}

Cargo.list['Мясная продукция'] = {
    order = {
        { name = "Бекон", weight = 16000 },
        { name = "Вареная колбаса 'Свиная'", weight = 16000 },
        { name = "Свинина тушеная", weight = 16000 },
        { name = "Вареная колбаса 'Молочная'", weight = 16000 },
        { name = "Грудинка 'Ароматная'", weight = 16000 },
        { name = "Рулет из грудинки свиной", weight = 16000 },
        { name = "Бекон варено-копченый", weight = 16000 },
    },
    truck = { 440, 605, 528, 543, 433, },
    trailer = { 435, 591, 450, },
    loadingPoint = { 'port', },
    warehousePoint = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, },
    deliveryPoint = { 'shop', },
}

Cargo.list['Химикаты'] = {
    order = {
        { name = 'Сульфат аммония', weight = 18000 },
        { name = 'Хлористый аммоний', weight = 18000 },
        { name = 'Натриевая селитра', weight = 18000 },
        { name = 'Аммиачная селитра', weight = 18000 },
        { name = 'Мочевина (карбамид)', weight = 18000 },
        { name = 'КАС (карбамид-аммиачная селитра)', weight = 18000 },
        { name = 'Калий хлористый', weight = 18000 },
        { name = 'Сульфат калия', weight = 18000 },
        { name = 'Калимаг (калийно-магниевый концентрат)', weight = 18000 },
        { name = 'Калийная селитра', weight = 18000 },
        { name = 'Аммофос', weight = 18000 },
    },
    truck = { 440, 605, 528, 543, 433, },
    trailer = { 435, 591, 450, },
    loadingPoint = { 'port', },
    warehousePoint = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, },
    deliveryPoint = { 'shop', },
}

Cargo.list['Продовольствие'] = {
    order = {
        { name = 'Пшеница (мешок 40 кг)', weight = 18000 },
        { name = 'Ячмень (мешок 50 кг)', weight = 18000 },
        { name = 'Лимонад Бавария Cola Edition', weight = 18000 },
        { name = 'Напиток EVERVESS COLA', weight = 18000 },
        { name = "Вода питьевая 'Святой источник'", weight = 18000 },
        { name = "Минеральная лечебно-столовая вода 'КАРМАДОН'", weight = 18000 },
        { name = "Напиток 'Любимая кола'", weight = 18000 },
        { name = "Минеральная вода 'ТБАУ'", weight = 18000 },
        { name = "Кофе раств. NESCAFE 3в1", weight = 18000 },
        { name = "Кофе молотый JACOBS MONARCH classic", weight = 18000 },
        { name = "Чай черный АЗЕРЧАЙ с ароматом бергамота", weight = 18000 },
    },
    truck = { 440, 605, 528, 543, 433, },
    trailer = { 435, 591, 450, },
    loadingPoint = { 'port', },
    warehousePoint = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, },
    deliveryPoint = { 'shop', },
}
]]

function getCargoList()
    return Cargo.list
end