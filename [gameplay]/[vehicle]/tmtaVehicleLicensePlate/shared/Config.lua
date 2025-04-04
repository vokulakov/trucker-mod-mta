Config = {}

Config.DEBUG = false

Config.LICANSE_PLATE_TEXTURE_NAME = {'nomer'}

Config.DEFAULT_STORAGE_SIZE = 1 -- количество слотов в хранилище номеров по умолчанию
Config.MAX_STORAGE_SIZE = 10 -- максимальное количество слотов в хранилище номеров

Config.STORAGE_PERIOD = 30 -- сколько дней хранится номер в хранилище

Config.PRICE_PUT_IN_STORAGE = 8500 -- цена за перемещение номера в хранилище
Config.PRICE_SET_IN_VEHICLE = 6500 -- цена за установку номера с хранилища
Config.STARTING_PRICE_STORAGE_SLOT = 20000 -- начальная цена за слот

Config.LICENSE_PLATE_REGISTRATION_POINTS = {
	{
		blipPosition = Vector3(957.83, 1732.78, 9.72),
		markerPosition = {
			{ x = 984, y = 1743, z = 8.65 },
			{ x = 984, y = 1737, z = 8.65 },
			{ x = 984, y = 1731, z = 8.65 },
			{ x = 984, y = 1725, z = 8.65 },
		},
		markerColor = {255, 255, 255, 100},
	},
}

Config.LICENSE_PLATE_TYPE = {
    [0] = 'default',
	[1] = 'ru',
	[2] = 'ru_no_flag',
	[3] = 'ru_tr',
	[4] = 'ru_trailer',
	[5] = 'ru_federal',
	[6] = 'by',
	[7] = 'kz',
	[8] = 'az',
	[9] = 'ua',
	[10] = 'arm',
}

