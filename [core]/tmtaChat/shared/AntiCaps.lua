AntiCaps = {}

local board = {
    ['й'] = 'q',    ['Й'] = 'Q', 
    ['ц'] = 'w',    ['Ц'] = 'W',
    ['у'] = 'e',    ['У'] = 'E',
    ['к'] = 'r',    ['К'] = 'R',
    ['е'] = 't',    ['Е'] = 'T',
    ['н'] = 'y',    ['Н'] = 'Y',
    ['г'] = 'u',    ['Г'] = 'U',
    ['ш'] = 'i',    ['Ш'] = 'I',
    ['щ'] = 'o',    ['Щ'] = 'O',
    ['з'] = 'p',    ['З'] = 'P',
    ['ф'] = 'a',    ['Ф'] = 'A',
    ['ы'] = 's',    ['Ы'] = 'S',
    ['в'] = 'd',    ['В'] = 'D',
    ['а'] = 'f',    ['А'] = 'F',
    ['п'] = 'g',    ['П'] = 'G',
    ['р'] = 'h',    ['Р'] = 'H',
    ['о'] = 'j',    ['О'] = 'J',
    ['л'] = 'k',    ['Л'] = 'K',
    ['д'] = 'l',    ['Д'] = 'L',
    ['ж'] = ';',    ['Ж'] = ';',
    ['э'] = '\'',   ['Э'] = '\'',
    ['я'] = 'z',    ['Я'] = 'Z',
    ['ч'] = 'x',    ['Ч'] = 'X',
    ['с'] = 'c',    ['С'] = 'C',
    ['м'] = 'v',    ['М'] = 'V',
    ['и'] = 'b',    ['И'] = 'B',
    ['т'] = 'n',    ['Т'] = 'N',
    ['ь'] = 'm',    ['Ь'] = 'M',
    ['ё'] = '`',    ['Ё'] = '`',
}

function AntiCaps.onMessage(message) 
    if type(message) ~= "string" then 
		return
	end

    if (not pregFind(message, "[a-z]") and pregFind(message, "[A-Z]")) then
		return true
	end

    if message:len() < 5 then -- это костыль для кириллицы
        return
    end
    
    local temp = ''
    for i = 1, utf8.len(message) do
        local char = board[utf8.sub(message, i, i)]
        if char then
            temp = tostring(temp)..''..tostring(char)
        end
    end

    if (not pregFind(temp, "[a-z]") and pregFind(temp, "[A-Z]")) then
		return true
	end

    return false
end 

--TODO:: сделать аналог функции lower()