Database = { }
local dbConnection

function Database.connect()
	if isElement(dbConnection) then
		outputDebugString("WARNING: Database.connect: соединение уже установлено")
		return false
	end

	dbConnection = Connection("sqlite", "tmtaDatabase.db")

	if not dbConnection then
		outputDebugString("ERROR: Database.connect: не удалось подключиться")
		root:setData("dbConnected", false)
		return false
	end

	root:setData("dbConnected", true)
	return true
end

--- Возвращает MTA-элемент подключения к БД
-- return element подключение 
function Database.getConnection()
	if not isElement(dbConnection) then
		dbConnection = nil
	end

	return dbConnection
end

--- Отключается от базы данных
-- return bool удалось ли отключиться от база данных
function Database.disconnect()
	if not isElement(dbConnection) then
		outputDebugString("WARNING: Database.disconnect: соединение не установлено")
		return false
	end

	dbConnection:destroy()
	dbConnection = nil
	
	return true
end

-- Exports
dbConnect = Database.connect
dbDisconnect = Database.disconnect
dbGetConnection = Database.getConnection