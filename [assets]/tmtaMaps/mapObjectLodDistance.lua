local objectLODDistance = {
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
}

for model in pairs(objectLODDistance) do
    engineSetModelLODDistance(model, 800)
end