Database = {}
local dbConnection

VEHICLES_TABLE_NAME = "vehicle"

function Database.setup()
    dbConnection = exports.tmtaSQLite:dbGetConnection()

	if not isElement(dbConnection) then
		outputDebugString("WARNING: Database.connect: соединение не установлено")
		return false
	end

    exports.tmtaSQLite:dbTableCreate(VEHICLES_TABLE_NAME, {
        -- Номер поля
        { name = "vehicleId", type = "INTEGER", option = "PRIMARY KEY" },
    
        -- Аккаунт владельца
        { name = "account", type = "TEXT", option = "NOT NULL" },
    
        -- Дата выпуска
        { name = "date_issue", type = "TEXT" },
    
        -- ID модели
        { name = "model", type = "INTEGER" },
    
        -- Цена
        { name = "price", type = "INTEGER" },
    
        -- Пробег
        { name = "mileage", type = "INTEGER", option = "NOT NULL DEFAULT 0" },
    
        -- Топливо
        { name = "fuel", type = "INTEGER" },
    
        -- Состояние
        { name = "health", type = "INTEGER", option = "NOT NULL DEFAULT 1000" },
    
        -- Хэндлинг
        { name = "handlings", type = "BLOB" },
    
        -- Номерной знак (рамка, тип номера, регион, номер)
        { name = "number", type = "BLOB" },
    
        -- Цвет
        { name = "colors", type = "BLOB" },
    
        -- Тонеровка
        { name = "toner", type = "BLOB" },
    
        -- Тюнинг
        { name = "tuning", type = "BLOB" },
    
        -- Фары
        { name = "headlight", type = "BLOB" },
    
        -- Колеса
        { name = "wheels", type = "BLOB" },
    
        -- Сигнал
        { name = "horn", type = "BLOB" },
    })

    --dbExec(dbConnection, "ALTER TABLE  "..VEHICLES_TABLE_NAME.." ADD COLUMN price INTEGER")
end

function Database.getConnection()
    if not isElement(dbConnection) then
		outputDebugString("WARNING: Database.connect: соединение не установлено")
		return false
	end
    return dbConnection
end