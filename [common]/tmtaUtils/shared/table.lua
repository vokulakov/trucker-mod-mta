loadstring(exports['tmtaModule']:include('TableHelper'))()

function tableCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function extendTable(table1, table2)
    if type(table1) ~= "table" or type(table2) ~= "table" then
        return false
    end
    for k, v in pairs(table2) do
        if table1[k] == nil then
            table1[k] = v
        end
    end
    return table1
end

function tableMerge(table1, table2, overwrite)
    if type(table1) ~= "table" or type(table2) ~= "table" then
        return false
    end
    if (not overwrite or overwrite == nil) then
        for k, v in ipairs(table2) do
            table.insert(table1, v)
        end 
    else
        return extendTable(table1, table2)
    end

    return table1
end

--- Перевернуть таблицу (поменять местами ключ со значением)
function tableReverse(t)
	local newt = {}
	for idx, item in ipairs(t) do
		newt[#t - idx + 1] = item
	end
	return newt
end

--- Перевернуть таблицу (сортировка в обратном порядке)
function tableReverseOrder(tab)
    for i = 1, #tab/2, 1 do
        tab[i], tab[#tab-i+1] = tab[#tab-i+1], tab[i]
    end
    return tab
end