-- https://ru.wikipedia.org/wiki/%D0%95%D0%B2%D1%80%D0%BE%D0%BF%D0%B5%D0%B9%D1%81%D0%BA%D0%B8%D0%B5_%D1%80%D0%B5%D0%B3%D0%B8%D1%81%D1%82%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5_%D0%B7%D0%BD%D0%B0%D0%BA%D0%B8_%D1%82%D1%80%D0%B0%D0%BD%D1%81%D0%BF%D0%BE%D1%80%D1%82%D0%BD%D1%8B%D1%85_%D1%81%D1%80%D0%B5%D0%B4%D1%81%D1%82%D0%B2#:~:text=%D0%91%D0%BE%D0%BB%D1%8C%D1%88%D0%B8%D0%BD%D1%81%D1%82%D0%B2%D0%BE%20%D0%B5%D0%B2%D1%80%D0%BE%D0%BF%D0%B5%D0%B9%D1%81%D0%BA%D0%B8%D1%85%20%D1%81%D1%82%D1%80%D0%B0%D0%BD%20%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D1%83%D0%B5%D1%82%20%D1%81%D0%BB%D0%B5%D0%B4%D1%83%D1%8E%D1%89%D0%B8%D0%B5,520%C3%97120%20%D0%BC%D0%BC.
Config.LICENSE_PLATE_REGION = {
    -- Регионы Российской Федерации
    ['ru'] = {
        ['01'] = 'Республика Адыгея',
		['02'] = 'Республика Башкортостан', ['102'] = 'Республика Башкортостан', ['702'] = 'Республика Башкортостан',
		['03'] = 'Республика Бурятия', ['103'] = 'Республика Бурятия',
		['04'] = 'Республика Алтай (Горный Алтай)',
		['05'] = 'Республика Дагестан',
		['06'] = 'Республика Ингушетия',
		['07'] = 'Кабардино-Балкарская Республика',
		['08'] = 'Республика Калмыкия',
		['09'] = 'Республика Карачаево-Черкессия',
		['10'] = 'Республика Карелия',
		['11'] = 'Республика Коми',
		['12'] = 'Республика Марий Эл',
		['13'] = 'Республика Мордовия', ['113'] = 'Республика Мордовия',
		['14'] = 'Республика Саха (Якутия)',
		['15'] = 'Республика Северная Осетия — Алания',
		['16'] = 'Республика Татарстан', ['116'] = 'Республика Татарстан', ['716'] = 'Республика Татарстан',
		['17'] = 'Республика Тыва',
		['18'] = 'Удмуртская Республика',
		['19'] = 'Республика Хакасия',
		['21'] = 'Чувашская Республика', ['121'] = 'Чувашская Республика',
		['22'] = 'Алтайский край',
		['23'] = 'Краснодарский край', ['93'] = 'Краснодарский край', ['123'] = 'Краснодарский край', ['193'] = 'Краснодарский край',
		['24'] = 'Красноярский край',	['88'] = 'Красноярский край', ['124'] = 'Красноярский край',
		['25'] = 'Приморский край', ['125'] = 'Приморский край',
		['26'] = 'Ставропольский край', ['126'] = 'Ставропольский край',
		['27'] = 'Хабаровский край',
		['28'] = 'Амурская область',
		['29'] = 'Архангельская область',
		['30'] = 'Астраханская область',
		['31'] = 'Белгородская область',
		['32'] = 'Брянская область',
		['33'] = 'Владимирская область',
		['34'] = 'Волгоградская область', ['134'] = 'Волгоградская область',
		['35'] = 'Вологодская область', 
		['36'] = 'Воронежская область', ['136'] = 'Воронежская область',
		['37'] = 'Ивановская область',
		['38'] = 'Иркутская область', ['138'] = 'Иркутская область',
		['39'] = 'Калининградская область', ['91'] = 'Калининградская область',
		['40'] = 'Калужская область',
		['41'] = 'Камчатский край',
		['42'] = 'Кемеровская область', ['142'] = 'Кемеровская область',
		['43'] = 'Кировская область',
		['44'] = 'Костромская область',
		['45'] = 'Курганская область',
		['46'] = 'Курская область',
		['47'] = 'Ленинградская область', ['147'] = 'Ленинградская область',
		['48'] = 'Липецкая область',
		['49'] = 'Магаданская область',
		['50'] = 'Московская область', ['90'] = 'Московская область', ['150'] = 'Московская область', ['190'] = 'Московская область', ['750'] = 'Московская область', ['790'] = 'Московская область',
		['51'] = 'Мурманская область',
		['52'] = 'Нижегородская область', ['152'] = 'Нижегородская область',
		['53'] = 'Новгородская область',
		['54'] = 'Новосибирская область', ['154'] = 'Новосибирская область',
		['55'] = 'Омская область', ['155'] = 'Омская область',
		['56'] = 'Оренбургская область', ['156'] = 'Оренбургская область',
		['57'] = 'Орловская область',
		['58'] = 'Пензенская область',
		['59'] = 'Пермский край', ['159'] = 'Пермский край',
		['60'] = 'Псковская область',
		['61'] = 'Ростовская область', ['161'] = 'Ростовская область', ['761'] = 'Ростовская область',
		['62'] = 'Рязанская область',
		['63'] = 'Самарская область', ['163'] = 'Самарская область', ['763'] = 'Самарская область',
		['64'] = 'Саратовская область', ['164'] = 'Саратовская область',
		['65'] = 'Сахалинская область',
		['66'] = 'Свердловская область', ['96'] = 'Свердловская область', ['196'] = 'Свердловская область',
		['67'] = 'Смоленская область',
		['68'] = 'Тамбовская область',
		['69'] = 'Тверская область',
		['70'] = 'Томская область',
		['71'] = 'Тульская область',
		['72'] = 'Тюменская область',
		['73'] = 'Ульяновская область', ['173'] = 'Ульяновская область',
		['74'] = 'Челябинская область', ['174'] = 'Челябинская область',
		['75'] = 'Забайкальский край',
		['76'] = 'Ярославская область',
		['77'] = 'г. Москва', ['97'] = 'г. Москва', ['99'] = 'г. Москва', ['177'] = 'г. Москва', ['197'] = 'г. Москва', ['199'] = 'г. Москва', ['777'] = 'г. Москва',	['797'] = 'г. Москва', ['799'] = 'г. Москва',
		['78'] = 'г. Санкт-Петербург', ['98'] = 'г. Санкт-Петербург', ['178'] = 'г. Санкт-Петербург', ['198'] = 'г. Санкт-Петербург',
		['79'] = 'Еврейская автономная область',
		['82'] = 'Республика Крым',
		['83'] = 'Ненецкий автономный округ',
		['86'] = 'Ханты-Мансийский автономный округ — Югра', ['186'] = 'Ханты-Мансийский автономный округ — Югра',
		['87'] = 'Чукотский автономный округ',
		['89'] = 'Ямало-Ненецкий автономный округ',
		['92'] = 'г. Севастополь',
		['94'] = 'территории, находящиеся за пределами РФ (режимные объекты - Байконур, Антарктика)',
		['95'] = 'Чеченская республика',
   
        ['80'] = 'Забайкальский край / Донецкая Народная Республика (ДНР)',
        ['81'] = 'Пермский край / Луганская Народная Республика (ЛНР)',
        ['84'] = 'Красноярский край / Херсонская область', ['184'] = 'Херсонская область',
        ['85'] = 'Иркутская область / Запорожская область', ['185'] = 'Запорожская область',

        ['188'] = 'Харьковская область',
    },
	['by'] = {
		['0'] = 'Вооружённые Силы',
		['1'] = 'Брестская область',
		['2'] = 'Витебская область',
		['3'] = 'Гомельская область',
		['4'] = 'Гродненская область',
		['5'] = 'Минская область',
		['6'] = 'Могилёвская область',
		['7'] = 'г. Минск',
	},
	['kz'] = {
		['01'] = 'г. Астана',
		['02'] = 'г. Алма-Ата',
		['03'] = 'Акмолинская область',
		['04'] = 'Актюбинская область',
		['05'] = 'Алма-Атинская область',
		['06'] = 'Атырауская область',
		['07'] = 'Западно-Казахстанская область',
		['08'] = 'Жамбылская область',
		['09'] = 'Карагандинская область',
		['10'] = 'Костанайская область',
		['11'] = 'Кызылординская область',
		['12'] = 'Мангистауская область',
		['13'] = 'Туркестанская область',
		['14'] = 'Павлодарская область',
		['15'] = 'Северо-Казахстанская область',
		['16'] = 'Восточно-Казахстанская область',
		['17'] = 'г. Шымкент',
		['18'] = 'Абайская область',
		['19'] = 'Жетысуская область',
		['20'] = 'Улытауская область',
	},
	['az'] = {
		['99'] = '',
		['01'] = 'Апшеронский район',
		['02'] = 'Агдамский район',
		['03'] = 'Агдашский район',
		['04'] = 'Агджабединский район',
		['05'] = 'Акстафинский район',
		['06'] = 'Ахсуйский район',
		['07'] = 'Астаринский район',
		['08'] = 'Балакенский район',
		['09'] = 'Бардинский район',
		['10'] = 'Баку', ['77'] = 'Баку', ['90'] = 'Баку',
		['11'] = 'Бейлаганский район',
		['12'] = 'Билясуварский район',
		['14'] = 'Джебраильский район',
		['15'] = 'Джалилабадский район',
		['16'] = 'Дашкесанский район',
		['17'] = 'Шабранский район',
		['18'] = 'Ширван',
		['19'] = 'Физулинский район',
		['20'] = 'Гянджа',
		['21'] = 'Кедабекский район',
		['22'] = 'Геранбойский район',
		['23'] = 'Гёйчайский район',
		['24'] = 'Аджигабульский район',
		['25'] = 'Гёйгёльский район',
		['26'] = 'Ханкенди',
		['27'] = 'Хачмазский район',
		['28'] = 'Ходжавендский район',
		['29'] = 'Хызынский район',
		['30'] = 'Имишлинский район',
		['31'] = 'Исмаиллинский район',
		['32'] = 'Кельбаджарский район',
		['33'] = 'Кюрдамирский район',
		['34'] = 'Кахский район',
		['35'] = 'Казахский район',
		['36'] = 'Габалинский район',
		['37'] = 'Гобустанский район',
		['38'] = 'Гусарский район',
		['39'] = 'Кубатлинский район',
		['40'] = 'Губинский район',
		['41'] = 'Лачинский район',
		['42'] = 'Ленкорань',
		['43'] = 'Лерикский район',
		['44'] = 'Масаллинский район',
		['45'] = 'Мингечевир',
		['46'] = 'Нафталан',
		['47'] = 'Нефтечалинский район',
		['48'] = 'Огузский район',
		['49'] = 'Саатлинский район',
		['50'] = 'Сумгаит',
		['51'] = 'Самухский район',
		['52'] = 'Сальянский район',
		['53'] = 'Сиазаньский район',
		['54'] = 'Сабирабадский район',
		['55'] = 'Шекинский район',
		['56'] = 'Шемахинский район',
		['57'] = 'Шамкирский район',
		['58'] = 'Шушинский район',
		['59'] = 'Тертерский район',
		['60'] = 'Товузский район',
		['61'] = 'Уджарский район',
		['62'] = 'Закатальский район',
		['63'] = 'Зердабский район',
		['64'] = 'Зангеланский район',
		['65'] = 'Ярдымлинский район',
		['66'] = 'Евлах',
		['67'] = 'Бабекский район',
		['68'] = 'Шарурский район',
		['69'] = 'Ордубадский район',
		['70'] = 'Нахичевань', ['75'] = 'Нахичевань',
		['71'] = 'Шахбузский район',
		['72'] = 'Джульфинский район',
		['73'] = 'Садаракский район',
		['74'] = 'Кенгерлинский район',
		['85'] = 'Нахичеванская Автономная Республика',
	},
	['ua'] = {
		['AA'] = 'г. Киев',	['KA'] = 'г. Киев',	['TT'] = 'г. Киев',	['TA'] = 'г. Киев',
		['AB'] = 'Винницкая область', ['KB'] = 'Винницкая область',	['MM'] = 'Винницкая область', ['OK'] = 'Винницкая область',
		['AC'] = 'Волынская область', ['KC'] = 'Волынская область',	['CM'] = 'Волынская область', ['TC'] = 'Волынская область',
		['AE'] = 'Днепропетровская область', ['KE'] = 'Днепропетровская область', ['PP'] = 'Днепропетровская область', ['MI'] = 'Днепропетровская область',
		['AM'] = 'Житомирская область',	['KM'] = 'Житомирская область',	['TM'] = 'Житомирская область',	['MB'] = 'Житомирская область',
		['AO'] = 'Закарпатская область', ['KO'] = 'Закарпатская область', ['MT'] = 'Закарпатская область', ['MO'] = 'Закарпатская область',
		['AT'] = 'Ивано-Франковская область', ['KT'] = 'Ивано-Франковская область',	['TO'] = 'Ивано-Франковская область', ['XC'] = 'Ивано-Франковская область',
		['AI'] = 'Киевская область', ['KI'] = 'Киевская область', ['TI'] = 'Киевская область', ['ME'] = 'Киевская область',
		['BA'] = 'Кировоградская область', ['HA'] = 'Кировоградская область', ['XA'] = 'Кировоградская область', ['EA'] = 'Кировоградская область',
		['BC'] = 'Львовская область', ['HC'] = 'Львовская область',	['CC'] = 'Львовская область', ['EC'] = 'Львовская область',
		['BE'] = 'Николаевская область', ['HE'] = 'Николаевская область', ['XE'] = 'Николаевская область', ['XH'] = 'Николаевская область',
		['BH'] = 'Одесская область', ['HH'] = 'Одесская область', ['OO'] = 'Одесская область', ['EH'] = 'Одесская область',
		['BI'] = 'Полтавская область', ['HI'] = 'Полтавская область', ['XI'] = 'Полтавская область', ['EI'] = 'Полтавская область',
		['BK'] = 'Ровенская область', ['HK'] = 'Ровенская область', ['XK'] = 'Ровенская область', ['EK'] = 'Ровенская область',
		['BM'] = 'Сумская область', ['HM'] = 'Сумская область', ['XM'] = 'Сумская область', ['EM'] = 'Сумская область',
		['BO'] = 'Тернопольская область', ['HO'] = 'Тернопольская область', ['XO'] = 'Тернопольская область', ['EO'] = 'Тернопольская область',
		['AX'] = 'Харьковская область', ['KX'] = 'Харьковская область', ['XX'] = 'Харьковская область', ['EX'] = 'Харьковская область',
		['BX'] = 'Хмельницкая область', ['HX'] = 'Хмельницкая область', ['OX'] = 'Хмельницкая область', ['PX'] = 'Хмельницкая область',
		['CA'] = 'Черкасская область', ['IA'] = 'Черкасская область', ['OA'] = 'Черкасская область', ['PA'] = 'Черкасская область',
		['CB'] = 'Черниговская область', ['IB'] = 'Черниговская область', ['OB'] = 'Черниговская область', ['PB'] = 'Черниговская область',
		['CE'] = 'Черновицкая область', ['IE'] = 'Черновицкая область', ['OE'] = 'Черновицкая область', ['PE'] = 'Черновицкая область',
	},
	['arm'] = {
		['01'] = 'Ереван', ['02'] = 'Ереван', ['03'] = 'Ереван', ['04'] = 'Ереван', ['05'] = 'Ереван', ['06'] = 'Ереван',
		['07'] = 'Ереван', ['08'] = 'Ереван', ['09'] = 'Ереван', ['10'] = 'Ереван', ['11'] = 'Ереван', ['13'] = 'Ереван',
		['19'] = 'Ереван',
		['61'] = 'Ереван', ['62'] = 'Ереван', ['63'] = 'Ереван', ['64'] = 'Ереван', 
		['65'] = 'Ереван', ['66'] = 'Ереван', ['67'] = 'Ереван', ['68'] = 'Ереван',
		['12'] = 'Армавирская область', ['27'] = 'Армавирская область', ['28'] = 'Армавирская область', ['29'] = 'Армавирская область',
		['14'] = 'Ширакская область', ['45'] = 'Ширакская область', ['46'] = 'Ширакская область', 
		['47'] = 'Ширакская область', ['48'] = 'Ширакская область', ['49'] = 'Ширакская область',
		['25'] = 'Араратская область', ['26'] = 'Араратская область',
		['15'] = 'Арагацотнская область', 
		['21'] = 'Арагацотнская область', ['22'] = 'Арагацотнская область',
		['23'] = 'Арагацотнская область', ['24'] = 'Арагацотнская область',
		['16'] = 'Гегаркуникская область', 
		['31'] = 'Гегаркуникская область', ['32'] = 'Гегаркуникская область', ['33'] = 'Гегаркуникская область',
		['34'] = 'Гегаркуникская область', ['35'] = 'Гегаркуникская область',
		['17'] = 'Котайкская область', ['42'] = 'Котайкская область', ['43'] = 'Котайкская область',
		['18'] = 'Вайоцдзорская область', ['56'] = 'Вайоцдзорская область',
		['36'] = 'Лорийская область', ['37'] = 'Лорийская область', ['38'] = 'Лорийская область', ['39'] = 'Лорийская область', ['41'] = 'Лорийская область',
		['51'] = 'Сюникская область', ['52'] = 'Сюникская область', ['53'] = 'Сюникская область', ['54'] = 'Сюникская область',
		['57'] = 'Тавушская область', ['58'] = 'Тавушская область', ['59'] = 'Тавушская область',

		['20'] = 'Нерегиональные номера', ['30'] = 'Нерегиональные номера', ['40'] = 'Нерегиональные номера', 
		['44'] = 'Нерегиональные номера', ['50'] = 'Нерегиональные номера', ['55'] = 'Нерегиональные номера', 
		['60'] = 'Нерегиональные номера', ['69'] = 'Нерегиональные номера', ['70'] = 'Нерегиональные номера', 
		['71'] = 'Нерегиональные номера', ['72'] = 'Нерегиональные номера', ['73'] = 'Нерегиональные номера',
		['74'] = 'Нерегиональные номера', ['75'] = 'Нерегиональные номера', ['76'] = 'Нерегиональные номера',
		['77'] = 'Нерегиональные номера', ['78'] = 'Нерегиональные номера', ['79'] = 'Нерегиональные номера',
		['80'] = 'Нерегиональные номера', ['81'] = 'Нерегиональные номера', ['82'] = 'Нерегиональные номера',
		['83'] = 'Нерегиональные номера', ['84'] = 'Нерегиональные номера', ['85'] = 'Нерегиональные номера',
		['86'] = 'Нерегиональные номера', ['87'] = 'Нерегиональные номера', ['88'] = 'Нерегиональные номера',
		['89'] = 'Нерегиональные номера', ['91'] = 'Нерегиональные номера', ['92'] = 'Нерегиональные номера',
		['93'] = 'Нерегиональные номера', ['94'] = 'Нерегиональные номера', ['95'] = 'Нерегиональные номера',
		['96'] = 'Нерегиональные номера', ['97'] = 'Нерегиональные номера', ['98'] = 'Нерегиональные номера',
		['99'] = 'Нерегиональные номера',

		['22'] = 'Нагорно-Карабахская Республика', ['90'] = 'Нагорно-Карабахская Республика',
	},
}

