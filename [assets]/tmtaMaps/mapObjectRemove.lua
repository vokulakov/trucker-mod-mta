local objectRemove = {
    [900] = true,
    [901] = true,
    [915] = true,
    [916] = true,
    [917] = true,
    [918] = true,
    [919] = true,
    [920] = true,
    [921] = true,

    [7696] = true,

    [1210] = true,
	
	[1872] = true,
	[1000] = true,
	[1001] = true,
	[1002] = true,
	[1003] = true,
	[1014] = true,
	[1015] = true,
}

addEventHandler('onResourceStart', resourceRoot,
    function()
        for model in pairs(objectRemove) do
            removeWorldModel(model, 10000, 0, 0, 0)
        end
    end
)

addEventHandler('onResourceStop', resourceRoot,
    function()
        for model in pairs(objectRemove) do
            restoreWorldModel(model, 10000, 0, 0, 0)
        end
    end
)