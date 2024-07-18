DatabaseTable = {}

local function retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
	if not isElement(connection) then
		outputDebugString("ERROR: retrieveQueryResults failed: no database connection")
		return false
	end
	if type(queryString) ~= "string" then
		error("queryString must be string")
	end

	-- Если не передали callback
	if not callbackFunctionName or callbackFunctionName:gsub(" ", "") == "" then
		-- Вернуть результат запроса синхронно
		local handle = connection:query(queryString)
		local result, errorCode, errorMessage = handle:poll(-1)
		if (not result) then
			outputDebugString(string.format("[ERROR] dbQuery error on %s", queryString), 1)
		end
		return result, errorCode, errorMessage
	else
		-- Если передали callback, вернуть результат асинхронно
		return not not connection:query(function(queryHandle, args)
			local result, errorCode, errorMessage = queryHandle:poll(0)
			if (not result) then
				outputDebugString(string.format("[ERROR] dbCallback error %i (%s)", errorCode, errorMessage), 1)
			end
			if type(args) ~= "table" then
				args = {}
			end
			triggerEvent("dbCallback", sourceResourceRoot, result, callbackFunctionName, args)
		end, {...}, queryString)
	end
end

--- Создание таблицы
function DatabaseTable.create(tableName, columns, options)
    if type(tableName) ~= "string" or type(columns) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.create: bad arguments")
		return false
	end
	if type(options) ~= "string" then
		options = ""
	else
		options = ", " .. options
	end
    
    local connection = Database.getConnection()
	if not isElement(connection) then
		outputDebugString("WARNING: Database.connect: no database connection")
		return false
	end

	local tblSchema = {}

	-- Автоматическое создание поля с id
	table.insert(tblSchema, {name = tableName..'Id', type = "INTEGER", options = "PRIMARY KEY NOT NULL"})

	tblSchema = exports.tmtaUtils:tableMerge(tblSchema, columns)

	-- Автоматическое создание полей createdAt, updatedAt
	table.insert(tblSchema, {name = "createdAt", type = "TIMESTAMP", options = "DEFAULT CURRENT_TIMESTAMP NOT NULL"})
	table.insert(tblSchema, {name = "updatedAt", type = "TIMESTAMP", options = "DEFAULT CURRENT_TIMESTAMP NOT NULL"})

    -- Строка запроса для каждого столбца таблицы
	local columnsQueries = {}
	for i, column in ipairs(tblSchema) do
		local columnQuery = connection:prepareString("`??` ??", column.name,  column.type)
		if column.size and tonumber(column.size) then
			columnQuery = columnQuery .. connection:prepareString("(??)", column.size)
		end
		if not column.options or type(column.options) ~= "string" then
			column.options = ""
		end
		if string.len(column.options) > 0 then
			columnQuery = columnQuery .. " " .. column.options
		end
        --outputDebugString(tostring(columnQuery))
		table.insert(columnsQueries, columnQuery)
	end

    
	local queryString = connection:prepareString(
		"CREATE TABLE IF NOT EXISTS `??` (" .. table.concat(columnsQueries, ", ") .. " " .. options .. ");",
		tableName
	)

	return connection:exec(queryString)
end

