local criticalUnloadTime = 60000
local alwaysInMemoryCount = 0

local _replacedModelDFF = {}
local _replacedModelTXD = {}
local _replacedModelStats = {}

local replaceQueue = {}		-- очередь моделей на замену
local replacedModels = {}	-- замененные модели
local notNeededModels = {}	-- модели, которые больше не нужны

local loadedVehiclesCount = {}

local vehicleIsReplacing = nil

local function onVehicleStreamIn(vehicle)
    if not isElement(vehicle) then
        return
    end

    local model = getElementModel(vehicle)
    if (vehicleIsReplacing == model) then
        vehicleIsReplacing = false
        return
    end

    loadedVehiclesCount[model] = (loadedVehiclesCount[model] or 0) + 1
    addToReplaceQueue(vehicle, model)
end

local function onVehicleStreamOut(vehicle, model)
    model = model or getElementModel(vehicle)
    if (vehicleIsReplacing == model) then
        return
    end

    loadedVehiclesCount[model] = (loadedVehiclesCount[model] or 0) - 1
    if (loadedVehiclesCount[model] >= 1) then
        return
    end

    loadedVehiclesCount[model] = nil
    addToRestoreQueue(model)
end

--- Добавить в очередь на замену
function addToReplaceQueue(vehicle, model)
    if (not replaceQueue[model] and not replacedModels[model]) then
		replaceQueue[model] = true
	end

	if not replacedModels[model] then
		setElementAlpha(vehicle, 0)
	end

	notNeededModels[model] = nil
end

function onVehicleReplaced(model)
	replaceQueue[model] = nil
	replacedModels[model] = true

	for _, vehicle in ipairs(getElementsByType('vehicle', root)) do
		if (getElementModel(vehicle) == model) then
			setElementAlpha(vehicle, 255)
		end
	end
end

function addToRestoreQueue(model)
	replaceQueue[model] = nil
	if (replacedModels[model]) then
		notNeededModels[model] = getTickCount()
	end
end

--- Проверить находится ли модель в очереди на замену
function isModelInReplaceQueue(model)
	return replaceQueue[model]
end

addEventHandler('onClientPreRender', root,
    function()
        local criticalTime = getTickCount()-criticalUnloadTime
        local minimumTime = getTickCount()
    
        local modelToRestore
        for model, state in pairs(replaceQueue) do
            if (state == true) then
                replaceQueue[model] = "waiting"
                replaceModel(model)
                break
            end
        end
    
        for model, lastUseTime in pairs(notNeededModels) do
            if (lastUseTime < criticalTime) and (lastUseTime < minimumTime) then
                modelToRestore = model
                minimumTime = lastUseTime
            end
        end
    
        if (modelToRestore) and (count(replacedModels) > alwaysInMemoryCount) then
            restoreModel(modelToRestore)
            replacedModels[modelToRestore] = nil
            notNeededModels[modelToRestore] = nil
        end
    end
)

local function replaceModelDFF(model)
    if not isModelInReplaceQueue(model) then
        return
    end

    _replacedModelStats[model].dffReplace = getTickCount()

    
    local dffFile = _replacedModelDFF[model]
    if isElement(dffFile) then
        engineReplaceModel(dffFile, model)
    end

    _replacedModelStats[model].dffReplace = getTickCount() - _replacedModelStats[model].dffReplace

    onVehicleReplaced(model)

    _replacedModelStats[model] = nil
    collectgarbage()
end

local function replaceModelLoadDFF(model, filePath)
    if not isModelInReplaceQueue(model) then
        return
    end

    _replacedModelStats[model].dffLoad = getTickCount()
    _replacedModelDFF[model] = engineLoadDFF(string.format('%s.dff', filePath), true)
    _replacedModelStats[model].dffLoad = getTickCount() - _replacedModelStats[model].dffLoad

    setTimer(replaceModelDFF, 50, 1, model)
end

local function replaceModelImportTXD(model, filePath)
    if not isModelInReplaceQueue(model) then
        return
    end

    _replacedModelStats[model].txdImport = getTickCount()

    local txdFile = _replacedModelTXD[model]
    if isElement(txdFile) then
        engineImportTXD(txdFile, model)
    end

    _replacedModelStats[model].txdImport = getTickCount() - _replacedModelStats[model].txdImport

    setTimer(replaceModelLoadDFF, 50, 1, model, filePath)
end

local function replaceModelLoadTXD(model, filePath)
    if not isModelInReplaceQueue(model) then
        return
    end

    vehicleIsReplacing = model

    if not _replacedModelStats[model] then
        _replacedModelStats[model] = {}
    end

    _replacedModelStats[model].txdLoad = getTickCount()
    _replacedModelTXD[model] = engineLoadTXD(string.format('%s.txd', filePath), true)
    _replacedModelStats[model].txdLoad = getTickCount() - _replacedModelStats[model].txdLoad

    setTimer(replaceModelImportTXD, 50, 1, model, filePath)
end

function replaceModel(model)
    local filePath = getFilePathByModel(model)
    if not filePath then
        onVehicleReplaced(model)
        return
    end

    return replaceModelLoadTXD(model, filePath)
end

function restoreModel(model)
    engineRestoreModel(model)

    local dff = _replacedModelDFF[model]
    if isElement(dff) then
        destroyElement(dff)
    end

    local txd = _replacedModelTXD[model]
    if isElement(txd) then
        destroyElement(txd)
    end

    _replacedModelDFF[model] = nil
    _replacedModelTXD[model] = nil
    
    collectgarbage()
end

addEventHandler('onClientElementStreamIn', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end

        onVehicleStreamIn(source)
    end
)

addEventHandler('onClientElementStreamOut', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end

        onVehicleStreamOut(source)
    end
)

addEventHandler('onClientElementDestroy', root, 
	function()
		if (getElementType(source) ~= 'vehicle') then
			return
		end

        if not isElementStreamedIn(source) then
            return
        end

        onVehicleStreamOut(source)
    end
)

addEventHandler('onClientResourceStart', resourceRoot,
    function()
        engineSetAsynchronousLoading(true, true)

        for _, vehicle in ipairs(getElementsByType('vehicle', root, true)) do
            onVehicleStreamIn(vehicle)
        end

        setTimer(
            function()
                for model, count in pairs(loadedVehiclesCount) do
                    if count then
                        for i = 1, count do
                            onVehicleStreamOut(nil, model)
                        end
                    end
                end
            
                loadedVehiclesCount = {}
                for _, vehicle in ipairs(getElementsByType('vehicle', root, true)) do
                    onVehicleStreamIn(vehicle)
                end
            end, 30 * 1000, 0)
    end
)
