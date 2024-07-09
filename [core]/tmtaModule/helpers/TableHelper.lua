-- @table.helpers

--- Применяет обратный вызов к элементам указанной таблицы
function table.map(table, callback)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = callback(v)
    end
    return t
end

--@link https://wiki.multitheftauto.com/wiki/RU/PairsByKeys
function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function()   -- iterator function
		i = i + 1
	  	if a[i] == nil then 
			return nil
	  	else 
			return a[i], t[a[i]]
	  	end
	end
	return iter
end