ModelReplacer = {}

local AMOUNT_MODS_PER_BATCH = 10 -- Amount of Mods per Batch
local TIME_MS_BETWEEN_BATCHES = 1000 -- Time Between Batches (ms)

local modelsReplaced = {}
local loaderCoroutine

local modsToLoad = {
	-- trailers
    [435] = 'trailers/435',
    [450] = 'trailers/450',
    [584] = 'trailers/584',
    [591] = 'trailers/591',

	-- trucks
    [605] = 'trucks/izh_2715',
    [543] = 'trucks/izh_2717',
    [528] = 'trucks/izh_oda_2717',

    [414] = 'trucks/gazel_3302',
    [478] = 'trucks/raf_2203',
    [455] = 'trucks/gaz_53',
    [499] = 'trucks/gazon_next',
    [609] = 'trucks/vw_transporter',
    [482] = 'trucks/mercedes_benz_sprinter',

    [544] = 'trucks/iveco_stralis_500',
    [578] = 'trucks/volvo_fh12',
    [433] = 'trucks/scania_r700',
    [573] = 'trucks/kamaz_54115',

    [403] = 'trucks/freightliner_columbia',
    [515] = 'trucks/kamaz_54901',
    [514] = 'trucks/volvo_fh_460',

	-- cars
    [412] = 'cars/alfa_romeo_giulia',
    [474] = 'cars/audi_q8rs',
    [565] = 'cars/audi_r8',
    [559] = 'cars/audi_rs5',
    [458] = 'cars/audi_rs6_avant_c8',
    [547] = 'cars/audi_s8',
    [535] = 'cars/bantley_continental_gt',
    [489] = 'cars/bentley_bentayga',
    [477] = 'cars/bmw_850_ci',
    [534] = 'cars/bmw_e30',
    [507] = 'cars/bmw_e34',
    [540] = 'cars/bmw_e38',
    [429] = 'cars/bmw_m3_e46',
    [529] = 'cars/bmw_m3_touring_g81',
    [602] = 'cars/bmw_m4_g82',
    [600] = 'cars/bmw_m5_e60',
    [419] = 'cars/bmw_m5_f10',
    [585] = 'cars/bmw_m5_f90',
    [410] = 'cars/bmw_m8_competition',
    [550] = 'cars/bmw_m760li',
    [566] = 'cars/bmw_x5_e53',
    [516] = 'cars/bmw_x5m_f85',
    [401] = 'cars/bmw_x6m',
    [415] = 'cars/bugatti_chiron',
    [502] = 'cars/bugatti_divo',
    [575] = 'cars/chevrolet_camaro_zl1',
    [542] = 'cars/dodge_challenger_srt',
    [500] = 'cars/dodge_ram_trx',
    [541] = 'cars/ferrari_488',
    [494] = 'cars/ferrari_sf90',
    [576] = 'cars/gaz_volga_24',
    [517] = 'cars/kia_k5',
    [436] = 'cars/kia_rio',
    [506] = 'cars/koenigsegg_gemera',
    [405] = 'cars/lada_priora_2170',
    [561] = 'cars/lada_vesta',
    [451] = 'cars/lamborghini_aventador_lp700',
    [418] = 'cars/lamborghini_urus',
    [558] = 'cars/lexus_isf',
    [422] = 'cars/mb_cls63_w218',
    [426] = 'cars/mb_e63_w212',
    [546] = 'cars/mb_e63s_w213',
    [551] = 'cars/mb_e63s_w223',
    [442] = 'cars/mb_gt63s',
    [409] = 'cars/mb_maybach_s650_x222',
    [439] = 'cars/mb_w124',
    [400] = 'cars/mb_g63_amg',
    [492] = 'cars/mb_w140',
    [411] = 'cars/mclaren_p1',
    [526] = 'cars/mitsubishi_lancer_x',
    [555] = 'cars/nissan_370z',
    [589] = 'cars/nissan_gtr_r34',
    [503] = 'cars/nissan_gtr_r35',
    [562] = 'cars/nissan_silvia_s15',
    [603] = 'cars/porsche_911_carrera_s',
    [402] = 'cars/porsche_panamera_turbo_s',
    [579] = 'cars/range_rover_sva',
    [466] = 'cars/rolls_royce_phantom',
    [508] = 'cars/rolls_royce_wraith',
    [536] = 'cars/skoda_octavia_vrs',
    [475] = 'cars/subaru_impreza_wrx',
    [420] = 'cars/toyota_camry_v70',
    [496] = 'cars/toyota_gt86',
    [421] = 'cars/toyota_lc_200',
    [491] = 'cars/toyota_mark2',
    [587] = 'cars/toyota_supra_a90',
    [527] = 'cars/vaz_2101',
    [467] = 'cars/vaz_2107',
    [567] = 'cars/vaz_2109',
    [533] = 'cars/vaz_2110',
    [545] = 'cars/volkswagen_golf_mk1',
    [549] = 'cars/volkswagen_passat_b3',
}

