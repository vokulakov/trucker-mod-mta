--TODO:: http://lua-users.org/wiki/FormattingNumbers

---============================================================
-- Округление до ближайшей сотни
-- Например: 1 = 100, 311 = 400
function roundUpHundred(number)
    return tonumber(math.ceil(number/100)*100)
end

---============================================================
-- Округление до сотни
-- Например: 456 = 400, 599 = 500
function roundDownHundred(number)
    return tonumber(math.floor(number/100)*100)
end

---============================================================
-- add comma to separate thousands
--
function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
function round(val, decimal)
	if (decimal) then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
		return math.floor(val+0.5)
	end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
--
function format_num(amount, decimal, prefix, neg_prefix)
	local str_amount,  formatted, famount, remain

	decimal = decimal or 2  -- default 2 decimal places
	neg_prefix = neg_prefix or "-" -- default negative sign

	famount = math.abs(round(amount, decimal))
	famount = math.floor(famount)

	remain = round(math.abs(amount) - famount, decimal)

	-- comma to separate the thousands
	formatted = comma_value(famount)

	-- attach the decimal portion
	if (decimal > 0) then
		remain = string.sub(tostring(remain),3)
		formatted = formatted .. "." .. remain ..
								string.rep("0", decimal - string.len(remain))
	end

	-- attach prefix string e.g '$'
	formatted = (prefix or "") .. formatted

	-- if value is negative then format accordingly
	if (amount < 0) then
		if (neg_prefix=="()") then
			formatted = "(" .. formatted .. ")"
		else
			formatted = neg_prefix .. formatted
		end
	end

	return formatted
end

--
function isBetween(num, limit_1, limit_2)
    if num and limit_1 and limit_2 then
        return num >= limit_1 and num <= limit_2
    end
end

--
function lerp(a, b, k)
	local result = a * (1-k) + b * k
	if result >= b then
		result = b
	elseif result <= a then
		result = a
	end
	return result
end

function formatMoney(money)
	local left, num, right = string.match(money, '^([^%d]*%d)(%d*)(.-)')
	local formated = left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())
	return tostring(formated)
end

--===================================================================
--https://stackoverflow.com/questions/9461621/format-a-number-as-2-5k-if-a-thousand-or-more-otherwise-900
--https://reacthustle.com/blog/how-to-convert-number-to-kmb-format-in-javascript
--https://stackoverflow.com/questions/25110721/format-long-number-to-shorter-version-in-lua
--https://forum.multitheftauto.com/topic/103317-help-how-to-convert-money-number/

--Форматирование денег в короткое значение
function formatMoneyToShortValue(money)
	if type(money) ~= 'number' then
		return "?"
	end

	if money >= 1e6 and money < 1e9 then -- минимум = 1 M (1.000.000)
		local result = string.format("%.1f", money / 1e6)
		result = string.sub(result, 0, string.sub(result, -1) == "0" and -3 or -1) -- Remove .0 (just if it is zero!)
		return string.format("%s M", result)
	elseif money >= 1e9 then -- максимум = 999 M (999.999.999)
		return string.format("999 M")
	end

	return string.format("%s", formatMoney(money))
end