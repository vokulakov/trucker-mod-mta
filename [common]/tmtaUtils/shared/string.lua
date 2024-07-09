--http://lua-users.org/wiki/StringRecipes 
local _transliteration = {
    ['а'] = 'a',   ['б'] = 'b',   ['в'] = 'v',
    ['г'] = 'g',   ['д'] = 'd',   ['е'] = 'e',
    ['ё'] = 'e',   ['ж'] = 'zh',  ['з'] = 'z',
    ['и'] = 'i',   ['й'] = 'y',   ['к'] = 'k',
    ['л'] = 'l',   ['м'] = 'm',   ['н'] = 'n',
    ['о'] = 'o',   ['п'] = 'p',   ['р'] = 'r',
    ['с'] = 's',   ['т'] = 't',   ['у'] = 'u',
    ['ф'] = 'f',   ['х'] = 'h',   ['ц'] = 'c',
    ['ч'] = 'ch',  ['ш'] = 'sh',  ['щ'] = 'sch',
    ['ь'] = '\'',  ['ы'] = 'y',   ['ъ'] = '\'',
    ['э'] = 'e',   ['ю'] = 'yu',  ['я'] = 'ya',

    ['А'] = 'A',   ['Б'] = 'B',   ['В'] = 'V',
    ['Г'] = 'G',   ['Д'] = 'D',   ['Е'] = 'E',
    ['Ё'] = 'E',   ['Ж'] = 'Zh',  ['З'] = 'Z',
    ['И'] = 'I',   ['Й'] = 'Y',   ['К'] = 'K',
    ['Л'] = 'L',   ['М'] = 'M',   ['Н'] = 'N',
    ['О'] = 'O',   ['П'] = 'P',   ['Р'] = 'R',
    ['С'] = 'S',   ['Т'] = 'T',   ['У'] = 'U',
    ['Ф'] = 'F',   ['Х'] = 'H',   ['Ц'] = 'C',
    ['Ч'] = 'Ch',  ['Ш'] = 'Sh',  ['Щ'] = 'Sch',
    ['Ь'] = '\'',  ['Ы'] = 'Y',   ['Ъ'] = '\'',
    ['Э'] = 'E',   ['Ю'] = 'Yu',  ['Я'] = 'Ya',
}

--- Разбить строку на символы
-- @tparam string str
-- @treturn table
function strSplit(str)
    if (not str or type(str) ~= 'string') then
        outputDebugString('strSplit: bad arguments', 1)
        return false
    end

    local result = {}
    string.gsub(str, '%w', function(char)
        return table.insert(result, char)
    end)

    return result
end

--- Транслитерировать строку
-- @tparam string str
function strTransliterate(str)
    if (not str or type(str) ~= 'string') then
        outputDebugString('strTr: bad arguments', 1)
        return false
    end
end

--@link http://stackoverflow.com/a/2421746
function strCapitalize(str)
    return (str:gsub("^%l", string.upper))
end

function strGenerate(len)
    if tonumber(len) then
        math.randomseed ( getTickCount () )
        local str = ""
        for i = 1, len do
            str = str .. string.char ( math.random (65, 90 ) )
        end
        return str
    end
    return false
end

function strRemoveHex(string)
	return string.gsub(string, "#%x%x%x%x%x%x", "")
end

function isEmailAddress(str)
    if not str then return nil end
    return tostring(str):match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")
end