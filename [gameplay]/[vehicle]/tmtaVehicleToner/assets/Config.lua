Config = {}

--TODO:: когда нибудь сделаем нормально
Config.tonerPrice = 15000 

function convertNumber(number)
	return tostring(exports.tmtaUtils:formatMoney(number))
end