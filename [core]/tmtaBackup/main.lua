local databasesToCopy = {
	{":tmtaSQLite/tmtaDatabase.db",	"tmtaDatabase.db"},
}

-- ===============     Бекап локальных БД     ===============
function collectDatabases()
	for _, db in ipairs(databasesToCopy) do
		fileCopy(db[1], db[2], true)
	end
	checkForDatabaseBackupNecessity()
end
addEventHandler("onResourceStart", resourceRoot, collectDatabases)
setTimer(collectDatabases, 600000, 0)

-- Триггерим бекап, только если прошло больше двух дней с предыдущего, либо если ресурс только что запущен
local resourceOnlyStarted = true
function checkForDatabaseBackupNecessity()
	if (resourceOnlyStarted) then
		resourceOnlyStarted = false
		copyDatabasesToBackup()
	else
		if (getDaysFromLastBackup() > 1) then
			copyDatabasesToBackup()
		end
	end
end

function getDaysFromLastBackup()
	local lastBackupDay = get("lastBackupDay") or 0
	local currentDay = getRealTime().yearday
	return math.abs(currentDay-lastBackupDay)
end

function copyDatabasesToBackup()
	local backupStart = getTickCount()
	local dateTimeString = dateTimeToString()
	local folderName = "Backup "..dateTimeString.."/"
	for _, db in ipairs(databasesToCopy) do
		fileCopy(db[2], folderName..db[2], true)
	end
	set("lastBackupDay", getRealTime().yearday)
	outputDebugString(string.format("[DBCOPY] Backup created. Folder name: %s, time elapsed: %i ms", folderName, getTickCount()-backupStart))
end
addCommandHandler("backupdb", copyDatabasesToBackup, true, false)

-- Конвертация времени в строку
function dateTimeToString(unixTime)
	unixTime = tonumber(unixTime)
	local tT = getRealTime(unixTime, true)
	tT.month = tT.month + 1
	tT.year = tT.year - 100
	return string.format("%02i-%02i-%02i %02i-%02i", tT.year, tT.month, tT.monthday, tT.hour, tT.minute)
end