--- Загрузка файла с проверкой хэш-суммы
-- @tparam string filePath
-- @tparam function loaderFunc
-- @treturn userdata
local function loadFile(filePath, loaderFunc)
    if (type(filePath) == 'string' and type(loaderFunc) == 'function') then
        local fileHandle = fileOpen(filePath, true)
        if fileHandle then
            local fileContent = fileGetContents(fileHandle, true)
            fileClose(fileHandle)
            if fileContent then
                local element = loaderFunc(fileContent)
                return element
            end
        end
    end

    return nil
end

local function replaceModel(filePath, model)
	engineRestoreModel(model)

	local txd = loadFile(string.format('assets/%s.txd', filePath), engineLoadTXD)
	if not txd then
		return false
	end

	local dff = loadFile(string.format('assets/%s.dff', filePath), engineLoadDFF)
	if not txd then
		return false
	end

	engineImportTXD(txd, model)
	engineReplaceModel(dff, model)

	modelsReplaced[model] = filePath

	return true
end

local function onClientReplaceModelsHandler()
	if loaderCoroutine then
		if (coroutine.status(loaderCoroutine) == 'suspended') then
			local success, errorMsg = coroutine.resume(loaderCoroutine)
			if not success then
				removeEventHandler('onClientRender', root, onClientReplaceModelsHandler)
			end
    	elseif (coroutine.status(loaderCoroutine) == 'dead') then
        	removeEventHandler('onClientRender', root, onClientReplaceModelsHandler)
		end
    end
end

local function proccessBatch()
	local loadedCounter = 0
	for model, filePath in pairs(modsToLoad) do
		replaceModel(filePath, model)
		
		loadedCounter = loadedCounter + 1
		modsToLoad[model] = nil

        if (loadedCounter >= tonumber(AMOUNT_MODS_PER_BATCH)) then
            break
        end
	end

	engineRestreamWorld()
end

function ModelReplacer.start()
	loaderCoroutine = coroutine.create(
		function()
			while next(modsToLoad) do
				local startTick = getTickCount()
				processBatch()
		
				if next(modsToLoad) then
					repeat
						coroutine.yield()
					until (getTickCount() - startTick >= tonumber(TIME_MS_BETWEEN_BATCHES))
				end
			end
		end
	)

	addEventHandler("onClientRender", root, onClientReplaceModelsHandler)
end

function ModelReplacer.stop()
	for model in pairs(modelsReplaced) do
		engineRestoreModel(model)
		modelsReplaced[model] = nil
    end

	modelsReplaced = {}
	engineRestreamWorld()
end

addEventHandler('onClientResourceStart', resourceRoot, ModelReplacer.start, false)
addEventHandler('onClientResourceStop', resourceRoot, ModelReplacer.stop, false)