Config.LICENSE_PLATE = {
	['ru'] = {
		name = 'Русский',
		price = 5000,
		region = Config.LICENSE_PLATE_REGION['ru'],
		example = 'A001AA77',
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY](%d%d%d)[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d?)$",
			numberRegex = "(%d%d%d)",
			regionRegex = "(%d%d%d?)$",
			maxLength = 9,
		},
	},
	['ru_no_flag'] = {
		name = 'Русский (без флага)',
		price = 10000,
		region = Config.LICENSE_PLATE_REGION['ru'],
		example = 'A001AA77',
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY](%d%d%d)[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d?)$",
			numberRegex = "(%d%d%d)",
			regionRegex = "(%d%d%d?)$",
			maxLength = 9,
		},
	},
	['ru_federal'] = {
		name = 'Русский (федеральный)',
		price = 0,
		region = Config.LICENSE_PLATE_REGION['ru'],
		example = 'A001AA',
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY](%d%d%d)[ABCEHKMOPTXY][ABCEHKMOPTXY])$",
			numberRegex = "(%d%d%d)",
			maxLength = 6,
		},
	},
	['ru_tr'] = {
		name = 'Русский (транзитный)',
		price = 0,
		region = Config.LICENSE_PLATE_REGION['ru'],
		example = 'AA001A77',
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY][ABCEHKMOPTXY](%d%d%d)[ABCEHKMOPTXY])(%d%d%d?)$",
			numberRegex = "(%d%d%d)",
			regionRegex = "(%d%d%d?)$",
			maxLength = 9,
		},
	},
	['ru_trailer'] = {
		name = 'Русский (для прицепа)',
		price = 0,
		region = Config.LICENSE_PLATE_REGION['ru'],
		example = 'AA072277',
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d)(%d%d%d?)$",
			numberRegex = "(%d%d%d%d)",
			regionRegex = "(%d%d%d?)$",
			maxLength = 9,
		},
	},
	['by'] = {
		name = 'Белорусский',
		price = 3000,
		region = Config.LICENSE_PLATE_REGION['by'],
		example = '1234AB5',
		characters = 'A, B, E, I, K, M, H, O, P, C, T, X, 0-7',
		validate = {
			regex = "^(%d%d%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX])(%d)$",
			numberRegex = "^(%d%d%d%d)",
			regionRegex = "(%d)$",
			maxLength = 7,
		},
	},
	['kz'] = {
		name = 'Казахстанский',
		example = '111ААА01',
		price = 3000,
		region = Config.LICENSE_PLATE_REGION['kz'],
		characters = 'А, В, С, Е, Н, К, М, О, Р, Т, Х, У, 0-9',
		validate = {
			regex = "^(%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY][ABCEHKMOPTXY]?)(%d%d)$",
			numberRegex = "^(%d%d%d)",
			regionRegex = "(%d%d)$",
			maxLength = 8,
		},
	},
	['az'] = {
		name = 'Азербайджанский',
		example = '10AB777',
		price = 3000,
		region = Config.LICENSE_PLATE_REGION['az'],
		characters = 'A, B, E, I, K, M, H, O, P, C, T, X, 0-9',
		validate = {
			regex = "^(%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX])(%d%d%d)$",
			numberRegex = "(%d%d%d)$",
			regionRegex = "^(%d%d)",
			maxLength = 8,
		},
	},
	['arm'] = {
		name = 'Армянский',
		example = '10AB777',
		price = 3000,
		region = Config.LICENSE_PLATE_REGION['arm'],
		characters = 'A-Z, 0-9',
		validate = {
			regex = "^(%d%d)([ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ])(%d%d%d)$",
			numberRegex = "(%d%d%d)$",
			regionRegex = "^(%d%d)",
			maxLength = 7,
		},
	},
	['ua'] = {
		name = 'Украинский',
		example = 'AB1234CE',
		price = 3000,
		region = Config.LICENSE_PLATE_REGION['ua'],
		characters = 'A, B, E, I, K, M, H, O, P, C, T, X, 0-9',
		validate = {
			regex = "^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY])$",
			numberRegex = "(%d%d%d%d)",
			regionRegex = "^([ABCEHKMOPTXY][ABCEHKMOPTXY])",
			maxLength = 8,
		},
	},
}

