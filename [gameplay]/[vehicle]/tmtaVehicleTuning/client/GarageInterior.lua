GarageInterior = {}
GarageInterior.objects = {}

local interiorObjects = {
    { 1000,  326.47165, 11.81649, 87.48909, 15000 },
    { 1001,  326.56406, 11.14147, 87.42269, 15000 },
    { 1002,  326.46460, 11.49005, 87.48589, 15000 },
	{ 1003,  326.43365, 16.21460, 87.42034, 15000 },
    { 1014,  332.41025, 11.31557, 85.92577, 15000 },
    { 1015,  325.81265, 11.80062, 86.53407, 15000 },
}

function GarageInterior.create()
    for _, objectData in pairs(interiorObjects) do
        local object = createObject(objectData[1], objectData[2], objectData[3], objectData[4] + 100)
        engineSetModelLODDistance(objectData[1], objectData[5])
        object.interior = Config.garageInterior
        object.dimension = 1871
        GarageInterior.objects[object] = object
    end
end

function GarageInterior.update(interior, dimension)
    for object in pairs(GarageInterior.objects) do
        object.interior = interior
        object.dimension = dimension
    end
end