--- Вставка в таблицу
function DatabaseTable.insert(tableName, insertValues, callbackFunctionName, ...)
	if type(tableName) ~= "string" or type(insertValues) ~= "table" or not next(insertValues) then
		outputDebugString("ERROR: DatabaseTable.insert: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.insert: no database connection")
		return false
	end

	-- Автоматическое обновление временных меток
	insertValues.createdAt = getRealTime().timestamp
	insertValues.updatedAt = getRealTime().timestamp

	local columnsQueries = {}
	local valuesQueries = {}
	local valuesCount = 0
	for column, value in pairs(insertValues) do
		table.insert(columnsQueries, connection:prepareString("`??`", column))
		table.insert(valuesQueries, connection:prepareString("?", value))
		valuesCount = valuesCount + 1
	end
	if valuesCount == 0 then
		return retrieveQueryResults(connection, connection:prepareString("INSERT INTO `??`;", tableName), sourceResourceRoot, callbackFunctionName, ...)
	end
	local columnsQuery = connection:prepareString("(" .. table.concat(columnsQueries, ",") .. ")")
	local valuesQuery = connection:prepareString("(" .. table.concat(valuesQueries, ",") .. ")")
	local queryString = connection:prepareString(
		"INSERT INTO `??` " .. columnsQuery .. " VALUES " .. valuesQuery .. ";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

--- Обновление записей в таблице
function DatabaseTable.update(tableName, setFields, whereFields, callbackFunctionName, ...)
	if type(tableName) ~= "string" or type(setFields) ~= "table" or not next(setFields) or type(whereFields) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.update: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.update: no database connection")
		return false
	end

	-- Автоматическое обновление временной метки
	setFields.updatedAt = getRealTime().timestamp

	local setQueries = {}
	for column, value in pairs(setFields) do
		if value == "NULL" then
			table.insert(setQueries, connection:prepareString("`??`=NULL", column))
		else
			table.insert(setQueries, connection:prepareString("`??`=?", column, value))
		end
	end
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local queryString = connection:prepareString("UPDATE `??` SET " .. table.concat(setQueries, ", "), tableName)
	if #whereQueries > 0 then
		queryString = queryString .. connection:prepareString(" WHERE " .. table.concat(whereQueries, " AND "))
	end
	queryString = queryString .. ";"
	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

--- Получение записей из таблицы
function DatabaseTable.select(tableName, columns, whereFields, callbackFunctionName, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.select: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.select: no database connection")
		return false
	end

	-- WHERE
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueryString = ""
	if #whereQueries > 0 then
		whereQueryString = " WHERE " .. table.concat(whereQueries, " AND ")
	end

	-- COLUMNS
	-- SELECT *
	if not columns or type(columns) ~= "table" or #columns == 0 then
		return retrieveQueryResults(connection, connection:prepareString("SELECT * FROM `??` " .. whereQueryString ..";", tableName), sourceResourceRoot, callbackFunctionName, ...)
	end
	local selectColumns = {}
	for i, name in ipairs(columns) do
		table.insert(selectColumns, connection:prepareString("`??`", name))
	end

	-- SELECT COLUMNS
	local queryString = connection:prepareString(
		"SELECT " .. table.concat(selectColumns, ",") .." FROM `??` " .. whereQueryString ..";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

--- Удаление записей из таблицы
function DatabaseTable.delete(tableName, whereFields, callbackFunctionName, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.select: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.select: no database connection")
		return false
	end
	-- WHERE
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueryString = ""
	if #whereQueries > 0 then
		whereQueryString = " WHERE " .. table.concat(whereQueries, " AND ")
	end

	-- SELECT COLUMNS
	local queryString = connection:prepareString(
		"DELETE FROM `??` " .. whereQueryString ..";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

-- Проверяет существует ли таблица
function DatabaseTable.exists(tableName)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.exists: bad arguments")
		return false
	end	
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.exists: no database connection")
		return false
	end	
	local queryString = connection:prepareString([[SELECT count(*) 
		FROM information_schema.TABLES 
		WHERE (TABLE_SCHEMA = ?) AND (TABLE_NAME = ?)
	]], DatabaseConfig.dbName, tableName)

	local result = retrieveQueryResults(connection, queryString, sourceResourceRoot)
	-- Eto konechno strannovato, no tak nado
	if type(result) == "table" then
		result = result[1]
		if type(result) == "table" then
			local key = next(result)
			if key then
				result = result[key]
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
	if type(result) ~= "number" then
		return false
	end
	return result > 0
end

--- Изменение таблицы
function DatabaseTable.alter(tableName, options, callbackFunctionName, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.alter: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.alter: no database connection")
		return false
	end
	if type(options) ~= "string" then
		options = ""
	end

	local queryString = connection:prepareString(
		"ALTER TABLE `??` " .. options .. ";",
		tableName
	)

	local queryString = connection:prepareString([[SELECT count(*) 
		FROM information_schema.TABLES 
		WHERE (TABLE_SCHEMA = ?) AND (TABLE_NAME = ?)
	]], DatabaseConfig.dbName, tableName)

	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

-- Прямой запрос
function DatabaseTable.query(queryString, callbackFunctionName, ...)
	if type(queryString) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.query: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.query: no database connection")
		return false
	end

	local queryString = connection:prepareString(queryString)

	return retrieveQueryResults(connection, queryString, sourceResourceRoot, callbackFunctionName, ...)
end

-- Exports
dbTableCreate = DatabaseTable.create
dbTableSelect = DatabaseTable.select
dbTableInsert = DatabaseTable.insert
dbTableUpdate = DatabaseTable.update
dbTableDelete = DatabaseTable.delete
dbTableAlter  = DatabaseTable.alter

dbQuery = DatabaseTable.query