--- Типы номеров доступные к установке (покупке)
Config.LICENSE_PLATE_TYPE_PUBLIC = { 
	'ru',
	'ru_no_flag',
	'by',
	'kz',
	'ua',
	'arm',
	'az',
}

--- Приватные номерные знаки (не выпадают рандомно)
Config.LICENSE_PLATE_PRIVATE = {
	['ru'] = {
		["^(A%d%d%dMP)(77)$"] = 290000, -- |A***MP|77|
		["^(A%d%d%dMP)(97)$"] = 240000, -- |A***MP|97|
		
		["^(E%d%d%dKX)(77)$"] = 290000, -- |E***KX|77|
		["^(E%d%d%dKX)(97)$"] = 290000, -- |E***KX|97|
		["^(E%d%d%dKX)(99)$"] = 290000, -- |E***KX|99|
		["^(E%d%d%dKX)(177)$"] = 290000, -- |E***KX|177|

		["^(X%d%d%dAM)(%d%d%d?)$"] = 35000, -- |X***AM|**|
		["^(B%d%d%dOP)(%d%d%d?)$"] = 50000, -- |B***OP|**|
		["^(A%d%d%dYE)(%d%d%d?)$"] = 50000, -- |A***YE|**|
		["^(A%d%d%dMP)(%d%d%d?)$"] = 75000, -- |A***MP|**|
		["^(E%d%d%dKX)(%d%d%d?)$"] = 200000, -- |E***KX|**|
	},
}

--- Уникальные номерные знаки (нельзя купить)
Config.LICENSE_PLATE_UNIQUE = {
	['ru'] = {
		["X777XX777"] = true,
		["A001AA01"] = true,
		["A001AA001"] = true,
	},
	['ua'] = {
		["^(AA)(%d%d%d%d)(BC)$"] = true,
		["^(AA)(%d%d%d%d)(KA)$"] = true,
		["^(AA)(%d%d%d%d)(KI)$"] = true,
		["^(AA)(%d%d%d%d)(KM)$"] = true,
		["^(AA)(%d%d%d%d)(KC)$"] = true,
		["^(AA)(%d%d%d%d)(BP)$"] = true,
		["^(II)(%d%d%d%d)(BC)$"] = true,
		["^(II)(%d%d%d%d)(KA)$"] = true,
		["^(II)(%d%d%d%d)(KI)$"] = true,
		["^(II)(%d%d%d%d)(KM)$"] = true,
		["^(II)(%d%d%d%d)(KC)$"] = true,
		["^(II)(%d%d%d%d)(BP)$"] = true,
	},
}